// Knight Class

class Knight
{
  // Checks for Certain Events
  boolean alive = true;
  
  boolean isCreated = false;
  boolean isDying = false;
  
  // Moving Checks For Actions
  boolean movingLeft = false;
  boolean movingRight = false;
  boolean attackLeft = false;
  boolean attackRight = false;
  
  // Differentiates Different Knights
  String knightClass;
  
  String action = "moveRight";
  String prevAction = "moveRight";

  int knightOrigPosX;
  int lifeFrame = 3;
  int currFrame;
  int drawsTillNextFrame = knightFrameRate;
  int drawsTillAttackFrame = knightAttackFrameRate;
  
  // Default Knight Position
  PVector knightPos = new PVector(width/2, height/2 - offsetPosY);
  
  // Load Knight Assets
  PImage[] knightLeft = new PImage[4];
  PImage[] knightRight = new PImage[4];
  PImage[] knightAttackLeft = new PImage[2];
  PImage[] knightAttackRight = new PImage[2];
  PImage[] knightDieLeft = new PImage[5];
  PImage[] knightDieRight = new PImage[5];
  PImage[] knightDamage = new PImage[2];
  PImage knightBlockLeft;
  PImage knightBlockRight;
  PImage knightSlashLeft;
  PImage knightSlashRight;
  
  PImage[] life = new PImage[4];

  void setup(int posX)
  {
    String loadAssetName;
    
    knightOrigPosX = posX;
    knightPos.x = posX;
    knightPos.y = height/2 - offsetPosY;
    
    for (int i = 0; i < 5; i++)
    {
      int imageNum = i+1;
      
      if (knightClass == "bossKnight" || knightClass == "playerKnight")
      {
        loadAssetName =  "assets/knightAnim/" + knightClass + "/" + knightClass + "DieLeft" + imageNum + ".png";
        knightDieLeft[i] = loadImage(loadAssetName);
        
        loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "DieRight" + imageNum + ".png";
        knightDieRight[i] = loadImage(loadAssetName);
      }
      
      if (i < 4)
      {
        if (knightClass == "bossKnight" || knightClass == "playerKnight")
        {
          loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "MoveLeft" + imageNum + ".png";
          knightLeft[i] = loadImage(loadAssetName);
        }
        
        if (knightClass == "creditKnight" || knightClass == "playerKnight")
        {
          loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "MoveRight" + imageNum + ".png";
          knightRight[i] = loadImage(loadAssetName);
        }
        
        if (knightClass == "bossKnight" || knightClass == "playerKnight") 
        {
          loadAssetName = "assets/knightAnim/lifeBar/life" + imageNum + ".png";
          life[i] = loadImage(loadAssetName);
        }
      }

      if (i < 2)
      {
        if (knightClass == "bossKnight" || knightClass == "playerKnight")
        {
          loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "AttackLeft" + imageNum + ".png";
          knightAttackLeft[i] = loadImage(loadAssetName);
          
          loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "Damage" + imageNum + ".png";
          knightDamage[i] = loadImage(loadAssetName);
        }
        
        if (knightClass == "creditKnight" || knightClass == "playerKnight")
        {
          loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "AttackRight" + imageNum + ".png";
          knightAttackRight[i] = loadImage(loadAssetName);
        }        
      }
      
      movingRight = true;
    }
    
    if (knightClass == "playerKnight")
    {
      loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "BlockLeft1.png";
      knightBlockLeft = loadImage(loadAssetName);
      
      loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "BlockRight1.png";
      knightBlockRight = loadImage(loadAssetName);
     
      loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "SlashRight1.png";
      knightSlashRight = loadImage(loadAssetName);
      
      loadAssetName = "assets/knightAnim/" + knightClass + "/" + knightClass + "SlashLeft1.png";
      knightSlashLeft = loadImage(loadAssetName);
    }
    else if (knightClass == "bossKnight")
    {
      action = "moveLeft";
      prevAction = "moveLeft";
      
      drawsTillNextFrame = knightFrameRate;
      drawsTillAttackFrame = 2 * knightFrameRate;
    }
  }


  Knight()
  {
  }


  Knight(String type)
  {
    knightClass = type;
  }
  
  
  void reset(boolean trueRestart) // Reset Function
  {
    if (trueRestart)
    {
      lifeFrame = 3;
    }
    
    alive = true;
  
    isCreated = false;
    isDying = false;
  
    movingLeft = false;
    movingRight = false;
    attackLeft = false;
    attackRight = false;
    
    if (knightClass == "bossKnight") 
    {
      action = "moveLeft";
      prevAction = "moveLeft";
      lifeFrame = 3;
    }
    else
    {
      action = "moveRight";
      prevAction = "moveRight";
    }

    knightPos.x = knightOrigPosX;
    currFrame = 0;
    drawsTillNextFrame = knightFrameRate;
    drawsTillAttackFrame = 2 * knightFrameRate;
  }
  
  
  void setPos(int xPos)
  {
    knightPos.x = xPos;
  }
  
  
  void die() // Knight Die Function (Mainly Used By playerKnight)
  {
    currFrame = 0;
    
    knightDeathSound.play();
    
    if (action == "moveLeft" || action == "attackLeft") action = "dieLeft";
    else action = "dieRight";
    
    if (isDying)
    {
      isDying = false;
    }
  }
  
  
  void takeDamage() // Damage Function (Only Used By bossKnight)
  {
    lifeFrame--;
    knightPos.x += 4;
    
    knightDamageSound.play();
    
    if (lifeFrame == 0)
    {
      action = "dieRight";
      alive = false;
      isDying = true;
      drawsTillNextFrame = knightDeathRate;
      currFrame = 0;
    }
    else
    {  
      currFrame = 0;
      action = "takeDamage";
    }
  }
  
  
  void defend() // Defend Function (Only Used By playerKnight)
  {
    knightDefendSound.play(1, 0, 0.4);
    
    if (action == "moveLeft")
    {
      currFrame = 0;
      prevAction = action;
      action = "defendLeft";
    }
    else if (action == "moveRight")
    {
      currFrame = 0;
      prevAction = action;
      action = "defendRight";
    }
  }


  void attack()
  {
    knightSlashSound.play();
    
    if (action == "moveLeft")
    {
      currFrame = 0;
      prevAction = action;
      action = "attackLeft";
    }
    else if (action == "moveRight")
    {
      currFrame = 0;
      prevAction = action;
      action = "attackRight";
    }
  }


  void move(boolean left)
  {
    if (playerMoveOffset - width/2 < 2086)
    {
      if (left)
      {
        if (action == "moveRight") 
        {
          currFrame = 0;
          movingLeft = true;
          movingRight = true;
          prevAction = action;
          action = "moveLeft";
        }
      }
      else
      {
        if (action == "moveLeft")
        {
          currFrame = 0;
          movingLeft = false;
          movingRight = true;
          prevAction = action;
          action = "moveRight";
        }
      }
    }
  }
}
