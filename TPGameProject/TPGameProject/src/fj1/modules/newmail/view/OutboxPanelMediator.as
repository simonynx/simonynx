package fj1.modules.newmail.view
{
	import assets.CursorLib;
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.salesroom.SalesroomConfigManager;
	import fj1.common.res.salesroom.vo.BeliefSaleItemConfig;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.staticdata.FetchType;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.MessageManager;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.model.vo.MailInfo;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.components.MailTabPanel;
	import fj1.modules.newmail.view.components.MailWritePanel;
	import fj1.modules.newmail.view.components.MiniFriendsPanel;
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import org.swiftsuspenders.Injector;
	import tempest.ui.DragManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.MouseOperatorLock;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TabControllerEvent;
	import tempest.ui.helper.TextFieldHelper;
	import tempest.utils.ListenerManager;

	public class OutboxPanelMediator
	{
		private var mailTabPanel:MailTabPanel;
		private var _mailWritePanel:MailWritePanel;
		private var mailModel:MailModel;
		private var mailSignal:MailSignal;
		private var _listenerManager:ListenerManager;

		public function OutboxPanelMediator(mailTabPanel:MailTabPanel, inject:Injector)
		{
			super();
			mailModel = inject.getInstance(MailModel);
			mailSignal = inject.getInstance(MailSignal);
			this.mailTabPanel = mailTabPanel;
			this._mailWritePanel = mailTabPanel.mailWritePanel;
			_listenerManager = new ListenerManager();
			this._mailWritePanel.addEventListener(TabControllerEvent.TAB_INIT, onRegister);
			this._mailWritePanel.addEventListener(TabControllerEvent.TAB_DISPOSE, onRemove);
		}

		private function onRegister(event:TabControllerEvent):void
		{
			_mailWritePanel.mailListList.dataProvider = mailModel.itemList;
			_mailWritePanel.txt_name.text = mailModel.chatName;
			mailModel.chatName = "";
			_mailWritePanel.lbl_money_to_send.text = "0";
			_mailWritePanel.txt_mail_money.text = String(MailInfo.POSTAGE);
			//
			_listenerManager.addSignal(_mailWritePanel.friend, onOpenFriend);
			_listenerManager.addSignal(_mailWritePanel.bag, onOpenBag);
			_listenerManager.addSignal(_mailWritePanel.send, onSendMail);
			_listenerManager.addSignal(_mailWritePanel.cancel, onCancel);
			_listenerManager.addSignal(mailSignal.setMailTitle, setMailTitle);
			_listenerManager.addSignal(mailSignal.sendMailComplete, sendMailComplete);
			_listenerManager.addSignal(mailSignal.setNameAndTitle, setNameAndTitle);
			_listenerManager.addSignal(mailSignal.miniFriName, setMiniFriName);
			_mailWritePanel.txt_sended_Num.text = LanguageManager.translate(10028, "每日发件数：{0}/{1}", mailModel.currSendMailNum, mailModel.maxMailNum);
			//
			_mailWritePanel.lbl_money_to_send.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			_mailWritePanel.lbl_money_to_send.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			_mailWritePanel.mailListList.foreach(function(render:TListItemRender):void
			{
				_listenerManager.addEventListener(_mailWritePanel.mailListList, ListEvent.ITEM_RENDER_CREATE, onItemRenderCreate);
			});
		}

		private function setMiniFriName(name:String):void
		{
			_mailWritePanel.txt_name.text = name;
		}

		private function onItemRenderCreate(event:ListEvent):void
		{
			var itemRender:BaseDataListItemRender = event.data as BaseDataListItemRender;
			//			itemRender.dataBox.dragImage.dropBackAreaArray = [this];
			itemRender.dataBox.pickUpEnabled = false; //禁用拖起事件
			itemRender.dragImage.dragAccpetPlaces = [DragImagePlaces.BAG]; //只接受背包物品
			itemRender.addEventListener(DragEvent.DROP_DOWN, onDropDown);
			itemRender.addEventListener(MouseEvent.CLICK, onItemRanderClick);
		}

		private function onDropDown(event:DragEvent):void
		{
			var itemRender:TListItemRender = event.currentTarget as TListItemRender;
			var itemData:ItemData = DragManager.dragingData as ItemData;
			if (itemData)
			{
				var beliefConfig:BeliefSaleItemConfig = SalesroomConfigManager.getBeliefSaleItemConfig(itemData.templateId);
				if (beliefConfig != null)
				{
					MessageManager.instance.addHintById_client(2307, "信仰罐无法邮寄");
					return;
				}
				if (itemData.playerBinded)
				{
					MessageManager.instance.addHintById_client(44, "绑定物品无法放入");
					return;
				}
			}
			mailModel.addItemList(itemData, itemRender.index); //添加附件
			mailSignal.setMailTitle.dispatch(itemData); //设置邮件标题
		}

		private function onItemRanderClick(event:MouseEvent):void
		{
			if (MouseOperatorLock.instance.isLocked())
			{
				return;
			}
			var itemRender:TListItemRender = event.currentTarget as TListItemRender;
			//删除附件
			mailModel.delItemList(itemRender.index);
		}

		/**
		 * 设置收件人名字和标题
		 * @param replyName
		 * @param replyTitle
		 *
		 */
		private function setNameAndTitle(replyName:String, replyTitle:String):void
		{
			_mailWritePanel.txt_name.text = replyName;
			_mailWritePanel.txt_title.text = replyTitle;
			_mailWritePanel.txt_content.text = "";
			_mailWritePanel.lbl_money_to_send.text = "0";
			mailModel.delAllItemList();
		}

		/**
		 * 邮件标题判断
		 * @param itemData
		 *
		 */
		private function setMailTitle(itemData:ItemData):void
		{
			if (_mailWritePanel.txt_title.text == "")
			{
				_mailWritePanel.txt_title.text = LanguageManager.translate(10007, "{0}物品的邮件", itemData.name);
			}
		}

		/**
		 * 邮件发送出去后操作
		 */
		private function sendMailComplete():void
		{
			delMailInfo();
			mailTabPanel.closeWindow();
		}

		//好友 	
		private function onOpenFriend(e:MouseEvent):void
		{
			//如果没有打开过好友列表就查询好友列表
//			GameInstance.signal.friend.friendListQuery.dispatch();
			TWindowManager.instance.showPopup2(null, MiniFriendsPanel.NAME, false, false, TWindowManager.MODEL_REMOVE_OR_ADD);
		}

		//鼠标手势
		private function onOpenBag(e:MouseEvent):void
		{
			if (FetchHelper.instance.isFetching)
			{
				if (FetchHelper.instance.fetchType != FetchType.ACCESSORY)
					FetchHelper.instance.begingFetch(FetchType.ACCESSORY, CursorLib.SHOP_SELL, true);
				else
					FetchHelper.instance.cancelFetch();
			}
			else
				FetchHelper.instance.begingFetch(FetchType.ACCESSORY, CursorLib.SHOP_SELL, true);
		}

		//发送邮件 
		private function onSendMail(e:MouseEvent):void
		{
			mailSignal.sendMail.dispatch(_mailWritePanel.txt_name.text, _mailWritePanel.txt_title.text, _mailWritePanel.txt_content.text, _mailWritePanel.lbl_money_to_send.text);
		}

		//取消发送邮件
		private function onCancel(e:MouseEvent):void
		{
			mailTabPanel.closeWindow();
		}

		private function focusInHandler(event:FocusEvent):void
		{
			_mailWritePanel.lbl_money_to_send.text = TextFieldHelper.getMoney(_mailWritePanel.lbl_money_to_send.text);
		}

		private function focusOutHandler(event:FocusEvent):void
		{
			if (int(_mailWritePanel.lbl_money_to_send.text) == 0)
				_mailWritePanel.lbl_money_to_send.text = "0"
			else
				_mailWritePanel.lbl_money_to_send.text = TextFieldHelper.getMoneyFormat(_mailWritePanel.lbl_money_to_send.text);
		}

		private function onRemove(event:TabControllerEvent):void
		{
			delMailInfo();
		}

		/**
		 * 删除邮件内容
		 *
		 */
		private function delMailInfo():void
		{
			_mailWritePanel.txt_name.text = "";
			_mailWritePanel.txt_title.text = "";
			_mailWritePanel.txt_content.text = "";
			_mailWritePanel.lbl_money_to_send.text = "0";
			mailModel.delAllItemList();
		}
	}
}
