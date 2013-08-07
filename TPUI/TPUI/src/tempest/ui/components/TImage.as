package tempest.ui.components
{
	import br.com.stimuli.loading.BulkLoader;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	import tempest.common.assets.BitmapAsset;
	import tempest.ui.Language;
	import tempest.ui.UIStyle;

	/**
	 * ...
	 * @author
	 */
	public class TImage extends TComponent
	{
		protected var _bitmap:Bitmap;
		protected var _loader:BitmapAsset;
		protected var _progresser:TLableProgressBar;
		protected var _isEmpty:Boolean;
		protected var _asset:BitmapAsset;
		protected var _defaultBitmapData:BitmapData;
		protected var _autoSize:Boolean;


		public function TImage(constraints:Object = null, _proxy:* = null, source:* = null)
		{
			super(constraints, _proxy);
			if (source)
				this.setSource(source);
		}

		override protected function addChildren():void
		{
			if (_proxy is Bitmap)
				_bitmap = _proxy;
			else
			{
				_bitmap = new Bitmap(UIStyle.defaultImageBk);
				if (_proxy)
				{
					_bitmap.width = _proxy.width;
					_bitmap.height = _proxy.height;
				}
				this.addChild(_bitmap);
				_proxy = _bitmap;
			}
		}

		public function empty():void
		{
			if (_isEmpty)
				return;
			endLoad();
			_bitmap.bitmapData; //.dispose();
			_bitmap.bitmapData = UIStyle.defaultImageBk;
			this.invalidateSize();
			_isEmpty = true;
		}

		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
		}

		public function setSource(val:*):void
		{
			if (!val || val == "")
			{
				this.empty();
				return;
			}
			endLoad();
			_bitmap.bitmapData; //.dispose();
			_bitmap.bitmapData = UIStyle.defaultImageBk;
			this.invalidateSize();
			_isEmpty = true;
			if (val is BitmapData)
			{
				_bitmap.bitmapData; //.dispose();
				_bitmap.bitmapData = val;
				this.invalidateSize();
				_isEmpty = false;
			}
			else if (val is Class)
			{
				var _data:Bitmap = new val() as Bitmap;
				if (_data)
				{
					_bitmap.bitmapData = _data.bitmapData;
					this.invalidateSize();
					_isEmpty = false;
				}
			}
			else if (val is String)
			{
				_asset = getBitmapAsset(val as String) as BitmapAsset;
				if (!_asset.defaultBitmapData)
					_asset.defaultBitmapData = _defaultBitmapData;
				if (_asset.complete)
					setRes(_asset.getBitmapData());
				else
				{
					_asset.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
					_asset.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
					if (!_progresser)
						_progresser = new TLableProgressBar({horizontalCenter: 0, verticalCenter: 0}, Language.LOADING);
					_progresser.value = 0;
					//确保进度条不影响图片宽度
					if (this.width != 0 && this.height != 0 &&
						(_progresser.x + _progresser.width > this.width || _progresser.y + _progresser.height > this.height))
					{
						_progresser.setSize(this.width - _progresser.x, this.height - _progresser.y);
					}
					addChild(_progresser);
				}
				_isEmpty = false;
			}
		}
		public static var caches:Dictionary = new Dictionary(); //动画资源缓存

		/**
		 * 位图资源
		 * @param url
		 * @param cached
		 * @return
		 */
		public static function getBitmapAsset(url:String, cached:Boolean = true, loadNow:Boolean = true):BitmapAsset
		{
			if (cached)
			{
				var asset:BitmapAsset = caches[url] as BitmapAsset;
				if (asset == null)
					asset = caches[url] = new BitmapAsset(url, loadNow);
				//				else
				//					asset.checkLoad();
				return asset;
			}
			else
				return BitmapAsset(url);
		}

		private function setRes(_b:BitmapData):void
		{
			_bitmap.bitmapData = _b;

			if (_autoSize)
			{
				//自动大小模式
				_bitmap.scaleX = 1;
				_bitmap.scaleY = 1;
				this.measureChildren(false, true);
			}
			else
			{
				this.invalidateSize();
			}
			_isEmpty = false;
			if (_progresser && _progresser.parent)
			{
				_progresser.parent.removeChild(_progresser);
			}
		}

		private function endLoad():void
		{
			if (_asset)
			{
				_asset.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
				_asset.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				if (_progresser && _progresser.parent)
				{
					_progresser.parent.removeChild(_progresser);
				}
			}
		}

		private function onProgressHandler(e:ProgressEvent):void
		{
			_progresser.value = e.bytesLoaded / e.bytesTotal;
		}

		private function onCompleteHandler(e:Event):void
		{
			setRes(_asset.getBitmapData());
			endLoad();
		}

		/**
		 * 默认资源路径（加载失败时出现）
		 * @param val
		 *
		 */
		public function set defaultSource(val:BitmapData):void
		{
			_defaultBitmapData = val;
		}

		override public function dispose():void
		{
			super.dispose();
			if (_loader)
				endLoad();
		}

		public function isLoading():Boolean
		{
			return _loader ? true : false;
		}

		public function isEmpty():Boolean
		{
			return _isEmpty;
		}

		//		public function isValid():Boolean
		//		{
		//			return !isLoading() && !isEmpty();
		//		}
		public function get bitmapData():BitmapData
		{
			return this._bitmap.bitmapData;
		}
	}
}
