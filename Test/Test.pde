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
Bullet[] bulletsB = new Bullet[NBR_BULLET];
Ennemy[] ennemies = new Ennemy[NBR_BULLET];
int bulletFiring = 0;
int lastEnnemy;
float typeTime;
boolean typeActive;


public void setup() 
{
  size(1280, 550);
  bimg = loadImage("Sprite\\Background.jpg");
  lastEnnemy = 0;
  typeTime = 2.5;
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    bulletsB[i] = new Bullet(new Sprite(this, "Sprite\\Bullet_Base.png", 1, 1, 49), 0);
    bulletsB[i].fire(-100, -100);
    bulletsW[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestW.png", 4, 1, 50), 1);
    bulletsW[i].fire(-100, -100);
    bulletsF[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestF.png", 4, 1, 51), 2);
    bulletsF[i].fire(-100, -100);
    bulletsT[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestT.png", 4, 1, 52), 3);
    bulletsT[i].fire(-100, -100);
    if ((i % 2) == 0) {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyW.png", 3, 1, 53), 1);  
    }
    else if ((i % 3) == 0) {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyN.png", 3, 1, 53), 2); 
    }
    else {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyF.png", 2, 1, 53), 3); 
    }
    ennemies[i].getSprite().setDomain(-40, -40, width+ennemies[i].getSprite().getWidth()/2, height+ennemies[i].getSprite().getHeight()/2, Sprite.REBOUND);
    ennemies[i].setXY(-40,random(-300, 300));
    ennemies[i].getSprite().setSpeed(random(-100, 100),random(-300, 300));
  }
  vessel = new Ship(new Sprite(this, "Sprite\\Sakura_walking.png", 3, 1, 50));

  registerMethod("keyEvent", this);  //keyboad handler
  registerMethod("pre", this);
}


public void keyEvent(KeyEvent e)
{
  if (!typeActive) {
    switch(e.getKeyCode()) {
    case 'Q':
      bulletFiring = 1;
      typeActive = true;
      break;
    case 'W':
      bulletFiring = 2;
      typeActive = true;
      break;
    case 'E':
      bulletFiring = 3;
      typeActive = true;
      break;
    }
  }
}

public void pre() {
  double elapsedTime = sw.getElapsedTime();
  S4P.updateSprites(elapsedTime);
  vessel.pre(elapsedTime);
  
  if (typeTime <= 0)
  {
    typeActive = false;
    bulletFiring = 0; 
    typeTime = 2.5;
  }
  typeTime -= elapsedTime;
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    for (int u = 0; u < NBR_BULLET; ++u) {
     if (ennemies[u].getType() == 1)
       bulletsW[i].touchEnnemy(ennemies[u]);
     else if (ennemies[u].getType() == 2)
       bulletsF[i].touchEnnemy(ennemies[u]);
     else if (ennemies[u].getType() == 3)
       bulletsT[i].touchEnnemy(ennemies[u]);
     else
       bulletsB[i].touchEnnemy(ennemies[u]);
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
  for (int i = 0; i < NBR_BULLET; ++i)
    {
      ennemies[i].update(width);
    }
  if (vessel.allowedShoot()) {
    for (int i = 0; i < NBR_BULLET; ++i)
    {
      if (bulletFiring == 1 && !bulletsW[i].isOnScreem())
      {
        bulletsW[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 2 && !bulletsF[i].isOnScreem())
      {
        bulletsF[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 3 && !bulletsT[i].isOnScreem())
      {
        bulletsT[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 0 && !bulletsB[i].isOnScreem())
      {
        bulletsB[i].fire(vessel.getX(), vessel.getY());
        break;
      }
    }
  }

  vessel.draw();
  S4P.drawSprites();
}

