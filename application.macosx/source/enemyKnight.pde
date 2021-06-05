// Enemy Knight Class


// Enemy Knight Assets
PImage[] enemyLeft = new PImage[4];
PImage[] enemyDie = new PImage[5];
PImage[] enemyAttack = new PImage[2];

PImage enemySlashLeft;

class enemyKnight
{
  boolean isCreated = false;
  boolean isAlive = true;
  boolean isDying = false;
  boolean inAnimation = false;
  PVector enemyPos = new PVector(0, height/2);

  int enemyFrameRate = int(random(6, 10));
  int enemyAttackFrameRate = int(random(10, 14));
  int enemyOrigPosX;
  int currFrame = 0;
  int drawsTillNextFrame = enemyFrameRate;
  int drawsTillAttackFrame = enemyFrameRate;
  
  float smallEnemyDifficulty = random(0.2, 0.5);
  
  String action = "";

  void setup(int xPos)
  { 
    String loadAssetName;
    
    enemyOrigPosX = xPos;
    enemyPos.x = xPos;
    drawsTillNextFrame = enemyFrameRate;
    drawsTillAttackFrame = enemyAttackFrameRate;
    
    if (gameDifficulty == "hard")
    {
      enemyFrameRate = int(random(4, 8));
      enemyAttackFrameRate = int(random(6, 10));
      smallEnemyDifficulty = random(0.4, 0.8);
    }
    else if (gameDifficulty == "normal")
    {
      enemyFrameRate = int(random(6, 10));
      enemyAttackFrameRate = int(random(8, 12));
      smallEnemyDifficulty = random(0.4, 0.65);
    }
    else if (gameDifficulty == "easy")
    {
      enemyFrameRate = int(random(8, 12));
      enemyAttackFrameRate = int(random(10, 14));
      smallEnemyDifficulty = random(0.4, 0.5);
    }
    
    println(enemyFrameRate, enemyAttackFrameRate, smallEnemyDifficulty);
    
    enemyPos.y = (height/2) - offsetPosY;
    
    for (int i = 0; i < 5; i++)
    {
      int imageNum = i+1;
      
      loadAssetName = "assets/knightAnim/enemyKnight/enemyDieLeft" + imageNum + ".png";
      enemyDie[i] = loadImage(loadAssetName);

      if (i < 4)
      {
        loadAssetName = "assets/knightAnim/enemyKnight/enemyMoveLeft" + imageNum + ".png";
        enemyLeft[i] = loadImage(loadAssetName);
      }

      if (i < 2)
      {
        loadAssetName = "assets/knightAnim/enemyKnight/enemyAttackLeft" + imageNum + ".png";
        enemyAttack[i] = loadImage(loadAssetName);
      }
      
    }
    
    loadAssetName = "assets/knightAnim/playerKnight/playerKnightSlashLeft1.png";
    enemySlashLeft = loadImage(loadAssetName);

  }

  enemyKnight()
  {
  }
  
  void reset() // Resets Enemy To Original
  {
    isCreated = false;
    isAlive = true;
    isDying = false;
    inAnimation = false;
    
    enemyPos.x = enemyOrigPosX;
    currFrame = 0;
    
    action = "moveLeft";
  }
  
  void die() // Die Function
  {
    currFrame = 0;
    isAlive = false;
    isDying = true;
    drawsTillNextFrame = enemyFrameRate;
  }

  void move()
  {
    currFrame = 0;
  }
}
