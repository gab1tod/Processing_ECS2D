public Game game;

void setup() {
  size(1440, 810);
  surface.setResizable(true);
  
  game = new TestGame();
}

void draw() {
  background(0);
  
  game.update();
  
  noStroke();
  fill(0, 255, 0);
  pushMatrix();
  
    Transform stw = ((Level1)game.scene).stw.transform;
    PVector wts = game.scene.camera.worldToScreen(stw.x(), stw.y());
    translate(wts.x, wts.y);
    rect(-10, -10, 20, 20);
  
  popMatrix();
}

void keyPressed(KeyEvent e) {
  game.keyPressed(e);
}

void keyReleased(KeyEvent e) {
  game.keyReleased(e);
}

void mousePressed(MouseEvent e) {
  game.mousePressed(e);
}

void mouseReleased(MouseEvent e) {
  game.mouseReleased(e);
}

void mouseWheel(MouseEvent e) {
  game.mouseWheel(e);
}

void windowResized() {
  game.windowResized();
}
