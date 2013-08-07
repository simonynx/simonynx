package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;

	import fj1.common.GameInstance;
	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.HeroDepot;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.MoneyType;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.MoneyTypeIcon;
	import fj1.common.ui.TInputText;
	import fj1.common.ui.TWindowManager;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TButton;
	import tempest.ui.events.DataEvent;
	import tempest.ui.helper.TextFieldHelper;
	import tempest.utils.RegexUtil;

	public class DepotMoneyEditDialog extends BaseWindow
	{
		private var _lbl_money:TInputText;
		private var _btn_moneyMax:TButton;
		private var _btn_submit:TButton;
		private var _btn_cancel:TButton;
		private var _heroDepot:HeroDepot;
		public static const TYPE_GET_MONEY:int = 1;
		public static const TYPE_SAVE_MONEY:int = 2;
		private var _type:int = 0;

		public function DepotMoneyEditDialog(type:int)
		{
			super({horizontalCenter: 0, verticalCenter: 0}, RslManager.getInstance(UIResourceLib.UI_GAME_GUI_DEPOT_MONEY_GETSET), TWindowManager.NAME_SINGLE_DIALOG);
			_lbl_money = new TInputText(moneyCheck, null, _proxy.lbl_money, "0");
			_lbl_money.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			_lbl_money.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			_lbl_money.numberModel(0, 999999999);
			_lbl_money.restrict = RegexUtil.Number;
//			_lbl_magicCrystal = new TInputText(magicCrystalCheck, null, _proxy.lbl_magicCrystal, "0");
//			_lbl_magicCrystal.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
//			_lbl_magicCrystal.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
//			_lbl_magicCrystal.numberModel();
			_btn_moneyMax = new TButton(null, _proxy.btn_moneyOK, "MAX", onClick);
//			_btn_magicCrystalMax = new TButton(null, _proxy.btn_magicCrystalOK, "MAX", onClick);
			_btn_submit = new TButton(null, _proxy.btn_left, LanguageManager.translate(100008, "确定"), onClick);
			_btn_cancel = new TButton(null, _proxy.btn_right, LanguageManager.translate(100009, "取消"), onClick);
			switch (type)
			{
				case TYPE_GET_MONEY:
					_proxy.tf_msg.text = LanguageManager.translate(29000, "请输入要取出的金额：");
					break;
				case TYPE_SAVE_MONEY:
					_proxy.tf_msg.text = LanguageManager.translate(29001, "请输入要存入的金额：");
					break;
			}
			_type = type;
			_heroDepot = HeroDepot.instance;
			new MoneyTypeIcon(_proxy.mc_iconMoney, MoneyType.MONEY);
//			new MoneyTypeIcon(_proxy.mc_iconMagicCrystal, MoneyType.MAGIC_CRYSTAL);
		}

		private function focusOutHandler(event:FocusEvent):void
		{
			if (int(event.target.text) == 0)
				event.target.text = "0";
			switch (event.target.name)
			{
				case "lbl_money":
					if (int(_lbl_money.text) == 0)
						_lbl_money.text = "0"
					else
						_lbl_money.text = TextFieldHelper.getMoneyFormat(_lbl_money.text);
					break;
//				case "lbl_magicCrystal":
//					if (int(_lbl_magicCrystal.text) == 0)
//						_lbl_magicCrystal.text = "0"
//					else
//						_lbl_magicCrystal.text = NumberTextField.getMoneyFormat(_lbl_magicCrystal.text);
//					break;
			}
		}

		private function focusInHandler(event:FocusEvent):void
		{
			if (event.target.text == "0")
				event.target.text = "";
			switch (event.target.name)
			{
				case "lbl_money":
					_lbl_money.text = TextFieldHelper.getMoney(_lbl_money.text);
					break;
//				case "lbl_magicCrystal":
//					_lbl_magicCrystal.text = NumberTextField.getMoney(_lbl_magicCrystal.text);
//					break;
			}
		}

		public function get type():int
		{
			return int(this._type);
		}
		/**
		 * 金钱验证
		 * @param str
		 * @return
		 *
		 */
		private var maxMoney:uint = 999999999; //玩家身上和仓库金钱上限
		private var myMoneyMax:uint; //现在存取金钱的上线
		private var myMojinMax:uint; //现在存取魔金的上线

		private function moneyCheck(str:String):Boolean
		{
			switch (type)
			{
				case TYPE_GET_MONEY: //取钱模式
					myMoneyMax = maxMoney - GameInstance.mainCharData.money;
//					if (myMoneyMax > _heroDepot.money)
//					{
					if (_heroDepot.money < int(str))
					{
						_lbl_money.text = _heroDepot.money.toString();
					}
//					}
//					else
//					{
					if (myMoneyMax < int(str))
					{
						_lbl_money.text = String(myMoneyMax);
					}
//					}
					break;
				case TYPE_SAVE_MONEY: //存钱模式
					myMoneyMax = maxMoney - _heroDepot.money;
//					if (myMoneyMax > _hero.money)
//					{
					if (GameInstance.mainCharData.money < int(str))
					{
						_lbl_money.text = GameInstance.mainCharData.money.toString();
					}
//					}
//					else
//					{
					if (myMoneyMax < int(str))
					{
						_lbl_money.text = String(myMoneyMax);
					}
//					}
					break;
			}
			_lbl_money.text = Number(_lbl_money.text).toString();
			return true;
		}

		/**
		 * 魔晶验证
		 * @param str
		 * @return
		 *
		 */
//		private function magicCrystalCheck(str:String):Boolean
//		{
//			switch (type)
//			{
//				case TYPE_GET_MONEY: //取钱模式
//					myMojinMax = maxMoney - _hero.magicCrystal;
////					if (myMojinMax > _heroDepot.magicCristal)
////					{
//					if (_heroDepot.magicCristal < int(str))
//					{
//						_lbl_magicCrystal.text = _heroDepot.magicCristal.toString();
//					}
////					}
////					else
////					{
//					if (myMojinMax < int(str))
//					{
//						_lbl_magicCrystal.text = String(myMojinMax);
//					}
////					}
//					break;
//				case TYPE_SAVE_MONEY: //存钱模式
//					myMojinMax = maxMoney - _heroDepot.magicCristal;
////					if (myMojinMax > _hero.magicCrystal)
////					{
//					if (_hero.magicCrystal < int(str))
//					{
//						_lbl_magicCrystal.text = _hero.magicCrystal.toString();
//					}
////					}
////					else
////					{
//					if (myMojinMax < int(str))
//					{
//						_lbl_magicCrystal.text = String(myMojinMax);
//					}
////					}
//					break;
//			}
//			return true;
//		}
		private function onClick(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case _btn_moneyMax:
					switch (type)
					{
						case TYPE_GET_MONEY: //取钱模式
							myMoneyMax = maxMoney - GameInstance.mainCharData.money;
							if (_heroDepot.money > myMoneyMax)
								_lbl_money.text = TextFieldHelper.getMoneyFormat(String(myMoneyMax));
							else
								_lbl_money.text = TextFieldHelper.getMoneyFormat(String(_heroDepot.money));
							break;
						case TYPE_SAVE_MONEY: //存钱模式
							myMoneyMax = maxMoney - _heroDepot.money;
							if (GameInstance.mainCharData.money > myMoneyMax)
								_lbl_money.text = TextFieldHelper.getMoneyFormat(String(myMoneyMax));
							else
								_lbl_money.text = TextFieldHelper.getMoneyFormat(String(GameInstance.mainCharData.money));
							break;
					}
					break;
//				case _btn_magicCrystalMax:
//					switch (type)
//					{
//						case TYPE_GET_MONEY: //取钱模式
//							myMojinMax = maxMoney - _hero.magicCrystal;
//							if (_heroDepot.magicCristal > myMojinMax)
//								_lbl_magicCrystal.text = NumberTextField.getMoneyFormat(String(myMojinMax));
//							else
//								_lbl_magicCrystal.text = NumberTextField.getMoneyFormat(String(_heroDepot.magicCristal));
//							break;
//						case TYPE_SAVE_MONEY: //存钱模式
//							myMojinMax = maxMoney - _heroDepot.magicCristal;
//							if (_hero.magicCrystal > myMojinMax)
//								_lbl_magicCrystal.text = NumberTextField.getMoneyFormat(String(myMojinMax));
//							else
//								_lbl_magicCrystal.text = NumberTextField.getMoneyFormat(String(_hero.magicCrystal));
//							break;
//					}
//					break;
				case _btn_submit:
					this.dispatchEvent(new DataEvent(DataEvent.DATA, [int(TextFieldHelper.getMoney(_lbl_money.text)), int(0)]));
					this.closeWindow();
					break;
				case _btn_cancel:
					this.closeWindow();
					break;
			}
		}
	}
}
