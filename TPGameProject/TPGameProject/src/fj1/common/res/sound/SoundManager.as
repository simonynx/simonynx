package fj1.common.res.sound
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.sound.vo.SoundEntity;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import tempest.utils.XMLAnalyser;

	public class SoundManager
	{
		private static var _instrance:SoundManager = null;
		private var _soundInfoList:Dictionary = new Dictionary(); //技能列表
		private static var _key:Boolean = false; //单例锁

		public static function get instrance():SoundManager
		{
			if (_instrance == null)
			{
				_key = true;
				_instrance = new SoundManager();
			}
			return _instrance;
		}

		public function SoundManager()
		{
			if (!_key)
			{
				throw new Error("单例模式,请用 instance() 取实例。");
			}
			_key = false;
		}

		/**
		 *初始化配置加载数据
		 * @param xml
		 *
		 */
		public function load(data:*):Boolean
		{
			_soundInfoList = ResManagerHelper.getDictionary(SoundEntity, data);
			return _soundInfoList != null;
		}

		public function getSoundEntity(id:int):SoundEntity
		{
			return _soundInfoList[id];
		}

		public function get soundList():Dictionary
		{
			return _soundInfoList;
		}
	}
}
