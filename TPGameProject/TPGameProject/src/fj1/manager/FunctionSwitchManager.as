package fj1.manager
{
	import fj1.common.GameInstance;

	import flash.utils.Dictionary;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class FunctionSwitchManager
	{
		/**
		 * 龙曜宝典
		 */
		public static const ESOTERICAL:int = 16;
		/**
		 * 神格
		 */
		public static const GODHOODSWTICH:int = 4;
		/**
		 * 神力
		 */
		public static const GODPOWERSWITCH:int = 5;
		/**
		 * 宠物
		 */
		public static const PETSWITCH:int = 6;
		/**
		 * 精通
		 */
		public static const MASTERYSWITCH:int = 7;
		/**
		 *坐骑
		 */
		public static const HORSESWTICH:int = 8;
		/**
		 *炼金术
		 */
		public static const ALCHEMYSWITCH:int = 9;
		/**
		 * 太阳神
		 */
		public static const SUNGODSWITCH:int = 10;
		/**
		 * 精通是否全开，并且加了一百点的自由点
		 */
		public static const HASALLJTADDFREEPOINT:int = 11;
		/**
		 * 是否使用圣光秘药
		 */
		public static const ISALLEQUIPSOULFULL:int = 12;
		/**
		 * 神力爆发
		 */
		public static const GODPOWERERUPT:int = 13;
		/**
		 * 是否觉醒过
		 */
		public static const AWAKEN:int = 14;
		/**
		 * 寻宝开关
		 */
		public static const ARCHAEOLOGY:int = 15;
		/**
		 * 装备强化开关
		 */
		public static const EQUIP_STRENG:int = 17;
		/**
		 * 占星开关
		 */
		public static const WATCHSTAR:int = 18;

		private static var _instance:FunctionSwitchManager;

		public function FunctionSwitchManager()
		{
			if (_instance)
				throw new Error("该类只能存在一个实例");
		}

		public static function get instance():FunctionSwitchManager
		{
			if (!_instance)
			{
				_instance = new FunctionSwitchManager();
			}
			return _instance;
		}
		private var _switchSignalDic:Dictionary = new Dictionary();
		private var _openSignal:ISignal;

		/**
		 * 获取相应开关的开启signal dispatch时会带两个参数，type是开关类型，isOpen是该功能是否开启
		 * @param type 开关类型
		 * @return
		 *
		 */
		public function getSwitchSignal(type:int):ISignal
		{
			var signal:ISignal = _switchSignalDic[type];
			if (!signal)
			{
				signal = new Signal();
				_switchSignalDic[type] = signal;
			}
			return signal;
		}

		/**
		 * 所有的开关都会抛  dispatch 时带两个参数，一个type 是开关类型 isOpen 该功能是否开启
		 * @return
		 *
		 */
		public function get openSignal():ISignal
		{
			return _openSignal ||= new Signal();
		}

		/**
		 * 角色初始化完成后开关功能开启关闭 所有的开关都会抛 getSwitchSignal 和openSignal
		 * @param type
		 * @param isOpen
		 *
		 */
		public function switchOpen(type:int, isOpen:Boolean):void
		{
			var switchIsOpen:Boolean = GameInstance.mainCharData.switchDiction[type];
			if (switchIsOpen == isOpen)
			{
				return;
			}
			getSwitchSignal(type).dispatch(isOpen);
			openSignal.dispatch(type, isOpen);
			GameInstance.mainCharData.switchDiction[type] = isOpen;
		}

		/**
		 * 初始化时调用
		 * @param isOpen
		 * @param type
		 *
		 */
		public function initFunctionSwitch(type:int, isOpen:Boolean):void
		{
			openSignal.dispatch(type, isOpen);
			getSwitchSignal(type).dispatch(isOpen);
			GameInstance.mainCharData.switchDiction[type] = isOpen;
		}
	}
}
