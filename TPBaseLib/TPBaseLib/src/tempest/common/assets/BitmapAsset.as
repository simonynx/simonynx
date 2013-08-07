package tempest.common.assets
{
	import com.adobe.utils.DictionaryUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import tempest.common.assets.loading.TPLoader;

	public class BitmapAsset extends TPLoader
	{
		public var defaultBitmapData:BitmapData;
		private var _bitmapData:BitmapData = null;
		private var _url:String;
		public function BitmapAsset(url:String, loadNow:Boolean = true)
		{
			_url = url;
			super();
			if(loadNow)
				load(new URLRequest(url));
		}
		
		/**
		 * 如果当前不在加载中，则开始加载 
		 * 
		 */		
		public function checkLoad():void
		{
			if(!loading && !complete)
				load(new URLRequest(_url));
		}
		
		public function getBitmap():Bitmap
		{
			return new Bitmap(_bitmapData);
		}
		public function getBitmapData():BitmapData
		{
			return _bitmapData;
		}
		override protected function onCompleteHandler(e:Event):void
		{
			super.onCompleteHandler(e);
			e.currentTarget.removeEventListener(e.type,arguments.callee);
			if(content)
				_bitmapData = (content as Bitmap).bitmapData;
			else
				_bitmapData = defaultBitmapData;
		}
		/**
		 * 加载尝试失败 
		 * @param e
		 * 
		 */		
		override protected function onFailedHandler():void
		{
			super.onFailedHandler();
			//使用替代图片
			if(defaultBitmapData)
			{
				this.contentLoaderInfo.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}
}