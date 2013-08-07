package tempest.ui.components
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.UIStyle;
	import tempest.utils.Fun;

	[Event(name = "change", type = "flash.events.Event")]
	public class TCheckBox extends TComponent
	{
		protected var mc_btn:MovieClip;
		protected var _model:int;
		protected var _selected:Boolean;
		protected var _text:String;
		protected var _currentFrame:int = 1;
		private var _clickEnabled:Boolean = true;

		public function TCheckBox(constraints:Object = null, proxy:* = null, text:String = null, model:int = MovieClipResModel.MODEL_FRAME_4)
		{
			_model = model;
			_text = text;
			super(constraints, proxy);
			mc_btn = _proxy as MovieClip;
			_currentFrame = 1;
			this.addEventListener(MouseEvent.CLICK, onClick);
			if (_model == MovieClipResModel.MODEL_FRAME_4)
			{
				this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
			this.buttonMode = true;
		}

		public function getButton():SimpleButton
		{
			return SimpleButton(_proxy.getChildAt(0));
		}

		public function get clickEnabled():Boolean
		{
			return _clickEnabled;
		}

		/**
		 * 是否启用点击
		 * @param value
		 *
		 */
		public function set clickEnabled(value:Boolean):void
		{
			if (_clickEnabled == value)
			{
				return;
			}

			if (_clickEnabled)
			{
				this.removeEventListener(MouseEvent.CLICK, onClick);
			}
			_clickEnabled = value;
			if (_clickEnabled)
			{
				this.addEventListener(MouseEvent.CLICK, onClick);
			}
		}

		override protected function draw():void
		{
			super.draw();
			if (!mc_btn)
			{
				return;
			}
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
			setSelected(!selected, true);
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			if (!_selected)
			{
				if (_model == MovieClipResModel.MODEL_FRAME_4)
				{
					_currentFrame = 2;
				}
				invalidate();
			}
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			if (!_selected)
			{
				_currentFrame = 1;
				invalidate();
			}
		}

		private function setSelected(value:Boolean, dispatch:Boolean = true):void
		{
			if (_selected == value)
			{
				return;
			}

			if (!_selected && value)
			{
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
			}
			else
			{
				_currentFrame = 1;
			}
			_selected = value;
			if (dispatch)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			invalidate();
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function set selected(value:Boolean):void
		{
			setSelected(value, false);
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set text(value:String):void
		{
			_text = value ? value : "";
			invalidate();
		}

		public function get text():String
		{
			return _text;
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

	}
}
