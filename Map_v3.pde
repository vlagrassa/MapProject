static int scrX; //1000 vs 1366
static int scrY; //600 vs 768
static int winX;
static int winY;
Coordinate backCoords, mouse;

File maplist;
String[] listOfItems;
ArrayList<MapItem> mapItems;
Button seeMore, backToMap;

PImage back, minimap;
Sidebar sidebar;
float minCenX, minCenY;
Bounds bounds, miniBounds;

MapItem selected = null;
int menu = 0; //Intro, Map, Bio

int setMenu, wid, wv;

Timeline timeline;
int globalStartTime, globalEndTime;

float scroll;


void setup() {
  //  Set up screen height and width  //
  size(1366,768); //1229, 691
  scrX = width;
  scrY = height;
  
  
  //  Retrieve map items from file and print  //
  mapItems = new ArrayList<MapItem>();
  //maplist = new File("//Users/student/Documents/Processing/Map_2_0/Map Items");
  maplist = new File("data/Map Items");
  listOfItems = maplist.list();
  println((Object)maplist.listFiles());
  
  //  Initialize item folders as individual map items  //
  for (int i = 0; i < listOfItems.length; i++) {
    if (! listOfItems[i].contains(".DS_Store")) {
      try {
        mapItems.add(new DatedMapItem(listOfItems[i]));
      } catch (Exception e) {
        println("Error: Previous Item Retracted");
        mapItems.add(new MapItem(listOfItems[i]));
      }
    }
  }
  
  
  //  Set up the background image  //
  imageMode(CENTER);
  back = loadImage("data/Map of the USA.png");
  winX = (back.width) / 2;
  winY = (back.height) / 2;
  backCoords = Coordinate.initCoords(winX, winY);
  
  
  //  Set up sidebar and minimap  //
  minimap = back.copy();
  minimap.resize(back.width/10, back.height/10);
  sidebar = new Sidebar((int) (minimap.width * 1.2));
  wid = sidebar.wid;
  
  
  //  Establish boundaries for Map and Minimap  //
  int temp[] = new int[4];
  temp[0] = (int) (scrX/2 - sidebar.wid);
  temp[1] = (int) (back.width-scrX/2);
  temp[2] = (int) (scrY/2);
  temp[3] = (int) (back.height-scrY/2);
  bounds = new Bounds(temp);
  
  temp = new int[4];
  temp[0] = (int) (minimap.width*0.6 - minimap.width/2 + (scrX-sidebar.wid)/20);
  temp[1] = (int) (minimap.width*0.6 + minimap.width/2 - (scrX-sidebar.wid)/20);
  temp[2] = (int) (scrY - minimap.height*0.6 - minimap.height/2 + scrY/20);
  temp[3] = (int) (scrY - minimap.height*0.6 + minimap.height/2 - scrY/20);
  miniBounds = new Bounds(temp);
  
  
  //  Establish Buttons  //
  seeMore = new Button((int)(minimap.width*0.6), (int) (scrY - minimap.height*1.2 - minimap.height*.5), minimap.width, 35 ,"See More");
  backToMap = new Button((int)(minimap.width*0.6), (int) (scrY - minimap.height*1.2 - minimap.height*.5), minimap.width, 35 ,"Back To Map");
  timeline = new Timeline((int)(minimap.width*0.6), (int) (scrY - minimap.height*1.2 ), minimap.width, 35 ,"Dates", 1900, 2000, 5);
}



void jumpTo(int x, int y) {
  Coordinate c = Coordinate.initCoords(x, y);
  jumpTo(c);
}

void jumpTo(Coordinate c) {
  winX = setWithBounds(c.getCoX(), bounds, 0);
  winY = setWithBounds(c.getCoY(), bounds, 2);
}



void draw() {
  if (menu == 0) {
    drawIntro();
  } else if (menu == 1) {
    drawMap();
  } else if (menu == 2) {
    drawInfo();
  } else if (menu == 3) {
    slideOutMenu();
  } else if (menu == 4) {
    slideInMenu();
  }
  drawMousePointer();
}


void drawIntro() {
  background(200);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(60);
  text("Civil Rights Map", scrX/2, scrY/2);
  
  if (mousePressed) {
    menu = 1;
  }
}

void drawMap() {
  //  Background  //
  imageMode(CENTER);
  background(255,0,0);
  backCoords.calcScreen();
  image(back,backCoords.getScX(),backCoords.getScY());
  
  //  Map Items  //
  for (MapItem x : mapItems) {
    x.render();
  }
  
  //  Sidebar  //
  sidebar.render();
}


void drawInfo() {
  background(200);
  sidebar.render();
  fill(0);
  textAlign(LEFT);
  text(selected.fullText[6], 400, 100);
  try {
    image(selected.pictures.get(0), 400,400);
  } catch (Exception e) {}
}


void drawMousePointer() {
  mouse = Coordinate.initScreen(mouseX, mouseY);
  stroke(255,0,0);
  noFill();
  ellipse(mouse.getScX(), mouse.getScY(), 10, 10);
}


void slideOutMenu() {
  backCoords.calcScreen();
  image(back,backCoords.getScX(),backCoords.getScY());
  rectMode(CORNER);
  fill(200);
  
  rect(0,0,wid,scrY);
  sidebar.render();
  
  if (wid > scrX) {
    menu = 2;
    wid = scrX-1;
    wv = 0;
  } else {
    wv += 1;
    wid += wv;
  }
}

void slideInMenu() {
  backCoords.calcScreen();
  image(back,backCoords.getScX(),backCoords.getScY());
  rectMode(CORNER);
  fill(200);
  
  rect(0,0,wid,scrY);
  sidebar.render();
  
  if (wid < sidebar.wid) {
    menu = 1;
    wid = sidebar.wid;
    wv = 0;
  } else {
    wv += 1;
    wid -= wv;
  }
}


void keyPressed() {
  if (key == CODED && menu == 1) {
    if (keyCode == RIGHT) {
      winX = setWithBounds(winX + 15, bounds, 0);
    }
    if (keyCode == LEFT) {
      winX = setWithBounds(winX - 15, bounds, 0);
    }
    if (keyCode == UP) {
      winY = setWithBounds(winY - 15, bounds, 2);
    }
    if (keyCode == DOWN) {
      winY = setWithBounds(winY + 15, bounds, 2);
    }
  }
}

int setWithBounds(int x, Bounds b, int s) {
  if (x < b.use(s)) {
    return b.use(s);
  }
  if (x > b.use(s+1)) {
    return b.use(s+1);
  }
  return x;
}

void mouseWheel(MouseEvent event) {
  scroll = event.getCount();
  if (menu == 1) {
    if (mouseX > sidebar.wid) {
      if (keyPressed && keyCode == SHIFT) {
        winX = setWithBounds((int) (winX + 2*scroll), bounds, 0);
      } else {
        winY = setWithBounds((int) (winY + 2*scroll), bounds, 2);
      }
    }
  } else if (menu == 2) {
    
  }
}

class Bounds {
  int[] bounds;
  
  public Bounds(int[] b) {
    bounds = b;
  }
  
  public Bounds(int x1, int x2, int y1, int y2) {
    bounds = new int[]{x1, x2, y1, y2};
  }
  
  public int lowerX() {
    return bounds[0];
  }
  
  public int upperX() {
    return bounds[1];
  }
  
  public int lowerY() {
    return bounds[2];
  }
  
  public int upperY() {
    return bounds[3];
  }
  
  public int use(int s) {
    return bounds[s];
  }
}

class Button {
  int posX, posY;
  int wid, hei;
  int mode; //CORNER, CORNERS, CENTER, RADIUS
  String text;
  int shape = 0;
  boolean showText = true;
  
  public Button(int x, int y, int w, int h, String t) {
    posX = x;
    posY = y;
    wid = w;
    hei = h;
    text = t;
  }
  
  public boolean touchingMouse() {
    return touchingCoords(mouseX, mouseY);
  }
  
  public boolean touchingCoords(int x, int y) {
    return (x > posX - wid/2 && x < posX + wid/2 && y > posY - hei/2 && y < posY + hei/2);
  }
  
  public boolean clicked() {
    return (touchingMouse() && mousePressed);
  }
  
  public void render() {
    stroke(255);
    fill(0);
    if (shape == 0) {
      rectMode(CENTER);
      rect(posX, posY, wid, hei);
    }
    else if (shape == 1) {
      triangle(posX-wid/2, posY-hei/2,  posX+wid/2, posY-hei/2,  posX, posY+hei/2);
    }
    
    
    if (showText) {
      textAlign(CENTER, CENTER);
      fill(255);
      textSize(12);
      text(text, posX, posY);
    }
  }
}

static class Coordinate {
  
  int scX, scY, coX, coY;
  
  public Coordinate(char mode, int x, int y) {
    if (mode == 'c') {
      coX = x;
      coY = y;
      calcScreen();
    }
    else if (mode == 's') {
      scX = x;
      scY = y;
      calcCoords();
    }
  }
  
  public static Coordinate initScreen(int x, int y) {
    Coordinate temp = new Coordinate('s', x, y);
    return temp;
  }
  
  public static Coordinate initCoords(int x, int y) {
    Coordinate temp = new Coordinate('c', x, y);
    return temp;
  }
  
  public int getScX() {
    return scX;
  }
  
  public int getScY() {
    return scY;
  }
  
  public int getCoX() {
    return coX;
  }
  
  public int getCoY() {
    return coY;
  }
  
  public void calcCoords() {
    coX = scX + (winX - scrX/2);
    coY = scY + (winY - scrY/2);
  }
  
  public void calcScreen() {
    scX = coX - (winX - scrX/2);
    scY = coY - (winY - scrY/2);
  }
  
}

class DatedMapItem extends MapItem {
  int startTime;
  int endTime;
  
  public DatedMapItem(String name) {
    super(name);
    startTime = Integer.parseInt(variables.get("Start Date"));
    endTime = Integer.parseInt(variables.get("End Date"));
  }
  
  @Override
  public boolean onScreen() {
    return ((startTime <= globalEndTime) || (endTime >= globalStartTime));
  }
  
  public int getStart() {
    return startTime;
  }
  
  public int getEnd() {
    return endTime;
  }
}

class MapItem {
  PImage icon;
  ArrayList<PImage> pictures;
  String location, name, displayName;
  int size;
  String[] fullText;
  int state; //Inactive, Icon only, Selected Icon, Menu
  Coordinate pos;
  String link;
  HashMap<String, String> variables = new HashMap();
  
  public MapItem(String name) {
    location = "Map Items/" + name + "/" + name + ".txt";
    this.name = name;
    fullText = loadStrings(location);
    initialize();
    println(name + " initialized: posx=" + pos.getCoX() + "  posy=" + pos.getCoY());
    size = 64;
    
  }
  
  private void initialize() {
    for (int i = 0; i < fullText.length; i++) {
      String fullLine = fullText[i];    
      int colonID = fullLine.indexOf(":");
    
      if ((fullLine.length() > 1) && !(colonID < 0 || colonID > fullLine.length())) {
        String head = fullLine.substring(0,colonID);
        String tail = fullLine.substring(colonID + 1);
        try {
          while ( tail.charAt(0) == ' ' ) {tail = tail.substring(1);}
        } catch (Exception e) {}
        variables.put(head, tail);
      }
    }
    displayName = variables.get("Name").toString().replace("\\n", "\n");
    pos = Coordinate.initCoords(Integer.parseInt(variables.get("X")), Integer.parseInt(variables.get("Y")));
    
    icon = loadImage("Map Items/" + name + "/Images/Icon.png");
    
    link = "http://" + variables.get("Link");
  }
  
  public void render() {
    updateState();
    
    if (state == 1) {
      makeImage(icon, pos, size);
    } else if (state == 2) {
      makeImage(icon, pos, size*2);
    }
  }
  
  private void makeImage(PImage img, Coordinate pos, int size) {
    try {
      image(img, pos.getScX(), pos.getScY(), size, size);
    } catch (NullPointerException e) {
      fill(255,0,0);
      ellipse(pos.getScX(), pos.getScY(), size, size);
    }
  }
  
  public int getCurrentState() {
    return state;
  }
  
  public int updateState() {
    pos.calcScreen();
    if (onScreen()) {
      if (touchingMouse()) {
        if (mousePressed) {
          state = 3;
          selected = this;
        }
        else {
          state = 2;
        }
      } else {
        state = 1;
      }
    } else {
      state = 0;
    }
    return state;
  }
  
  public boolean touchingMouse() {
    double dist = Math.sqrt(Math.pow(mouseX-pos.getScX(),2) + Math.pow(mouseY-pos.getScY(),2));
    if (state == 1) {
      return dist < size/2 && mouseX > sidebar.wid;
    }
    else if (state == 2) {
      return dist < size && mouseX > sidebar.wid;
    }
    return false;
  }
  
  public boolean onScreen() {
    if (pos.getScX() < 0 || pos.getScX() > scrX || pos.getScY() < 0 || pos.getScY() > scrY) {
      return false;
    }
    return true;
  }
    
}

class MovingButton extends Button {
  Bounds bounds;
  
  public MovingButton(int x, int y, int w, int h, String name, Bounds b ) {
    super(x, y, w, h, name);
    bounds = b;
  }
  
  @Override
  public boolean touchingCoords(int x, int y) {
    return (    (x > bounds.lowerX() && x < bounds.upperX())     &&     ((y > bounds.lowerY() && y < bounds.upperY()) || (y > posY-hei/2 && y < posY+hei/2)));
  }
  
  @Override
  public boolean clicked() {
    return this.touchingCoords(mouseX, mouseY) && mousePressed;
  }
  
  @Override
  public void render() {
    fill(0,255,0);
    //text(text + " bounds: lowerX=" + bounds.lowerX() + " upperX=" + bounds.upperX(), 100, 100+posX);
    if (this.clicked()) {
      
        if (bounds.lowerX() == bounds.upperX()) {
          posX = bounds.lowerX();
        } else {
          posX = setWithBounds(mouseX, bounds, 0);
        }
        
        if (bounds.lowerY() == bounds.upperY()) {
          posY = bounds.lowerY();
        } else {
          posY = setWithBounds(mouseY, bounds, 2);
        }
      
    }
    super.render();
  }
}

class Sidebar {
  int wid;
  
  public Sidebar(int w) {
    wid = w;
  }
  
  public void render() {
    fill(0);
    rectMode(CORNER);
    rect(0, 0, wid, scrY);
    
    fill(255);
    
    textAlign(LEFT);
    rectMode(CENTER);
    stroke(255);
    noFill();
    rect((int)(minimap.width*0.6), (int) (scrY - minimap.height*1.2 - minimap.height*.5),minimap.width,35);
    
    minimapTracker();
    //timeline.render();
    showSelected();
    
  }
  
  public void minimapTracker() {
    //  Minimap  //
    imageMode(CENTER);
    image(minimap, minimap.width * 0.6, scrY - (minimap.height * 0.6));
    
    if (menu == 1) {
      rectMode(CENTER);
      noFill();
      stroke(255,0,0);
      
      if (!mousePressed) {
        minCenX = minimap.width*0.6 - minimap.width/2 + winX/10 + sidebar.wid/20;
        minCenY = scrY - minimap.height*0.6 - minimap.height/2 + winY/10;
      }
      
      else if (mouseX < minCenX + scrX/20 && mouseX > minCenX - (scrX-sidebar.wid)/20 && mouseY < minCenY + scrY/20 && mouseY > minCenY - scrY/20) {
        minCenX = setWithBounds(mouseX, miniBounds, 0);
        minCenY = setWithBounds(mouseY, miniBounds, 2);
        jumpTo((int) (mouseX - minimap.width*0.6 + minimap.width/2 - sidebar.wid/20) * 10, 10 * (int)(mouseY - (scrY - minimap.height*0.6 - minimap.height/2)));
      }
      
      rect(minCenX, minCenY, (scrX-sidebar.wid)/10, scrY/10);
    }
  }
  
  public void showSelected() {
    if (selected != null) {
      image(selected.icon, sidebar.wid/2, minimap.width*0.6, minimap.width, minimap.width);
      try {
        DatedMapItem s = (DatedMapItem)selected;
        fill(255);
        textAlign(CENTER, CENTER);
        text("Time Range: " + s.getStart() + " - " + s.getEnd(), (minimap.width*0.6), scrY - minimap.height*1.2 - 50);
        //timeline.renderFixedTime(s.getStart(), s.getEnd());
        //fill(255, 0, 255);
        //text(s.getStart() + ", " + s.getEnd(), 400,400);
        //text(globalStartTime + ", " + globalEndTime, 400, 500);
      } catch (NullPointerException e) {
        ;
      }
      fill(255);
      textSize(24);
      textAlign(CENTER, CENTER);
      text(selected.displayName, sidebar.wid/2, scrY/2.5);
      fill(255, 0, 0);
      text(mouse.getCoX() + ", " + mouse.getCoY(), 400, 400);
      
      
      if (menu == 1) {
        seeMore.render();
        if (seeMore.clicked()) {
          //setMenu = 3;
          link(selected.link);
        }
      } else if (menu == 2) {
        backToMap.render();
        if (backToMap.clicked()) {
          setMenu = 4;
        }
      }
      
      if (!mousePressed && setMenu > 0) {
        menu = setMenu;
        setMenu = -1;
      }
      
    }
  }
}

class Timeline extends Button {
  int startDate, endDate;
  int increment;
  MovingButton top, bottom;
  
  public Timeline(int x, int y, int w, int h, String name, int start, int end, int inc) {
    super(x, y, w, h, name);
    startDate = start;
    endDate = end;
    increment = inc;
    Bounds temp = new Bounds(x-w/2, x+w/2, y-h/2, y-h/2);
    top = new MovingButton(x-w/2, y-h/2, 15, 15, "", temp);
    temp = new Bounds(x-w/2, x+w/2, y-h/2, y-h/2);
    bottom = new MovingButton(x+w/2, y-h/2, 15, 15, "", temp);
    top.shape = 1;
    bottom.shape = 1;
  }
  
  public void drawLine() {
    stroke(255);
    line(posX-wid/2, posY, posX+wid/2, posY);
    int space = (endDate-startDate) / increment;
    for (int i = 0; i < space+1; i++) {
      line(posX-wid/2+i*wid/space, posY-5, posX-wid/2+i*wid/space, posY+5);
    }
  }
  
  @Override
  public void render() {
    drawLine();
    top.bounds.bounds[1] = bottom.posX-bottom.wid/2;//-increment;
    bottom.bounds.bounds[0] = top.posX+top.wid/2;//+increment;
    top.render();
    bottom.render();
    
    
    
    fill(255);
    globalStartTime = (startDate + ((top.posX-(posX-wid/2))*(endDate-startDate)/wid));
    globalEndTime = (startDate + ((bottom.posX-(posX-wid/2))*(endDate-startDate)/wid));
    if (globalStartTime == globalEndTime) {
      text("Time Range: " + globalStartTime, posX, posY-50);
    } else {
      text("Time Range: " + globalStartTime + " - " + globalEndTime, posX, posY-50);
    }
    
  }
  
  public void renderFixedTime(int start, int end) {
    fill(0, 255, 0);
    text(start + ", " + end, 300, 300);
    fill(0,255,255);
    //int beginning = (start - startDate + posX - wid/2) * ((endDate-startDate) / wid);
    int beginning = //(start-startDate)/(endDate-startDate)*wid - (wid/2) + posX;
    (int)lerp(posX-wid/2, posX+wid/2, (start-startDate)/(endDate-startDate));
    //int ending = (end - startDate + posX - wid/2) / (endDate-startDate) * wid;
    int ending = //(end-startDate)/(endDate-startDate)*wid - wid/2 + posX;
    (int)lerp(posX-wid/2, posX+wid/2, (end-startDate)/(endDate-startDate));
    rectMode(CORNERS);
    rect(posX-wid/2, posY-5, posX+wid/2, posY+5);
    fill(255, 0, 255);
    rect(beginning, posY+5, ending, posY-5);
    text(beginning +", " + ending, 425, 600);
  }
}
