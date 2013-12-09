class Ship {

  Sprite me;
  Sprite damaged;
  Sprite shield;
  boolean shoot;
  double time;
  double shieldTimer;
  int bonus;
  int init;
  int life;
  int score;
  float invincible;

  Ship(Sprite _s, Sprite _d, Sprite _shield)
  {
    me = _s;
    damaged = _d;
    shield = _shield;
    me.setFrameSequence(0, 7, 0.2f);
    me.setDead(false);
    damaged.setFrameSequence(0, 7, 0.2f);
    damaged.setDead(false);
    shield.setFrameSequence(0, 4, 0.2f);
    shield.setScale(4);
    shield.setVisible(false);
    shieldTimer = 0.0;
    shoot = false;
    me.setXY(150, 250);
    damaged.setVisible(false);
    init = 0;
    time = 0.0;
    bonus = 0;
    life = 3;
    invincible = 4.0;
    me.setCollisionRadius(0.9);
    score = 0;
  }
  
  public int getLife()
  {
    return life;
  }

  public void pre(double elapsedTime)
  {
    time += elapsedTime;

    if (shieldTimer > 0.0)
    {
      shieldTimer -= elapsedTime;
    }
    
    if (shieldTimer < 0.0)
    {
     shieldTimer = 0.0; 
     shield.setVisible(false);
    }
    
    if (time - bonus > 0.2)
    {
     shoot = true;
     time = 0.0; 
    }
    
    if (damaged.isVisible())
    {
      invincible -= elapsedTime;
      if (invincible < 0)
      {
        invincible = 4.0;
        damaged.setVisible(false); 
      }
    }
  }
  
  public void activeShield()
  {
    shield.setVisible(true);
    shieldTimer = 5.0;
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
    else if  (init == -1) {
      me.setXY(5000, 5000);
      damaged.setXY(5000, 5000);
    }
    else {
      me.setXY(mouseX, mouseY);
      damaged.setXY(mouseX, mouseY);
      shield.setXY(mouseX, mouseY);
    }
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
 
  public boolean damaged()
  {
    if (shield.isVisible())
    {
      return false;
    }
    
    damaged.setVisible(true);
    if (invincible != 4.0)
      return false;
    if (--life < 0) {
      shoot = false;
      me.setDead(true);
      damaged.setDead(true);
      init = -1;
    }
    return true;
  } 
  
}

