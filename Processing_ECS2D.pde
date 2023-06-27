HashMap<Integer, Character> pressedKeys = new HashMap();
HashSet<Integer> pressedMouseButtons = new HashSet();

System system = new System();
Entity tank = new Entity(0, 0, 0) {
  @Override
  public void init() {
    RectComponent body = new RectComponent(null, new Color(255, 0, 0), 0, 0, 40, 50);
    body.mode = CENTER;
    RectComponent cannon = new RectComponent(null, new Color(255, 0, 0), 0, -25, 7, 50);
    cannon.mode = CENTER;
    TankController ctrl = new TankController(200, 1.5 * HALF_PI, 0.7);
    
    registerComponent(body);
    registerComponent(cannon);
    registerComponent(ctrl);
    
    super.init();
  }
};

void setup() {
  size(960, 540);
  
  tank.transform.moveTo(width/2, height/2, 0);
  system.spawn(tank);
}

void draw() {
  background(0);
  
  system.update();
}

void keyPressed(KeyEvent e) {
  system.keyPressed(e);
  pressedKeys.put(keyCode, key);
}

void keyReleased(KeyEvent e) {
  system.keyReleased(e);
  pressedKeys.remove(keyCode);
}

void mousePressed(MouseEvent e) {
  system.mousePressed(e);
  pressedMouseButtons.add(mouseButton);
}

void mouseReleased(MouseEvent e) {
  system.mouseReleased(e);
  pressedMouseButtons.remove(mouseButton);
}

void mouseWheel(MouseEvent e) {
  system.mouseWheel(e);
}
