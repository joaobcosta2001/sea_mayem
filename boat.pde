class Boat{
  PVector position;
  float angle;
  Display display;
  Boat(){
    this.position = new PVector(0,0);
    this.angle = 0;
    this.display = new Display();
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

class Display{
  int frontTurret,middleTurret,backTurret, frontAntiTurret, backAntiTurret, engine, navigation;
  Display(){
    frontTurret = 0;
    middleTurret = 0;
    backTurret = 0;
    backAntiTurret = 0;
    frontAntiTurret = 0;
    navigation = 0;
    engine = 0;
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
