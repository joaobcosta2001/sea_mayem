class Boat{
  PVector position;
  float rotation;
  int ft,mt,bt,fat,bat,nav,eng;
  Boat(){
    this.position = new PVector(0,0); //position of the boat in the map
    this.rotation = 0;  //angle of the boat
    this.ft = -1;  //type of front turret
    this.mt = -1;  //type of middle turret
    this.bt = -1;  //type of back turret
    this.fat = -1;  //type of front anti turret
    this.bat = -1;  //type of back anti turret
    this.nav = -1;  //type of navigation system
    this.eng = -1;  //type of engine
  }
  void drawIcon(){
    pushMatrix();
    translate(this.position.x,this.position.y);
    beginShape();
    vertex(0,-100);
    vertex(86.6,50);
    vertex(0,0);
    vertex(-86.6,50);
    endShape(CLOSE);
    popMatrix();
  }
}

class Player{
  String name;
  Boat boat;
  boolean ready;
  int team;
  Player(String n){
    playerList.add(this);
    this.name = n;
    this.boat = new Boat();
    this.ready = false;
  }
}

ArrayList<RadioMessageBalloon> radioMessageBalloonList = new ArrayList<RadioMessageBalloon>(); //contains all active RadioMessageBalloons

//RadioMessageBalloons are text balloons that appear to display a message as if it was received in the ships radio
class RadioMessageBalloon{
  String message;
  ArrayList<String> truncatedMessage;
  PVector dimensions;
  PVector position;
  float fontSize;
  PFont font;
  float maxWidth;
  float margin;
  color strokeColor, backgroundColor, textColor;
  float maxTime, transitionTime, startTime;
  //Constructor: give text to put in balloon (string m), position of the tip of the balloon (x and y) and time to be active in milliseconds (t, should be greater than 2x transitionTime)
  RadioMessageBalloon(String m,float x, float y, float t){
    println("Creating new radio message baloon");
    radioMessageBalloonList.add(this);
    this.message = m; //message to be displayed
    this.truncatedMessage = new ArrayList<String>(); //message to be displayed split into lines
    this.fontSize = 20;
    this.font = font_default;
    textFont(this.font);
    textSize(this.fontSize);
    this.position = new PVector(x,y);
    this.maxWidth = 400; //maximum width of the balloon
    this.margin = 20; //margins of the text inside the balloon, also controls the size of the tip of the balloon
    this.recalculateDimensions();
    this.strokeColor = color(0,255,255);
    this.backgroundColor = color(0);
    this.textColor = color(0,255,255);
    this.maxTime = t;
    this.transitionTime = 500; //time in milliseconds of the transitions
    this.startTime = millis();
  }

  //recalculates balloon dimensions and truncates the text acordingly
  void recalculateDimensions(){
    textFont(this.font);
    textSize(this.fontSize);
    this.truncatedMessage = new ArrayList<String>();
    String t = this.message,m = truncateWordsToWidth(t,this.maxWidth-2*this.margin);
    this.truncatedMessage.add(String.copyValueOf(m.toCharArray()));
    while(!m.equals(t)){
      t = t.substring(m.length(),t.length());
      if (t.charAt(0) == ' '){
        t = t.substring(1,t.length());
      }
      m = truncateWordsToWidth(t,this.maxWidth-2*this.margin);
      this.truncatedMessage.add(String.copyValueOf(m.toCharArray()));
    }
    this.dimensions = new PVector(this.maxWidth,this.margin*4 + (this.truncatedMessage.size()*2-1) * this.fontSize);
  }

  void render(){
    //Check if animation is completes, if so delete balloon
    if (millis() > this.startTime + this.maxTime){
      for (int i = 0; i < radioMessageBalloonList.size(); i++){
        if (radioMessageBalloonList.get(i) == this){
          radioMessageBalloonList.remove(i);
          return;
        }
      }
    }
    pushMatrix();
    translate(this.position.x,this.position.y);
    pushMatrix();
    //animate balloon if in transition, by rotating and fading
    if (millis()-this.startTime < this.transitionTime){
      rotate((1-(millis()-this.startTime)/this.transitionTime)*(-PI));
      color bc = this.backgroundColor, sc = this.strokeColor;
      fill(red(bc),green(bc),blue(bc),255*((millis()-this.startTime)/this.transitionTime));
      stroke(red(sc),green(sc),blue(sc),255*((millis()-this.startTime)/this.transitionTime));
    }else if (this.startTime + this.maxTime - millis() < this.transitionTime){
      rotate((1-(this.startTime+this.maxTime - millis())/this.transitionTime)*(PI));
      color bc = this.backgroundColor, sc = this.strokeColor;
      fill(red(bc),green(bc),blue(bc),255*((this.startTime+this.maxTime - millis())/this.transitionTime));
      stroke(red(sc),green(sc),blue(sc),255*((this.startTime+this.maxTime - millis())/this.transitionTime));
    }else{
      fill(this.backgroundColor);
      stroke(this.strokeColor);
    }
    //drawing outline
    beginShape();
    vertex(0,0);
    vertex(-1.5*this.margin,-this.margin);
    vertex(-this.margin,-this.margin);
    vertex(-2*this.margin,-2*this.margin);
    vertex(-this.maxWidth+this.margin,-2*this.margin);
    bezierVertex(-this.maxWidth+this.margin/2.0,-2*this.margin,-this.maxWidth,-2.5*this.margin,-this.maxWidth,-3*this.margin);
    vertex(-this.maxWidth,-this.dimensions.y+this.margin);
    bezierVertex(-this.maxWidth,-this.dimensions.y+this.margin/2.0,-this.maxWidth+this.margin/2.0,-this.dimensions.y,-this.maxWidth+this.margin,-this.dimensions.y);
    vertex(-this.margin,-this.dimensions.y);
    bezierVertex(-this.margin/2.0,-this.dimensions.y,0,-this.dimensions.y+this.margin/2.0,0,-this.dimensions.y+this.margin);
    vertex(0,-3*this.margin);
    bezierVertex(0,-2.5*this.margin,-this.margin/2,-2*this.margin,-this.margin,-2*this.margin);
    vertex(0,-this.margin);
    vertex(-this.margin/2,-this.margin);
    endShape(CLOSE);
    //drawing text
    textFont(this.font);
    textSize(this.fontSize);
    //fading the text
    if (millis()-this.startTime < this.transitionTime){
      color tc = this.textColor;
      fill(red(tc),green(tc),blue(tc),255*((millis()-this.startTime)/this.transitionTime));
    }else if (this.startTime + this.maxTime - millis() < this.transitionTime){
      color tc = this.textColor;
      fill(red(tc),green(tc),blue(tc),255*((this.startTime+this.maxTime - millis())/this.transitionTime));
    }else{
      fill(this.textColor);
    }
    for (int i = 0; i < truncatedMessage.size();i++){
      text(truncatedMessage.get(i),-this.maxWidth + this.margin,-this.dimensions.y + this.margin + this.fontSize*(1+2*i) - textDescent());
    }
    popMatrix();
    popMatrix();
  }
}


void drawGrid(PVector offset, float scale){
  stroke(0,255,255);
  pushMatrix();
  strokeWeight(1);
  translate(width/2,height/2);
  translate(offset.x,offset.y);
  scale(scale);
  if (mapSize%2 == 0){
    for (int i = 0;i < mapSize +1; i++){ //Vertical lines
      line((-mapSize/2+i)*100,-mapSize/2*100,(-mapSize/2+i)*100,mapSize/2*100);
    }
    for (int i = 0;i < mapSize +1; i++){ //Horizontal lines
      line((-mapSize/2)*100,(-mapSize/2+i)*100,(mapSize/2)*100,(-mapSize/2+i)*100);
    }
  }else{
    for (int i = 0;i < mapSize +2; i++){ //Vertical lines
      line(((-mapSize/2-0.5)+i)*100,(-mapSize/2-0.5)*100,(-mapSize/2+i-0.5)*100,(mapSize/2+0.5)*100);
    }
    for (int i = 0;i < mapSize +2; i++){ //Horizontal lines
      line((-mapSize/2-0.5)*100,(-mapSize/2+i-0.5)*100,(mapSize/2+0.5)*100,(-mapSize/2+i-0.5)*100);
    }
  }
  popMatrix();
}

//Takes a string m and returns a string with maximum width of w without cutting words.
//Font and text size according to what is set when function called
String truncateWordsToWidth(String m, float w){
  int i = 0, lastI = 0;
  while(i< m.length()){ //goes through all characters
    if (m.charAt(i) == ' '){ //if it finds a space
      if (textWidth(m.substring(0,i)) > w){ //if string with new word is too long return string until word last found before
        return m.substring(0,lastI);
      }
      lastI = i;  //else this becomes new valid word
    }
    i++;
  }
  if (textWidth(m.substring(0,i)) > w){ //when it gets to the end, if the last word doesnt fit return until last valid word
    return m.substring(0,lastI);
  }else{  //if it fits returns the whole string m
    return m;
  }
}