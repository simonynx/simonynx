package fj1.common.net.tcpLoader
{
	import fj1.common.data.dataobject.MallItemData;
	import fj1.common.net.GameClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;
	import fj1.modules.mall.model.MallModel;

	import tempest.common.net.vo.TPacketIn;

	public class MallItemLoader extends TCPLoader
	{
		private var _templateId:int;
		private var _discount:Boolean;

		private var _itemArray:Array;

		public function MallItemLoader(templateId:int, discount:Boolean)
		{
			_templateId = templateId;
			_discount = discount;
			super();
		}

		override public function getGroup():int
		{
			return TCPLoaderGroup.MALL_ITEM;
		}

		public function get templateId():int
		{
			return _templateId;
		}

		override public function load():void
		{
			super.load();
//			var storeItemData:MallItemData = MallModel.instance.getStoreItem(_templateId, _discount);
//			if (storeItemData)
//			{
//				resiveData2(storeItemData);
//			}
//			else
//			{
			GameClient.sendMallItemQuery(_templateId, _discount, loaderId);
//			}
		}

		public function get mallItemArray():Array
		{
			return _itemArray;
		}

		override protected function analysisResponse(packet:TPacketIn):Object
		{
//			var storeItemData:MallItemData = MallModel.instance.getStoreItem(_templateId, _discount);
//			if (!storeItemData)
//			{
			_itemArray = MallItemData.create(packet);
//			for (var i:int = 0; i < _itemArray.length; i++)
//			{
//				MallModel.instance.addItemToCategory(_itemArray[i]);
//			}
//			}
			return _itemArray[0];
		}
	}
}
