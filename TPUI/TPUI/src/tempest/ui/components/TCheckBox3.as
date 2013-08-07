package tempest.ui.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import tempest.utils.Fun;

	public class TCheckBox3 extends TComponent
	{
		private var _text:String = "";
		protected var _selected:Boolean;
		private var _stateHolder1:StateHolder;
		private var _stateHolder2:StateHolder;
		private var _currentState:StateHolder;
		private var _delayState:StateHolder;

		public function TCheckBox3(constraints:Object = null, proxy:* = null)
		{
			super(constraints, proxy);
			_stateHolder1 = new StateHolder(_proxy.state1);
			_stateHolder2 = new StateHolder(_proxy.state2);
			_stateHolder2.hide();
			_delayState = _stateHolder1;
			_currentState = _stateHolder1;
			_currentState.show();
			this.addEventListener(MouseEvent.CLICK, onClick);
//			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
//			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}

		public function get state1():StateHolder
		{
			return _stateHolder1;
		}

		public function get state2():StateHolder
		{
			return _stateHolder2;
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			_stateHolder1.invalidateSize(_width, _height);
			_stateHolder2.invalidateSize(_width, _height);
		}

		override protected function draw():void
		{
			super.draw();
			if (_currentState != _delayState)
			{
				if (_currentState)
				{
					_currentState.hide();
				}
				_currentState = _delayState;
				if (_currentState)
				{
					_currentState.show();
				}
			}
			_currentState.textField.htmlText = _text;
		}

		private function setSelected(value:Boolean, dispatch:Boolean = true):void
		{
			if (_selected == value)
			{
				return;
			}
			if (!_selected && value)
			{
				_delayState = _stateHolder2;
			}
			else
			{
				_delayState = _stateHolder1;
			}
			_selected = value;
			if (dispatch)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			invalidate();
		}

		protected function onClick(event:MouseEvent):void
		{
			setSelected(!selected, true);
		}

//		protected function onMouseOver(event:MouseEvent):void
//		{
//			if (!_selected)
//			{
//				_currentFrame = 2;
//				invalidate();
//			}
//		}
//		protected function onMouseOut(event:MouseEvent):void
//		{
//			if (!_selected)
//			{
//				_currentFrame = 1;
//				invalidate();
//			}
//		}
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

		public function get textField():TextField
		{
			return _currentState.textField;
		}
	}
}
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;
import tempest.ui.components.TComponent;
import tempest.utils.Fun;

class TButton2 extends TComponent
{
	public function TButton2(constraints:Object = null, proxy:* = null)
	{
		super(constraints, proxy);
	}

	override public function invalidateSize(changed:Boolean = false):void
	{
		_proxy.downState.getChildAt(0).width = _width;
		_proxy.downState.getChildAt(0).height = _height;
		_proxy.upState.getChildAt(0).width = _width;
		_proxy.upState.getChildAt(0).height = _height;
		_proxy.overState.getChildAt(0).width = _width;
		_proxy.overState.getChildAt(0).height = _height;
	}
}

class StateHolder
{
	private var _tbutton:TButton2;
	private var _textField:TextField;
	private var _parent:DisplayObjectContainer;
	private var _stateProxy:*;

	public function StateHolder(stateProxy:*)
	{
		_stateProxy = stateProxy;
		_parent = stateProxy.parent;
		_tbutton = new TButton2(null, stateProxy.btn);
		_textField = stateProxy.text;
		if (_textField)
		{
			if (_textField.selectable)
			{
				_textField.selectable = false;
			}
			if (_textField.mouseEnabled)
			{
				_textField.mouseEnabled = false;
			}
		}
	}

	public function get tbutton():TButton2
	{
		return _tbutton;
	}

	public function get textField():TextField
	{
		return _textField;
	}

	public function invalidateSize(width:Number, height:Number):void
	{
		_tbutton.width = width;
		_tbutton.height = height;
		_textField.width = width;
		_textField.height = height;
	}

	public function hide():void
	{
		if (_stateProxy.parent)
		{
			_parent.removeChild(_stateProxy);
		}
	}

	public function show():void
	{
		if (!_stateProxy.parent)
		{
			_parent.addChild(_stateProxy);
		}
	}
}
