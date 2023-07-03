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

  public RectDC(color c, float x, float y, float w, float h, boolean fill) {
    super();
    this.c = c;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fill = fill;
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
    
    rectMode(mode);
    rect(x, y, w, h);
  }
}

public class EllipseDC extends DisplayComponent {
  public color c;
  public boolean fill = true;
  public float weight = 1;
  public int mode = CENTER;
  public float x;
  public float y;
  public float w;
  public float h;

  public EllipseDC(color c, float x, float y, float w, float h) {
    super();
    this.c = c;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  public EllipseDC(color c, float x, float y, float w, float h, boolean fill) {
    super();
    this.c = c;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fill = fill;
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

    ellipseMode(mode);
    ellipse(x, y, w, h);
  }
}

// CAMERA
public class CameraComponent extends Component {
  public float zoom = 1;
  public Transform target = null;
  public boolean follow = false;
  public boolean followAngle = false;
  private PVector offset = new PVector(0, 0, 0);  // Offset when following
  public boolean offsetRelative = true;  // Offset relative to target

  public void applyView() {
    PVector pos = transform().global();
    
    scale(zoom);
    translate(width/2 /zoom, height/2 /zoom);
    rotate(-pos.z);
    translate(-pos.x, -pos.y);
  }
  
  public PVector screenToWorld(PVector point) {
    PVector pos = transform().global();
    PVector res = point.copy();
    
    res.sub(new PVector(width/2, height/2));
    res.rotate(pos.z);
    res.add(pos.copy().mult(zoom));
    res.div(zoom);
    
    return res;
  }
  
  public PVector screenToWorld(float x, float y) {
    return screenToWorld(new PVector(x, y));
  }
  
  public PVector worldToScreen(PVector point) {
    PVector pos = transform().global();
    PVector res = point.copy();
    
    res.mult(zoom);
    res.sub(pos.copy().mult(zoom));
    res.rotate(-pos.z);
    res.add(new PVector(width/2, height/2));
    
    return res;
  }
  
  public PVector worldToScreen(float x, float y) {
    return worldToScreen(new PVector(x, y));
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
      
      PVector off = offset.copy();
      if (offsetRelative) {
        off.rotate(target.global().z);
      }
      transform().move(off);
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
  
  public PVector offset() { return offset; }
  public PVector offset(PVector value) { return offset = value; }
  public PVector offset(float x, float y, float a) { return offset(new PVector(x, y, a)); }
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
  
  public PVector offset() { return component.offset(); }
  public PVector offset(PVector value) { return component.offset(value); }
  public PVector offset(float x, float y, float a) { return offset(new PVector(x, y, a)); }
  
  public PVector screenToWorld(PVector point) {
    return component.screenToWorld(point);
  }
  
  public PVector screenToWorld(float x, float y) {
    return screenToWorld(new PVector(x, y));
  }
  
  public PVector worldToScreen(PVector point) {
    return component.worldToScreen(point);
  }
  
  public PVector worldToScreen(float x, float y) {
    return worldToScreen(new PVector(x, y));
  }
}

// Hitbox
public abstract class HitboxComponent extends Component {
  public ArrayList<HitboxComponent> hits = new ArrayList();
  
  public abstract boolean hit(PVector point);
  public abstract boolean hit(float x, float y);
  public abstract boolean hit(HitboxComponent hitbox);
  
  @Override
  public void update(float delta) {
    // TODO: check for every hitbox of the scene (except this one)
  }
}

public class RectHitbox extends HitboxComponent {
  public float w;
  public float h;
  
  public RectHitbox(float w, float h) {
    super();
    this.w = w;
    this.h = h;
  }
  
  public boolean hit(PVector point) {
    PVector pt = entity().transform.globalToLocal(point);
    return pt.x > -w/2 && pt.x < w/2 && pt.y > -h/2 && pt.y < h/2;
  }
  
  public boolean hit(float x, float y) {
    PVector pt = entity().transform.globalToLocal(x, y);
    return pt.x > -w/2 && pt.x < w/2 && pt.y > -h/2 && pt.y < h/2;
  }
  
  public boolean hit(HitboxComponent hitbox) {
    if (hitbox instanceof RectHitbox) {
      // TODO
    }
    if (hitbox instanceof CircleHitbox) {
      // TODO
    }
    return false;
  }
}

public class CircleHitbox extends HitboxComponent {
  public float radius;
  
  public CircleHitbox(float r) {
    super();
    this.radius = r;
  }
  
  public boolean hit(PVector point) {
    PVector pt = entity().transform.globalToLocal(point);
    return pt.mag() < radius;
  }
  
  public boolean hit(float x, float y) {
    PVector pt = entity().transform.globalToLocal(x, y);
    return pt.mag() < radius;
  }
  
  public boolean hit(HitboxComponent hitbox) {
    if (hitbox instanceof RectHitbox) {
      // TODO
    }
    if (hitbox instanceof CircleHitbox) {
      PVector pt = entity().transform.globalToLocal(hitbox.entity().transform.vector);
      return pt.mag() < radius + ((CircleHitbox)hitbox).radius;
    }
    return false;
  }
}
