class Bullet {
 
  Sprite me;
 
  Bullet(Sprite _s)
  {
    me = _s;
    me.setFrameSequence(0, 3, 0.2f);
    me.setRot(-67.5);
    me.setVelX(300.0);
    me.setDead(false);
  }

  public void pre(double elapsedTime)
  {
//    S4P.updateSprites(elapsedTime);
  }

  public void draw()
  {
    me.draw();
  }
  
  public boolean isOnScreem()
  {
    return me.isOnScreem();  
  }

  public void fire(double _x, double _y)
  {
    me.setXY(_x, _y); 
  }
}

