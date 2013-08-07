package
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.hurlant.util.Base64;

	import fj1.common.GameInstance;
	import fj1.common.config.CustomConfig;
	import fj1.modules.loading.LoadFacade;
	import fj1.modules.mainUI.view.components.MainUI;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.system.Security;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.logging.logger.CcLoggerFatory;
	import tempest.ui.TPApplication;
	import tempest.ui.components.TLayoutContainer;
	import tempest.utils.Fun;

	import tpe.manager.FilePathManager;

	[SWF(width = "1000", height = "600", backgroundColor = "0x000000")]
	[Frame(factoryClass = "preloader.PreLoader")]
	public class GameProject extends TPApplication
	{
		private static const log:ILogger = TLog.getLogger(GameProject);
		public var uiContainer:TLayoutContainer;
		public var sceneContainer:TLayoutContainer;
		public var mainUI:MainUI;

		public function GameProject()
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
		}

		private function initGame():void
		{
			initContainer();
			FilePathManager.register(CustomConfig.instance.res_host, "");
			LoadFacade.instance.startup();
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
			var params:Object = this.stage.loaderInfo["parameters"] || this.loaderInfo["parameters"] || {};
			var jsonKey:String = params["key"];
			if (jsonKey)
			{
				Fun.copyProperties(CustomConfig.instance, new JSONDecoder(Base64.decode(jsonKey)).getValue(), true);
			}
			else
			{
				trace("参数解析错误: key == null");
			}
			Fun.copyProperties(CustomConfig.instance, params);
		}

		private function initLog():void
		{
			CONFIG::debugging
			{
				TLog.init(CustomConfig.instance.log_level, new CcLoggerFatory(this), false, false);
			}
			CONFIG::release
			{
				TLog.init(CustomConfig.instance.log_level, new TraceLoggerFactory(), false, false);
			}
			this.addEventListener(Event.ENTER_FRAME, onDelayLogParams);
		}

		private var _delay:int = 0;

		private function onDelayLogParams(event:Event):void
		{
			if (_delay < 5)
			{
				++_delay;
				return;
			}
			_delay = 0;
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			//DEBUG
			log.info("网页参数:");
			var params:Object = this.stage.loaderInfo["parameters"] || this.loaderInfo["parameters"] || {};
			for (var key:String in params)
			{
				log.info(key + "=" + params[key]);
			}
		}
	}
}
