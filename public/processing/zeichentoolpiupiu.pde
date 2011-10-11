/////////////////////////////////
//Simple Sketching
//by Manuel Eisl
//latest changes: 110531
//

int amnt = 3;
int offset = 5;
Linie[] linie = new Linie[amnt];  

void setup(){
  size(330,240,P2D);
  smooth();
  background(255);
  for(int i=0;i<amnt;i++){
    linie[i] = new Linie();
  }
  strokeWeight(1);
}

void draw(){     //   strokeWeight(random(4));

  for(int i=0;i<amnt;i++){
    linie[i].update();
    if(mousePressed){

      linie[i].display();
    }
  }
}

class Linie{

  float[] _x = new float[offset];
  float[] _y = new float[offset];
  
  Linie() {
   //never mind
  }
  
  void update(){
    for(int i=0;i<_x.length-1;i++){

 // für einen bissl kaputteren pinsel
/*      _x[i]=_x[i+1]+random(-2,2);
      _y[i]=_y[i+1]+random(-2,2);
  */  
      _x[i]=_x[i+1];
      _y[i]=_y[i+1];
     
  }
    _x[_x.length-1]=mouseX+random(-2,1);
    _y[_y.length-1]=mouseY+random(-2,1);
  }
  
  void display(){
    
    fill(0);
      for(int i=0;i<_x.length-1;i++){
        line(
          _x[i],_y[i],
          _x[_x.length-1],_y[_y.length-1]
        );    
      }
    }
}

void keyReleased(){
  background(255);
}

