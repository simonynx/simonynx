package tempest.manager
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;
	import tempest.common.keyboard.vo.HotkeyData;
	import tempest.common.logging.*;

	public class KeyboardManager
	{
		private static const log:ILogger = TLog.getLogger(KeyboardManager);
		public static var ctrlKey:Boolean = false;
		public static var shiftKey:Boolean = false;
		public static var altKey:Boolean = false;
		private static var downkey_cache:Array = [];
		private static var downkeys:Vector.<int> = new Vector.<int>();
		private static var hotkeys:Object = {};
		private static var signals:InteractiveObjectSignalSet = null;

		public static function init(stage:Stage):void
		{
			signals = new InteractiveObjectSignalSet(stage);
		}

		/**
		 * 注册热键
		 * @param name 热键名
		 * @param keys 组合键
		 * @param handler 处理函数
		 * @param ctrl
		 * @param alt
		 * @param shift
		 */
		public static function addHotkey(name:String, keys:Array, handler:Function, ctrl:Boolean = false, alt:Boolean = false, shift:Boolean = false, needKeys:Boolean = false):void
		{
			keys.sort(Array.NUMERIC);
			var keysString:String = createKeyString(keys.join("+"), ctrl, alt, shift);
			if (hotkeys.hasOwnProperty(keysString))
			{
				throw new Error(keysString + "-重复注册热键");
			}
			if (hasHotkey(name))
			{
				throw new Error(keysString + "-重复注册热键名");
			}
			hotkeys[keysString] = new HotkeyData(name, keys, keysString, handler, needKeys);
			log.info("注册热键  name:{0} key:{1}", name, keysString);
		}

		/**
		 * 注册一组热键
		 * @param prefix 命名前缀
		 * @param keys 热键数组
		 * @param handler
		 * @param ctrl
		 * @param alt
		 * @param shift
		 * @param needKeys
		 */
		public static function addHotkeyGroup(prefix:String, keys:Array, handler:Function, ctrl:Boolean = false, alt:Boolean = false, shift:Boolean = false, needKeys:Boolean = true):void
		{
			if (keys && keys.length != 0)
			{
				keys.forEach(function(element:int, index:int, arr:Array):void
				{
					addHotkey(prefix + element, [element], handler, ctrl, alt, shift, needKeys);
				});
			}
		}

		/**
		 * 移除热键
		 * @param name 热键名
		 */
		public static function removeHotkey(name:String):void
		{
			var hotKey:HotkeyData;
			for each (hotKey in hotkeys)
			{
				if (hotKey.name == name)
				{
					hotkeys[hotKey.keyString] = null;
					delete hotkeys[hotKey.keyString];
					log.info("移除热键:{0}", name);
					break;
				}
			}
		}

		/**
		 * 移除一组热键
		 * @param prefix
		 * @param keys
		 */
		public static function removeHotkeyGroup(prefix:String, keys:Array):void
		{
			if (keys && keys.length != 0)
			{
				keys.forEach(function(element:int, index:int, arr:Array):void
				{
					removeHotkey(prefix + element);
				});
			}
		}

		/**
		 * 移除所有热键
		 */
		public static function removeAllHotkey():void
		{
			hotkeys = {};
			log.info("移除所有热键");
		}

		/**
		 * 禁用键盘
		 */
		public static function disable():void
		{
			signals.keyDown.remove(onKeyDown);
			signals.keyUp.remove(onKeyUp);
			log.info("禁用热键");
		}

		/**
		 * 启用键盘
		 */
		public static function enable():void
		{
			downkeys.length = 0;
			downkey_cache.length = 0;
			signals.keyDown.add(onKeyDown);
			signals.keyUp.add(onKeyUp);
			log.info("启用热键");
		}

		/**
		 * 是否注册热键
		 * @param name 热键名
		 * @return
		 */
		public static function hasHotkey(name:String):Boolean
		{
			var hotKey:HotkeyData;
			for each (hotKey in hotkeys)
			{
				if (hotKey.name == name)
				{
					return true;
				}
			}
			return false;
		}

		private static function onKeyDown(e:KeyboardEvent):void
		{
			if (!(e.keyCode == 18 || e.keyCode == 16 || e.keyCode == 17 || e.keyCode == 229 || (e.eventPhase != 2 && (e.target is TextField) && (e.target.type == TextFieldType.INPUT))))
			{
				if (!Boolean(downkey_cache[e.keyCode]))
				{
					downkey_cache[e.keyCode] = true;
					downkeys.push(e.keyCode);
				}
			}
		}

		private static function createKeyString(keyString:String, ctrl:Boolean = false, alt:Boolean = false, shift:Boolean = false):String
		{
			var str:String = "";
			if (ctrl)
			{
				str += "ctrl+";
			}
			if (alt)
			{
				str += "alt+";
			}
			if (shift)
			{
				str += "shift+";
			}
			str += keyString;
			return (str);
		}

		private static function onKeyUp(e:KeyboardEvent):void
		{
			if (!(e.keyCode == 18 || e.keyCode == 16 || e.keyCode == 17))
			{
				if (!Boolean(downkey_cache[e.keyCode]))
				{
					downkey_cache[e.keyCode] = true;
					downkeys.push(e.keyCode);
				}
				if (!(e.eventPhase != 2 && (e.target is TextField) && (e.target.type == TextFieldType.INPUT)))
				{
					downkeys.sort(Array.NUMERIC);
					var keysString:String = createKeyString(downkeys.join("+"), e.ctrlKey, e.altKey, e.shiftKey);
					if (hotkeys.hasOwnProperty(keysString))
					{
						hotkeys[keysString].execute();
					}
						//					downkeys.splice(downkeys.indexOf(e.keyCode), 1);
				}
			}
			downkey_cache.length = 0;
			downkeys.length = 0;
		}
	}
}
