package core
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Interfaces.IState;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.display.Sprite;
	import Box2D.Dynamics.Joints.b2Joint;
	
	public class PhysicsState extends State
	{
		protected var _world:b2World;
		protected var _gravity:b2Vec2;
		protected var _worldScale:int = 30;
		protected var _debugDrawVisible:Boolean;
		
		public function PhysicsState(game:Game)
		{
			super();
		}

		override public function init(event:Event):void
		{
			_gravity = new b2Vec2(0,0);
			_world = new b2World(_gravity,false);
			debugDraw(HowMany.debugSprite);
			super.init(event);
		}
		
		override public function update(event:Event):void
		{
			_world.Step(1 / 30, 10, 10);
			for (var currentBody:b2Body= _world.GetBodyList(); currentBody; currentBody = currentBody.GetNext()) {
				if (currentBody.GetUserData()) {
					if (currentBody.GetUserData().assetSprite!=null) {
						currentBody.GetUserData().assetSprite.x =  currentBody.GetPosition().x * _worldScale - (currentBody.GetUserData().assetSprite.width / 2);
						currentBody.GetUserData().assetSprite.y = currentBody.GetPosition().y * _worldScale - (currentBody.GetUserData().assetSprite.height / 2);
						//currentBody.GetUserData().assetSprite.rotation = currentBody.GetAngle() * 0.1;
						
					}
					// se modifico esta parte para saber cuantos cuerpos existen en este punto
					if (currentBody.GetUserData().remove) {
						if (currentBody.GetUserData().assetSprite != null && stage.contains(currentBody.GetUserData().assetSprite)) {
							removeChild(currentBody.GetUserData().assetSprite);
						}
						_world.DestroyBody(currentBody);
					}
				}
			}
			// joints 
			for (var currentJoint:b2Joint = _world.GetJointList(); currentJoint; currentJoint = currentJoint.GetNext()) 
			{
				if (currentJoint.GetUserData()) 
				{
					if (currentJoint.GetUserData().remove) {
						_world.DestroyJoint(currentJoint);
					}
				}
			}
			_world.ClearForces();
			_world.DrawDebugData();
		}
		
		protected function debugDraw(debugSprite:flash.display.Sprite):void
		{
			var worldDebugDraw:b2DebugDraw = new b2DebugDraw();
			worldDebugDraw.SetSprite(debugSprite);
			worldDebugDraw.SetDrawScale(_worldScale);
			//worldDebugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			//worldDebugDraw.SetFlags(b2DebugDraw.e_jointBit);
			//worldDebugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			worldDebugDraw.SetFillAlpha(1.5);
			_world.SetDebugDraw(worldDebugDraw);
		}
	}
}