class Bomb {
 
  Sprite fire;
  Sprite ice;
  Sprite thunder;
  double _timer;
 
  Bomb(Sprite _f, Sprite _i, Sprite _t)
  {
    fire = _f;
    fire.setFrameSequence(0, 3, 0.2f);
    fire.setScale(5);
    fire.setRot(-67.5);
    fire.setVisible(false);
    _timer = 2.0;

    ice = _i;
    ice.setFrameSequence(0, 3, 0.2f);
    ice.setScale(0);

    thunder = _t;
    thunder.setFrameSequence(0, 3, 0.2f);
    thunder.setScale(0);
  }

  public void pre(double elapsedTime)
  {
    if (fire.isVisible()) {
      _timer -= elapsedTime;
    }
    if (_timer <= 0.0)
    {
     fire.setVisible(false); 
    }
    fire.setXY(mouseX + 310, mouseY); 
  }
  
  public void fire()
  {
    fire.setFrame(0);
    fire.setFrameSequence(0, 3, 0.2f);
    fire.setVisible(true); 
//    ice.setXY(mouseX + 100, mouseY); 
//    thunder.setXY(mouseX + 100, mouseY); 
  }

  
  public int touchEnnemy(Ennemy e)
  {
    int score = 0;
    
//    if (me.cc_collision(e.getSprite()))
//     {
//       if (type == 0)
//       {
//         score = e.kill(1);
//       }
//       else if (e.getType() == type)
//       {
//         score = e.kill(10);
//       }
//       me.setXY(-100, -100);
//     }
     return score;
  }
}

