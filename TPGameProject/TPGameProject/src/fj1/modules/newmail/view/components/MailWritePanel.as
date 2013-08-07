package fj1.modules.newmail.view.components
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.salesroom.SalesroomConfigManager;
	import fj1.common.res.salesroom.vo.BeliefSaleItemConfig;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.ui.TInputText;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.MessageManager;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.ui.DragManager;
	import tempest.ui.MouseOperatorLock;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TFixedList;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.textFields.TText;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.ListEvent;
	import tempest.utils.RegexUtil;

	public class MailWritePanel extends TComponent
	{
		public var txt_name:TInputText; //名字
		public var txt_title:TInputText; //邮件标题
		public var txt_content:TInputText; //内容
		public var lbl_money_to_send:TInputText; //寄送金币
		public var txt_mail_money:TextField; //邮费
		public var btn_friend:TButton; //好友
		public var btn_bag:TButton; //背包
		public var btn_send:TButton; //发送
		public var btn_cancel:TButton; //取消
		public var mailListList:TFixedList; //邮件附件列表
		public var friendSignal:ISignal;
		public var bagSignal:ISignal;
		public var sendSignal:ISignal;
		public var cancelSignal:ISignal;
		public var txt_sended_Num:TextField;

		public function MailWritePanel(proxy:* = null)
		{
			super(null, proxy);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			txt_name = new TInputText(null, null, _proxy.txt_name, "");
//			txt_name.byteLimitModel(16);
			txt_title = new TInputText(null, null, _proxy.txt_title, "");
			txt_title.byteLimitModel(24);
			txt_title.setByteLimit(32, TText.OL_ADD_TAIL);
			txt_content = new TInputText(null, null, _proxy.txt_content, "");
			txt_content.text = "";
			txt_content.byteLimitModel(300);
			lbl_money_to_send = new TInputText(moneyCheck, null, _proxy.lbl_money_to_send, "0");
			lbl_money_to_send.numberModel(0, 999999999);
			lbl_money_to_send.restrict = RegexUtil.Number;
			txt_mail_money = _proxy.txt_mail_money;
			btn_friend = new TButton(null, _proxy.btn_friend, LanguageManager.translate(9004, "好友"));
			btn_bag = new TButton(null, _proxy.btn_bag, LanguageManager.translate(10023, "放入物品"));
			btn_send = new TButton(null, _proxy.btn_send, LanguageManager.translate(10024, "发送"));
			btn_cancel = new TButton(null, _proxy.btn_cancel, LanguageManager.translate(100009, "取消"));
			mailListList = new TFixedList(null, _proxy.mc_mailItemList, MailWriteItemRender, "item", new Array(5), false);
			txt_sended_Num = _proxy.txt_sended_Num;
		}

		/**
		 * 金钱判断
		 * @param str
		 * @return
		 *
		 */
		private function moneyCheck(str:String):Boolean
		{
			if (GameInstance.mainCharData.money < uint(txt_mail_money.text))
			{
				lbl_money_to_send.text = "0";
			}
			else
			{
				var maxMoney:int = GameInstance.mainCharData.money - uint(txt_mail_money.text);
				if (int(str) > maxMoney)
				{
					lbl_money_to_send.text = maxMoney.toString();
				}
			}
			lbl_money_to_send.text = Number(lbl_money_to_send.text).toString();
			return true;
		}

		/**
		 * 好友
		 * @return
		 *
		 */
		public function get friend():ISignal
		{
			return friendSignal ||= new NativeSignal(btn_friend, MouseEvent.CLICK, MouseEvent);
		}

		/**
		 * 背包
		 * @return
		 *
		 */
		public function get bag():ISignal
		{
			return bagSignal ||= new NativeSignal(btn_bag, MouseEvent.CLICK, MouseEvent);
		}

		/**
		 * 发送邮件
		 * @return
		 *
		 */
		public function get send():ISignal
		{
			return sendSignal ||= new NativeSignal(btn_send, MouseEvent.CLICK, MouseEvent);
		}

		/**
		 * 取消
		 * @return
		 *
		 */
		public function get cancel():ISignal
		{
			return cancelSignal ||= new NativeSignal(btn_cancel, MouseEvent.CLICK, MouseEvent);
		}
	}
}
import fj1.common.ui.boxes.BaseDataBox;
import fj1.common.ui.boxes.BaseDataListItemRender;

class MailWriteItemRender extends BaseDataListItemRender
{
	public function MailWriteItemRender(_proxy:* = null, data:Object = null)
	{
		super(_proxy, data);
	}

	override protected function createBox():void
	{
		_dataBox = new BaseDataBox(_proxy);
		_dataBox.enableLockState = false;
	}
}
