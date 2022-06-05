package mvc.controller
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2DebugDraw;
   import Box2D.Dynamics.b2World;
   import flash.display.Sprite;
   import mvc.controller.events.ContactEvent;
   import mvc.model.BallState;
   import mvc.model.DiscState;
   import mvc.model.GameStateVolleyball;
   import mvc.model.InputContainer;
   
   public class SimulatorVolleyball implements ISimulator
   {
      
      public static var $world:b2World;
      
      public static var $goalBallVelocityMultiplier:Number = 0.3;
       
      
      private var _drawDebug:Boolean;
      
      private var _debugSprite:Sprite;
      
      private var _debugDraw:b2DebugDraw;
      
      private var _goalsThisStep:Array;
      
      public function SimulatorVolleyball(param1:Boolean = false, param2:Sprite = null)
      {
         super();
         this._drawDebug = param1;
         this._debugSprite = param2;
      }
      
      public function init(param1:IGameState) : *
      {
         var _loc2_:GameStateVolleyball = param1 as GameStateVolleyball;
         $world = new b2World(new b2Vec2(0,_loc2_.gravity),false);
         $world.SetWarmStarting(false);
         var _loc3_:CustomContactListener = new CustomContactListener(_loc2_.ppm);
         $world.SetContactListener(_loc3_);
         _loc3_.eventDispatcher.addEventListener(ContactEvent.GOAL_SCORED,this.eventGoalScored);
         if(this._drawDebug)
         {
            this._debugDraw = new b2DebugDraw();
            this._debugDraw.SetSprite(this._debugSprite);
            this._debugDraw.SetDrawScale(30);
            this._debugDraw.SetLineThickness(1);
            this._debugDraw.SetAlpha(1);
            this._debugDraw.SetFillAlpha(0.4);
            this._debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
            $world.SetDebugDraw(this._debugDraw);
         }
      }
      
      public function step(param1:IGameState, param2:InputContainer, param3:GameSettings) : IGameState
      {
         var i:* = undefined;
         var gameStateOutput:GameStateVolleyball = null;
         var filterCat:Number = NaN;
         var simplePlayerArray:Array = null;
         var scoredTeamID:Number = NaN;
         var temp:BallState = null;
         var tempD:DiscState = null;
         var iGameState:IGameState = param1;
         var inputState:InputContainer = param2;
         var gameSettings:GameSettings = param3;
         var removingThisPlayerThisStep:Function = function(param1:Number):Boolean
         {
            var _loc2_:* = undefined;
            if(inputState.adminInputs && inputState.adminInputs.playersLeft && inputState.adminInputs.playersLeft.length > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < inputState.adminInputs.playersLeft)
               {
                  if(inputState.adminInputs.playersLeft[_loc2_] == param1)
                  {
                     return true;
                  }
                  _loc2_++;
               }
            }
            return false;
         };
         var gameState:GameStateVolleyball = iGameState as GameStateVolleyball;
         if(this._drawDebug)
         {
            this._debugDraw.SetDrawScale(gameState.ppm);
         }
         var wallCreator:WallCreatorVolleyball = new WallCreatorVolleyball($world,gameState.borderThickness,gameState.ppm,gameState.netHeight);
         var ballCreatorArray:Array = new Array();
         i = 0;
         while(i < gameState.balls.length)
         {
            if(gameState.balls[i])
            {
               ballCreatorArray[i] = new BallCreator($world,gameState.balls[i]);
            }
            i++;
         }
         var discCreatorArray:Array = new Array();
         var j:* = 0;
         while(j < gameState.discs.length)
         {
            if(gameState.discs[j])
            {
               if(removingThisPlayerThisStep(j) == false)
               {
                  filterCat = 2;
                  discCreatorArray[j] = new DiscCreator($world,gameState.discs[j],filterCat);
               }
            }
            j++;
         }
         this._goalsThisStep = [0,0];
         var dontInterpolate:Boolean = false;
         if(gameState.framesToUnfreeze == 0)
         {
            this.applyInputs(discCreatorArray,inputState.keyboardInputs);
         }
         if(ballCreatorArray[0].body.GetLinearVelocity().Length() == 0)
         {
            ballCreatorArray[0].body.SetAwake(false);
         }
         if(gameState.framesToUnfreeze == 0)
         {
            this.physicsStep(gameState.timeScale);
         }
         if(gameState.framesToReset > 0 || gameState.framesToGameOver > 0)
         {
            this._goalsThisStep = [0,0];
         }
         if(gameState.framesToReset == 1)
         {
            simplePlayerArray = new Array();
            i = 0;
            while(i < discCreatorArray.length)
            {
               if(discCreatorArray[i])
               {
                  simplePlayerArray[i] = [discCreatorArray[i].team,discCreatorArray[i].playerName];
               }
               i++;
            }
            gameStateOutput = GameStateVolleyball.getInitialState(simplePlayerArray,gameSettings,gameState.lastScoringTeam);
            gameStateOutput.scores = gameState.scores;
            gameStateOutput.dontInterpolate = true;
            gameStateOutput.ppm = gameState.ppm;
         }
         else
         {
            gameStateOutput = new GameStateVolleyball();
            gameStateOutput.scores = [gameState.scores[0] + this._goalsThisStep[0],gameState.scores[1] + this._goalsThisStep[1]];
            gameStateOutput.borderThickness = gameState.borderThickness;
            gameStateOutput.netHeight = gameState.netHeight;
            gameStateOutput.ppm = gameState.ppm;
            gameStateOutput.dontInterpolate = dontInterpolate;
            gameStateOutput.lastScoringTeam = gameState.lastScoringTeam;
            gameStateOutput.gravity = gameState.gravity;
            gameStateOutput.timeScale = gameState.timeScale;
            gameStateOutput.map = gameState.map;
            gameStateOutput.framesToReset = gameState.framesToReset;
            if(gameStateOutput.framesToReset > 0)
            {
               gameStateOutput.framesToReset--;
            }
            gameStateOutput.framesToUnfreeze = gameState.framesToUnfreeze;
            if(gameStateOutput.framesToUnfreeze > 0)
            {
               gameStateOutput.framesToUnfreeze--;
            }
            gameStateOutput.framesToGameOver = gameState.framesToGameOver;
            if(gameStateOutput.framesToGameOver > 1)
            {
               gameStateOutput.framesToGameOver--;
            }
            if(this._goalsThisStep[0] != 0 || this._goalsThisStep[1] != 0)
            {
               if(this._goalsThisStep[0] != 0)
               {
                  scoredTeamID = 0;
               }
               else
               {
                  scoredTeamID = 1;
               }
               gameStateOutput.lastScoringTeam = scoredTeamID;
               if(gameStateOutput.scores[scoredTeamID] >= gameSettings.roundsToWin)
               {
                  gameStateOutput.framesToGameOver = 4 * Main.$physicsPerSecond;
               }
               else
               {
                  gameStateOutput.framesToReset = 3 * Main.$physicsPerSecond;
               }
            }
            gameStateOutput.balls = new Array();
            i = 0;
            while(i < ballCreatorArray.length)
            {
               if(ballCreatorArray[i])
               {
                  temp = new BallState(ballCreatorArray[i]);
                  gameStateOutput.balls[i] = temp;
               }
               i++;
            }
            gameStateOutput.discs = new Array();
            i = 0;
            while(i < discCreatorArray.length)
            {
               if(discCreatorArray[i])
               {
                  tempD = new DiscState(discCreatorArray[i]);
                  gameStateOutput.discs[i] = tempD;
               }
               i++;
            }
         }
         wallCreator.destroy($world);
         wallCreator = null;
         i = 0;
         while(i < ballCreatorArray.length)
         {
            if(ballCreatorArray[i])
            {
               ballCreatorArray[i].destroy($world);
               ballCreatorArray[i] = null;
            }
            i++;
         }
         ballCreatorArray = null;
         i = 0;
         while(i < discCreatorArray.length)
         {
            if(discCreatorArray[i])
            {
               discCreatorArray[i].destroy($world);
               discCreatorArray[i] = null;
            }
            i++;
         }
         discCreatorArray = null;
         return gameStateOutput;
      }
      
      private function eventGoalScored(param1:ContactEvent) : *
      {
         this._goalsThisStep[param1.scoringTeam]++;
      }
      
      private function physicsStep(param1:Number) : *
      {
         $world.Step(1 / Main.$physicsPerSecond * param1,2,6);
         $world.ClearForces();
         if(this._drawDebug)
         {
            $world.DrawDebugData();
         }
      }
      
      private function applyInputs(param1:Array, param2:Array) : *
      {
         if(param1.length != param2.length)
         {
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_])
            {
               param1[_loc3_].processInputs(param2[_loc3_]);
            }
            _loc3_++;
         }
      }
   }
}
