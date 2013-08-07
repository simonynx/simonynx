package tempest.manager
{
	import com.adobe.utils.ArrayUtil;
	import flash.events.Event;
	import org.osflash.signals.natives.base.SignalTimer;
	import tempest.common.time.SignalPreciseTimer;
	import tempest.common.time.vo.TimerData;

	public class TimerManager
	{
		public static const NORMAL:String = "normal";
		public static const PRECISE:String = "precise";
		private static var _timers:Array = [];

		public static function get timerCount():int
		{
			return _timers.length;
		}

		public static function destoryAllTimers():void
		{
			_timers.forEach(function(item:TimerData, index:int, array:Array):void
			{
				item.dispose();
			});
			_timers = [];
		}

		/**
		 * 创建系统默认定时器
		 * @param delay 间隔
		 * @param repeatCount 重复次数 0表示无限循环
		 * @param updateHandler 间隔回调函数
		 * @param updateArgs 间隔回调函数参数
		 * @param completeHandler 完成回调函数
		 * @param completeArgs 完成回调函数参数
		 * @param autoStart 是否自动运行
		 * @return 定时器数据
		 */
		public static function createNormalTimer(delay:Number, repeatCount:int = 0, updateHandler:Function = null, updateArgs:Array = null, completeHandler:Function = null, completeArgs:Array = null, autoStart:Boolean =
			true):TimerData
		{
			return createTimer(delay, repeatCount, updateHandler, updateArgs, completeHandler, completeArgs, autoStart, NORMAL);
		}

		/**
		 * 创建精确定时器
		 * @param delay 间隔
		 * @param repeatCount 重复次数 0表示无限循环
		 * @param updateHandler 间隔回调函数
		 * @param updateArgs 间隔回调函数参数
		 * @param completeHandler 完成回调函数
		 * @param completeArgs 完成回调函数参数
		 * @param autoStart 是否自动运行
		 * @return 定时器数据
		 */
		public static function createPreciseTimer(delay:Number, repeatCount:int = 0, updateHandler:Function = null, updateArgs:Array = null, completeHandler:Function = null, completeArgs:Array = null, autoStart:Boolean =
			true):TimerData
		{
			return createTimer(delay, repeatCount, updateHandler, updateArgs, completeHandler, completeArgs, autoStart, PRECISE);
		}

		/**
		 *
		 * 创建定时器
		 * @param delay 间隔
		 * @param repeatCount 重复次数 0表示无限循环
		 * @param updateHandler 间隔回调函数
		 * @param updateArgs 间隔回调函数参数
		 * @param completeHandler 完成回调函数
		 * @param completeArgs 完成回调函数参数
		 * @param autoStart 是否自动运行
		 * @param timerType 定时器类型
		 * @return 定时器数据
		 */
		private static function createTimer(delay:Number, repeatCount:int = 0, updateHandler:Function = null, updateArgs:Array = null, completeHandler:Function = null, completeArgs:Array = null, autoStart:Boolean =
			true, timerType:String = "normal"):TimerData
		{
			var timer:*;
			var timeData:TimerData;
			var onTimer:Function;
			var onComlete:Function;
			var onDestory:Function;
			var $updateHandler:Function = updateHandler;
			var $updateArgs:Array = updateArgs;
			var $completeHandler:Function = completeHandler;
			var $completeArgs:Array = completeArgs;
			if (timerType == PRECISE)
			{
				timer = new SignalPreciseTimer(delay, repeatCount);
			}
			else
			{
				timer = new SignalTimer(delay, repeatCount);
			}
			onDestory = function():void
			{
//				ArrayUtil.removeValueFromArray(_timers, timeData);
				timer.signals.removeAll();
				timer = null;
			}
			onComlete = function(e:Event):void
			{
				timeData.dispose();
				if ($completeHandler != null)
				{
					HandlerManager.execute($completeHandler, $completeArgs);
				}
			}
			timeData = new TimerData(timer, onDestory);
//			_timers.push(timeData);
			timer.signals.timerComplete.add(onComlete);
			if ($updateHandler != null)
			{
				onTimer = function(e:Event):void
				{
					HandlerManager.execute($updateHandler, $updateArgs);
				}
				timer.signals.timer.add(onTimer);
			}
			if (autoStart)
			{
				timeData.start();
			}
			return timeData;
		}
	}
}
