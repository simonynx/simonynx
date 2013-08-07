package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;

	import fj1.common.res.scroll.ScrollManager;
	import fj1.common.res.scroll.vo.ScrollInfo;
	import fj1.common.ui.BaseWindow;
	import tempest.ui.components.TPageController;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.events.TWindowEvent;

	public class ScrollPanelDialog extends BaseWindow
	{
		public static const NAME:String = "ScrollPanel";
		private var lbl_title:TextField; //标题
		private var lbl_content:TextField; //内容
		private var pageController:TPageController;
		private var pageControl:MovieClip;
		private var scrollID:int; //卷轴数据ID
		private var scrollArr:Array = []; //对应这个卷轴的数据

		public function ScrollPanelDialog()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_SCROLL), NAME);
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			lbl_title = _proxy.lbl_title;
			lbl_title.mouseEnabled = false;
			lbl_content = _proxy.lbl_content;
			lbl_content.mouseEnabled = false;
			pageControl = _proxy.mc_pageController;
			pageController = new TPageController(pageControl);
			scrollID = int(this.data);
			scrollArr = ScrollManager.getCurrentData(scrollID); //数组赋值
			pageController.maxPage = scrollArr.length - 1; //最大页数
			initData(); //初始时候赋值赋值
			pageController.pageSignal.add(onPageChanged);
		}

		//翻页监听
		private function onPageChanged(index:int, oldPage:int):void
		{
			initData(); //翻页时候赋值赋值
		}

		//初始或翻页时候赋值赋值
		private function initData():void
		{
			var scrollData:ScrollInfo;
			for each (scrollData in scrollArr)
			{
				if (pageController.curPage == scrollData.cur_page)
				{
					lbl_title.text = scrollData.title;
					lbl_content.htmlText = scrollData.content;
				}
			}
		}
	}
}
