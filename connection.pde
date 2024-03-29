import java.util.StringTokenizer;


Socket clientSocket = null;
OutputStream clientSocketOut = null;
InputStream clientSocketIn = null;



boolean connectToServer(String ip, String port){
  println("Attempting connection");
  try{
    clientSocket = new Socket(ip, int(port));
    clientSocketOut = clientSocket.getOutputStream();  
    clientSocketIn = clientSocket.getInputStream();  
  }catch (UnknownHostException e) {
    return false;
  }catch (IOException e) {
    return false;
  }
  println("Connection successfull");
  return true;
}

void sendServerRequest(String t){
  if (clientSocketOut == null){
    return;
  }
  println("Sending server request |" + t + "|");
  try{
    clientSocketOut.write(("(" + playerName + ")" + t + "|").getBytes());
  }catch(IOException e){
    handleSendServerRequestFailure();
  }
  try{
    clientSocketOut.flush();
  }catch(IOException e){
    handleSendServerRequestFailure();
  }
}

void handleSendServerRequestFailure(){
  println("Failed to send request to server");
}


String longMessage = "";
int longMessageCount = 0;

void handleConnectivity(){
  //If connection is not established ignore
  if(clientSocket == null){
    return;
  }
  //Check if there are bytes to be read
  int availableBytes = 0;
  try{
    availableBytes = clientSocketIn.available();
  }catch(IOException e){
    ;
  }
  //If there are, read
  if (availableBytes > 0){
    byte[] bm = new byte[1000];
    //Reads the bytes
    try{
      clientSocketIn.read(bm,0,999);
    }catch(IOException e){
      ;
    }
    String m = new String(bm);
    //Checks if received message is part of a long message
    if (m.indexOf("|") == -1){
      if (longMessageCount == 0){
        println("Receiving long message");
      }
      longMessage+= m;
      longMessageCount++;
      return;
    }
    int nullIndex = m.length()-1;
    while(m.charAt(nullIndex) == '\0'){
      nullIndex--;
    }
    boolean incompleteMessagePresent = false;
    if(m.charAt(nullIndex) != '|'){
      incompleteMessagePresent = true;
    }
    //divides message in parts with '|' as the delimiter
    StringTokenizer st = new StringTokenizer(m,"|");
    while(st.hasMoreTokens()){
      m = st.nextToken();
      if (m.charAt(0) == '\0'){
        continue;
      }
      if (!longMessage.equals("")){
        m = longMessage + m;
        //Eliminates '\0' in long messages
        for(int i = 0; i < m.length(); i++){
          if (m.charAt(i) == '\0'){
            println("Found null character!");
            m = m.substring(0,i) + m.substring(i+1,m.length());
          }
        }
        longMessage = "";
        println("Received long message with " + str(longMessageCount) + " fragments");
        longMessageCount = 0;
      }
      if (!st.hasMoreTokens() && incompleteMessagePresent){
        longMessage = m;
        break;
      }
      if(m.length() >= 11){
        if (m.substring(0,11).equals("login_info:")){
          int i1 = 11, i2 = 11;
          i2 = m.indexOf(",",i1);
          mapSize = int(m.substring(i1,i2));
          i1 = i2 + 1;
          i2 = m.indexOf(",",i1);
          MAX_NORMAL_POINTS = int(m.substring(i1,i2));
          i1 = i2 + 1;
          i2 = m.indexOf(",",i1);
          MAX_SPECIAL_POINTS = int(m.substring(i1,i2));
          i1 = i2 + 1;
          i2 = m.indexOf(",",i1);
          MAX_ATTACK_POINTS = int(m.substring(i1,i2));
          i1 = i2 + 1;
          i2 = m.indexOf(",",i1);
          MAX_DEFENSE_POINTS = int(m.substring(i1,i2));
          i1 = i2 + 1;
          i2 = m.indexOf(",",i1);
          MAX_NAVIGATION_POINTS = int(m.substring(i1,i2));
          MAX_ENGINE_POINTS = int(m.substring(i2+1,m.length()));
        }
      }
      if(m.length() >= 11){
        if (m.substring(0,11).equals("teams_info:")){
          println("Received teams info");
          updateTeamsAndReadyStates(m);
        }
      }
      if(m.length() >= 11){
        if (m.substring(0,14).equals("remove_player:")){
          boolean found = false;
          for (int i = 0; i < playerList.size(); i++){
            if (playerList.get(i).name.equals(m.substring(14,m.length()))){
              found = true;
              println("Removing player " + m.substring(14,m.length()));
              playerList.remove(i);
              updateTeamScrollLists();
              break;
            }
          }
          if (!found){
            println("ERROR Player to remove not found!");
          }
        }
      }
      if(m.length() >= 16){
        if (m.substring(0,16).equals("teams_unbalanced")){
          println("Teams are unbalanced!");
          new UIMessage("Teams are unbalanced!");
        }
      }
      if(m.length() >= 15){
        if (m.substring(0,15).equals("building_screen")){
          println("Switching to building screen");
          currentScreen = "building_screen_loading";
        }
      }
      if(m.length() >= 11){
        if (m.substring(0,11).equals("boats_info:")){
          println("Received boats info");
          updateBoats(m);
          updatePointBars();
        }
      }
      if(m.length() >= 17){
        if (m.substring(0,17).equals("not_enough_points")){
          println("Received not enough points");
          new UIMessage("You don't have enough remaining points!");
          if (selectedBuildingMenuPart == "Torre de Defesa Frontal"){
            scrolllist_building_part_select.selectedIndex = thisPlayer.boat.fat;
          }else if(selectedBuildingMenuPart == "Torre de Defesa Traseira"){
            scrolllist_building_part_select.selectedIndex = thisPlayer.boat.bat;
          }else if(selectedBuildingMenuPart == "Torre Frontal"){
            scrolllist_building_part_select.selectedIndex = thisPlayer.boat.ft;
          }else if(selectedBuildingMenuPart == "Torre Intermedia"){
            scrolllist_building_part_select.selectedIndex = thisPlayer.boat.mt;
          }else if(selectedBuildingMenuPart == "Torre Traseira"){
            scrolllist_building_part_select.selectedIndex = thisPlayer.boat.bt;
          }
        }
      }
      if(m.length() >= 12){
        if (m.substring(0,12).equals("points_info:")){
          int index1 = 12;
          int index2 = m.indexOf(':',index1);
          int np,sp;
          np = Integer.parseInt(String.valueOf(m.substring(index1,index2)));
          progressbar_bulding_total_normal_points.progress = float(np)/(MAX_NORMAL_POINTS + MAX_SPECIAL_POINTS);
          progressbar_bulding_total_special_points.position.x = width*1.5/16 + width*3.0/16*progressbar_bulding_total_normal_points.progress;
          index1 = index2 +1;
          index2 = m.length();
          sp = Integer.parseInt(String.valueOf(m.substring(index1,index2)));
          progressbar_bulding_total_special_points.progress = float(sp)/MAX_SPECIAL_POINTS;
          println("Received points info: " + str(np) + "np + " + str(sp) + "sp");
        }
      }
      if(m.length() >= 13){
        if(m.substring(0,13).equals("stolen_intel:")){
          print("Received stolen intel: " + m.substring(13,m.length()));
          if(m.substring(13,m.length()).equals("strong_attack")){
            float r = random(1);
            if (r < 0.5){
              new RadioMessageBalloon("The enemy is installing large caliber guns, watch out!",width, height-100, 4000);
            }else{
              new RadioMessageBalloon("I see heavy artillery being set up in the enemy's ships!", width, height-100,4000);
            }
          }else if(m.substring(13,m.length()).equals("strong_defense")){
            float r = random(1);
            if (r < 0.5){
              new RadioMessageBalloon("The enemy spent a fortune in advanced defense technology!",width, height-100, 4000);
            }else{
              new RadioMessageBalloon("I see powerfull defense turrets beign installed in the enemy's vessels!", width, height-100,4000);
            }
          }else if(m.substring(13,m.length()).equals("strong_navigation")){
            float r = random(1);
            if (r < 0.5){
              new RadioMessageBalloon("I had never seen such advanced antennas as in the enemy's battleships!",width, height-100, 4000);
            }else{
              new RadioMessageBalloon("The radars installed in some of the enemy's towers are worrying!", width, height-100,4000);
            }
          }else if(m.substring(13,m.length()).equals("strong_engine")){
            float r = random(1);
            if (r < 0.5){
              new RadioMessageBalloon("The noise of the enemy's engines is deafening, they must be really powerfull!",width, height-100, 4000);
            }else{
              new RadioMessageBalloon("I see huge negines being installed in the rear of some ships, watch out!", width, height-100,4000);
            }
          }else if(m.substring(13,m.length()).equals("no_intel")){
            float r = random(1);
            if (r < 0.33){
              new RadioMessageBalloon("The enemy is hiding its ships, i can't identify any relevant information...",width, height-100, 4000);
            }else if(r < 0.66){
              new RadioMessageBalloon("My binoculars are broken! The instruments the navy gives us are ever worse...", width, height-100,4000);
            }else{
              new RadioMessageBalloon("My instruments are tottaly wet! I can't see a thing!", width, height-100,4000);
            }
          }
        }
      }
      if (m.length() >= 19){
        if (m.equals("game_loading_screen")){
          println("Going into game loading screen");
          currentScreen = "game_loading_screen";
        }
      }
      if (m.length() >= 4){
        if (m.substring(0,4).equals("map:")){
          println("Saving map");
          map = createGraphics(mapSize*100,mapSize*100);
          map.beginDraw();
          map.loadPixels();
          int count = 0;
          for (int i = 0; i < mapSize * 100; i++){
            for (int j = 0; j < mapSize * 100; j++){
              String s = m.substring(4+(i*mapSize*100+j)*2,4+(i*mapSize*100+j)*2+2);
              int c = int(s);
              //DEBUG
              if (map == null){
                println("MAP IS NULL");
              }
              if (map.pixels == null){
                println("MAP PIXELS IS NULL");
              }
              if (c == -1){
                map.pixels[i*mapSize*100+j] = color(0,0,0,0);
              }else{
                map.pixels[i*mapSize*100+j] = color(int(255*(1-c/100.0)),255,255,255);
              }
            }
          }
          if (mapSize*100 < height-20 || mapSize * 100 < width/3.0-20){
            println("Map too small! Ressizing");
            int factor = 2;
            while(factor*mapSize*100 < height-20){
              factor *= 2;
            }
            while(factor*mapSize*100 < width/3.0-20){
              factor *= 2;
            }
            println("Ressizing with factor " +str(factor));
            PGraphics newMap = createGraphics(mapSize*100*factor,mapSize*100*factor);
            newMap.beginDraw();
            newMap.loadPixels();
            for (int i = 0; i < mapSize*100; i++){
              for (int j = 0; j < mapSize*100; j++){
                for (int k = 0; k < factor; k++){
                  for(int l = 0; l < factor; l++){
                    newMap.pixels[i*mapSize*100*factor*factor + j*factor + k*mapSize*100*factor+l] = map.pixels[i*mapSize*100+j];
                  }
                }
              }
            }
            map = newMap;
          }
          map.updatePixels();
          map.endDraw();
          println("Map saved!");

          //Other pregame loading
          mapLenght = width*2/3.0-20;
          if (mapLenght >height-20){
            mapLenght = height-20;
          }
          if(thisPlayer.boat.nav == -1){
            thisPlayer.boat.nav = 0;
          }
          radarDetectionGraphics = createGraphics(int(400*(1+thisPlayer.boat.nav)*mapLenght/(mapSize*1000)),int(400*(1+thisPlayer.boat.nav)*mapLenght/(mapSize*1000)));


          sendServerRequest("map_received");
          if (map == null){
            print("Map ended up being null!");
          }
        }
      }
      if (m.length() >= 10){
        if (m.substring(0,10).equals("start_game")){
          println("Starting game!");
          currentScreen = "map_screen";
        }
      }
      if (m.length() >= 10){
        if (m.substring(0,10).equals("game_info:")){
          updateGameInfo(m);
          sendServerRequest("send_game_info");
        }
      }
    }
  }
}

void updateTeamsAndReadyStates(String m){
  int lastIndex = 11,currentIndex = 12,team = 1;
  while(currentIndex!=m.length()){ //Loop through received message
    if(m.charAt(currentIndex) == '\0'){ //If end of message is reached break
      break;
    }
    if (m.charAt(currentIndex) == ','){ //check if a ',' is found, wich means the text before is a player
      String name = m.substring(lastIndex,currentIndex-2);  //names come in the format "BobX1" or "EddieV4", wich mean respectively player Bob is not ready and from team 1 and Eddie is ready and from team 4
      Player p = getPlayerByName(name);
      if (p == null){ //checks if the found player doesnt exist and creates it if so
        p = new Player(name);
      }
      p.ready = m.charAt(currentIndex-2) == 'V'; //set properties of player
      p.team = Integer.parseInt(String.valueOf(m.charAt(currentIndex-1)));
      lastIndex = currentIndex +1;
      currentIndex++;
    }
    currentIndex++;
  }
  Player p = getPlayerByName(m.substring(lastIndex,currentIndex-2));
  if (p == null){ //checks if the found player doesnt exist and creates it if so
    p = new Player(m.substring(lastIndex,currentIndex-2));
  }
  p.ready = m.charAt(currentIndex-2) == 'V'; //set properties of player
  p.team = Integer.parseInt(String.valueOf(m.charAt(currentIndex-1)));
  if (thisPlayer == null){
    thisPlayer = getPlayerByName(playerName);
  }
  updateTeamScrollLists();
}

void updateTeamScrollLists(){
  scrolllist_team_select_team_1.removeAll();
  scrolllist_team_select_team_2.removeAll();
  for (int i = 0; i< playerList.size();i++){
    if (playerList.get(i).team == 1){
      scrolllist_team_select_team_1.add(playerList.get(i).name);
    }else{
      scrolllist_team_select_team_2.add(playerList.get(i).name);
    }
  }
}

void updateBoats(String m){ //updates boats' displays
  int lastIndex = 11,i = 12;
  while(i < m.length()-1){
    i = m.indexOf(':',lastIndex);
    Player p = getPlayerByName(m.substring(lastIndex,i));
    if (p == null){
      println("ERROR received boat information for player that doesn't exist!");
      new Player(m.substring(lastIndex,i));
    }
    lastIndex = i+1;
    i = m.indexOf(",",lastIndex);
    p.boat.ft = int(m.substring(lastIndex,i));
    lastIndex = i+1;
    i = m.indexOf(",",lastIndex);
    p.boat.mt = int(m.substring(lastIndex,i));
    lastIndex = i+1;
    i = m.indexOf(",",lastIndex);
    p.boat.bt = int(m.substring(lastIndex,i));
    lastIndex = i+1;
    i = m.indexOf(",",lastIndex);
    p.boat.fat = int(m.substring(lastIndex,i));
    lastIndex = i+1;
    i = m.indexOf(",",lastIndex);
    p.boat.bat = int(m.substring(lastIndex,i));
    lastIndex = i+1;
    i = m.indexOf(",",lastIndex);
    p.boat.nav = int(m.substring(lastIndex,i));
    lastIndex = i+1;
    i = m.indexOf(";",lastIndex);
    p.boat.eng = int(m.substring(lastIndex,i));
    lastIndex = i+1;
  }
}


//update game informations, m is the string with the information sent by server
//Message example: game_info:boats:Bob,100,100,2.4,Mary,100,150,1.76;projectiles:100,20,110,32;
void updateGameInfo(String m){
  int i1 = 16, i2 = 16;
  int semicolonIndex = m.indexOf(';');
  while (true){
    i1 = m.indexOf(',',i2);
    Player p = getPlayerByName(m.substring(i2,i1));
    if (p == null){
      println("Boat of player " + m.substring(i2,i1) +  " not found!");
    }
    i2 = i1+1;
    i1 = m.indexOf(',',i2);
    p.boat.position.x = float(m.substring(i2,i1));
    i2 = i1 + 1;
    i1 = m.indexOf(',',i2);
    p.boat.position.y = float(m.substring(i2,i1));
    i2 = i1 + 1;
    i1 = m.indexOf(',',i2);
    if (i1 > semicolonIndex || i1 <0){
      p.boat.rotation = float(m.substring(i2,semicolonIndex));
      break;
    }else{
      p.boat.rotation = float(m.substring(i2,i1));
    }
    i2 = i1 +1;
  }
  i1 = semicolonIndex + 1; i2 = semicolonIndex +13; semicolonIndex = m.indexOf(';',i1);
  projectileList.clear();
  if (m.charAt(i2) != ';'){
    while (true){
      i1 = m.indexOf(',',i2);
      float x = float(m.substring(i2,i1));
      i2 = i1 + 1;
      i1 = m.indexOf(',',i2);
      float y = float(m.substring(i2,i1));
      i2 = i1 + 1;
      i1 = m.indexOf(',',i2);
      if (i1 <0){
        if(m.substring(i2,m.length()-1).equals(thisPlayer.name)){
          projectileList.add(new PVector(x,y,0));
        }else{
          projectileList.add(new PVector(x,y,getPlayerByName(m.substring(i2,m.length()-1)).team));
        }
        break;
      }else{
        if(m.substring(i2,i1).equals(thisPlayer.name)){
          projectileList.add(new PVector(x,y,0));
        }else{
          projectileList.add(new PVector(x,y,getPlayerByName(m.substring(i2,i1)).team));
        }
        i2=i1+1;
      }
    }
  }
}