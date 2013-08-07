package fj1.common.vo.character
{
	import fj1.common.signals.MainCharSignal;
	import flash.events.Event;
	import tempest.engine.SceneCharacter;

	public class Hero extends Player
	{
		private var _signals:MainCharSignal;

		public function Hero(sc:SceneCharacter)
		{
			super(sc);
		}

		public function get signals():MainCharSignal
		{
			return _signals ||= new MainCharSignal();
		}

		private var _bagSize:uint = 0; //背包大小
		/**
		 * 背包大小
		 */
		[Bindable(event = "bagSizeChange")]
		[Attribute(index = "UNIT_END + 0x0030")]
		public function set bagSize(value:uint):void
		{
			_bagSize = value;
			dispatchEvent(new Event("bagSizeChange"));
		}

		public function get bagSize():uint
		{
			return _bagSize;
		}
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0010")]
		public var money:uint = 0; //金钱
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0012")]
		public var magicCrystal:uint = 0; //魔晶
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0011")]
		public var integrate:uint = 0; //积分
	}
}
