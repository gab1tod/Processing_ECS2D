public interface GameObject {
  void update(float delta);
  void display();
  void keyPressed(KeyEvent e);
  void keyReleased(KeyEvent e);
  void mousePressed(MouseEvent e);
  void mouseReleased(MouseEvent e);
  void mouseWheel(MouseEvent e);
}

public class Game implements GameObject {
  public HashMap<Integer, Character> pressedKeys = new HashMap();
  public HashSet<Integer> pressedMouseButtons = new HashSet();
  
  private Scene scene;
  public float timeMultiplier = 1;
  private boolean pause = false;
  private int timestamp;
  
  public Game() {}
  
  public void setPause(boolean p) {
    pause = p;
    if (!pause) {
      timestamp = millis();
    }
  }
  
  public Scene scene() { return scene; }
  
  public void loadScene(Scene scene)  {
    if (this.scene != null)
      this.scene.dispose();
    this.scene = scene;
    if (this.scene != null)
      this.scene.init();
  }
  
  public void update() {
    float delta = (float)(millis() - timestamp) / 1000 * timeMultiplier;
    timestamp = millis();
    update(delta);
    display();
  }
  
  void update(float delta) {
    if (scene != null) scene.update(delta);
  }
  
  void display() {
    if (scene != null) scene.display();
  }
  
  void keyPressed(KeyEvent e) {
    if (scene != null) scene.keyPressed(e);
    pressedKeys.put(keyCode, key);
  }
  
  void keyReleased(KeyEvent e) {
    if (scene != null) scene.keyReleased(e);
    pressedKeys.remove(keyCode);
  }
  
  void mousePressed(MouseEvent e) {
    if (scene != null) scene.mousePressed(e);
    pressedMouseButtons.add(mouseButton);
  }
  
  void mouseReleased(MouseEvent e) {
    if (scene != null) scene.mouseReleased(e);
    pressedMouseButtons.remove(mouseButton);
  }
  
  void mouseWheel(MouseEvent e) {
    if (scene != null) scene.mouseWheel(e);
  }
}
