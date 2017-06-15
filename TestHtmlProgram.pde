/* @pjs preload="data/Map of the Americas.png" */

PImage back;

void setup() {
  back = new PImage("data/Map of the Americas.png")
  size(2000,2016);
  background(255, 0, 0);
  fill(0, 255, 0);
}

void draw() {
  try {
    background(back);
  } catch (Exception e) {
    background(0, 0, 255);
  }
  ellipse(mouseX, mouseY, 25, 25);
}
