package fj1.modules.card.view.components
{
	import fj1.common.data.dataobject.Card;
	import fj1.common.data.dataobject.CardConst;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.ui.boxes.BaseDataBox;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import tempest.common.staticdata.CursorPriority;
	import tempest.common.staticdata.MouseOperatePriority;
	import tempest.common.staticdata.MouseOperatorType;
	import tempest.ui.CursorManager;
	import tempest.ui.DragManager;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.interfaces.IDragable;

	public class CardBagItemRender extends TListItemRender implements IDragable
	{
		private var _dropBackAreaArray:Array; //拖放放下后，会自动回到原处的范围，范围内不会触发DragEvent.DROP_OUT事件
		private var _dropOutTarget:InteractiveObject;
		private var _pickUpEnable:Boolean = true; //是否开启拾取
		private var _place:int; //标记图片所在的逻辑地点，方便逻辑判断
		private var _bePickedUp:Boolean;
		private var _setMouseSkinHandler:Function;
		private var _mc_flag:Sprite;
		////////////////////////////////////////////////////////////////////
		public var box:BaseDataBox;
		public var lbl_name:TextField;
		public var lbl_life:TextField;
		public var lbl_attack:TextField;
		public var lbl_level:TextField;

		public function CardBagItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
			this.place = DragImagePlaces.CARD_BAG;
			this.pickUpEnable = true;
			this.setMouseSkinHandler = dragSkinHandler;
		}

		private function dragSkinHandler():void
		{
			var card:Card = this.data as Card;
			if (card)
			{
				CursorManager.instance.setTempCursor(card.createAvatar(), 0, 0, CursorPriority.DRAG);
			}
		}

		override protected function addChildren():void
		{
			super.addChildren();
			box = new BaseDataBox(_proxy.mc_item);
			box.pickUpEnabled = false;
			lbl_name = _proxy.lbl_name;
			lbl_life = _proxy.lbl_life;
			lbl_attack = _proxy.lbl_attack;
			lbl_level = _proxy.lbl_level;
			_mc_flag = _proxy.mc_flag;
		}

		override public function set data(value:Object):void
		{
			_changeWatcherManger.unWatchAll();
			super.data = value;
			var card:Card = data as Card;
			if (card)
			{
				box.data = card;
				lbl_name.text = card.name;
				lbl_life.text = card.healthMax.toString();
				lbl_attack.text = card.attack.toString();
				lbl_level.text = card.level.toString();
				_changeWatcherManger.bindSetter(bindState, card, "state");
			}
			else
			{
				box.data = null;
				lbl_name.text = "";
				lbl_life.text = "";
				lbl_attack.text = "";
				lbl_level.text = "";
			}
		}

		public function bindState(state:int):void
		{
			if (state == CardConst.FIGHT)
				_mc_flag.visible = true;
			else
				_mc_flag.visible = false;
		}

		public function set bePickedUp(value:Boolean):void
		{
			_bePickedUp = value;
		}

		public function get bePickedUp():Boolean
		{
			return _bePickedUp;
		}

		public function get dropBackAreaArray():Array
		{
			return _dropBackAreaArray;
		}

		public function get dropOutTarget():InteractiveObject
		{
			return _dropOutTarget;
		}

		public function isEmpty():Boolean
		{
			return !data;
		}

		public function get pickUpEnable():Boolean
		{
			return _pickUpEnable;
		}

		public function set pickUpEnable(value:Boolean):void
		{
			if (value)
			{
				DragManager.dragable(this);
			}
			else
			{
				DragManager.unDragable(this);
			}
			_pickUpEnable = value;
		}

		public function get place():int
		{
			return _place;
		}

		public function set place(value:int):void
		{
			_place = value;
		}

		public function set setMouseSkinHandler(value:Function):void
		{
			_setMouseSkinHandler = value;
		}

		public function get setMouseSkinHandler():Function
		{
			return _setMouseSkinHandler;
		}

		public function get type():int
		{
			return MouseOperatorType.DRAG;
		}

		public function cancelOperate():void
		{
			DragManager.cancelDrag();
		}

		public function get priority():int
		{
			return MouseOperatePriority.DRAG_DROP;
		}
	}
}
