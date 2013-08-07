package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.UIStyle;

	[Event(name = "change", type = "flash.events.Event")]
	[Event(name = "select", type = "flash.events.Event")]
	public class TRadioButton extends TComponent
	{
		protected var mc_btn:MovieClip;
		protected var _model:int;
		protected var _selected:Boolean;
		protected var _groupName:String;
		protected var _text:String;
		protected var _mouseOverEnabled:Boolean = true;

		protected var _currentFrame:int;
		protected var _group:TGroup;

		public function TRadioButton(group:TGroup, constraints:Object = null, proxy:* = null, text:String = null, model:int = MovieClipResModel.MODEL_FRAME_4,
			changeHandler:Function = null)
		{
			_model = model;
			_text = text;
			_group = group;

			super(constraints, proxy);

			mc_btn = _proxy as MovieClip;
			if (!_proxy)
			{
				throw new Error("TRadioButton._proxy is null");
			}
			mc_btn.gotoAndStop(1);
			_currentFrame = 1;
			this.addEventListener(MouseEvent.CLICK, onClick);
			if (_model == MovieClipResModel.MODEL_FRAME_4)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}

			this.buttonMode = true;
			this.mouseChildren = false;
			_group.addRadioButton(this);

			if (changeHandler != null)
				this.addEventListener(Event.CHANGE, changeHandler);
		}

		override protected function draw():void
		{
			super.draw();

			mc_btn.gotoAndStop(_currentFrame);

			if (_text)
			{
				var tf:TextField = mc_btn.getChildAt(1) as TextField;
				if (tf.selectable)
				{
					tf.selectable = false;
				}
				if (tf.mouseEnabled)
				{
					tf.mouseEnabled = false;
				}
				tf.text = _text;
			}
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		protected function onClick(event:MouseEvent):void
		{
			this.addEventListener(Event.SELECT, onDefaultSelect, false, -50, false);
			dispatchEvent(new Event(Event.SELECT, false, true));
		}

		private function onDefaultSelect(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			if (event.isDefaultPrevented())
				return;
			this.select();
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			if (!_mouseOverEnabled)
			{
				return;
			}
			if (!_selected)
			{
				_currentFrame = 2;
				invalidate();
			}
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			if (!_mouseOverEnabled)
			{
				return;
			}
			if (!_selected)
			{
//				mc_btn.gotoAndStop(1);
				_currentFrame = 1;
				invalidate();
			}
		}

		protected function set mouseOverEnabled(value:Boolean):void
		{
			_mouseOverEnabled = value;
		}

		public function unSelect():void
		{
			if (_selected == false)
			{
				return;
			}
			_currentFrame = 1;
			_selected = false;
			dispatchEvent(new Event(Event.CHANGE));

			invalidate();
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * 设置为选中
		 *
		 */
		public function select():void
		{
			if (_selected)
			{
				return;
			}
			//选中
			switch (_model)
			{
				case MovieClipResModel.MODEL_FRAME_4:
					_currentFrame = 3;
					break;
				case MovieClipResModel.MODEL_FRAME_2:
					_currentFrame = 2;
					break;
			}
			_group.updateGroupButton(this);
			_selected = true;
			dispatchEvent(new Event(Event.CHANGE));

			invalidate();
		}

		/**
		 * 获取选中状态
		 * @return
		 *
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		override public function set enabled(value:Boolean):void
		{
			if (super.enabled == value)
			{
				return;
			}
			super.enabled = value;
			if (!super.enabled)
			{
				this.setFilter(UIStyle.disableFilter);
				this.mouseEnabled = this.mouseChildren = false;
			}
			else
			{
				this.removeFilters();
				this.mouseEnabled = this.mouseChildren = true;
			}
		}

		/**
		 * 设置文本
		 * @param value
		 *
		 */
		public function set text(value:String):void
		{
			_text = value;
			invalidate();
		}

		/**
		 * 切换到指定帧
		 * @param frame
		 *
		 */
		public function goToFrame(frame:int):void
		{
			_currentFrame = frame;
			invalidateNow();
		}
	}
}
