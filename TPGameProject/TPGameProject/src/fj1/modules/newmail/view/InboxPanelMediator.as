package fj1.modules.newmail.view
{
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.model.vo.MailInfo;
	import fj1.modules.newmail.service.MailService;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.components.MailInfoPanel;
	import fj1.modules.newmail.view.components.MailListPanel;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.swiftsuspenders.Injector;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TPagedListView;
	import tempest.ui.components.TRadioButton;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TAlertEvent;
	import tempest.ui.events.TabControllerEvent;
	import tempest.utils.ListenerManager;

	public class InboxPanelMediator
	{
		private var _mailListPanel:MailListPanel;
		public var model:MailModel;
		private var signal:MailSignal;
		private var service:MailService;
		private var _listenerManager:ListenerManager;
		//选项卡叶名字
		private var tab_name:String;
		private var pagedListView:TPagedListView;

		public function InboxPanelMediator(mailListPanel:MailListPanel, inject:Injector)
		{
			super();
			model = inject.getInstance(MailModel);
			signal = inject.getInstance(MailSignal);
			service = inject.getInstance(MailService);
			this._mailListPanel = mailListPanel;
			_listenerManager = new ListenerManager();
			this._mailListPanel.addEventListener(TabControllerEvent.TAB_INIT, onRegister);
			this._mailListPanel.addEventListener(TabControllerEvent.TAB_DISPOSE, onRemove);
		}

		private function onRegister(event:TabControllerEvent):void
		{
			pagedListView = new TPagedListView(_mailListPanel.mailList, model.mailDataList, 6, _mailListPanel.pageController);
			_mailListPanel.pageController.pageSignal.add(onPageChanged); //翻页
			_mailListPanel.mailList.addEventListener(ListEvent.ITEM_RENDER_CREATE, onRenderCreate); //创建itemrender事件
			_mailListPanel.cbox_selectAll.addEventListener(Event.CHANGE, onChageState); //全选
			_listenerManager.addSignal(_mailListPanel.deleteMailSignal, onDeleteMail); //删除邮件
			_listenerManager.addSignal(signal.mailDataComplete, mailDataComplete); //查询邮件返回的结果
			//邮件分类
			_mailListPanel.rbt_all.addEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_system.addEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_personal.addEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_read.addEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_unread.addEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_all.select();
			btnEnabled(); //删除邮件按钮状态
			_mailListPanel.cbox_selectAll.selected = false;
		}

		/**
		 *查询邮件返回的结果
		 *
		 */
		private function mailDataComplete():void
		{
			model.mailDataList.source = model.mailListArr.source.slice();
		}

		/**
		 * 创建itemrender事件
		 * @param event
		 *
		 */
		private function onRenderCreate(event:ListEvent):void
		{
			event.itemRender.addEventListener(MouseEvent.CLICK, onClick);
		}

		/**
		 * 邮件列表的单击事件
		 * @param event
		 *
		 */
		private function onClick(event:MouseEvent):void
		{
			var guid:int = event.currentTarget.data.guid;
			model.guid = guid;
			//判断是否点击了多选框
			if (event.target is SimpleButton)
			{
				model.changeSelectState(guid); //改变选中状态
				_mailListPanel.cbox_selectAll.selected = model.checkSelectAll(pagedListView.pagedCollection.getPage(pagedListView.currentPage)); //全选框状态
				btnEnabled(); //删除邮件按钮状态
				return;
			}
			var mailInfo:MailInfo = model.getAndChangeMailState(guid);
			//未读邮件操作
//			if (tab_name == "mc_tab_unread")
//				_mailListPanel.mailList.selectedIndex = -1;
			//判断是否已经查询过邮件的具体内同
			if (mailInfo.sendContent == "")
			{
				service.sendRequestMailInfo(guid);
				return;
			}
			TWindowManager.instance.showPopup2(null, MailInfoPanel.NAME);
			signal.updateMailContent.dispatch(mailInfo);
		}

		/**
		 * 切换邮件分类处理
		 * @param event
		 *
		 */
		private function onCateChange(event:Event):void
		{
			var rbt:TRadioButton = event.currentTarget as TRadioButton;
			tab_name = rbt.name;
			if (!rbt.selected)
				return;
			switch (rbt.name)
			{
				case "mc_tab_all":
					model.mailDataList.source = model.mailListArr.source;
					break;
				case "rbt_system":
					model.mailDataList.source = model.getSysMail();
					break;
				case "mc_tab_personal":
					model.mailDataList.source = model.getMailByKind(MailInfo.MAIL_PERSONAL);
					break;
				case "mc_tab_read":
					model.mailDataList.source = model.getMailByRead(MailInfo.STATE_READ);
					break;
				case "mc_tab_unread":
					model.mailDataList.source = model.getMailByRead(MailInfo.STATE_UNREAD);
					break;
			}
			if (model.mailDataList.length != 0)
				_mailListPanel.cbox_selectAll.selected = model.checkSelectAll(pagedListView.pagedCollection.getPage(0));
			else
				_mailListPanel.cbox_selectAll.selected = false;
		}

		/**
		 * 全选
		 * @param event
		 *
		 */
		private function onChageState(event:Event):void
		{
			if (_mailListPanel.cbox_selectAll.selected)
				model.selectAll(pagedListView.pagedCollection..getPage(pagedListView.currentPage));
			else
				model.unSelectAll(pagedListView.pagedCollection..getPage(pagedListView.currentPage));
			btnEnabled(); //删除邮件按钮状态
		}

		/**
		 * 删除邮件
		 * @param e
		 *
		 */
		private function onDeleteMail(e:Event):void
		{
			if (model.findSelectMail() != null)
			{
				TAlertHelper.showDialog(2066, "你确定要删除所有指定邮件？（删除邮件将会失去所有附件，而且不能恢复）", true, TAlert.OK | TAlert.CANCEL, OnSureDeleteAll);
			}
		}

		private function OnSureDeleteAll(e:TAlertEvent):void
		{
			if (e.flag == TAlert.OK)
			{
				delOpenMailWindow();
				signal.mailDelete.dispatch(model.findSelectMail());
				if (_mailListPanel.cbox_selectAll.selected)
					_mailListPanel.cbox_selectAll.selected = false;
				btnEnabled();
			}
		}

		/**
		 * 删除打开邮件的窗口
		 *
		 */
		private function delOpenMailWindow():void
		{
			if (TWindowManager.instance.findPopup(MailInfoPanel.NAME))
			{
				var guid:int;
				for each (guid in model.findSelectMail())
				{
					if (guid == model.guid)
					{
						TWindowManager.instance.removePopupByName(MailInfoPanel.NAME);
					}
				}
			}
		}

		/**
		 * 删除邮件按钮状态
		 *
		 */
		private function btnEnabled():void
		{
			if (model.findSelectMail() == null)
			{
//				_mailListPanel.btn_openMail.enabled = false;
				_mailListPanel.btn_deleteMail.enabled = false;
			}
			else
			{
//				_mailListPanel.btn_openMail.enabled = true;
				_mailListPanel.btn_deleteMail.enabled = true;
			}
		}

		/**
		 * 翻页
		 * @param index
		 * @param oldPage
		 *
		 */
		private function onPageChanged(index:int, oldPage:int):void
		{
			if (model.mailDataList.length != 0)
				_mailListPanel.cbox_selectAll.selected = model.checkSelectAll(pagedListView.pagedCollection..getPage(index));
			else
				_mailListPanel.cbox_selectAll.selected = false;
			//翻页关闭邮件详细信息窗口
			TWindowManager.instance.removePopupByName(MailInfoPanel.NAME);
			//翻页时候默认没有选择项
			_mailListPanel.mailList.selectedIndex = -1;
		}

		private function onRemove(event:TabControllerEvent):void
		{
			_mailListPanel.rbt_all.select();
			_mailListPanel.rbt_all.removeEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_system.removeEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_personal.removeEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_read.removeEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.rbt_unread.removeEventListener(Event.CHANGE, onCateChange);
			_mailListPanel.pageController.curPage = 0;
			_mailListPanel.mailList.dataProvider = null;
		}
	}
}
