package fj1.modules.friend.view
{
	import fj1.common.GameInstance;
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.FriendConst;
	import fj1.common.staticdata.Profession;
	import fj1.manager.MessageManager;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.signals.FriendSignal;
	import fj1.modules.friend.view.components.FindPanel;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.mvc.base.Mediator;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TAlertEvent;
	import tempest.utils.StringUtil;

	/**
	 * ...
	 * @author ...
	 */
	public class FindPanelMediator extends Mediator
	{
		public function FindPanelMediator()
		{
			super();
		}
		[Inject]
		public var view:FindPanel
		[Inject]
		public var model:FriendModel;
		[Inject]
		public var signal:FriendSignal;

		override public function onRegister():void
		{
			//限制输入长度
			view.tf_search.byteLimitModel(21);
			view.btn_friendAdd.enabled = false;
			view.tf_search.text = "";
			model.save_input_word = "";
			initFindText();
			switch (model.friendListState)
			{
				case (FriendConst.TYPE_BLACK):
					view.btn_friendAdd.text = LanguageManager.translate(9003, "添加黑名单");
					break;
				case (FriendConst.TYPE_ENEMY):
					view.btn_friendAdd.text = LanguageManager.translate(9016, "添加仇人");
					break;
				case (FriendConst.TYPE_FRIEND):
					view.btn_friendAdd.text = LanguageManager.translate(9002, "添加好友");
					break;
				case (FriendConst.TYPE_TEAM):
					view.btn_friendAdd.text = LanguageManager.translate(9121, "邀请入队");
					break;
			}
			addSignal(view.addFri, addFriHandler);
			addSignal(view.searchFri, searchFriHandler);
			addSignal(signal.findPlayerData, setInitializeData);
			addSignal(signal.cannotFindPlayer, cannotFindPlayer);
		}

		/**
		 * 找不到玩家
		 */
		private function cannotFindPlayer():void
		{
			MessageManager.instance.addHintById_client(2018, "查无此人");
			view.btn_friendAdd.enabled = false;
			initFindText();
		}

		/**
		 * 找到玩家显示
		 */
		private function setInitializeData():void
		{
			view.lbl_name.text = model.findInfo.name;
			view.lbl_level.text = String(model.findInfo.level);
			view.lbl_pro.text = Profession.getName(model.findInfo.profession);
			if (model.findInfo.power != 0)
				view.lbl_power.text = String(model.findInfo.power);
			else
				view.lbl_power.text = LanguageManager.translate(50452, "暂未获得神力");
			view.lbl_state.text = model.findInfo.online == 1 ? LanguageManager.translate(9010, "在线") : LanguageManager.translate(9011, "离线");
			view.btn_friendAdd.enabled = true;
		}

		private function initFindText():void
		{
			view.lbl_name.text = "";
			view.lbl_level.text = "";
			view.lbl_pro.text = "";
			view.lbl_power.text = "";
			view.lbl_state.text = "";
		}

		//按钮状态
		private function onMyClick(e:MouseEvent):void
		{
			if (view.btn_friendAdd.enabled == false)
				view.btn_friendAdd.enabled = true;
		}

		//去空格
		public function trim(s:String):String
		{
			return s.replace(/([ ]{1})/g, "");
		}

		//查找好友
		private function searchFriHandler(e:Event):void
		{
			view.tf_search.text = trim(view.tf_search.text)
//			initFindText();
			signal.findPlayer.dispatch(view.tf_search.text);
		}

		/**
		 * 添加好友
		 * @param e
		 */
		private function addFriHandler(e:Event):void
		{
			switch (model.friendListState)
			{
				case (FriendConst.TYPE_BLACK):
					//添加黑名单
					signal.addBlack.dispatch(model.findInfo.guid);
					break;
				case (FriendConst.TYPE_ENEMY):
					//添加仇人
					signal.addEnemy.dispatch(model.findInfo.guid);
					break;
				case (FriendConst.TYPE_FRIEND):
					if (model.findInfo.online != 1)
					{
						MessageManager.instance.addHintById_client(717, "对方不在线");
						return;
					}
					//添加好友
					signal.addFriendHandler.dispatch(model.findInfo.guid);
					break;
				case (FriendConst.TYPE_TEAM):
//					GameInstance.signal.team.makeTeamSignal.dispatch(friendModel.findInfo.guid, MakeTeamCommand.INVITE_KIND_NEAR);
					break;
			}
		}
	}
}
