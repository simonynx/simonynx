package fj1.modules.battle.view.components
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import fj1.common.GameInstance;
	import fj1.modules.battle.model.entity.BattlePlayer;
	import fj1.modules.battle.model.vo.BattleInfo;
	import fj1.modules.battle.model.vo.BattlePlayerInfo;
	import fj1.modules.battle.model.vo.BattleSceneTemplate;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	import fj1.modules.battle.view.components.element.BattleElement;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.ListenerManager;
	
	import tpe.manager.FilePathManager;

	public class BattleScene
	{
		public var container:Sprite = new Sprite();

		private var _info:BattleSceneTemplate;
		/**
		 * 战斗地图层 
		 */
		private var _bkImage:BackGroundImage;
		/**
		 * 场景对象层
		 */
		private var _elementLayer:BattleElementLayer;
		/**
		 * 战斗UI层 
		 */		
		public var battleUI:BattleUILayer = new BattleUILayer();
	
		private var _listenerManager:ListenerManager;

		public var sceneRender:BattleSceneRender; //场景渲染
		
		private static const log:ILogger = TLog.getLogger(BattleScene);
		
		public function BattleScene()
		{
			_bkImage = new BackGroundImage(container.width, container.height);
			container.addChild(_bkImage);
			
			_elementLayer = new BattleElementLayer();
			container.addChild(_elementLayer);
			
			sceneRender = new BattleSceneRender(this);
			_listenerManager = new ListenerManager();
		}

		public function get elementLayer():BattleElementLayer
		{
			return _elementLayer;
		}

		/**
		 * 进入场景
		 *
		 */
		public function enterScene(battleInfo:BattleInfo):void
		{
			sceneRender.stopRender();
			var mapId:int = battleInfo.mapId;
			var info:BattleSceneTemplate = new BattleSceneTemplate();
			info.id = 1;
			info.bgPath = FilePathManager.getPath("scene/battlemap.jpg");
			info.bgPathSmall = FilePathManager.getPath("scene/" + 2 + "/thumb.jpg");
			reset(info); //重置战斗场景
			initScene(battleInfo.playerInfoArr);
			sceneRender.startRender(true);
		}

		/**
		 * 初始化战斗角色
		 * @param info
		 *
		 */
		private function initScene(playerInfoArr:Vector.<BattlePlayerInfo>):void
		{
			for each (var bInfo:BattlePlayerInfo in playerInfoArr)
			{
				var player:BattlePlayer = createBattlePlayer(bInfo);
				var bc:BattleCharacter = new BattleCharacter(player.guid);
				bc.data = player;
				addElement(bc);
			}
			_listenerManager.addEventListener(GameInstance.app.sceneContainer, Event.RESIZE, resizeScene);
			this.resizeScene(null);
		}

		private function createBattlePlayer(playerInfo:BattlePlayerInfo):BattlePlayer
		{
			var player:BattlePlayer = new BattlePlayer(playerInfo.id);
			player.name = playerInfo.name;
			player.hp = 50;
			player.maxHp = 50;
			player.camp = playerInfo.camp;
			player.logicX = playerInfo.logicX;
			player.logicY = playerInfo.logicY;
			player.modelId = playerInfo.modelId;
			return player;
		}
		
		/**
		 * 添加场景特效
		 * @param ani 动画
		 * @param fg 是否前景
		 */
		public function addEffect(displayObj:DisplayObject, fg:Boolean = true):void
		{
			_elementLayer.addChild(displayObj);
		}

		private function resizeScene(event:Event):void
		{
			var width:int = GameInstance.app.sceneContainer.width;
			var height:int = GameInstance.app.sceneContainer.height;
			_bkImage.invalidateSize();
			_elementLayer.x = (width - _elementLayer.width) / 2;
			_elementLayer.y = (height - _elementLayer.height) / 2;
		}

		/**
		 * 测试
		 * @param guid
		 * @param camp
		 * @param logicX
		 * @param logicY
		 * @param name
		 * @param modelId
		 * @param battleInfo
		 *
		 */
		private function addCharacter(guid:int, camp:int, logicX:int, logicY:int, name:String, modelId:int, battleInfo:BattleInfo):void
		{
			var player:BattlePlayer = new BattlePlayer(guid);
			player.name = name;
			player.hp = 50;
			player.maxHp = 50;
			player.camp = camp;
			player.logicX = logicX;
			player.logicY = logicY;
			player.modelId = modelId;
			var char:BattleCharacter = new BattleCharacter(player.guid);
			char.data = player;
		}

		private function createShape(width:Number, height:Number):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.drawRect(0, 0, width, height);
			return shape;
		}

		/**
		 * 获取逻辑坐标对应的像素坐标
		 * @param camp
		 * @param logicX
		 * @param logicY
		 * @return
		 *
		 */
		public function getPixelPos(camp:int, logicX:int, logicY:int):Point
		{
			return _elementLayer.getPixelPos(camp, logicX, logicY);
		}

		public function get sceneId():int
		{
			return _info.id;
		}

		public function get info():BattleSceneTemplate
		{
			return _info;
		}

		/**
		 * 重置战斗场景
		 * @param info
		 *
		 */
		public function reset(info:BattleSceneTemplate):void
		{
			_info = info;
			_bkImage.load(_info.bgPath, _info.bgPathSmall);
			_elementLayer.removeAllElements();
		}

		public function addElement(ele:BattleElement):void
		{
			_elementLayer.addElement(ele);
		}

		public function removeElement(guid:int):void
		{
			_elementLayer.removeElement(guid);
		}

		public function getElement(guid:int):BattleElement
		{
			return _elementLayer.getElement(guid);
		}

		public function getElementByLogicPos(logicX:int, logicY:int):BattleElement
		{
			return _elementLayer.getElementByLogicPos(logicX, logicY);
		}

		public function removeAllElements():void
		{
			_elementLayer.removeAllElements();
		}

		public function dispose():void
		{
			removeAllElements();
			sceneRender.stopRender();
			_listenerManager.removeAll();
		}
	}
}
