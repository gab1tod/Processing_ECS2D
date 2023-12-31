public static class Transform {
  public Transform parent = null;
  public PVector vector;  // x: x, y: y, z: angle
  
  public float x() { return vector.x; }
  public float x(float val) { return vector.x = val; }
  public float y() { return vector.y; }
  public float y(float val) { return vector.y = val; }
  public float angle() { return vector.z; }
  public float angle(float val) { return vector.z = val; }
  
  public Transform(PVector vector) {
    this.vector = vector;
  }
  
  public Transform(float x, float y, float a) {
    vector = new PVector(x, y, a);
  }
  
  public Transform move(PVector movement) {
    vector.add(movement);
    return this;
  }
  
  public Transform move(float x, float y, float a) {
    return move(new PVector(x, y, a));
  }
  
  public Transform moveTo(PVector target) {
    vector = target.copy();
    return this;
  }
  
  public Transform moveTo(float x, float y, float a) {
    return moveTo(new PVector(x, y, a));
  }
  
  // Loval to Global
  public PVector localToGlobal(PVector point) {
    point.rotate(angle());
    point.add(vector);
    
    return parent != null ? parent.localToGlobal(point) : point;
  }
  
  public PVector localToGlobal(float x, float y, float a) {
    return localToGlobal(new PVector(x, y, a));
  }
  
  // Global to Local
  public PVector global() { return localToGlobal(new PVector(0, 0, 0)); }
  
  public PVector globalToLocal(PVector point) {
    PVector global = global();
    point.sub(global);
    point.rotate(-global.z);
    
    return point;
  }
  
  public PVector globalToLocal(float x, float y) {
    return globalToLocal(new PVector(x, y));
  }
  
  public PVector globalToLocal(float x, float y, float a) {
    return globalToLocal(new PVector(x, y, a));
  }
  
  public static Transform fromVector(PVector v) {
    return new Transform(v.x, v.y, v.z);
  }
}

public class Entity implements GameObject {
  // Position in the world
  public Transform transform;
  public boolean enable = true;  // If set to `false`, this component will be ignored
  // Priority of call
  public int priority = 0;
  // All the components
  private ArrayList<Component> components = new ArrayList();
  // System in witch this is added
  private Scene scene = null;
  public Scene scene() { return scene; }
  
  public Entity(PVector transform) {
    this.transform = new Transform(transform);
  }
  
  public Entity(float x, float y, float a) {
    this.transform = new Transform(x, y, a);
  }
  
  public <C extends Component> Entity registerComponent(C comp) {
    components.add(comp);
    comp.onRegistered(this);
    return this;
  }
  
  public <C extends Component> boolean removeComponent(Class<C> type) {
    for (Component c : components) {
      if (c.getClass().equals(type)) {
        components.remove(c);
        c.onRemoved();
        return true;
      }
    }
    return false;
  }
  
  public <C extends Component> int removeComponents(Class<C> type) {
    int nbRemoved = 0;
    
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component c = components.get(i);
      if (c.getClass().equals(type)) {
        components.remove(c);
        c.onRemoved();
        
        nbRemoved ++;
      }
    }
    
    return nbRemoved;
  }
  
  public <C extends Component> Component getComponent(Class<C> type) {
    for (Component c : components) {
      if (c.getClass().equals(type)) return c;
    }
    return null;
  }
  
  public <C extends Component> ArrayList<Component> getComponents(Class<C> type) {
    ArrayList<Component> res = new ArrayList();
    for (Component c : components) {
      if (c.getClass().equals(type)) res.add(c);
    }
    return res;
  }
  
  public void onSpawn(Scene scene) {
    this.scene = scene;
    
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).init();
    }
  }
  
  public void onDespawn() {
    this.scene = null;
  }
  
  public void beforeUpdate() {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.beforeUpdate();
    }
  }
  
  public void update(float delta) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.update(delta);
    }
  }
  
  public void afterUpdate() {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.afterUpdate();
    }
  }
  
  public void display() {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.display();
    }
  }
  
  void keyPressed(KeyEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.keyPressed(e);
    }
  }
  
  void keyReleased(KeyEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.keyReleased(e);
    }
  }
  
  void mousePressed(MouseEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.mousePressed(e);
    }
  }
  
  void mouseReleased(MouseEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.mouseReleased(e);
    }
  }
  
  void mouseWheel(MouseEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.mouseWheel(e);
    }
  }
  
  void windowResized() {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      Component component = components.get(i);
      if (components.get(i).enable)
        component.windowResized();
    }
  }
}
