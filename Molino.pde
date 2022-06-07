class Molino{
  RevoluteJoint joint;
  Square aspa;
  Square base;
  RevoluteJointDef rjd;
  float posX, posY;
  
  Molino(float x, float y, float w, float h){
    
    //float x, float y, float wid, float hei, boolean fixed
    aspa = new Square(x, y, w, h, false);
    base = new Square(x, y, 5, true);
    posX = x;
    posY = y;
    
    rjd = new RevoluteJointDef();

    rjd.initialize(aspa.body, base.body, aspa.body.getWorldCenter());
    Vec2 offset = myWorld.vectorPixelsToWorld(new Vec2(0, 0));
    rjd.localAnchorB = offset;
    
    rjd.motorSpeed = 0;       // how fast?
    rjd.maxMotorTorque = 0; // how powerful?
    rjd.enableMotor = false; 
    
    joint = (RevoluteJoint) myWorld.world.createJoint(rjd);
  }
  
  float getAngle(){
   return aspa.getAngle();
  }
  

  
  PVector getPos(){
   return new PVector(posX,posY); 
  }
  
   void display() {
    // para que se desplieguen las partes
    aspa.displayRect();

    // Para el centro 
    Vec2 anchor = myWorld.coordWorldToPixels(aspa.body.getWorldCenter());
    
    ellipse(anchor.x, anchor.y, 2, 2);

  }
  
}
