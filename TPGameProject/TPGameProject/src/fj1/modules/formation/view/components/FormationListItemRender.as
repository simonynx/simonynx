package fj1.modules.formation.view.components
{
	import fj1.common.data.dataobject.Card;
	import fj1.common.staticdata.DragImagePlaces;
	import tempest.common.staticdata.CursorPriority;
	import tempest.engine.graphics.avatar.Avatar;
	import tempest.ui.CursorManager;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.events.DragEvent;

	public class FormationListItemRender extends TListItemRender
	{
		private var _avatar:Avatar;
		public var dragView:FormationDragView;

		public function FormationListItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
			this.dragAccpetPlaces = [DragImagePlaces.FORMATION, DragImagePlaces.CARD_BAG];
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_avatar = new Avatar(null);
			//
			dragView = new FormationDragView(_proxy);
			dragView.x = this.width / 2;
			dragView.y = this.height / 2 + 10;
			dragView.buttonMode = true;
			dragView.useDoubleClick = true;
			dragView.addEventListener(DragEvent.PICK_UP, onPickUp);
			this.addChild(dragView);
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			dragView.data = data;
			if (data)
			{
				//
				var card:Card = data as Card;
				_avatar = card.createAvatar();
				dragView.addChild(_avatar);
			}
			else
			{
				_avatar.removeAllAvatarPart();
			}
		}

		private function onPickUp(event:DragEvent):void
		{
			var dragView:FormationDragView = event.dragFrom as FormationDragView;
			dragView.setMouseSkinHandler = setDragMouseSkin;
		}

		private function setDragMouseSkin():void
		{
			var card:Card = data as Card;
			var avatar:Avatar = card.createAvatar();
			CursorManager.instance.setTempCursor(avatar, avatar.width / 2, avatar.height / 2, CursorPriority.DRAG);
//			CursorManager.instance.setTempCursor(avatar, -avatar.width / 2, -avatar.height / 2, CursorPriority.DRAG);
		}
	}
}
