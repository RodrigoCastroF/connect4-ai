void setup() {
  
  size(700, 600);
  
}

void draw() {
  
  background(0, 116, 179);  // blue color
  
  final int cols = 7;  // "final" is the "const" of Java for primitives; see https://www.javamex.com/java_equivalents/const_java.shtml
  final int rows = 6;

  // diameter of circles and margin between them
  final float diameter = width/10;
  final float margin = width/cols - diameter;
  
  // give the outline of the circles a darker blue color and make it thicker
  stroke(1, 74, 114);
  strokeWeight(5);
  
  // show the circles
  for (int col = 0; col <= cols; col++) {
    for (int row = 0; row <= rows; row++) {
      ellipse(width*col/cols + diameter/2 + margin/2, height*row/rows + diameter/2 + margin/2, diameter, diameter);
    }
  }
  
}
