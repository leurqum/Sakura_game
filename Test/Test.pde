
import ddf.minim.*;
import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

StopWatch sw = new StopWatch();
int NBR_BULLET = 25;

PImage bimg;
PImage bimg2;
float xpos;
float xpos2;
float ypos;
float xvel = 2;
float yvel = 1;
int imwidth;
int imheight;


Minim minim;

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

AudioSample Bullet_card;
AudioSample Bullet_fire;
AudioSample Bullet_thunder;
AudioSample Bullet_water;
AudioPlayer BG_music;

Sprite gui;
Sprite fire_off;
Sprite fire_on;
Sprite water_off;
Sprite water_on;
Sprite thunder_off;
Sprite thunder_on;
Sprite card_off;
Sprite card_on;

public void setup() 
{
  imageMode(CENTER);
  size (1280,550);
  bimg=loadImage("./Sprite\\Background.jpg");
  bimg2=loadImage("./Sprite\\Background.jpg");
  xpos2=width/2 + width;
  xpos=width/2;
  ypos=height/2;
  imwidth=bimg.width;
  imheight=bimg.height;
  image(bimg,xpos, ypos);
  image(bimg2,xpos2, ypos);

  size(1280, 550);
  minim = new Minim(this);
  Bullet_card = minim.loadSample("Sound\\Bullet_card.wav");
  Bullet_fire = minim.loadSample("Sound\\Bullet_fire.wav", 2048);
  Bullet_fire.setGain(-10.0);
  Bullet_thunder = minim.loadSample("Sound\\Bullet_thunder.wav", 2048);
  Bullet_thunder.setGain(-10.0);
  Bullet_water = minim.loadSample("Sound\\Bullet_water.wav", 2048);
  Bullet_water.setGain(-10.0);
  BG_music = minim.loadFile("Sound\\Background_music.mp3");
  BG_music.loop();
  lastEnnemy = 0;
  typeTime = 2.5;
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    bulletsB[i] = new Bullet(new Sprite(this, "Sprite\\Bullet_Base.png", 1, 1, 49), 0);
    bulletsB[i].fire(-100, -100);
    bulletsW[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestW.png", 4, 1, 49), 1);
    bulletsW[i].fire(-100, -100);
    bulletsF[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestF.png", 4, 1, 49), 2);
    bulletsF[i].fire(-100, -100);
    bulletsT[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestT.png", 4, 1, 49), 3);
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
    ennemies[i].setXY(-40, random(-300, 300));
    ennemies[i].getSprite().setSpeed(random(-100, 100), random(-300, 300));
  }
  vessel = new Ship(new Sprite(this, "Sprite\\Sakura_flying.png", 7, 1, 50));

  gui = new Sprite(this, "Sprite\\flower_gui_pink.png", 1, 1, 100);
  gui.setXY(160, (height / 2));
  gui.setScale(0.6);
  fire_on = new Sprite(this, "Sprite\\Fire_activated.png", 1, 1, 111);
  fire_on.setXY(22, 230);
  fire_on.setScale(0.4);
  fire_on.setVisible(false);
  fire_off = new Sprite(this, "Sprite\\Fire.png", 1, 1, 110);
  fire_off.setXY(22, 230);
  fire_off.setScale(0.4);
  water_on = new Sprite(this, "Sprite\\Water_activated.png", 1, 1, 111);
  water_on.setXY(22, 270);
  water_on.setScale(0.4);
  water_on.setVisible(false);
  water_off = new Sprite(this, "Sprite\\Water.png", 1, 1, 110);
  water_off.setXY(22, 270);
  water_off.setScale(0.4);
  thunder_on = new Sprite(this, "Sprite\\Lightning_activated.png", 1, 1, 111);
  thunder_on.setXY(22, 310);
  thunder_on.setScale(0.4);
  thunder_on.setVisible(false);
  thunder_off = new Sprite(this, "Sprite\\Lightning.png", 1, 1, 110);
  thunder_off.setXY(22, 310);
  thunder_off.setScale(0.4);
  
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
    case 'D':
      bulletFiring = 4;
      typeActive = false;
      typeTime = 5;
      break;
    }
  }
}

public void pre() {
  double elapsedTime = sw.getElapsedTime();
  if (bulletFiring != 4) {
    S4P.updateSprites(elapsedTime);
    vessel.pre(elapsedTime);
  }
  if (typeTime <= 0)
  {
    bulletFiring = 0; 
    if (typeTime <= -1)
    {
      typeActive = false;
      typeTime = 1.5;
    }
  }
  
  if (typeActive) {
    typeTime -= elapsedTime;
  }
  
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    for (int u = 0; u < NBR_BULLET; ++u) {
      bulletsW[i].touchEnnemy(ennemies[u]);
      bulletsF[i].touchEnnemy(ennemies[u]);
      bulletsT[i].touchEnnemy(ennemies[u]);
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
  if (xpos <= -width/2)
    xpos = width/2 + width;
  if (xpos2 <= -width/2)
    xpos2 = width/2 + width;
  xpos -= xvel;
  xpos2 -= xvel;
  image(bimg,xpos, ypos);
  image(bimg2,xpos2, ypos);
  
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    ennemies[i].update(width);
  }
  if (vessel.allowedShoot()) {
    for (int i = 0; i < NBR_BULLET; ++i)
    {
      if (bulletFiring == 1 && !bulletsW[i].isOnScreem())
      {
        water_on.setVisible(true);
        fire_on.setVisible(false);
        thunder_on.setVisible(false);
        Bullet_water.trigger();
        bulletsW[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 2 && !bulletsF[i].isOnScreem())
      {
        water_on.setVisible(false);
        fire_on.setVisible(true);
        thunder_on.setVisible(false);
        Bullet_fire.trigger();
        bulletsF[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 3 && !bulletsT[i].isOnScreem())
      {
        water_on.setVisible(false);
        fire_on.setVisible(false);
        thunder_on.setVisible(true);
        Bullet_thunder.trigger();
        bulletsT[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 0 && !bulletsB[i].isOnScreem())
      {
        Bullet_card.trigger();
        bulletsB[i].fire(vessel.getX(), vessel.getY());
        break;
      }
    }
  }
  if (bulletFiring != 4) {
      vessel.draw();
  }
  S4P.drawSprites();
}

void stop()
{
  Bullet_card.close();
  Bullet_fire.close();
  Bullet_thunder.close();
  Bullet_water.close();
  minim.stop();
}
