class CircPar {

  // We need to keep track of a Body and a radius
  Body body;
  
  float rad;
  String tipo;
  
  CircPar(float x, float y, float r, boolean lock, String t) {
    rad = r;
    tipo = t;
    
       
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = myWorld.coordPixelsToWorld(x,y);
    if (lock) bd.type = BodyType.STATIC;
    else bd.type = BodyType.DYNAMIC;
    body = myWorld.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = myWorld.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 0.9;
    fd.friction = 0.001;
    fd.restitution = 1.1;
    
    // Attach fixture to body
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2(0,0));

  }

  // This function removes the particle from the box2d world
  void killBody() {
    myWorld.destroyBody(body);
  }
  
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = myWorld.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+rad*2) {
      killBody();
      return true;
    }
    return false;
  }



  void display(PImage imagen) {
    // We look at each body and get its screen position
    Vec2 pos = myWorld.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    image(imagen, -rad, -rad, rad, rad);
    popMatrix();
  } 
  

}
