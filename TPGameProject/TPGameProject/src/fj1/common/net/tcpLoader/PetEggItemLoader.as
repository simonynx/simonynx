package fj1.common.net.tcpLoader
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.dataobject.items.PetEggSealData;
	import fj1.common.data.dataobject.items.toolTipShowers.PetEggSealToolTipShower;
	import fj1.common.helper.ObjectCreateHelper;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.helper.QueryHelper;
	import fj1.common.helper.UpdatePropsHelper;
	import fj1.common.net.ChatClient;
	import fj1.common.net.game_handler.ObjectUpdateHandler;
	import fj1.common.net.tcpLoader.base.ILoaderFailClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.pet.PetTemplateInfoManager;
	import fj1.common.res.pet.vo.PetTemplateInfo;
	import fj1.common.staticdata.QueryType;
	import fj1.common.vo.character.Pet;
	import fj1.common.vo.character.info.PetInfo;

	import tempest.common.net.vo.TPacketIn;

	public class PetEggItemLoader extends TCPLoader implements ILoaderFailClient
	{
		private var _playerId:uint;
		private var _itemGuId:int;
		private var _petEggSealData:PetEggSealData;

		private var _contentWhenFail:Object;

		public function PetEggItemLoader(playerId:int, itemGuId:int, petEggSealData:PetEggSealData)
		{
			_playerId = playerId;
			_itemGuId = itemGuId;
			_petEggSealData = petEggSealData;
			super();
			this.signals.failed.addOnceWithPriority(onFail, 1);
		}

		override public function load():void
		{
			super.load();
			if (_petEggSealData.petProperty)
			{
				this.resiveData2(_petEggSealData);
			}
			else
			{
				QueryHelper.query(loaderId, _playerId, _itemGuId, QueryType.ITEM);
			}
		}

		override protected function analysisResponse(packet:TPacketIn):Object
		{
			var petProperty:PetInfo = new PetInfo();
			ObjectCreateHelper.updateObj(petProperty, UpdatePropsHelper.parsePropPacket(packet).props);
			petProperty.fullName = packet.readUTF();
			var petTemplateInfo:PetTemplateInfo = PetTemplateInfoManager.instrance.getPetTemplateInfo(petProperty.templateID);
			petProperty.pet_magic_type = petTemplateInfo.id % 10; //魔法类型
			petProperty.pet_attack_type = petTemplateInfo.id * .1; //属性类型
			_petEggSealData.petProperty = petProperty;
			return _petEggSealData;
		}

		private function onFail(loader:TCPLoader):void
		{
			_contentWhenFail = ItemDataFactory.createByID(0, 0, _petEggSealData.templateId);
		}

		public function get contentWhenFail():Object
		{
			return _contentWhenFail;
		}

		public function get contentWhenTimeOut():Object
		{
			return ItemDataFactory.createByID(0, 0, _petEggSealData.templateId);
		}
	}
}
