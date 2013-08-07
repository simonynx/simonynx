package fj1.modules.loading.controller
{
	import assets.CursorLib;
	import assets.EmbedRes;
	import assets.ResLib;
	import assets.UIResourceLib;
	import assets.UISkinLib;
	import fj1.common.GameInstance;
	import fj1.common.staticdata.IconSizeType;
	import fj1.common.staticdata.ToolTipName;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.animation.MovieClipAnimationRes;
	import fj1.common.ui.animation.QualityAniResMananger;
	import fj1.common.ui.animation.QualityAnimationRes;
	import fj1.common.ui.pools.IconBoxPool;
	import fj1.common.ui.pools.IconBoxPoolManager;
	import fj1.common.ui.styleSheet.DefaultStyleSheet;
	import fj1.common.ui.tips.LoaderCompareTip;
	import fj1.common.ui.tips.LoaderTip;
	import fj1.common.ui.tips.TCompareToolTip;
	import fj1.modules.chat.view.components.HornInputPanel;
	import fj1.modules.chat.view.components.MainChatPanel;
	import fj1.modules.item.view.components.HeroBagPanel;
	import fj1.modules.item.view.components.HeroDepotPanel;
	import fj1.modules.login.LoginFacade;
	import fj1.modules.main.MainFacade;
	import fj1.modules.mainUI.view.components.MainUI;
	import flash.display.DisplayObject;
	import tempest.common.mvc.base.Command;
	import tempest.common.rsl.RslManager;
	import tempest.common.staticdata.CursorPriority;
	import tempest.common.staticdata.StyleSheetType;
	import tempest.ui.CursorManager;
	import tempest.ui.StyleSheetManager;
	import tempest.ui.TToolTipManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TTextListItemRender;
	import tempest.ui.components.tips.TAutoWidthToolTip;
	import tempest.ui.components.tips.TRichTextToolTip;
	import tempest.ui.components.tips.TSimpleToolTip;

	public class LoadResCompleteCommand extends Command
	{
		public function LoadResCompleteCommand()
		{
			super();
		}

		override public function execute():void
		{
			this.facade.showdown();
//			MainFacade.instance.startup();
			var tipBkSkin:Class = RslManager.getDefinition(UISkinLib.tipSkin) as Class;
			initUIStyle();
			initQualityEffectRes();
			initCursor();
			initToolTip();
			initWindow();
			GameInstance.app.mainUI = new MainUI();
			IconBoxPoolManager.registerPool(IconSizeType.ICON36.toString(), new IconBoxPool(UISkinLib.itemMoveBoxSkin, IconSizeType.ICON36));
			IconBoxPoolManager.registerPool(IconSizeType.ICON72.toString(), new IconBoxPool(UISkinLib.itemMoveBoxSkin72, IconSizeType.ICON72));
			LoginFacade.instance.startup();
		}

		private function initUIStyle():void
		{
			UIStyle.tipBkSkin = RslManager.getDefinition(UISkinLib.tipSkin) as Class;
			UIStyle.menuBkSkin = RslManager.getDefinition(UISkinLib.menuBkSkin) as Class;
			UIStyle.alertSkin = RslManager.getDefinition(UISkinLib.alertSkin) as Class;
			UIStyle.scrollBar = RslManager.getDefinition(UISkinLib.scrollBarSkin) as Class;
			UIStyle.listItemSkin = RslManager.getDefinition(UISkinLib.simpleListItemSkin) as Class;
//			UIStyle.inputDialogSkin = TRslManager.getDefinition(UISkinLib.inputDialogSkin) as Class;
			UIStyle.textListItemRender = TTextListItemRender;
			UIStyle.loading = EmbedRes.loadingSkin;
			UIStyle.toolTip = new TSimpleToolTip(new UIStyle.tipBkSkin(), true, 20, 20, 0, false);
			UIStyle.htmlToolTip = new TSimpleToolTip(new UIStyle.tipBkSkin(), true, 20, 20, 0, true);
			UIStyle.fontName = "굴림";
		}

		private function initToolTip():void
		{
			StyleSheetManager.instance.registerStyleSheet(StyleSheetType.DEFAULT, new DefaultStyleSheet());
			TToolTipManager.instance.registerToolTip(ToolTipName.DEFAULT, UIStyle.toolTip);
			TToolTipManager.instance.registerToolTip(ToolTipName.DEFAULT_HTML, UIStyle.htmlToolTip);
			//			TToolTipManager.instance.registerToolTip(ToolTipName.COLLECT, UIStyle.toolTip);
			TToolTipManager.instance.registerToolTip(ToolTipName.RICHTEXT, new TRichTextToolTip(new UIStyle.tipBkSkin(), false, 4, 4, 200, StyleSheetManager.instance.getStyleSheet(StyleSheetType.DEFAULT)));
//			TToolTipManager.instance.registerToolTip(ToolTipName.COMPARE, new TCompareToolTip(new UIStyle.tipBkSkin(), new UIStyle.tipBkSkin(), false, 4, 4, 200, StyleSheetManager.instance.getStyleSheet(StyleSheetType.
//				DEFAULT)));
//			TToolTipManager.instance.registerToolTip(ToolTipName.TITLECOMPRE, new TitleTipCompareToolTip(new UIStyle.tipBkSkin(), new UIStyle.tipBkSkin(), false, 4, 4, 200, StyleSheetManager.instance.
//				getStyleSheet(StyleSheetType.DEFAULT)));
			TToolTipManager.instance.registerToolTip(ToolTipName.LOADER_TIP, new LoaderTip(new UIStyle.tipBkSkin(), false, 4, 4, 200, StyleSheetManager.instance.getStyleSheet(StyleSheetType.DEFAULT)));
//			TToolTipManager.instance.registerToolTip(ToolTipName.LOADER_COMPARE_TIP, new LoaderCompareTip(new UIStyle.tipBkSkin(), new UIStyle.tipBkSkin(), false, 4, 4, 200, StyleSheetManager.instance.
//				getStyleSheet(StyleSheetType.DEFAULT)));
			TToolTipManager.instance.registerToolTip(ToolTipName.AUTO_WIDTH, new TAutoWidthToolTip(new UIStyle.tipBkSkin(), true, 20, 20, true));
		}

		private function initQualityEffectRes():void
		{
			//初始化物品品质特效资源
			var qAniResMgr:QualityAniResMananger = QualityAniResMananger.getInstance();
			qAniResMgr.setRes(ResLib.QUALITY_EFFECT_PURPLE, new QualityAnimationRes(RslManager.getInstance(ResLib.QUALITY_EFFECT_PURPLE)));
			qAniResMgr.setRes(ResLib.QUALITY_EFFECT_YELLOW, new QualityAnimationRes(RslManager.getInstance(ResLib.QUALITY_EFFECT_YELLOW)));
			qAniResMgr.setRes(ResLib.QUALITY_EFFECT_RED, new QualityAnimationRes(RslManager.getInstance(ResLib.QUALITY_EFFECT_RED)));
			qAniResMgr.setRes(ResLib.QUALITY_FIRE_YELLOW, new MovieClipAnimationRes(RslManager.getInstance(ResLib.QUALITY_FIRE_YELLOW)));
			qAniResMgr.setRes(ResLib.QUALITY_FIRE_RED, new MovieClipAnimationRes(RslManager.getInstance(ResLib.QUALITY_FIRE_RED)));
		}

		/**
		 *初始化鼠标手型
		 *注册光标
		 */
		private function initCursor():void
		{
//			var areaObj:* = RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.AREA_ATTACK);
//			var unareaObj:* = RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.AREA_ATTACK);
//			(unareaObj as BitmapData).applyFilter(unareaObj, unareaObj.rect, SkillConst.ZERO_POINT, UIStyle.redFiliter);
//			var singleObj:* = RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.SINGLE_ATTACK);
//			var unsingleObj:* = RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.SINGLE_ATTACK);
//			unsingleObj.applyFilter(unsingleObj, unsingleObj.rect, SkillConst.ZERO_POINT, UIStyle.redFiliter);
			var cursorManager:CursorManager = CursorManager.instance;
//			cursorManager.registerCursor(CursorLib.AREA_ATTACK, areaObj, -areaObj.width * .5, -areaObj.height * .5, CursorPriority.ATTACK);
//			cursorManager.registerCursor(CursorLib.UN_AREA_ATTACK, unareaObj, -unareaObj.width * .5, -unareaObj.height * .5, CursorPriority.ATTACK);
//			cursorManager.registerCursor(CursorLib.SINGLE_ATTACK, singleObj, -singleObj.width * .5, -singleObj.height * .5, CursorPriority.ATTACK);
//			cursorManager.registerCursor(CursorLib.UN_SINGLE_ATTACK, unsingleObj, -unsingleObj.width * .5, -unsingleObj.height * .5, CursorPriority.ATTACK);
			cursorManager.registerCursor(CursorLib.TALK, RslManager.getInstance(CursorLib.TALK), 0, 0, CursorPriority.NORMAL); //对话图标
			cursorManager.registerCursor(CursorLib.SHOP_SELL, RslManager.getInstance(CursorLib.SELL), 0, 0, CursorPriority.DRAG); //售卖图标
			cursorManager.registerCursor(CursorLib.SPLIT_EQUIPMENT, RslManager.getInstance(CursorLib.SPLIT_EQUIPMENT), 0, 0, CursorPriority.DRAG); //售卖图标
			cursorManager.registerCursor(CursorLib.DEPOT, RslManager.getInstance(CursorLib.HAND), 0, 0, CursorPriority.DRAG); //仓库存取图标
			cursorManager.registerCursor(CursorLib.EQUIPMENT_GREEN, RslManager.getInstance(CursorLib.EQUIPMENT_GREEN), 0, 0, CursorPriority.DRAG); //绿品装备手势
			cursorManager.registerCursor(CursorLib.EQUIPMENT_BLUE, RslManager.getInstance(CursorLib.EQUIPMENT_BLUE), 0, 0, CursorPriority.DRAG); //蓝品装备手势
			cursorManager.registerCursor(CursorLib.EQUIPMENT_PURPLE, RslManager.getInstance(CursorLib.EQUIPMENT_PURPLE), 0, 0, CursorPriority.DRAG); //紫品装备手势
			cursorManager.registerCursor(CursorLib.EQUIPMENT_ORANGE, RslManager.getInstance(CursorLib.EQUIPMENT_ORANGE), 0, 0, CursorPriority.DRAG); //橙品装备手势
			cursorManager.registerCursor(CursorLib.EQUIPMENT_RED, RslManager.getInstance(CursorLib.EQUIPMENT_RED), 0, 0, CursorPriority.DRAG); //红品装备手势
//			var repairRes:DisplayObject = RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.REPAIR);
//			cursorManager.registerCursor(CursorLib.REPAIR, repairRes, 0, -repairRes.width * 0.5, CursorPriority.DRAG); //修理物品图标
			cursorManager.registerCursor(CursorLib.SCRATCH1, RslManager.getInstance(CursorLib.SCRATCH1), 0, 0, CursorPriority.NORMAL); //刮奖手势图标
			cursorManager.registerCursor(CursorLib.SCRATCH2, RslManager.getInstance(CursorLib.SCRATCH2), 0, 0, CursorPriority.NORMAL); //刮奖手势图标
			cursorManager.registerCursor(CursorLib.SCRATCH3, RslManager.getInstance(CursorLib.SCRATCH3), 0, 0, CursorPriority.NORMAL); //刮奖手势图标
			cursorManager.registerCursor(CursorLib.PACK, RslManager.getInstance(CursorLib.HAND), 0, 0, CursorPriority.DRAG); //打包手势图标
			cursorManager.registerCursor(CursorLib.SHOOTGAME, RslManager.getInstance(CursorLib.SHOOTGAME), 0, 0, CursorPriority.NORMAL);
			cursorManager.registerCursor(CursorLib.SIZE_CHANGE_HORIZON, RslManager.getInstance(CursorLib.SIZE_CHANGE_HORIZON), 0, 0, CursorPriority.UI_OPERATE); //窗口横向拉动图标
			cursorManager.registerCursor(CursorLib.SIZE_CHANGE_VERTICAL, RslManager.getInstance(CursorLib.SIZE_CHANGE_VERTICAL), 0, 0, CursorPriority.UI_OPERATE); //窗口纵向拉动图标
//			var corner:DisplayObject = RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.SIZE_CHANGE_CORNER);
//			corner.rotation = 90;
//			cursorManager.registerCursor(CursorLib.SIZE_CHANGE_CORNER, corner, 0, 0, CursorPriority.UI_OPERATE); //窗口斜向拉动图标
			cursorManager.registerCursor(CursorLib.COLLECT, RslManager.getInstance(CursorLib.HAND), 0, 0, CursorPriority.NORMAL); //收集
			//探索小游戏
//			cursorManager.registerCursor(CursorLib.EXPLORATION_BOMB, RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.EXPLORATION_BOMB), 0, 0, CursorPriority.DRAG); //炸弹手势
//			cursorManager.registerCursor(CursorLib.EXPLORATION_HOE, RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.EXPLORATION_HOE), 0, 0, CursorPriority.DRAG); //锄头手势
//			cursorManager.registerCursor(CursorLib.EXPLORATION_SHOVEL, RslMananger.getInstanceByName(CursorLib.libPath, CursorLib.EXPLORATION_SHOVEL), 0, 0, CursorPriority.DRAG); //铁铲手势
//			cursorManager.registerCursor(UIJarLib.HITJAR_HAMMER, RslMananger.getInstanceByName(UIJarLib.HITJAR_HAMMER), 0, 0, CursorPriority.DRAG); //锤子手势
		}

		private function initWindow():void
		{
			TWindowManager.instance.registerWindow2(new HeroBagPanel());
			TWindowManager.instance.registerWindow2(new HeroDepotPanel());
//			TWindowManager.instance.registerWindow2(new MiniFriendsPanel());
//			TWindowManager.instance.registerWindow2(new MainChatPanel());
//			TWindowManager.instance.registerWindow2(new HornInputPanel());
		}
	}
}
