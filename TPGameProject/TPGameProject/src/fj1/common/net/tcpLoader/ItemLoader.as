package fj1.common.net.tcpLoader
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.helper.QueryHelper;
	import fj1.common.helper.UpdatePropsHelper;
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.net.tcpLoader.base.ILoaderFailClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.staticdata.QueryType;
	import fj1.manager.SlotItemManager;
	import tempest.common.net.vo.TPacketIn;

	public class ItemLoader extends TCPLoader implements ILoaderFailClient
	{
		private var _playerId:int;
		private var _itemGuId:int;
		private var _templateId:int
		private var _contentWhenFail:Object;

		public function ItemLoader(playerId:int, itemGuId:int, templateId:int)
		{
			_playerId = playerId;
			_itemGuId = itemGuId;
			_templateId = templateId;
			super();
			this.signals.failed.addOnceWithPriority(onFail, 1);
		}

		override public function load():void
		{
			super.load();
			var itemData:ItemData = SlotItemManager.instance.getItem(_itemGuId) as ItemData;
			if (itemData)
			{
				this.resiveData2(itemData);
			}
			else
			{
				QueryHelper.query(loaderId, _playerId, _itemGuId, _itemGuId == 0 ? QueryType.CHR : QueryType.ITEM);
			}
		}

		override protected function analysisResponse(packet:TPacketIn):Object
		{
			var propData:Object = UpdatePropsHelper.parsePropPacket(packet);
			var item:ItemData = ItemDataFactory.create(_playerId, propData.guid, propData.props);
			if (!item) //使用查询结果创建对象失败
			{
				item = ItemDataFactory.createByID(_playerId, 0, _templateId);
			}
			return item;
		}

		private function onFail(loader:TCPLoader):void
		{
			_contentWhenFail = ItemDataFactory.createByID(0, 0, _templateId);
		}

		public function get contentWhenFail():Object
		{
			return _contentWhenFail;
		}

		public function get contentWhenTimeOut():Object
		{
			return ItemDataFactory.createByID(0, 0, _templateId);
		}
	}
}
