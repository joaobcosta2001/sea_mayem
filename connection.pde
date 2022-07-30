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
    clientSocketOut.write(("(" + playerName + ")" + t).getBytes());
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
  if (availableBytes > 0){
    byte[] bm = new byte[1000];
    //Reads the bytes
    try{
      clientSocketIn.read(bm,0,999);
    }catch(IOException e){
      ;
    }
    String m = new String(bm);
    //Checks if received string has teams info
    StringTokenizer st = new StringTokenizer(m,"|");
    while(st.hasMoreTokens()){
      m = st.nextToken();
      if (m.charAt(0) == '\0'){
        continue;
      }
      //println("Received message: |" + m + "|");
      if(m.length() >= 11){
        if (m.substring(0,11).equals("teams_info:")){
          println("Received teams info");
          updateTeamsAndReadyStates(m);
        }
      }
      if(m.length() >= 16){
        if (m.substring(0,16).equals("teams_unbalanced")){
          println("Teams are unbalanced!");
          new UIMessage("As equipas estão desequilibradas!");
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
          new UIMessage("Já não tem pontos restantes!");
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
              new RadioMessageBalloon("O inimigo esta a prepara armas de grande calibre, cuidado!",width, height-100, 4000);
            }else{
              new RadioMessageBalloon("Vejo artilharia pesada a ser montada nos navios adversarios!", width, height-100,4000);
            }
          }else if(m.substring(13,m.length()).equals("strong_defense")){
            float r = random(1);
            if (r < 0.5){
              new RadioMessageBalloon("O inimgo gastou bastante dinheiro em tecnologia defensiva de ponta!",width, height-100, 4000);
            }else{
              new RadioMessageBalloon("Vejo potentes torres de defesa a serem instaladas nos navios inimigos!", width, height-100,4000);
            }
          }else if(m.substring(13,m.length()).equals("strong_navigation")){
            float r = random(1);
            if (r < 0.5){
              new RadioMessageBalloon("Nunca vi antenas tao sofisticadas como nos navios adversarios!",width, height-100, 4000);
            }else{
              new RadioMessageBalloon("Os radares instaldos nas torres de alguns navios inimigos sao preocupantes!", width, height-100,4000);
            }
          }else if(m.substring(13,m.length()).equals("strong_engine")){
            float r = random(1);
            if (r < 0.5){
              new RadioMessageBalloon("O barulho dos motores inimigos e ensurdecedor, devem ser de alta potencia!",width, height-100, 4000);
            }else{
              new RadioMessageBalloon("Vejo motores enorme a serem instalados na retaguarda de alguns navios, cuidado!", width, height-100,4000);
            }
          }else if(m.substring(13,m.length()).equals("no_intel")){
            float r = random(1);
            if (r < 0.33){
              new RadioMessageBalloon("O inimigo esta a esconder os barcos! Nao consigo avistar informacao relevante...",width, height-100, 4000);
            }else if(r < 0.66){
              new RadioMessageBalloon("Os meus binicolos nao funcionam! Que raio de instrumentos que a marinha nos da...", width, height-100,4000);
            }else{
              new RadioMessageBalloon("Os meus instrumentos de espionagem apanharam agua! Nao consigo ver nada!", width, height-100,4000);
            }
          }
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
    i = m.indexOf(";",lastIndex);
    p.boat.bat = int(m.substring(lastIndex,i));
    lastIndex = i+1;
  }
}