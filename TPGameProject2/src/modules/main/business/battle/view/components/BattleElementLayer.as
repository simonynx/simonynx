package modules.main.business.battle.view.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import modules.main.business.battle.view.components.element.BattleElement;
	
	import tempest.engine.graphics.avatar.Avatar;

	public class BattleElementLayer extends Sprite
	{
		private var _elements:Vector.<BattleElement>;
		private var _battleGrid:BattleGrid

		private var _lastTime:uint = 0;

		public function BattleElementLayer(battleGrid:BattleGrid)
		{
			super();
			_battleGrid = battleGrid;
			_elements = new Vector.<BattleElement>();
//			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function get elements():Vector.<BattleElement>
		{
			return _elements;
		}

		public function addElement(ele:BattleElement):void
		{
			var pos:Point = _battleGrid.getPixelPos(ele.camp, ele.logicX, ele.logicY);
			ele.x = pos.x;
			ele.y = pos.y;
			this.addChild(ele);
			_elements.push(ele);
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
