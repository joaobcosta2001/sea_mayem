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
          println("Received boats info: |" + m + "|");
          updateBoats(m);
        }
      }
    }
  }
}

void updateTeamsAndReadyStates(String m){
  println("Received players: |" + m + "|");
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
  print("Player teams: ");
  for (int i = 0; i< playerList.size();i++){
    print(str(playerList.get(i).team) + ",");
    if (playerList.get(i).team == 1){
      scrolllist_team_select_team_1.add(playerList.get(i).name);
    }else{
      scrolllist_team_select_team_2.add(playerList.get(i).name);
    }
  }
  println("");
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