class Ennemy {

  Sprite me;
  boolean shoot;
  double time;
  int type;
  double health;

  Ennemy(Sprite _s, int _type)
  {
    me = _s;
    me.setFrameSequence(0, 3, random(0.1f, 0.3f));
    me.setDead(false);
    type = _type;
    shoot = false;
    time = 0.0;
    health = 5.0;
  }

  public void pre(double elapsedTime)
  {

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
  
  public void setVelX(float vel)
  {
    me.setVelX(vel);
  }
  
  public Sprite getSprite()
  {
    return me; 
  }
  
  public void kill(double damage)
  {
    health -= damage;
    if (health <= 0)
    {
      me.setXY(width + 50, (random(10, height - 10)));
      me.setVelX(me.getVelX() * 1.05f);
      health = 5;
    }
  }
  
  public int getType()
  {
    return type; 
  }
  
  public void update(int w)
  {
    if (me.getX() < 0)
      me.setX(w + 50);
  }
  
  public void touchShip(Ship s)
  {
    if (me.cc_collision(s.getSprite()))
    {
       if (s.damaged()) {
         me.setXY(width + 50, (random(10, height - 10)));
         me.setVelX(me.getVelX() * 1.05f);
         health = 5;
       }
    }
  }
}

