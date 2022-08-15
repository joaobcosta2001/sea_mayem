void drawBoatOutline(float x, float y, float s, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/800.0);
	noFill();
	stroke(0,255,255);
	strokeWeight(str);
	beginShape();
	vertex(-50,400);
	bezierVertex(-100,275,-100,275,-100,100);
	vertex(-100,0);
	bezierVertex(-100,-100,-50,-300,0,-400);
	bezierVertex(50,-300,100,-100,100,0);
	vertex(100,100);
	bezierVertex(100,275,100,275,50,400);
	endShape(CLOSE);
	strokeWeight(1);
	popMatrix();
}

void drawBoatInnerLine(float x, float y, float s, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/800.0);
	noFill();
	stroke(0,255,255);
	strokeWeight(str);
	beginShape();
	vertex(-25,200);
	bezierVertex(-37.5,187.5,-50,137.5,-50,125);
	vertex(-50,75);
	bezierVertex(-50,50,-25,0,0,-50);
	bezierVertex(25,0,50,50,50,75);
	vertex(50,125);
	bezierVertex(50,137.5,37.5,187.5,25,200);
	endShape(CLOSE);
	strokeWeight(1);
	popMatrix();
}

void drawCannonTurret(float x, float y, float s, float r, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	fill(0);
	stroke(0,255,255);
	strokeWeight(str);
	beginShape();
	vertex(-175,200);
	vertex(-200,150);
	vertex(-200,-200);
	vertex(-175,-100);
	vertex(-175,200);
	vertex(175,200);
	vertex(200,150);
	vertex(200,-200);
	vertex(175,-100);
	vertex(175,200);
	endShape();
	line(-200,-200,200,-200);
	line(-175,-100,-100,-100);
	line(-50,-100,-25,-100);
	line(25,-100,50,-100);
	line(100,-100,175,-100);
	rect(-100,-175,50,275);
	rect(-25,-175,50,275);
	rect(50,-175,50,275);
	float incline;
	if (r < 0){
		incline = 0;
	}else if(r > PI/3){
		incline = PI/3;
	}else{
		incline = r;
	}
	rect(-87.5,-500*cos(incline),25,500*cos(incline));
	rect(-12.5,-500*cos(incline),25,500*cos(incline));
	rect(62.5,-500*cos(incline),25,500*cos(incline));
	strokeWeight(1);
	popMatrix();
}

void drawMissileTurret(float x, float y, float s, float str){
	pushMatrix(); //Correction because it looked too big
	translate(x,y);
	scale(0.75);
	scale(s);
	scale(1/400.0);
	stroke(0,255,255);
	strokeWeight(str);
	fill(0);
	circle(0,0,400);
	rect(-200,-25,400,50);
	for(int i = 0; i< 4; i++){
		arc(-162.5 + 125 * i,-350,100,100, PI,4*PI/3);
		arc(-212.5 + 125*i,-350, 100,100, 5*PI/3,2*PI);
		rect(-225 + 125*i, -350, 75,550);
	}
	rect(-237.5,100,475,150);
	beginShape();
	vertex(-237.5,250);
	vertex(237.5,250);
	vertex(200,300);
	vertex(-200,300);
	endShape(CLOSE);
	strokeWeight(1);
	popMatrix();
}

void drawTorpedoTurret(float x, float y, float s, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	stroke(0,255,255);
	strokeWeight(str);
	fill(0);
	circle(0,0,200);
	circle(0,0,100);
	rect(-50,-50,50,100);
	beginShape();
	vertex(-25,150);
	vertex(25,150);
	vertex(12.5,-400);
	vertex(-12.5,-400);
	endShape(CLOSE);
	beginShape();
	noFill();
	vertex(-125,-75);
	vertex(-75,-125);
	vertex(75,-125);
	vertex(125,-75);
	endShape();
	strokeWeight(1);
	popMatrix();
}

void drawAntiCannonTurret(float x, float y, float s, float r, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	stroke(0,255,255);
	strokeWeight(str);
	fill(0);
	circle(0,0,400);
	beginShape();
	vertex(-125,-125);
	vertex(-75,-75);
	vertex(-75,75);
	vertex(-125,125);
	endShape(CLOSE);
	beginShape();
	vertex(125,-125);
	vertex(75,-75);
	vertex(75,75);
	vertex(125,125);
	endShape(CLOSE);
	beginShape();
	vertex(-125,-125);
	vertex(-75,-75);
	vertex(-50,-75);
	vertex(-75,-125);
	endShape(CLOSE);
	beginShape();
	vertex(-125,125);
	vertex(-75,75);
	vertex(-50,75);
	vertex(-75,125);
	endShape(CLOSE);
	beginShape();
	vertex(125,125);
	vertex(75,75);
	vertex(50,75);
	vertex(75,125);
	endShape(CLOSE);
	beginShape();
	vertex(125,-125);
	vertex(75,-75);
	vertex(50,-75);
	vertex(75,-125);
	endShape(CLOSE);
	rect(-75,-75,25,150);
	rect(50,-75,25,150);
	pushMatrix();
	float incline;
	if(r < 0){
		incline = 0;
	}else if(r > PI/3){
		incline = PI/3;
	}else{
		incline = r;
	}
	scale(1,cos(incline));
	rect(-50,-100,100,200);
	rect(-37.5,100,75,12.5);
	noStroke();
	rect(-25,-150,50,25);
	stroke(0,255,255);
	strokeWeight(str);
	line(-25,-150,25,-150);
	arc(-25,-125,50,50,PI,3*PI/2);
	arc(25,-125,50,50,3*PI/2,PI*2);
	rect(-50,-125,100,25);
	rect(-6.25,-400,12.5,250);
	strokeWeight(1);
	popMatrix();
	popMatrix();
}

void drawAntiMissileTurret(float x, float y, float s, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	stroke(0,255,255);
	strokeWeight(str);
	fill(0);
	circle(0,0,150);
	rect(-50,-25,100,100);
	rect(-37.5,-12.5,75,75);
	line(0,75,0,100);
	beginShape();
	noFill();
	vertex(-125,50);
	vertex(-25,100);
	vertex(25,100);
	vertex(125,50);
	endShape();
	fill(0);
	for(int i = 0; i< 6; i++){
		line(0,-200+25*i,50,-200+25*i);
		arc(50,-187.5+25*i,25,25,-PI/2,PI/2);
	}
	line(0,-50,50,-50);
	for(int i = 0; i< 6; i++){
		line(0,-200+25*i,-50,-200+25*i);
		arc(-50,-187.5+25*i,25,25,PI/2,3*PI/2);
	}
	line(0,-50,-50,-50);
	strokeWeight(2*str);
	line(0,-25,0,-250);
	strokeWeight(1);

	popMatrix();
}

void drawAntiTorpedoTurret(float x, float y, float s, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	stroke(0,255,255);
	strokeWeight(str);
	fill(0);
	circle(0,0,150);
	rect(-125,-150,75,300);
	rect(50,-150,75,300);
	rect(-25,-100,12.5,75);
	rect(12.5,-100,12.5,75);
	strokeWeight(1);
	popMatrix();
}

void drawTier2Antenna(float x, float y, float s, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	fill(0);
	stroke(0,255,255);
	strokeWeight(str);
	rect(-200,-200,400,400);
	rect(-150,50,100,100);
	line(-150,50,-50,150);
	line(-150,150,-50,50);
	circle(-100,100,25);
	pushMatrix();
	translate(0,-100);
	rotate((millis()-animationStartTime) / 300.0);
	rect(-175,-25,350,50);
	popMatrix();
	circle(100,100,20);
	line(100,10,100,190);
	line(50,25,150,25);
	line(50,75,150,75);
	line(50,125,150,125);
	line(50,175,150,175);
	strokeWeight(1);
	popMatrix();
}

void drawTier1Antenna(float x, float y, float s, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	fill(0);
	stroke(0,255,255);
	strokeWeight(str);
	rect(-200,-200,400,400);
	//circle(0,0,200);
	pushMatrix();
	rotate((millis()-animationStartTime) / 400.0);
	translate(0,-50);
	arc(0,50,250,150,0,PI);
	ellipse(0,50,250,100);
	line(0,-40,0,20);
	line(0,-40,-100,60);
	line(0,-40,100,60);
	circle(0,-40,20);
	popMatrix();
	strokeWeight(1);
	popMatrix();
}

void drawTier3Antenna(float x, float y, float s, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	fill(0);
	stroke(0,255,255);
	strokeWeight(str);
	rect(-200,-200,400,400);
	circle(0,0,200);
	pushMatrix();
	scale(1.5);
	rotate((millis()-animationStartTime) / 400.0);
	beginShape();
	vertex(-30,60);
	vertex(-5,-30);
	vertex(5,-30);
	vertex(30,60);
	vertex(20,60);
	vertex(0,-20);
	vertex(-20,60);
	endShape(CLOSE);
	beginShape();
	vertex(-200,0);
	bezierVertex(-150,50,-75,80,0,80);
	bezierVertex(75,80,150,50,200,0);
	vertex(200,-10);
	bezierVertex(150,40,40,40,0,40);
	bezierVertex(-40,40,-150,40,-200,-10);
	endShape(CLOSE);
	rect(-5,-50,10,50);
	circle(0,0,15);
	popMatrix();
	strokeWeight(1);
	popMatrix();
}


void drawTier1Engine(float x, float y, float s, float sp, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	fill(0);
	stroke(0,255,255);
	strokeWeight(str);
	rect(-200,-50,400,100);
	strokeWeight(str/2.0);
	rotate((millis()-animationStartTime) / -200.0 * sp);
	pushMatrix();
	for(int i = 0; i< 4; i++){
		rotate(PI/2);
		beginShape();
		vertex(0,0);
		bezierVertex(8, -40, 32, -40, 40, 8);
		bezierVertex(28,-8,12,-8,0,0);
		endShape(CLOSE);
	}
	popMatrix();
	circle(0,0,20);
	popMatrix();
	strokeWeight(1);
}


void drawTier2Engine(float x, float y, float s, float sp, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	fill(0);
	stroke(0,255,255);
	strokeWeight(str);
	rect(-200,-50,400,100);
	strokeWeight(str/2.0);
	translate(-66,0);
	pushMatrix();
	rotate((millis()-animationStartTime) / -200.0*sp);
	for(int i = 0; i< 4; i++){
		rotate(PI/2);
		beginShape();
		vertex(0,0);
		bezierVertex(8, -40, 32, -40, 40, 8);
		bezierVertex(28,-8,12,-8,0,0);
		endShape(CLOSE);
	}
	popMatrix();
	circle(0,0,20);
	translate(133,0);
	pushMatrix();
	rotate((millis()-animationStartTime) / -200.0*sp);
	for(int i = 0; i< 4; i++){
		rotate(PI/2);
		beginShape();
		vertex(0,0);
		bezierVertex(8, -40, 32, -40, 40, 8);
		bezierVertex(28,-8,12,-8,0,0);
		endShape(CLOSE);
	}
	popMatrix();
	circle(0,0,20);
	popMatrix();
	strokeWeight(1);
}

void drawTier3Engine(float x, float y, float s, float sp, float str){
	pushMatrix();
	translate(x,y);
	scale(s);
	scale(1/400.0);
	fill(0);
	stroke(0,255,255);
	strokeWeight(str);
	rect(-200,-50,400,100);
	strokeWeight(str/2.0);
	translate(-100,0);
	pushMatrix();
	rotate((millis()-animationStartTime) / -200.0*sp);
	for(int i = 0; i< 4; i++){
		rotate(PI/2);
		beginShape();
		vertex(0,0);
		bezierVertex(8, -40, 32, -40, 40, 8);
		bezierVertex(28,-8,12,-8,0,0);
		endShape(CLOSE);
	}
	popMatrix();
	circle(0,0,20);
	translate(100,0);
	pushMatrix();
	rotate((millis()-animationStartTime) / -200.0*sp);
	for(int i = 0; i< 4; i++){
		rotate(PI/2);
		beginShape();
		vertex(0,0);
		bezierVertex(8, -40, 32, -40, 40, 8);
		bezierVertex(28,-8,12,-8,0,0);
		endShape(CLOSE);
	}
	popMatrix();
	circle(0,0,20);
	translate(100,0);
	pushMatrix();
	rotate((millis()-animationStartTime) / -200.0*sp);
	for(int i = 0; i< 4; i++){
		rotate(PI/2);
		beginShape();
		vertex(0,0);
		bezierVertex(8, -40, 32, -40, 40, 8);
		bezierVertex(28,-8,12,-8,0,0);
		endShape(CLOSE);
	}
	popMatrix();
	circle(0,0,20);
	popMatrix();
	strokeWeight(1);
}


PGraphics generateRadarImage(){
	PGraphics img = createGraphics(500,500);
	img.beginDraw();
	img.noStroke();
	img.fill(0,255,255,1);
	for (int i = 0; i < 100; i++){
		img.arc(250,250,500,500,-PI/3 + PI/3*float(i)/100,0);
	}
	img.endDraw();
	return img;
}