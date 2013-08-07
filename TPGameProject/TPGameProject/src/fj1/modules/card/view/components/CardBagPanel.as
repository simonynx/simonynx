package fj1.modules.card.view.components
{
	import assets.UIResourceLib;

	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.layoutDesign.LayoutDesignManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemQuality;
	import fj1.common.staticdata.LayoutDesignConst;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.modules.card.constants.CardType;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import tempest.common.rsl.RslManager;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.engine.graphics.avatar.Avatar;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TCheckBox;
	import tempest.ui.components.TFixedList;
	import tempest.ui.components.TGroup;
	import tempest.ui.components.TList;
	import tempest.ui.components.TPageController;
	import tempest.ui.components.TPagedListView;
	import tempest.ui.components.TProgressBar;
	import tempest.ui.components.TRadioButton;

	public class CardBagPanel extends BaseWindow
	{
		public static const NAME:String = "CardBagPanel";

		public var list:TList;

		///////////////////////////////////////////////

		public var typeGroup:TGroup;
		public var rbtn_typeAll:TRadioButton;
		public var rbtn_attack:TRadioButton;
		public var rbtn_defence:TRadioButton;
		public var rbtn_cure:TRadioButton;
		public var rbtn_balance:TRadioButton;
		public var rbtn_typeOther:TRadioButton;

		public var qualityGroup:TGroup;
		public var rbtn_qualityAll:TRadioButton;
		public var rbtn_qualityWhite:TRadioButton;
		public var rbtn_qualityGreen:TRadioButton;
		public var rbtn_qualityBlue:TRadioButton;
		public var rbtn_qualityPurple:TRadioButton;
		public var rbtn_qualityOringe:TRadioButton;

		public var sortGroup:TGroup;
		public var rbtn_sortAttack:TRadioButton;
		public var rbtn_sortLife:TRadioButton;

		///////////////////////////////////////////////
		public var viewModel:int;

		public function CardBagPanel(proxy:*)
		{
			super(LayoutDesignManager.getConstraintsByID(LayoutDesignConst.CARD_BAG), proxy, NAME);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			var container:* = _proxy.container;
			list = new TList(null, container.mc_list, container.scrollbar, CardBagItemRender, RslManager.getDefinition(UIResourceLib.CARD_BAG_ITEM_RENDER));

			typeGroup = new TGroup();
			rbtn_typeAll = createRadioBtn(typeGroup, container.rbtn_typeAll, -1);
			rbtn_attack = createRadioBtn(typeGroup, container.rbtn_attack, CardType.ATTACK);
			rbtn_defence = createRadioBtn(typeGroup, container.rbtn_defence, CardType.DEFENCE);
			rbtn_cure = createRadioBtn(typeGroup, container.rbtn_cure, CardType.CURE);
			rbtn_balance = createRadioBtn(typeGroup, container.rbtn_balance, CardType.BALANCE);
			rbtn_typeOther = createRadioBtn(typeGroup, container.rbtn_typeOther, CardType.OHTER);

			qualityGroup = new TGroup();
			rbtn_qualityAll = createRadioBtn(qualityGroup, container.rbtn_qualityAll, -1);
			rbtn_qualityWhite = createRadioBtn(qualityGroup, container.rbtn_qualityWhite, ItemQuality.QUALITY_0);
			rbtn_qualityGreen = createRadioBtn(qualityGroup, container.rbtn_qualityGreen, ItemQuality.QUALITY_1);
			rbtn_qualityBlue = createRadioBtn(qualityGroup, container.rbtn_qualityBlue, ItemQuality.QUALITY_2);
			rbtn_qualityPurple = createRadioBtn(qualityGroup, container.rbtn_qualityPurple, ItemQuality.QUALITY_3);
			rbtn_qualityOringe = createRadioBtn(qualityGroup, container.rbtn_qualityOringe, ItemQuality.QUALITY_4);

			sortGroup = new TGroup();
			rbtn_sortAttack = createRadioBtn(sortGroup, container.rbtn_sortAttack, "attack");
			rbtn_sortLife = createRadioBtn(sortGroup, container.rbtn_sortLife, "defence");
		}

		private function createRadioBtn(group:TGroup, proxy:*, data:Object):TRadioButton
		{
			var btn:TRadioButton = new TRadioButton(group, null, proxy, null, MovieClipResModel.MODEL_FRAME_2);
			btn.data = data;
			return btn;
		}
	}
}
