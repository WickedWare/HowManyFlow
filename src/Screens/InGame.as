package Screens
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Managers.AssetsManager;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;

	//import Physics.customContactListener;
	
	public class InGame extends starling.display.Sprite
	{
		// variables privadas 
		private var world:b2World;
		private var worldScale:int = 3;
		//private var customContact:customContactListener;
		private var stopTimer:Timer = new Timer(2000);
		private var timerStopped:Boolean = false;
		private var makeStaticTimer:Timer = new Timer(4000);
		
		private var balls:Vector.<b2Body>;
		private var frames:Vector.<b2Body>;
		private var joints:Array;
		private var shuffled:Boolean = false;
		private var hooked:Boolean = false;
		//UI elements 
		private var shuffleButton:Button;
		
		public function InGame()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			// se generan los elemntos del escenario y la logica del juego 
			var gravity:b2Vec2 = new b2Vec2(0,0);
			//customContact = new customContactListener();
			world = new b2World(gravity,false);
			//world.SetContactListener(customContact);
			debugDraw(HowMany.debugSprite);
			// instancia los elemntos de la escena 
			addWall(1024, 10, 512, 770, "floor");
			addWall(10, 780, 1014, 390, "leftWall");
			addWall(10, 780, 10, 390, "rightWall");
			addWall(1024, 10, 512, 10, "ceiling");
			//var body:b2Body = addSphere(10,512,390);
			var randomNumber:int = randomInt(1, 30);
			trace("numero de bolas " + randomNumber);
			balls = new Vector.<b2Body>();
			for (var i:int = 0; i < 30; i++)
			{
				var randomX:int = randomInt(20, 1000);
				var randomY:int = randomInt(20, 700);
				var body:b2Body = addBall(20, randomX, randomY);	
				balls.push(body);
			}
			
			// 5 frames 
			var initialX:int = 50;
			var initialY:int = 50;
			frames = new Vector.<b2Body>();
			for (var row:int = 0; row < 8; row++)
			{
				for (var column:int = 0; column < 5; column++)
				{
					var frame:b2Body = addFrame(5,5,initialX + (column*100), initialY + (row * 95));
					frames.push(frame);
				}
			}
			joints = new Array();
			// UI elements 
			shuffleButton = new Button(AssetsManager.getTexture("shuffle"));
			shuffleButton.x = 850;
			shuffleButton.y = 50;
			shuffleButton.scaleX = 0.8;
			shuffleButton.scaleY = 0.8;
			this.addChild(shuffleButton);
			shuffleButton.addEventListener(starling.events.Event.TRIGGERED, onShuffleTriggered);
			// elementos dinamicos  en la escena 
			this.addEventListener(starling.events.Event.ENTER_FRAME, updateWorld);
			stopTimer.addEventListener(TimerEvent.TIMER, OnStopTimer);
			stopTimer.start();
		}
		
		private function onShuffleTriggered(event:Event):void
		{
			if (shuffled)
			{
				shuffled = false;
				hooked = false;
				for(var i:int = 0; i < joints.length; i++)
				{
					world.DestroyJoint(joints[i]);
					joints.splice(i,1);
				}
				trace("numero de joints despues de eliminar: " + joints.length);
				stopTimer.addEventListener(TimerEvent.TIMER, OnStopTimer);
				stopTimer.start();
				timerStopped = false;
//				for (var i:int = 0; i < balls.length; i++)
//				{
//					balls[i].SetType(b2Body.b2_dynamicBody);
//				}
			}
			else 
			{
				// instancia los joints 
				for(var i:int = 0; i < balls.length; i++)
				{
					var distanceJoint:b2DistanceJoint = addDistanceJoint(balls[i],frames[i]);
					joints.push(distanceJoint);
				}
				trace("numero de joints antes de eliminar: " + joints.length);
				hooked = true;
				shuffled = true;
			}
		}
		
		protected function OnStopTimer(event:TimerEvent):void
		{
			stopTimer.stop();
			stopTimer.removeEventListener(TimerEvent.TIMER, OnStopTimer);
			timerStopped = true;
			makeStaticTimer.addEventListener(TimerEvent.TIMER, onMakeStaticTimer);
			makeStaticTimer.start();
		}		
		
		protected function onMakeStaticTimer(event:TimerEvent):void
		{
			makeStaticTimer.stop();
			makeStaticTimer.removeEventListener(TimerEvent.TIMER, onMakeStaticTimer);
			for (var i:int = 0; i < balls.length; i++)
			{
				balls[i].SetType(b2Body.b2_staticBody);
			}
		}
		
		private function updateWorld(event:Event):void 
		{
			if (world)
			{
				world.Step(1 / 30, 10, 10);
				//trace("el total de cuerpos en este punto: " + levelArray.length);
//				for (var currentBody:b2Body=world.GetBodyList(); currentBody; currentBody=currentBody.GetNext()) {
//					if (currentBody.GetUserData()) {
//						if (currentBody.GetUserData().assetSprite!=null) {
//							currentBody.GetUserData().assetSprite.x=currentBody.GetPosition().x*worldScale;
//							currentBody.GetUserData().assetSprite.y = currentBody.GetPosition().y * worldScale;
//							if (currentBody.GetUserData().assetName != "sphere")
//								currentBody.GetUserData().assetSprite.rotation=currentBody.GetAngle()*(180/Math.PI);
//						}
//						// se modifico esta parte para saber cuantos cuerpos existen en este punto
//						if (currentBody.GetUserData().remove) {
//							if (currentBody.GetUserData().assetSprite != null && stage.contains(currentBody.GetUserData().assetSprite)) {
//								removeChild(currentBody.GetUserData().assetSprite);
//							}
//							world.DestroyBody(currentBody);
//						}
//					}
//				}
				world.ClearForces();
				world.DrawDebugData();
				if (!timerStopped)
					checkImpulses();
				if (shuffled)
					manageJoints();
				//updateCollisions();
				//checkCollisions();
				// periodicas
				//rana.Update(target.x,target.y);
				// ejecuta la funcion update de los mosquitos 
				/*for(var i in mosquitos) {
				mosquitos[i].update();
				}*/
			
				// recorre la lista de joints para hacer un render 
				//jointSprite.graphics.clear();
				//jointSprite.graphics.beginBitmapFill(new lenguaCuerpo(), null, true, false);
				//jointSprite.graphics.lineStyle(20,0xFA8072,1);
				//jointSprite.graphics.lineBitmapStyle(new lenguaCuerpo(), null, true, false);
				//			for (var j:b2Joint = world.GetJointList(); j; j = j.GetNext()) {
				//				if (j.GetUserData().jointName == "lengua")
				//				{
				//					jointSprite.graphics.moveTo(j.GetAnchorA().x * 30, j.GetAnchorA().y * 30);
				//					jointSprite.graphics.lineTo(j.GetAnchorB().x * 30, j.GetAnchorB().y * 30);
				//				}
				//			}
		  	 }
		}
		
		private function manageJoints():void
		{
			if (hooked)
			{
				for (var i:int = 0; i < balls.length; i++)
				{
					balls[i].SetType(b2Body.b2_dynamicBody);
					balls[i].SetAwake(true);
				}
				hooked = false;
			}
			for (var i:int = 0; i < joints.length; i++)
			{
				if (joints[i].GetLength() > 0.5)
					joints[i].SetLength(joints[i].GetLength() * 0.75);
			}
		}
		
		private function checkImpulses():void
		{
			for (var i:int = 0; i < balls.length; i++)
			{
				var randomY:int = randomInt(-300,300);
				var randomX:int = randomInt(-400, 400);
				balls[i].ApplyImpulse(new b2Vec2(randomX,randomY),balls[i].GetWorldCenter());
			}
		}
		
		private function addWall(w,h,px,py,name):void 
		{
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsBox(w/worldScale,h/worldScale);
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density=0;
			floorFixture.friction=10;
			floorFixture.restitution=0.3;
			floorFixture.shape = floorShape;
			var floorBodyDef:b2BodyDef = new b2BodyDef();
			floorBodyDef.position.Set(px/worldScale,py/worldScale);
			floorBodyDef.userData={assetName:name,assetSprite:null,remove:false};
			var floor:b2Body = world.CreateBody(floorBodyDef);
			floor.CreateFixture(floorFixture);
			// agrega este cuerpo en el arreglo del nivel actual 
		 } // addWall
		
		private function addBall(r,px,py):b2Body
		{
			var sphereShape:b2CircleShape = new b2CircleShape(30/worldScale);
			var sphereFixture:b2FixtureDef = new b2FixtureDef();
			sphereFixture.density=0.2;
			sphereFixture.friction=1;
			sphereFixture.restitution=0.1;
			sphereFixture.shape = sphereShape;
			sphereFixture.filter.categoryBits = 4;
			var sphereBodyDef:b2BodyDef = new b2BodyDef();
			sphereBodyDef.position.Set((stage.stageWidth/2)/worldScale,(stage.stageHeight / 2)/worldScale);
			sphereBodyDef.type=b2Body.b2_dynamicBody;
			sphereBodyDef.userData = {assetName:"sphere", assetSprite:null, remove:false };
			// cuerpo fisico de la lengua
			var sphere:b2Body;
			sphere = world.CreateBody(sphereBodyDef);
			sphere.CreateFixture(sphereFixture);
			return sphere;
		}
		
		private function addFrame(w,h,px,py, sprite = null):b2Body
		{
			var cubeShape:b2PolygonShape = new b2PolygonShape();
			cubeShape.SetAsBox(w/worldScale,h/worldScale);
			var cubeFixture:b2FixtureDef = new b2FixtureDef();
			cubeFixture.density=0;
			cubeFixture.friction=10;
			cubeFixture.restitution=0.3;
			cubeFixture.shape = cubeShape;
			cubeFixture.filter.maskBits = 2;
			var cubeBodyDef:b2BodyDef = new b2BodyDef();
			cubeBodyDef.position.Set(px/worldScale,py/worldScale);
			cubeBodyDef.userData={assetName:"frame",assetSprite:sprite,remove:false};
			var cube:b2Body = world.CreateBody(cubeBodyDef);
			cube.CreateFixture(cubeFixture);
			return cube; 
		}
		
		
		private function addDistanceJoint(bodyA:b2Body, bodyB:b2Body):b2DistanceJoint {
			var dJoint:b2DistanceJointDef = new b2DistanceJointDef();
			dJoint.bodyA = bodyA;
			dJoint.bodyB = bodyB;
			dJoint.localAnchorA = new b2Vec2(0, 0);
			dJoint.localAnchorB = new b2Vec2(0, 0);
			dJoint.length = 5;
			var distanceJoint:b2DistanceJoint;
			distanceJoint = world.CreateJoint(dJoint) as b2DistanceJoint;
			return distanceJoint;
		}
		
		private function debugDraw(debugSprite:flash.display.Sprite):void 
		{
			var worldDebugDraw:b2DebugDraw = new b2DebugDraw();
			worldDebugDraw.SetSprite(debugSprite);
			worldDebugDraw.SetDrawScale(worldScale);
			worldDebugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			//worldDebugDraw.SetFlags(b2DebugDraw.e_jointBit);
			//worldDebugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			worldDebugDraw.SetFillAlpha(1.5);
			world.SetDebugDraw(worldDebugDraw);
		}
		
		// helpers externas 
		private function randomInt(lowVal:int, highVal:int):int {
			if (lowVal <= highVal) {
				return (lowVal + Math.floor(Math.random() * (highVal - lowVal + 1)));
			} else {
				throw (new Error("Error en los valores pasados al math.random")); 
			}
		} // randomInt
		
	}
}