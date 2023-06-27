import java.awt.*;

public class RectComponent extends Component {
  public Color border;
  public int borderSize = 1;
  public Color background;
  public float x, y, w, h;
  public int mode = CORNER;
  
  public RectComponent(Color border, Color background, float x, float y, float w, float h) {
    super();
    this.border = border;
    this.background = background;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public void update(float delta) {}
  
  @Override
  public void afterUpdate() {
    if (border != null) {
      strokeWeight(borderSize);
      stroke(border.getRed(), border.getGreen(), border.getBlue(), border.getAlpha());
    } else {
      noStroke();
    }
    
    if (background != null) {
      fill(background.getRed(), background.getGreen(), background.getBlue(), background.getAlpha());
    } else {
      noFill();
    }
    
    rectMode(mode);
    PVector transform = entity.transform.global();
    
    pushMatrix();
    translate(transform.x, transform.y);
    rotate(transform.z);
    rect(x, y, w, h);
    popMatrix();
  }
}


public class TankController extends Component {
  // Speed in pixels/seconds
  public float speed;
  // Rotation speed in radian/seconds
  public float rotationSpeed;
  // Time between two shots in seconds
  public float timeToReload;
  public Integer lastShotTs = null;
  
  public TankController(float speed, float rotationSpeed, float timeToReload) {
    super();
    this.speed = speed;
    this.rotationSpeed = rotationSpeed;
    this.timeToReload = timeToReload;
  }
  
  public void update(float delta) {
    PVector direction = new PVector(0, 0, 0);
    float rotation = 0;
    
    if (pressedKeys.keySet().contains(LEFT)) {
      rotation -= 1;
    }
    if (pressedKeys.keySet().contains(RIGHT)) {
      rotation += 1;
    }
    if (pressedKeys.keySet().contains(UP)) {
      direction.y -= 1;
    }
    if (pressedKeys.keySet().contains(DOWN)) {
      direction.y += 1;
    }
    if (pressedKeys.keySet().contains(CONTROL) && (lastShotTs == null || (float)(millis() - lastShotTs)/1000 > timeToReload)) {
      shoot();
    }
    
    direction.normalize();
    direction.mult(speed * delta);
    direction.rotate(entity.transform.angle());
    direction.z = rotation * rotationSpeed * delta;
    entity.transform.move(direction);
  }
  
  void shoot() {
    lastShotTs = millis();
    Entity bullet = new Entity(entity.transform.localToGlobal(0, -50, 0)) {
      @Override
      public void init() {
        RectComponent rect = new RectComponent(null, new Color(250, 250, 60), 0, 0, 5, 15);
        rect.mode = CENTER;
        Component ctrl = new Component() {
          float speed = 2000; // In pixel/seconds
          float lifeTime = 1; // In seconds;
          int timestamp;
          
          @Override
          public void init() {
            timestamp = millis();
          }
          
          @Override
          public void update(float delta) {
            PVector movement = new PVector(0, -speed * delta, 0);
            movement.rotate(entity.transform.angle());
            entity.transform.move(movement);
          }
          
          @Override
          public void afterUpdate() {
            if ((float)(millis() - timestamp)/1000 > lifeTime) {  // Delete bullet
              system.despawn(entity);
            }
          }
        };
        
        registerComponent(rect);
        registerComponent(ctrl);
        
        super.init();
      }
    };
    
    system.spawn(bullet);
  }
}
