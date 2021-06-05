/*


      ///////////////////////////////
      /////////////Vars//////////////
      ///////////////////////////////

        - 8 Different Game States -
    States are in order as explained below:
   
      "menu"          - menu state to select difficulty
   
      "title"         - title state
      
      "help"          - provides important info for players
      
      "pause"         - currently not used as "help" state can act as pause
      
      "fade"          - used to create screen fading animation 
                          + acts as an intermediate between some states
                          
      "game"          - state that controls knight animations and is what is
                          constantly displaying the images and updating vars
                          
      "loseLife"      - displays loss of hearts (lives) animation
      
      "endGameScene"  - used to display end game animation
      
      "gameOver"      - displays "Game Over" after 
      
      
        - 3 Level Difficulties -
        
              Hard
              Normal
              Easy
      
      
        - 11 Different Class Objects -
        
              playerKnight
              bossKnight
              creditKnight
              
  // enemyKnight objects were hardcoded to ensure a preset gameplay //
              enemyKnightOne
              enemyKnightTwo
              enemyKnightThree
              enemyKnightFour
              enemyKnightFive
              enemyKnightSix
              enemyKnightSeven
              enemyKnightEight
              
              
              
        - 6 Keyboard Commands -
              
          LEFT    - Left Movement
          RIGHT   - Right Movement
          
          A       - Attack
          D       - Defend
          R       - Restart
          H       - Help Menu



      ///////////////////////////////
      /////////Loaded Assets/////////
      ///////////////////////////////

        - 9 Different Sound Assets -

           gameBackgroundSound
           titleBackgroundSound
          
           knightSlashSound
           knightDeathSound
           knightDamageSound
           knightDefendSound
           knightYellSound
           smallEnemySlashSound
           smallEnemyDeathSound
           
           
                                          - 27 Different Image Asset Groups -
                     Asset groups below reference to PImage arrays and objects and not the actual images

      //PlayerKnight assets     //Boss Knight Assets      //Credit Knight Assets    //Small Enemy Assets    //Misc. Assets
        
        playerKnightLeft          bossKnightLeft            creditKnightRight            enemyLeft           life
        playerKnightRight         bossKnightAttackRight     creditKnightAttackLeft       enemyAttack         dungeonBackground
        playerKnightAttackLeft    bossKnightDieLeft                                      enemyDie            dungeonGate
        playerKnightAttackRight   bossKnightDieRight                                     enemySlashLeft;     closeGate
        playerKnightDieLeft       bossKnightDamage                                                           downArrowContinue
        playerKnightDieRight      
        playerKnightDamage        
        playerKnightBlockLeft
        playerKnightBlockRight
        playerKnightSlashLeft
        playerKnightSlashRight
              
              
              
        - 3 Font Assets -

        Trattatello-48.vlw
        AppleBraille-16.vlw
        ArialNarrow-Bold-16.vlw


*/
