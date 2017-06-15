PImage back;

void setup() {
back = new PImage("data/Map of the Americas.png")
  size(2000,2016);
  background(255, 0, 0);
  fill(0, 255, 0);
}

void draw() {
  background(back);
  ellipse(mouseX, mouseY, 25, 25);
}
