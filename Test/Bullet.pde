class Bullet {
 
  Sprite me;
  int type;
 
  Bullet(Sprite _s, int _t)
  {
    me = _s;
    me.setFrameSequence(0, 3, 0.2f);
     if (_t != 0)
     {
       me.setRot(-67.5);
     }
     else
     {
       me.setScale(0.2);
     }
    me.setVelX(300.0);
    me.setDead(false);
    type = _t;
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
  
  public void touchEnnemy(Ennemy e)
  {
    if (me.cc_collision(e.getSprite()))
     {
       if (type == 0)
       {
         e.kill(1);
       }
       else if (e.getType() == type)
       {
         e.kill(5);
       }
       else
       {
         e.kill(2);
       }
       me.setXY(-100, -100);
     } 
  }
}

