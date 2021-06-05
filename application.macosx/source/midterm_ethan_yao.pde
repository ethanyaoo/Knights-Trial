// Midterm Project by Ethan Yao


// Create Knights
Knight playerKnight = new Knight("playerKnight");
Knight bossKnight = new Knight("bossKnight");
Knight creditKnight = new Knight("creditKnight");


// Small Enemy Knights (Hard Coded In So Game Gives Preset Positions)
enemyKnight[] enemyList = new enemyKnight[8];

enemyKnight enemyKnightOne = new enemyKnight();
enemyKnight enemyKnightTwo = new enemyKnight();
enemyKnight enemyKnightThree = new enemyKnight();
enemyKnight enemyKnightFour = new enemyKnight();
enemyKnight enemyKnightFive = new enemyKnight();
enemyKnight enemyKnightSix = new enemyKnight();
enemyKnight enemyKnightSeven = new enemyKnight();
enemyKnight enemyKnightEight = new enemyKnight();


//  Frame Controllers
int utilFrame = 0;
int knightFrameRate = 6;
int knightAttackFrameRate = 12;
int knightDeathRate = 30;

int knightBossFrameRate;
int knightBossAttackFrameRate;

int endSceneFrameRate = 8;
int drawsTillDropLifeHeart = 75;
int drawsTillRestart = 50;
int drawsTillArrowFrame = 5;


// Game Controller Variables
int textState = 1;

float soundController = 1;
float bossKnightDifficulty = 0.0;

String gameState = "menu";
String gameDifficulty = "normal"; // Default Difficulty Setting

boolean startGame = true;
boolean inAnimation = false;
boolean inDefend = false;
boolean gamePause = false;
boolean endGame = false;
boolean lastScene = false;


// Text Controller
int textHeight;
int textWidth;

int textHeightDiff;

PFont gameFont;
PFont helpFont;
PFont endFont;


// Player offset to create moving screen effect
int playerMoveOffset = 0;
int playerMoveSpeed = 8;

int offsetPosY = 2; // Offset Y by 2 because of overlap from map and is easier to add offset than re-edit and shift each pixel down

int bossMovementSpeed = 6;


// Import sound files
import processing.sound.*;

SoundFile gameBackgroundSound;
SoundFile titleBackgroundSound;

SoundFile knightSlashSound;
SoundFile knightDeathSound;
SoundFile knightDamageSound;
SoundFile knightDefendSound;
SoundFile knightYellSound;
SoundFile smallEnemySlashSound;
SoundFile smallEnemyDeathSound;


// Dungeon Objects
PImage dungeonBackground;
PImage[] dungeonGate = new PImage[2];

boolean closeGate = false;


// Misc. Objects
PImage[] downArrowContinue = new PImage[5];
PImage[] rightArrowContinue = new PImage[5];


void setup()
{
  size(512, 512);
  
  // Player Setup
  playerKnight.setup(width/2);  
  
  // Font Vars
  textHeight = height/6;
  textWidth = width/8;
  textHeightDiff = height/4;
  
  // Asset Load
  loadAssets();
  
  // Background Music
  titleBackgroundSound.loop();
  
  // Application Edit
  surface.setTitle("A Simple Dungeon Runner");
}

void loadAssets() // Loads Game Assets 
{
  // Font Assets
  gameFont = loadFont("Trattatello-48.vlw");
  helpFont = loadFont("AppleBraille-16.vlw");
  endFont = loadFont("ArialNarrow-Bold-16.vlw");
  
  
  // Dungeon Map Vars
  dungeonBackground = loadImage("assets/dungeonMap/dungeonMap.png");
  
  dungeonGate[0] = loadImage("assets/dungeonMap/gateOpen.png");
  dungeonGate[1] = loadImage("assets/dungeonMap/gateClosed.png");
  
  surface.setIcon(dungeonGate[0]);
  
  
  // Misc. Vars
  String loadAssetName;
  
  for (int i = 0; i < 5; i++)
  {
    int imageNum = i+1;
    loadAssetName = "assets/misc/downArrow" + imageNum + ".png";
    downArrowContinue[i] = loadImage(loadAssetName);
    
    loadAssetName = "assets/misc/rightArrow" + imageNum + ".png";
    rightArrowContinue[i] = loadImage(loadAssetName);
  }
  
  
  // Sound Setup
  gameBackgroundSound = new SoundFile(this, "assets/sounds/dungeon8Bit.wav");
  titleBackgroundSound = new SoundFile(this, "assets/sounds/title16Bit.wav");
  
  knightSlashSound = new SoundFile(this, "assets/sounds/knightSlash.wav");
  knightDeathSound = new SoundFile(this, "assets/sounds/knightDeath.wav");
  knightDamageSound = new SoundFile(this, "assets/sounds/knightDamage.wav");
  knightDefendSound = new SoundFile(this, "assets/sounds/knightDefend.wav");
  knightYellSound = new SoundFile(this, "assets/sounds/knightYell.wav");
  
  smallEnemySlashSound = new SoundFile(this, "assets/sounds/smallEnemySlash.wav");
  smallEnemyDeathSound = new SoundFile(this, "assets/sounds/smallEnemyDeath.wav");
    
  knightSlashSound.amp(0.5);
  knightDeathSound.amp(0.5);
  knightDamageSound.amp(0.4);
  knightDefendSound.amp(0.25);
  knightYellSound.amp(0.8);
  
  smallEnemyDeathSound.amp(0.3);
  smallEnemySlashSound.amp(0.1);
}

void createEnemyKnights() // Function To Create Small Enemy Knights (Reduce Code In Setup And To Easily Reset Enemies)
{
  // Array To Hold Small Enemy Knights
  enemyList = new enemyKnight[8];
  
  // Call Setup for Enemy Knights
  enemyKnightOne.setup(480); // Force enemyKnight positions by pixel count
  enemyKnightTwo.setup(690);
  enemyKnightThree.setup(770);
  enemyKnightFour.setup(980);
  enemyKnightFive.setup(1120);
  enemyKnightSix.setup(1290);
  enemyKnightSeven.setup(1460);
  enemyKnightEight.setup(1580);
  
  // Add Enemies to List
  enemyList[0] = enemyKnightOne;
  enemyList[1] = enemyKnightTwo;
  enemyList[2] = enemyKnightThree;
  enemyList[3] = enemyKnightFour;
  enemyList[4] = enemyKnightFive;
  enemyList[5] = enemyKnightSix;
  enemyList[6] = enemyKnightSeven;
  enemyList[7] = enemyKnightEight;
  
  // Create Final Scene Knight
  creditKnight.setup(0);
  
  // Setup Boss Knight
  if (gameDifficulty == "hard") // Values Are Used To Determine Enemy Attack Speed
  {                          // And The Range At Which Enemies Decide When To Attack
    knightBossFrameRate = int(random(8, 12));
    knightBossAttackFrameRate = int(random(12, 18));
    bossKnightDifficulty = int(random(0.4, 0.5));
  }
  else if (gameDifficulty == "normal")
  {
    knightBossFrameRate = int(random(10, 14));
    knightBossAttackFrameRate = int(random(16, 22));
    bossKnightDifficulty = int(random(0.3, 0.4));
  }
  else if (gameDifficulty == "easy")
  {
    knightBossFrameRate = int(random(12, 16));
    knightBossAttackFrameRate = int(random(20, 26));
    bossKnightDifficulty = int(random(0.2, 0.3));
  }
  
  
  bossKnight.setup(2084); // Force bossKnight position by pixel count
    
  bossKnight.prevAction = "moveLeft"; // Force Action To Move Left 
  bossKnight.action = "moveLeft";    // Because Boss Knight Does Not Have moveRight
}

void reset(boolean trueRestart) // Resets All Vars
{
  if (trueRestart) // Fully Restarts Game From Title
  {
    textState = 0;
    closeGate = false;
    startGame = true;
    
    gameBackgroundSound.stop();
    
    gameState = "title";
  }
  
  // Default Reset For Globals and Objects
  
  // Call Object's Class Reset()
  for (int i = 0; i < enemyList.length; i++)
  {
    enemyList[i].reset();
  }
  
  playerKnight.reset(trueRestart);
  bossKnight.reset(trueRestart);
  creditKnight.reset(trueRestart);  
  
  //  Frame Controllers
  utilFrame = 0;
  drawsTillArrowFrame = 10;
  drawsTillRestart = 50;
  drawsTillDropLifeHeart = 75;

  // Game Controller Variables
  playerMoveOffset = 0;

  inAnimation = false;
  inDefend = false;
  gamePause = false;
  endGame = false;
  lastScene = false;
 
  gamePause = false;
  inAnimation = false;
}

void draw()
{ 
  if (gameState == "menu")
  {
    background(0);
    fill(255);
    textFont(gameFont);
    
    drawsTillArrowFrame--;
    
    if (drawsTillArrowFrame <= 0)
    {
      utilFrame++;
      drawsTillArrowFrame = 10;
      
      if (utilFrame >= downArrowContinue.length)
      {
        utilFrame = 0;
      }
    }
    
    float tempVal = textState; // textState is kept as an int
    
    image(rightArrowContinue[utilFrame], 23 * width/64, height/2 + ((tempVal/2) * textHeightDiff) + 6);
       
    textSize(48);
    text("A Simple Dungeon Runner", width/16, 2 * height/16, 15 * width/16, 15 * height/16);
    
    textSize(24);
    text("Select The Difficulty Level", 2 * width/8, 6 * height/16, 15 * width/16, 7 * height/ 16);
    
    textSize(24);
    text("Hard", 13 * width/32, height/2 + (0 * textHeightDiff), 15 * width/16, height);
    
    textSize(24);
    text("Normal", 13 * width/32, height/2 + (0.5 * textHeightDiff), 15 * width/16, height);
    
    textSize(24);
    text("Easy", 13 * width/32, height/2 + (1 * textHeightDiff), 15 * width/16, height);
    
    textSize(24);
    text("Press Enter To Continue", 9 * width/32, 15 * height/16);
  }
  if (gameState == "title") // Title State With Triggers For Text
  {
    background(0);
    fill(255);
    textFont(gameFont);
    
    drawsTillArrowFrame--;
    
    if (drawsTillArrowFrame <= 0)
    {
      utilFrame++;
      drawsTillArrowFrame = 15;
      
      if (utilFrame >= downArrowContinue.length)
      {
        utilFrame = 0;
      }
    }
    
    if (textState >= 0 && textState < 2) 
    {
      textSize(48);
      
      text("Midterm Project", textWidth * 0.5, textHeight * 2.25);
      
      if (textState == 0) image(downArrowContinue[utilFrame], textWidth * 4.75, textHeight * 2.25);
    }
    if (textState == 1)
    {
      text("by Ethan Yao", textWidth * 3, (textHeight * 2.25) + textHeightDiff);
      
      image(downArrowContinue[utilFrame], textWidth * 6.5, (textHeight * 2.25) + textHeightDiff);
    }
    if (textState >= 2) 
    {
      String descrip = "A monster plagues the mountain caverns and has slaughtered all knights who have ventured inside";
      textSize(28);
      
      text(descrip, textWidth * 0.5, textHeight * 0.5, width - textWidth, textHeight + textHeightDiff);
      
      if (textState == 2) image(downArrowContinue[utilFrame], width - (textWidth * 0.4), textHeight * 1.35);
    }
    if (textState >= 3) 
    {
      String descrip = "No one has yet to come back after all this time. Be wary, monsters come in all shapes and sizes";
      textSize(28);
      
      text(descrip, textWidth * 0.5, textHeight * 1.75, width - textWidth, textHeight + (1.25 * textHeightDiff));
      
      if (textState == 3) image(downArrowContinue[utilFrame], width - (textWidth * 0.4), textHeight * 2.5);
    }
    if (textState >= 4)
    {
      text("Game Objective: ", textWidth * 0.5, textHeight + (1.5 *textHeightDiff));
      
      if (textState == 4) image(downArrowContinue[utilFrame], textWidth * 2.9, textHeight + (1.48 *textHeightDiff));
    }
    if (textState >= 5)
    {
      text("-Explore The Caverns", textWidth * 1.5, textHeight + (2 * textHeightDiff));
      
      if (textState == 5) image(downArrowContinue[utilFrame], textWidth * 4.8, textHeight + (1.975 *textHeightDiff));
    }
    if (textState >= 6)
    {
      text("-Kill The Monster Hidden Within", textWidth * 1.5, textHeight + (2.5 * textHeightDiff));
      
      if (textState == 6) image(downArrowContinue[utilFrame], textWidth * 6.85, textHeight + (2.47 *textHeightDiff));
    }
  }
  else if (gameState == "help") // Simple Help Screen (Can Be Used As Pause State)
  {
    background(0);
    fill(255);
    textFont(helpFont);
    text("Help", width/2 - 30, height/10);
    text("-Use the Left and Right arrow keys to move", textWidth * 0.25, textHeight);
    text("-Press A to attack", textWidth * 0.25, textHeight + (0.5 * textHeightDiff));
    text("-Press D to defend", textWidth * 0.25, textHeight + (1 * textHeightDiff));
    text("-Press H to open up the help menu", textWidth * 0.25, textHeight + (1.5 * textHeightDiff));
    text("-Press R to reset the game back to the title menu", textWidth * 0.25, textHeight + (2 * textHeightDiff));
    text("-Press Enter to close the help menu", textWidth * 0.25, textHeight + (2.5 * textHeightDiff));
    
    drawsTillArrowFrame--;
    
    if (drawsTillArrowFrame <= 0)
    {
      utilFrame++;
      drawsTillArrowFrame = 15;
      
      if (utilFrame >= downArrowContinue.length)
      {
        utilFrame = 0;
      }
    }
    
    image(downArrowContinue[utilFrame], width - (1.3 * textWidth), textHeight + (2.45 * textHeightDiff));
  }
  else if (gameState == "pause") // State Not Necessary Because Of Help Screen
  {
    gamePause = true;
  }
  else if (gameState == "fade") // Screen Fade Animation
  {
    fill(0, 10);
    rect(0, 0, width, height);
    
    if (bossKnight.alive) // Restarts Game If Boss Not Killed
    {
      drawsTillRestart--;
      
      if (playerKnight.lifeFrame >= 0 && drawsTillRestart <= 0)
      {
        gameState = "loseLife";
        playerKnight.lifeFrame--;
        drawsTillRestart = 200;
      }
    }
    else if (creditKnight.knightPos.x >= 200) // Triggers gameOver Scene
    {
      gameState = "gameOver";
    }
    else // Triggers Final End Game Scene
    {
      creditKnight.drawsTillNextFrame = endSceneFrameRate;
      gameState = "endGameScene";
      
      textState = 0;
      utilFrame = 0;
      drawsTillArrowFrame = 5;
      
      knightYellSound.play(1, 0, 1);
      
      gameBackgroundSound.stop();
    }
  }
  else if (gameState == "game")
  { 
    // Background Images
    image(dungeonBackground, -playerMoveOffset, 0);
    
    // Create Dungeon Gate Closing Animation
    if (closeGate) image(dungeonGate[1], width/2 - playerMoveOffset, height/2 - (3 * offsetPosY));
    else if (playerMoveOffset >= 25)
    {
      closeGate = true;
      image(dungeonGate[1], width/2 - playerMoveOffset, height/2 - (3 * offsetPosY));
    }
    else
    {
      image(dungeonGate[0], width/2 - playerMoveOffset, height/2 - (3 * offsetPosY));
    }
    
    
    // Player Knight Statements
    
    // Display Health Bar for Player
    fill(255);
    textFont(helpFont);
    text("Player Health", width/16, 1.5 * height/32);
    image(playerKnight.life[playerKnight.lifeFrame], 2.25 * width/16, height/16);
  
    // Player Movement Animations
    if (playerKnight.action == "moveLeft") image(playerKnight.knightLeft[playerKnight.currFrame], 
        playerKnight.knightPos.x, playerKnight.knightPos.y);
    else if (playerKnight.action == "moveRight") image(playerKnight.knightRight[playerKnight.currFrame], 
        playerKnight.knightPos.x, playerKnight.knightPos.y);
    else if (playerKnight.action == "attackRight") // Player Attack Animations
    {
      inAnimation = true;
      playerKnight.drawsTillAttackFrame--;
      
      image(playerKnight.knightAttackRight[playerKnight.currFrame], playerKnight.knightPos.x + 
          (0.5 * playerKnight.knightAttackRight[0].width), playerKnight.knightPos.y);
          
      image(playerKnight.knightSlashRight, playerKnight.knightPos.x + playerKnight.knightAttackRight[0].width, 
          playerKnight.knightPos.y);
          
      if (playerKnight.drawsTillAttackFrame <= 0)
      {
        playerKnight.currFrame++;
        
        if (playerKnight.currFrame == 1) // Check If Hit Boss Knight
        {          
          if (bossKnight.knightPos.x - playerMoveOffset - width/2 - (0.5 * playerKnight.knightAttackRight[0].width) -
              playerKnight.knightSlashRight.width <= 0 && bossKnight.alive && bossKnight.isCreated)
          {             
            bossKnight.takeDamage();
            bossKnight.knightPos.x += 12;
          }
        }
        
        if (playerKnight.currFrame >= playerKnight.knightAttackRight.length) 
        {
          playerKnight.currFrame = 0;
          playerKnight.action = "moveRight";
          inAnimation = false;
        }
        playerKnight.drawsTillAttackFrame = knightAttackFrameRate;
      }
      
      for (int i = 0; i < enemyList.length; i++) // Check If Hit Any Small Enemy Knights
      {
        if (enemyList[i].enemyPos.x - playerMoveOffset - width/2 - (0.5 * playerKnight.knightAttackRight[0].width) - 
            playerKnight.knightSlashRight.width <= 0 && enemyList[i].isAlive && playerKnight.drawsTillAttackFrame >= 10)
        {
          //added check for frames as enemies could just walk onto your sword attack
          
          enemyList[i].die();
        }
      }
    }
    else if (playerKnight.action == "attackLeft") 
    {
      inAnimation = true;
      playerKnight.drawsTillAttackFrame--;
      
      image(playerKnight.knightAttackLeft[playerKnight.currFrame], playerKnight.knightPos.x - 
          (0.5 * playerKnight.knightAttackLeft[0].width), playerKnight.knightPos.y);
          
      image(playerKnight.knightSlashLeft, playerKnight.knightPos.x - 
          (1 * playerKnight.knightAttackRight[0].width), playerKnight.knightPos.y);
          
      if (playerKnight.drawsTillAttackFrame <= 0)
      {
        playerKnight.currFrame++;
        
        if (playerKnight.currFrame >= playerKnight.knightAttackLeft.length)
        {
          playerKnight.currFrame = 0;
          playerKnight.action = "moveLeft";
          inAnimation = false;
        }
        playerKnight.drawsTillAttackFrame = knightAttackFrameRate;
      }
      
      for (int i = 0; i < enemyList.length; i++) // Check Through Enemies List If Player Hits
      {
        if (enemyList[i].enemyPos.x - playerMoveOffset - width/2 - (0.5 * playerKnight.knightAttackRight[0].width) + 
            playerKnight.knightSlashRight.width <= 0 && enemyList[i].isAlive && playerKnight.drawsTillAttackFrame >= 10)
        {
          enemyList[i].die();
        }
      }
      
      // Check If Hit Boss
      if (bossKnight.knightPos.x - playerMoveOffset - width/2 - (0.5 * playerKnight.knightAttackRight[0].width) + 
          playerKnight.knightSlashRight.width <= 0 && bossKnight.alive)
      {
        bossKnight.takeDamage();
      }
    } // Player Death Animations
    else if (playerKnight.action == "dieLeft")
    {
      inAnimation = true;
      playerKnight.drawsTillNextFrame--;
      
      image(playerKnight.knightDieLeft[playerKnight.currFrame], playerKnight.knightPos.x, playerKnight.knightPos.y);
      
      if (playerKnight.drawsTillNextFrame <= 0)
      {
        playerKnight.currFrame++;
        
        if (playerKnight.currFrame >= playerKnight.knightDieLeft.length)
        {
          playerKnight.currFrame = 0;
          gameState = "fade";
        }
        
        playerKnight.drawsTillNextFrame = knightFrameRate;
      }
    }
    else if (playerKnight.action == "dieRight")
    {
      inAnimation = true;
      playerKnight.drawsTillNextFrame--;
      
      image(playerKnight.knightDieRight[playerKnight.currFrame], playerKnight.knightPos.x, playerKnight.knightPos.y);
      
      if (playerKnight.drawsTillNextFrame <= 0)
      {
        playerKnight.currFrame++;
        
        if (playerKnight.currFrame >= playerKnight.knightDieRight.length)
        {
          playerKnight.currFrame = 0;
          gameState = "fade";
        }
        
        playerKnight.drawsTillNextFrame = knightFrameRate;
      }
    } // Player Defend Animations
    else if (playerKnight.action == "defendLeft")
    {
      if (inDefend) image(playerKnight.knightBlockLeft, playerKnight.knightPos.x, playerKnight.knightPos.y);
      else playerKnight.action = playerKnight.prevAction;
    }
    else if (playerKnight.action == "defendRight")
    {
      if (inDefend) image(playerKnight.knightBlockRight, playerKnight.knightPos.x, playerKnight.knightPos.y);
      else playerKnight.action = playerKnight.prevAction;
    }
    
    
    // Small Enemy Controller
    if (!gamePause)
    {
      for (int i = 0; i < enemyList.length; i++)
      {
        if (enemyList[i].isAlive) // Makes sure that the unit is still alive and be displayed
        {
          if ((playerMoveOffset + width >= enemyList[i].enemyPos.x || enemyList[i].isCreated) && !enemyList[i].isDying)
          {
            enemyList[i].isCreated = true;
            
            if (enemyList[i].enemyPos.x - playerMoveOffset - width/2 - (enemyList[i].smallEnemyDifficulty * enemyAttack[0].width) - enemySlashLeft.width <= 0)
            {
              if (enemyList[i].action != "attack") 
              {
                enemyList[i].action = "attack";
                enemyList[i].currFrame = 0;
                enemyList[i].drawsTillAttackFrame = enemyList[i].enemyAttackFrameRate;
              }
              
              enemyList[i].drawsTillAttackFrame--;
              
              if (enemyList[i].currFrame == 1) // Checks for slash timing
              {
                image(enemyAttack[enemyList[i].currFrame], enemyList[i].enemyPos.x - playerMoveOffset - 
                    (0.5 * enemyAttack[0].width), enemyList[i].enemyPos.y);
                image(playerKnight.knightSlashLeft, enemyList[i].enemyPos.x - playerMoveOffset - 
                    (0.5 * enemyAttack[0].width), playerKnight.knightPos.y);
                
                if (enemyList[i].enemyPos.x - playerMoveOffset - width/2 - (enemyList[i].smallEnemyDifficulty * enemyAttack[0].width) - 
                    enemySlashLeft.width <= 0 && enemyList[i].isAlive && !inDefend)
                {
                  playerKnight.currFrame = 0;
                  playerKnight.die();
                  gamePause = true;
                }
                else
                {
                  smallEnemySlashSound.play();
                }
                  
              }
              else
              {                
                image(enemyAttack[enemyList[i].currFrame], enemyList[i].enemyPos.x - 
                    playerMoveOffset, enemyList[i].enemyPos.y);
              }
              
              if (enemyList[i].drawsTillAttackFrame <= 0)
              {
                enemyList[i].currFrame++;
                enemyList[i].drawsTillAttackFrame = enemyList[i].enemyAttackFrameRate;
                
                if (enemyList[i].currFrame >= enemyAttack.length)
                {
                  enemyList[i].currFrame = 0;
                }
              }
            }
            else // Only other action besides attacking is left movement
            {
              if (enemyList[i].action != "move") 
              {
                enemyList[i].action = "move";
                enemyList[i].currFrame = 0;
                enemyList[i].drawsTillNextFrame = enemyList[i].enemyFrameRate;
              }
              
              enemyList[i].drawsTillNextFrame--;
              image(enemyLeft[enemyList[i].currFrame], enemyList[i].enemyPos.x - playerMoveOffset, enemyList[i].enemyPos.y);
              
              if (enemyList[i].drawsTillNextFrame <= 0)
              {
                enemyList[i].currFrame++;
                enemyList[i].drawsTillNextFrame = enemyList[i].enemyFrameRate;
                enemyList[i].enemyPos.x -= 4;
                
                if (enemyList[i].currFrame >= enemyLeft.length)
                {
                  enemyList[i].currFrame = 0;
                }
              }
            }
          }
        }
        else if (enemyList[i].isDying) // Create Dying Animation
        {
          if (enemyList[i].action != "die") 
          {
            enemyList[i].action = "die";
            enemyList[i].currFrame = 0;
            enemyList[i].drawsTillNextFrame = enemyList[i].enemyFrameRate;
          }
          
          enemyList[i].drawsTillNextFrame--;
          if (enemyList[i].currFrame == 0) smallEnemyDeathSound.play();
          
          image(enemyDie[enemyList[i].currFrame], enemyList[i].enemyPos.x - playerMoveOffset, enemyList[i].enemyPos.y);
          
          if (enemyList[i].drawsTillNextFrame <= 0)
          {
            enemyList[i].currFrame++;
            if (enemyList[i].currFrame >= enemyDie.length)
            {
              enemyList[i].currFrame = 0;
              enemyList[i].isDying = false;
            }
            enemyList[i].drawsTillNextFrame = enemyList[i].enemyFrameRate;
          }
        }
      }
    }
    else
    {
      for (int i = 0; i < enemyList.length; i++)
      {
        if (enemyList[i].isAlive)
        {
          image(enemyLeft[enemyList[i].currFrame], enemyList[i].enemyPos.x - playerMoveOffset, enemyList[i].enemyPos.y);
        }
      }
    }
   
        
    // Final Boss Controller
    if (bossKnight.alive && !gamePause)
    {
      if ((playerMoveOffset >= 1600 || bossKnight.isCreated) && !bossKnight.isDying)
      {
        bossKnight.isCreated = true; // Used To Make Sure He Is Created If Not Made Already And No Repeat Of Text
        
        fill(255);
        textFont(helpFont);
        text("Boss Health", 12 * width/16, 1.5 * height/32);
        image(bossKnight.life[bossKnight.lifeFrame], 13 * width/16, height/16);
        
        if (lastScene && textState <= 1) // Creates Text Dialog Box
        {
          drawsTillArrowFrame--;
    
          if (drawsTillArrowFrame <= 0)
          {
            utilFrame++;
            drawsTillArrowFrame = 15;
            
            if (utilFrame >= downArrowContinue.length)
            {
              utilFrame = 0;
            }
          }
                
          fill(0);
          rect(width/4, 8.5 * height/10, 2 * width/4, height/10);
          
          fill(255);
          textFont(endFont);
          
          if (textState == 0) 
          {
            text("YOU MONSTER ! ", 1.6 * width/4, 9.1 * height/10);
            image(downArrowContinue[utilFrame], 1.22 * width/2, 9.0 * height/10);
          }
          
          else if (textState == 1) 
          {
            text("HOW COULD YOU ! ", 1.6 * width/4, 9.1 * height/10);
            image(downArrowContinue[utilFrame], 1.3 * width/2, 9.0 * height/10);
          }
        }
        // Create Cutscene #1
        if (playerMoveOffset >= 1600 && bossKnight.knightPos.x - playerMoveOffset - 256 >= 75 && !lastScene)
        {
          lastScene = true;
        }
        else if (bossKnight.action == "takeDamage") // Damage Checker
        {
          bossKnight.drawsTillNextFrame--;
          
          image(bossKnight.knightDamage[bossKnight.currFrame], bossKnight.knightPos.x - playerMoveOffset, bossKnight.knightPos.y);
          
          if (bossKnight.drawsTillNextFrame <= 0)
          {
            bossKnight.currFrame++;
            bossKnight.drawsTillNextFrame = knightBossFrameRate;
            
            if (bossKnight.currFrame >= bossKnight.knightDamage.length)
            {
              bossKnight.currFrame = 0;
              bossKnight.action = "moveLeft";
            }
          }
        }
        // Checks For When To Attack
        else if (bossKnight.knightPos.x - width/2 - playerMoveOffset - 
            (bossKnightDifficulty * bossKnight.knightAttackLeft[0].width) - playerKnight.knightSlashLeft.width <= 0)
        {          
          if (bossKnight.action != "attackLeft") // Checks To Make Sure Frames Are Reset
          {
            bossKnight.action = "attackLeft";
            bossKnight.currFrame = 0;
            bossKnight.drawsTillAttackFrame = knightBossAttackFrameRate;
          }
          
          bossKnight.drawsTillAttackFrame--;
          
          if (bossKnight.currFrame == 1)  // Check to make sure slash art appears at right timing
          {
            image(bossKnight.knightAttackLeft[bossKnight.currFrame], bossKnight.knightPos.x - playerMoveOffset - 
                (0.5 * bossKnight.knightAttackLeft[0].width), bossKnight.knightPos.y);
            image(playerKnight.knightSlashLeft, bossKnight.knightPos.x - playerMoveOffset - 
                (0.5 * enemyAttack[0].width), playerKnight.knightPos.y);
                        
            if (bossKnight.knightPos.x - width/2 - playerMoveOffset - (bossKnightDifficulty * bossKnight.knightAttackLeft[0].width) - 
                playerKnight.knightSlashRight.width <= 0 && bossKnight.alive)
            {
              if (!inDefend)
              {
                playerKnight.currFrame = 0;
                playerKnight.die();
                lastScene = false;
                gamePause = true;
              }
              else
              {
                bossKnight.knightPos.x -= 24;
              }
            }
          }
          else
          {
            knightSlashSound.play();
            image(bossKnight.knightAttackLeft[bossKnight.currFrame], bossKnight.knightPos.x - playerMoveOffset, bossKnight.knightPos.y);
          }
          
          if (bossKnight.drawsTillAttackFrame <= 0)
          {
            bossKnight.currFrame++;
            bossKnight.drawsTillAttackFrame = knightBossAttackFrameRate;
            
            if (bossKnight.currFrame >= bossKnight.knightAttackLeft.length)
            {
              bossKnight.currFrame = 0;
            }
          }
        }
        else // Only Other Action Available To Boss Is Left Movement
        {
          if (bossKnight.action != "moveLeft") // Checks To Make Sure Frames Are Reset
          {
            bossKnight.action = "moveleft";
            bossKnight.currFrame = 0;
            bossKnight.drawsTillNextFrame = knightBossFrameRate;
          }
          
          if (bossKnight.knightPos.x - playerMoveOffset - 256 <= 100)
          {
            bossKnight.drawsTillNextFrame--;
            image(bossKnight.knightLeft[bossKnight.currFrame], bossKnight.knightPos.x - playerMoveOffset, bossKnight.knightPos.y);
            
            if (bossKnight.drawsTillNextFrame <= 0)
            {
              bossKnight.currFrame++;
              bossKnight.drawsTillNextFrame = knightBossFrameRate;
              bossKnight.knightPos.x -= bossMovementSpeed;
              
              if (bossKnight.currFrame >= bossKnight.knightLeft.length)
              {
                bossKnight.currFrame = 0;
              }
            }
          }
          else 
          {
            image(bossKnight.knightLeft[bossKnight.currFrame], bossKnight.knightPos.x - playerMoveOffset, bossKnight.knightPos.y);
          }
        }
      }
    }
    else if (bossKnight.isDying && !bossKnight.alive) // Create Dying Animation
    {
      if (bossKnight.action != "dying") // Checks To Make Sure Frames Are Reset
      {
        bossKnight.action = "dying";
        bossKnight.currFrame = 0;
        bossKnight.drawsTillNextFrame = knightAttackFrameRate;
      }
      
      bossKnight.drawsTillNextFrame--;
      
      image(bossKnight.knightDieLeft[bossKnight.currFrame], bossKnight.knightPos.x - playerMoveOffset, bossKnight.knightPos.y);
      
      if (bossKnight.currFrame == 0) knightDeathSound.play();
      
      if (bossKnight.drawsTillNextFrame <= 0)
      {
        bossKnight.currFrame++;
        knightDeathSound.play();
        if (bossKnight.currFrame >= bossKnight.knightDieLeft.length)
        {
          bossKnight.currFrame = 0;
          bossKnight.isDying = false;
          bossKnight.alive = false;
          lastScene = false;
          
          gameState = "fade";
        }
        bossKnight.drawsTillNextFrame = knightAttackFrameRate;
      }
    }
    else // In case of player dying and boss is still alive
    {
      if (bossKnight.alive) image(bossKnight.knightLeft[0], bossKnight.knightPos.x - playerMoveOffset, bossKnight.knightPos.y);
    }
  }
  else if (gameState == "loseLife") // Lose Life Animation
  {
    background(0);
    
    if (playerKnight.lifeFrame >= 0)
    {
      drawsTillRestart--;
      drawsTillDropLifeHeart--;
            
      image(playerKnight.life[playerKnight.lifeFrame + 1], width/2 - playerKnight.life[0].width/2, height/2);
      
      if (drawsTillDropLifeHeart <= 0)
      {
        image(playerKnight.life[playerKnight.lifeFrame], width/2 - playerKnight.life[0].width/2, height/2);
        
        if (drawsTillDropLifeHeart == 0) knightDamageSound.play(1, 0, 1);
        
        utilFrame = 0;
        textState = 0;
        drawsTillArrowFrame = 15;
      }
      
      if (drawsTillRestart <= 0) // Reset All Controls Back To Beginning
      {
        if (playerKnight.lifeFrame != 0)
        {
          reset(false);
          gameState = "game";
        }
        else if (playerKnight.lifeFrame == 0)
        {
          gameBackgroundSound.play();
          titleBackgroundSound.play();
          
          gameState = "gameOver";
        }
      }
    }
  }
  else if (gameState == "endGameScene") // Final End Game Scene
  {
    playerMoveOffset = 1790;
    
    image(dungeonBackground, -playerMoveOffset, 0);
    image(bossKnight.knightDieLeft[4], playerKnight.knightPos.x + 30, bossKnight.knightPos.y - 2);
    
    // Display Health Bar for Player
    fill(255);
    textFont(helpFont);
    text("Player Health", width/16, 1.5 * height/32);
    image(playerKnight.life[playerKnight.lifeFrame], 2.25 * width/16, height/16);
    
    if (creditKnight.knightPos.x <= 64) // Draws creditKnight Running To Bridge
    {
      image(playerKnight.knightLeft[0], playerKnight.knightPos.x, playerKnight.knightPos.y);
      image(creditKnight.knightRight[creditKnight.currFrame], creditKnight.knightPos.x, creditKnight.knightPos.y);
      creditKnight.drawsTillNextFrame--;
      
      if (creditKnight.drawsTillNextFrame <= 0)
      {
        creditKnight.currFrame++;
        creditKnight.knightPos.x += 4;
        creditKnight.drawsTillNextFrame = endSceneFrameRate;
        
        if (creditKnight.currFrame >= creditKnight.knightRight.length)
        {
          creditKnight.currFrame = 0;
        }
      }
    }
    else if (!endGame) // Pauses Game For First Part of Final End Scene (All Text Scene)
    {      
      image(playerKnight.knightLeft[0], playerKnight.knightPos.x, playerKnight.knightPos.y);
      image(creditKnight.knightRight[0], creditKnight.knightPos.x, creditKnight.knightPos.y);
      
      
      drawsTillArrowFrame--;
    
      if (drawsTillArrowFrame <= 0)
      {
        utilFrame++;
        drawsTillArrowFrame = 15;
        
        if (utilFrame >= downArrowContinue.length)
        {
          utilFrame = 0;
        }
      }
            
      fill(0);
      rect(width/4, 8.5 * height/10, 2 * width/4, height/10);
      
      fill(255);
      textFont(endFont);
      
      if (textState == 0) 
      {
        text("YOU MONSTER ! ", 1.6 * width/4, 9.1 * height/10);
        image(downArrowContinue[utilFrame], 1.22 * width/2, 9.0 * height/10);
      }
      
      else if (textState == 1) 
      {
        text("HOW COULD YOU ! ", 1.6 * width/4, 9.1 * height/10);
      }
      
      if (textState >= 1)
      {
        image(downArrowContinue[utilFrame], 1.3 * width/2, 9.0 * height/10);
      }
    }
    else // Triggers Second Part of Final End Scene
    {
      if (playerKnight.knightPos.x - creditKnight.knightPos.x - (creditKnight.knightAttackRight[0].width) - playerKnight.knightSlashRight.width > 0)
      {
        image(playerKnight.knightLeft[0], playerKnight.knightPos.x, playerKnight.knightPos.y);
        image(creditKnight.knightRight[creditKnight.currFrame], creditKnight.knightPos.x, creditKnight.knightPos.y);
        creditKnight.drawsTillNextFrame--;
        
        if (creditKnight.drawsTillNextFrame <= 0)
        {
          creditKnight.currFrame++;
          creditKnight.knightPos.x += 8;
          creditKnight.drawsTillNextFrame = endSceneFrameRate;
          
          if (creditKnight.currFrame >= creditKnight.knightRight.length)
          {
            creditKnight.currFrame = 0;
          }
        }
      }
      else // Plays creditKnight Attack Animation
      {        
        if (creditKnight.currFrame >= creditKnight.knightAttackRight.length)
        {
          endSceneFrameRate *= 3;
          
          creditKnight.currFrame = 0;
          creditKnight.drawsTillNextFrame = endSceneFrameRate;
          playerKnight.drawsTillNextFrame = endSceneFrameRate;
        }
        
        creditKnight.drawsTillNextFrame--;
        
        if (playerKnight.isDying) 
        {
          playerKnight.drawsTillNextFrame--;
          
          if (playerKnight.lifeFrame <= 1 && playerKnight.isDying) 
          {
            image(playerKnight.knightDieLeft[playerKnight.currFrame], playerKnight.knightPos.x, playerKnight.knightPos.y);
            
            if (playerKnight.lifeFrame == 0) playerKnight.lifeFrame++;
            else playerKnight.lifeFrame--;
          }
        }
                
        image(creditKnight.knightAttackRight[creditKnight.currFrame], creditKnight.knightPos.x, creditKnight.knightPos.y);
                
        if (creditKnight.currFrame == 1)
        {     
          
          if (playerKnight.lifeFrame < 1)
          {
            playerKnight.currFrame = 0;
            playerKnight.drawsTillNextFrame = endSceneFrameRate;
            
            playerKnight.isDying = true;
          }
          
          if (creditKnight.drawsTillNextFrame <= 0)
          {
            creditKnight.currFrame = 0;
            creditKnight.drawsTillNextFrame = endSceneFrameRate; 
          }
          else
          {
            if (playerKnight.lifeFrame >= 1)
            {
              image(playerKnight.knightDamage[0], playerKnight.knightPos.x, playerKnight.knightPos.y);
            }
          }
        }
        else if (creditKnight.currFrame == 0)
        {          
          if (creditKnight.drawsTillNextFrame <= 0)
          {                        
            if (!playerKnight.isDying)
            {
              knightSlashSound.play();
              
              creditKnight.currFrame++;
              creditKnight.drawsTillNextFrame = endSceneFrameRate;
              
              if (playerKnight.lifeFrame > 1) playerKnight.lifeFrame--;
              else 
              {
                playerKnight.isDying = true;
              }
            }            
            else if (playerKnight.isDying && playerKnight.drawsTillNextFrame <= 0)
            {
              knightDeathSound.play(1, 0, soundController);
              soundController -= 0.23;
              playerKnight.currFrame++;
              playerKnight.drawsTillNextFrame = endSceneFrameRate;
              
              if (playerKnight.currFrame >= playerKnight.knightDieLeft.length)
              {
                playerKnight.currFrame = 0;
                playerKnight.lifeFrame = 1;
                gameState = "fade";
              }
            }
          }
          else if (playerKnight.lifeFrame >= 0 && !playerKnight.isDying)
          { 
            image(playerKnight.knightBlockLeft, playerKnight.knightPos.x, playerKnight.knightPos.y);
          }
        }
      }
    }
  }  
  else if (gameState == "gameOver")
  {
    background(0);
    fill(255);
    textFont(gameFont);
    text("Game Over", textWidth, textHeight + textHeightDiff);
  }  
}

void keyPressed()
{
  if (keyCode == 'R')
  {
    reset(true);
    titleBackgroundSound.stop();
    titleBackgroundSound.play();
  }
  
  if (inDefend && keyCode == 'A')
  {
    if (playerKnight.prevAction == "moveRight")
    {
      playerKnight.prevAction = "attackRight";
    }
    else if (playerKnight.prevAction == "moveLeft")
    {
      playerKnight.prevAction = "attackLeft";
    }
  }
  
  if (gameState == "menu")
  {
    if (textState <= 2 && textState >= 0)
    { 
      if (keyCode == UP && textState != 0) textState--;
      else if (keyCode == DOWN && textState != 2) textState++;
      else if (keyCode == ENTER)
      {
        if (textState == 1) gameDifficulty = "normal";
        else if (textState == 0) gameDifficulty = "hard";
        else if (textState == 2) gameDifficulty = "easy";
        
        textState = 0;
        createEnemyKnights();
        gameState = "title";
      }
    }
  }
  else if (gameState == "title")
  {
    if (keyCode == ENTER) textState++;
    if (textState >= 7)
    {
      utilFrame = 0;
      textState = 0;
      drawsTillArrowFrame = 15;
      
      gameState = "help";
    }
  }
  else if (gameState == "help")
  {
    utilFrame = 0;
    
    gameState = "game";
    
    gameBackgroundSound.loop();
  }
  else if (gameState == "endGameScene" && creditKnight.knightPos.x > 56) // Check For Text Box Continue
  {
    if (textState < 1) 
      {
        if (keyCode == ENTER) 
        {
          textState++;
          knightYellSound.play(1.1, 0, 1);
        }
      }
    else 
    {
      knightYellSound.play(1.1, 0, 1);
      utilFrame = 0;
      textState = 0;
      drawsTillArrowFrame = 15;
      endGame = true;
    }
  }
  else if (gameState == "game")
  {
    if (startGame) startGame= false;
    
    if (lastScene && textState <= 1) // Check For Text Box Continue
    {
      if (textState <= 1) 
      {
        if (keyCode == ENTER) 
        {
          textState++;
          knightYellSound.play(1.1, 0, 1);
        }
      }
      else 
      {
        utilFrame = 0;
        drawsTillArrowFrame = 15;
        lastScene = true;
      }
    }
    else if (keyCode == 'D') // Defend checked first so that animation can be held
    {
      playerKnight.defend();
      inDefend = true;
    }
    else 
    {
      inDefend = false;
      
      if (!inAnimation)
      {
        if (keyCode == LEFT)
        {
          playerKnight.move(true);
          playerKnight.currFrame++;
          
          // 20 is the value that marks the end of the map on the left
          if (playerMoveOffset >= -20) playerMoveOffset -= playerMoveSpeed;
      
          if (playerKnight.currFrame >= playerKnight.knightLeft.length) playerKnight.currFrame = 0;
        } 
        else if (keyCode == RIGHT)
        {
          playerKnight.move(false);
          playerKnight.currFrame++;
          
          playerMoveOffset += playerMoveSpeed;
      
          if (playerKnight.currFrame >= playerKnight.knightRight.length) playerKnight.currFrame = 0;
        } 
        else if (keyCode == 'A' && !inAnimation)
        {
          inAnimation = true;
          playerKnight.currFrame = 0;
          if (playerKnight.action != "attackLeft" || playerKnight.action != "attackRight") playerKnight.attack();
        }
        else if (keyCode == 'H')
        {
          gameState = "help";
        }
      }
    }
  }
}

void mousePressed()
{
}
