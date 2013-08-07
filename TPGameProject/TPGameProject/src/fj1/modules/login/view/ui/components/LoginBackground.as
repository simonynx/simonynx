package fj1.modules.login.view.ui.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import org.osflash.signals.natives.base.SignalLoader;
	import tempest.common.logging.*;
	import tempest.ui.components.TComponent;

	public class LoginBackground extends TComponent
	{
		private static const log:ILogger = TLog.getLogger(LoginBackground);
		public static const SCROLL_SPEED:int = 1; //滚动速度
		private var _bitmaps:Vector.<Bitmap>;
		////////////////////////////////
		private var _bm_width:Number = 0;
		private var _bm_height:Number = 0;
		private var _leftBound:Number = 0;
		private var _rect:Rectangle = new Rectangle();

		public function LoginBackground(constraints:Object = null, proxy:* = null)
		{
			super(constraints, proxy);
		}
		//=================================资源加载===================================================
		private var _loader:SignalLoader;
		private var _remainLoadCount:int;
		private var _url:String;
		private var _complate:Boolean = false;

		public function load(url:String, autoRun:Boolean = true):void
		{
			_url = url;
			if (_loader == null)
			{
				_remainLoadCount = 3;
				_loader = new SignalLoader();
				_loader.signals.complete.addOnce(onLoadCompleteHandler);
				_loader.signals.ioError.add(onLoadErrorHandler);
			}
			_loader.load(new URLRequest(url));
		}

		private function onLoadCompleteHandler(e:Event):void
		{
			var bd:BitmapData = Bitmap(LoaderInfo(e.target).content).bitmapData;
			_loader.signals.removeAll();
			_loader.unload();
			_loader = null;
			_bm_width = bd.width;
			_bm_height = bd.height;
			_rect.width = _bm_width * 2;
			_rect.height = _bm_height;
			_leftBound = (_rect.width - _bm_width) * 0.5;
			_rect.x = (this.width - _rect.width) * 0.5;
			_rect.y = (this.height - _rect.height) * 0.5;
			_bitmaps = new Vector.<Bitmap>(2, true)
			_bitmaps[0] = new Bitmap(bd);
			_bitmaps[0].x = _rect.x;
			_bitmaps[0].y = _rect.y;
			_bitmaps[1] = new Bitmap(bd);
			_bitmaps[1].x = _rect.x + _bm_width;
			_bitmaps[1].y = _rect.y;
			this.addChild(_bitmaps[0]);
			this.addChild(_bitmaps[1]);
			_complate = true;
			this.signals.enterFrame.add(onTick);
		}

		private function onLoadErrorHandler(e:IOErrorEvent):void
		{
			if (_remainLoadCount > 0)
			{
				_remainLoadCount--;
				load(_url);
				return;
			}
			_loader.signals.removeAll();
			_loader.unload();
			_loader = null;
			log.error("加载失败 url:" + _url);
		}

		override public function dispose():void
		{
			if (_loader)
			{
				_loader.signals.removeAll();
				_loader.unload();
				_loader = null;
			}
			if (_complate)
			{
				this.signals.enterFrame.remove(onTick);
				_bitmaps[0].bitmapData.dispose();
				_bitmaps = null;
				_complate = false;
			}
			super.dispose();
		}

		////////////////////////////////图片管理//////////////////////////////////////////
		public override function invalidateSize(changed:Boolean = false):void
		{
			super.invalidateSize();
			if (!_complate)
				return;
			//调整位置
			var dx:Number;
			var old_x:Number = _rect.x;
			_rect.x = (this.width - _rect.width) * 0.5;
			_rect.y = (this.height - _rect.height) * 0.5;
			dx = _rect.x - old_x;
			_bitmaps[0].x += dx;
			_bitmaps[1].x += dx;
			_bitmaps[0].y = _bitmaps[1].y = _rect.y;
		}

		private function onTick(e:Event):void
		{
			if (!_complate)
				return;
			_bitmaps[0].x -= SCROLL_SPEED;
			_bitmaps[1].x -= SCROLL_SPEED;
			if (_bitmaps[0].x + _bm_width < _rect.x + _leftBound)
			{
				_bitmaps[0].x = _bitmaps[1].x + _bm_width;
				var bm:Bitmap = _bitmaps[0];
				_bitmaps[0] = _bitmaps[1];
				_bitmaps[1] = bm;
			}
		}
	}
}
