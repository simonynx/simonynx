package tpe
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class Input
	{
		private static var _stage:Stage;
		private static var _active:Boolean = false;
		private static var _key_cache:Array = [];
		private static var _downkey_cache:Array = [];
		private static var _upkey_cache:Array = [];
		private static var updateNext:Boolean = false;
		
		static public function get active():Boolean
		{
			return _active;
		}
		
		public static function init(stage:Stage):void
		{
			_stage = stage;
		}
		
		public static function enable():void
		{
			if (!_active)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				_stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
				_stage.addEventListener(Event.DEACTIVATE,onDeactivate);
				_active = true;
			}
		
		}
		
		public static function disable():void
		{
			if (_active)
			{
				_downkey_cache.length = 0;
				_upkey_cache.length = 0;
				_key_cache.length = 0;
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				_stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
				_stage.removeEventListener(Event.DEACTIVATE,onDeactivate);
				_active = false;
			}
		
		}
		
		public static function getKeyDown(keyCode:uint):Boolean
		{
			return Boolean(_downkey_cache[keyCode]);
		}
		
		public static function getKeyUp(keyCode:uint):Boolean
		{
			return Boolean(_upkey_cache[keyCode]);
		}
		
		public static function getKey(keyCode:uint):Boolean
		{
			return Boolean(_key_cache[keyCode]);
		}
		
		private static function _onKeyDown(e:KeyboardEvent):void
		{
			
			if (!(e.keyCode == 229 || (e.eventPhase != 2 && (e.target is TextField) && (e.target.type == TextFieldType.INPUT))))
			{
				if (!Boolean(_key_cache[e.keyCode]))
				{
					_key_cache[e.keyCode] = true;
					_downkey_cache[e.keyCode] = true;
					if (_downkey_cache.length != 0 && !updateNext)
					{
						updateNext = true;
						_stage.addEventListener(Event.ENTER_FRAME, onNextFrame, false, int.MAX_VALUE);
					}
				}
			}
		}
		
		private static function _onKeyUp(e:KeyboardEvent):void
		{
			if (Boolean(_key_cache[e.keyCode]))
			{
				_key_cache[e.keyCode] = false;
				if ((!(e.eventPhase != 2 && (e.target is TextField) && (e.target.type == TextFieldType.INPUT))))
				{
					_upkey_cache[e.keyCode] = true;
					if (_upkey_cache.length != 0 && !updateNext)
					{
						updateNext = true;
						_stage.addEventListener(Event.ENTER_FRAME, onNextFrame, false, int.MIN_VALUE);
					}
				}
			}
		}
		static private function onDeactivate(e:Event):void
		{
			_downkey_cache.length = 0;
			_upkey_cache.length = 0;
			_key_cache.length = 0;
		}
		
		static private function onNextFrame(e:Event):void
		{
			_stage.removeEventListener(Event.ENTER_FRAME, onNextFrame);
			_downkey_cache.length = 0;
			_upkey_cache.length = 0;
			updateNext = false;
		}
	
	}
}
