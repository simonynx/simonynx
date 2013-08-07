package fj1.common.ui
{
	import com.riaidea.text.RichTextField;
	import com.riaidea.text.plugins.IRTFPlugin;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	public class TextFieldMouseDownPlugin implements IRTFPlugin
	{
		private var _mouseDownEvent:MouseEvent;
		private var _mouseUpEvent:MouseEvent;
		private var _waitForFrames:int = 0;
		private var _eventThrowTarget:InteractiveObject;
		private var _textField:DisplayObject;
		private var _eventBuffer:Vector.<DelayDispatchData>;

		public function TextFieldMouseDownPlugin(eventThrowTarget:InteractiveObject)
		{
			_eventBuffer = new Vector.<DelayDispatchData>();
			_eventThrowTarget = eventThrowTarget;
		}

		/**
		 * 安装插件时由RichTextField对象调用。
		 * @param	target 要安装插件的RichTextField对象。
		 */
		public function setup(target:RichTextField):void
		{
			setupCommon(target);
		}

		/**
		 * 将插件作用于文本对象中
		 * @param target
		 *
		 */
		public function setupCommon(target:DisplayObject):void
		{
			_textField = target;
			_textField.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventHandler);
			_textField.addEventListener(MouseEvent.MOUSE_UP, onMouseEventHandler);
			_textField.addEventListener(MouseEvent.ROLL_OVER, onMouseEventHandler);
			_textField.addEventListener(MouseEvent.MOUSE_OVER, onMouseEventHandler);
			_textField.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEventHandler);
			_textField.addEventListener(TextEvent.LINK, onTextLink);
		}

		/**
		 * 一个布尔值，指示插件是否启用。
		 */
		public function get enabled():Boolean
		{
			return true;
		}

		public function set enabled(value:Boolean):void
		{
		}

		private function onTextLink(event:TextEvent):void
		{
			//如果已经有TextLink事件，置空，不抛到场景
			_eventBuffer = new Vector.<DelayDispatchData>();
		}

		private function onMouseEventHandler(event:MouseEvent):void
		{
			if (event.target is SimpleButton)
			{
				return;
			}
			var $e:MouseEvent = event;
			var localP:Point = _eventThrowTarget.globalToLocal(_textField.localToGlobal(new Point($e.localX, $e.localY)));
			$e.localX = localP.x;
			$e.localY = localP.y;
			switch ($e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					//缓存mouseDown事件
					_eventBuffer.push(new DelayDispatchData(6, $e));
					if (_eventBuffer.length == 1)
					{
						_textField.addEventListener(Event.ENTER_FRAME, onDispatchToScene);
					}
					break;
				case MouseEvent.MOUSE_UP:
					//缓存mouseUp事件
					_eventBuffer.push(new DelayDispatchData(6, $e));
					if (_eventBuffer.length == 1)
					{
						_textField.addEventListener(Event.ENTER_FRAME, onDispatchToScene);
					}
					break;
				case MouseEvent.MOUSE_OVER:
					_eventThrowTarget.dispatchEvent($e);
					break;
				case MouseEvent.MOUSE_MOVE:
					_eventThrowTarget.dispatchEvent($e);
					break;
				case MouseEvent.ROLL_OVER:
					_eventThrowTarget.dispatchEvent($e);
					break;
			}
		}

		protected function onDispatchToScene(event:Event):void
		{
			for (var i:int = 0; i < _eventBuffer.length; i++)
			{
				var element:DelayDispatchData = _eventBuffer[i] as DelayDispatchData;
				--element.waitForFrames;
				if (element.waitForFrames <= 0)
				{
					//事件抛给场景
					_eventThrowTarget.dispatchEvent(element.event);
					_eventThrowTarget.stage.focus = _eventThrowTarget; //设置焦点
					_eventBuffer.splice(i, 1);
					--i;
				}
			}
			if (_eventBuffer.length == 0)
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
			}
		}
	}
}
import flash.events.MouseEvent;

class DelayDispatchData
{
	public function DelayDispatchData(waitForFrames:int, event:MouseEvent)
	{
		this.waitForFrames = waitForFrames;
		this.event = event;
	}
	public var waitForFrames:int; //等待TextLink事件的帧数
	public var event:MouseEvent;
}
