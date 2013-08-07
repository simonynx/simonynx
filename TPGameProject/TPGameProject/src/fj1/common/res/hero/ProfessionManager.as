package fj1.common.res.hero
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.hero.vo.ProfessionRes;

	import flash.utils.ByteArray;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.XMLAnalyser;

	public class ProfessionManager
	{
		private static const log:ILogger = TLog.getLogger(ProfessionManager);
		public static var configArray:Array = [];
		private static var _mainCharRes:ProfessionRes = null;

		/**
		 *初始化配置加载数据
		 * @param xml
		 *
		 */
		public static function load(data:*):Boolean
		{
			var xmlList:XMLList = ResManagerHelper.getXmlList(data);
			if (xmlList)
			{
				for each (var item:XML in xmlList)
				{
					var res:ProfessionRes = new ProfessionRes();
					res.id = item.@id;
					res.descript = String(item.@descript).replace("\\n", "\n");
					res.gender = item.@gender;
					res.gPointDesc = item.@gPointDesc;
					res.fPointDesc = item.@fPointDesc;
					res.mPointDesc = item.@mPointDesc;
					res.tPointDesc = item.@tPointDesc;
					res.gDesc = item.@gDesc;
					res.star_atk = item.@star_atk;
					res.star_def = item.@star_def;
					res.star_recover = item.@star_recover;
					res.star_eruption = item.@star_eruption;
					var iconListStr:String = String(item.@icon);
					var iconStrArr:Array = iconListStr.split(",");
					for each (var iconStr:String in iconStrArr)
					{
						res.icons.push(parseInt(iconStr));
					}
					configArray[res.id] = res;
				}
				if (configArray.length == 0)
				{
					log.error("职业配置文件加载失败");
				}
				return true;
			}
			return false;
		}

		/**
		 *
		 * @param level
		 * @return
		 *
		 */
		public static function get(profession:int):ProfessionRes
		{
			if (profession == 0)
				return null;
			return ProfessionRes(configArray[profession]);
		}

		/**
		 *角色属性描述信息
		 * @return
		 *
		 */
		public static function get mainCharRes():ProfessionRes
		{
//			return _mainCharRes || ProfessionRes(configArray[GameInstance.mainCharData.professions])
			return _mainCharRes;
		}
	}
}
