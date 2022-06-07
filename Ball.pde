class Ball{
 // We need to keep track of a Body and a width and height
  Body body;
  float r;
  boolean contact;

  // Constructor
  Ball(float x_, float y_, float r_) {
    
    contact = false;
    
    float x = x_;
    float y = y_;
    r = r_; 
    
    makeBody(new Vec2(x,y),r);
    body.setUserData(this); //necesario para validar la colision

  }
  
  void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }
  
  PVector getPos() {
    return myWorld.getBodyPixelCoordPVector(body);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    myWorld.destroyBody(body);
  }
  

  boolean contains(float x, float y) {
    Vec2 worldPoint = myWorld.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = myWorld.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    //rectMode(PConstants.CENTER);
    ellipseMode(CENTER);
    noStroke();
    fill(colDom);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    circle(0,0,r*2);
    popMatrix();
  }
  
   void displayInt1() {
    // We look at each body and get its screen position
    Vec2 pos = myWorld.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    //rectMode(PConstants.CENTER);
    ellipseMode(CENTER);
    noStroke();
    fill(tipoInteractivo1);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    circle(0,0,r*2);
    popMatrix();
  }
  
  void displayInt2() {
    // We look at each body and get its screen position
    Vec2 pos = myWorld.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    //rectMode(PConstants.CENTER);
    ellipseMode(CENTER);
    noStroke();
    fill(tipoInteractivo2);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    circle(0,0,r*2);
    popMatrix();
  }


  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float r) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(myWorld.coordPixelsToWorld(center));
    body = myWorld.createBody(bd);

    CircleShape cs = new CircleShape();
    cs.m_radius = myWorld.scalarPixelsToWorld(r);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    //fd.shape = sd;
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(0, 0));
    body.setAngularVelocity(0);
  }
}
