package fj1.modules.formation.view.components
{
	import fj1.common.res.layoutDesign.LayoutDesignManager;
	import fj1.common.staticdata.LayoutDesignConst;
	import fj1.common.ui.BaseWindow;
	import flash.text.TextField;
	import tempest.ui.collections.TFixedLayoutItemHolder;
	import tempest.ui.components.TWindow;

	public class FormationPanel extends BaseWindow
	{
		public static const NAME:String = "FormationPanel";
		public var lbl_num:TextField;
		public var formationList:TFixedLayoutItemHolder;

		public function FormationPanel(_proxy:* = null)
		{
			super(LayoutDesignManager.getConstraintsByID(LayoutDesignConst.FORMATION), _proxy, NAME);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			formationList = new TFixedLayoutItemHolder(_proxy, FormationListItemRender, "mc_info");
			lbl_num = _proxy.lbl_num;
		}
	}
}
