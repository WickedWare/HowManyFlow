package core
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	public class BodyFactory
	{
		public static function createBox(w,h,px,py,world,worldScale,name,_static:Boolean = true,image = null, _categoryBits = null, _maskbits = null):b2Body
		{
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(w/worldScale,h/worldScale);
			var boxFixture:b2FixtureDef = new b2FixtureDef();
			boxFixture.density=0;
			boxFixture.friction=10;
			boxFixture.restitution=0.3;
			boxFixture.shape = boxShape;
			if (_categoryBits)
				boxFixture.filter.categoryBits = _categoryBits;
			if (_maskbits)
				boxFixture.filter.maskBits = _maskbits;
			var boxBodyDef:b2BodyDef = new b2BodyDef();
			boxBodyDef.position.Set(px/worldScale,py/worldScale);
			boxBodyDef.userData={assetName:name,assetSprite:image,remove:false};
			if (_static == false)
				boxBodyDef.type=b2Body.b2_dynamicBody;
			var box:b2Body = world.CreateBody(boxBodyDef);
			box.CreateFixture(boxFixture);
			return box;
		}
		
		public static function createSphere(r,px,py,world,worldScale,name,_static:Boolean = true,image = null, _categoryBits = null, _maskbits = null):b2Body
		{
			var sphereShape:b2CircleShape = new b2CircleShape(r/worldScale);
			var sphereFixture:b2FixtureDef = new b2FixtureDef();
			sphereFixture.density=0.2;
			sphereFixture.friction=1;
			sphereFixture.restitution=0.1;
			sphereFixture.shape = sphereShape;
			if (_categoryBits)
				sphereFixture.filter.categoryBits = _categoryBits;
			var sphereBodyDef:b2BodyDef = new b2BodyDef();
			sphereBodyDef.position.Set(px/worldScale,py/worldScale);
			if (_static == false)
				sphereBodyDef.type=b2Body.b2_dynamicBody;
			sphereBodyDef.userData = {assetName:name, assetSprite:image, remove:false };
			// cuerpo fisico de la lengua
			var sphere:b2Body;
			sphere = world.CreateBody(sphereBodyDef);
			sphere.CreateFixture(sphereFixture);
			return sphere;
		}
		
//		public static function createPolygon():b2Body
//		{
//			return null;
//		}
		
		public static function createDistanceJoint(bodyA:b2Body, bodyB:b2Body, world:b2World):b2DistanceJoint
		{
			var dJoint:b2DistanceJointDef = new b2DistanceJointDef();
			dJoint.bodyA = bodyA;
			dJoint.bodyB = bodyB;
			dJoint.localAnchorA = new b2Vec2(0, 0);
			dJoint.localAnchorB = new b2Vec2(0, 0);
			dJoint.length = 5;
			dJoint.userData = {remove:false};
			var distanceJoint:b2DistanceJoint;
			distanceJoint = world.CreateJoint(dJoint) as b2DistanceJoint;
			return distanceJoint;
		}
		
		public static function createMouseJoint(body:b2Body, target:b2Vec2,world:b2World):b2MouseJoint
		{
			var mJoint:b2MouseJointDef = new b2MouseJointDef();
			mJoint.bodyA = world.GetGroundBody();
			mJoint.bodyB = body;
			mJoint.target = target;
			mJoint.maxForce = 1000* body.GetMass();
			mJoint.userData = {remove:false};
			var mouseJoint:b2MouseJoint = world.CreateJoint(mJoint) as b2MouseJoint;
			return mouseJoint;
		}
		
//		public static function createRevoluteJoint():b2RevoluteJoint
//		{
//			return null;
//		}
	}
}