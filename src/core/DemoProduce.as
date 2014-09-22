package core
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Managers.AssetsManager;
	
	import core.BodyFactory;
	import core.Game;
	import core.Helpers;
	import core.PhysicsState;
	
	import enumerations.ProduceInteractionStates;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class DemoProduce extends PhysicsState
	{
		// variables privadas 
		private var stopTimer:Timer = new Timer(2000);
		private var timerStopped:Boolean = true;
		private var background:Image;
		private var shuffleButton:starling.display.Button;
		
		// vectors 
		private var tenFrame:Vector.<b2Body>;
		private var fiveFrame:Vector.<b2Body>;
		private var oneFrame:b2Body;
		private var inBoxFrames:Vector.<b2Body>;
		private var inBoxSpheres:int = 0;
		private var tenBalls:Vector.<b2Body>;
		private var fiveBalls:Vector.<b2Body>;
		private var oneBall:b2Body;
		private var inBoxBalls:Vector.<b2Body>;
		
		// touch 
		private var touch:Touch;
		
		//touchable quads 
		private var tenFramesQuad:Quad;
		private var fiveFramesQuad:Quad;
		private var oneFrameQuad:Quad;
		
		// flags 
		private var interactionState:String = ProduceInteractionStates.IDLE;
		
		// joints 
		private var mouseJoints:Vector.<b2MouseJoint>;
		private var inBoxJoints:Vector.<b2DistanceJoint>;
		
		public function DemoProduce(game:Game)
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
			var quad1:Quad = new Quad(10, stage.stageHeight,0xff0000);
			this.addChild(quad1);
			var quad2:Quad = new Quad(10, stage.stageHeight,0xff0000);
			this.addChild(quad2);
			var quad3:Quad = new Quad(stage.stageWidth, 10,0xff0000);
			this.addChild(quad3);
			var quad4:Quad = new Quad(stage.stageWidth, 10,0xff0000);
			this.addChild(quad4);
			BodyFactory.createBox(stage.stageWidth, 10, stage.stageWidth / 2, stage.stageHeight - 10, _world,_worldScale,"floor",true,null,null,null);
			BodyFactory.createBox(10, stage.stageHeight, stage.stageWidth - 10, stage.stageHeight / 2, _world,_worldScale,"leftWall",true,quad1,null,null);
			BodyFactory.createBox(10, stage.stageHeight, 10,stage.stageHeight / 2, _world,_worldScale,"rightWall",true,quad2,null,null);
			BodyFactory.createBox(stage.stageWidth, 10, stage.stageWidth / 2, 10, _world,_worldScale,"ceiling",true,quad3,null,null);
			BodyFactory.createBox(10,80, 680,100, _world,_worldScale,"separator",true,null,null,null);
			BodyFactory.createBox(10,100,500,80, _world,_worldScale,"shuffleY",true,null,null,null);
			BodyFactory.createBox(80,10,590,170, _world,_worldScale,"suffleX",true,null,null,null);
			BodyFactory.createBox(stage.stageWidth, 10, stage.stageWidth / 2, stage.stageHeight - 300, _world,_worldScale,"resourceBox",true,quad4,null,2); // resource box boundaries 
			
			// elementos estaticos 
			// 5 frames 
			var initialX:int = 50;
			var initialY:int = stage.stageHeight - 140;
			var currentY:int = 0;
			tenFrame = new Vector.<b2Body>();
			for (var row:int = 0; row < 2; row++)
			{
				if ( row > 0 && row % 2 == 0)
				{
					currentY += 40;
				}
				for (var column:int = 0; column < 5; column++)
				{
					var frame:b2Body;
					frame = BodyFactory.createBox(5,5,initialX + (column*60), initialY + currentY,_world,_worldScale,"frame",true,null,null,2);
					tenFrame.push(frame);
				}
				currentY += 60;
			}
			
			// 5 frame 
			initialX = 600;
			initialY = stage.stageHeight - 100;
			currentY = 0;
			fiveFrame = new Vector.<b2Body>();
			for (var column:int = 0; column < 5; column++)
			{
				var frame:b2Body;
				frame = BodyFactory.createBox(5,5,initialX + (column*80), initialY + currentY,_world,_worldScale,"frame",true,null,null,null);
				fiveFrame.push(frame);
			}
			currentY += 80;
			
			// individual frame 
			oneFrame = BodyFactory.createBox(5,5,1170, stage.stageHeight - 100,_world,_worldScale,"frame",true,null,null,null);
			
			inBoxJoints = new Vector.<b2DistanceJoint>();
			
			tenBalls = new Vector.<b2Body>();
			populateTenFrame();
			fiveBalls = new Vector.<b2Body>();
			pupulateFiveFrame();
			createOneBall();
			
			// touchable quads 
			tenFramesQuad = new Quad(500,500,0xfffff);
			fiveFramesQuad = new Quad(500,150,0xfffff);
			oneFrameQuad = new Quad(100,100,0xfffff);
			tenFramesQuad.x = 20;
			tenFramesQuad.y = 610;
			tenFramesQuad.visible = false;
			this.addChild(tenFramesQuad);
			fiveFramesQuad.x = 546;
			fiveFramesQuad.y = 620;
			fiveFramesQuad.visible = false;
			this.addChild(fiveFramesQuad);
			oneFrameQuad.x = 1118;
			oneFrameQuad.y = 648;
			oneFrameQuad.visible = false;
			this.addChild(oneFrameQuad);
			mouseJoints = new Vector.<b2MouseJoint>();
			
			// UI elements 
//			okButton = new starling.display.Button(AssetsManager.getTexture("shuffle"));
//			okButton.x = 700;
//			okButton.y = 40;
//			okButton.scaleX = 0.8;
//			okButton.scaleY = 0.8;
//			this.addChild(okButton);
//			okButton.addEventListener(starling.events.Event.TRIGGERED, onOkTriggered);
			// numero aleatorio con la cantidad pedida
			var randomNumber:int = Helpers.randomInt(1,40);
			var testNumber:TextField = new TextField(200,200,String(randomNumber),AssetsManager.getFont().name,90,0xff0000);
			testNumber.x = 500;
			testNumber.y = 10;
			this.addChild(testNumber);
			inBoxBalls = new Vector.<b2Body>();
			
			// elementos dinamicos  en la escena 
			this.addEventListener(starling.events.TouchEvent.TOUCH, onTouchEvent);
		}
		
		private function onTouchEvent(event:TouchEvent)
		{
			touch = event.getTouch(this);
			if (touch != null)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
//					trace("touch event X: " + touch.globalX);	
//					trace("touch event Y: " + touch.globalY);
					if (tenFramesQuad.bounds.contains(touch.globalX, touch.globalY))
					{
						for (var i:int = 0 ; i < tenBalls.length ; i++)
						{
							tenBalls[i].SetType(b2Body.b2_dynamicBody);
							tenBalls[i].SetAwake(true);
						}
						var mouseJoint:b2MouseJoint = BodyFactory.createMouseJoint(tenBalls[3],Helpers.mouseToWorld(touch.globalX,touch.globalY,_worldScale),_world);
						mouseJoints.push(mouseJoint);
						interactionState = ProduceInteractionStates.DRAGGINGTENBALLS;
					}
					else if (fiveFramesQuad.bounds.contains(touch.globalX, touch.globalY))
					{
						//trace("click on fiveframes");
						if (fiveFramesQuad.bounds.contains(touch.globalX, touch.globalY))
						{
							for (var i:int = 0 ; i < fiveBalls.length ; i++)
							{
								fiveBalls[i].SetType(b2Body.b2_dynamicBody);
								fiveBalls[i].SetAwake(true);
//								var mouseJoint:b2MouseJoint = BodyFactory.createMouseJoint(fiveBalls[i],Helpers.mouseToWorld(touch.globalX,touch.globalY,_worldScale),_world);
//								mouseJoints.push(mouseJoint);
							}
							
							var mouseJoint:b2MouseJoint = BodyFactory.createMouseJoint(fiveBalls[2],Helpers.mouseToWorld(touch.globalX,touch.globalY,_worldScale),_world);
							mouseJoints.push(mouseJoint);
							
							interactionState = ProduceInteractionStates.DRAGGINGFIVEBALLS;
						}
						
					}
					else if (oneFrameQuad.bounds.contains(touch.globalX, touch.globalY))
					{
						//trace("click on oneframes");
						if (oneFrameQuad.bounds.contains(touch.globalX, touch.globalY))
						{
							
							oneBall.SetType(b2Body.b2_dynamicBody);
							oneBall.SetAwake(true);
							var mouseJoint:b2MouseJoint = BodyFactory.createMouseJoint(oneBall,Helpers.mouseToWorld(touch.globalX,touch.globalY,_worldScale),_world);
							mouseJoints.push(mouseJoint);
							interactionState = ProduceInteractionStates.DRAGGINGONEBALL;
						}
					}
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
					for (var i:int = 0; i < mouseJoints.length; i++)
					{
						mouseJoints[i].GetUserData().remove = true;
					}
					mouseJoints.splice(0, mouseJoints.length);
					
					if (interactionState == ProduceInteractionStates.DRAGGINGTENBALLS)
					{
						//trace("finalizo el touch en: " + touch.globalX);
						// borra todos los mouse joints 
						
						for (var i:int = 0; i < tenBalls.length; i++)
						{
							var filter:b2FilterData = new b2FilterData();
							filter.categoryBits = 2;
							tenBalls[i].GetFixtureList().SetFilterData(filter);
						}
						// copia el arreglo a inbox
						for (var i:int = 0; i < tenBalls.length; i++)
						{
							inBoxBalls.push(tenBalls[i]);
						}
						tenBalls.splice(0, tenBalls.length);
						populateTenFrame();
					}
					else if (interactionState == ProduceInteractionStates.DRAGGINGFIVEBALLS)
					{
						for (var i:int = 0; i < fiveBalls.length; i++)
						{
							var filter:b2FilterData = new b2FilterData();
							filter.categoryBits = 2;
							fiveBalls[i].GetFixtureList().SetFilterData(filter);
						}
						// copia el arreglo a inbox
						for (var i:int = 0; i < fiveBalls.length; i++)
						{
							inBoxBalls.push(fiveBalls[i]);
						}
						fiveBalls.splice(0, fiveBalls.length);
						pupulateFiveFrame();
					}
					else if (interactionState == ProduceInteractionStates.DRAGGINGONEBALL)
					{
						
						var filter:b2FilterData = new b2FilterData();
						filter.categoryBits = 2;
						oneBall.GetFixtureList().SetFilterData(filter);
						inBoxBalls.push(oneBall);
						createOneBall();
					}
					interactionState = ProduceInteractionStates.IDLE;
					trace("numero de esferas dentro: " + inBoxBalls.length);
				}
				else if (touch.phase == TouchPhase.MOVED)
				{
					
					for (var i:int = 0; i < mouseJoints.length; i++)
					{
						mouseJoints[i].SetTarget(Helpers.mouseToWorld(touch.globalX, touch.globalY,_worldScale));
					}
				}
			}
		}
		
		override public function update(event:Event):void
		{
			super.update(event);
		}
		
		private function populateTenFrame():void
		{
			var SpheresColor:uint = Helpers.getRandomColor(Color.RED,0.8, 0.2);
			var filter = new ColorMatrixFilter();
			filter.reset();
			filter.adjustSaturation(Helpers.randomInt(0,3));
//			var obj:Object = {val: vars.startValue%7D;
//					vars.val = vars.endValue;
//					vars.object.filter = new ColorMatrixFilter();
//					vars.onUpdate = function():void
//					{
//						vars.object.filter.reset();
//						vars.object.filter.adjustSaturation(obj.val);
//					};
//					Starling.juggler.tween(obj, vars.duration, vars);
				
			for (var i:int = 0; i < tenFrame.length; i++)
			{
				//var SphereTexture:Image = AssetsManager.createNewImmage("Bubble");
				var SphereTexture:Image = new Image(AssetsManager.getAtlas().getTexture("Fruta1"));
				SphereTexture.scaleX = 2;
				SphereTexture.scaleY = 2;
				SphereTexture.color = SpheresColor;
				SphereTexture.filter = filter;
				this.addChild(SphereTexture);
				var body:b2Body = BodyFactory.createSphere(35,tenFrame[i].GetPosition().x * _worldScale,tenFrame[i].GetPosition().y * _worldScale, _world, _worldScale, "sphere",true,SphereTexture,4,null); 
				tenBalls.push(body);
			}
			// establece un joint entre cada esfera 
			for (var i:int = 0; i < 4; i++)
			{
				var ballJoint:b2DistanceJoint = BodyFactory.createDistanceJoint(tenBalls[i], tenBalls[i+1],_world);
				ballJoint.SetLength(2);
			}
			
			for (var i:int = 5; i < 9; i++)
			{
				var ballJoint:b2DistanceJoint = BodyFactory.createDistanceJoint(tenBalls[i], tenBalls[i+1],_world);
				ballJoint.SetLength(2);
			}
			var ball_16Joint:b2DistanceJoint = BodyFactory.createDistanceJoint(tenBalls[0], tenBalls[5],_world);
			ball_16Joint.SetLength(2);
			var ball_50Joint:b2DistanceJoint = BodyFactory.createDistanceJoint(tenBalls[4], tenBalls[9],_world);
			ball_50Joint.SetLength(2);
		}
		
		private function pupulateFiveFrame():void
		{
			for (var i:int = 0; i < fiveFrame.length; i++)
			{
				var SphereTexture:Image = new Image(AssetsManager.getAtlas().getTexture("Fruta1"));
				SphereTexture.scaleX = 2;
				SphereTexture.scaleY = 2;
				SphereTexture.color = Color.BLUE;
				this.addChild(SphereTexture);
				var body:b2Body = BodyFactory.createSphere(35,fiveFrame[i].GetPosition().x * _worldScale,fiveFrame[i].GetPosition().y * _worldScale, _world, _worldScale, "sphere",true,SphereTexture,4,null); 	
				fiveBalls.push(body);
			}
			// establece un joint entre cada esfera 
			for (var i:int = 0; i < (fiveBalls.length - 1); i++)
			{
				var ballJoint:b2DistanceJoint = BodyFactory.createDistanceJoint(fiveBalls[i], fiveBalls[i+1],_world);
				ballJoint.SetLength(2);
			}
		}
		
		private function createOneBall():void 
		{
			var SphereTexture:Image = new Image(AssetsManager.getAtlas().getTexture("Fruta1"));
			SphereTexture.scaleX = 2;
			SphereTexture.scaleY = 2;
			SphereTexture.color = Color.YELLOW;
			this.addChild(SphereTexture);
			oneBall = BodyFactory.createSphere(35,oneFrame.GetPosition().x * _worldScale,oneFrame.GetPosition().y * _worldScale, _world, _worldScale, "sphere",true,SphereTexture,4,null); 
		}
	}
}