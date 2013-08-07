package fj1.common.net.tcpLoader
{
	import fj1.common.data.dataobject.PetObjectData;
	import fj1.common.helper.ObjectCreateHelper;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.helper.QueryHelper;
	import fj1.common.helper.UpdatePropsHelper;
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.net.game_handler.ObjectUpdateHandler;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;
	import fj1.common.res.pet.PetTemplateInfoManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ObjectType;
	import fj1.common.staticdata.QueryType;
	import fj1.common.vo.character.info.PetInfo;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.net.vo.TPacketIn;

	public class DBItemDataLoader2 extends TCPLoader
	{
		private var _queryType:int;
		private var _guid:int;
		private var _ownerId:int;

		private static const log:ILogger = TLog.getLogger(DBItemDataLoader2);

		public function DBItemDataLoader2(queryType:int, guid:int, ownerId:int)
		{
			_queryType = queryType;
			_guid = guid;
			_ownerId = ownerId;
			super();
		}

		override public function load():void
		{
			super.load();
			QueryHelper.query(loaderId, _ownerId, _guid, _queryType);
		}

		override protected function analysisResponse(packet:TPacketIn):Object
		{
			if (_queryType == QueryType.PET)
			{
				var propData:Object = UpdatePropsHelper.parsePropPacket(packet);
				var petDataObject:PetObjectData = new PetObjectData(propData.guid);
				petDataObject.name = packet.readUTF();
				petDataObject.petProperty.fullName = petDataObject.name;
				petDataObject.petProperty.bodyModelId = propData.templateId;
				UpdatePropsHelper.updateProps(petDataObject.petProperty, propData.props);
				petDataObject.petTemplateInfo = PetTemplateInfoManager.instrance.getPetTemplateInfo(petDataObject.petProperty.templateID);
				petDataObject.petProperty.pet_magic_type = petDataObject.petTemplateInfo.id % 10; //魔法类型
				petDataObject.petProperty.pet_attack_type = petDataObject.petTemplateInfo.id * .1; //属性类型
				return petDataObject;

			}
			else if (_queryType == QueryType.ITEM)
			{
				var propData1:Object = UpdatePropsHelper.parsePropPacket(packet);
				return new ItemDataFactory(0, propData1.guid, propData1.props).newInstance();
			}
			else
			{
				log.error("错误的查询类型：queryType = " + _queryType);
				return null;
			}
		}
	}
}
