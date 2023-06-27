public abstract class Component {
  Entity entity = null;
  public Entity entity() { return entity; }
  
  // Called when component is added to a new Entity
  void onRegistered(Entity e) {
    this.entity = e;
  }
  
  void onRemoved() {
    this.entity = null;
  }
  
  public void init() {};
  
  public void beforeUpdate() {}
  public abstract void update(float delta);
  public void afterUpdate() {}
  
  void keyPressed(KeyEvent e) {}
  void keyReleased(KeyEvent e) {}
  void mousePressed(MouseEvent e) {}
  void mouseReleased(MouseEvent e) {}
  void mouseWheel(MouseEvent e) {}
}
