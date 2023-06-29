import java.util.*;

public class System implements GameObject {
  private ArrayList<Entity> entities;
  // Put hign priority last. But as iteration is backward, it will be updated first
  private final Comparator<Entity> priorityComparator = new Comparator<Entity>() {
    @Override
    public int compare(Entity a, Entity b) {
      return a.priority - b.priority;
    }
  };
  
  public System() {
    entities = new ArrayList();
  }
  
  public void spawn(Entity e) {
    entities.add(e);
    e.onSpawn(this);
  }
  
  public boolean despawn(Entity e) {
    if (entities.remove(e)) {
      e.onDespawn();
      return true;
    }
    return false;
  }
  
  public ArrayList<Entity> entities() {
    return entities;
  }
  
  public void update(float delta) {
    Collections.sort(entities, priorityComparator);
    
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity e = entities.get(i);
      e.beforeUpdate();
    }
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity e = entities.get(i);
      e.update(delta);
    }
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity e = entities.get(i);
      e.afterUpdate();
    }
  }
  
  public void display() {
    Collections.sort(entities, priorityComparator);
    
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity e = entities.get(i);
      e.display();
    }
  }
  
  void keyPressed(KeyEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      entities.get(i).keyPressed(e);
    }
  }
  
  void keyReleased(KeyEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      entities.get(i).keyReleased(e);
    }
  }
  
  void mousePressed(MouseEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      entities.get(i).mousePressed(e);
    }
  }
  
  void mouseReleased(MouseEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      entities.get(i).mouseReleased(e);
    }
  }
  
  void mouseWheel(MouseEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      entities.get(i).mouseWheel(e);
    }
  }
}

abstract class Scene extends System {
  // Must setup camera
  public CameraComponent camera;
  
  public Scene() {
    super();
  }
  
  public abstract void init();
  public abstract void dispose();
  
  @Override
  public void display() {
    pushMatrix();
    
    if (camera != null) camera.applyView();  // Move view according to camera location, rotation and zoom
    super.display();
    
    popMatrix();
  }
}
