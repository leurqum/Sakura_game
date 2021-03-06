class Bullet {
 
  Sprite me;
  int type;
 
  Bullet(Sprite _s, int _t)
  {
    me = _s;
    me.setFrameSequence(0, 3, 0.2f);
    if (_t != 0 && _t != 1)
    {
      me.setRot(-67.5);
    }
    else if (_t != 1)
    {
      me.setScale(0.2);
    }
    else
    {
      me.setScale(0.7);
    }
    me.setVelX(300.0);
    me.setDead(false);
    type = _t;
  }

  public void draw()
  {
    me.draw();
  }
  
  public Sprite getSprite()
  {
    return me; 
  }
  
  public boolean isOnScreem()
  {
    return me.isOnScreem();  
  }

  public void fire(double _x, double _y)
  {
    me.setXY(_x + 60, _y + 15); 
  }
  
  public void setScale(double s)
  {
    me.setScale(s); 
  }
  
  public int touchEnnemy(Ennemy e)
  {
    int score = 0;
    
    if (me.cc_collision(e.getSprite()))
     {
       if (e.getType() == 0 && type == 0)
       {
         score = e.kill(3);
       }
       else if (e.getType() == type)
       {
         score = e.kill(10);
       }
       else if (type == 0)
       {
        score = e.kill(1); 
       }
       else
       {
        score = e.kill(0.5); 
       }
       me.setXY(-100, -100);
     }
     return score;
  }
}

