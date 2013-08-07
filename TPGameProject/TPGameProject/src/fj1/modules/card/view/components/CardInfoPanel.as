package fj1.modules.card.view.components
{
	import fj1.common.res.layoutDesign.LayoutDesignManager;
	import fj1.common.staticdata.LayoutDesignConst;
	import fj1.common.ui.BaseWindow;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import tempest.engine.graphics.avatar.Avatar;

	public class CardInfoPanel extends BaseWindow
	{
		public static const NAME:String = "CardInfoPanel";

		public var lbl_type:TextField;
		public var lbl_name:TextField;
		public var lbl_level:TextField;

		public var mc_star:MovieClip;
		public var lbl_cost:TextField;
		public var lbl_attack:TextField;
		public var lbl_life:TextField;

		private var _mc_avatar:MovieClip;
		private var _avatar:Avatar;

		public function CardInfoPanel(proxy:*)
		{
			super(LayoutDesignManager.getConstraintsByID(LayoutDesignConst.CARD_INFO), proxy, NAME);
		}

		override protected function addChildren():void
		{
			super.addChildren();

			var mc_role:* = _proxy.mc_role;

			lbl_type = mc_role.lbl_type;
			lbl_name = mc_role.lbl_name;
			lbl_level = mc_role.lbl_level;

			mc_star = mc_role.mc_star;
			lbl_cost = mc_role.lbl_cost;
			lbl_attack = mc_role.lbl_attack;
			lbl_life = mc_role.lbl_life;

			_mc_avatar = mc_role.mc_avatar;
		}

		public function set avatar(value:Avatar):void
		{
			if (_avatar == value)
			{
				return;
			}
			if (_avatar)
			{
				_avatar.dispose();
				_avatar.parent.removeChild(_avatar);
			}
			_avatar = value;
			if (_avatar)
			{
				_mc_avatar.addChild(_avatar);
			}
		}
	}
}
