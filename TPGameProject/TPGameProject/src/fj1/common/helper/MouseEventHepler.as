package fj1.common.helper
{
	import com.riaidea.text.RichTextField;

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	import tempest.ui.components.textFields.TText;

	public class MouseEventHepler
	{
		/**
		 * 设置TText事件转发
		 * @param tf
		 * @param to
		 */
		public static function setTextForwarding(tf:TText, to:InteractiveObject):void
		{
			var $tf:TText = tf;
			var $to:InteractiveObject = to;
			if (!$tf || !$to)
			{
				return;
			}
			forwarding($tf, to);
			var tfClick:Boolean = false;
			var onMouseDownHandler:Function = function(e:MouseEvent):void
			{
				if (e.target is Sprite || e.target is TextField)
				{
					if (tfClick)
					{
						e.stopImmediatePropagation();
					}
				}
				tfClick = false;
			}
			var onLinkHandler:Function = function(e:TextEvent):void
			{
				tfClick = true;
			}
			$tf.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, true);
			$tf.textField.addEventListener(TextEvent.LINK, onLinkHandler, false, int.MAX_VALUE);
		}

		public static function setRichTextFieldForwarding(tf:RichTextField, to:InteractiveObject):void
		{
			var $tf:RichTextField = tf;
			var $to:InteractiveObject = to;
			if (!$tf || !$to)
			{
				return;
			}
			forwarding($tf, to);
			var tfClick:Boolean = false;
			var onMouseDownHandler:Function = function(e:MouseEvent):void
			{
				if (e.target is Sprite || e.target is TextField)
				{
					if (tfClick)
					{
						e.stopImmediatePropagation();
					}
				}
				tfClick = false;
			}
			var onLinkHandler:Function = function(e:TextEvent):void
			{
				tfClick = true;
			}
			$tf.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, true);
			$tf.textfield.addEventListener(TextEvent.LINK, onLinkHandler, false, int.MAX_VALUE);
		}

		/**
		 * 设置转发
		 * @param from 转发事件的对象
		 * @param to 要转发到的对象
		 * @param eventPhase 指定监听到的事件在某个事件阶段时才会被转发，默认为不指定，即转发所有鼠标事件
		 */
		public static function forwarding(from:InteractiveObject, to:InteractiveObject, eventPhase:uint = 0):void
		{
			var $from:InteractiveObject = from;
			var $to:InteractiveObject = to;
			if (!$from || !$to)
			{
				return;
			}
			var onMouseEventHandler:Function = function(e:MouseEvent):void
			{
				if (eventPhase && e.eventPhase != eventPhase)
				{
					return;
				}
				var $e:MouseEvent = e;
				var localP:Point = $to.globalToLocal($from.localToGlobal(new Point(e.localX, e.localY)));
				$e.localX = localP.x;
				$e.localY = localP.y;
				$to.dispatchEvent($e);
			}
			$from.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventHandler);
			$from.addEventListener(MouseEvent.MOUSE_UP, onMouseEventHandler);
			$from.addEventListener(MouseEvent.ROLL_OVER, onMouseEventHandler);
			$from.addEventListener(MouseEvent.MOUSE_OUT, onMouseEventHandler);
			$from.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEventHandler);
		}
	}
}
