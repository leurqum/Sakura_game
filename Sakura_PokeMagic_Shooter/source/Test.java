import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import sprites.utils.*; 
import sprites.maths.*; 
import sprites.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Test extends PApplet {






StopWatch sw = new StopWatch();
int NBR_BULLET = 25;
int NBR_ENNEMIES = 100;
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
  Bullet_fire.setGain(-10.0f);
  Bullet_thunder = minim.loadSample("Sound\\Bullet_thunder.wav", 2048);
  Bullet_thunder.setGain(-10.0f);
  Bullet_water = minim.loadSample("Sound\\Bullet_water.wav", 2048);
  Bullet_water.setGain(-10.0f);

  BG_music = minim.loadFile("Sound\\Background_music.mp3");
  BG_music.loop();
  GO_music = minim.loadFile("Sound\\GameOver_music.mp3");

  spell = new Sprite(this, "Sprite\\CardCharging.png", 6, 1, 2);
  spell.setXY(135, (height / 2) - 4);
  spell.setScale(1.19f);

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
    else if ((i % 2) == 0) {
      ennemies[i] = new Ennemy(new Sprite(this, "Sprite\\EnnemyW.png", 3, 1, 53), 1);
    }
    else if ((i % 3) == 0) {
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
                    new Sprite(this, "Sprite\\Sakura_flying_damage.png", 7, 1, 52));

  gameOver = new Sprite(this, "Sprite\\GameOver.png", 1, 1, 100);
  gameOver.setXY(xpos - 50, ypos + 10);
  gameOver.setVisible(false);
  
  gui = new Sprite(this, "Sprite\\flower_gui_pink.png", 1, 1, 100);
  gui.setXY(150, (height / 2));
  gui.setScale(0.6f);
  fire_on = new Sprite(this, "Sprite\\Fire_activated.png", 1, 1, 111);
  fire_on.setXY(22, 270);
  fire_on.setScale(0.4f);
  fire_on.setVisible(false);
  fire_off = new Sprite(this, "Sprite\\Fire.png", 1, 1, 110);
  fire_off.setXY(22, 270);
  fire_off.setScale(0.4f);
  water_on = new Sprite(this, "Sprite\\Water_activated.png", 1, 1, 111);
  water_on.setXY(22, 230);
  water_on.setScale(0.4f);
  water_on.setVisible(false);
  water_off = new Sprite(this, "Sprite\\Water.png", 1, 1, 110);
  water_off.setXY(22, 230);
  water_off.setScale(0.4f);
  thunder_on = new Sprite(this, "Sprite\\Lightning_activated.png", 1, 1, 111);
  thunder_on.setXY(22, 310);
  thunder_on.setScale(0.4f);
  thunder_on.setVisible(false);
  thunder_off = new Sprite(this, "Sprite\\Lightning.png", 1, 1, 110);
  thunder_off.setXY(22, 310);
  thunder_off.setScale(0.4f);
  card_on = new Sprite(this, "Sprite\\Card_activated.png", 1, 1, 111);
  card_on.setXY(80, 270);
  card_on.setScale(0.4f);
  card_off = new Sprite(this, "Sprite\\Card.png", 1, 1, 110);
  card_off.setXY(80, 270);
  card_off.setScale(0.4f);
  
  
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
      spell.setFrame(0);
    }
    break;
  }
}

public void pre() {
  double elapsedTime = sw.getElapsedTime();
  S4P.updateSprites(elapsedTime);
  vessel.pre(elapsedTime);
  
  for (int i = 0; i < NBR_BULLET; ++i)
  {
    for (int u = 0; u < NBR_ENNEMIES; ++u) {
      int score_tmp = vessel.score;
      vessel.score += bulletsW[i].touchEnnemy(ennemies[u]);
      vessel.score += bulletsF[i].touchEnnemy(ennemies[u]);
      vessel.score += bulletsT[i].touchEnnemy(ennemies[u]);
      vessel.score += bulletsB[i].touchEnnemy(ennemies[u]);
      if (score_tmp != vessel.score && spell.getFrame() != 5 && random(0,5) < 1.0f)
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
    ennemies[lastEnnemy].setVelX(-1 * random(50, 100));
    ++lastEnnemy;
  }
}

public void draw()
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
        card_on.setVisible(false);
        Bullet_water.trigger();
        bulletsW[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 2 && !bulletsF[i].isOnScreem())
      {
        water_on.setVisible(false);
        fire_on.setVisible(true);
        thunder_on.setVisible(false);
        card_on.setVisible(false);
        Bullet_fire.trigger();
        bulletsF[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 3 && !bulletsT[i].isOnScreem())
      {
        water_on.setVisible(false);
        fire_on.setVisible(false);
        thunder_on.setVisible(true);
        card_on.setVisible(false);
        Bullet_thunder.trigger();
        bulletsT[i].fire(vessel.getX(), vessel.getY());
        break;
      }
      else if (bulletFiring == 0 && !bulletsB[i].isOnScreem())
      {
        water_on.setVisible(false);
        fire_on.setVisible(false);
        thunder_on.setVisible(false);
        card_on.setVisible(true);
        Bullet_card.trigger();
        bulletsB[i].fire(vessel.getX(), vessel.getY());
        break;
      }
    }
  }
  vessel.draw();
  S4P.drawSprites();
}

public void stop()
{
  Bullet_card.close();
  Bullet_fire.close();
  Bullet_thunder.close();
  Bullet_water.close();
  minim.stop();
}
class Bullet {
 
  Sprite me;
  int type;
 
  Bullet(Sprite _s, int _t)
  {
    me = _s;
    me.setFrameSequence(0, 3, 0.2f);
    if (_t != 0 && _t != 1)
    {
      me.setRot(-67.5f);
    }
    else if (_t != 1)
    {
      me.setScale(0.2f);
    }
    else
    {
      me.setScale(0.7f);
    }
    me.setVelX(300.0f);
    me.setDead(false);
    type = _t;
  }

  public void draw()
  {
    me.draw();
  }
  
  public Sprite getSprite()
  {
    return me; 
  }
  
  public boolean isOnScreem()
  {
    return me.isOnScreem();  
  }

  public void fire(double _x, double _y)
  {
    me.setXY(_x + 60, _y + 15); 
  }
  
  public void setScale(double s)
  {
    me.setScale(s); 
  }
  
  public int touchEnnemy(Ennemy e)
  {
    int score = 0;
    
    if (me.cc_collision(e.getSprite()))
     {
       if (type == 0)
       {
         score = e.kill(1);
       }
       else if (e.getType() == type)
       {
         score = e.kill(10);
       }
       me.setXY(-100, -100);
     }
     return score;
  }
}

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
    time = 0.0f;
    health = 5.0f;
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
   me.setY(me.getY() - 5.0f);
  } 

  public void moveDown()
  {
   me.setY(me.getY() + 5.0f);
  } 

  public void moveLeft()
  {
   me.setX(me.getX() - 5.0f);
  } 

  public void moveRight()
  {
   me.setX(me.getX() + 5.0f );
  }
  
  public void setVelX(float vel)
  {
    me.setVelX(vel);
  }
  
  public Sprite getSprite()
  {
    return me; 
  }
  
  public int kill(int damage)
  {
    health -= damage;
    if (health <= 0)
    {
      me.setXY(width + 50, (random(10, height - 10)));
      me.setVelX(me.getVelX() * 1.05f);
      health = 5;
      return damage;
    }
    return 0;
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

class Ship {

  Sprite me;
  Sprite damaged;
  boolean shoot;
  double time;
  int bonus;
  int init;
  int life;
  int score;
  float invincible;

  Ship(Sprite _s, Sprite _d)
  {
    me = _s;
    damaged = _d;
    me.setFrameSequence(0, 7, 0.2f);
    me.setDead(false);
    damaged.setFrameSequence(0, 7, 0.2f);
    damaged.setDead(false);
    shoot = false;
    me.setXY(150, 250);
    damaged.setVisible(false);
    init = 0;
    time = 0.0f;
    bonus = 0;
    life = 3;
    invincible = 4.0f;
    me.setCollisionRadius(0.9f);
    score = 0;
  }

  public void pre(double elapsedTime)
  {
    time += elapsedTime;
    if (time - bonus > 0.2f)
    {
     shoot = true;
     time = 0.0f; 
    }
    
    if (damaged.isVisible())
    {
      invincible -= elapsedTime;
      if (invincible < 0)
      {
        invincible = 4.0f;
        damaged.setVisible(false); 
      }
    }
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
   me.setY(me.getY() - 5.0f);
  } 

  public void moveDown()
  {
   me.setY(me.getY() + 5.0f);
  } 

  public void moveLeft()
  {
   me.setX(me.getX() - 5.0f);
  } 

  public void moveRight()
  {
   me.setX(me.getX() + 5.0f );
  }
 
  public boolean damaged()
  {
    damaged.setVisible(true);
    if (invincible != 4.0f)
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

class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Starting the timer
  public void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  public boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Test" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
