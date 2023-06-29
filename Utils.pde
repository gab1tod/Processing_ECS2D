// DISPLAY
public abstract class DisplayComponent extends Component {
  @Override
  public void display() {
    pushMatrix();
      translate(transform().global().x, transform().global().y);
      rotate(transform().global().z);
      displayTransformed();
    popMatrix();
  }
  
  public abstract void displayTransformed();
}

public class RectDC extends DisplayComponent {
  public color c;
  public boolean fill = true;
  public float weight = 1;
  public int mode = CORNER;
  public float x;
  public float y;
  public float w;
  public float h;
  
  public RectDC(color c, float x, float y, float w, float h) {
    super();
    this.c = c;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  @Override
  public void displayTransformed() {
    if (fill) {
      noStroke();
      fill(c);
    } else {
      noFill();
      stroke(c);
      strokeWeight(weight);
    }
    
    rect(x, y, w, h);
  }
}

// CAMERA
public class CameraComponent extends Component {
  public float zoom = 1;
  public Transform target = null;
  public boolean follow = false;
  public boolean followAngle = false;
  
  public void applyView() {
    PVector pos = transform().global();
    
    translate(-pos.x, -pos.y);
    rotate(-pos.z);
    translate(width/2 * 1.0/zoom, height/2 * 1.0/zoom);
    scale(zoom);
  }
  
  @Override
  public void afterUpdate() {
    if (follow && target != null) {
      if (followAngle) {
        transform().moveTo(target.global());
      } else {
        transform().vector.x = target.global().x;
        transform().vector.y = target.global().y;
      }
    }
  }
  
  public void follow(Transform target, boolean followAngle) {
    this.follow = true;
    this.target = target;
    this.followAngle = followAngle;
  }
  
  public void unfollow() {
    this.follow = false;
  }
}

public class Camera extends Entity {
  private final CameraComponent component;
  
  public Camera(PVector position) {
    super(position);
    component = new CameraComponent();
    registerComponent(component);
  }
  
  public Camera(float x, float y, float a) {
    super(x, y, a);
    component = new CameraComponent();
    registerComponent(component);
  }
  
  public void follow(Transform target, boolean followAngle) {
    component.follow(target, followAngle);
  }
  
  public void unfollow() {
    component.unfollow();
  }
}
