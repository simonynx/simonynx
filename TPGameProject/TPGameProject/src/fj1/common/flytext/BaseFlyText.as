package fj1.common.flytext
{
	import flash.display.Sprite;
	
	import tempest.core.IPoolClient;
	
	import tpm.magic.core.IFlyText;

	public class BaseFlyText extends Sprite implements tpm.magic.core.IFlyText, IPoolClient
	{
		protected var _direction:int = 1;

		public function BaseFlyText()
		{
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction = value;
		}

		public function reset(args:Array):void
		{
		}

		public function dispose():void
		{
		}

		public function setText(orien:int, content:String):void
		{
		}
	}
}
