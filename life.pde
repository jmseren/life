/* Conway's Game of Life */
/* Jayden Serenari 2021 */


/* 
  This was not written to be an example of good code,
  but instead was written to see how fast I could get it working.
  It took me about an hour and a half to write the code below, with almost 0
  prior knowledge of Processing but with prior knowledge in Java programming. 
*/


color DEAD = color(0);
color ALIVE = color(255);

final int cellSize = 10;
int cellW = -1;
int cellH = -1;

final int runningDelay = 150;
final int pauseDelay = 25;

boolean running = false;

boolean cellMap[];
boolean tempMap[];
void drawMap(){
  for(int y = 0; y < cellH; y++){
     for(int x = 0; x < cellW; x++){
       color status = readCell(x, y) ? ALIVE : DEAD;
       fill(status);
       rect(x*cellSize, y*cellSize, cellSize, cellSize);
     }
  }
}


boolean readCell(int x, int y){
  int absoluteLocation = (y * cellW) + x;
  return cellMap[absoluteLocation];
}

void placeCell(int x, int y, boolean status){
  int absoluteLocation = (y * cellW) + x;
  cellMap[absoluteLocation] = status;
}

void placeTempCell(int x, int y, boolean status){
  int absoluteLocation = (y * cellW) + x;
  tempMap[absoluteLocation] = status;
}


int neighbors(int x, int y){
  int total = 0;
  for(int yy = y - 1; yy < y + 2; yy++){
    for(int xx = x - 1; xx < x + 2; xx++){
      if(xx < 0 || xx >= cellW || yy < 0 || yy >= cellH || (xx == x && yy == y) ) continue;
      total += readCell(xx, yy) ? 1 : 0;
    }
  }
  return total;
}

void mousePressed(){
  int x = mouseX;
  int y = mouseY;
  int mapx = floor(x / cellSize);
  int mapy = floor(y / cellSize);
  placeCell(mapx, mapy, !readCell(mapx, mapy) );
}

void keyPressed(){
    if(key == ' '){
      running = !running;
    }else if(key == 'n'){
      int x = mouseX;
      int y = mouseY;
      int mapx = floor(x / cellSize);
      int mapy = floor(y / cellSize);
      
      print(neighbors(mapx, mapy));
      
    }else if(key == CODED){
      if(!running && keyCode == RIGHT){
        cglife();
      }
    }
}

void setup(){
  size(400, 400);
  background(0, 0, 0);
  cellW = width / cellSize;
  cellH = height / cellSize;
  cellMap = new boolean[cellW * cellH];
  tempMap = new boolean[cellMap.length];
  loop();
}



void cglife() {
  tempMap = new boolean[cellMap.length];
  int n = -1;
  for(int y = 0; y < cellH; y++){
    for(int x = 0; x < cellW; x++){
      n = neighbors(x, y);
      if(n <= 1){
        placeTempCell(x, y, false);
      }else if(n == 2){
        placeTempCell(x, y, readCell(x, y));
      }else if(n == 3){
        placeTempCell(x, y, true);
      }else if(n > 3){
        placeTempCell(x, y, false);
      }
    }
  }
  cellMap = tempMap;
}

void draw(){
  if(running) cglife();
  drawMap();
  delay(running ? runningDelay : pauseDelay);
}
