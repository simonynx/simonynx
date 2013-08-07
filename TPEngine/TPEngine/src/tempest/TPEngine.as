package tempest
{
	import br.com.stimuli.loading.BulkLoader;

	import flash.display.Stage;
	import flash.events.Event;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.engine.staticdata.BulkLoaderType;
	import tempest.engine.tools.loader.MapConfigLoader;

	import tpe.Input;

	public class TPEngine
	{
		private static const log:ILogger = TLog.getLogger(TPEngine);
		private static var _stage:Stage;
		private static var _fps:Number;
		public static var decode:Function = null;

		/**
		 * 初始化
		 * @param stage 舞台
		 * @param fps 帧频
		 */
		public static function init(stage:Stage, fps:Number = -1):void
		{
			_stage = stage;
			_fps = _stage.frameRate;
			if (fps >= 0)
			{
				_fps = fps;
				_stage.frameRate = _fps;
			}
			Input.init(stage);

			//注册加载器
			BulkLoader.registerNewType("swf", BulkLoaderType.MAP_CONFIG_LOADER, MapConfigLoader);
			log.info("引擎初始化完成");
		}

		/**
		 * 获取舞台
		 * @return
		 */
		public static function get stage():Stage
		{
			return _stage;
		}

		/**
		 * 获取/设置帧频
		 * @return
		 */
		public static function get fps():Number
		{
			return _fps;
		}

		public static function set fps(value:Number):void
		{
			if (_fps >= 0)
			{
				_fps = value;
				_stage.frameRate = _fps;
			}
		}
	}
}
