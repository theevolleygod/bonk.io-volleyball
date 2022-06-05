package mvc.controller
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   
   public class WallCreatorVolleyball
   {
       
      
      private var _left:b2Body;
      
      private var _right:b2Body;
      
      private var _top:b2Body;
      
      private var _bottom:b2Body;
      
      private var _net:b2Body;
      
      private var _dividerMiddle:b2Body;
      
      public function WallCreatorVolleyball(param1:b2World, param2:Number, param3:Number, param4:Number, param5:Number = NaN, param6:Number = NaN)
      {
         super();
         var _loc7_:b2BodyDef = new b2BodyDef();
         _loc7_.type = b2Body.b2_staticBody;
         _loc7_.position.Set(param2 / param3 / 2,Main.$logH / 2 / param3);
         this._left = param1.CreateBody(_loc7_);
         _loc7_.position.Set(Main.$logW / param3 - param2 / param3 / 2,Main.$logH / 2 / param3);
         this._right = param1.CreateBody(_loc7_);
         _loc7_.position.Set(Main.$logW / 2 / param3,param2 / param3 / 2);
         this._top = param1.CreateBody(_loc7_);
         _loc7_.position.Set(Main.$logW / 2 / param3,Main.$logH / param3 - param2 / param3 / 2);
         this._bottom = param1.CreateBody(_loc7_);
         var _loc8_:b2PolygonShape = new b2PolygonShape();
         _loc8_.SetAsBox(Main.$logW / 2 / param3,param2 / param3 / 2);
         var _loc9_:b2PolygonShape = new b2PolygonShape();
         _loc9_.SetAsBox(param2 / param3 / 2,Main.$logH / 2 / param3);
         var _loc10_:b2PolygonShape = new b2PolygonShape();
         _loc10_.SetAsBox(param2 / param3 / 2,param4 / param3 / 2);
         var _loc11_:b2PolygonShape = new b2PolygonShape();
         _loc11_.SetAsBox(2 / param3 / 2,Main.$logH / param3 / 2);
         var _loc12_:b2FixtureDef = new b2FixtureDef();
         _loc12_.friction = 0;
         _loc12_.restitution = 0.8;
         if(!isNaN(param5))
         {
            _loc12_.filter.categoryBits = param5;
         }
         if(!isNaN(param6))
         {
            _loc12_.filter.maskBits = param6;
         }
         _loc12_.shape = _loc9_;
         this._left.CreateFixture(_loc12_);
         this._right.CreateFixture(_loc12_);
         _loc12_.shape = _loc8_;
         this._top.CreateFixture(_loc12_);
         this._bottom.CreateFixture(_loc12_);
         _loc7_.position.Set(Main.$logW / 2 / param3,(Main.$logH - param2 - param4 / 2) / param3);
         this._net = param1.CreateBody(_loc7_);
         _loc12_.shape = _loc10_;
         this._net.CreateFixture(_loc12_);
         _loc7_.position.Set(Main.$logW / 2 / param3,Main.$logH / 2 / param3);
         this._dividerMiddle = param1.CreateBody(_loc7_);
         _loc12_.shape = _loc11_;
         _loc12_.filter.maskBits = 2;
         this._dividerMiddle.CreateFixture(_loc12_);
         var _loc13_:Object = new Object();
         _loc13_.type = "volleyballfloor";
         this._bottom.SetUserData(_loc13_);
      }
      
      public function destroy(param1:b2World) : *
      {
         param1.DestroyBody(this._left);
         param1.DestroyBody(this._right);
         param1.DestroyBody(this._top);
         param1.DestroyBody(this._bottom);
         param1.DestroyBody(this._net);
         param1.DestroyBody(this._dividerMiddle);
         this._left = null;
         this._right = null;
         this._top = null;
         this._bottom = null;
         this._net = null;
         this._dividerMiddle = null;
      }
   }
}
