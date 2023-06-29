public Game game;

void setup() {
  size(1440, 810);
  
  game = new TestGame();
}

void draw() {
  background(0);
  
  game.update();
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
