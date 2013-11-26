class Ship {

  Sprite me;
  boolean shoot;
  double time;
  int bonus;
  int init;

  Ship(Sprite _s)
  {
    me = _s;
    me.setFrameSequence(0, 7, 0.2f);
    me.setDead(false);
    shoot = false;
    me.setXY(150, 250);
    init = 0;
    time = 0.0;
    bonus = 0;
    me.setCollisionRadius(1);
  }

  public void pre(double elapsedTime)
  {
    time += elapsedTime;
    if (time - bonus > 0.2)
    {
     shoot = true;
     time = 0.0; 
    }
  }
  
  public void bonus()
  {
     bonus = 1; 
  }
  
  public void setXY(double x, double y)
  {
    me.setXY(x, y);
  }
  
  public Sprite getSprite()
  {
    return me; 
  }
  
  public double getX()
  {
    return me.getX(); 
  }

  public double getY()
  {
    return me.getY(); 
  }
  
  public void draw()
  {
    if (init == 0)
    {
      me.setXY(150, 250);
      init++;
    }
    else if  (init == -1)
      me.setXY(5000, 5000);
    else
      me.setXY(mouseX, mouseY);
    
  }

  public boolean allowedShoot()
  {
    if (shoot)
    {
      shoot = false;
     return true; 
    }
    return false;
  }
  
  public void moveUp()
  {
   me.setY(me.getY() - 5.0);
  } 

  public void moveDown()
  {
   me.setY(me.getY() + 5.0);
  } 

  public void moveLeft()
  {
   me.setX(me.getX() - 5.0);
  } 

  public void moveRight()
  {
   me.setX(me.getX() + 5.0 );
  } 
  
}

