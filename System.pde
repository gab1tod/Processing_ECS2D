import java.util.*;

public class System {
  public float timeMultiplier = 1;
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
  
  public System(ArrayList<Entity> entities) {
    this.entities = entities;
  }
  
  private boolean pause = false;
  private int timestamp;
  
  public void setPause(boolean p) {
    pause = p;
    if (!pause) {
      timestamp = millis();
    }
  }
  
  public void spawn(Entity e) {
    entities.add(e);
    e.init();
  }
  
  public boolean despawn(Entity e) {
    return entities.remove(e);
  }
  
  public Entity[] entities() {
    return (Entity[])entities.toArray();
  }
  
  public void update() {
    float delta = (float)(millis() - timestamp) / 1000 * timeMultiplier;
    timestamp = millis();
    
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
