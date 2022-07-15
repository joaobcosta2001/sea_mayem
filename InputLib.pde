//Put initializeInputLib() in setup(), processUIMousePress() in mousePressed() and processUIMouseRelease() in mouseReleased()



boolean[] mouseButtonsPressed;
boolean shiftPressed = false;
boolean backspacePressed = false;

void initializeInputLib(){
  mouseButtonsPressed = new boolean[2];
  mouseButtonsPressed[0] = false;
  mouseButtonsPressed[1] = false;
}

void processInputLibMousePress(){
  if (mouseButton == LEFT){
    mouseButtonsPressed[0] = true;
  }else if(mouseButton == RIGHT){
    mouseButtonsPressed[1] = true;
  }
}

void processInputLibMouseRelease(){
  if (mouseButton == LEFT){
    mouseButtonsPressed[0] = false;
  }else if(mouseButton == RIGHT){
    mouseButtonsPressed[1] = false;
  }
  
}


void processInputLibKeyPressed(){
  if (key == CODED){
    if (keyCode == SHIFT){
      shiftPressed = true;
    }else if(key == BACKSPACE){
      backspacePressed = true;
    }
  }
}

void processInputLibKeyReleased(){
  if (key == CODED){
    if (keyCode == SHIFT){
      shiftPressed = false;
    }else if(key == BACKSPACE){
      backspacePressed = false;
    }
  }
}