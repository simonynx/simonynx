package fj1.common.ui
{
	import fj1.common.staticdata.Profession;
	import tempest.ui.components.TComponent;

	public class ProfessionIcon extends TComponent
	{
		private var _profession:int;

		public function ProfessionIcon(_proxy:* = null)
		{
			super(null, _proxy);
			_proxy.gotoAndStop(1);
		}

		public function set profession(value:int):void
		{
			_profession = value;

			if (value <= Profession.None)
			{
				this.visible = false;
			}
			else
			{
				this.visible = true;
				this.toolTipString = Profession.getName(_profession);
				_proxy.gotoAndStop(value);
			}

		}
	}
}
