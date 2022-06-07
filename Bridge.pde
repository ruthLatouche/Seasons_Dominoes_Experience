class Bridge {

  // Bridge properties
  float totalLength, xStep, yStep;  // How long
  int numPoints;      // How many points
  int miXinicial, miYinicial, miXfinal, miYfinal;

  // Our chain is a list of particles
  ArrayList<Square> piezas;

  // Chain constructor
  Bridge(int _xI, int _yI, int _xF, int _yF, int n) {
    numPoints = n;
    miXinicial = _xI;
    miYinicial = _yI;
    miXfinal = _xF;
    miYfinal = _yF;

    piezas = new ArrayList();
    float len = 0.1;
    //float len = dist(miXinicial, miYinicial, miXfinal, miYfinal) / numPoints;
    xStep = (miXfinal-miXinicial)/numPoints;
    yStep = (miYfinal-miYinicial)/numPoints;

    // Here is the real work, go through and add particles to the chain itself
    for (int i=0; i < numPoints+1; i++) {
      // Make a new particle
      Square p = null;

      // primera particula que es STATIC
      if (i == 0) p = new Square(miXinicial, miYinicial,10, true);
      // segunda particula que es STATIC
      else if (i == numPoints) p = new Square(miXfinal, miYfinal,10, true);
      // todas las demás particulas que son DINAMIC
      else p = new Square(miXinicial+i*xStep, miYinicial+i*yStep, 10, false);

      piezas.add(p);

      // Connect the particles with a distance joint
      if (i > 0) {
        DistanceJointDef djd = new DistanceJointDef();
        Square previous = piezas.get(i-1);
        // Connection between previous particle and this one
        djd.bodyA = previous.body;
        djd.bodyB = p.body;
        // Equilibrium length
        djd.length = myWorld.scalarPixelsToWorld(len);
        // These properties affect how springy the joint is 
        djd.frequencyHz = 7; //0=no elasticity | 1=very elastic | 9 very hard
        djd.dampingRatio = 0; //0

        // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
        // We might need to someday, but for now it's ok
        DistanceJoint dj = (DistanceJoint) myWorld.world.createJoint(djd);
      }
    }
  }
  
  PVector getPos(){
    return new PVector(miXinicial, miYinicial);
  }
  

  // Draw the bridge
  void display() {
    for (Square d : piezas) {
      d.displayCirc();
    }
  }
}
