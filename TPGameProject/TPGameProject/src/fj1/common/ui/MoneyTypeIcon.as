package fj1.common.ui
{
	import fj1.common.staticdata.MoneyType;
	import fj1.common.staticdata.ToolTipName;

	import tempest.ui.TToolTipManager;
	import tempest.ui.components.TComponent;

	public class MoneyTypeIcon extends TComponent
	{
		private var _moneyType:int;

		private var _typeMap:Array;

		private var FRAME_MAGIC_CRYSTAL:int = 1;
		private var FRAME_MAGIC_STONEL:int = 2;
		private var FRAME_INTEGRATE:int = 3;
		private var FRAME_MONEY:int = 4;

		public function MoneyTypeIcon(_proxy:*, moneyType:int = 0, typeMap:Array = null)
		{
			if (!typeMap)
			{
				_typeMap = [{type: MoneyType.MAGIC_CRYSTAL, frame: 1},
					{type: MoneyType.MAGIC_STONE, frame: 2},
					{type: MoneyType.INTEGRATE, frame: 3},
					{type: MoneyType.MONEY, frame: 4},
					{type: MoneyType.GONGXUN, frame: 5}];
			}
			else
			{
				_typeMap = typeMap;
			}
			super(null, _proxy);
//			this.toolTip = TToolTipManager.instance.getToolTipInstance(ToolTipName.AUTO_WIDTH);
			this.moneyType = moneyType;
		}

		public function set moneyType(value:int):void
		{
			_moneyType = value;

			var canShow:Boolean = false;
			for each (var obj:Object in _typeMap)
			{
				if (obj.type == _moneyType)
				{
					_proxy.gotoAndStop(obj.frame);
					canShow = true;
					break;
				}
			}
			if (canShow)
			{
				this.visible = true;
				this.toolTipString = MoneyType.getTipStr(_moneyType);
			}
			else
			{
				this.visible = false;
				this.toolTipString = null;
			}
		}
	}
}
