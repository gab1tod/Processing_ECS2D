// GAME
public class TestGame extends Game {
  private TestGame() {
    super();
    loadScene(new Level1());
  }
}

// LEVEL 1
public class Level1 extends Scene {
  public Tank player;
  public Entity stw;

  @Override
    public void init() {
    // Setup camera
    Camera cam = new Camera(800/2, 450/2, 0);
    this.camera = cam.component;
    spawn(cam);
    cam.component.zoom = height / 450.0;
    cam.registerComponent(new Component() {
      Camera camera = cam;
      
      void windowResized() {
        camera.component.zoom = height / 450.0;
      }
    });

    // Setup player
    player = new Tank(color(255, 0, 0), 800/3, 450/2, 0);
    spawn(player);
    
    // Setup dummy
    Tank dummy = new Tank(color(0, 0, 255), 2*800/3, 450/2, 0);
    dummy.controller.enable = false;
    dummy.turret.controller.enable = false;
    spawn(dummy);
    
    // World/screen test
    stw = new Entity(0, 0, 0);
    stw.registerComponent(new Component(){  // Screen to world controller
      Camera camera = cam;
    
      @Override
      public void afterUpdate() {
        transform().moveTo(camera.screenToWorld(mouseX, mouseY));
      }
    });
    stw.registerComponent(new EllipseDC(color(200, 0, 0), 0, 0, 10, 10, false));
    stw.priority = -2;
    spawn(stw);

    //cam.transform.moveTo(0, -100, 0);
    //cam.transform.parent = player.turret.transform;
    cam.follow(player.transform, false);
    cam.offset(0, -50, 0);

    // Grid background
    Entity grid = new Entity(0, 0, 0);
    Component gridDC = new DisplayComponent() {
      @Override
        public void displayTransformed() {
        stroke(0, 255, 0, 100);
        strokeWeight(1);

        for (int i=0; i<=16; i++) {
          line(i * 800/16, 0, i * 800/16, 450);
        }
        for (int i=0; i<=9; i++) {
          line(0, i * 450/9, 800, i * 450/9);
        }
      }
    };
    grid.registerComponent(gridDC);
    spawn(grid);
  }

  @Override
    public void dispose() {
  }
}

// PLAYER
public class TankController extends Component {
  public float speed = 100;  // pixel/s
  public float speedInput = 0;
  public float speedInputSpeed = 0.1;  // Input reactivity between 0..1
  public float turnSpeed = 1.2;  // Radian/s
  public float turnInput = 0;
  public float turnInputSpeed = 0.15;  // Input reactivity between 0..1

  @Override
  public void update(float delta) {
    float direction = 0;
    float turnDirection = 0;
    if (game.pressedKeys.values().contains('z')) direction --;
    if (game.pressedKeys.values().contains('s')) direction ++;
    if (game.pressedKeys.values().contains('q')) turnDirection --;
    if (game.pressedKeys.values().contains('d')) turnDirection ++;
    
    speedInput += (direction - speedInput) * speedInputSpeed;
    turnInput += (turnDirection - turnInput) * turnInputSpeed;
    
    PVector move = new PVector(0, speedInput * speed * delta, turnInput * turnSpeed * delta);
    move.rotate(transform().angle());
    transform().move(move);
  }
}

public class TurretController extends Component {
  public float turnSpeed = 1.5;  // Radian/s
  public float turnInput = 0;
  public float turnInputSpeed = 0.33;  // Input reactivity between 0..1
  public int lastShot = 0;
  public int timeBetweenShots = 1000;  // Time between to shots in ms

  @Override
    public void update(float delta) {
    //float direction = 0;
    //if (game.pressedKeys.containsKey(LEFT)) direction --;
    //if (game.pressedKeys.containsKey(RIGHT)) direction ++;
    
    //turnInput += (direction - turnInput) * turnInputSpeed;
    //transform().move(0, 0, turnInput * turnSpeed * delta);
    
    PVector target = entity().scene.camera.screenToWorld(mouseX, mouseY);
    target.sub(transform().global());
    float targetAngle = atan2(target.y, target.x) + HALF_PI;
    targetAngle = transform().parent != null ? transform().parent.globalToLocal(0, 0, targetAngle).z : targetAngle;
    transform().angle(targetAngle);
    
    if (game.pressedMouseButtons.contains(LEFT) && millis()-lastShot > timeBetweenShots) {
      lastShot = millis();
      entity().scene.spawn(new Bullet(
        color(255, 255, 0),
        entity().transform.localToGlobal(0, -30, 0),
        new PVector(0, -1000, 0).rotate(entity().transform.global().z),
        1.0
      ));
    }
  }
}

public class Tank extends Entity {
  public final TankController controller;
  public final RectDC body;
  public final Turret turret;

  public Tank(color c, PVector position) {
    super(position);
    controller = new TankController();
    body = new RectDC(lerpColor(c, color(0), 0.15), -15, -25, 30, 50);
    registerComponent(controller);
    registerComponent(body);

    turret = new Turret(c, 0, 0, 0);
    turret.transform.parent = transform;
  }

  public Tank(color c, float x, float y, float a) {
    super(x, y, a);
    controller = new TankController();
    body = new RectDC(lerpColor(c, color(0), 0.15), -15, -25, 30, 50);
    registerComponent(controller);
    registerComponent(body);

    turret = new Turret(c, 0, 5, 0);
    turret.priority = -1;
    turret.transform.parent = transform;
  }

  @Override
    public void onSpawn(Scene scene) {
    super.onSpawn(scene);

    scene.spawn(turret);
  }

  @Override
    public void onDespawn() {
    if (scene() != null) scene().despawn(turret);

    super.onDespawn();
  }
}

public class Turret extends Entity {
  public final TurretController controller;
  public final RectDC body;
  public final RectDC cannon;

  public Turret(color c, PVector position) {
    super(position);
    controller = new TurretController();
    body = new RectDC(c, -10, -10, 20, 20);
    cannon = new RectDC(c, -2, 0, 4, -33);
    registerComponent(controller);
    registerComponent(body);
    registerComponent(cannon);
  }

  public Turret(color c, float x, float y, float z) {
    super(x, y, z);
    controller = new TurretController();
    body = new RectDC(c, -10, -10, 20, 20);
    cannon = new RectDC(c, -2, 0, 4, -33);
    registerComponent(controller);
    registerComponent(body);
    registerComponent(cannon);
  }
}

// BULLET
public class BulletController extends Component {
  public PVector speed;
  public float timeToLive;  // In seconds
  
  public BulletController(float x, float y, float a, float t) {
    super();
    this.speed = new PVector(x, y, a);
    this.timeToLive = t;
  }
  
  public BulletController(PVector dir, float t) {
    super();
    this.speed = dir;
    this.timeToLive = t;
  }
  
  @Override
  public void update(float delta) {
    PVector direction = speed.copy();
    direction.mult(delta);
    transform().move(direction);
    
    timeToLive -= delta;
    if (timeToLive <= 0) {
      entity().scene.despawn(entity());
    }
  }
}

public class Bullet extends Entity {
  BulletController controller;
  RectDC body;;
  
  public Bullet(color c, PVector pos, PVector dir, float t) {
    super(pos);
    controller = new BulletController(dir, t);
    body = new RectDC(c, -2, -5, 4, 10);
    registerComponent(controller);
    registerComponent(body);
  }
  
  public Bullet(color c, float x, float y, float a, float vX, float vY, float vA, float t) {
    super(x, y, a);
    controller = new BulletController(vX, vY, vA, t);
    body = new RectDC(c, -2, -5, 4, 10);
    registerComponent(controller);
    registerComponent(body);
  }
}
