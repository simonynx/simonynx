package tempest.ui.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.events.PropertyChangeEvent;

	import tempest.ui.components.IList;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.TPagedCollectionEvent;

	public class TPagedListCollection extends EventDispatcher
	{
		private var _maxPage:int;
		protected var _pageSize:int;
		private var _currentPage:int;
		private var _validateCurrentPage:Boolean;

		protected var _host:IList;
		protected var _pagedCollection:IList = new TArrayList(null);

		public function TPagedListCollection(host:IList, pageSize:int = 0, validateCurrentPage:Boolean = true)
		{
			super(this);
			_validateCurrentPage = validateCurrentPage;
			_host = host;
			if (_host)
			{
				_host.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			this.pageSize = pageSize;
		}

		private function onCollectionChange(event:CollectionEvent):void
		{
			var min:int;
			var max:int;
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
					min = _currentPage * _pageSize;
					max = Math.min(min + _pageSize - 1, _host.length - 1);
					if (event.location >= min && event.location <= max)
					{
						if (_pagedCollection.length == _pageSize)
						{
							_pagedCollection.removeItemAt(_pageSize - 1);
						}
						_pagedCollection.addItemAt(event.items[0], event.location - _currentPage * _pageSize);
					}
					break;
				case CollectionEventKind.REMOVE:
					min = _currentPage * _pageSize;
					max = min + _pageSize - 1;
					if (event.location >= min && event.location <= max)
					{
						//修改索引落在当前页范围内
						_pagedCollection.removeItemAt(event.location - _currentPage * _pageSize);
						if (_pagedCollection.length == _pageSize - 1 && _host.length >= min + _pageSize)
						{
							_pagedCollection.addItem(_host.getItemAt(min + _pageSize - 1));
						}
					}
					updateMaxPage();
					if (_pagedCollection.length == 0 && _host.length != 0)
					{
						reflashPage();
					}
					break;
				case CollectionEventKind.RESET:
				case CollectionEventKind.REFRESH:
//					_currentPage = 0;
					updateMaxPage();
					reflashPage();
					break;
				case CollectionEventKind.REPLACE:
					if (_pageSize != 0 && (event.location >= _currentPage * _pageSize && event.location <= getPageMaxLen(_currentPage) - 1))
					{
						_pagedCollection.setItemAt((event.items[0] as PropertyChangeEvent).newValue, event.location - _currentPage * _pageSize);
					}
					break;
			}
		}

		public function get host():IList
		{
			return _host;
		}

		public function set host(value:IList):void
		{
			if (_host == value)
			{
				return;
			}
			if (_host)
			{
				_host.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			var oldValue:IList = _host;
			_host = value;
			if (_host)
			{
				_host.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			_currentPage = 0;
			reflashPage();
			dispatchEvent(new TPagedCollectionEvent(TPagedCollectionEvent.HOST_CHANGE, oldValue, _host));
		}

		public function get pagedCollection():IList
		{
			return _pagedCollection;
		}

		public function getPage(pageIndex:int):Array
		{
			if (_pageSize <= 0)
				return null;
			var newItems:Array = [];
			var maxLen:int = getPageMaxLen(pageIndex);
			for (var i:int = pageIndex * _pageSize; i <= maxLen - 1; ++i)
			{
				newItems.push(_host.getItemAt(i));
			}
			return newItems;
		}

		protected function reflashPage():void
		{
			var newItems:Array = getPage(_currentPage);
			(_pagedCollection as TArrayList).source = newItems;
		}

		private function getPageMaxLen(pageIndex:int):int
		{
			if (!_host)
			{
				return 0;
			}
			else
			{
				return (pageIndex + 1) * _pageSize >= _host.length ? _host.length : (pageIndex + 1) * _pageSize;
			}

		}

		private function updateMaxPage():void
		{
			if (_pageSize <= 0)
				return;
			_maxPage = !_host ? 0 : _host.length == 0 ? 0 : (_host.length - 1) / _pageSize;
			if (_validateCurrentPage && _currentPage > _maxPage)
				_currentPage = _maxPage;
		}

		/**
		 * 每页长度（必须设置一次）
		 * @param value
		 *
		 */
		public function set pageSize(value:int):void
		{
			_pageSize = value;
			updateMaxPage();
			reflashPage();
		}

		public function get pageSize():int
		{
			return _pageSize;
		}

		/**
		 * 当前页
		 * @param value
		 *
		 */
		public function set currentPage(value:int):void
		{
			_currentPage = value;
			if (_currentPage < 0)
			{
				_currentPage = 0;
			}
			reflashPage();
		}

		public function get currentPage():int
		{
			return _currentPage;
		}

		public function get maxPage():int
		{
			return _maxPage;
		}
	}
}
