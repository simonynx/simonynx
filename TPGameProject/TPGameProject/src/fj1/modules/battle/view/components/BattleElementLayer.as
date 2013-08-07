package fj1.modules.battle.view.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import assets.EmbedRes;
	
	import fj1.modules.battle.constants.BattleCamp;
	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.view.components.element.BattleCharacter;
	import fj1.modules.battle.view.components.element.BattleElement;
	
	import tempest.engine.staticdata.Direction;
	import tempest.engine.staticdata.Status;
	import tempest.ui.components.TComponent;
	
	public class BattleElementLayer extends TComponent
	{
		private var _elements:Vector.<BattleElement>;

		private var _posArray:Array;
		private var _lastTime:uint = 0;

		public function BattleElementLayer()
		{
			_posArray = [];
			super(null, (new EmbedRes.battleGrid()));
			initPos(BattleCamp.LEFT, "left", _proxy);
			initPos(BattleCamp.RIGHT, "right", _proxy);
			_elements = new Vector.<BattleElement>();
		}
		
		public function get elements():Vector.<BattleElement>
		{
			return _elements;
		}

		public function addElement(ele:BattleElement):void
		{
			switch(ele.camp)
			{
				case BattleConst.LEFT:
				{
					BattleCharacter(ele).playTo(Status.STAND, Direction.EAST);
					break;
				}
				case BattleConst.RIGHT:
				{
					BattleCharacter(ele).playTo(Status.STAND, Direction.WEST);
					break;
				}	
				default:
				{
					break;
				}
			} 
			var pos:Point = getPixelPos(ele.camp, ele.logicX, ele.logicY);
			ele.x = pos.x;
			ele.y = pos.y;
			
			this.addChild(ele);
			_elements.push(ele);
		}
		
		private function initPos(camp:int, campName:String, mc:*):void
		{
			var fields:Array = [];
			for (var y:int = 0; y < BattleConst.BATTLE_GRID_HEIGHT; ++y)
			{
				fields[y] = [];
				for (var x:int = 0; x < BattleConst.BATTLE_GRID_WIDTH; ++x)
				{
					var posMC:MovieClip = mc.getChildByName(campName + "_" + y + "_" + x) as MovieClip;
					fields[y][x] = new Point(posMC.x, posMC.y);
				}
			}
			_posArray[camp] = fields;
		}
		
		public function getPixelPos(camp:int, logicX:int, logicY:int):Point
		{
			return _posArray[camp][logicY][logicX];
		}
		
		public function removeElement(guid:int):void
		{
			for (var i:int = 0; i < _elements.length; ++i)
			{
				var ele:BattleElement = _elements[i];
				if (ele.guid == guid)
				{
					_elements.splice(i, 1);
					this.removeChild(ele);
					return;
				}
			}
		}

		public function getElement(guid:int):BattleElement
		{
			for (var i:int = 0; i < _elements.length; ++i)
			{
				var ele:BattleElement = _elements[i];
				if (ele.guid == guid)
				{
					return ele;
				}
			}
			return null;
		}

		public function getElementByLogicPos(logicX:int, logicY:int):BattleElement
		{
			for (var i:int = 0; i < _elements.length; ++i)
			{
				var ele:BattleElement = _elements[i];
				if (ele.logicX == logicX && ele.logicY == logicY)
				{
					return ele;
				}
			}
			return null;
		}

		public function removeAllElements():void
		{
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
			_elements = new Vector.<BattleElement>();
		}

		private function onEnterFrame(event:Event):void
		{
			var nowTime:Number = new Date().getTime();
			var diff:uint = 0;
			if (_lastTime != 0)
			{
				diff = nowTime - _lastTime;
			}
			_lastTime = nowTime;
			for each (var ele:BattleElement in _elements)
			{
				ele.update(diff);
			}
		}

	}
}
