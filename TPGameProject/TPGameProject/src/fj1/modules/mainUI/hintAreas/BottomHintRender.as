package fj1.modules.mainUI.hintAreas
{
	import fj1.common.res.hint.vo.HintConfig;
	import fj1.common.res.hint.vo.HintData;
	import flash.text.TextField;
	import tempest.core.IPoolClient;
	import tempest.ui.collections.TMutexGroup;
	import tempest.ui.components.TListItemRender;

	public class BottomHintRender extends TListItemRender implements IPoolClient
	{
		private var _lbl_content:TextField;
		private var _typeGroup:TMutexGroup;

		//DEBUG
//		private static var _count:int;	
//		
//		public var idd:int;
		public function BottomHintRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
			_lbl_content = _proxy.lbl_content;
			_typeGroup = new TMutexGroup(this, [_proxy.mc_iconGreen, _proxy.mc_iconYellow, _proxy.mc_iconRed]);
//			idd = ++_count;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			var hintData:HintData = HintData(value);
			if (hintData)
			{
				_lbl_content.text = hintData.content;
				var type2:int = (hintData.hintConfig as HintConfig).type2;
				_typeGroup.currentIndex = type2 - 1 >= 0 ? type2 - 1 : 0;
			}
			else
			{
				_lbl_content.text = "";
				_typeGroup.currentIndex = 0;
			}
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
		}

		public function reset(args:Array):void
		{
		}
	}
}
