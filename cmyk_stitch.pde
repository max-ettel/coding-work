PImage cyan;
PImage magenta;
PImage yellow;
PImage black;
PImage img;

//determines the size of the cells for individual channels

int c_cell = 10;
int m_cell = 10;
int y_cell = 10;
int b_cell = 10;

//determines maximum amount of movement within the cell
float mv_max = 15;

//do not modify process variable
int process = 1;

//determines the minimum and maximum stroke for the lines
float strokeMin = 0.25;
float strokeMax = 5;

void setup(){
  // set size to image size
  size(3000,2000);
  
  //place cyan channel here here
  cyan = loadImage("test_cyan.jpg");
  
  //place magenta channel image here
  magenta = loadImage("test_magenta.jpg");
  
  //place yellow channel image here
  yellow = loadImage("test_yellow.jpg");
  
  //place black channel image here
  black = loadImage("test_key.jpg");

}

void draw(){
  background(255);
  
  if (process==1){
   linePattern(cyan, c_cell);
   process=2;
   saveFrame("cyan_####.jpg");
  }
  
  else if (process==2){
   linePattern(magenta, m_cell);
   process=3;
   saveFrame("magenta_####.jpg");
  }
  
  else if (process==3){
   linePattern(yellow, y_cell);
   process=4;
   saveFrame("yellow_####.jpg");
  }
  
  else if (process==4){
   linePattern(black, b_cell);
   process=5;
   saveFrame("key_####.jpg");
  }
  
  else {
    exit();
  }
  

  

}


// this is the function that processes the images
void linePattern(PImage lineImg, int cellsize){
  background(255);
  stroke(0);
  
  //determines direction of the link pattern
  int direction = 1;
  
  //cell level loops
  for (int cX = 0; cX<lineImg.width; cX+=cellsize){
   for (int cY = 0; cY<lineImg.height; cY+=cellsize){

      // getting average brightness of the cell
     float cSum = 0;
       for (int pX = cX; pX<cX+cellsize && pX<lineImg.width; pX++){
          for (int pY = cY; pY<cY+cellsize && pY<lineImg.height; pY++){
             int index = pX+pY*width;
             float pBright = brightness(lineImg.pixels[index]);
             cSum+=pBright;
          }
       }
       
       float cAvg = cSum/(cellsize*cellsize);

       //stroke weight 
       float strk = map(cAvg,0,255,strokeMax,strokeMin);
       strokeWeight(strk);
       
       //spacing 
       float spacer = floor(map(cAvg,0,255,1,10));
       
       //line movement
       float lMv = map(cAvg,0,255,0,mv_max);
       
       //lines
       for (int i=cX; i<cX+cellsize; i+=spacer){
         
         if (direction==1){
           float t_mv = i-lMv;
           float b_mv = i+lMv;
           float yt = cY;
           float yb = cY+cellsize;
           if (t_mv < cX){
             yt = cY+(cX-(i-lMv));
             t_mv = cX;
           }
           
           else {
            t_mv = i-lMv; 
           }
           
           if (b_mv > cX+cellsize){
            yb = (cY+cellsize)-(b_mv-(cX+cellsize));
            b_mv = cX+cellsize;
           }
         line(t_mv,yt,b_mv,yb);
         }
         
         else {
           float t_mv = i+lMv;
           float b_mv = i-lMv;
           float yt = cY;
           float yb = cY+cellsize;
           
           if (t_mv > cX){
             yt = cY+((i+lMv)-(cX+cellsize));
             t_mv = cX;
           }
           
           else {
            t_mv = i+lMv; 
           }
           
           if (b_mv > cX+cellsize){
            yb = (cY+cellsize)-(cX-(i-lMv));
            b_mv = cX;
           }
           
          line(t_mv,yt,b_mv,yb); 

         }
       }
       
      if (direction==1){
      direction = 2;
      }
      
      else {
       direction=1; 
      }
        
      
   }
  }
}
