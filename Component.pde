public abstract class Component implements GameObject {
  Entity entity = null;
  public boolean enable = true;  // If set to `false`, this component will be ignored
  public Entity entity() { return entity; }
  public Transform transform() { return entity.transform; }
  
  // Called when component is added to a new Entity
  void onRegistered(Entity e) {
    this.entity = e;
  }
  
  void onRemoved() {
    this.entity = null;
  }
  
  public void init() {};
  
  public void beforeUpdate() {}
  public void update(float delta) {}
  public void afterUpdate() {}
  
  public void display() {}
  
  void keyPressed(KeyEvent e) {}
  void keyReleased(KeyEvent e) {}
  void mousePressed(MouseEvent e) {}
  void mouseReleased(MouseEvent e) {}
  void mouseWheel(MouseEvent e) {}
  void windowResized() {}
}
