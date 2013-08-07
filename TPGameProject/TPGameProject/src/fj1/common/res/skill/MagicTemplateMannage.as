package fj1.common.res.skill
{
	import fj1.common.res.ResManagerHelper;

	import flash.utils.Dictionary;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	import tpm.magic.entity.MagicInfo;

	/**
	 *技能管理类
	 * @author zhangyong
	 *
	 */
	public class MagicTemplateMannage 
	{
		private static const log:ILogger=TLog.getLogger(MagicTemplateMannage);
		/**
		 *
		 */
		private static var _instrance:MagicTemplateMannage=null;
		/**
		 *魔法列表
		 */
		private var _magicInfoList:Dictionary=new Dictionary();
		/**
		 * 单例锁
		 */
		private static var _key:Boolean=false;

		public static function get instrance():MagicTemplateMannage
		{
			if (_instrance == null)
			{
				_key=true;
				_instrance=new MagicTemplateMannage();
			}
			return _instrance;
		}

		public function MagicTemplateMannage()
		{
			if (!_key)
			{
				throw new Error("单例模式,请用 instance() 取实例。");
			}
			_key=false;
		}

		/**
		 *初始化配置加载数据
		 * @param xml
		 *
		 */
		public function load(data:*):Boolean
		{
			_magicInfoList = ResManagerHelper.getDictionary(MagicInfo, data)
			return (_magicInfoList != null)
		}

		/**
		 *回返技能
		 * @param id
		 * @return
		 *
		 */
		public function getMagicInfo(id:uint):MagicInfo
		{
			if (_magicInfoList[id] == null)
			{
				log.warn("不存在魔法模板信息ID:" + id);
			}
			return _magicInfoList[id];
		}

		/**
		 *获取技能列表
		 * @return
		 *
		 */
		public function get magicInfoList():Dictionary
		{
			return _magicInfoList;
		}
	}
}
