package tempest.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.osflash.signals.natives.base.SignalSprite;
	import tempest.utils.Guid;

	public class TPSprite extends SignalSprite
	{
		protected var _id:int = -1;

		public function TPSprite()
		{
//			try
//			{
//				name = Guid.create();
//			}
//			catch (e:Error) //root不能更改
//			{
//			}
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function dispose():void
		{
		}

		public function get $width():Number
		{
			return super.width;
		}

		public function set $width(value:Number):void
		{
			super.width = value;
		}

		public function get $height():Number
		{
			return super.height;
		}

		public function set $height(value:Number):void
		{
			super.height = value;
		}
	}
}
