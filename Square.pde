class Square {

  // We need to keep track of a Body and a radius
  Body body;
  float h, w, r;

  Square(float x, float y, float wid, float hei, boolean fixed) {
    w = wid;
    h = hei;
    
    // Define a body
    BodyDef bd = new BodyDef();
    if (fixed) bd.type = BodyType.STATIC;
    else bd.type = BodyType.DYNAMIC;
    
    PolygonShape ps = new PolygonShape();

    // define las dimensiones de la forma en coordenadas virtuales
    float box2dW = myWorld.scalarPixelsToWorld(w/2);      // changing screen to virtual world size
    float box2dH = myWorld.scalarPixelsToWorld(h/2);  // Box2D considers the width and height of a
    ps.setAsBox(box2dW, box2dH);            

    // Set its position
    bd.position = myWorld.coordPixelsToWorld(x,y);
    body = myWorld.world.createBody(bd);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    
    body.createFixture(fd);
  }
  
  Square(float x, float y, float rad, boolean fixed) {
     r = rad;
    
    // Define a body
    BodyDef bd = new BodyDef();
    if (fixed) bd.type = BodyType.STATIC;
    else bd.type = BodyType.DYNAMIC;

    // Set its position
    bd.position = myWorld.coordPixelsToWorld(x,y);
    body = myWorld.world.createBody(bd);

    // Make the body's shape a circle
    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = myWorld.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    
    body.createFixture(fd);
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
    if (pos.y > height+h/2) {
      killBody();
      return true;
    }
    return false;
  }
  
  float getAngle(){
   float a = body.getAngle(); 
   return -a;
  }

  // 
  void displayRect() {
    // We look at each body and get its screen position
    Vec2 pos = myWorld.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    stroke(0);
    fill(colDom);
    noStroke();
    rectMode(CORNER);
    rect(-w/2,-h/2,w,h);
    popMatrix();
  }
  
  void displayCirc() {
    // We look at each body and get its screen position
    Vec2 pos = myWorld.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    stroke(0);
    fill(colDom);
    noStroke();
    circle(0,0,r);
    popMatrix();
  }


}
