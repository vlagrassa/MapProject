response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Credentials", "true");
response.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
response.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");

void setup() {
  size(500,500);
  background(255, 0, 0);
  fill(0, 255, 0);
}

void draw() {
  background(255, 0, 0);
  ellipse(mouseX, mouseY, 25, 25);
}
