class GifInteracciones {
  
  SpriteSheet ani;
  PVector coordenadas;
  boolean activo;
  
  public GifInteracciones(PVector _loc, String tipo){
   if(tipo == "shake"){
     ani = new SpriteSheet("IconShake/", 81,"png");
   }
   else if(tipo == "dragup"){
     ani = new SpriteSheet("IconDragUp/", 41,"png");
   }
   else if(tipo == "finalgif"){
     ani = new SpriteSheet("FinalGif/", 119,"png");
   }
   else if(tipo == "dragleft"){
     ani = new SpriteSheet("IconDragLeft/", 81,"png");
   }
   else if(tipo == "tap"){
     ani = new SpriteSheet("IconTap/", 81,"png");
   }
   else if(tipo == "tapToContinue"){
     ani = new SpriteSheet("TapToContinue/", 61,"png");
   }
   
   coordenadas = _loc;
   ani.loop();
   ani.play(); 
  }
  
  void display(){
    imageMode(CENTER);
    ani.display(coordenadas.x, coordenadas.y);
    if (ani.isFinished())
      activo = false;
  }
  
  boolean esta() {
    return activo;
  }
  
  
}
