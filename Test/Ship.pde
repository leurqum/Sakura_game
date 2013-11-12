class Ship {

  Sprite me;
  boolean shoot;
  double time;

  Ship(Sprite _s)
  {
    me = _s;
    me.setFrameSequence(0, 3, 0.2f);
    me.setDead(false);
    shoot = false;
    time = 0.0;
  }

  public void pre(double elapsedTime)
  {
    time += elapsedTime;
    if (time > 0.2)
    {
     shoot = true;
     time = 0.0; 
    }
  }
  
  public void setXY(double x, double y)
  {
    me.setXY(x, y);
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

