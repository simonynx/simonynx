package fj1.modules.chat.model
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.net.tcpLoader.ItemLoader;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import mx.core.IFactory;
	import fj1.common.staticdata.ItemConst;

	public class ChatItemLoaderManager
	{
		private static var uniqueLoaderCache:Dictionary = new Dictionary();

		/**
		 * 获取现有的loader
		 * @param loaderId
		 * @return
		 *
		 */
		public static function getLoader(loaderId:int):TCPLoader
		{
			return uniqueLoaderCache[loaderId];
		}

		/**
		 * 创建新loader返回，可以决定是否立刻开始加载
		 * @param loaderId
		 * @param senderId
		 * @param goodsId
		 * @param loadNow 是否立刻开启加载
		 * @return 新创建的loader
		 *
		 */
		public static function addLoader(loaderId:int, newloader:TCPLoader, loadNow:Boolean = true):TCPLoader
		{
			var newloader:TCPLoader;
			newloader.signals.complete.add(onComplete);
			if (loadNow)
			{
				newloader.load();
			}
			uniqueLoaderCache[loaderId] = newloader;
			return newloader;
		}

		private static function onComplete(loader:TCPLoader):void
		{
//			if (!loader)
//			{
//				return;
//			}
//			var itemData:ItemData = loader.content as ItemData;
//			if (itemData)
//			{
//				itemData.watchHeroChange();
//			}
		}
	}
}
