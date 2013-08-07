package tempest.manager
{
	import flash.utils.Dictionary;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class GMCommandMananger
	{
		private static const log:ILogger = TLog.getLogger(GMCommandMananger);

		private static var _handlers:Dictionary = new Dictionary();

		/**
		 * 注册一个GM指令处理函数
		 * @param key 指令标识
		 * @param processor GM指令处理方法 function(tokens:Array):void{}
		 *
		 */
		public static function register(key:String, processor:Function):void
		{
			if (_handlers.hasOwnProperty(key))
			{
				throw new Error("GMCommandMananger 重复注册processor, key = " + key);
			}
			_handlers[key] = processor;
		}

		public static function exec(commandStr:String):void
		{
			commandStr = commandStr.substr(1);
			var tokens:Array = commandStr.split(" ");
			if (tokens.length == 0)
			{
				return;
			}

			var processor:Function = _handlers[tokens[0]];
			if (processor == null)
			{
				log.warn("GM指令未注册：" + tokens[0]);
				return;
			}

			processor(tokens.slice(1));
		}
	}
}
