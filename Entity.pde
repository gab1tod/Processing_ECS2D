public static class Transform {
  public Transform parent = null;
  public PVector vector;  // x: x, y: y, z: angle
  
  public float x() { return vector.x; }
  public float y() { return vector.y; }
  public float angle() { return vector.z; }
  
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
  
  public static Transform fromVector(PVector v) {
    return new Transform(v.x, v.y, v.z);
  }
}

public class Entity {
  // Position in the world
  public Transform transform;
  // Priority of call
  public int priority = 0;
  // All the components
  private ArrayList<Component> components = new ArrayList();
  
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
  
  public void init() {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).init();
    }
  }
  
  public void beforeUpdate() {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).beforeUpdate();
    }
  }
  
  public void update(float delta) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).update(delta);
    }
  }
  
  public void afterUpdate() {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).afterUpdate();
    }
  }
  
  void keyPressed(KeyEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).keyPressed(e);
    }
  }
  
  void keyReleased(KeyEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).keyReleased(e);
    }
  }
  
  void mousePressed(MouseEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).mousePressed(e);
    }
  }
  
  void mouseReleased(MouseEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).mouseReleased(e);
    }
  }
  
  void mouseWheel(MouseEvent e) {
    for (int i=components.size()-1; i>=0; i--) {
      if (i>=components.size()) continue;
      
      components.get(i).mouseWheel(e);
    }
  }
}
