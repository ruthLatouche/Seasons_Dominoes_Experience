class Fijo {

  // Our object is two boxes and one joint
  // Consider making the fixed box much smaller and not drawing it
  CircPar par1;
  CircPar par2;
  float rad;
  String tipo; 
  PImage copoNieve, flor;

  Fijo(float x1, float y1, float r1, float x2, float y2, float r2, String t) {
    
    float len = dist(x1, y1, x2, y2); 

    // Initialize locations of two boxex
     par1 = new CircPar(x1, y1, r1, false, t); 
     par2 = new CircPar(x2, y2, r2, true, t); 
     rad = r1;
     tipo = t;
     copoNieve = loadImage("copoNieve.png");
     flor = loadImage("Flor.png");
     
     DistanceJointDef djd = new DistanceJointDef();
    // Connection between previous particle and this one
    djd.bodyA = par1.body;
    djd.bodyB = par2.body;
    // Equilibrium length
    djd.length = myWorld.scalarPixelsToWorld(len);
    
    // These properties affect how springy the joint is 
    djd.frequencyHz = 3;  // Try a value less than 5 (0 for no elasticity)
    djd.dampingRatio = 0.1; // Ranges between 0 and 1

    // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
    // We might need to someday, but for now it's ok
    DistanceJoint dj = (DistanceJoint) myWorld.world.createJoint(djd);
  }



  // Draw the bridge
  void display() {
    Vec2 pos1 = myWorld.getBodyPixelCoord(par1.body);
    Vec2 pos2 = myWorld.getBodyPixelCoord(par2.body);
    pushMatrix();
    stroke(0);
    //line(pos1.x,pos1.y,pos2.x,pos2.y);
    if (tipo == "Winter") par1.display(copoNieve);
    if (tipo == "Spring") par1.display(flor);

    popMatrix();
  }
}
