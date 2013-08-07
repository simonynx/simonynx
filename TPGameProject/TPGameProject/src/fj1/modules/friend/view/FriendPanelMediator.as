package fj1.modules.friend.view
{
	import fj1.common.GameInstance;
	import fj1.common.helper.MenuHelper;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.FriendConst;
	import fj1.common.staticdata.MenuOperationType;
	import fj1.common.ui.MenuDataItem;
	import fj1.manager.MessageManager;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.model.vo.BlackInfo;
	import fj1.modules.friend.model.vo.EnemyInfo;
	import fj1.modules.friend.model.vo.FriendInfo;
	import fj1.modules.friend.service.FriendService;
	import fj1.modules.friend.signals.FriendSignal;
	import fj1.modules.friend.view.components.FriendPanel;
	import fj1.modules.newmail.signals.MailSignal;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.mvc.base.Mediator;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TListMenu;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TAlertEvent;
	import tempest.ui.events.TabControllerEvent;
	import tempest.utils.ListenerManager;

	public class FriendPanelMediator extends Mediator
	{
		private var _friendListRenderCreateSignal:NativeSignal;
		private var _blackListRenderCreateSignal:NativeSignal;
		private var _enemyListRenderCreateSignal:NativeSignal;
		[Inject]
		public var friendPanel:FriendPanel
		[Inject]
		public var friendModel:FriendModel;
		[Inject]
		public var friendSignal:FriendSignal;
		[Inject]
		public var service:FriendService;
		[Inject]
		public var chatModel:ChatModel;
		[Inject]
		public var mailSignal:MailSignal;
		private var _listenerManager:ListenerManager;

		public function FriendPanelMediator()
		{
			super();
			_listenerManager = new ListenerManager();
		}

		override public function onRegister():void
		{
			//总
			friendPanel.tabController.addEventListener(TabControllerEvent.CHANGE, onChange);
			friendPanel.tabController.selectedIndex = 0;
			changeViewState(0); //按钮状态判断
			_listenerManager.addEventListener(friendPanel.btn_friendAdd, MouseEvent.CLICK, onAddBtnClick);
			_listenerManager.addEventListener(friendPanel.btn_friendDel, MouseEvent.CLICK, onDelBtnClick);
			//好友
			_friendListRenderCreateSignal = new NativeSignal(friendPanel.friendList.friendList, ListEvent.ITEM_RENDER_CREATE, ListEvent);
			addSignal(_friendListRenderCreateSignal, onFriendRenderCreate);
			friendPanel.friendList.friendList.dataProvider = friendModel.getContainer(FriendConst.TYPE_FRIEND); //数据绑定
			//黑名单
			_blackListRenderCreateSignal = new NativeSignal(friendPanel.blackList.blackList, ListEvent.ITEM_RENDER_CREATE, ListEvent);
			addSignal(_blackListRenderCreateSignal, onBlackListRenderCreate);
			friendPanel.blackList.blackList.dataProvider = friendModel.getContainer(FriendConst.TYPE_BLACK); //数据绑定
			//仇人
			_enemyListRenderCreateSignal = new NativeSignal(friendPanel.enemyList.enemyList, ListEvent.ITEM_RENDER_CREATE, ListEvent);
			addSignal(_enemyListRenderCreateSignal, onEnamyListRenderCreate);
			friendPanel.enemyList.enemyList.dataProvider = friendModel.getContainer(FriendConst.TYPE_ENEMY); //数据绑定
		}

		override public function onRemove():void
		{
			friendPanel.friendList.friendList.dataProvider = null;
			friendPanel.blackList.blackList.dataProvider = null;
			friendPanel.enemyList.enemyList.dataProvider = null;
			_listenerManager.removeAll();
		}

		//--------------------------好友----------------------------------
		private function onFriendRenderCreate(event:ListEvent):void
		{
			event.itemRender.addEventListener(MouseEvent.CLICK, onMyClick);
		}

		private function onMyClick(e:MouseEvent):void
		{
			var render:TListItemRender = TListItemRender(e.currentTarget);
			MenuHelper.show(null, render, friendPanel, [MenuOperationType.VIEW_INFO,
				MenuOperationType.DEL,
				MenuOperationType.TEAM,
				MenuOperationType.CHAT,
				MenuOperationType.TRADE,
				MenuOperationType.INVITE,
				MenuOperationType.SEND_MAIL,
				MenuOperationType.MOVETO_BLACK], render.data, onMenuSelect);
			if (friendPanel.btn_friendDel.enabled == false)
			{
				friendPanel.btn_friendDel.enabled = true;
			}
		}

		protected function onMenuSelect(event:Event):void
		{
			var menu:TListMenu = TListMenu(event.currentTarget);
			var friendInfo:FriendInfo = FriendInfo(menu.data);
			switch ((menu.list.selectedItem as MenuDataItem).operateType)
			{
				case MenuOperationType.VIEW_INFO:
//					GameInstance.signal.attribute.queryPlayer.dispatch(friendInfo.id);
					break;
				case MenuOperationType.DEL:
					friendSignal.delFriendHandler.dispatch(friendInfo.id);
					changeViewState(friendPanel.tabController.selectedIndex);
					break;
				case MenuOperationType.TEAM:
//					GameInstance.signal.team.makeTeamSignal.dispatch(friendInfo.id, MakeTeamCommand.INVITE_KIND_OTHER);
					break;
				case MenuOperationType.CHAT:
					chatModel.setPrivateChatTarget(friendInfo.name);
					break;
				case MenuOperationType.INVITE:
//					GameInstance.signal.guild.inviterInGuild.dispatch(friendInfo.id);
					break;
				case MenuOperationType.TRADE:
//					if (!PlayerTradeStateManager.instance.trading)
//					{
//						GameClient.sendPlayerTradeRequest(friendInfo.id);
//					}
//					else
//					{
//						MessageManager.instance.addHintById_client(711, "交易状态下无法发起交易申请"); //交易状态下无法发起交易申请
//					}
					break;
				case MenuOperationType.SEND_MAIL:
					mailSignal.writeMailForChat.dispatch(friendInfo.name);
					break;
				case MenuOperationType.MOVETO_BLACK:
					TAlertHelper.showDialog(2017, "确定将这个好友移至黑名单", true, TAlert.YES | TAlert.NO, movetoHandler, TAlert.YES);
					break;
			}
		}

		//移到黑名单
		private function movetoHandler(event:TAlertEvent):void
		{
			if (event.flag == TAlert.YES)
			{
				//获取guid
				var friendInfo:FriendInfo = FriendInfo(friendPanel.friendList.friendList.selectedItem);
				//将好友移到黑名单
				service.sendFriendMoveToRequest(friendInfo.id);
			}
		}

		//--------------------------黑名单----------------------------------
		private function onBlackListRenderCreate(event:ListEvent):void
		{
			event.itemRender.addEventListener(MouseEvent.CLICK, onBlackClick);
		}

		protected function onMenuSelectBlack(event:Event):void
		{
			var menu:TListMenu = TListMenu(event.currentTarget);
			var blackInfo:BlackInfo = BlackInfo(menu.data);
			switch ((menu.list.selectedItem as MenuDataItem).operateType)
			{
				case MenuOperationType.VIEW_INFO:
//					GameInstance.signal.attribute.queryPlayer.dispatch(blackInfo.id);
					break;
				case MenuOperationType.DEL:
					friendSignal.delBlackHandler.dispatch(blackInfo.id);
					changeViewState(friendPanel.tabController.selectedIndex);
					break;
			}
		}

		private function onBlackClick(e:MouseEvent):void
		{
			if (friendPanel.btn_friendDel.enabled == false)
			{
				friendPanel.btn_friendDel.enabled = true;
			}
			var render:TListItemRender = TListItemRender(e.currentTarget);
			MenuHelper.show(null, render, friendPanel, [MenuOperationType.VIEW_INFO, MenuOperationType.DEL], render.data, onMenuSelectBlack);
		}

		//--------------------------仇人列表----------------------------------
		private function onEnamyListRenderCreate(event:ListEvent):void
		{
			event.itemRender.addEventListener(MouseEvent.CLICK, onEnemyClick);
		}

		protected function onMenuSelectEnemy(event:Event):void
		{
			var menu:TListMenu = TListMenu(event.currentTarget);
			var enemyInfo:EnemyInfo = EnemyInfo(menu.data);
			switch ((menu.list.selectedItem as MenuDataItem).operateType)
			{
				case MenuOperationType.VIEW_INFO:
//					GameInstance.signal.attribute.queryPlayer.dispatch(enemyInfo.id);
					break;
				case MenuOperationType.CHAT:
					chatModel.setPrivateChatTarget(enemyInfo.name);
					break;
				case MenuOperationType.DEL:
					friendSignal.delEnemyHandler.dispatch(enemyInfo.id, enemyInfo.name);
					changeViewState(friendPanel.tabController.selectedIndex);
					break;
				case MenuOperationType.VIEW_POS:
					friendSignal.enemyPosTrace.dispatch(enemyInfo.id, enemyInfo.online);
					break;
			}
		}

		private function onEnemyClick(e:MouseEvent):void
		{
			if (friendPanel.btn_friendDel.enabled == false)
			{
				friendPanel.btn_friendDel.enabled = true;
			}
			var render:TListItemRender = TListItemRender(e.currentTarget)
			MenuHelper.show(null, render, friendPanel, [MenuOperationType.VIEW_INFO, MenuOperationType.CHAT, MenuOperationType.DEL, MenuOperationType.VIEW_POS], render.data, onMenuSelectEnemy);
		}

		//--------------------------共同操作----------------------------------
		private function onChange(event:TabControllerEvent):void
		{
			changeViewState(friendPanel.tabController.selectedIndex);
		}

		private static function tabIndexToType(index:int):int
		{
			switch (index)
			{
				case 0:
					return FriendConst.TYPE_FRIEND;
				case 1:
					return FriendConst.TYPE_ENEMY;
				case 2:
					return FriendConst.TYPE_BLACK;
				default:
					return 0;
			}
		}

		//按钮状态判断
		private function changeViewState(index:int):void
		{
			friendModel.friendListState = tabIndexToType(index);
			switch (friendModel.friendListState)
			{
				case FriendConst.TYPE_FRIEND:
					friendPanel.friendList.friendList.selectedIndex = -1;
					friendPanel.btn_friendAdd.visible = true;
					friendPanel.btn_friendAdd.text = LanguageManager.translate(9002, "添加好友");
					friendPanel.btn_friendDel.text = LanguageManager.translate(100016, "删除");
					friendPanel.btn_friendDel.enabled = false;
					friendSignal.friendListQuery.dispatch();
					break;
				case FriendConst.TYPE_ENEMY:
					friendModel.delAllData(FriendConst.TYPE_ENEMY);
					friendPanel.enemyList.enemyList.selectedIndex = -1;
					friendPanel.btn_friendAdd.visible = true;
					friendPanel.btn_friendAdd.text = LanguageManager.translate(9016, "添加仇人");
					friendPanel.btn_friendDel.text = LanguageManager.translate(100016, "删除");
					friendPanel.btn_friendDel.enabled = false;
					service.sendEnmeyRequest();
					break;
				case FriendConst.TYPE_BLACK:
					friendPanel.blackList.blackList.selectedIndex = -1;
					friendPanel.btn_friendAdd.visible = true;
					friendPanel.btn_friendAdd.text = LanguageManager.translate(9003, "添加黑名单");
					friendPanel.btn_friendDel.text = LanguageManager.translate(9006, "清空");
					friendPanel.btn_friendDel.enabled = true;
					service.sendBlackRequest();
					break;
			}
//			friendPanel._btn_friendAdd.enabled = false;
		}

		/**
		 * 添加好友
		 * @param e
		 */
		private function onAddBtnClick(e:MouseEvent):void
		{
			friendSignal.showFindPanel.dispatch();
		}

		/**
		 * 删除好友
		 * @param e
		 */
		private function onDelBtnClick(e:MouseEvent):void
		{
			switch (friendModel.friendListState)
			{
				case FriendConst.TYPE_FRIEND:
					var friendInfo:FriendInfo = FriendInfo(friendPanel.friendList.friendList.selectedItem);
					friendSignal.delFriendHandler.dispatch(friendInfo.id);
					changeViewState(friendPanel.tabController.selectedIndex);
					break;
				case FriendConst.TYPE_BLACK:
					TAlertHelper.showDialog(2014, "确定清空黑名单", true, TAlert.YES | TAlert.NO, function(event:TAlertEvent):void
					{
						if (event.flag == TAlert.YES)
						{
							service.sendDelAll(FriendConst.TYPE_BLACK);
							changeViewState(friendPanel.tabController.selectedIndex);
						}
					});
					break;
				case FriendConst.TYPE_ENEMY:
					var enemyInfo:EnemyInfo = EnemyInfo(friendPanel.enemyList.enemyList.selectedItem);
					friendSignal.delEnemyHandler.dispatch(enemyInfo.id, enemyInfo.name);
					changeViewState(friendPanel.tabController.selectedIndex);
//					TAlertMananger.showAlert(9014, LanguageManager.translate(9014, "确定清空仇人列表"), true, TAlert.YES | TAlert.NO, function(event:TAlertEvent):void
//					{
//						if (event.flag == TAlert.YES)
//						{
//							GameInstance.signal.friend.delAllEnemyHandler.dispatch();
//							changeViewState(friendPanel.tabController.selectedIndex);
//						}
//					});
					break;
			}
		}
	}
}
