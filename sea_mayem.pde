import java.net.*;

int mapSize = 9; //Size in km
String currentScreen = "drawLoadingScreen";
String playerName = "name";
boolean teamSelectReady = false;

ArrayList<Boolean> team_1_ready = new ArrayList<Boolean>(), team_2_ready = new ArrayList<Boolean>();

Boat playerBoat = new Boat();

void setup(){
  //size(1000,1000);
  fullScreen();
  preprocess();
  initializeInputLib();
  initializeUILib();
  font_default = font_karma_suture_100;

  playerBoat.display.frontTurret = 1;
  playerBoat.display.middleTurret = 2;
  playerBoat.display.backTurret = 3;
  playerBoat.display.frontAntiTurret = 1;
  playerBoat.display.backAntiTurret = 2;
}


void draw(){
  if (currentScreen == "drawLoadingScreen"){
    drawLoadingScreen();
    currentScreen = "loading";
  }else if(currentScreen == "loading"){
    loadImages();
    loadFonts();
    loadUIElements();
    textbox_main_screen_ip.text = "localhost";
    textbox_main_screen_port.text = "4500";
    textbox_main_screen_name.text = "Bob";
    currentScreen = "main";
    textbox_main_screen_ip.visible = true;
    textbox_main_screen_port.visible = true;
    textbox_main_screen_name.visible = true;
  }else if(currentScreen == "main" || currentScreen == "main_connecting"){
    drawMainScreen();
    if(currentScreen == "main"){
      button_main_screen_connect.visible = true;
    }else if(currentScreen == "main_connecting"){
      button_main_screen_connect.visible = false;
      textAlign(CENTER);
      fill(0,255,255);
      textSize(button_main_screen_connect.fontSize);
      text("Conectando...", width/2,height*(1.0/2+4.0/15+1.0/15*5.0/6));
      currentScreen = "connecting";
    }
    if(button_main_screen_connect.clicked){
      if(textbox_main_screen_ip.text.length() == 0){
        new UIMessage("Por favor insira um IP!");
      }else if(textbox_main_screen_port.text.length() == 0){
        new UIMessage("Por favor insira uma porta!");
      }else if(textbox_main_screen_name.text.length() == 0){
        new UIMessage("Por favor insira um nome!");
      }else{
        currentScreen = "main_connecting";
        button_main_screen_connect.visible = false;
        playerName = textbox_main_screen_name.text;
      }
    }
  }else if(currentScreen == "connecting"){
    if(!connectToServer(textbox_main_screen_ip.text,textbox_main_screen_port.text)){
      new UIMessage("Falha na conexão!");
      currentScreen = "main";
    }else{
      sendServerRequest("(" + playerName + ")request_teams");
      resetVisibilities();
      currentScreen = "wait_connect_response";
    }
  }else if (currentScreen == "wait_connect_response"){
    if(scrolllist_team_select_team_2.elements.size() > 0 || scrolllist_team_select_team_1.elements.size() > 0){
      button_team_select_swap.visible = true;
      button_team_select_ready.visible = true;
      scrolllist_team_select_team_1.visible = true;
      scrolllist_team_select_team_2.visible = true;
      scrolllist_team_select_team_1.fontSize = height * 5.0/9/20;
      scrolllist_team_select_team_2.fontSize = height * 5.0/9/20;
      currentScreen = "team_select";
    }
  }else if(currentScreen == "team_select"){
    drawTeamSelectMenu();
    if(button_team_select_swap.clicked){
      sendServerRequest("(" + playerName + ")swap_teams");
    }
    if(button_team_select_ready.clicked && !teamSelectReady){
      sendServerRequest("(" + playerName + ")ready");
    }else if(button_team_select_ready.clicked && teamSelectReady){
      sendServerRequest("(" + playerName + ")unready");
    }
  }else if(currentScreen == "building_screen_loading"){
    scrolllist_team_select_team_1.visible = false;
    scrolllist_team_select_team_2.visible = false;
    button_team_select_ready.visible = false;
    button_team_select_swap.visible = false;
    progressbar_bulding_total_normal_points.visible = true;
    progressbar_bulding_total_special_points.visible = true;
    progressbar_building_guns_points.visible = true;
    progressbar_building_defence_points.visible = true;
    progressbar_building_navigation_points.visible = true;
    progressbar_building_engine_points.visible = true;
    scrolllist_buiding_team_list.visible = true;
    scrolllist_building_part_select.visible = true;
    textbox_building_boat_name.visible = true;
    button_building_steal_intel.visible = true;
    button_building_ready.visible = true;
    currentScreen = "building_screen";
  }else if(currentScreen == "building_screen"){
    drawBuildingMenu();
  }
  handleConnectivity();
  processUILib();
  if(currentScreen == "team_select" && teamSelectReady){
    drawGreenTick(width * 10.5/16,height*8.25/9,width*.5*16/15000);
  }
}



void preprocess(){
    font_karma_future_100 = loadFont("KarmaFuture-Regular-100.vlw");
    font_karma_suture_100 = loadFont("KarmaSuture-Regular-100.vlw");
}

void loadUIElements(){
  textbox_main_screen_ip = new UITextBox(width*5/12,height*(1.0/2+1.0/15+1.0/15*1.0/6),width/6, height*(1.0/15*4.0/6),"000.000.000.000");
  textbox_main_screen_port = new UITextBox(width*5/12,height*(1.0/2+2.0/15+1.0/15*1.0/6),width/6, height*(1.0/15*4.0/6),"00000");
  textbox_main_screen_name = new UITextBox(width*5/12,height*(1.0/2+3.0/15+1.0/15*1.0/6),width/6, height*(1.0/15*4.0/6),"player1");
  button_main_screen_connect = new UIButton(width/2-width/12,height*(1.0/2+4.0/15+1.0/15*1.0/6),width/6,height*(1.0/15*4.0/6),"Conectar");
  button_team_select_swap = new UIButton(width*5.5/16, height * 7.5/9, width*2/16.0,height*0.75/9,"Trocar");
  button_team_select_ready = new UIButton(width*8.5/16,height * 7.5/9, width*2/16.0,height*0.75/9,"Pronto");
  scrolllist_team_select_team_1 = new UIScrollList(width*2/16.0,height*2/9.0,width*5/16.0,height*5/9.0);
  scrolllist_team_select_team_2 = new UIScrollList(width*9/16.0,height*2/9.0,width*5/16.0,height*5/9.0);
  progressbar_bulding_total_normal_points = new UIProgressBar(width * 1.5/16, height * 1.25/9,width*3.0/16,height*0.25/9);
  progressbar_bulding_total_special_points = new UIProgressBar(width * 1.5/16, height * 1.25/9,width*3.0/16,height*0.25/9);
  progressbar_bulding_total_special_points.barColor = color(0,255,255);
  progressbar_building_guns_points = new UIProgressBar(width * 1.5/16, height * 2.25 / 9, width * 2.25/16, height * 0.25/9);
  progressbar_building_defence_points = new UIProgressBar(width * 1.5/16, height * 3.0 / 9, width * 2.25/16, height * 0.25/9);
  progressbar_building_navigation_points = new UIProgressBar(width * 1.5/16, height * 3.75 / 9, width * 2.25/16, height * 0.25/9);
  progressbar_building_engine_points = new UIProgressBar(width * 1.5/16, height * 4.5 / 9, width * 2.25/16, height * 0.25/9);
  scrolllist_buiding_team_list = new UIScrollList(width/16.0,height*5.5/9,width*3.5/16,height*2.5/9);
  scrolllist_building_part_select = new UIScrollList(width*11.5/16.0,height*0.75/9,width*3.5/16,height*3.25/9);
  textbox_building_boat_name = new UITextBox(width*6.0/16,height*0.5/9,width*4.0/16,height*0.75/9,"Nau Sao Gabriel");
  button_building_steal_intel = new UIButton(width*11.5/16,height*6.0/9,width*3.5/16,height*0.75/9,"Espiar");
  button_building_ready = new UIButton(width*11.5/16,height*7.25/9,width*3.5/16,height*0.75/9,"Pronto");
}


void resetVisibilities(){
  for(int i = 0; i< UIElementList.size();i++){
    UIElementList.get(i).visible = false;
  }
}

//IMAGES

PImage logo;
void loadImages(){
  logo = loadImage("logo.png");
}
PFont font_karma_future_100;
PFont font_karma_suture_100;
void loadFonts(){
}

void drawLoadingScreen(){
  background(0);
  textFont(font_karma_future_100);
  textSize(48);
  textAlign(CENTER);
  text("Carregando...",width/2,height/2 + (textAscent() + textDescent())/2 - textDescent());
}

UIButton button_main_screen_connect;
UITextBox textbox_main_screen_ip, textbox_main_screen_port, textbox_main_screen_name;
void drawMainScreen(){
  background(0);
  textAlign(CENTER);
  fill(0,255,255);
  textFont(font_karma_future_100);
  textSize(100);
  text("Batalha Naval", width/2,height/4+50- textDescent());
  textFont(font_karma_suture_100);
  textSize(40);
  fill(255);
  text("Conectar a um servidor:", width/2, height/2 + 20-textDescent());
  textSize(30);
}

UIScrollList scrolllist_team_select_team_1, scrolllist_team_select_team_2;
UIButton button_team_select_swap, button_team_select_ready;
void drawTeamSelectMenu(){
  background(0);
  textFont(font_karma_future_100);
  textAlign(CENTER);
  textSize(height*0.75/9);
  fill(0,255,255);
  text("Equipa 1",width*4.5/16,height*1.75/9-textDescent());
  text("Equipa 2",width*11.5/16,height*1.75/9-textDescent());
  textFont(font_karma_suture_100);
  textAlign(LEFT);
  UIButton b = button_team_select_ready;
  textSize(b.fontSize);
  fill(255);
  text(str(countReadyPlayers()) + "/" + str(team_1_ready.size() + team_2_ready.size()),b.position.x + b.dimensions.x *1.25,b.position.y+b.dimensions.y-b.margin-textDescent());
}


UIProgressBar progressbar_bulding_total_normal_points,progressbar_bulding_total_special_points,progressbar_building_guns_points,progressbar_building_defence_points,progressbar_building_navigation_points,progressbar_building_engine_points;
UIScrollList scrolllist_buiding_team_list, scrolllist_building_part_select;
UITextBox textbox_building_boat_name;
UIButton button_building_steal_intel, button_building_ready;

void drawBuildingMenu(){
  background(0);
  drawGunsIcon(width*1.125/16,height*2.375/9,width*0.25/16);
  drawDefenseIcon(width*1.125/16,height*3.125/9,width*0.25/16);
  drawNavigationIcon(width*1.125/16,height*3.875/9,width*0.25/16);
  drawEngineIcon(width*1.125/16,height*4.625/9,width*0.25/16);
  drawBoatDisplay();
}







void mousePressed(){
  processInputLibMousePress();
  processUILibMousePressed();
}
void mouseReleased(){
  processInputLibMouseRelease();
  processUILibMouseReleased();
}
void keyPressed(){
  processUILibKeyPressed();
  processInputLibKeyPressed();
}
void keyReleased(){
  processInputLibKeyReleased();
  //
}


int countReadyPlayers(){
  int c = 0;
  for(int i = 0; i < team_1_ready.size(); i++){
    if(team_1_ready.get(i).booleanValue()){
      c++;
    }
  }
  for(int i = 0; i < team_2_ready.size(); i++){
    if(team_2_ready.get(i).booleanValue()){
      c++;
    }
  }
  return c;
}


void drawBoatDisplay(){
  noFill();
  stroke(0,255,255);
  float nDim = 5.5*height/9/800; //Normalized dimensions to draw according to 800x800 format of boat outline and inline

  rect(5*width/16.0,1.5*height/9,6*width/16.0,6.5*height/9); // draw border of display

  pushMatrix();
  translate(8*width/16.0, 4.75*height/9); //Translate to center of boat
  drawBoatOutline(0,0,5.5*height/9,5); //Draw the outline of the boat
  drawBoatInnerLine(0, 0 , 5.5*height/9,3); //Draw the inner line of the boat

  float inlineStroke = 20;

  PVector mouseCoords = new PVector(mouseX - 8*width/16.0,mouseY - 4.75*height/9);
  pushMatrix();
  translate(0,-212.5*nDim); //Go to front turret position
  mouseCoords.y += 212.5*nDim;
  rotate(atan2(mouseCoords.y,mouseCoords.x) + PI/2);
  if(playerBoat.display.frontTurret == 0){
    circle(0,0,150*nDim/2.0);
  }else if(playerBoat.display.frontTurret == 1){
    drawCannonTurret(0,0,150*nDim/2.0,0,inlineStroke);
  }else if(playerBoat.display.frontTurret == 2){
    drawMissileTurret(0,0,150*nDim/2.0,inlineStroke);
  }else if(playerBoat.display.frontTurret == 3){
    drawTorpedoTurret(0,0,150*nDim/2.0,inlineStroke);
  }
  popMatrix();
  mouseCoords.y -= 212.5*nDim;

  pushMatrix();
  translate(0,-87.5*nDim); //Go to middle turret position
  mouseCoords.y += 87.5*nDim;
  rotate(atan2(mouseCoords.y,mouseCoords.x) + PI/2);
  if(playerBoat.display.middleTurret == 0){
    circle(0,0,150*nDim/2.0);
  }else if(playerBoat.display.middleTurret == 1){
    drawCannonTurret(0,0,150*nDim/2.0,0,inlineStroke);
  }else if(playerBoat.display.middleTurret == 2){
    drawMissileTurret(0,0,150*nDim/2.0,inlineStroke);
  }else if(playerBoat.display.middleTurret == 3){
    drawTorpedoTurret(0,0,150*nDim/2.0,inlineStroke);
  }
  popMatrix();
  mouseCoords.y -= 87.5*nDim;

  pushMatrix();
  translate(0,262.5*nDim); //Go to back turret position
  mouseCoords.y -= 262.5*nDim;
  rotate(atan2(mouseCoords.y,mouseCoords.x) + PI/2);
  if(playerBoat.display.backTurret == 0){
    circle(0,0,150*nDim/2.0);
  }else if(playerBoat.display.backTurret == 1){
    drawCannonTurret(0,0,150*nDim/2.0,0,inlineStroke);
  }else if(playerBoat.display.backTurret == 2){
    drawMissileTurret(0,0,150*nDim/2.0,inlineStroke);
  }else if(playerBoat.display.backTurret == 3){
    drawTorpedoTurret(0,0,150*nDim/2.0,inlineStroke);
  }
  popMatrix();
  mouseCoords.y += 262.5*nDim;

  pushMatrix();
  translate(0,-300*nDim); //Go to front anti turret position
  mouseCoords.y += 300*nDim;
  rotate(atan2(mouseCoords.y,mouseCoords.x) + PI/2);
  if(playerBoat.display.frontTurret == 0){
    circle(0,0,100*nDim/2.0);
  }else if(playerBoat.display.frontAntiTurret == 1){
    drawAntiCannonTurret(0,0,100*nDim/2.0,0,inlineStroke);
  }else if(playerBoat.display.frontAntiTurret == 2){
    drawAntiMissileTurret(0,0,100*nDim/2.0,inlineStroke);
  }else if(playerBoat.display.frontAntiTurret == 3){
    drawAntiTorpedoTurret(0,0,100*nDim/2.0,inlineStroke);
  }
  popMatrix();
  mouseCoords.y -= 300*nDim;

  pushMatrix();
  translate(0,150*nDim); //Go to back anti turret position
  mouseCoords.y -= 150*nDim;
  rotate(atan2(mouseCoords.y,mouseCoords.x) + PI/2);
  if(playerBoat.display.backTurret == 0){
    circle(0,0,100*nDim/2.0);
  }else if(playerBoat.display.backAntiTurret == 1){
    drawAntiCannonTurret(0,0,100*nDim/2.0,0,inlineStroke);
  }else if(playerBoat.display.backAntiTurret == 2){
    drawAntiMissileTurret(0,0,100*nDim/2.0,inlineStroke);
  }else if(playerBoat.display.backAntiTurret == 3){
    drawAntiTorpedoTurret(0,0,100*nDim/2.0,inlineStroke);
  }
  popMatrix();
  mouseCoords.y += 150*nDim;

  popMatrix();
}