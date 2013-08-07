package fj1.modules.newmail.view
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.model.vo.MailInfo;
	import fj1.modules.newmail.service.MailService;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.components.MailInfoPanel;
	import fj1.modules.newmail.view.components.MailTabPanel;

	import flash.events.MouseEvent;

	import tempest.common.mvc.base.Mediator;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;
	import tempest.ui.helper.TextFieldHelper;

	public class MailInfoPanelMediator extends Mediator
	{
		[Inject]
		public var view:MailInfoPanel;
		[Inject]
		public var model:MailModel;
		[Inject]
		public var signal:MailSignal;
		[Inject]
		public var service:MailService;
		private var itemNum:int; //附件个数
		private var guid:int; //邮箱guid
		private var listArr:TArrayCollection = new TArrayCollection([null, null, null, null, null]);

		public function MailInfoPanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(view.reply, onReplyMail);
			addSignal(view.resive, onResiveMail);
			addSignal(view.cancal, onCancalMail);
			addSignal(signal.updateMailContent, onUpdateMail);
		}

		//更新邮件内容
		private function onUpdateMail(mailInfo:MailInfo):void
		{
			listArr.source = [null, null, null, null, null];
			if (mailInfo.kind != MailInfo.MAIL_PERSONAL)
				view._btn_reply.enabled = false;
			else
				view._btn_reply.enabled = true;
			guid = mailInfo.guid;
			itemNum = mailInfo.itemArr.length;
			view._txt_title.text = mailInfo.title;
			view._txt_title.enabled = false;
			view._txt_name.text = mailInfo.senderName;
			view._txt_mailContent.text = mailInfo.sendContent;
			view._lbl_money_to_send.text = TextFieldHelper.getMoneyFormat(String(mailInfo.sendMoney));
			view._lbl_emoney_to_send.text = TextFieldHelper.getMoneyFormat(String(mailInfo.sendMoJin));
			view._mailListList.dataProvider = listArr;
			for (var i:int = 0; i < mailInfo.itemArr.length; i++)
			{
				var itemData:ItemData = ItemDataFactory.createByID(GameInstance.mainChar.id, mailInfo.itemArr[i][0], mailInfo.itemArr[i][1], null, mailInfo.itemArr[i][2]);
				listArr[i] = itemData;
			}
		}

		//回复邮件
		private function onReplyMail(e:MouseEvent):void
		{
			signal.showMailPanel.dispatch(1);
			signal.replyMail.dispatch(view._txt_name.text, LanguageManager.translate(10025, "回复:{0}", view._txt_title.text));
		}

		//接受附件
		private function onResiveMail(e:MouseEvent):void
		{
			if (itemNum == 0 && view._lbl_money_to_send.text == "0" && view._lbl_emoney_to_send.text == "0")
				return;
			if (GameInstance.mainCharData.money + uint(TextFieldHelper.getMoney(view._lbl_money_to_send.text)) > 999999999)
				MessageManager.instance.addHintById_client(45, "可携带金币上限");
			if (GameInstance.mainCharData.magicCrystal + uint(TextFieldHelper.getMoney(view._lbl_emoney_to_send.text)) > 999999999)
				MessageManager.instance.addHintById_client(46, "可携带魔晶上限");
			//获得背包空格数量
			var emptyBagNum:int = SlotItemManager.instance.getEmptyCellNum(ItemConst.CONTAINER_BACKPACK);
			if (itemNum > emptyBagNum)
			{
				MessageManager.instance.addHintById_client(802, "您的背包空间不够"); //您的背包空间不够
				return;
			}
			else
			{
				service.getMailAffix(guid);
			}
			if (view._lbl_money_to_send.text != "0")
				view._lbl_money_to_send.text = "0";
			if (view._lbl_emoney_to_send.text != "0")
				view._lbl_emoney_to_send.text = "0";
			listArr.source = [null, null, null, null, null];

		}

		//删除正在查看的邮件
		private function onCancalMail(e:MouseEvent):void
		{
			TAlertHelper.showDialog(2067, "你确定要删除当前邮件？（删除邮件将会失去附件，而且不能恢复）", true, TAlert.OK | TAlert.CANCEL, OnSureDelete);
		}

		private function OnSureDelete(e:TAlertEvent):void
		{
			if (e.flag == TAlert.OK)
			{
				//向服务器请求删除这条邮件
				signal.mailDelete.dispatch([guid]);
				model.delMailByIDArr([guid]);
				view.closeWindow();
			}
		}

		override public function onRemove():void
		{

		}
	}
}


