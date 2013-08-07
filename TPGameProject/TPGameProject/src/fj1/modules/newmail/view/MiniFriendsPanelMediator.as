package fj1.modules.newmail.view
{
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.components.MiniFriListItemRender;
	import fj1.modules.newmail.view.components.MiniFriendsPanel;
	import flash.events.MouseEvent;
	import tempest.common.mvc.base.Mediator;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.ListEvent;
	import tempest.utils.ListenerManager;

	public class MiniFriendsPanelMediator extends Mediator
	{
		[Inject]
		public var view:MiniFriendsPanel;
		[Inject]
		public var signal:MailSignal;
		private var _listenerManager:ListenerManager;
		private var _saveFriendName:String = "";

		public function MiniFriendsPanelMediator()
		{
			super();
			_listenerManager = new ListenerManager();
		}

		public override function onRegister():void
		{
			if (_saveFriendName == "")
				view.btn_sure.enabled = false;
			else
				view.btn_sure.enabled = true;
			_listenerManager.addEventListener(view.btn_sure, MouseEvent.CLICK, onClick);
			_listenerManager.addEventListener(view.btn_cancel, MouseEvent.CLICK, onClick);
			view.friendList.addEventListener(ListEvent.ITEM_RENDER_CREATE, onRenderCreate);
//			view.friendList.dataProvider = GameInstance.model.friend.getContainer(FriendConst.TYPE_FRIEND);
		}

		private function onRenderCreate(event:ListEvent):void
		{
			event.itemRender.addEventListener(MouseEvent.CLICK, onMyClick);
		}

		private function onMyClick(e:MouseEvent):void
		{
			_saveFriendName = MiniFriListItemRender(e.currentTarget).lbl_name.text;
			view.btn_sure.enabled = true;
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case view.btn_sure:
					signal.miniFriName.dispatch(_saveFriendName);
					break;
				case view.btn_cancel:
					break;
			}
			view.closeWindow();
		}

		public override function onRemove():void
		{
			_listenerManager.removeAll();
			_saveFriendName = "";
		}
	}
}
