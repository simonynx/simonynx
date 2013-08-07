package fj1.common.net.gamehandler.objupdate
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.DataObject;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.helper.ObjectCreateHelper;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.events.ObjectUpdateEvent;
	import fj1.common.helper.UpdatePropsHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.EquipmentTemplate;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.staticdata.ObjectType;
	import fj1.common.staticdata.ObjectUpdateConst;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.common.vo.character.BaseCharacter;
	import fj1.common.vo.character.Monster;
	import fj1.common.vo.character.Player;
	import fj1.manager.HeadFaceManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.main.MainFacade;
	import fj1.modules.scene.plugins.MonsterAIPlugin;
	import fj1.modules.scene.signals.SceneSignals;

	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	import mx.events.PropertyChangeEvent;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.net.IPacketHandler;
	import tempest.common.net.vo.TPacketIn;
	import tempest.core.ISocket;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.utils.AttributeManager;
	import tempest.utils.Fun;

	public class ObjectUpdateHandler implements IPacketHandler
	{
		private static const log:ILogger = TLog.getLogger(ObjectUpdateHandler);

		public function handPacket(socket:ISocket, packet:TPacketIn):void
		{
			while (packet.bytesAvailable)
			{
				var updateType:int = packet.readUnsignedByte(); //对象更新类型
				var guid:uint = packet.readUnsignedInt();
				//更新类型分支
				switch (updateType)
				{
					case ObjectUpdateConst.UPDATETYPE_VALUES: //更新属性
						updateObj(guid, packet);
						break;
					case ObjectUpdateConst.UPDATETYPE_CREATE_OBJECT: //创建对象
						createObj(guid, packet);
						break;
					case ObjectUpdateConst.UPDATETYPE_CREATE_HERO: //创建主角
						createHero(guid, packet);
						break;
				}
			}
		}

		/**
		 * 更新对象属性
		 * @param guid
		 * @param props
		 *
		 */
		public static function updateObj(guid:int, packet:TPacketIn):void
		{
			var props:Array = UpdatePropsHelper.parseMask(packet);
			if (guid == GameInstance.mainChar.id)
			{
				updatePropsEx(GameInstance.mainCharData, props);
			}
			else
			{
				var type:int = (uint(guid) * 0.000000001) >> 0;
				switch (type)
				{
					case ObjectType.TYPEID_PLAYER: //玩家
					case ObjectType.TYPEID_MONSTER: //怪物
						var character:SceneCharacter = GameInstance.scene.getCharacterById(guid);
						if (character)
						{
							updatePropsEx(character.data, props);
						}
						break;
					case ObjectType.TYPEID_DYNAMICOBJECT: //掉落物品
						break;
					case ObjectType.TYPEID_PET: //宠物
//						var pet:SceneCharacter = GameInstance.scene.getCharacterById(guid);
//						if (pet)
//						{
//							updatePropsEx(pet.data, props);
//						}
//						var petData:PetObjectData = GameInstance.model.pet.getPetData(guid);
//						if (petData)
//						{
//							updatePropsEx(petData.petProperty, props);
//						}
						break;
				}
			}
		}

		private static function updatePropsEx(obj:*, props:Array):void
		{
			//更新对象，并搜集属性变更事件
			ObjectCreateHelper.updateObj(obj, props, true);
		}

		private static var count:int = 0; //DEBUG

		/**
		 * 创建对象
		 * @param guid
		 * @param props
		 *
		 */
		public static function createObj(guid:int, packet:TPacketIn):void
		{
			var modelID:int = packet.readUnsignedInt();
			var props:Array = UpdatePropsHelper.parseMask(packet);
			var type:int = (uint(guid) * 0.000000001) >> 0;
			switch (type)
			{
				case ObjectType.TYPEID_MONSTER: //怪物
					var monster:SceneCharacter;
					if (!((monster = Monster.create(modelID)) == null))
					{
						monster.id = guid;
						packet.readUTF(); /*obj.fullName = */
						monster.tile_x = packet.readUnsignedShort();
						monster.tile_y = packet.readUnsignedShort();
						monster.dir = packet.readUnsignedByte();
						UpdatePropsHelper.updateProps(monster.data, props);
						HeadFaceManager.updateNickCharName([monster]);
						GameInstance.scene.addCharacter(monster);
						//添加怪物AI
						if (count < 1)
						{
							monster.addPlugin(new MonsterAIPlugin());
							++count;
						}
					}
					else
					{
						packet.readUTF();
						packet.readUnsignedShort();
						packet.readUnsignedShort();
						packet.readUnsignedByte();
						log.error("Monster id:{0} template is not exist templateID:{1}", guid, modelID);
					}
					break;
				case ObjectType.TYPEID_PLAYER: //玩家
					var player:SceneCharacter = new SceneCharacter(SceneCharacterType.PLAYER, GameInstance.scene);
					var playerData:Player = new Player(player);
					player.data = playerData;
					player.id = guid;
					playerData.name = packet.readUTF();
					player.tile_x = packet.readUnsignedShort();
					player.tile_y = packet.readUnsignedShort();
					player.dir = packet.readUnsignedByte();
					if (GameInstance.setting.hidePlayerAvatar)
					{
						player.setAvatarVisible(false);
					}
					UpdatePropsHelper.updateProps(player.data, props);
					HeadFaceManager.updateNickCharName([player]);
					GameInstance.scene.addCharacter(player);
					/////////////
					sceneSignal.addCharacter.dispatch(player);
//					//组队处理
//					GameInstance.model.team.onScenePlayerCreate(player);
//					//附近玩家
//					GameInstance.model.team.addData(GameInstance.model.team.nearPlayerListData, player);
					///////////////
					break;
				case ObjectType.TYPEID_PET: //宠物
//					var pet:SceneCharacter = new SceneCharacter(SceneCharacterType.PET, GameInstance.scene);
//					var petData:Pet = new Pet(pet);
//					pet.data = petData;
//					pet.id = guid;
//					petData.name = packet.readUTF();
//					pet.tile_x = packet.readUnsignedShort();
//					pet.tile_y = packet.readUnsignedShort();
//					pet.dir = packet.readUnsignedByte();
//					UpdatePropsHelper.updateProps(pet.data, props);
//					HeadFaceManager.updateNickCharName([pet]);
//					var master:SceneCharacter = GameInstance.scene.getCharacterById(Pet(pet.data).masterID);
//					if (master)
//					{
//						master.follower = pet;
//						pet.master = master;
//						pet.opacity = master.opacity;
//						if (!master.isMainChar && GameInstance.setting.hidePetAvatar)
//						{
//							pet.setAvatarVisible(false);
//						}
//						GameInstance.scene.addCharacter(pet);
//					}
//					else
//					{
//						log.error("Pet Master id:{0} can't find", pet.data.masterID);
//					}
					break;
				case ObjectType.TYPEID_DYNAMICOBJECT: //掉落物品
//					var dropItem:DropItem = new DropItem();
//					dropItem.id = guid;
//					packet.readUTF();
//					GameInstance.scene.addElement(dropItem);
//					dropItem.tile_x = packet.readUnsignedShort();
//					dropItem.tile_y = packet.readUnsignedShort();
//					packet.readUnsignedByte();
//					UpdatePropsHelper.updateProps(dropItem, props);
//					dropItem.tryPlaySound();
					break;
//				case ObjectType.TYPEID_MAGICWARD: //魔法阵
//					var magicward:MagicWard = (GameInstance.scene.getElementById(modelID, SceneCharacterType.MAGICWARD) as MagicWard);
//					if (magicward)
//					{
//						magicward.id = guid;
//						magicward.fullName = packet.readUTF();
//						magicward.tile_x = packet.readUnsignedShort();
//						magicward.tile_y = packet.readUnsignedShort();
//						packet.readUnsignedByte();
//						UpdatePropsHelper.updateProps(magicward, props);
//					}
//					else
//					{
//						packet.readUTF();
//						packet.readUnsignedShort();
//						packet.readUnsignedShort();
//						packet.readUnsignedByte();
//						log.error("MagicWard id:{0} template is not exist", guid);
//					}
//					break;
//				case ObjectType.TYPEID_HORSE: //坐骑
//					break;
			}
		}

		/**
		 * 创建英雄
		 * @param guid
		 * @param props
		 * @param packet
		 *
		 */
		private function createHero(guid:int, packet:TPacketIn):void
		{
			packet.readUnsignedInt();
			var props:Array = UpdatePropsHelper.parseMask(packet);
			var hero:SceneCharacter = GameInstance.mainChar;
			hero.id = guid;
			GameInstance.mainCharData.name = packet.readUTF();
			hero.tile_x = packet.readUnsignedShort();
			hero.tile_y = packet.readUnsignedShort();
			hero.dir = packet.readUnsignedByte();
			UpdatePropsHelper.updateProps(hero.data, props);
			HeadFaceManager.updateNickCharName([hero]);
		}

		private static function get sceneSignal():SceneSignals
		{
			return MainFacade.instance.inject.getInstance(SceneSignals) as SceneSignals;
		}
	}
}
