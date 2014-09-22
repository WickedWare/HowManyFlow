package Screens
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Events.AnswerItemSelected;
	
	import Managers.AssetsManager;
	
	import core.AnswerBox;
	import core.AnswerItem;
	import core.BodyFactory;
	import core.Helpers;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import core.Game;
	import core.PhysicsState;
	
	public class DemoState extends PhysicsState
	{
		//private var customContact:customContactListener;
		//time management
		private var stopTimer:Timer = new Timer(100);
		private var timerStopped:Boolean = false;
		private var makeStaticTimer:Timer = new Timer(4000);
		private var timePrevious:Number = 0;
		private var timeCurrent:Number = 0;
		private var elapsed:Number = 0;
		
		private var balls:Vector.<b2Body>;
		private var frames:Vector.<b2Body>;
		private var ballSprites:Vector.<Image>;
		private var joints:Array;
		private var shuffled:Boolean = false;
		private var hooked:Boolean = false;
		private var inBoxTotalBalls:int = 0;
		//UI elements 
		private var shuffleButton:starling.display.Button;
		private var background:Image;
		
		public function DemoState(game:Game)
		{
			super(game);
		}
		
		override public function init(event:Event):void
		{
			super.init(event);
			// background 
			background = new Image(AssetsManager.getAtlas().getTexture("PanelVertical1"));
			background.x = -30;
			background.y = -30;
			background.scaleX = 2;
			background.scaleY = 2;
			this.addChild(background);
			
			// instancia los elemntos de la escena 
			BodyFactory.createBox(stage.stageWidth, 10, stage.stageWidth / 2, stage.stageHeight - 10, _world,_worldScale,"floor",true,null,null,null);
			BodyFactory.createBox(10, stage.stageHeight, stage.stageWidth - 10, stage.stageHeight / 2, _world,_worldScale,"leftWall",true,null,null,null);
			BodyFactory.createBox(10, stage.stageHeight, 10,stage.stageHeight / 2, _world,_worldScale,"rightWall",true,null,null,null);
			BodyFactory.createBox(stage.stageWidth, 10, stage.stageWidth / 2, 10, _world,_worldScale,"ceiling",true,null,null,null);
			BodyFactory.createBox(10,stage.stageHeight, 850, stage.stageHeight / 2, _world,_worldScale,"separator",true,null,null,null);
			BodyFactory.createBox(10,100,690,80, _world,_worldScale,"shuffleY",true,null,null,null);
			BodyFactory.createBox(80,10,780,170, _world,_worldScale,"suffleX",true,null,null,null);
			
			// separacion del boton suffle 
			var randomNumber:int = Helpers.randomInt(1, 30);
			inBoxTotalBalls = randomNumber;
			balls = new Vector.<b2Body>();
			ballSprites = new Vector.<Image>();
			for (var i:int = 0; i < randomNumber; i++)
			{
				var SphereTexture:Image = new Image(AssetsManager.getAtlas().getTexture("Fruta1"));
				SphereTexture.scaleX = 2;
				SphereTexture.scaleY = 2;
				this.addChild(SphereTexture);
				ballSprites.push(SphereTexture);
				var randomX:int = Helpers.randomInt(20, 500);
				var randomY:int = Helpers.randomInt(20, 700);
				var body:b2Body = BodyFactory.createSphere(35, randomX, randomY, _world, _worldScale, "sphere",false,SphereTexture,4,null); 	
				balls.push(body);
			}
			
			// 5 frames 
			var initialX:int = 50;
			var initialY:int = 50;
			var currentY:int = 0;
			frames = new Vector.<b2Body>();
			var rowFactor:int = 0;
			for (var row:int = 0; row < 8; row++)
			{
				if ( row > 0 && row % 2 == 0)
				{
					currentY += 40;
				}
				for (var column:int = 0; column < 5; column++)
				{
					var frame:b2Body;
					frame = BodyFactory.createBox(5,5,initialX + (column*100), initialY + currentY, _world,_worldScale,"frame",true,null,null,2);	
					frames.push(frame);
				}
				currentY += 80;
			}
			joints = new Array();
			
			// UI elements 
			shuffleButton = new starling.display.Button(AssetsManager.getTexture("shuffle"));
			shuffleButton.x = 700;
			shuffleButton.y = 40;
			shuffleButton.scaleX = 0.8;
			shuffleButton.scaleY = 0.8;
			this.addChild(shuffleButton);
			shuffleButton.addEventListener(starling.events.Event.TRIGGERED, onShuffleTriggered);
			
			// answer box 
			//new MetalWorksMobileTheme();
			var scrollContainer:AnswerBox = new AnswerBox();
			scrollContainer.x = 1050;
			scrollContainer.y = 20;
			scrollContainer.width = 200;
			scrollContainer.height = 800;
			scrollContainer.addEventListener(AnswerItemSelected.ITEMSELECTED, onAnswerSelected);
			var layout:VerticalLayout = new VerticalLayout();
			scrollContainer.layout = layout;
			this.addChild(scrollContainer);
			var xPosition:Number = 0;
			for (var i:int = 0; i < 40; i++)
			{
				var answerItem:AnswerItem = new AnswerItem(80,80,String(i + 1),AssetsManager.getFont().name,70,0xff0000);
				scrollContainer.addChild(answerItem);
			}
			// elementos dinamicos  en la escena
			this.addEventListener(Event.ENTER_FRAME, checkElapsedTime);
			stopTimer.addEventListener(TimerEvent.TIMER, OnStopTimer);
			stopTimer.start();
		}
		
		private function checkElapsedTime(event:Event):void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious);
		}
		
		private function onAnswerSelected(event:AnswerItemSelected):void
		{
			trace("se selecciono el item: " + event.data.id);	
		}
		
		private function onShuffleTriggered(event:Event):void
		{
			shuffleButton.removeEventListener(starling.events.Event.TRIGGERED, onShuffleTriggered);
			if (shuffled)
			{
				shuffled = false;
				hooked = false;
				for(var i:int = 0; i < joints.length; i++)
				{	
					joints[i].GetUserData().remove = true;
				}
				joints.splice(0,joints.length);
				stopTimer.addEventListener(TimerEvent.TIMER, OnStopTimer);
				stopTimer.start();
				timerStopped = false;
			}
			else 
			{
				// instancia los joints 
				for(var i:int = 0; i < balls.length; i++)
				{
					var distanceJoint:b2DistanceJoint = BodyFactory.createDistanceJoint(balls[i],frames[i],_world);
					joints.push(distanceJoint);
				}
				hooked = true;
				shuffled = true;
				shuffleButton.addEventListener(starling.events.Event.TRIGGERED, onShuffleTriggered);
			}
		}
		
		private function OnStopTimer(event:TimerEvent):void
		{
			stopTimer.stop();
			stopTimer.removeEventListener(TimerEvent.TIMER, OnStopTimer);
			timerStopped = true;
			shuffleButton.addEventListener(starling.events.Event.TRIGGERED, onShuffleTriggered);
			//			makeStaticTimer.addEventListener(TimerEvent.TIMER, onMakeStaticTimer);
			//			makeStaticTimer.start();
		}
		
		private function onMakeStaticTimer(event:TimerEvent):void
		{
			makeStaticTimer.stop();
			makeStaticTimer.removeEventListener(TimerEvent.TIMER, onMakeStaticTimer);
			for (var i:int = 0; i < balls.length; i++)
			{
				balls[i].SetType(b2Body.b2_staticBody);
			}
		}
		
		override public function update(event:Event):void
		{
			super.update(event);
			if (!timerStopped)
				checkImpulses();
			if (shuffled)
				manageJoints();
		}
		
		private function manageJoints():void
		{
			if (hooked)
			{
				hooked = false;
			}
			for (var i:int = 0; i < joints.length; i++)
			{
				if (joints[i].GetLength() > 0.05)
					joints[i].SetLength(joints[i].GetLength() * 0.95);
			}
		}
		
		private function checkImpulses():void
		{
			for (var i:int = 0; i < balls.length; i++)
			{
				var randomY:int = Helpers.randomInt(-5,5);
				var randomX:int = Helpers.randomInt(-10, 10);
				balls[i].ApplyImpulse(new b2Vec2(randomX,randomY),balls[i].GetWorldCenter());
			}
		}
	}
}