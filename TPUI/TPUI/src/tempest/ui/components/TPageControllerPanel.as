package tempest.ui.components
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.ui.UIStyle;

	public class TPageControllerPanel extends TComponent
	{
		private var _pageController:TPageController;

		public function TPageControllerPanel(constraints:Object = null, _proxy:* = null, btn_prev:SimpleButton = null, btn_next:SimpleButton = null, btn_first:SimpleButton = null, btn_last:SimpleButton =
			null, lbl_pageIndex:TextField = null)
		{
			super(constraints, _proxy);
			_pageController = new TPageController(_proxy, btn_prev, btn_next, btn_first, btn_last, lbl_pageIndex);
		}

		public function get pageSignal():Signal
		{
			return _pageController.pageSignal;
		}

		public function setCurPage(value:int, dispatch:Boolean = true):void
		{
			_pageController.setCurPage(value, dispatch);
		}

		public function set curPage(value:int):void
		{
			_pageController.curPage = value;
		}

		public function get curPage():int
		{
			return _pageController.curPage;
		}

		/**
		 * 以0为索引起始
		 * @param value
		 *
		 */
		public function set maxPage(value:int):void
		{
			_pageController.maxPage = value;
		}

		public function setMaxSize(value:int, pageSize:int):void
		{
			_pageController.setMaxSize(value, pageSize);
		}

		public function get maxPage():int
		{
			return _pageController.maxPage;
		}
	}
}
