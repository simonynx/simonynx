package fj1.common.res.salesroom
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.salesroom.vo.BeliefSaleItemConfig;
	import fj1.common.res.salesroom.vo.SaleItemConfig;
	import flash.utils.ByteArray;
	import tempest.utils.XMLAnalyser;

	public class SalesroomConfigManager
	{
		private static var _configArray:Array = [];
		public static var _beliefSaleItemConfig:Array = [];

		public static function load(data:*):Boolean
		{
			_configArray = ResManagerHelper.getArray(SaleItemConfig, data, "templateid");
//			return ResManagerHelper.mapArryList(_configArray, SaleItemConfig, data, false, "templateid");
			return _configArray != null;
		}

		/**
		 *加载信仰力市场配置
		 * @param data
		 * @return
		 *
		 */
		public static function loadBelief(data:*):Boolean
		{
			_beliefSaleItemConfig = ResManagerHelper.getArray(BeliefSaleItemConfig, data, "id");
			return _beliefSaleItemConfig != null;
//			return ResManagerHelper.mapArryList(_beliefSaleItemConfig, BeliefSaleItemConfig, data, false);
		}

		/**
		 *获取出售配置
		 * @param templateId
		 * @return
		 *
		 */
		public static function getSaleItemConfig(templateId:int):SaleItemConfig
		{
			return _configArray[templateId] as SaleItemConfig;
		}

		/**
		 *获取信仰力市场配置
		 * @param id
		 * @return
		 *
		 */
		public static function getBeliefSaleItemConfig(id:int):BeliefSaleItemConfig
		{
			return _beliefSaleItemConfig[id] as BeliefSaleItemConfig;
		}

		/**
		 *根据类型获取信仰力配置
		 * @return
		 *
		 */
		public static function getBeliefSaleItemConfigByType(type:int):BeliefSaleItemConfig
		{
			var beliefConfig:BeliefSaleItemConfig = null;
			for each (beliefConfig in _beliefSaleItemConfig)
			{
				if (beliefConfig.trade_subtype == type)
				{
					return beliefConfig;
				}
			}
			return null;
		}
	}
}
