//To play game point and click on the Cue ball.
//Sink all the balls to win.
//Hold w or s to change the power of your shot
import ddf.minim.*; //importing sound library
AudioPlayer player; 
AudioPlayer player1;
AudioPlayer player2;
AudioPlayer player3;
Minim minim;

class Point
{
 float x, y;
 Point (float a, float b)
 {
 x = a;
 y = b;
 }
}

class Ball
{
 float rad;
 Point center;
 Point contact_point;
 color col;
 PVector velocity;
 Ball()
 {
 
 }
 Ball(float a, color b,float c,float d)
 {
   rad=a;
   col=b;
   center=new Point(c,d);
   velocity= new PVector(0,0);
 }
 
 Ball(float a, float b)
 {
   contact_point=new Point(a,b);
 }
 
 Ball(PVector a)
 {
   velocity=a;
 }
 
 void drawball() //draws ball in a specific spot
 {
   fill(col);
   ellipse(center.x,center.y,rad*2,rad*2);
 }
 
 void move() //Adding velocity to the ball based on the gain PVector
 {
   center.x=center.x+velocity.x;
   center.y=center.y+velocity.y;
 }
 
 void bounce() //used to bounce the balls off of the side walls
 {
   if(center.x<1280&&center.x>0&&center.y>0&&center.y<720){
   if((center.x+rad>width-50)||(center.x-rad<0+50))
   {
     velocity.x*=-1;
     player1.play();
     player1.rewind();
   }
   if((center.y+rad>height-50)||(center.y-rad<0+50))
   {
     velocity.y*=-1;
     player1.play();
     player1.rewind();
   }
   }
 }
 void acceleration() //used to decellerate the balls
 {
 velocity.x*=0.99;
 velocity.y*=0.99;
 }
}

class Stick
{
 Point start_p;
 Point end_p;
 float col; //color of the pool stick
 int length; //length of the pool stick
 PVector CueM;
 Stick(int a, float b)
 {
   length=a;
   col=b;
   start_p=new Point(mouseX,mouseY);
   end_p=new Point(10,10);
   CueM=new PVector();
 }
}

class Table
{
 Ball [] b_arr; //the length of this array can be 1 for
 Ball cue_ball; //iteration 3
 Stick st;
 Table(int a, float b)
 { 
   st=new Stick(a,b);
   b_arr=new Ball[6];
   b_arr[0]= new Ball(20,#0658db,1280/4*3,720/2); //blue
   b_arr[1]= new Ball(20,#e20404,1280/4*3+45,720/2+25); //red
   b_arr[2]= new Ball(20,#fff607,1280/4*3+45,720/2-25); //yellow
   b_arr[3]= new Ball(20,#ff9707,1280/4*3+85,720/2+45); //orange
   b_arr[4]= new Ball(20,#c907ff,1280/4*3+85,720/2); //purple
   b_arr[5]= new Ball(20,#07fff6,1280/4*3+85,720/2-45); //turquoise
 }
}

void setup()
{
  size(1280,720);
  minim=new Minim(this); //loading sounds in
  player=minim.loadFile("CueHit.mp3",2048);
  player1=minim.loadFile("Rebound.wav",2048);
  player2=minim.loadFile("PoolBalls1.mp3",1024);
  player3=minim.loadFile("Pocket.mp3",2048);
}

//GLOBAL VARIABLES
float xcolor=1;
Table table=new Table(250,xcolor);
int Cuex=1280/4;
int Cuey=720/2;
Ball Cue= new Ball(20,255,Cuex,Cuey);
int Count=0;   //Used to count balls sunk
int endgame=0; //Used trigger reset


void draw()
{
  drawtable();
  Cue.drawball();
  textSize(25);
  text("Balls Sunk "+str(Count),1280/4-75,35);
  table.b_arr[0].drawball();
  table.b_arr[1].drawball();
  table.b_arr[2].drawball();
  table.b_arr[3].drawball();
  table.b_arr[4].drawball();
  table.b_arr[5].drawball();
  drawstick();
  power();
  pointer();
  Cue.move();
  Contact();
  Contact2();
  table.b_arr[0].move();
  table.b_arr[1].move();
  table.b_arr[2].move();
  table.b_arr[3].move();
  table.b_arr[4].move();
  table.b_arr[5].move();
  Cue.bounce();
  table.b_arr[0].bounce();
  table.b_arr[1].bounce();
  table.b_arr[2].bounce();
  table.b_arr[3].bounce();
  table.b_arr[4].bounce();
  table.b_arr[5].bounce();
  Cue.acceleration();
  table.b_arr[0].acceleration();
  table.b_arr[1].acceleration();
  table.b_arr[2].acceleration();
  table.b_arr[3].acceleration();
  table.b_arr[4].acceleration();
  table.b_arr[5].acceleration();
  gameover1();
  gameover2();
}

void drawtable() //Requires: Nothing 
{                //Promises: to Draw a pool table
  int side=50; //how big the sides of the table are
  int d=60;    //the diameter of the pockets
  fill(1,175,36);
  rect(0,0,width,height); //felt
  fill(175,103,1);
  rect(0,0,width,side);  //sides
  rect(0,height-side,width,side);
  rect(0,0,side,height);
  rect(width-side,0,width-side,height);
  fill(0);
  ellipse(side,side,d,d); //pockets
  ellipse(width/2,side,d,d);
  ellipse(width-side,side,d,d);
  ellipse(side,height-side,d,d);
  ellipse(width/2,height-side,d,d);
  ellipse(width-side,height-side,d,d);
  stroke(255);
  strokeWeight(3);
  line(width/4,side,width/4,height-side);
  stroke(0);
  strokeWeight(1);
}

void mousePressed () //Fuction used to shoot the Cue Ball
{                    //also used to reset game with a click
  if(dist(Cue.center.x,Cue.center.y,mouseX,mouseY)<=20)
  {
     player.play();
     player.rewind();
     Cue.contact_point=new Point(mouseX,mouseY);
     PVector CueV = new PVector(((Cue.center.x-Cue.contact_point.x)/2)*(1+(xcolor/255)),((Cue.center.y-Cue.contact_point.y)/2)*(1+(xcolor/255)));
     Cue.velocity=CueV;
  }
  if(endgame>0)
  {
     xcolor=1;
     table=new Table(250,xcolor);
     Cuex=1280/4;
     Cuey=720/2;
     Cue.center.x=Cuex;
     Cue.center.y=Cuey;
     Cue.velocity.x=0;
     Cue.velocity.y=0;
     Count=0;
     endgame=0;

  }
}

void power() //REQUIRES: Nothing
{            //PROMISES: Changes a value to a number between 0-255 based
 if(keyPressed&&xcolor>0&&xcolor<255){ //on W and S keypresses
   if(key=='w'||key=='W')
   {
     xcolor+=5;
   }
   if(key=='s'||key=='S')
   {
    xcolor-=5; 
   }
 }
 else if(keyPressed&&(xcolor>255))
 {
   xcolor=254;
 }
 else if(keyPressed&&(xcolor<0))
 {
   xcolor=1; 
 } 
}

void pointer() //REQUIRES: Nothing
{              //PROMISES: To create an object at your cusor with a color
  fill(0+xcolor,0,255-xcolor); //based on the power of your shot
  ellipse(mouseX,mouseY,10,10);
}

void gameover1() //REQUIRES: Nothing
{                //PROMISES: To end the game and to display "gameover" when the cue ball is shot into a pocket.
  if(dist(Cue.center.x,Cue.center.y,50,50)<30||dist(Cue.center.x,Cue.center.y,640,50)<25||dist(Cue.center.x,Cue.center.y,1280-50,50)<30||dist(Cue.center.x,Cue.center.y,50,720-50)<30||dist(Cue.center.x,Cue.center.y,1280/2,720-50)<25||dist(Cue.center.x,Cue.center.y,1280-50,720-50)<30)
  {
    Cue.center.x=9000;
    Cue.center.y=9000;
  }
  gameovertext1();
}

void gameovertext1() //REQUIRES: Nothing
{                    //Promises: To end the game and display"gameover" if Cue is out of bounds
  if(Cue.center.x>1280||Cue.center.x<0)
  {
  textSize(50);
  text("GAME OVER: Click The Screen To Play Again",100,360);
  endgame++;
  }
}

void stop(){ //REQUIRES: Nothing
  player.close(); //Promises: To put an end to the players and any background processes.
  minim.stop();
  super.stop();
}

void drawstick() //REQUIRES: Nothing
{                //Promises: To draw a pool cue with the color based on your shot power.
 strokeWeight(5);
 stroke(0+xcolor,0,255-xcolor);
 table.st.start_p.x=mouseX;
 table.st.start_p.y=mouseY;
 table.st.CueM.x=Cue.center.x-mouseX;
 table.st.CueM.y=Cue.center.y-mouseY;
 table.st.CueM.normalize();
 table.st.CueM.x*=table.st.length;
 table.st.CueM.y*=table.st.length;
 line(table.st.start_p.x,table.st.start_p.y,mouseX-table.st.CueM.x,mouseY-table.st.CueM.y);
 strokeWeight(1);
 stroke(0);
}

void Contact() //Checks to see if you Cue is contacting any balls
{              //Calculates outgoing velocitys
 for(int i=0; i<6;i++)
 {
 if(dist(Cue.center.x,Cue.center.y,table.b_arr[i].center.x,table.b_arr[i].center.y)<=40)
 {
  float k=((Cue.velocity.x-table.b_arr[i].velocity.x)*(Cue.center.x-table.b_arr[i].center.x)+(Cue.velocity.y-table.b_arr[i].velocity.y)*(Cue.center.y-table.b_arr[i].center.y))/((Cue.center.x-table.b_arr[i].center.x)*(Cue.center.x-table.b_arr[i].center.x)+(Cue.center.y-table.b_arr[i].center.y)*(Cue.center.y-table.b_arr[i].center.y));
  table.b_arr[i].velocity.x= table.b_arr[i].velocity.x-k*(table.b_arr[i].center.x-Cue.center.x);
  table.b_arr[i].velocity.y= table.b_arr[i].velocity.y-k*(table.b_arr[i].center.y-Cue.center.y);
  Cue.velocity.x= Cue.velocity.x-k*(Cue.center.x-table.b_arr[i].center.x);
  Cue.velocity.y= Cue.velocity.y-k*(Cue.center.y-table.b_arr[i].center.y);
  player2.play();
  player2.rewind();
 }
 }
}

void Contact2() //Checks for contact between all balls and eachother,
{               //not the Cue. Note: This is a very long function because I could not get the collisions to work only using 2 for loops.
  for(int i=0; i<6;i++)
 {
   if(i!=0&&dist(table.b_arr[0].center.x,table.b_arr[0].center.y,table.b_arr[i].center.x,table.b_arr[i].center.y)<=40)
   {
   float k=((table.b_arr[0].velocity.x-table.b_arr[i].velocity.x)*(table.b_arr[0].center.x-table.b_arr[i].center.x)+(table.b_arr[0].velocity.y-table.b_arr[i].velocity.y)*(table.b_arr[0].center.y-table.b_arr[i].center.y))/((table.b_arr[0].center.x-table.b_arr[i].center.x)*(table.b_arr[0].center.x-table.b_arr[i].center.x)+(table.b_arr[0].center.y-table.b_arr[i].center.y)*(table.b_arr[0].center.y-table.b_arr[i].center.y));
   table.b_arr[i].velocity.x= table.b_arr[i].velocity.x-k*(table.b_arr[i].center.x-table.b_arr[0].center.x);
   table.b_arr[i].velocity.y= table.b_arr[i].velocity.y-k*(table.b_arr[i].center.y-table.b_arr[0].center.y);
   table.b_arr[0].velocity.x= table.b_arr[0].velocity.x-k*(table.b_arr[0].center.x-table.b_arr[i].center.x);
   table.b_arr[0].velocity.y= table.b_arr[0].velocity.y-k*(table.b_arr[0].center.y-table.b_arr[i].center.y);
   player2.play();
   player2.rewind();
   }
   if(i!=1&&i!=0&&dist(table.b_arr[1].center.x,table.b_arr[1].center.y,table.b_arr[i].center.x,table.b_arr[i].center.y)<=40)
   { 
   float k=((table.b_arr[1].velocity.x-table.b_arr[i].velocity.x)*(table.b_arr[1].center.x-table.b_arr[i].center.x)+(table.b_arr[1].velocity.y-table.b_arr[i].velocity.y)*(table.b_arr[1].center.y-table.b_arr[i].center.y))/((table.b_arr[1].center.x-table.b_arr[i].center.x)*(table.b_arr[1].center.x-table.b_arr[i].center.x)+(table.b_arr[1].center.y-table.b_arr[i].center.y)*(table.b_arr[1].center.y-table.b_arr[i].center.y));
   table.b_arr[i].velocity.x= table.b_arr[i].velocity.x-k*(table.b_arr[i].center.x-table.b_arr[1].center.x);
   table.b_arr[i].velocity.y= table.b_arr[i].velocity.y-k*(table.b_arr[i].center.y-table.b_arr[1].center.y);
   table.b_arr[1].velocity.x= table.b_arr[1].velocity.x-k*(table.b_arr[1].center.x-table.b_arr[i].center.x);
   table.b_arr[1].velocity.y= table.b_arr[1].velocity.y-k*(table.b_arr[1].center.y-table.b_arr[i].center.y);
   player2.play();
   player2.rewind();
  }
  if(i!=1&&i!=0&&i!=2&&dist(table.b_arr[2].center.x,table.b_arr[2].center.y,table.b_arr[i].center.x,table.b_arr[i].center.y)<=40)
   { 
   float k=((table.b_arr[2].velocity.x-table.b_arr[i].velocity.x)*(table.b_arr[2].center.x-table.b_arr[i].center.x)+(table.b_arr[2].velocity.y-table.b_arr[i].velocity.y)*(table.b_arr[2].center.y-table.b_arr[i].center.y))/((table.b_arr[2].center.x-table.b_arr[i].center.x)*(table.b_arr[2].center.x-table.b_arr[i].center.x)+(table.b_arr[2].center.y-table.b_arr[i].center.y)*(table.b_arr[2].center.y-table.b_arr[i].center.y));
   table.b_arr[i].velocity.x= table.b_arr[i].velocity.x-k*(table.b_arr[i].center.x-table.b_arr[2].center.x);
   table.b_arr[i].velocity.y= table.b_arr[i].velocity.y-k*(table.b_arr[i].center.y-table.b_arr[2].center.y);
   table.b_arr[2].velocity.x= table.b_arr[2].velocity.x-k*(table.b_arr[2].center.x-table.b_arr[i].center.x);
   table.b_arr[2].velocity.y= table.b_arr[2].velocity.y-k*(table.b_arr[2].center.y-table.b_arr[i].center.y);
   player2.play();
   player2.rewind();
   }
   if(i!=1&&i!=0&&i!=2&&i!=3&&dist(table.b_arr[3].center.x,table.b_arr[3].center.y,table.b_arr[i].center.x,table.b_arr[i].center.y)<=40)
   { 
   float k=((table.b_arr[3].velocity.x-table.b_arr[i].velocity.x)*(table.b_arr[3].center.x-table.b_arr[i].center.x)+(table.b_arr[3].velocity.y-table.b_arr[i].velocity.y)*(table.b_arr[3].center.y-table.b_arr[i].center.y))/((table.b_arr[3].center.x-table.b_arr[i].center.x)*(table.b_arr[3].center.x-table.b_arr[i].center.x)+(table.b_arr[3].center.y-table.b_arr[i].center.y)*(table.b_arr[3].center.y-table.b_arr[i].center.y));
   table.b_arr[i].velocity.x= table.b_arr[i].velocity.x-k*(table.b_arr[i].center.x-table.b_arr[3].center.x);
   table.b_arr[i].velocity.y= table.b_arr[i].velocity.y-k*(table.b_arr[i].center.y-table.b_arr[3].center.y);
   table.b_arr[3].velocity.x= table.b_arr[3].velocity.x-k*(table.b_arr[3].center.x-table.b_arr[i].center.x);
   table.b_arr[3].velocity.y= table.b_arr[3].velocity.y-k*(table.b_arr[3].center.y-table.b_arr[i].center.y);
   player2.play();
   player2.rewind();
   }
   if(i!=1&&i!=0&&i!=2&&i!=3&&i!=4&&dist(table.b_arr[4].center.x,table.b_arr[4].center.y,table.b_arr[i].center.x,table.b_arr[i].center.y)<=40)
   { 
   float k=((table.b_arr[4].velocity.x-table.b_arr[i].velocity.x)*(table.b_arr[4].center.x-table.b_arr[i].center.x)+(table.b_arr[4].velocity.y-table.b_arr[i].velocity.y)*(table.b_arr[4].center.y-table.b_arr[i].center.y))/((table.b_arr[4].center.x-table.b_arr[i].center.x)*(table.b_arr[4].center.x-table.b_arr[i].center.x)+(table.b_arr[4].center.y-table.b_arr[i].center.y)*(table.b_arr[4].center.y-table.b_arr[i].center.y));
   table.b_arr[i].velocity.x= table.b_arr[i].velocity.x-k*(table.b_arr[i].center.x-table.b_arr[4].center.x);
   table.b_arr[i].velocity.y= table.b_arr[i].velocity.y-k*(table.b_arr[i].center.y-table.b_arr[4].center.y);
   table.b_arr[4].velocity.x= table.b_arr[4].velocity.x-k*(table.b_arr[4].center.x-table.b_arr[i].center.x);
   table.b_arr[4].velocity.y= table.b_arr[4].velocity.y-k*(table.b_arr[4].center.y-table.b_arr[i].center.y);
   player2.play();
   player2.rewind();
   }
 }
}

void gameovertext2() //REQUIRES: Nothing
{                    //Promises: To end the game and display"gameover" if a ball is out of bounds
  if((table.b_arr[0].center.x>1280||table.b_arr[0].center.x<0)&&(table.b_arr[1].center.x>1280||table.b_arr[1].center.x<0)&&(table.b_arr[2].center.x>1280||table.b_arr[2].center.x<0)&&(table.b_arr[3].center.x>1280||table.b_arr[3].center.x<0)&&(table.b_arr[4].center.x>1280||table.b_arr[4].center.x<0)&&(table.b_arr[5].center.x>1280||table.b_arr[5].center.x<0))
  {
  textSize(50);
  text("YOU WIN: Click The Screen To Play Again",100,360);
  endgame++;
  }
}

void gameover2() //REQUIRES: Nothing
{                //PROMISES: To end the game and to display "You Win" when the ball is shot into a pocket.
  for(int i=0;i<6;i++){
  if(dist(table.b_arr[i].center.x,table.b_arr[i].center.y,50,50)<45||dist(table.b_arr[i].center.x,table.b_arr[i].center.y,640,50)<35||dist(table.b_arr[i].center.x,table.b_arr[i].center.y,1280-50,50)<45||dist(table.b_arr[i].center.x,table.b_arr[i].center.y,50,720-50)<45||dist(table.b_arr[i].center.x,table.b_arr[i].center.y,1280/2,720-50)<35||dist(table.b_arr[i].center.x,table.b_arr[i].center.y,1280-50,720-50)<45)
  {
    table.b_arr[i].center.x=random(3000,20000);
    table.b_arr[i].center.y=random(3000,20000);
    table.b_arr[i].velocity.x=0;
    table.b_arr[i].velocity.y=0;
    Count++;
    player3.play();
    player3.rewind();
  }
  }
  gameovertext2();
}