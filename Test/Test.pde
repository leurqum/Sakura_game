import ddf.minim.*;
import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

StopWatch sw = new StopWatch();
int NBR_BULLET = 25;
int NBR_ENNEMIES = 30;
Timer t = new Timer(2000);

PImage bimg;
PImage bimg2;
float xpos;
float xpos2;
float ypos;
float xvel = 2;
float yvel = 1;
int imwidth;
int imheight;
int fin = 0;

Minim minim;

Ship vessel;
Bullet[] bulletsW = new Bullet[NBR_BULLET];
Bullet[] bulletsF = new Bullet[NBR_BULLET];
Bullet[] bulletsT = new Bullet[NBR_BULLET];
Bullet[] bulletsB = new Bullet[NBR_BULLET];
Ennemy[] ennemies = new Ennemy[NBR_ENNEMIES];
int bulletFiring = 0;
int lastEnnemy;

Bomb bomb;

boolean typeActive;

AudioSample Bullet_card;
AudioSample Bullet_fire;
AudioSample Bullet_thunder;
AudioSample Bullet_water;
AudioPlayer BG_music;
AudioPlayer GO_music;

Sprite gui;
Sprite gameOver;
Sprite fire_off;
Sprite fire_on;
Sprite water_off;
Sprite water_on;
Sprite thunder_off;
Sprite thunder_on;
Sprite card_off;
Sprite card_on;
Sprite spell;

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
  GO_music = minim.loadFile("Sound\\GameOver_music.mp3");

  spell = new Sprite(this, "Sprite\\CardCharging.png", 6, 1, 2);
  spell.setXY(135, (height / 2) - 4);
  spell.setScale(1.19);

  bomb = new Bomb(new Sprite(this, "Sprite\\BombFire.png", 6, 1, 200),
                  new Sprite(this, "Sprite\\BombIce.png", 6, 1, 200),
                  new Sprite(this, "Sprite\\BombThunder.png", 4, 1, 200));

  lastEnnemy = 0;

  for (int i = 0; i < NBR_BULLET; ++i)
  {
    bulletsB[i] = new Bullet(new Sprite(this, "Sprite\\Bullet_Base.png", 1, 1, 49), 0);
    bulletsB[i].fire(-1000, -1000);
    bulletsW[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestW.png", 3, 1, 49), 1);
    bulletsW[i].fire(-1000, -1000);
    bulletsF[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestF.png", 4, 1, 49), 2);
    bulletsF[i].fire(-1000, -1000);
    bulletsT[i] = new Bullet(new Sprite(this, "Sprite\\BulletTestT.png", 4, 1, 49), 3);
    bulletsT[i].setScale(0.4f);
    bulletsT[i].fire(-1000, -1000);
  }
  
  for (int i = 0; i < NBR_ENNEMIES; ++i)
  {
    if ((i % 5) == 0) {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyL.png", 3, 1, 53), 0);
    }
    else if ((i % 3) == 0) {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyW.png", 3, 1, 53), 1);
    }
    else if ((i % 3) == 1) {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyN.png", 3, 1, 53), 3);
    }
    else {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyF.png", 2, 1, 53), 2);
    }
    ennemies[i].getSprite().setDomain(-40, -40, width+ennemies[i].getSprite().getWidth()/2, height+ennemies[i].getSprite().getHeight()/2, Sprite.REBOUND);
    ennemies[i].setXY(-40, random(-300, 300));
    ennemies[i].getSprite().setSpeed(random(-100, 100), random(-300, 300));
  }
  vessel = new Ship(new Sprite(this, "Sprite\\Sakura_flying.png", 7, 1, 50),
                    new Sprite(this, "Sprite\\Sakura_flying_damage.png", 7, 1, 52),
                    new Sprite(this, "Sprite\\Shield.png", 4, 1, 53));

  gameOver = new Sprite(this, "Sprite\\GameOver.png", 1, 1, 100);
  gameOver.setXY(xpos - 50, ypos + 10);
  gameOver.setVisible(false);
  
  gui = new Sprite(this, "Sprite\\flower_gui_pink.png", 1, 1, 100);
  gui.setXY(150, (height / 2));
  gui.setScale(0.6);
  fire_on = new Sprite(this, "Sprite\\Fire_activated.png", 1, 1, 111);
  fire_on.setXY(22, 270);
  fire_on.setScale(0.4);
  fire_on.setVisible(false);
  fire_off = new Sprite(this, "Sprite\\Fire.png", 1, 1, 110);
  fire_off.setXY(22, 270);
  fire_off.setScale(0.4);
  water_on = new Sprite(this, "Sprite\\Water_activated.png", 1, 1, 111);
  water_on.setXY(22, 230);
  water_on.setScale(0.4);
  water_on.setVisible(false);
  water_off = new Sprite(this, "Sprite\\Water.png", 1, 1, 110);
  water_off.setXY(22, 230);
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
  switch(e.getKeyCode()) {
  case 'Q':
    bulletFiring = 1;
    break;
  case 'W':
    bulletFiring = 2;
    break;
  case 'E':
    bulletFiring = 3;
    break;
  case 'R':
    bulletFiring = 0;
    break;
  case ' ':
    if (spell.getFrame() == 5) {
      bomb.fire(bulletFiring);
      if (bulletFiring == 0)
      {
        vessel.activeShield(); 
      }
      spell.setFrame(0);
    }
    break;
  }
}

public void pre() {
  double elapsedTime = sw.getElapsedTime();
  S4P.updateSprites(elapsedTime);
  vessel.pre(elapsedTime);
  bomb.pre(elapsedTime);
  
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    for (int u = 0; u < NBR_ENNEMIES; ++u) {
      int score_tmp = vessel.score;
      vessel.score += bulletsW[i].touchEnnemy(ennemies[u]);
      vessel.score += bulletsF[i].touchEnnemy(ennemies[u]);
      vessel.score += bulletsT[i].touchEnnemy(ennemies[u]);
      vessel.score += bulletsB[i].touchEnnemy(ennemies[u]);
      vessel.score += bomb.touchEnnemy(ennemies[u]);

      if (score_tmp != vessel.score && !bomb.isActive() && spell.getFrame() != 5 && random(0,5) < 1)
      {
        spell.setFrame(spell.getFrame() + 1);
      }
      ennemies[u].touchShip(vessel);
    }
  }

  if (lastEnnemy == NBR_BULLET)
  {
    return;
  }
  if ((random(0, 240)) < 10)
  {
    ennemies[lastEnnemy].setXY(width + 50, (random(10, height - 10)));
    ennemies[lastEnnemy].setVelX(-1 * random(150, 400));
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
  if(t.isFinished() == true && fin == 0)
  {
   vessel.score +=1;
   t.start(); 
  }
  
  if (vessel.init == -1 && fin == 0)
  {
    fin = 1;
    for (int i = 0; i < NBR_BULLET; ++i)
    {
      bulletsW[i].getSprite().setDead(true);
      bulletsF[i].getSprite().setDead(true);
      bulletsT[i].getSprite().setDead(true);
      bulletsB[i].getSprite().setDead(true);
    }
    for (int i = 0; i < NBR_ENNEMIES; ++i)
    {
       ennemies[i].getSprite().setDead(true);
    }
    return;
  }
  else if (vessel.init == -1)
  {
    gameOver.setVisible(true);
    gameOver.draw();
    text("SCORE :"+vessel.score, width / 2 - 50, height - 200);
    if (!GO_music.isPlaying())
    {
     BG_music.pause();
     GO_music.play(); 
    }
    return;
  }
  textSize(24);
  text("SCORE :"+vessel.score, 20, 35);
  for (int i = 0; i < NBR_ENNEMIES; ++i)
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
        water_on.setVisible(false);
        fire_on.setVisible(false);
        thunder_on.setVisible(false);
        Bullet_card.trigger();
        bulletsB[i].fire(vessel.getX(), vessel.getY());
        break;
      }
    }
  }
  vessel.draw();
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
