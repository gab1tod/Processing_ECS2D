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

  @Override
    public void init() {
    // Setup camera
    Camera cam = new Camera(800/2, 450/2, 0);
    this.camera = cam.component;
    spawn(cam);
    cam.component.zoom = height / 450.0;

    // Setup player
    player = new Tank(color(255, 0, 0), 800/2, 450/2, 0);
    spawn(player);

    // TODO: remove after tests
    //cam.transform.moveTo(0, 0, 0);
    //cam.transform.parent = player.turret.transform;
    cam.follow(player.transform, false);

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
  public float speedInputSpeed = 0.15;  // Input reactivity between 0..1
  public float turnSpeed = 1.5;  // Radian/s
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

  @Override
    public void update(float delta) {
    float direction = 0;
    if (game.pressedKeys.containsKey(LEFT)) direction --;
    if (game.pressedKeys.containsKey(RIGHT)) direction ++;
    
    turnInput += (direction - turnInput) * turnInputSpeed;
    transform().move(0, 0, turnInput * turnSpeed * delta);
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
    public void onSpawn(System system) {
    super.onSpawn(system);

    system.spawn(turret);
  }

  @Override
    public void onDespawn() {
    if (system() != null) system().despawn(turret);

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
