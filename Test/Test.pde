import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

StopWatch sw = new StopWatch();
int NBR_BULLET = 25;
PImage bimg;

Ship vessel;
Bullet[] bulletsW = new Bullet[NBR_BULLET];
Bullet[] bulletsF = new Bullet[NBR_BULLET];
Bullet[] bulletsT = new Bullet[NBR_BULLET];
Ennemy[] ennemies = new Ennemy[NBR_BULLET];
int bulletFiring = 0;
int lastEnnemy;


public void setup() 
{
  size(1280, 550);
  //  size(3840, 1080);
  bimg = loadImage("Sprite\\Background.jpg");
  lastEnnemy = 0;
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    bulletsW[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestW.png", 4, 1, 50));
    bulletsW[i].fire(-100, -100);
    bulletsF[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestF.png", 4, 1, 51));
    bulletsF[i].fire(-100, -100);
    bulletsT[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestT.png", 4, 1, 52));
    bulletsT[i].fire(-100, -100);
    if ((i % 2) == 0) {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyW.png", 3, 1, 53), 0);  
    }
    else if ((i % 3) == 0) {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyN.png", 3, 1, 53), 1); 
    }
    else {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyF.png", 2, 1, 53), 2); 
    }
    ennemies[i].setXY(-100, -100);
  }
  vessel = new Ship(new Sprite(this, "Sprite\\Sakura_walking.png", 3, 1, 50));

  registerMethod("keyEvent", this);  //keyboad handler
  registerMethod("pre", this);
}


public void keyEvent(KeyEvent e)
{
  switch(e.getKeyCode()) {
  case 'Q':
    bulletFiring = 0;
    break;
  case 'W':
    bulletFiring = 1;
    break;
  case 'E':
    bulletFiring = 2;
    break;
  }
}

public void pre() {
  double elapsedTime = sw.getElapsedTime();
  S4P.updateSprites(elapsedTime);
  vessel.pre(elapsedTime);
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    for (int u = 0; u < NBR_BULLET; ++u) {
     if (ennemies[u].getType() == 0)
       bulletsW[i].touchEnnemy(ennemies[u]);
     if (ennemies[u].getType() == 1)
       bulletsF[i].touchEnnemy(ennemies[u]);
     if (ennemies[u].getType() == 2)
       bulletsT[i].touchEnnemy(ennemies[u]);
    }
  }

  if (lastEnnemy == NBR_BULLET)
  {
    return;
  }
  if ((random(0, 240)) < 10)
  {
    ennemies[lastEnnemy].setXY(width + 50, (random(10, height - 10)));
    ennemies[lastEnnemy].setVelX(-1 * random(50, 100));
    ++lastEnnemy;
  }
}

void draw()
{
  background(bimg);

  if (vessel.allowedShoot()) {
    for (int i = 0; i < NBR_BULLET; ++i)
    {
      if (bulletFiring == 0 && !bulletsW[i].isOnScreem())
      {
        bulletsW[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      if (bulletFiring == 1 && !bulletsF[i].isOnScreem())
      {
        bulletsF[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      if (bulletFiring == 2 && !bulletsT[i].isOnScreem())
      {
        bulletsT[i].fire(vessel.getX(), vessel.getY());
        break;
      }
    }
  }

  vessel.draw();
  S4P.drawSprites();
}

