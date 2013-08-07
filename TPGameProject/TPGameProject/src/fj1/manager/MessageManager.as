package fj1.manager
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import fj1.common.events.HintEvent;
	import fj1.common.res.hint.HintDataFactory;
	import fj1.common.res.hint.HintResManager;
	import fj1.common.res.hint.vo.BaseHintConfig;
	import fj1.common.res.hint.vo.HintConfig;
	import fj1.common.res.hint.vo.HintData;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.HintConst;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;
	import tempest.utils.HtmlUtil;

	public class MessageManager extends EventDispatcher
	{
		private static var log:ILogger = TLog.getLogger(MessageManager);
		private static var _hintSignalMap:Vector.<Object> = new Vector.<Object>();
		private static var _instance:MessageManager;
		private var _alertDictionary:Dictionary = new Dictionary();

		public static function get instance():MessageManager
		{
			if (!_instance)
				new MessageManager();
			return _instance;
		}

		public function MessageManager()
		{
			super(this);
			if (_instance)
				throw new Error("该类只能存在一个实例");
			_instance = this;
			registerChatShower(HintConst.HINT_PLACE_ALERT, AlterShower.show);
		}

		/**
		 * 添加系统提示 （不会发送到服务端）
		 * @param str 提示文本
		 * @param showType 显示位置（HintConst.SHOW_RIGHT, HintConst.SHOW_TOP_SCROLL, HintConst.SHOW_CHAT）之间的组合
		 * @param type 在ChatConst中定义，
		 * 				当showType | HintConst.SHOW_CHAT时为频道Id（GM频道不可用）
		 *    =2
		 *  =5
		 */
		private function addHintInternal(prefix:String, hintData:HintData):void
		{
			if (prefix)
			{
				hintData.prefix = prefix;
			}
			//延时一帧显示提示
			GTweener.to(null, 1, null, {useFrames: true}).onComplete = function(gTween:GTween):void
			{
				dispatchHint(hintData);
			};
		}

		/**
		 * 添加系统提示(客户端调用) （不会发送到服务端）
		 * @param str 提示文本
		 * @param showType 显示位置（HintConst.SHOW_BULLETIN, HintConst.SHOW_SYSTEM_HINT, HintConst.SHOW_CHAT, HintConst.SHOW_SCROLL_HINT, HintConst.SHOW_NOTICE）之间的组合
		 * @param type 在ChatConst中定义，
		 * 				当showType | HintConst.SHOW_CHAT时为频道Id（GM频道不可用）
		 * 				当showType | HintConst.SHOW_NOTICE时为通知Id
		 *  HintConst.SHOW_SCROLL_HINT=8
		 *  ChatConst.CHANNEL_INFO=5
		 */
		public function addHint(str:String, showType:int = 8 /*HintConst.SHOW_SCROLL_HINT*/, channel:int = 5 /*ChatConst.CHANNEL_INFO*/):void
		{
			var newHintData:HintData = HintDataFactory.create(new HintConfig(-1, str, showType, 0, channel), null);
			addHintInternal("", newHintData);
			//如果是滚动提示，补充一条信息频道提示到聊天框
//			if (showType == HintConst.HINT_PLACE_SCROLL_HINT)
//			{
//				addHintInternal("", new HintData(new HintConfig(-1, null, HintConst.HINT_PLACE_CHAT, 0, ChatConst.CHANNEL_INFO), str));
//			}
//			else 
			if (showType == HintConst.HINT_PLACE_BULLETIN)
			{
				addHintInternal("", HintDataFactory.create(new HintConfig(-1, str, HintConst.HINT_PLACE_CHAT, 0, ChatConst.CHANNEL_NOTICE), null));
			}
//			if (channel == ChatConst.CHANNEL_GUILD_HEARSAY)
//			{
//				addHintInternal("", new HintData(new HintConfig(-1, null, HintConst.HINT_PLACE_CHAT, 0, ChatConst.CHANNEL_GUILD), str));
//			}
		}

		/**
		 * 添加错误提示
		 * @param str
		 * @param showType
		 * @return
		 *
		 */
		public function addErrorHint(str:String, showType:int = 8, channel:int = 5 /*ChatConst.CHANNEL_INFO*/):void
		{
			CONFIG::debugging
			{
				addHintInternal("[ERROR]", HintDataFactory.create(new HintConfig(-1, str, HintConst.HINT_PLACE_SYSTEM_HINT, 0, channel), null));
			}
		}

		/**
		 * 根据配置Id显示客户端提示
		 * @param id 配置id
		 * @param defaultHint 配置id无效时，默认的提示内容（可以是模式字符串）
		 * @param params 模式字符串中的替换参数
		 * @param type 类型，决定配置显示的来源HintConst.TYPE_CLIENT， HintConst.SERVER，HintConst.TYPE_SERVER_SCRIPT
		 *
		 */
		public function addHintById(id:int, defaultHint:String = null, params:Array = null, type:int = -1):void
		{
			var hintResManager:HintResManager = HintResManager.getInstance(type);
			var config:BaseHintConfig = hintResManager.getHintConfig(id);
			if (!config && defaultHint)
			{
				if (defaultHint)
				{
					//找不到配置，采用默认提示 
					config = new HintConfig(id, defaultHint, HintConst.HINT_PLACE_SYSTEM_HINT);
				}
			}
			if (!config)
			{
				return;
			}
			addHintData(type, HintDataFactory.create(config, params));
		}

		public function addHintData(type:int, hintData:HintData):void
		{
			CONFIG::debugging
			{
				switch (type)
				{
					case HintConst.CONFIG_CLIENT:
						addHintInternal("[C-" + hintData.hintConfig.id + "]", hintData);
						break;
					case HintConst.CONFIG_SERVER:
						addHintInternal("[S-" + hintData.hintConfig.id + "]", hintData);
						break;
					case HintConst.CONFIG_SERVER_SCRIPT:
						addHintInternal("[SC-" + hintData.hintConfig.id + "]", hintData);
						break;
					default:
						addHintInternal("", hintData);
						break;
				}
			}
			CONFIG::release
			{
				addHintInternal("", hintData);
			}
			dispatchEvent(new HintEvent(HintEvent.HINT_SHOW, type, hintData, hintData.params)); //抛出事件供其他地方表现提示
		}

		/**
		 * 根据客户端配置Id显示客户端提示（client_hint.xml）
		 * @param id 配置id
		 * @param defaultHint 配置id无效时，默认的提示内容（可以是模式字符串）
		 * @param params 模式字符串中的替换参数
		 *
		 */
		public function addHintById_client(id:int, defaultHint:String = null, ... params):void
		{
			addHintById(id, defaultHint, params, HintConst.CONFIG_CLIENT);
		}

		/**
		 * 抛出提示数据到具体显示层
		 * @param hintData
		 *
		 */
		private function dispatchHint(hintData:HintData):void
		{
			if (!(hintData.hintConfig is HintConfig))
			{
				log.error("提示配置错误，未使用hint标签，只有用hint标签配置的提示才可以使用MessageManager显示");
				return;
			}
			var hintConfig:HintConfig = HintConfig(hintData.hintConfig);
			for each (var obj:Object in _hintSignalMap)
			{
				if (obj.place & hintConfig.place)
				{
					var signal:Signal = obj.signal;
					if (signal)
						signal.dispatch(hintData);
				}
			}
		}

		/**
		 * 注册消息的显示回调函数，用于显示指定消息
		 * @param showPlace
		 * @param handler
		 *
		 */
		public static function registerChatShower(showPlace:int, handler:Function):void
		{
			var signal:ISignal = getSignal(showPlace);
			if (!signal)
			{
				signal = new Signal(HintData);
				_hintSignalMap.push({place: showPlace, signal: signal});
			}
			signal.add(handler);
		}

		private static function getSignal(showPlace:int):ISignal
		{
			for each (var obj:Object in _hintSignalMap)
			{
				if (obj.place == showPlace)
				{
					return obj.signal;
				}
			}
			return null;
		}
	}
}
import fj1.common.GameInstance;
import fj1.common.res.hint.vo.HintData;
import fj1.common.ui.TAlertMananger;

import tempest.ui.components.TAlert;
import tempest.ui.events.TWindowEvent;

class AlterShower
{
	public static function show(hintData:HintData):void
	{
		TAlertMananger.showHintAlert(hintData.type, hintData.hintConfig.id, hintData.content, false);
//		var alert:TAlert = TAlert.Show(hintData.content, "", false);
	}

	private static function onAlertClose(event:TWindowEvent):void
	{
	}
}
