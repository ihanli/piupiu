//int i;
float[]a=new float[18];

void setup(){
  size(330,240);
  background(255);
  frameRate(400);
    smooth();
}


void draw(){
  if(mousePressed){
  fill(0,0,0);
  stroke(0,0,0);
  a[9]=mouseY;
  a[0]=mouseX;
  for(int i=0;++i<9;){
  line(a[i],a[i+9],a[i]+=(a[i-1]-a[i])/i,a[i+9]+=(a[i+8]-a[i+9])/i);}

  }

}
