package mvc.model
{
   import flash.net.registerClassAlias;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class GameStateVolleyball extends IGameState implements IExternalizable
   {
      
      public static var $netHeight:Number = 1;
      
      public static var $borderThickness:Number = 1;
      
      public static var $ppm:Number = 5;
      
      public static var $ballRadius:Number = 3.5;
      
      public static var $ballDensity:Number = 0.5;
      
      public static var $ballRestitution:Number = 0.8;
      
      public static var $ballLinearDamping:Number = 0.3;
      
      public static var $discFriction:Number = 0;
      
      public static var $discRestitution:Number = 0.95;
      
      public static var $discDensity:Number = 1;
      
      public static var $discLinearDamping:Number = 3;
      
      public static var $discRadius:Number = 1;
      
      public static var $discAllForce:Number = 300;
      
      public static var $gravity:Number = 40;
      
      public static var $timeScale:Number = 0.55;
      
      private static const ALIAS = registerClassAlias("gv",GameStateVolleyball);
       
      
      public var ppm:Number;
      
      public var netHeight:Number;
      
      public var borderThickness:Number;
      
      public var gravity:Number;
      
      public var timeScale:Number;
      
      public var balls:Array;
      
      public var discs:Array;
      
      public var lastScoringTeam:Number;
      
      public function GameStateVolleyball()
      {
         super();
      }
      
      public static function getInitialState(param1:Array, param2:GameSettings, param3:Number = -1) : GameStateVolleyball
      {
         var _loc4_:* = null;
         var _loc5_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:* = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:* = null;
         _loc4_ = new GameStateVolleyball();
         _loc4_.scores = [0,0];
         _loc4_.borderThickness = $borderThickness;
         _loc4_.ppm = $ppm;
         _loc4_.framesToReset = 0;
         _loc4_.framesToUnfreeze = 4 * Main.$physicsPerSecond;
         _loc4_.framesToGameOver = -1;
         _loc4_.lastScoringTeam = param3;
         _loc4_.gravity = $gravity;
         _loc4_.netHeight = $netHeight;
         _loc4_.timeScale = $timeScale;
         _loc4_.map = param2.map;
         _loc4_.balls = [new BallState()];
         _loc5_ = Main.$logW / 2;
         _loc4_.balls[0].x = _loc5_ / _loc4_.ppm;
         _loc4_.balls[0].y = (Main.$logH / 2 + 70) / _loc4_.ppm;
         _loc4_.balls[0].xv = 0;
         _loc4_.balls[0].yv = 0;
         _loc4_.balls[0].radius = $ballRadius;
         _loc4_.balls[0].density = $ballDensity;
         _loc4_.balls[0].restitution = $ballRestitution;
         _loc4_.balls[0].linearDamping = $ballLinearDamping;
         _loc4_.discs = new Array();
         var _loc6_:* = [0,0,0];
         var _loc7_:int = 0;
         while(_loc7_ < param1.length)
         {
            if(param1[_loc7_] && param1[_loc7_][0] != 0)
            {
               _loc8_ = param1[_loc7_][0];
               _loc9_ = _loc8_ == 1?-125:Number(125);
               if(_loc8_ == 1)
               {
                  _loc9_ = _loc9_ - 60 * _loc6_[_loc8_];
               }
               else
               {
                  _loc9_ = _loc9_ + 60 * _loc6_[_loc8_];
               }
               _loc10_ = Main.$logW / 2 + _loc9_;
               _loc11_ = 150;
               _loc12_ = Main.$logH / 2 + _loc11_;
               _loc13_ = new DiscState();
               _loc13_.x = _loc10_ / _loc4_.ppm;
               _loc13_.y = _loc12_ / _loc4_.ppm;
               _loc13_.xv = 0;
               _loc13_.yv = 0;
               _loc13_.friction = $discFriction;
               _loc13_.restitution = $discRestitution;
               _loc13_.density = $discDensity;
               _loc13_.linearDamping = $discLinearDamping;
               _loc13_.radius = $discRadius;
               _loc13_.allForce = $discAllForce;
               _loc13_.team = param1[_loc7_][0];
               _loc13_.alive = true;
               _loc13_.playerName = param1[_loc7_][1];
               _loc13_.action1Ammo = 1000;
               _loc4_.discs[_loc7_] = _loc13_;
               _loc6_[_loc8_]++;
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         var _loc2_:* = undefined;
         param1.writeShort(map);
         param1.writeInt(scores[0]);
         param1.writeInt(scores[1]);
         param1.writeInt(this.ppm);
         param1.writeDouble(this.netHeight);
         param1.writeDouble(this.borderThickness);
         param1.writeDouble(this.gravity);
         param1.writeDouble(this.timeScale);
         param1.writeShort(framesToReset);
         param1.writeShort(framesToUnfreeze);
         param1.writeShort(framesToGameOver);
         param1.writeShort(this.lastScoringTeam);
         param1.writeInt(this.balls.length);
         _loc2_ = 0;
         while(_loc2_ < this.balls.length)
         {
            param1.writeObject(this.balls[_loc2_]);
            _loc2_++;
         }
         param1.writeInt(this.discs.length);
         _loc2_ = 0;
         while(_loc2_ < this.discs.length)
         {
            param1.writeObject(this.discs[_loc2_]);
            _loc2_++;
         }
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         var _loc3_:* = undefined;
         map = param1.readShort();
         scores = [param1.readInt(),param1.readInt()];
         this.ppm = param1.readInt();
         this.netHeight = param1.readDouble();
         this.borderThickness = param1.readDouble();
         this.gravity = param1.readDouble();
         this.timeScale = param1.readDouble();
         framesToReset = param1.readShort();
         framesToUnfreeze = param1.readShort();
         framesToGameOver = param1.readShort();
         this.lastScoringTeam = param1.readShort();
         var _loc2_:Number = param1.readInt();
         this.balls = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.balls[_loc3_] = param1.readObject() as BallState;
            _loc3_++;
         }
         var _loc4_:Number = param1.readInt();
         this.discs = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.discs[_loc3_] = param1.readObject() as DiscState;
            _loc3_++;
         }
      }
   }
}
