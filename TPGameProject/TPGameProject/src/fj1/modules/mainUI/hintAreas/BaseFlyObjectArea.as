package fj1.modules.mainUI.hintAreas
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.components.TComponent;

	public class BaseFlyObjectArea extends TComponent
	{
		protected static const MOVE_DELAY:Number = 50;
		protected static const MOVE_TIME:Number = 0.5;

		protected var objectList:Vector.<DisplayObject>;
		protected var _maxLen:int;
		private var updateTimer:TimerData;
		protected var _moveDelay:int; //移动触发间隔
		protected var _moveTime:Number;
		protected var _parent:DisplayObjectContainer;

		public function BaseFlyObjectArea(parent:DisplayObjectContainer, constraints:Object, width:Number, height:Number, maxLen:int = 5)
		{
			_parent = parent;
			var shape:Sprite = new Sprite();
			shape.graphics.drawRect(0, 0, width, height);
			super(constraints, shape);
			objectList = new Vector.<DisplayObject>();
			_maxLen = maxLen;
			moveDelay = MOVE_DELAY;
			moveTime = MOVE_TIME;
		}

		/**
		 * 文本向上移动一行，需要耗费的时间(文本高度全部相同)
		 * @param value
		 *
		 */
		public function set moveTime(value:Number):void
		{
			_moveTime = value;
		}

		public function set moveDelay(value:int):void
		{
			_moveDelay = value;
			if (!updateTimer)
			{
				updateTimer = TimerManager.createNormalTimer(_moveDelay, 0, onUpdate, null, null, null, false);
			}
			else
			{
				updateTimer.delay = _moveDelay;
			}
		}

		private function onUpdate():void
		{
			if (objectList.length == 0)
				return;
			if (objectList[0].y > 0)
			{
				for each (var autoText:DisplayObject in objectList)
				{
					autoText.y -= autoText.height / _moveTime / (1000 / _moveDelay);
					autoText.y = Math.floor(autoText.y);
				}
			}
		}

		public function addObject(value:DisplayObject):void
		{
			if (objectList.length == 0)
			{
				updateTimer.start();
			}

			value.addEventListener(Event.COMPLETE, onHideComplete);
			if (objectList.length == 0)
			{
				value.y = 0;
			}
			else
			{
				var lastObj:DisplayObject = objectList[objectList.length - 1];
				value.y = lastObj.y + lastObj.height;
			}
			this.addChild(value);
			objectList.push(value);
			if (objectList.length > _maxLen)
			{
				for (var i:int = objectList.length - 1; i > 0; --i)
				{
					objectList[i].y = objectList[i - 1].y;
				}
				var objRemove:DisplayObject = objectList.shift();
				removeObj(objRemove);
			}

			if (_parent && objectList.length > 0 && !this.parent)
			{
				_parent.addChild(this);
			}
		}

		protected function onHideComplete(event:Event):void
		{
			for (var i:int = 0; i < objectList.length; ++i)
			{
				if (objectList[i] == event.currentTarget)
				{
					objectList.splice(i, 1);
					removeObj(event.currentTarget as DisplayObject);
					break;
				}
			}
		}

		private function removeObj(obj:DisplayObject):void
		{
			obj.removeEventListener(Event.COMPLETE, onHideComplete);
			this.removeChild(obj);
			if (objectList.length == 0)
			{
				updateTimer.stop();
				if (_parent && this.parent)
				{
					_parent.removeChild(this);
				}
			}
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
		}
	}
}
