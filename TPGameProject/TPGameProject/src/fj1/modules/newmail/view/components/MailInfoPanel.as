package fj1.modules.newmail.view.components
{
	import assets.UIResourceLib;
	import tempest.common.rsl.RslManager;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.TInputText;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TFixedList;
	import tempest.ui.components.textFields.TText;
	import tempest.ui.events.ListEvent;

	public class MailInfoPanel extends BaseWindow
	{
		public static const NAME:String = "MailInfoPanel";
		public var _lbl_money_to_send:TextField; //金币
		public var _lbl_emoney_to_send:TextField; //魔金
		public var _txt_title:TInputText; //标题
		public var _txt_mailContent:TextField; //邮件内容
		public var _txt_name:TextField; //发件人
		public var _btn_remove:TButton; //删除
		public var _btn_reply:TButton; //回复
		public var _btn_resive:TButton; //收取附件
		public var _btn_cancal:TButton; //取消
		public var _mailListList:TFixedList; //邮件附件列表
		//
		public var replySignal:ISignal;
		public var resiveSignal:ISignal;
		public var cancalSignal:ISignal;

		public function MailInfoPanel(_proxy:*)
		{
			super({horizontalCenter: 336, verticalCenter: 0}, _proxy, NAME);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_lbl_money_to_send = _proxy.lbl_money_to_send;
			_lbl_emoney_to_send = _proxy.lbl_emoney_to_send;
			_txt_title = new TInputText(null, null, _proxy.txt_title, "");
			_txt_title.setByteLimit(32, TText.OL_ADD_TAIL);
			_txt_mailContent = _proxy.txt_mailContent;
			_txt_name = _proxy.txt_name;
			_btn_reply = new TButton(null, _proxy.btn_reply, LanguageManager.translate(10019, "回复"));
			_btn_resive = new TButton(null, _proxy.btn_resive, LanguageManager.translate(10020, "收取附件"));
			_btn_cancal = new TButton(null, _proxy.btn_cancal, LanguageManager.translate(100016, "删除"));
			_mailListList = new TFixedList(null, _proxy.mc_itemList, MailOverViewItemRender, "item", new Array(5), false, onItemRenderCreate);
		}

		private function onItemRenderCreate(event:ListEvent):void
		{
			var itemRender:BaseDataListItemRender = event.data as BaseDataListItemRender;
			itemRender.dataBox.pickUpEnabled = false; //禁用拖起事件
		}

		/**
		 * 回复
		 * @return
		 *
		 */
		public function get reply():ISignal
		{
			return replySignal ||= new NativeSignal(_btn_reply, MouseEvent.CLICK, MouseEvent);
		}

		/**
		 * 收取附件
		 * @return
		 *
		 */
		public function get resive():ISignal
		{
			return resiveSignal ||= new NativeSignal(_btn_resive, MouseEvent.CLICK, MouseEvent);
		}

		/**
		 * 删除
		 * @return
		 *
		 */
		public function get cancal():ISignal
		{
			return cancalSignal ||= new NativeSignal(_btn_cancal, MouseEvent.CLICK, MouseEvent);
		}
	}
}
import fj1.common.GameInstance;
import fj1.common.data.dataobject.items.ItemData;
import fj1.common.net.tcpLoader.DBItemDataLoader;
import fj1.common.staticdata.ToolTipName;
import fj1.common.ui.boxes.BaseDataBox;
import fj1.common.ui.boxes.BaseDataListItemRender;
import fj1.modules.main.MainFacade;
import fj1.modules.newmail.model.MailItemLoaderManager;
import fj1.modules.newmail.model.MailModel;
import fj1.modules.newmail.model.vo.MailInfo;
import tempest.ui.TToolTipManager;

class MailOverViewItemRender extends BaseDataListItemRender
{
	public function MailOverViewItemRender(proxy:* = null, data:Object = null)
	{
		super(proxy, data);
	}

	override protected function createBox():void
	{
		_dataBox = new MailItemBox(_proxy);
		_dataBox.enableLockState = false;
	}
}

class MailItemBox extends BaseDataBox
{
	public function MailItemBox(proxy:* = null)
	{
		super(proxy, null);
	}

	/**
	 * 设置Tip类型, 派生类可覆盖
	 *
	 */
	override protected function setToolTip():void
	{
		this.toolTip = TToolTipManager.instance.getToolTipInstance(ToolTipName.RICHTEXT); //TToolTipManager.instance.getToolTipInstance(ToolTipName.LOADER_COMPARE_TIP);
	}

	override public function getTipData():Object
	{
		if (!data)
		{
			return null;
		}
		var itemData:ItemData = data as ItemData;
		var model:MailModel = MainFacade.instance.inject.getInstance(MailModel) as MailModel;
		var currentMailInfo:MailInfo = model.getAndChangeMailState(model.guid);
		if (itemData.guId == 0)
		{
			return itemData;
		}
		else
		{
			var itemGuid:int = itemData.guId;
			var key:String = currentMailInfo.guid.toString() + itemGuid.toString(); //将邮件GUID和物品GUID拼接作为loader的缓存ID
			var loader:DBItemDataLoader = MailItemLoaderManager.get(key);
			if (!loader)
			{
				loader = new DBItemDataLoader(itemData);
				MailItemLoaderManager.add(key, loader);
			}
			return loader;
		}
	}
}
