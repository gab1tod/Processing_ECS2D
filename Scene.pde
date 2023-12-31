import java.util.*;

public abstract class Scene implements GameObject {
  // Must setup camera
  public CameraComponent camera;
  private ArrayList<Entity> entities;
  // Put hign priority last. But as iteration is backward, it will be updated first
  private final Comparator<Entity> priorityComparator = new Comparator<Entity>() {
    @Override
    public int compare(Entity a, Entity b) {
      return a.priority - b.priority;
    }
  };
  
  public Scene() {
    entities = new ArrayList();
  }
  
  public abstract void init();
  public abstract void dispose();
  
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
      if (e.enable)
        e.beforeUpdate();
    }
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity e = entities.get(i);
      if (e.enable)
        e.update(delta);
    }
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity e = entities.get(i);
      if (e.enable)
        e.afterUpdate();
    }
  }
  
  public void display() {
    pushMatrix();
    
    if (camera != null) camera.applyView();  // Move view according to camera location, rotation and zoom
    Collections.sort(entities, priorityComparator);
    
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity e = entities.get(i);
      if (e.enable)
        e.display();
    }
    
    popMatrix();
  }
  
  void keyPressed(KeyEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity entity = entities.get(i);
      if (entity.enable)
        entity.keyPressed(e);
    }
  }
  
  void keyReleased(KeyEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity entity = entities.get(i);
      if (entity.enable)
        entity.keyReleased(e);
    }
  }
  
  void mousePressed(MouseEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity entity = entities.get(i);
      if (entity.enable)
        entity.mousePressed(e);
    }
  }
  
  void mouseReleased(MouseEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity entity = entities.get(i);
      if (entity.enable)
        entity.mouseReleased(e);
    }
  }
  
  void mouseWheel(MouseEvent e) {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity entity = entities.get(i);
      if (entity.enable)
        entity.mouseWheel(e);
    }
  }
  
  void windowResized() {
    for (int i=entities.size()-1; i>=0; i--) {
      if (i >= entities.size()) continue;
      
      Entity entity = entities.get(i);
      if (entity.enable)
        entity.windowResized();
    }
  }
}
