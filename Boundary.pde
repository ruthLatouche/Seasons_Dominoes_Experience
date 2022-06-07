class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  float r;
  String figura="";
  color col;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  Boundary(float x_,float y_, float w_, float h_, float a_, color clr) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    figura = "rect";
    col = clr;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = myWorld.scalarPixelsToWorld(w/2);
    float box2dH = myWorld.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.angle = a_;
    bd.position.set(myWorld.coordPixelsToWorld(x,y));
    b = myWorld.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
    b.setUserData(this);
  }
  
  Boundary(float x_,float y_, float r_) {
    x = x_;
    y = y_;
    r = r_;
    
    figura = "circ";
    // Define the polygon
    CircleShape cs = new CircleShape();
    // We're just a box
    cs.m_radius = myWorld.scalarPixelsToWorld(r_);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(myWorld.coordPixelsToWorld(x,y));
    b = myWorld.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(cs,1);
    b.setUserData(this);
  }
  
  void killBody() {
    myWorld.destroyBody(b);
  }
  
  PVector getPos() {
    return myWorld.getBodyPixelCoordPVector(b);
  }
  
  void setPos(float x, float y){
     b.setTransform(myWorld.coordPixelsToWorld(x, y), b.getAngle());
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    pushMatrix();
    noStroke();
    fill(col);
    
    translate(x,y);
    
    float a = b.getAngle();
    rotate(-a);
    rectMode(CENTER);
    rect(0,0,w,h);

    popMatrix();
  }
  
  void displayInt(float x_, float y_, color tipo) {
    pushMatrix();
    noStroke();
    fill(tipo);
    
    translate(x_,y_);
    
    float a = b.getAngle();
    rotate(-a);
    rectMode(CENTER);
    rect(0,0,w,h);

    popMatrix();
  }
    

}
