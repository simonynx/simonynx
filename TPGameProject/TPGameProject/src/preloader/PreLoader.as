package preloader
{
	import assets.EmbedRes;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PreLoader extends MovieClip
	{
		private var txt_progress:TextField;
		private var txt_debug:TextField;

		private const SHOW_LOGO:Boolean = false;

		public function PreLoader()
		{
			super();
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.quality = StageQuality.HIGH;
			}

			//加载进度textField
			txt_progress = createProgressTF();
			txt_progress.text = "0%";
			txt_progress.x = (stage.stageWidth - txt_progress.width) * 0.5;
			txt_progress.y = (stage.stageHeight - txt_progress.height) * 0.5;
			this.addChild(txt_progress);

			//debug
			txt_debug = createDebugTF();
			txt_debug.x = (stage.stageWidth - txt_debug.width) * 0.5;
			txt_debug.y = stage.stageHeight - txt_debug.height;
			this.addChild(txt_debug);

			//事件监听
			loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			stage.addEventListener(Event.RESIZE, onStageResize);


			//获取网页参数
//			debugPrint("网页参数:");
//			var params:Object = root.loaderInfo.parameters;
//			for (var key:String in params)
//			{
//				debugPrint(key + "=" + params[key]);
//			}
		}

		private function createProgressTF():TextField
		{
			var tf:TextField = new TextField();
			tf.width = 300;
			tf.defaultTextFormat = new TextFormat("宋体", 12, 0x00FFFF);
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.selectable = false;
			tf.mouseEnabled = false;
			return tf;
		}

		private function createDebugTF():TextField
		{
			var tf:TextField = new TextField();
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = 300;
			tf.height = 200;
			tf.defaultTextFormat = new TextFormat("宋体", 12, 0x00FFFF);
			tf.selectable = false;
			tf.mouseEnabled = false;
			return tf;
		}

		private function debugPrint(str:String):void
		{
			txt_debug.appendText(str + "\n");
		}

		/**
		 * 显示logo
		 *
		 */
		private function showLogo():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var mc:MovieClip = loader.content as MovieClip;
				var onResize:Function = function(e:Event):void
				{
					mc.x = (stage.stageWidth - 800) * 0.5;
					mc.y = (stage.stageHeight - 600) * 0.5;
				}
				stage.addEventListener(Event.RESIZE, onResize);
				onResize(null);
				addChild(mc);
				mc.addFrameScript(mc.totalFrames - 1, function():void
				{
					stage.removeEventListener(Event.RESIZE, onResize);
					mc.stop();
					removeChild(mc);
					loader.unload();
					startup(); //添加主应用程序
				});
				mc.gotoAndPlay(1);
			});
			loader.loadBytes(new (EmbedRes.logo)());
		}

		private function onStageResize(_arg1:Event):void
		{
			txt_progress.x = (stage.stageWidth - txt_progress.width) * 0.5;
			txt_progress.y = (stage.stageHeight - txt_progress.height) * 0.5;
		}


		private function onLoadComplete(e:Event):void
		{
			//
			this.removeChild(txt_progress);

			//
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			stage.removeEventListener(Event.RESIZE, onStageResize);

			//logo
			if (SHOW_LOGO)
			{
				showLogo();
			}
			else
			{
				startup(); //添加主应用程序
			}
		}

		private function onLoadProgress(e:ProgressEvent):void
		{
			txt_progress.text = int(e.bytesLoaded / e.bytesTotal * 100) + "%";
		}

		private function onIoError(e:IOErrorEvent):void
		{
			trace(e.text);
		}

		private function startup():void
		{
			this.addChild(new GameProject());
		}
	}
}
