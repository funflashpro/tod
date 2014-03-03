package 
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.WheelMenu;
	import com.bit101.components.Window;
	import com.demonsters.debugger.MonsterDebugger;
	import com.golodyuk.DataProvider;
	import com.golodyuk.Game;
	import com.golodyuk.Game.BotBase;
	import com.golodyuk.Game.BotModel;
	import com.golodyuk.Game.GameController;
	import com.golodyuk.Game.GameModel;
	import com.golodyuk.menu.FriendBox;
	import com.golodyuk.menu.TopBar;
	import com.golodyuk.Model;
	import com.golodyuk.Player;
	import com.golodyuk.Social;
	import com.golodyuk.SocketProvider;
	import com.golodyuk.SoundTower;
	import com.golodyuk.window.WindowManager;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Security;
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	
	/**
	 * Добавляет старлинг на сцену.
	 * @author temudjin
	 */
	
	[SWF(width = "760", height = "760", backgroundColor = "0xCCEEFF", frameRate = "30")]
	[Frame(factoryClass = "Preloader")]
	public class Main extends Sprite 
	{
		public static var instance:Main;
		
		public var removeLoader:Function;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// entry point
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			
			instance = this;
			
			//Security.loadPolicyFile("http://tower.myco-st.ru/crossdomain.xml");
			//Security.allowDomain("*");
			//stage.dispatchEvent(new Event(Event.DEACTIVATE));
			//stage.dispatchEvent(new Event(Event.ACTIVATE)); 
			
			
			MonsterDebugger.initialize(stage);
			
			// social.init -> dataprovider.register -> socketprovider.init -> start
			Social.init(stage);
		}
		
		public static function ready():void
		{
			if (Model.isSocialLoaded && Model.isDataLoaded)
				instance.start();
		}
		
		public static function readySocketServer():void
		{
			if (Model.isSocketConnected)
			{
				if (Model.arsenal != null) Model.arsenal.onSocketConnected();
			}
		}

		/**
		 * Вход в игру - загрузили все данные
		 */
		public function start():void
		{
			//CONFIG::release{
				//removeLoader();
			//}
			Preloader.remove();
			
			createScreens();
			
			// debug info
			createInteface(); 
			
			function createScreens():void
			{
				var viewPortRectangle:Rectangle = new Rectangle();
				viewPortRectangle.width = 760;
				viewPortRectangle.height = 760;
				
				Model.starling = new Starling(Game, stage, viewPortRectangle);
				Model.starling.start();
				
				stage.addEventListener(ResizeEvent.RESIZE, onResize);
			}
			
			function onResize(e:Event):void 
			{
				var view:Rectangle = new Rectangle();
				view.width = stage.stageWidth;
				view.height = stage.stageHeight;
				Model.starling.viewPort = view;
			}
		}
		

		public function createInteface():void
		{
			//var testWindow:Window =  new Window(stage, 100, 100, "test");
			//var removeTableButton:PushButton = new PushButton(testWindow, 0, 0, "remove table",
				//function(e:MouseEvent):void	
				//{
					//SocketProvider.remove();
				//});
				
			//var call:PushButton = new PushButton(testWindow, 0, 0, "call action",
				//function(e:MouseEvent):void
				//{
					//Game.instance.nextWindow();
					//
					//trace("\ncount: " + Player.counter);
					//trace("action: " + Player.action);
					//trace("gold: " + Player.gold);
				//});
			
			// speed window
			//speedWindow = new Window(stage, 600, 300, "speed contoroller");
			//speedWindow.height = 300;
			//var labels:Array = [];
			//for (var i:int = 0; i < 8; ++i)
			//{
			//var speed: Label = new Label(speedWindow, 25, i*25, BotModel.features[BotModel.SKELET + i].speed);
			//labels.push(speed);
			//
			//var plusSpeed:PushButton = new PushButton(speedWindow, 50, i*25, "+",
				//function(e:MouseEvent):void
				//{
					//BotModel.features[BotModel.SKELET + int(e.target.name)].speed += .1;
					//labels[int(e.target.name)].text = BotModel.features[BotModel.SKELET + int(e.target.name)].speed.toFixed(2).toString();
				//});
			//plusSpeed.name = i.toString();
			//plusSpeed.width = 15;
			//
			//var minSpeed:PushButton = new PushButton(speedWindow, 5, i*25, "-",
				//function(e:MouseEvent):void
				//{
					//if (BotModel.features[BotModel.SKELET + int(e.target.name)].speed <= .1) return;
					//
					//BotModel.features[BotModel.SKELET + int(e.target.name)].speed -= .1;
					//labels[int(e.target.name)].text = BotModel.features[BotModel.SKELET + int(e.target.name)].speed.toFixed(2).toString();
				//});
			//minSpeed.name = i.toString();	
			//minSpeed.width = 15;
			//}
			
			
			/*
			routeWindow = new Window(stage, 0, 0, "ROUTES");
			routeWindow.height = 400;
			var texts:Array = [];
			for (var route:* in GameModel.routes)
			{
				var a:Text = new Text(routeWindow, 0, route * 20, GameModel.routes[route].pos);
				a.addEventListener(Event.CHANGE,
					function(e:Event):void
					{
						GameModel.routes[int(e.target.name)].pos = texts[int(e.target.name)].text;
						trace("change");
					});
				a.name = route;
				texts.push(a);
			}
			var rx:Text = new Text(routeWindow, 0, 340, GameModel.respawn.x.toString());
				rx.addEventListener(Event.CHANGE,
					function(e:Event):void
					{
						GameModel.respawn.x = int(rx.text);
						//trace("change");
					});
			var ry:Text = new Text(routeWindow, 0, 360, GameModel.respawn.y.toString());
				ry.addEventListener(Event.CHANGE,
					function(e:Event):void
					{
						GameModel.respawn.y = int(ry.text);
						//trace("change");
					});
			*/
			
			// инфо-меню - тест ------- удалить после
			//menu = new Window(stage, 600, 50, "STAT:");
			//menu.height = 130;
			//towerLabel = new Label(menu, 2, 20, "TOWERS:");
			//enemiesLabel = new Label(menu, 2, 30, "ENEMIES:");
			//dLabel = new Label(menu, 2, 50, "");
			//distLabel = new Label(menu, 2, 60, "");
			//levelLabel = new Label(menu, 2, 70, "");
			//speedLabel = new Label(menu, 2, 80, "");
			//inLabel = new Label(menu, 2, 90, "");
			//var del:PushButton = new PushButton(menu, 0, 0, "del",
				//function (e:MouseEvent):void
				//{
					//SocketProvider.remove();
				//});
			//
			//var arr:Array = [];
			//arr[0] = 0;
			//arr[1] = 0;
			//arr[2] = -1;
			//var enemyWindow:Window = new Window(stage, 600, 200, "ADD NEW ENEMY");
			//enemyWindow.height = 300;
			//var skeletButton:PushButton = new PushButton(enemyWindow, 0, 0, "1.skelet", function(e:MouseEvent):void { arr[1] = 0; GameController.add(arr); } );
			//skeletButton.width = 50;
			//var ghostButton:PushButton = new PushButton(enemyWindow, 50, 0, "2.ghost", function(e:MouseEvent):void {arr[1] = 1; GameController.add(arr); } );
			//ghostButton.width = 50;
			//var ufoButton:PushButton = new PushButton(enemyWindow, 0, 20, "3.ufo", function(e:MouseEvent):void { arr[1] = 2; GameController.add(arr); } );
			//ufoButton.width = 50;
			//var orkButton:PushButton = new PushButton(enemyWindow, 50, 20, "4.ork", function(e:MouseEvent):void { arr[1] = 3;GameController.add(arr); } );
			//orkButton.width = 50;
			//var paladinButton:PushButton = new PushButton(enemyWindow, 0, 40, "5.paladin", function(e:MouseEvent):void { arr[1] = 4;GameController.add(arr); } );
			//paladinButton.width = 50;
			//var trollButton:PushButton = new PushButton(enemyWindow, 50, 40, "6.troll", function(e:MouseEvent):void { arr[1] = 5;GameController.add(arr); } );
			//trollButton.width = 50;
			//var valkButton:PushButton = new PushButton(enemyWindow, 0, 60, "7.valkyrie", function(e:MouseEvent):void { arr[1] = 6;GameController.add(arr); } );
			//valkButton.width = 50;
			//var dragonButton:PushButton = new PushButton(enemyWindow, 50, 60, "8.dragon", function(e:MouseEvent):void { arr[1] = 7;GameController.add(arr); } );
			//dragonButton.width = 50;
		}
		
		
		// ---------------- test ------------------------
		//public static var menu:Window;
		//public static var towerLabel:Label;
		//public static var enemiesLabel:Label;
		//public static var baseLabel:Label;
		//
		//
		//public static var routeWindow:Window;
		//
		//public static var speedWindow:Window;
		//public static var speed:Label;
		//
		//public static var dLabel:Label;
		//public static var distLabel:Label;
		//public static var levelLabel:Label;
		//public static var speedLabel:Label;
		//public static var inLabel:Label;
		//------------------ delete this -----------------
		
	}
	
}