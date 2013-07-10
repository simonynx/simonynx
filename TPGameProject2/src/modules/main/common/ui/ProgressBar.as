package modules.main.common.ui
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import tempest.ui.components.TComponent;
	import tempest.utils.Geom;
	import tempest.utils.Fun;

	/**
	 * 进度条
	 * @author
	 */
	[Embed(source = "/asset/loading.swf", symbol = "ProgressBar")]
	public class ProgressBar extends TComponent
	{
		public var bar:MovieClip;
		public var lbl_tip:TextField;

		public function ProgressBar(constraints:Object = null, defaultTip:String = "")
		{
			super(constraints, this);
			setTip(defaultTip);
		}

		protected override function init():void
		{
			lbl_tip = bar.lbl_tip;
			this.mouseEnabled = this.mouseChildren = false;
			super.init();
		}

		public function setProgress(progress:Number):void
		{
			var _value:int = progress * 100 + 1;
			if (_value < 1)
				_value = 1;
			if (_value > 101)
				_value = 101;
			bar.gotoAndStop(_value);
		}

		public function setTip(tip:String):void
		{
			lbl_tip.text = tip;
		}
	}
}
