ArrayList<UIElement> UIElementList = new ArrayList<UIElement>();  //List of UIElements
ArrayList<UIButton> UIButtonList = new ArrayList<UIButton>();     //List of UITextBoxes
ArrayList<UITextBox> UITextBoxList = new ArrayList<UITextBox>();  //List of UIButtons
ArrayList<UIScrollList> UIScrollListList = new ArrayList<UIScrollList>(); // List of UIScrollLists
ArrayList<UIScrollBar> UIScrollBarList = new ArrayList<UIScrollBar>(); // List of UISCrollBars
ArrayList<UIMessage> UIMessageList = new ArrayList<UIMessage>(); //List of UIMEssages
ArrayList<UIProgressBar> UIProgressBarList = new ArrayList<UIProgressBar>(); // List of UIProgressBar

String selectedUIElement = null; //Label of the currently selected UIElement


PFont font_default;
int UIBEGINNING = 1;
int UIENDING = 2;

class UIElement{
  PVector position,dimensions;
  boolean visible;
  String label;
}

class UIButton extends UIElement{
  color textColor, backgroundColor, strokeColor, selectedTextColor, selectedBackgroundColor, selectedStrokeColor;
  float margin, fontSize;
  String text;
  PFont font;
  boolean clicked,released;
  UIButton(float x, float y, float w, float h,String t){
    UIElementList.add(this);
    UIButtonList.add(this);
    this.position = new PVector(x,y);
    this.dimensions = new PVector(w,h);
    this.visible = false;
    this.textColor = color(0,255,255);
    this.backgroundColor = color(255,255,255,0);
    this.strokeColor = color(0,255,255);
    this.selectedTextColor = color(255);
    this.selectedBackgroundColor = color(0,255,255,50);
    this.selectedStrokeColor = color(255);
    this.text = t;
    this.margin = 10;
    this.font = font_default;
    textFont(this.font);
    this.fontSize = fitTextSizeToWidth(this.text, this.dimensions.x - 2 * this.margin, this.dimensions.y - 2 * this.margin);
    this.clicked = false;
    this.released = false;
    this.label = "button_" + str(UIButtonList.size());
  }
  void render(){
    textFont(this.font);
    if (selectedUIElement == this.label){
      stroke(this.selectedStrokeColor);
      fill(this.selectedBackgroundColor);
      rect(this.position.x,this.position.y,this.dimensions.x,this.dimensions.y);
      fill(this.selectedTextColor);
      textSize(this.fontSize);
      textAlign(CENTER);
      text(this.text,this.position.x+this.dimensions.x/2,this.position.y+this.dimensions.y/2 + this.fontSize/2 - textDescent());
    }else{
      stroke(this.strokeColor);
      fill(this.backgroundColor);
      rect(this.position.x,this.position.y,this.dimensions.x,this.dimensions.y);
      fill(this.textColor);
      textSize(this.fontSize);
      textAlign(CENTER);
      text(this.text,this.position.x+this.dimensions.x/2,this.position.y+this.dimensions.y/2 + this.fontSize/2 - textDescent());
    }
  }
  void setFont(PFont f){
    this.font = f;
    textFont(this.font);
    this.fontSize = fitTextSizeToWidth(this.text,this.dimensions.x-2*this.margin, this.dimensions.y - 2 * this.margin);
  }
}

class UITextBox extends UIElement{
  color textColor, dummyTextColor, backgroundColor, strokeColor, selectedDummyTextColor, selectedBackgroundColor, selectedStrokeColor;
  float margin, fontSize;
  String text, dummyText;
  boolean clicked;
  UITextBox(float x, float y, float w, float h,String t){
    UIElementList.add(this);
    UITextBoxList.add(this);
    this.position = new PVector(x,y);
    this.dimensions = new PVector(w,h);
    this.visible = false;
    this.textColor = color(255);
    this.dummyTextColor = color(100);
    this.selectedDummyTextColor = color(150);
    this.backgroundColor = color(255,255,255,0);
    this.strokeColor = color(0,255,255);
    this.selectedBackgroundColor = color(0,255,255,50);
    this.selectedStrokeColor = color(255);
    this.text = "";
    this.dummyText = t;
    this.margin = this.dimensions.y/4;
    this.fontSize = this.dimensions.y/2;
    textSize(this.fontSize);
    while(this.fontSize > this.dimensions.y - 2 * this.margin){
      this.fontSize = this.fontSize-1;
      if(this.fontSize == 0){
        this.fontSize = 10;
        break;
      }
      textSize(this.fontSize);
    }
    this.clicked = false;
    this.label = "textbox_" + str(UIButtonList.size());
  }
  void render(){
    if (selectedUIElement == this.label){
      stroke(this.selectedStrokeColor);
      fill(this.selectedBackgroundColor);
      rect(this.position.x,this.position.y,this.dimensions.x,this.dimensions.y);
      textSize(this.fontSize);
      textAlign(LEFT);
      if (this.text == ""){
        fill(this.selectedDummyTextColor);
        text(truncateTextToWidth(this.dummyText,this.dimensions.x - this.margin * 2, UIENDING),this.position.x+this.margin,this.position.y+this.dimensions.y - this.margin - textDescent());
        fill(this.textColor);
        text("|",this.position.x+this.margin,this.position.y+this.dimensions.y - this.margin - textDescent());
      }else{
        fill(this.textColor);
        text(truncateTextToWidth(this.text + "|",this.dimensions.x - this.margin * 2, UIENDING),this.position.x+this.margin,this.position.y+this.dimensions.y - this.margin - textDescent());
      }
    }else{
      stroke(this.strokeColor);
      fill(this.backgroundColor);
      rect(this.position.x,this.position.y,this.dimensions.x,this.dimensions.y);
      textSize(this.fontSize);
      textAlign(LEFT);
      if (this.text == ""){
        fill(this.selectedDummyTextColor);
        text(truncateTextToWidth(this.dummyText,this.dimensions.x - this.margin * 2, UIENDING),this.position.x+this.margin,this.position.y+this.dimensions.y - this.margin - textDescent());
      }else{
        fill(this.textColor);
        text(truncateTextToWidth(this.text,this.dimensions.x - this.margin * 2, UIENDING),this.position.x+this.margin,this.position.y+this.dimensions.y - this.margin - textDescent());
      }
    }
  }
}

class UIScrollList extends UIElement{
  color strokeColor,backgroundColor, textColor;
  float fontSize, margin, scrollBarWidth;
  int elementsToDraw, selectedElement;
  ArrayList<String> elements;
  UIScrollBar scrollbar;
    
  UIScrollList(float x, float y, float w, float h){
    UIElementList.add(this);
    UIScrollListList.add(this);
    this.position = new PVector(x,y);
    this.dimensions = new PVector(w,h);
    this.visible = false;
    this.label = "scrolllist_"  + str(UIScrollListList.size());
    this.strokeColor = color(0,255,255);
    this.backgroundColor = color(255,0,0,0);
    this.textColor = color(255);
    this.fontSize = 20;
    this.margin = this.fontSize;
    this.elementsToDraw = 0;
    this.selectedElement = -1;
    this.elements = new ArrayList<String>();
    this.scrollBarWidth = this.margin;
    this.scrollbar = new UIScrollBar(this.position.x +  this.dimensions.x - this.margin - this.scrollBarWidth, this.position.y + this.margin, this.scrollBarWidth, this.dimensions.y - 2 * this.margin, 1);
    this.scrollbar.visible = false;
  }

  void recalculateScrollButtonSize(){
    this.scrollbar.buttonToHeightRatio = this.elementsToDraw / float(this.elements.size());
  }

  void add(String t){
    elements.add(t);
    if(this.elements.size() * this.fontSize*2-this.fontSize < this.dimensions.y - 2 * this.margin){
      this.elementsToDraw = this.elements.size();
      this.scrollbar.visible = false;
    }else{
      this.elementsToDraw = ceil((this.dimensions.y - 2 * this.margin)/(this.fontSize * 2));
      this.scrollbar.visible = true;
    }
    this.recalculateScrollButtonSize();
  }

  boolean remove(String t){
    for (int i = 0; i < this.elements.size();i++){
      if (this.elements.get(i) == t){
        this.elements.remove(i);
        if(this.elements.size() * this.fontSize*2-this.fontSize < this.dimensions.y - 2 * this.margin){
          this.elementsToDraw = this.elements.size();
          this.scrollbar.visible = false;
        }else{
          this.elementsToDraw = ceil((this.dimensions.y - 2 * this.margin)/(this.fontSize * 2));
          this.scrollbar.visible = true;
        }
        this.recalculateScrollButtonSize();
        return true;
      }
    }
    return false;
  }
  void removeAll(){
    this.elements.clear();
    this.elementsToDraw = this.elements.size();
    this.scrollbar.visible = false;
    this.recalculateScrollButtonSize();
  }

  void render(){
    textAlign(LEFT);
    pushMatrix();
    translate(this.position.x,this.position.y);
    fill(this.backgroundColor);
    stroke(this.strokeColor);
    rect(0,0,this.dimensions.x,this.dimensions.y);
    if (this.scrollbar.visible){
      textSize(this.fontSize);
      fill(this.textColor);
      int offset = floor(this.scrollbar.progress * (this.elements.size() - this.elementsToDraw +1));
      if (offset > this.elements.size() - this.elementsToDraw){
        offset = this.elements.size() - this.elementsToDraw;
      }
      for(int i = 0;i < elementsToDraw; i++){
        if (textWidth(elements.get(i+offset)) > this.dimensions.x - 3 * this.margin - this.scrollBarWidth){
          text(truncateTextToWidth(elements.get(i + offset),this.dimensions.x - 3 * this.margin - this.scrollBarWidth - textWidth("..."), UIBEGINNING) + "...",this.margin, this.margin + this.fontSize + i * (this.fontSize*2) - textDescent());
        }else{
          text(elements.get(i+offset),this.margin, this.margin + this.fontSize + i * (this.fontSize*2) - textDescent());
        }
      }
    }else{
      textSize(this.fontSize);
      fill(this.textColor);
      int offset = floor(this.scrollbar.progress * (this.elements.size() - this.elementsToDraw +1));
      if (offset > this.elements.size() - this.elementsToDraw){
        offset = this.elements.size() - this.elementsToDraw;
      }
      for(int i = 0;i < elementsToDraw; i++){
        if (textWidth(elements.get(i + offset)) > this.dimensions.x - 3 * this.margin - this.scrollBarWidth){
          text(truncateTextToWidth(elements.get(i+offset),this.dimensions.x - 3 * this.margin - this.scrollBarWidth - textWidth("..."), UIBEGINNING) + "...",this.margin, this.margin + this.fontSize + i * (this.fontSize*2) - textDescent());
        }else{
          text(elements.get(i + offset),this.margin, this.margin + this.fontSize + i * (this.fontSize*2) - textDescent());
        }
      }
    }
    popMatrix();
    if(this.scrollbar.visible){
      this.scrollbar.render();
    }
  }
  void updateScroll(){
      
  }
}

class UIScrollBar extends UIElement{
  color backgroundColor, buttonColor, selectedButtonColor, strokeColor;
  float buttonToHeightRatio, progress;
  UIScrollBar(float x,float y, float w, float h, float r){
    UIElementList.add(this);
    UIScrollBarList.add(this);
    this.position = new PVector(x,y);
    this.dimensions = new PVector(w,h);
    this.visible = true;
    this.label = "scrollbar_" + str(UIScrollBarList.size());
    this.backgroundColor = color(0,255,255,100);
    this.buttonColor = color (0,255,255);
    this.selectedButtonColor = color(255);
    this.strokeColor = color(255,0,0,0);
    this.buttonToHeightRatio = r;
    this.progress = 0;
  }
  void render(){
    pushMatrix();
    translate(this.position.x,this.position.y);
    fill(this.backgroundColor);
    stroke(this.strokeColor);
    rect(0,0,this.dimensions.x,this.dimensions.y);
    if(selectedUIElement == this.label){
      fill(this.selectedButtonColor);
    }else{
      fill(this.buttonColor);
    }
    rect(0,this.progress*(1-this.buttonToHeightRatio)* this.dimensions.y, this.dimensions.x, this.dimensions.y * this.buttonToHeightRatio);
    popMatrix();
  }
}

class UIMessage{
  String text;
  PFont font;
  float fontSize;
  int startTime, animationDuration;
  color textColor;
  UIMessage(String t){
    println("Created message: " + t);
    UIMessageList.add(this);
    this.text = t;
    this.font = font_default;
    this.fontSize = height/25;
    this.startTime = millis();
    this.animationDuration = int(2.5*1000);
    this.textColor = color(255);
  }
  void render(){
    float progress = (millis() - this.startTime)/float(this.animationDuration);
    if (progress>=1){
      int i;
      for(i = 0; i < UIMessageList.size(); i++){
        if (UIMessageList.get(i) == this){
          break;
        }
      }
      UIMessageList.remove(i);
    }
    textFont(this.font);
    textSize(this.fontSize);
    if(progress < 1/6.0){
      fill(red(this.textColor),green(this.textColor),blue(this.textColor),progress * 6*255);
    }else if(progress > 5/6.0){
      fill(red(this.textColor),green(this.textColor),blue(this.textColor),(1-progress) * 6*255);
    }else{
      fill(this.textColor);
    }
    textAlign(CENTER);

    text(this.text,width/2,height/2 + this.fontSize - textDescent() - 2 * this.fontSize * progress);
  }
}

class UIProgressBar extends UIElement{
  color strokeColor, backgroundColor, barColor;
  float progress;
  UIProgressBar(float x, float y, float w, float h){
    UIElementList.add(this);
    UIProgressBarList.add(this);
    this.position = new PVector(x,y);
    this.dimensions = new PVector(w,h);
    this.visible = false;
    this.label = "progress_bar_" + str(UIProgressBarList.size());
    this.strokeColor = color(0,255,255);
    this.backgroundColor = color(255,0,0,0);
    this.barColor = color(255);
    this.progress = 0;
  }
  void render(){
    pushMatrix();
    translate(this.position.x,this.position.y);
    noStroke();
    fill(this.backgroundColor);
    rect(0,0,this.dimensions.x,this.dimensions.y);
    fill(this.barColor);
    rect(0,0,this.dimensions.x * this.progress,this.dimensions.y);
    fill(255,0,0,0);
    stroke(strokeColor);
    rect(0,0,this.dimensions.x,this.dimensions.y);
    popMatrix();
  }
}

void initializeUILib(){
  font_default = createFont("Arial",50);
}

//Function to be added to draw()
void processUILib(){
  for(int i = 0; i< UIButtonList.size();i++){
    if(UIButtonList.get(i).visible){
      UIButtonList.get(i).render();
    }
  }
  for(int i = 0; i< UITextBoxList.size();i++){
    if(UITextBoxList.get(i).visible){
      UITextBoxList.get(i).render();
    }
  }
  for(int i = 0; i< UIScrollListList.size();i++){
    if(UIScrollListList.get(i).visible){
      UIScrollListList.get(i).render();
    }
  }
  for(int i = 0; i< UIProgressBarList.size();i++){
    if(UIProgressBarList.get(i).visible){
      UIProgressBarList.get(i).render();
    }
  }
  for(int i = 0; i< UIMessageList.size();i++){
    UIMessageList.get(i).render();
  }
  for(int i = 0; i< UIButtonList.size(); i++){
    if (UIButtonList.get(i).clicked){
      UIButtonList.get(i).clicked = false;
    }
    if (UIButtonList.get(i).released){
      UIButtonList.get(i).released = false;
    }
  }for(int i = 0; i< UITextBoxList.size(); i++){
    if (UITextBoxList.get(i).clicked){
      UITextBoxList.get(i).clicked = false;
    }
  }
  UIScrollBar sb = getUIScrollBarByLabel(selectedUIElement);
  if(sb!=null){
    sb.progress = (mouseY - sb.position.y - sb.dimensions.y * sb.buttonToHeightRatio/2)/((1 - sb.buttonToHeightRatio) * sb.dimensions.y);
    if (sb.progress > 1){
      sb.progress = 1;
    }else if (sb.progress < 0){
      sb.progress = 0;
    }
  }
}

//Function to be added to mousePressed()
void processUILibMousePressed(){
  UIButton b = checkMouseOverUIButton();
  if (b != null){
    if(b.visible){
      b.clicked = true;
      selectedUIElement = b.label;
      return;
    }
  }
  UITextBox tb = checkMouseOverUITextBox();
  if (tb != null){
    if (tb.visible){
      tb.clicked = true;
      selectedUIElement = tb.label;
      return;
    }
  }
  UIScrollBar sb = checkMouseOverUIScrollBar();
  if (sb != null){
    if (sb.visible){
      selectedUIElement = sb.label;
      sb.progress = (mouseY - sb.position.y - sb.dimensions.y * sb.buttonToHeightRatio/2)/((1 - sb.buttonToHeightRatio) * sb.dimensions.y);
      println(sb.progress);
      if (sb.progress > 1){
        sb.progress = 1;
      }else if (sb.progress < 0){
        sb.progress = 0;
      }
      return;
    }
  }
  selectedUIElement = null;
}

//function to be added to mouseReleased()
void processUILibMouseReleased(){
  UIButton b = getUIButtonByLabel(selectedUIElement);
  if (b != null){
    selectedUIElement = null;
    b.released = true;
  }
  UIScrollBar sb = getUIScrollBarByLabel(selectedUIElement);
  if (sb != null){
    selectedUIElement = null;
  }
}

//function to be added to keyPressed()
void processUILibKeyPressed(){
  if (selectedUIElement != null){
    if (key != CODED){
      UITextBox tb = getUITextBoxByLabel(selectedUIElement);
      if (key == BACKSPACE){
        if (tb != null){
          if (tb.text.length() > 0){
            tb.text = tb.text.substring(0,tb.text.length()-1);
          }
        }
      }else if(key == TAB){
        int i;
        for(i = 0; i < UITextBoxList.size();i++){
          if (selectedUIElement == UITextBoxList.get(i).label){
            break;
          }
        }
        int startingI = i;
        i++;
        if (i==UITextBoxList.size()){
          i = 0;
        }
        while(i != startingI){
          if(UITextBoxList.get(i).visible){
            break;
          }
        }
        if(startingI != i){
          selectedUIElement = UITextBoxList.get(i).label;
        }
      }else if (key == ENTER || key == RETURN || key == ESC || key == DELETE){
        ;
      }else{
        if (tb != null){
          tb.text = tb.text + key;
        }
      }
    }
  }
}




//AUXILIARY FUNCTIONS

//float fitTextSizeToWidth(String t, flaot w, float maxH):
// - Takes string t and a width w and returns the adjusted textSize to fit in the given width. maxH is the maximum text size
float fitTextSizeToWidth(String t, float w, float maxH){
  float size = maxH;
  textSize(size);
  while(textWidth(t) > w){
    size--;
    if(size == 0){
      size = 10;
      break;
    }
    textSize(size);
  }
  return size;
}

//String truncateTextToWidth(String t, float w, int m):
// - Takes string t and, depending on the current text size and provided mode m, returns the string truncated to fit the width w.
// - The available modes are:
//   - UIBEGGINING - leaves the begging of the String, cutting the last part
//   - UIENDING - leaves the endind of the String, cuttind the first part
String truncateTextToWidth(String t, float w, int m){
  if (m != 1 && m != 2){
    println("Invalid mode in trucnateTextToWidth()!");
    return null;
  }
  while(textWidth(t) > w){
    if( m == UIBEGINNING){
      t = t.substring(0,t.length() - 2);
    }else if (m == UIENDING){
      t = t.substring(1,t.length() - 1);
    }
  }
  return t;
}

//UIElement checkMouseOverUIElement():
// - if the mouse is over a UIElement returns it, otherwise returns null
UIElement checkMouseOverUIElement(){
  for(int i = 0; i < UIElementList.size();i++){
    if (UIElementList.get(i).position.x < mouseX && UIElementList.get(i).position.x + UIElementList.get(i).dimensions.x > mouseX && UIElementList.get(i).position.y < mouseY && UIElementList.get(i).position.y + UIElementList.get(i).dimensions.y > mouseY){
      return UIElementList.get(i);
    }
  }
  return null;
}

//UIButton checkMouseOverUIButton():
// - if the mouse is over a UIButton returns it, otherwise returns null
UIButton checkMouseOverUIButton(){
  for(int i = 0; i < UIButtonList.size();i++){
    if (UIButtonList.get(i).position.x < mouseX && UIButtonList.get(i).position.x + UIButtonList.get(i).dimensions.x > mouseX && UIButtonList.get(i).position.y < mouseY && UIButtonList.get(i).position.y + UIButtonList.get(i).dimensions.y > mouseY){
      return UIButtonList.get(i);
    }
  }
  return null;
}

UIScrollBar checkMouseOverUIScrollBar(){
  for(int i = 0; i < UIScrollBarList.size();i++){
    if (UIScrollBarList.get(i).position.x < mouseX && UIScrollBarList.get(i).position.x + UIScrollBarList.get(i).dimensions.x > mouseX && UIScrollBarList.get(i).position.y < mouseY && UIScrollBarList.get(i).position.y + UIScrollBarList.get(i).dimensions.y > mouseY){
      return UIScrollBarList.get(i);
    }
  }
  return null;
}

//UITextBox checkMouseOverUITextBox():
// - if the mouse is over a UITextBox returns it, otherwise returns null
UITextBox checkMouseOverUITextBox(){
  for(int i = 0; i < UITextBoxList.size();i++){
    if (UITextBoxList.get(i).position.x < mouseX && UITextBoxList.get(i).position.x + UITextBoxList.get(i).dimensions.x > mouseX && UITextBoxList.get(i).position.y < mouseY && UITextBoxList.get(i).position.y + UITextBoxList.get(i).dimensions.y > mouseY){
      return UITextBoxList.get(i);
    }
  }
  return null;
}

//UIButton getUIButtonByLabel(String s):
//Searches UIButtonList for button with label s, if it is found returns UIButton, otherwise returns null
UIButton getUIButtonByLabel(String s){
  for (int i = 0; i < UIButtonList.size(); i++){
    if (s == UIButtonList.get(i).label){
      return UIButtonList.get(i);
    }
  }
  return null;
}

//UITextBox getUITextBoxByLabel(String s):
//Searches UITextBoxList for textbox with label s, if it is found returns UITextBox, otherwise returns null
UITextBox getUITextBoxByLabel(String s){
  for (int i = 0; i < UITextBoxList.size(); i++){
    if (s == UITextBoxList.get(i).label){
      return UITextBoxList.get(i);
    }
  }
  return null;
}

UIScrollBar getUIScrollBarByLabel(String s){
  for (int i = 0; i < UIScrollBarList.size(); i++){
    if (s == UIScrollBarList.get(i).label){
      return UIScrollBarList.get(i);
    }
  }
  return null;
}
