class Domino {
  Body body; // cuerpo de la particula
  float w, h;
  color col;
  String t;




  //----------------------------------------------------------
  Domino(float x, float y, float wid, float hei, String tipo) { 
    
    w = wid;
    h = hei;
    t = tipo;
    makeMyBody (x, y);

    // genera una velocidad inicial tanto linear como angular
    body.setLinearVelocity(new Vec2(0, 0));
    body.setAngularVelocity(0);
  } // end of Box





  //----------------------------------------------------------
  // responde si la particula esta fuera de la pantalla para eliminarla
  boolean done() {
    // se pregunta a la biblioteca dónde está la particula
    Vec2 pos = myWorld.getBodyPixelCoord(body);
    // está la partícula aun dentr de la partícula?
    if (pos.y > height+h*2 || pos.x < -w || pos.x > width+w ) {
      myWorld.destroyBody(body);
      return true;
    }
    return false;
  } // end of 


PVector getPos() {
    return myWorld.getBodyPixelCoordPVector(body);
  }
  
  
  float getAngle(){
    float a = body.getAngle();
    return degrees(a);
  }
  
  String getTipo(){
   return t; 
  }
  



  //----------------------------------------------------------
  void display() {
    // se pregunta a la biblioteca dónde está la particula
    Vec2 pos = myWorld.getBodyPixelCoord(body);  
    // se pregunta a la biblioteca en qué ángulo está la particula
    float a = body.getAngle();

    // se guardan la posicón actual del centro del sistema de coordenadas
    pushMatrix();
    // se traslada el centro de las coordenadas a la posicion de la partícula
    translate(pos.x, pos.y); 
    // se rota el sistema coordenado en el ángulo que esté la partícula
    rotate(-a);              
    fill(colDom);
    noStroke();
    rectMode(CENTER);
    // y se dibuja el rectangulo
    rect(0, 0, w, h);
    // se vuelve el sistema de coordenadas a la posición y angulo antes de la tansfromación
    popMatrix();
  } // end of Display
  
  
  // Display Interactivo
    void displayInt() {
    // se pregunta a la biblioteca dónde está la particula
    Vec2 pos = myWorld.getBodyPixelCoord(body);  
    // se pregunta a la biblioteca en qué ángulo está la particula
    float a = body.getAngle();

    // se guardan la posicón actual del centro del sistema de coordenadas
    pushMatrix();
    // se traslada el centro de las coordenadas a la posicion de la partícula
    translate(pos.x, pos.y); 
    // se rota el sistema coordenado en el ángulo que esté la partícula
    rotate(-a);              
    fill(#FF3333);
    noStroke();
    rectMode(CENTER);
    // y se dibuja el rectangulo
    rect(0, 0, w, h);
    // se vuelve el sistema de coordenadas a la posición y angulo antes de la tansfromación
    popMatrix();
  } // end of Display
  
  void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
    //t.makeVibrate();
  }

  //----------------------------------------------------------
  void makeMyBody (float x, float y) {
    // se crea el cuerpo principal
    BodyDef bd = new BodyDef();    // new body  
    bd.type = BodyType.DYNAMIC;    // se define como DINAMICO
    // se obtiene el punto deseado en coordenadas del mundo virtual
    Vec2 puntoEnElEspacioVirtual = myWorld.coordPixelsToWorld(x, y);
    bd.position.set(puntoEnElEspacioVirtual);
    body = myWorld.createBody(bd);

    // se crea la forma (shape) que en este caso es un rectangulo
    PolygonShape ps = new PolygonShape();
    // define las dimensiones de la forma en coordenadas virtuales
    float box2dW = myWorld.scalarPixelsToWorld(w/2);      // changing screen to virtual world size
    float box2dH = myWorld.scalarPixelsToWorld(h/2);  // Box2D considers the width and height of a
    ps.setAsBox(box2dW, box2dH);            

    // define la fixture
    FixtureDef fd = new FixtureDef();    // declares link between the body and form
    fd.shape = ps;
    
    // como es dinámico se necesita definir las propiedades físicas
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // se unen el cuerpo y la forma               
    body.createFixture(fd);   
    body.setUserData(this);// connecting shape) to body
  } // end of makeMyBody
  
  float posx(){
   Vec2 pos = myWorld.getBodyPixelCoord(body);
   return pos.x; 
  }
  
  float posy(){
   Vec2 pos = myWorld.getBodyPixelCoord(body);
   return pos.y; 
  }
  
  
} // end of class 
