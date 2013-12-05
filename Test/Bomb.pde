class Bomb {
 
  Sprite fire;
  Sprite ice;
  Sprite thunder;
  double _timer;
 
  Bomb(Sprite _f, Sprite _i, Sprite _t)
  {
    fire = _f;
    fire.setFrameSequence(0, 6, 0.2f);
    fire.setScale(5);
    fire.setRot(-67.5);
    fire.setVisible(false);
    _timer = 1.0;

    ice = _i;
    ice.setFrameSequence(0, 6, 0.2f);
    ice.setRot(-67.5);
    ice.setScale(5);
    ice.setVisible(false);

    thunder = _t;
    thunder.setFrameSequence(0, 8, 0.14f);
    thunder.setRot(-67.5);
    thunder.setScale(5);
    thunder.setVisible(false);
  }

  public boolean isActive()
  {
    return fire.isVisible() || ice.isVisible() || thunder.isVisible();
  }

  public void pre(double elapsedTime)
  {
    if (fire.isVisible() || ice.isVisible() || thunder.isVisible()) {
      _timer -= elapsedTime;
    }
    if (_timer <= 0.0)
    {
     fire.setVisible(false);
     fire.setFrame(0);
     ice.setVisible(false);
     ice.setFrame(0);
     thunder.setVisible(false);
     thunder.setFrame(0);
     _timer = 1.0;
    }
    fire.setXY(mouseX + 310, mouseY); 
    ice.setXY(mouseX + 310, mouseY); 
    thunder.setXY(mouseX + 310, mouseY + 30); 
  }
  
  public void fire(int bulletType)
  {
    if (bulletType == 2)
    {
      fire.setFrame(0);
      fire.setFrameSequence(0, 6, 0.2f);
      fire.setVisible(true);
    }
    if (bulletType == 1)
    {
      ice.setFrame(0);
      ice.setFrameSequence(0, 6, 0.2f);
      ice.setVisible(true);
    }
    if (bulletType == 3)
    {
      thunder.setFrame(0);
      thunder.setFrameSequence(0, 4, 0.2f);
      thunder.setVisible(true);
    }
  }

  
  public int touchEnnemy(Ennemy e)
  {
    if (fire.isVisible() && fire.cc_collision(e.getSprite()))
     {
         return e.kill(2);
     }
    if (ice.isVisible() && ice.cc_collision(e.getSprite()))
     {
         return e.kill(2);
     }
    if (thunder.isVisible() && thunder.cc_collision(e.getSprite()))
     {
         return e.kill(2);
     }
     return 0;
  }
}

