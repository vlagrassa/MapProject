/* @pjs preload="https://raw.githubusercontent.com/vlagrassa/MapProject/master/data/Map%20of%20the%20Americas.png" */

PImage back;

void setup() {
  back = new PImage("https://raw.githubusercontent.com/vlagrassa/MapProject/master/data/Map%20of%20the%20Americas.png")
  back.loadPixels();
  for (int i = 0; i < back.pixels.length; i++) {
    back.pixels[i] = color(0, 255, 0);
  }
  size(2000,2016);
  background(255, 0, 0);
  fill(0, 255, 0);
}

void draw() {
  background(back);
  ellipse(mouseX, mouseY, 25, 25);
}
