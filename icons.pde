void drawGunsIcon(float x, float y, float s){
	fill(0,255,255);
	noStroke();
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/100.0);
	rect(-50,-22,25,72);
	rect(-12.5,-22,25,72);
	rect(25,-22,25,72);
	arc(-25,-28.3,50,50,PI,PI*(4.0/3));
	arc(12.5,-28.3,50,50,PI,PI*(4.0/3));
	arc(50,-28.3,50,50,PI,PI*(4.0/3));
	arc(-50,-28.3,50,50,PI*(5.0/3),PI*2);
	arc(-12.5,-28.3,50,50,PI*(5.0/3),PI*2);
	arc(25,-28.3,50,50,PI*(5.0/3),PI*2);
	popMatrix();
}

void drawDefenseIcon(float x, float y, float s){
	fill(0,255,255);
	noStroke();
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/100.0);
	beginShape();
	vertex(0,-50);
	vertex(50,-40);
	bezierVertex(40,30,40,30,0,50);
	bezierVertex(-40,30,-40,30,-50,-40);
	endShape(CLOSE);
	popMatrix();
}

void drawNavigationIcon(float x, float y, float s){
	stroke(0,255,255);
	noFill();
	strokeWeight(8);
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/100.0);
	line(0,-50,0,50);
	line(-50,0,50,0);
	circle(0,0,80);
	circle(0,0,40);
	strokeWeight(1);
	endShape(CLOSE);
	popMatrix();
}

void drawEngineIcon(float x, float y, float s){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/100.0);
	stroke(0,255,255);
	noFill();
	strokeWeight(20);
	circle(0,0,60);
	noStroke();
	fill(0,255,255);
	pushMatrix();
	int teethCount = 12;
	for(int i = 0; i < teethCount; i++){
		rotate(2*PI/teethCount);
		beginShape();
		vertex(-7,-30);
		vertex(-5,-50);
		vertex(5,-50);
		vertex(7,-30);
		endShape(CLOSE);
	}
	popMatrix();
	strokeWeight(1);
	endShape(CLOSE);
	popMatrix();
}


void drawGreenTick(float x, float y, float s){
  pushMatrix();
  translate(x,y);
  scale(s);
  fill(0);
  stroke(0,255,255);
  beginShape();
  vertex(75/3.0,-5*75/12.0);
  vertex(75/2.0,-75/4.0);
  vertex(-75/6.0,5*75/12.0);
  vertex(-75/2.0,75/12.0);
  vertex(-75/3.0,-75/12.0);
  vertex(-75/6.0,75/12.0);
  endShape(CLOSE);
  popMatrix();
}