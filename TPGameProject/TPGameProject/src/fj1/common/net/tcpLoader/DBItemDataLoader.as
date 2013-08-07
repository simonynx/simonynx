package fj1.common.net.tcpLoader
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.helper.ObjectCreateHelper;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.helper.QueryHelper;
	import fj1.common.helper.UpdatePropsHelper;
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.net.tcpLoader.base.ILoaderFailClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.QueryType;
	import tempest.common.net.vo.TPacketIn;

	public class DBItemDataLoader extends TCPLoader implements ILoaderFailClient
	{
		private var _itemData:ItemData;
		private var _contentWhenFail:Object;

		public function DBItemDataLoader(itemData:ItemData)
		{
			_itemData = itemData;
			super();
			this.signals.failed.addOnceWithPriority(onFail, 1);
		}

		override public function load():void
		{
			super.load();
			QueryHelper.query(loaderId, 0, _itemData.guId, QueryType.ITEM);
		}

		override protected function analysisResponse(packet:TPacketIn):Object
		{
//			if (_itemData is PetEggSealData)
//			{
//				var petEggSealData:PetEggSealData = _itemData as PetEggSealData;
//				var petProperty:PetInfo = new PetInfo();
//				DataObjectFactory.updateObj(petProperty, UpdatePropsHelper.parsePropPacket(packet).props);
//				petProperty.fullName = packet.readUTF();
//				petEggSealData.petProperty = petProperty;
//				return petEggSealData;
//			}
//			else
//			{
			var propData:Object = UpdatePropsHelper.parsePropPacket(packet);
			return ItemDataFactory.create(0, propData.guid, propData.props);
//			}
		}

		private function onFail(loader:TCPLoader):void
		{
			_contentWhenFail = ItemDataFactory.createByID(0, 0, _itemData.templateId);
		}

		public function get contentWhenFail():Object
		{
			return _contentWhenFail;
		}

		public function get contentWhenTimeOut():Object
		{
			return ItemDataFactory.createByID(0, 0, _itemData.templateId);
		}
	}
}
