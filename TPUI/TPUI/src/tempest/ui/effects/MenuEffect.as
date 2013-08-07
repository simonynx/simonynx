package tempest.ui.effects
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import tempest.ui.events.MenuEffectEvent;

	[Event(name = "change", type = "flash.events.Event")]
	public class MenuEffect extends TimerEffect
	{
		public static const TYPE_EXPEND:int = 0; //菜单正在展开中
		public static const TYPE_DISPEND:int = 1; //菜单正在回收中
		public static const STATE_EXPEND:int = 0; //菜单展开状态
		public static const STATE_DISPEND:int = 1; //菜单回收状态	
		public static const DERECT_DOWN:int = 0; //方向
		public static const DERECT_UP:int = 1;
		protected var _type:int;
		protected var _state:int;
		protected var _direct:int;
		protected var _expendSpeed:Number = 1 / 5; //伸展速度
		protected var _dispendSpeed:Number = 1 / 2; //收回速度

		public function MenuEffect(delay:Number, target:DisplayObject, direct:int, type:int = MenuEffect.TYPE_EXPEND)
		{
			super(delay, target);
			this._type = type;
			this._direct = direct;
			if (_type == TYPE_EXPEND)
			{
				this._state = STATE_DISPEND;
				this._target.visible = false;
			}
			else
			{
				this._target.visible = true;
				this._state = STATE_EXPEND;
				this._target.scrollRect = new Rectangle(0, 0, this._target.width, this._target.height);
			}

		}

		public function changeType(type:int):void
		{
			this._type = type;
		}

		private function _play():void
		{
			this._target.visible = true;
			if (!this._target.scrollRect)
			{
				if (_type == TYPE_EXPEND)
				{
					if (_direct == DERECT_DOWN)
					{
						this._target.scrollRect = new Rectangle(0, this._target.height, this._target.width, this._target.height);
					}
					else
					{
						this._target.scrollRect = new Rectangle(0, -this._target.height, this._target.width, this._target.height);
					}
				}
				else
				{
					this._target.scrollRect = new Rectangle(0, 0, this._target.width, this._target.height);
				}
			}
			super.play();
		}

		override public function play():void
		{
			if (showing)
			{
				this._type = TYPE_DISPEND;
				_play();
				dispatchEvent(new MenuEffectEvent(MenuEffectEvent.RETRACTION));
			}
			else
			{
				this._type = TYPE_EXPEND;
				_play();
				dispatchEvent(new MenuEffectEvent(MenuEffectEvent.DEPLOY));
			}
		}

		public function expend():void
		{
			if (showing)
				return;
			this._type = TYPE_EXPEND;
			_play();
			dispatchEvent(new MenuEffectEvent(MenuEffectEvent.DEPLOY));
		}

		public function dispend():void
		{
			if (!showing)
				return;
			this._type = TYPE_DISPEND;
			_play();
			dispatchEvent(new MenuEffectEvent(MenuEffectEvent.RETRACTION));
		}

		override public function dispose():void
		{
			super.dispose();
			this._target.scrollRect == null;
			this._target = null;
		}

		override protected function onTimer(event:TimerEvent):void
		{
			if (_direct == DERECT_DOWN)
			{
				onDerectDownTimer();
			}
			else if (_direct == DERECT_UP)
			{
				onDerectUpTimer();
			}
			else
			{
			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function onDerectDownTimer():void
		{
			if (_type == TYPE_EXPEND)
			{
				//弹出
				if (this._target.scrollRect.y <= 0)
				{
					this._target.scrollRect = null;
					this._state = STATE_EXPEND;
					stop();
					return;
				}
				var scrollRect:Rectangle = this._target.scrollRect;
				scrollRect.y -= this._target.height * _expendSpeed;
				if (scrollRect.y < 0)
					scrollRect.y = 0;
				this._target.scrollRect = scrollRect;
			}
			else
			{
				//收起
				if (this._target.scrollRect.y >= this._target.height)
				{
					this._target.scrollRect = null;
					this._target.visible = false;
					this._state = STATE_DISPEND;
					stop();
					return;
				}
				var scrollRect2:Rectangle = this._target.scrollRect;
				scrollRect2.y += this._target.height * _dispendSpeed;
				if (scrollRect2.y > this._target.height)
					scrollRect2.y = this._target.height;
				this._target.scrollRect = scrollRect2;
			}
		}

		private function onDerectUpTimer():void
		{
			if (_type == TYPE_EXPEND)
			{
				//弹出
				if (this._target.scrollRect.y >= 0)
				{
					this._target.scrollRect = null;
					this._state = STATE_EXPEND;
					stop();
					return;
				}
				var scrollRect:Rectangle = this._target.scrollRect;
				scrollRect.y += this._target.height * _expendSpeed;
				this._target.scrollRect = scrollRect;
			}
			else
			{
				//收起
				if (this._target.scrollRect.y <= -this._target.height)
				{
					this._target.scrollRect = null;
					this._target.visible = false;
					this._state = STATE_DISPEND;
					stop();
					return;
				}
				var scrollRect2:Rectangle = this._target.scrollRect;
				scrollRect2.y -= this._target.height * _dispendSpeed;
				this._target.scrollRect = scrollRect2;
			}
		}

		public function get type():int
		{
			return _type;
		}

		public function get scrollHeight():Number
		{
			if (!this._target.scrollRect)
			{
				if (_state == STATE_DISPEND)
					return 0;
				else if (_state == STATE_EXPEND)
					return this._target.height;
				else
					return 0;
			}
			if (_direct == DERECT_DOWN)
			{
				return this._target.height - this._target.scrollRect.y;
			}
			else if (_direct == DERECT_UP)
			{
				return this._target.scrollRect.y - this._target.height;
			}
			else
			{
				return this._target.height;
			}
		}

		public function get state():int
		{
			return _state;
		}

		public function set direct(value:int):void
		{
			this._direct = value;
		}

		public function get showing():Boolean
		{
			if ((playing && this._type == TYPE_EXPEND)
				|| (!playing && this._state == STATE_EXPEND))
				return true;
			else
				return false;
		}

		public function get hiding():Boolean
		{
			if ((playing && this._type == TYPE_DISPEND)
				|| (!playing && this._state == STATE_DISPEND))
				return true;
			else
				return false;
		}

		public function set expendSpeed(value:Number):void
		{
			_expendSpeed = value;
		}

		public function set dispendSpeed(value:Number):void
		{
			_dispendSpeed = value;
		}
	}
}
