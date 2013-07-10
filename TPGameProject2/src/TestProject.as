package
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;

	import com.junkbyte.console.Cc;

	import common.CustomConfig;
	import common.GameInstance;
	import common.config.SystemConfig;
	import common.constants.ResPath;
	import common.constants.ResourceLib;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;

	import modules.loading.LoadFacade;

	import preloader.PreLoader;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.logging.logger.CcLoggerFatory;
	import tempest.common.logging.logger.TraceLoggerFactory;
	import tempest.ui.TPApplication;
	import tempest.ui.components.TLayoutContainer;

	import tpe.manager.FilePathManager;

	[SWF(width = "1000", height = "600", backgroundColor = "0x000000")]
	[Frame(factoryClass = "preloader.PreLoader")]
	public class TestProject extends TPApplication
	{
		private static const log:ILogger = TLog.getLogger(TestProject);
		public var uiContainer:TLayoutContainer;
		public var sceneContainer:TLayoutContainer;

		public function TestProject()
		{
			super();
			Security.allowDomain("*");
		}

		protected override function initApp():void
		{
			super.initApp();
			GameInstance.app = this;

			initCustomConfig();
			initLog();
			initGame();

//			var rsloader:TRsLoader = new TRsLoader("", ResPath.getUIPath("Resource.swf"), TRslType.LIB, null);
//			rsloader.load();
//			rsloader.signals.complete.add(onComplete);
//			var loader:Loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete2);
//			loader.load(new URLRequest("http://kr.ly.lx.qyfz.com/res/base/resource.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
		}

//		private function onComplete(loader:TRsLoader):void
//		{
//			var clas:Object = ApplicationDomain.currentDomain.getDefinition(ResourceLib.UI_GAME_GUI_HERO_BAG);
//			//DEBUG
//			trace("DEBUG");
//		}

//		private function onComplete2(event:Event):void
//		{
//			var clas:Object = ApplicationDomain.currentDomain.getDefinition(ResourceLib.UI_GAME_GUI_HERO_BAG);
//			//DEBUG
//			trace("DEBUG");
//		}

		private function initGame():void
		{
			initContainer();
			FilePathManager.register(CustomConfig.res_host, "");
			LoadFacade.instance.startup();

			var params:Object = this.root.loaderInfo.parameters;
			log.info("网页参数:");
			for (var key:String in params)
			{
				log.info(key + "=" + params[key]);
			}
		}

		private function initContainer():void
		{
			this.sceneContainer = new TLayoutContainer({left: 0, right: 0, top: 0, bottom: 0});
			this.application.addChild(this.sceneContainer);
			this.uiContainer = new TLayoutContainer({left: 0, right: 0, top: 0, bottom: 0});
			this.application.addChild(this.uiContainer);
		}

		private function initCustomConfig():void
		{
			CustomConfig.log_level = SystemConfig.LOG_LEVEL;
			var params:Object = this.root.loaderInfo.parameters;
			if (params.hasOwnProperty("res_host"))
			{
				CustomConfig.res_host = params["res_host"];
			}
			if (params.hasOwnProperty("login_host"))
			{
				CustomConfig.login_host = params["login_host"];
			}
		}

		private function initLog():void
		{
			CONFIG::debugging
			{
				TLog.init(CustomConfig.log_level, new CcLoggerFatory(this), false, false);
			}
			CONFIG::release
			{
				TLog.init(CustomConfig.log_level, new TraceLoggerFactory(), false, false);
			}
		}

	}
}
