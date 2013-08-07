package tempest.ui.components
{
	import tempest.ui.collections.TPagedListCollection;

	/**
	 * 为方便列表分页数据显示辅助类
	 * @author linxun
	 *
	 */
	public class TPagedListView
	{
		private var _list:*;
		private var _pagedCollection:TPagedListCollection;
		private var _pageController:TPageController;

		/**
		 *
		 * @param list 列表对象
		 * @param dataProvider 数据源
		 * @param pageSize 分页大小
		 * @param pageController 翻页控件
		 *
		 */
		public function TPagedListView(list:*, dataProvider:IList, pageSize:int, pageController:TPageController = null)
		{
			_list = list;
			_pagedCollection = new TPagedListCollection(dataProvider, pageSize);
			_pageController = pageController;
			if (_pageController)
			{
				_pageController.bindListPageHelper(_pagedCollection);
			}
			_list.dataProvider = _pagedCollection.pagedCollection;
		}

		/**
		 * 分页数据容器
		 * @return
		 *
		 */
		public function get pagedCollection():TPagedListCollection
		{
			return _pagedCollection;
		}

		/**
		 * 每页长度
		 * @param value
		 *
		 */
		public function set pageSize(value:int):void
		{
			_pagedCollection.pageSize = value;
		}

		public function get pageSize():int
		{
			return _pagedCollection.pageSize;
		}

		/**
		 * 当前页号（从0开始）
		 * @param value
		 *
		 */
		public function set currentPage(value:int):void
		{
			if (_pageController)
			{
				_pageController.curPage = value;
			}
			else
			{
				_pagedCollection.currentPage = value;
			}
		}

		public function get currentPage():int
		{
			return _pagedCollection.currentPage;
		}

		/**
		 * 最大页号（从0开始）
		 * @return
		 *
		 */
		public function get maxPage():int
		{
			return _pagedCollection.maxPage;
		}

		public function get list():*
		{
			return _list;
		}

		/**
		 * 数据源
		 * @param value
		 *
		 */
		public function set dataProvider(value:IList):void
		{
			_pagedCollection.host = value;
		}

		public function get dataProvider():IList
		{
			return _pagedCollection.host;
		}
	}
}
