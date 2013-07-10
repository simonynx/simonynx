package modules.main.business.battle.view.components
{

	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import common.GameInstance;
	import common.RslMananger;
	import common.constants.ResPath;
	import common.constants.ResourceLib;
	
	import modules.main.business.battle.constants.BattleCamp;
	import modules.main.business.battle.constants.BattleConst;
	import modules.main.business.battle.model.entity.BattlePlayer;
	import modules.main.business.battle.model.vo.BattleInfo;
	import modules.main.business.battle.model.vo.BattleSceneTemplate;
	import modules.main.business.battle.view.components.element.BattleCharacter;
	import modules.main.business.battle.view.components.element.BattleElement;
	
	import tempest.ui.components.TButton;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TLayoutContainer;
	
	import tpe.manager.FilePathManager;

	public class BattleScene
	{
		public var container:Sprite = new Sprite();
		
		private var _info:BattleSceneTemplate;

		private var _bkImage:BackGroundImage;
		/**
		 * 保存逻辑坐标和像素坐标的映射关系
		 */
		private var _battleGrid:BattleGrid;

		/**
		 * 场景对象层
		 */
		private var _elementLayer:BattleElementLayer;
		
		public var sceneRender:BattleSceneRender; //场景渲染

		public function BattleScene()
		{
			_battleGrid = new BattleGrid();
//			super({horizontalCenter: 0, verticalCenter: 0}, createShape(BattleConst.BATTLE_SCENE_WIDTH, BattleConst.BATTLE_SCENE_HEIGHT));
			_bkImage = new BackGroundImage(container.width, container.height); 
			container.addChild(_bkImage);
			_elementLayer = new BattleElementLayer(_battleGrid);
			container.addChild(_elementLayer);
			this.sceneRender = new BattleSceneRender(this);
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
			/////////
			var mapId:int = battleInfo.mapId;
			var info:BattleSceneTemplate = new BattleSceneTemplate();
			info.id = 1;
			info.bgPath = FilePathManager.getPath("scene/" + 2 + "/thumb.jpg");
			info.bgPathSmall = FilePathManager.getPath("scene/" + 2 + "/thumb.jpg");
			reset(info); //重置战斗场景
			initScene(info);
			sceneRender.startRender(true);
		}
		
		/**
		 * 初始化战斗角色
		 * @param info
		 *
		 */
		private function initScene(info:BattleSceneTemplate):void
		{
			addCharacter(1, BattleCamp.LEFT, 0, 0, "player1", 110011);
			addCharacter(2, BattleCamp.LEFT, 1, 0, "player2", 110011);
			addCharacter(3, BattleCamp.LEFT, 0, 1, "player3", 110011);
			addCharacter(4, BattleCamp.LEFT, 1, 1, "player4", 110011);
			addCharacter(5, BattleCamp.LEFT, 0, 2, "player5", 110011);
			addCharacter(6, BattleCamp.LEFT, 1, 2, "player6", 110011);
			addCharacter(7, BattleCamp.RIGHT, 0, 0, "player7", 110011);
			addCharacter(8, BattleCamp.RIGHT, 1, 0, "player8", 110011);
			addCharacter(9, BattleCamp.RIGHT, 0, 1, "player9", 110011);
			addCharacter(10, BattleCamp.RIGHT, 1, 1, "player10", 110011);
			addCharacter(11, BattleCamp.RIGHT, 0, 2, "player11", 110011);
			addCharacter(12, BattleCamp.RIGHT, 1, 2, "player12", 110011);
			GameInstance.app.sceneContainer.addEventListener(Event.RESIZE, resizeScene);
			this.resizeScene(null);
		}
		
		private function resizeScene(event:Event):void
		{
			var width:int = GameInstance.app.sceneContainer.width;
			var height:int = GameInstance.app.sceneContainer.height;
			_bkImage.setSize(width, height);
		}		
		
		private function addCharacter(guid:int, camp:int, logicX:int, logicY:int, name:String, modelId:int):void
		{
			var player:BattlePlayer = new BattlePlayer(guid);
			player.name = name;
			player.camp = camp;
			player.logicX = logicX;
			player.logicY = logicY;
			player.modelId = modelId;
//			battleModel.addPlayer(player);
			var char:BattleCharacter = new BattleCharacter(player.guid);
			char.data = player;
			addElement(char);
		}

		private function createShape(width:Number, height:Number):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.drawRect(0, 0, width, height);
			return shape;
		}

		public function get battleGrid():BattleGrid
		{
			return _battleGrid;
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
			return _battleGrid.getPixelPos(camp, logicX, logicY);
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
			
		}

	}
}
