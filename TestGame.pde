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
    Camera cam = new Camera(width/2, height/2, 0);
    this.camera = cam.component;
    spawn(cam);

    // Setup player
    player = new Tank(color(255, 0, 0), width/2, height/2, 0);
    spawn(player);

    // TODO: remove after tests
    //cam.transform.moveTo(0, 0, 0);
    //cam.transform.parent = player.transform;
    cam.follow(player.transform, false);

    // Grid background
    Entity grid = new Entity(0, 0, 0);
    Component gridDC = new DisplayComponent() {
      @Override
        public void displayTransformed() {
        stroke(0, 255, 0, 100);
        strokeWeight(1);

        for (int i=0; i<=16; i++) {
          line(i * width/16, 0, i * width/16, height);
        }
        for (int i=0; i<=9; i++) {
          line(0, i * height/9, width, i * height/9);
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
  public float turnSpeed = 1.5;  // Radian/s

  @Override
    public void update(float delta) {
    PVector direction = new PVector(0, 0, 0);
    if (game.pressedKeys.values().contains('z')) direction.y --;
    if (game.pressedKeys.values().contains('s')) direction.y ++;
    if (game.pressedKeys.values().contains('q')) direction.z --;
    if (game.pressedKeys.values().contains('d')) direction.z ++;
    direction.y *= speed * delta;
    direction.z *= turnSpeed * delta;
    direction.rotate(transform().angle());
    transform().move(direction);
  }
}

public class TurretController extends Component {
  public float turnSpeed = 1.5;  // Radian/s

  @Override
    public void update(float delta) {
    float direction = 0;
    if (game.pressedKeys.containsKey(LEFT)) direction --;
    if (game.pressedKeys.containsKey(RIGHT)) direction ++;
    direction *= turnSpeed * delta;
    transform().move(0, 0, direction);
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
    cannon = new RectDC(c, -2, 0, 4, -30);
    registerComponent(controller);
    registerComponent(body);
    registerComponent(cannon);
  }

  public Turret(color c, float x, float y, float z) {
    super(x, y, z);
    controller = new TurretController();
    body = new RectDC(c, -10, -10, 20, 20);
    cannon = new RectDC(c, -2, 0, 4, -30);
    registerComponent(controller);
    registerComponent(body);
    registerComponent(cannon);
  }
}
