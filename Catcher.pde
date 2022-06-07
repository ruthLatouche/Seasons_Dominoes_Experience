class Catcher {

  PVector loc;
  PVector vel;
  
  public Catcher(float _px, float _py) {
    loc = new PVector(_px, _py);
    vel = new PVector(0,0);
  }
  
  void display() {
    fill(100,60);
    circle(loc.x,loc.y,50);
  }
  
  void move() {
    loc.add(vel);
    
    if (loc.x < 0) {
      loc.x = 0;
      vel.x = 0;
    }
    else if (loc.x >= widthStage) {
      loc.x = widthStage;
      vel.x = 0;
    }
      
    if (loc.y < 0) {
      loc.y = 0;
      vel.y = 0;
    }
    else if (loc.y >= heightStage) {
      loc.y = heightStage;
      vel.y = 0;
    }
  }
  
  void update(float _vx, float _vy) {
    vel.x = _vx;
    vel.y = _vy;
  }
  
  PVector getPos() {
    return loc;
  }
}
