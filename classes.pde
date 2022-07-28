class Boat{
  PVector position;
  float angle;
  int ft,mt,bt,fat,bat;
  Boat(){
    this.position = new PVector(0,0);
    this.angle = 0;
    this.ft = -1;
    this.mt = -1;
    this.bt = -1;
    this.fat = -1;
    this.bat = -1;
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
