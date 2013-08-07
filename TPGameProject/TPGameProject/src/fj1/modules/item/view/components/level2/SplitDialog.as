package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;

	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.TInputText;
	import fj1.common.ui.boxes.BaseDataBox;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.ui.events.DataEvent;
	import tempest.utils.RegexUtil;

	public class SplitDialog extends BaseWindow
	{
		public static const NAME:String = "SplitPanel";
		private var itemBox:BaseDataBox;
		private var _btn_cancel:TButton;
		private var _btn_submit:TButton;
		private var _tf_splitnum:TInputText;

		public function SplitDialog()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, RslManager.getInstance(UIResourceLib.UI_GAME_GUI_SPLIT), NAME);
			itemBox = new BaseDataBox(_proxy.item);
			itemBox.dragImage.pickUpEnable = false;
			_btn_cancel = new TButton(null, _proxy.btn_cancel, LanguageManager.translate(100009, "取消"), onButtonClick);
			_btn_submit = new TButton(null, _proxy.btn_submit, LanguageManager.translate(100008, "确定"), onButtonClick);
			_tf_splitnum = new TInputText(checkInput, null, _proxy.tf_splitnum);
			_tf_splitnum.numberModel(0, 999);
			_tf_splitnum.addEventListener(FocusEvent.FOCUS_IN, function(event:Event):void
			{
				_tf_splitnum.text = "";
			});
		}

		/**
		 * 检查数量合法性
		 * @param newStr
		 *
		 */
		private function checkInput(newStr:String):Boolean
		{
			var newValue:Number = Number(newStr);
			if (newValue > ItemData(data).num)
				_tf_splitnum.text = Number(ItemData(data).num).toString();
			else
				_tf_splitnum.text = Number(newValue).toString();
//			if (newValue < 1)
//				_tf_splitnum.text = "1";
			return true;
		}

		/**
		 *
		 * @param itemData
		 *
		 */
		public function setSplitData(itemData:ItemData):void
		{
			itemBox.data = itemData;
			_tf_splitnum.text = Number(1).toString();
		}

		private function onButtonClick(event:Event):void
		{
			switch (event.currentTarget)
			{
				case _btn_submit:
					var splitNum:int = int(_tf_splitnum.text);
					if (splitNum <= 0)
						return;
					dispatchEvent(new DataEvent("split", splitNum));
					break;
				case _btn_cancel:
//					this.closeWindow();
					break;
			}
			this.closeWindow();
		}
	}
}
