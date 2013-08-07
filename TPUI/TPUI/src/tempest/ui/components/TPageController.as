package tempest.ui.components
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import org.osflash.signals.PrioritySignal;
	import org.osflash.signals.Signal;

	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.UIStyle;
	import tempest.ui.collections.TPagedListCollection;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.TPagedCollectionEvent;

	public class TPageController
	{
		private var _btn_first:SimpleButton;
		private var _btn_prev:SimpleButton;
		private var _btn_next:SimpleButton;
		private var _btn_last:SimpleButton;
		private var _lbl_pageIndex:TextField;
		private var _curPage:int;
		private var _maxPage:int;
		private var _pageSignal:PrioritySignal;
		private var _timer:TimerData;
		private var _pageHelperBind:TPagedListCollection;

		public function TPageController(proxy:* = null, btn_prev:SimpleButton = null, btn_next:SimpleButton = null, btn_first:SimpleButton = null, btn_last:SimpleButton = null, lbl_pageIndex:TextField =
			null)
		{
			_btn_prev = btn_prev ? btn_prev : !proxy ? null : proxy.hasOwnProperty("prev") ? proxy.prev : null;
			_btn_next = btn_next ? btn_next : !proxy ? null : proxy.hasOwnProperty("next") ? proxy.next : null;
			_btn_first = btn_first ? btn_first : !proxy ? null : proxy.hasOwnProperty("first") ? proxy.first : null;
			_btn_last = btn_last ? btn_last : !proxy ? null : proxy.hasOwnProperty("last") ? proxy.last : null;
			_lbl_pageIndex = lbl_pageIndex ? lbl_pageIndex : !proxy ? null : proxy.hasOwnProperty("lbl_pageIndex") ? proxy.lbl_pageIndex : null;
			_pageSignal = new PrioritySignal(int);
			if (_btn_first)
				_btn_first.addEventListener(MouseEvent.CLICK, onFristClick);
			if (_btn_prev)
				_btn_prev.addEventListener(MouseEvent.CLICK, onPrevClick);
			if (_btn_next)
				_btn_next.addEventListener(MouseEvent.CLICK, onNextClick);
			if (_btn_last)
				_btn_last.addEventListener(MouseEvent.CLICK, onLastClick);
			invalidate();
		}

		public function get btn_first():SimpleButton
		{
			return _btn_first;
		}

		public function get btn_prev():SimpleButton
		{
			return _btn_prev;
		}

		public function get btn_next():SimpleButton
		{
			return _btn_next;
		}

		public function get btn_last():SimpleButton
		{
			return _btn_last;
		}

		private function invalidate():void
		{
			if (!_timer)
				_timer = TimerManager.createNormalTimer(1, 1, null, null, onInvalidate);
		}

		public function get pageSignal():PrioritySignal
		{
			return _pageSignal;
		}

		private function onFristClick(event:MouseEvent):void
		{
			curPage = 0;
		}

		private function onPrevClick(event:MouseEvent):void
		{
			if (curPage <= 0)
				return;
			--curPage;
		}

		private function onNextClick(event:MouseEvent):void
		{
			if (curPage >= maxPage)
				return;
			++curPage;
		}

		private function onLastClick(event:MouseEvent):void
		{
			curPage = maxPage;
		}

		private function onInvalidate():void
		{
			if (_lbl_pageIndex)
				_lbl_pageIndex.text = (_maxPage >= 0 ? _curPage + 1 : 0) + "/" + (_maxPage + 1);
			setBtEnable(_btn_first, true);
			setBtEnable(_btn_prev, true);
			setBtEnable(_btn_next, true);
			setBtEnable(_btn_last, true);
			if (_curPage <= 0)
			{
				setBtEnable(_btn_first, false);
				setBtEnable(_btn_prev, false);
			}
			if (_curPage >= _maxPage)
			{
				setBtEnable(_btn_next, false);
				setBtEnable(_btn_last, false);
			}
			_timer = null;
		}

		private function setBtEnable(bt:SimpleButton, enabled:Boolean):void
		{
			if (!bt)
				return;
			bt.enabled = enabled;
			if (enabled)
			{
				bt.filters = null;
			}
			else
			{
				bt.filters = [UIStyle.disableFilter];
			}
		}

		/**
		 * 设置当前页（可指定是否触发pageSignal）
		 * @param value
		 * @param dispatch
		 *
		 */
		public function setCurPage(value:int, dispatch:Boolean = true):void
		{
			if (_curPage == value)
				return;
			var oldPage:int = _curPage;
			_curPage = value;
			invalidate();
			if (dispatch)
				_pageSignal.dispatch(_curPage, oldPage);
		}

		/**
		 * 当前页, 以0为索引起始
		 * @param value
		 *
		 */
		public function set curPage(value:int):void
		{
			setCurPage(value);
		}

		public function get curPage():int
		{
			return _curPage;
		}

		/**
		 * 总页数, 以0为索引起始
		 * @param value
		 *
		 */
		public function set maxPage(value:int):void
		{
			if (_maxPage == value)
				return;
			_maxPage = value;
			invalidate();
		}

		public function setMaxSize(value:int, pageSize:int):void
		{
//			if (value == 0)
//				maxPage = -1;
//			else
			maxPage = (value - 1) / pageSize;
		}

		public function get maxPage():int
		{
			return _maxPage;
		}

		/**
		 * 和TListCollectionPagingHelper绑定
		 * @param pageHelper
		 *
		 */
		public function bindListPageHelper(pageHelper:TPagedListCollection):void
		{
			if (_pageHelperBind)
			{
				_pageHelperBind.host.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
				_pageHelperBind.removeEventListener(TPagedCollectionEvent.HOST_CHANGE, onHostChange);
				pageSignal.remove(onPageChange);
			}
			_pageHelperBind = pageHelper;
			if (_pageHelperBind)
			{
				_pageHelperBind.host.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
				_pageHelperBind.addEventListener(TPagedCollectionEvent.HOST_CHANGE, onHostChange);
				pageSignal.addWithPriority(onPageChange, 1);
				setMaxSize(_pageHelperBind.host.length, _pageHelperBind.pageSize);
				curPage = _pageHelperBind.currentPage;
			}
			else
			{
				maxPage = 0;
				curPage = 0;
			}
		}

		/**
		 * TPagedListCollection变更host时触发，重新加上监听
		 * @param event
		 *
		 */
		private function onHostChange(event:TPagedCollectionEvent):void
		{
			if (event.oldValue)
			{
				IList(event.oldValue).removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			if (event.newValue)
			{
				IList(event.newValue).addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			if (_pageHelperBind.host)
			{
				setMaxSize(_pageHelperBind.host.length, _pageHelperBind.pageSize);
			}
			curPage = _pageHelperBind.currentPage;
		}

		private function onCollectionChange(e:CollectionEvent):void
		{
			switch (e.kind)
			{
				case CollectionEventKind.ADD:
				case CollectionEventKind.REMOVE:
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.RESET:
					setMaxSize(_pageHelperBind.host.length, _pageHelperBind.pageSize);
					curPage = _pageHelperBind.currentPage;
					break;
			}
		}

		private function onPageChange(curPage:int, oldPage:int):void
		{
			_pageHelperBind.currentPage = curPage;
		}
	}
}
