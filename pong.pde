//By KJunya 2014.1.23
//ball property
float bX;    //ball position X
float bY;    //ball position Y
float bsX;   //ball speed X
float bsY;   //ball speed Y
float bs;    //ball size
float tbsX;  //X speed tweeker when hit count increas
float tbsY;  //Y speed tweeker when ball hits pattle
//pattle property
float prX;   //pattle right position X
float prY;   //pattle right position Y
float plX;   //pattle left position X
float plY;   //pattle left position Y
float prds;  //pattle right default speed
float plds;  //pattle left default speed
float prs;   //pattle right speed
float pls;   //pattle left speed
float prss;  //pattle right slow speed
float plss;  //pattle left slow speed
float pw;    //pattle width
float ph;    //pattle size
boolean lp;  //left pattle player:true=manual,falce=auto
boolean[] kC;/*check 8 key input(up,down,left,right,e,d,shift
                ,q) pressed = true ,released = falce*/ 
//gameplay property
int ptr;     //point right
int ptl;     //point left
int hc;      //hit count
int mp;      //match point
int dm;      //draw mode 1 = Classic,2 = Round, 3 = Balls, 4 = Meteor, 5 = Straight
int maxDM;   //max draw mode
boolean start;//draw start menu
boolean MP;  //true=>ends gameplay
PFont font;  //font
float[] sbX; //storage bX
float[] sbY; //storage bY
int n;       //count sbX,sbY
//color property
color bgc;   //back ground color
color pbc;   //pattle ball color
color fc;    //font color
color[] cp;  //color pallet
int z,x,c;   //color selector
int maxC;    //max color pallet number

/* abstract of functions
              setup() : sets up base settings, default settings, color pallet
         minorSetup() : resets pattle and ball's speed and position, points, key booleans,
                        without changing custom settings
               draw() : gameloop
     drawBackground() : draws background
      drawStartMenu() : draws start menu
           calcBall() : calculate ball movement
    calcRightPattle() : calculate right pattle movement
     calcLeftPattle() : calculate left pattle movement
  drawPattleAndBall() : draws ball and pattle
         drawPoints() : draws points.
       drawHitCount() : draws ball's hit count
         drawVictor() : draws victor
         keyPressed() : sets true to boolean keys. changes custom options
        keyReleased() : sets false to boolean keys
       calcAutoPong() : simulates auto pong.
*/


/*
  sets up base settings. 
*/
void setup()
{
  //base setting
  size(500,500);
  rectMode(CENTER);
  smooth();
  font = loadFont("Impact-48.vlw");
  textAlign(CENTER,CENTER);
  start = true;
  MP = false;
  dm = 1;
  maxDM = 5;
  
  //pattle and ball default size,position,speed
  bY = height/2;
  bsX = 2;  bsY = 0;  bs = 10;
  prX = width - 10;  plX = 10;
  prY = height/2;  plY = height/2;
  prs = prds = 6; 
  pls = plds = 6;
  prss = 2;
  plss = 2;
  pw = 5;  ph = 30;
  bX = plX + pw/2 + 10;
  tbsX = 0.5;  tbsY = 0.75;
  lp = false;
  kC = new boolean[8];
  kC[0] = false; kC[1] = false;//keyinput up,down
  kC[2] = false; kC[3] = false;//keyinput left,right
  kC[4] = false; kC[5] = false;//keyinput e,d
  kC[6] = false; kC[7] = false;//keyinput shift,q
  sbX = new float[15];
  sbY = new float[15];
  n=0;
  for(int i=0; i<15; i++){
    sbX[i] = bX;
    sbY[i] = bY;
  }
  
  //color setting
  colorMode(RGB,100);
  maxC = 7;
  cp = new color[maxC];
  cp[0] = color(99,99,99);  //white
  cp[1] = color(99,1,1);    //red
  cp[2] = color(99,50,1);   //orange
  cp[3] = color(1,99,10);   //green
  cp[4] = color(1,99,99);   //light blue
  cp[5] = color(1,1,99);    //blue
  cp[6] = color(1,1,1);     //black
  z = 0;  x = 6;  c = 1;
  bgc = cp[z]; pbc = cp[x]; fc = cp[c];
  
  //points and hitcount setting
  mp = 5; ptr = 0;  ptl = 0;  hc = 0;
}





/*
  resets pattle and ball's speed and position, points, key booleans,
  without changing custom settings
*/
void minorSetup()
{
  bY = height/2;
  bsX = 2;  bsY = 0;  bs = 10;
  prX = width - 10;  plX = 10;
  prY = height/2;  plY = height/2;
  prs = prds; 
  pls = plds;
  pw = 5;
  bX = plX + pw/2 + 10;
  tbsX = 0.5;
  kC[0] = false; kC[1] = false;//keyinput up,down
  kC[2] = false; kC[3] = false;//keyinput left,right
  kC[4] = false; kC[5] = false;//keyinput e,d
  kC[6] = false; kC[7] = false;//keyinput shift,q
  ptr = 0;  ptl = 0;  hc = 0;
}




/*
  gameloop.
  start menu -(choosed player number)> gameplay -(reached match point)> victor screen
  -(pressed left or right key)> start menu
*/
void draw()
{ 
  drawBackground();
  if(start){
    calcAutoPong();
    drawPattleAndBall();
    drawHitCount();
    drawStartMenu();
  }else{
    if(!MP){
      calcBall();
      calcRightPattle();
      calcLeftPattle();
      drawPattleAndBall();
      drawHitCount();
      drawPoints();
    }else{
      drawVictor();
    }
  }
}




/*
  draws background

*/
void drawBackground()
{
  rectMode(CORNER);
  noStroke();
  
  fill(bgc);
  
  rect(0,0,width,height);
  rectMode(CENTER);
}





/*
  start menu.
  title, player select, control, start game, options, values
  starts game by pressing LEFT or RIGHT
*/
void drawStartMenu()
{
  fill(fc);
  //title
  textFont(font,70); 
  text("PONG",width/2-width*0.025+bX*0.05,50+bY*0.05);
  textFont(font,20);
  text("UP&DOWN : Player Select",width/2,120);
  //text options
  textAlign(CORNER);
  text("M : Draw Mode",width/3,height-150);
  text("N : Match Point",width/3,height-130);
  text("B : Pattle Speed",width/3,height-110);
  text("V : Pattle Height",width/3,height-90);
  text("C : Font Color",width/3,height-70);
  text("X : Pattle Color",width/3,height-50);
  text("Z : Background Color",width/3,height-30);
  //draw values
  if(dm == 2){
    text(mp,width/3+175,height-129);
    text(prds,width/3+170,height-109);
    text(ph,width/3+170,height-89);
  }else{
    text(mp,width/3+154,height-129);
    text(prds,width/3+150,height-109);
    text(ph,width/3+150,height-89);
  }
  //draw modes
  switch(dm){
    case 1: text("Classic",width/3+153,height-149);
            break;
    case 2: text("Round",width/3+174,height-149);
            break;
    case 3: text("Balls",width/3+153,height-149);
            break;
    case 4: text("Meteor",width/3+153,height-149);
            break;
    case 5: text("Straight",width/3+153,height-149);
            break;
  }
  
  textAlign(CENTER,CENTER);
  textFont(font,30);
  
  //UPkey:1 player
  //DOWNkey:2 players
  if(kC[1]){ lp = true; }
  if(kC[0]){ lp = false; }
  if(lp){
    text("2 Player",width/2,height/2-60);
    textFont(font,20);
    text("LEFT&RIGHT : Start Game",width/2,height/2+50);
    textAlign(CORNER,CENTER);
    text("UP : Move Up",width/2+40,height/2-35+prY*0.05);
    text("DOWN : Move Down",width/2+40,height/2-15+prY*0.05);
    text("SHIFT : Slow Down",width/2+40,height/2+5+prY*0.05);
    text("E : Move Up",width/3-118,height/2-35+plY*0.05);
    text("D : Move Down",width/3-120,height/2-15+plY*0.05);
    text("Q : Slow Down",width/3-120,height/2+5+plY*0.05);
    textAlign(CENTER,CENTER);
  }else{
    text("1 Player",width/2,height/2-60);
    textFont(font,20);
    text("LEFT&RIGHT : Start Game",width/2,height/2+50);
    textAlign(CORNER,CENTER);
    text("UP : Move Up",width/2+40,height/2-35+prY*0.05);
    text("DOWN : Move Down",width/2+40,height/2-15+prY*0.05);
    text("SHIFT : Slow Down",width/2+40,height/2+5+prY*0.05);
    textAlign(CENTER,CENTER);
  }
  
  
  //LEFT or RIGHT key: starts game
  if(kC[2] || kC[3]){
    minorSetup();
    start = false;
    MP = false;
  }
}




/*
  changes ball speed, position, adds hitcounts, adds point, saves 15 ball position
*/
void calcBall()
{
  bX += bsX + tbsX * hc;
  bY += bsY;
  
  //pattle right hit call. inverts X speed, changes Y speed, adds hitcounts
  if(((prY - ph/2) <= (bY + bs/2)) && ((bY - bs/2) <= (prY + ph/2))){
    if((prX - pw/2) <= (bX + bs/2)){
      bsX = -bsX;
      tbsX = -tbsX;
      bsY = (bY - prY) * tbsY;
      hc++;
    }
  }
  //pattle left hit call. same as up
  if(((plY - ph/2) <= (bY + bs/2)) && ((bY - bs/2) <= (plY + ph/2))){
    if((plX + pw/2) >= (bX - bs/2)){
      bsX = -bsX;
      tbsX = -tbsX;
      bsY = (bY - plY) * tbsY;
      hc++;
    }
  }
  //ball edge reach call.
  if(width < bX || bX < 0){
    if(width < bX){ //serves ball to right player, adds point to left player
      bX = plX + pw/2 + 10;
      bsX = 2;
      ptl++;
    }else{ //if bX < 0, serves ball to left player, adds point to right player
      bX = prX + pw/2 - 10;
      bsX = -2;
      ptr++;
    }
    bY = height/2;
    bsY = 0;
    //reset hitcount
    hc = 0;
    //save 15 ball position
    for(int i=0; i<15; i++){
      sbX[i] = bX;
      sbY[i] = bY;
    }
    //check match point
    if((ptr == mp) || (ptl == mp)){ MP = true; }
  }
  //ball side reach call
  if((height < bY) || (bY < 0)){
    bsY = -bsY;
  }
}





void calcRightPattle()
{
  if(kC[6]){ prs = prss;}
  else{ prs = prds; }
  if(kC[0]) prY -= prs;
  if(kC[1]) prY += prs;
  //bottom and height restrain
  if((prY - ph/2) < 0) prY = ph/2;
  if(height < (prY + ph/2)) prY = height - ph/2;
}






void calcLeftPattle()
{ 
  //lp:true=>manual,false=>auto 
  if(lp){
    if(kC[7]){ pls = plss; }
    else{ pls = plds; }
    if(kC[4]) plY -= pls;
    if(kC[5]) plY += pls;
    //bottom and height restrain
    if((plY - ph/2) < 0) plY = ph/2;
    if(height < (plY + ph/2)) plY = height - ph/2;
  }else{
    //if ball comes left, follow bY
    //if ball goes right, go to center
    if(bsX < 0){
      if(plY > bY){plY -= pls;}
        else{ plY += pls;}
    }else{
      if(plY > (height/2 + 4)){ plY -= pls;}
      if((height/2 - 4) > plY){ plY += pls;}
    }
  }
}





void drawPattleAndBall()
{
  fill(pbc);
  switch(dm){
    //Classic
    case 1: noStroke();
            //draw ball
            rect(bX,bY,bs,bs);
            //draw right pattle
            rect(prX,prY,pw,ph);
            //draw left pattle
            rect(plX,plY,pw,ph);
            break;
            
    //Round
    case 2: //draw ball
            noStroke();
            ellipse(bX,bY,bs,bs);
            //draw right pattle
            stroke(pbc);
            strokeWeight(pw);
            line(prX,prY-(ph/2),prX,prY+(ph/2));
            //draw left pattle
            line(plX,plY-(ph/2),plX,plY+(ph/2));
            break;
            
    //Balls
    case 3: //draw ball effect
            strokeWeight(3);
            if(n < 14){
              sbX[n+1] = sbX[n];
              sbY[n+1] = sbY[n];
              sbX[n] = bX;
              sbY[n] = bY;
              n++;
            }else{ n = 0; }
            for(int i=0; i<14; i++){
              stroke(pbc);
              if(bsX < 0){
                ellipse(sbX[i]+random(0,bX/10),sbY[i]+random(-bX/20,bX/20),bs,bs);
              }else{
                ellipse(sbX[i]-random(0,width/10-bX/10),sbY[i]+random(bX/20-width/20,width/20-bX/20),bs,bs);
              }
            }
            //draw ball
            noStroke();
            ellipse(bX,bY,bs,bs);
            
            
            //draw right pattle
            stroke(pbc);
            strokeWeight(pw);
            line(prX,prY-(ph/2),prX,prY+(ph/2));
            //draw left pattle
            line(plX,plY-(ph/2),plX,plY+(ph/2));
            break;
            
    //Meteor
    case 4: //draw ball effect
            strokeWeight(3);
            if(n < 14){
              sbX[n+1] = sbX[n];
              sbY[n+1] = sbY[n];
              sbX[n] = bX;
              sbY[n] = bY;
              n++;
            }else{ n = 0; }
            for(int i=0; i<10; i++){
              stroke(pbc);
              if(bsX < 0){
                line(bX,bY,sbX[14]+random(0,bX/2),sbY[14]+random(-bX/2,bX/2));
              }else{
                line(bX,bY,sbX[14]-random(0,width/2-bX/2),sbY[14]+random(bX/2-width/2,width/2-bX/2));
              }
            }
            //draw ball
            noStroke();
            ellipse(bX,bY,bs,bs);
            
            
            //draw right pattle
            stroke(pbc);
            strokeWeight(pw);
            line(prX,prY-(ph/2),prX,prY+(ph/2));
            //draw left pattle
            line(plX,plY-(ph/2),plX,plY+(ph/2));
            
            
            //draw pattle effect
            stroke(fc);
            strokeWeight(3);
            for(int i=0; i<10; i++){
                line(prX+pw,prY,width,random(0,height));
                line(plX-pw,plY,0,random(0,height));
            }
            break;
            
    //Straight
    case 5: //draw ball
            strokeWeight(bs);
            stroke(pbc);
            line(width/2,bY,bX,bY);
            //draw right pattle
            strokeWeight(pw);
            stroke(fc);
            line(prX,0,prX,height);
            stroke(pbc);
            line(prX,prY-(ph/2),prX,prY+(ph/2));
            //draw left pattle
            stroke(fc);
            line(plX,0,plX,height);
            stroke(pbc);
            line(plX,plY-(ph/2),plX,plY+(ph/2));
            break;
  }
}






void drawPoints()
{
  textFont(font,50);
  fill(fc);
  
  text(ptl,width/2-50,50);
  text(ptr,width/2+50,50);
}





void drawHitCount()
{
  if(hc != 0){
    textFont(font,20);
    fill(fc);
    
    if(bsX > 0){
      text(hc,bX-15,bY);
    }else{
      text(hc,bX+15,bY);
    }
  }
}





void drawVictor()
{ 
  textFont(font,45);
  fill(fc);

  if(ptr == mp){
    if(lp){
      text("RIGHT PLAYER WINS!",width/2,height/2);
    }else{
      text("YOU WIN!",width/2,height/2);
    }
  }else{
    if(lp){
      text("LEFT PLAYER WINS!",width/2,height/2);
    }else{
      text("YOU LOSE!",width/2,height/2);
    }
  }
  
  //LEFT or RIGHT key: back to start menu
  textFont(font,20);
  text("LEFT or RIGHT : Back to Menu",width/2,height/2+50);
  if(kC[2] || kC[3]){
    minorSetup();
    start = true;
  }
}






/*
     up key : move right pattle up.     kC[0].  default false
   down key : move right pattle down.   kC[1].  default false
   left key : select.                   kC[2].  default false
  right key : select.                   kC[3].  default false
      e key : move left pattle up.      kC[4].  default false
      d key : move left pattle down.    kC[5].  default false
  shift key : slows right pattle speed. kC[6].  default false
      q key : slows left pattle speed.  kC[7].  default false
      m key : draw mode.  (default)dm = 1,classic / dm = 2,round / dm = 3,wacky.
      n key : match point.  1,2,3,4,(default)5,6,7,8,9,10.
      b key : pattle speed.  2,4,(default)6,8,10,12,14,16,18,20.
      v key : pattle height.  10,20,(default)30,40,50,60,70,80,90,100.
      c key : font color.        default 1,red
      x key : pattle color.      default 6,black
      z key : background color.  default 0,white
*/
void keyPressed()
{
  //move right pattle while key pressed
  if(key == CODED){
    if(keyCode == UP){kC[0] = true;}
    if(keyCode == DOWN){kC[1] = true;}
    if(keyCode == LEFT){kC[2] = true;}
    if(keyCode == RIGHT){kC[3] = true;}
    if(keyCode == SHIFT){kC[6] = true;}
  }
  //if lp=true, same as up
  if(lp){
    if(key == 'e'){kC[4] = true;}
    if(key == 'd'){kC[5] = true;}
    if(key == 'q'){kC[7] = true;}
  }
  
  
  //change back ground color
  if(key == 'z'){
    if(z != (maxC-1)){ z++; }
    else{ z = 0; }
  }
  //change pattle ball color
  if(key == 'x'){
    if(x != (maxC-1)){ x++; }
    else{ x = 0; }
  }
  //change font color
  if(key == 'c'){
    if(c != (maxC-1)){ c++; }
    else{ c = 0; }
  }
  bgc = cp[z]; 
  pbc = cp[x];
  fc = cp[c];
  
  
  //change pattle height 10~100 by 10 stages
  if(key == 'v'){
    if(ph < 100){
      ph = ph + 10;
      tbsY = tbsY - 0.05;
    }else{ 
    ph = 10;
    tbsY = 0.85;
    }
  }
  //change pattle speed 2~20 by 10 stages
  if(key == 'b'){
    if(prds < 20){
      prs = prds = prds + 2;
      pls = plds = plds + 2;
    }else{
      prs = pls= prds = plds = 2;
    }
  }
  //change match point 1~10 by 10 stage
  //only in start menu
  if(key == 'n'){
    if(start){
      if(mp < 10){
        mp++;
      }else{
        mp = 1;
      }
    }
  }
  //change draw mode
  if(key == 'm'){
    if(dm < maxDM){ dm++;}
    else{ dm = 1; }
    
    switch(dm){
        case 1: font = loadFont("Impact-48.vlw");
                break;
        case 2: font = loadFont("ArialRoundedMTBold-48.vlw");
                break;
        case 3: font = loadFont("MarkerFelt-Wide-48.vlw");
                break;
        case 4: font = loadFont("Cracked-48.vlw");
                break;
        case 5: font = loadFont("Bauhaus93-48.vlw");
                break;
    }
  }
}





/*
  need this function for multi key press and smooth animation
*/
void keyReleased()
{
  //stop right pattle from moving when key released
  if(key == CODED){
    if(keyCode == UP){kC[0] = false;}
    if(keyCode == DOWN){kC[1] = false;}
    if(keyCode == LEFT){kC[2] = false;}
    if(keyCode == RIGHT){kC[3] = false;}
    if(keyCode == SHIFT){kC[6] = false;}
  }
  //if lp = true, same as up
  if(lp){
    if(key == 'e'){kC[4] = false;}
    if(key == 'd'){kC[5] = false;}
    if(key == 'q'){kC[7] = false;}
  }
}





/*
  simulates auto pong movements.
*/
void calcAutoPong()
{
  bX += bsX + tbsX * hc;
  bY += bsY;
  
  //pattle right hit call
  if(((prY - ph/2) <= (bY + bs/2)) && ((bY - bs/2) <= (prY + ph/2))){
    if((prX - pw/2) <= (bX + bs/2)){
      bsX = -bsX;
      tbsX = -tbsX;
      bsY = (bY - prY) * tbsY;
      hc++;
    }
  }
  //pattle left hit call
  if(((plY - ph/2) <= (bY + bs/2)) && ((bY - bs/2) <= (plY + ph/2))){
    if((plX + pw/2) >= (bX - bs/2)){
      bsX = -bsX;
      tbsX = -tbsX;
      bsY = (bY - plY) * tbsY;
      hc++;
    }
  }
  //ball edge reach call
  if(width < bX || bX < 0){
    if(width < bX){ 
      bX = plX + pw/2 + 10;
      bsX = 2;
    }else{ //if bX < 0
      bX = prX + pw/2 - 10;
      bsX = -2;
    }
    bY = height/2;
    bsY = 0;
    hc = 0;
    for(int i=0; i<15; i++){
      sbX[i] = bX;
      sbY[i] = bY;
    }
  }
  //ball side reach call
  if((height < bY) || (bY < 0)){
    bsY = -bsY;
  }
  
  
  //move auto pattle 
  if(bsX < 0){
      //left pattle deffense mode
      if(plY > bY){plY -= pls;}
      else{ plY += pls;}
      
      //right pattle return to center
      if(prY > (height/2 + 4)){ prY -= prs;}
      if((height/2 - 4) > prY){ prY += prs;}
  }else{
      //left pattle return to center
      if(plY > (height/2 + 4)){ plY -= pls;}
      if((height/2 - 4) > plY){ plY += pls;}
      
      //right pattle deffense mode
      if(prY > bY){prY -= prs;}
      else{ prY += prs;}
  }
}
