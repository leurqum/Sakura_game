import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

StopWatch sw = new StopWatch();
int NBR_BULLET = 25;
Ship vessel;
Bullet[] bulletsW = new Bullet[NBR_BULLET];
Bullet[] bulletsF = new Bullet[NBR_BULLET];
Bullet[] bulletsT = new Bullet[NBR_BULLET];
Ennemy[] ennemies = new Ennemy[NBR_BULLET];
int bulletFiring = 0;
int lastEnnemy;


public void setup() 
{
  size(1200, 480);
  lastEnnemy = 0;
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    bulletsW[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestW.png", 4, 1, 50));
    bulletsW[i].fire(-100, -100);
    bulletsF[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestF.png", 4, 1, 51));
    bulletsF[i].fire(-100, -100);
    bulletsT[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestT.png", 4, 1, 52));
    bulletsT[i].fire(-100, -100);
    ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyW.png", 3, 1, 53));  
    ennemies[i].setXY(-100, -100);
}
  vessel = new Ship(new Sprite(this, "Sprite\\Sakura_walking.png", 3, 1, 50));

  registerMethod("keyEvent", this);  //keyboad handler
  registerMethod("pre", this);  //keyboad handler

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
//  S4P.updateSprites(sw.getElapsedTime());
//  println((random(0, 240)));
//  println("patate");
  if ((random(0, 240)) < 10)
  {
    if (lastEnnemy == NBR_BULLET)
      {
        return;
//        lastEnnemy = 0;
      }
    ennemies[lastEnnemy].setXY(width + 50, (random(10, height - 10)));
    ennemies[lastEnnemy].setVelX(-1 * random(50, 100));
    ++lastEnnemy;
  }
  
}

void draw()
{
  background(0);
  
  if (vessel.allowedShoot()){
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
println(lastEnnemy);  
  bulletsW[0].pre(sw.getElapsedTime());
//  ennemies[0].pre(sw.getElapsedTime());
  vessel.pre(sw.getElapsedTime());
  for (int i = 0; i < NBR_BULLET; ++i)
  {
     if (bulletFiring == 0)
      bulletsW[i].draw();
     if (bulletFiring == 1)
      bulletsF[i].draw();
     if (bulletFiring == 2)
      bulletsT[i].draw();
  }
  vessel.draw();
  S4P.drawSprites();
}
