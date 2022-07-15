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
    clientSocketOut.write(t.getBytes());
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
    }
  }
}

void updateTeamsAndReadyStates(String m){
  scrolllist_team_select_team_1.removeAll();
  scrolllist_team_select_team_2.removeAll();
  team_1_ready.clear();
  team_2_ready.clear();
  int lastIndex = 11,currentIndex = 12;
  UIScrollList currentScrollList = scrolllist_team_select_team_1;
  ArrayList<Boolean> currentReadyList = team_1_ready;
  while(currentIndex!=m.length()){
    if(m.charAt(currentIndex) == '\0'){
      break;
    }
    if (m.charAt(currentIndex) == ','){
      currentScrollList.add(m.substring(lastIndex,currentIndex-1));
      currentReadyList.add(m.charAt(currentIndex-1) == 'V');
      if(m.substring(lastIndex,currentIndex-1).equals(playerName)){
        teamSelectReady = m.charAt(currentIndex-1) == 'V';
      }
      lastIndex = currentIndex +1;
      currentIndex++;
      if(m.charAt(currentIndex) == ','){
        currentScrollList = scrolllist_team_select_team_2;
        currentReadyList = team_2_ready;
        lastIndex++;
        currentIndex++;
      }
    }
    currentIndex++;
  }
  currentScrollList.add(m.substring(lastIndex,currentIndex-1));
  currentReadyList.add(m.charAt(currentIndex-1) == 'V');
  if(m.substring(lastIndex,currentIndex-1).equals(playerName)){
    teamSelectReady = m.charAt(currentIndex-1) == 'V';
  }
}