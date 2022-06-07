// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A rectangular box

// modified by franklin hernandez-castro
// www.skizata.com
// tec costa rica | HfG shcwae. gmuend | 2020

class Particle {
  Body body; // cuerpo de la particula
  float w, h; // ancho y alto
  PImage hoja1, hoja2, hoja3, copoNieve; 
  String tipo;
  int tipoHoja; 
  



  //----------------------------------------------------------
  Particle(float x, float y, String t) { 
    w = 10; // ancho y alto
    h = 10;
    tipo = t;
    makeMyBody (x, y);
    
    tipoHoja = int(random(1,4));    
    hoja1 = loadImage("hoja1.png");
    hoja2 = loadImage("hoja2.png");
    hoja3 = loadImage("hoja3.png");


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
    if(tipo == "Fall"){
      if (tipoHoja == 1) image(hoja1, -w/2, -h/2, w,h);
      if (tipoHoja == 2) image(hoja2, -w/2, -h/2, w,h);
      if (tipoHoja == 3) image(hoja3, -w/2, -h/2, w,h);
    }
    //if(tipo == "Winter") image(copoNieve, -w/2, -h/2, w,h);
       
    noStroke();
    popMatrix();
  } // end of Display





  //----------------------------------------------------------
  // responde si el punto pregunatdo está o no dentro de la partícula
  boolean contains(float x, float y) {
    // se traduce el punto a coordenadas en el mundo virtual
    Vec2 worldPoint = myWorld.coordPixelsToWorld(x, y);
    // se prgunta si el punto está dentro del body
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
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
    body.createFixture(fd);            // connecting shape) to body
  } // end of makeMyBody
  
  
  
  
} // end of class 
