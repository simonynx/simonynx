package fj1.common.helper
{
	import fj1.common.net.ChatClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.AlertId;
	import fj1.common.staticdata.QueryType;
	import fj1.common.ui.TAlertMananger;

	public class QueryHelper
	{
		public function QueryHelper()
		{
		}

		/**
		 * 查询玩家 物品 宠物
		 * @param loaderId loaderId
		 * @param playerId 玩家ID
		 * @param itemId 物品ID
		 * @param queryType 查询类型 0玩家 1物品 2宠物
		 *
		 */
		public static function query(loaderId:int, playerId:int, itemId:int, queryType:int):void
		{
			ChatClient.sendQueryObject(loaderId, playerId, itemId, queryType);
		}

		/**
		 * @param queryType 查询类型 0玩家 1物品 2宠物
		 */
		public static function queryAlert(queryType:int):void
		{
			switch (queryType)
			{
				case QueryType.CHR:
					TAlertMananger.showAlert(AlertId.QUERY_CHR, LanguageManager.translate(50075, "查询失败, 玩家不在线"));
					break;
				case QueryType.ITEM:
					TAlertMananger.showAlert(AlertId.QUERY_ITEM, LanguageManager.translate(50075, "查询失败, 玩家不在线"));
					break;
				case QueryType.PET:
					TAlertMananger.showAlert(AlertId.QUERY_PET, LanguageManager.translate(36071, "查询失败，该宠物的主人不在线"));
					break;
			}
		}
	}
}
