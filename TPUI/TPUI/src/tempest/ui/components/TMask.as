package tempest.ui.components
{

	public class TMask extends TComponent
	{
		public var _color:uint = 0x0;
		public var _colorAlpha:Number = 1;

		public function TMask(constraints:Object = null, _proxy:* = null, color:uint = 0x0, colorAlpha:Number = 1, enableInteractive:Boolean = false)
		{
			_color = color;
			_colorAlpha = colorAlpha;
			super(constraints, _proxy);
			this.enabled = enableInteractive;
		}

		override protected function draw():void
		{
			this.graphics.clear();
			this.graphics.beginFill(_color, _colorAlpha);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			super.invalidateSize();
			draw();
		}
	}
}
