package fj1.common.net.tcpLoader
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.HeroRewardItemData;
	import fj1.common.data.dataobject.PetObjectData;
	import fj1.common.data.dataobject.PlayerQueryData;
	import fj1.common.data.dataobject.items.EquipmentData;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.helper.QueryHelper;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.res.god.GodHoodManager;
	import fj1.common.res.mount.vo.MountData;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.PetConst;
	import fj1.common.staticdata.QueryType;
	import fj1.common.staticdata.RewardConst;
	import fj1.common.vo.character.Hero;
	import fj1.common.vo.character.Player;
	import fj1.manager.EquipmentManager;
	import fj1.manager.FunctionSwitchManager;
	import fj1.manager.SunGodDataManager;
	import fj1.modules.attribute.model.vo.SunGodState;
	import fj1.modules.attribute.staticdata.SungodConst;
	import fj1.modules.equipment.model.vo.EquipLocationData;
	import tempest.common.net.vo.TPacketIn;

	public class PlayerDataLoader extends TCPLoader
	{
		private var _playerId:int;

		public function PlayerDataLoader(playerId:int)
		{
			_playerId = playerId;
			super();
		}

		override public function load():void
		{
			super.load();
			if (GameInstance.mainChar.id == _playerId)
			{
				//英雄自身则不用发起查询
				var hero:Hero = GameInstance.mainCharData;
				var playerQueryData:PlayerQueryData = new PlayerQueryData();
				playerQueryData.guid = _playerId;
				playerQueryData.name = hero.name;
				playerQueryData.professions = hero.professions;
				playerQueryData.level = hero.level;
				playerQueryData.bodyModelId = hero.getBodyModelId(false);
				playerQueryData.weaponModelId = hero.getWeaponModelId();
				playerQueryData.wingModelId = hero.wingModelId;
				playerQueryData.godPowerAll = hero.deity_power;
				playerQueryData.pkValue = hero.pk_value;
				playerQueryData.hunterLevel = hero.reward_level;
				playerQueryData.headIcon = hero.headIcon;
				playerQueryData.guildName = hero.guildName;
				//坐骑
				var defaultMount:MountData = GameInstance.model.mount.defaultMount;
				if (defaultMount)
				{
					playerQueryData.horseTemplateId = defaultMount.mountInfo.id;
					playerQueryData.horseModelId = defaultMount.changeModelID;
					playerQueryData.horseExp = defaultMount.currentExp;
				}
				//宠物
				var battlePet:PetObjectData = GameInstance.model.pet.getPetDataByState(PetConst.PET_STATE_BATTLE);
				playerQueryData.battlePetGuid = battlePet ? battlePet.guId : 0;
				var unitPet:PetObjectData = GameInstance.model.pet.getPetDataByState(PetConst.PET_STATE_UNITE);
				playerQueryData.unitPetGuid = unitPet ? unitPet.guId : 0;
				//神格
				playerQueryData.godHoodGodPower = hero.godPowerFromGodHood;
				playerQueryData.godHoodValue = GodHoodManager.instance.totalGodHood;
				playerQueryData.valorLev = hero.godhood_levOrin & 0xFF;
				playerQueryData.brawninessLev = (hero.godhood_levOrin & 0xFF00) >> 8;
				playerQueryData.diligencyLev = (hero.godhood_levOrin & 0xFF0000) >> 16;
				playerQueryData.rafaleLev = (hero.godhood_levOrin & 0xFF000000) >> 24;
				playerQueryData.godhoodType = Player.getGodhoodLev(playerQueryData.valorLev, playerQueryData.brawninessLev, playerQueryData.diligencyLev, playerQueryData.rafaleLev); //神格阶段;
				//攻防体敏点数
				playerQueryData.attackPoint = hero.gPoint;
				playerQueryData.defensePoint = hero.fPoint;
				playerQueryData.delicacyPoint = hero.mPoint;
				playerQueryData.bodyPoint = hero.tPoint;
				//生命值魔法值
				playerQueryData.health = hero.health;
				playerQueryData.healthMax = hero.healthMax;
				playerQueryData.mana = hero.mana;
				playerQueryData.manaMax = hero.manaMax;
				//攻击防御敏捷暴击
				playerQueryData.pointGodPower = hero.godPowerFromPoint;
				playerQueryData.attack = hero.attact;
				playerQueryData.defense = hero.definse;
				playerQueryData.delicacy = hero.delicacy;
				playerQueryData.hayMaker = hero.heyMaker;
				//白黑青血魔法力
				playerQueryData.whiteMagic = hero.white_magic;
				playerQueryData.blackMagic = hero.black_magic;
				playerQueryData.blueMagic = hero.blue_magic;
				playerQueryData.bloodMagic = hero.red_magic;
				//当前称号
				playerQueryData.currentTitleId = hero.titleId0;
				//装备部位列表
				playerQueryData.equipGodPower = hero.godPowerFromEquipment;
				playerQueryData.equipLocList = EquipmentManager.instance.locationDataList.source;
				//功能开关
				playerQueryData.switchDiction = hero.switchDiction;
				//太阳神
				var sunGodStatus:SunGodState = SunGodDataManager.instance.getSunGodState(SungodConst.TYPE_SUN_GOD);
				playerQueryData.sunGodId = sunGodStatus.sunGodID;
				playerQueryData.sunGodExp = sunGodStatus.sunGodExp;
				playerQueryData.sunGodSlowExp = sunGodStatus.sunGodSlowExp;
//				//赏金声望列表
				playerQueryData.rewardList = [
					new HeroRewardItemData(RewardConst.CAMP_REWARD),
					new HeroRewardItemData(RewardConst.CAMP_DIJING),
					new HeroRewardItemData(RewardConst.CAMP_SHENMIAO),
					new HeroRewardItemData(RewardConst.CAMP_BEIBU),
					new HeroRewardItemData(RewardConst.CAMP_FASHI),
					new HeroRewardItemData(RewardConst.CAMP_AIREN),
					new HeroRewardItemData(RewardConst.CAMP_JINGLING),
					new HeroRewardItemData(RewardConst.CAMP_LONGZU)
					];
				//契灵
				playerQueryData.qilingData = SunGodDataManager.instance.getSunGodState(SungodConst.TYPE_QILING);
				playerQueryData.qilingHP = hero.qilingHP;
				//军衔
				playerQueryData.military_rank = hero.military_rank;
				//功勋
				playerQueryData.gongxun = hero.gongxun;
				//
				this.resiveData2(playerQueryData);
			}
			else
			{
				QueryHelper.query(loaderId, _playerId, 0, QueryType.CHR);
			}
		}

		public function get playerId():int
		{
			return _playerId;
		}

		override protected function analysisResponse(packet:TPacketIn):Object
		{
			var playerQueryData:PlayerQueryData = new PlayerQueryData();
			playerQueryData.guid = _playerId;
			playerQueryData.name = packet.readUTF();
			playerQueryData.professions = packet.readByte();
			playerQueryData.level = packet.readUnsignedInt();
			playerQueryData.bodyModelId = packet.readUnsignedInt();
			playerQueryData.weaponModelId = packet.readUnsignedInt();
			playerQueryData.wingModelId = packet.readUnsignedInt();
			//设置精通
			for (var i:int = 0; i < ItemConst.EQUIP_POS_NUM; i++)
			{
				var equipLoc:EquipLocationData = new EquipLocationData(i);
				if (equipLoc.starsData)
				{
					equipLoc.starsData.updateAll2(packet.readUnsignedInt());
				}
				playerQueryData.equipLocList.push(equipLoc);
			}
			//设置装备
			var nCount:int = packet.readByte();
			for (var j:int = 0; j < nCount; j++)
			{
				var guid:int = packet.readUnsignedInt();
				var template:int = packet.readUnsignedInt();
				var equipmentData:EquipmentData = EquipmentData(ItemDataFactory.createByID(playerQueryData.guid, guid, template));
				var locationData:EquipLocationData = playerQueryData.equipLocList[equipmentData.equipmentTemplate.subtype];
				locationData.equipmentData = equipmentData;
			}
			playerQueryData.godPowerAll = packet.readUnsignedInt(); //神力
			playerQueryData.pkValue = packet.readUnsignedInt(); //PK值
			playerQueryData.hunterLevel = packet.readUnsignedInt(); //赏金猎人等级
			//坐骑
			playerQueryData.horseTemplateId = packet.readUnsignedInt();
			playerQueryData.horseModelId = packet.readUnsignedInt();
			playerQueryData.horseExp = packet.readUnsignedInt();
			//宠物
			playerQueryData.battlePetGuid = packet.readUnsignedInt();
			playerQueryData.unitPetGuid = packet.readUnsignedInt();
			//星座（神格）
			playerQueryData.godHoodValue = packet.readUnsignedInt();
			playerQueryData.valorLev = playerQueryData.godHoodValue & 0xFF; //勇猛
			playerQueryData.brawninessLev = (playerQueryData.godHoodValue & 0xFF00) >> 8; //顽强
			playerQueryData.diligencyLev = (playerQueryData.godHoodValue & 0xFF0000) >> 16; //坚韧
			playerQueryData.rafaleLev = (playerQueryData.godHoodValue & 0xFF000000) >> 24; //迅捷
			playerQueryData.godhoodType = Player.getGodhoodLev(playerQueryData.valorLev, playerQueryData.brawninessLev, playerQueryData.diligencyLev, playerQueryData.rafaleLev); //神格阶段
			//攻防敏体点数
			playerQueryData.attackPoint = packet.readUnsignedInt();
			playerQueryData.defensePoint = packet.readUnsignedInt();
			playerQueryData.delicacyPoint = packet.readUnsignedInt();
			playerQueryData.bodyPoint = packet.readUnsignedInt();
			playerQueryData.point = packet.readUnsignedInt();
			//攻击力 防御力 敏捷 暴击
			playerQueryData.attack = packet.readUnsignedInt();
			playerQueryData.defense = packet.readUnsignedInt();
			playerQueryData.delicacy = packet.readUnsignedInt();
			playerQueryData.hayMaker = packet.readUnsignedInt();
			playerQueryData.broken = packet.readUnsignedInt();
			playerQueryData.miss = packet.readUnsignedInt();
			//白黑青血魔法力
			playerQueryData.whiteMagic = packet.readUnsignedInt();
			playerQueryData.blackMagic = packet.readUnsignedInt();
			playerQueryData.blueMagic = packet.readUnsignedInt();
			playerQueryData.bloodMagic = packet.readUnsignedInt();
			//头像
			playerQueryData.headIcon = packet.readUnsignedInt();
			//公会名称
			playerQueryData.guildName = packet.readUTF();
			//HP，MP
			playerQueryData.health = packet.readUnsignedInt();
			playerQueryData.healthMax = packet.readUnsignedInt();
			playerQueryData.mana = packet.readUnsignedInt();
			playerQueryData.manaMax = packet.readUnsignedInt();
			//业务系统开关
			var switchNum:int = packet.readUnsignedInt();
			var switchString:String = switchNum.toString(2);
			var switchLength:int = switchString.length;
			for (var k:int = FunctionSwitchManager.GODHOODSWTICH; k < switchLength; k++)
			{
//				playerQueryData.switchDiction[k] = Boolean(parseInt(switchString.charAt(switchLength - k - 1)));
				playerQueryData.switchDiction[k] = Boolean(switchNum & (1 << k))
			}
			//当前称号
			playerQueryData.currentTitleId = packet.readUnsignedInt();
			//装备总神力加成
			playerQueryData.equipGodPower = packet.readUnsignedInt();
			//神格神力
			playerQueryData.godHoodGodPower = packet.readInt();
			//属性点神力
			playerQueryData.pointGodPower = packet.readInt();
			//太阳神
			playerQueryData.sunGodId = packet.readUnsignedInt();
			playerQueryData.sunGodExp = packet.readUnsignedInt();
			playerQueryData.sunGodFailedTimes = packet.readUnsignedInt();
			playerQueryData.sunGodSlowExp = packet.readUnsignedInt();
			//契灵
			playerQueryData.qilingData = new SunGodState();
			playerQueryData.qilingData.sunGodID = packet.readUnsignedInt();
			playerQueryData.qilingData.sunGodExp = packet.readUnsignedInt();
			playerQueryData.qilingData.sunGodFialTimes = packet.readUnsignedInt();
			playerQueryData.qilingHP = packet.readUnsignedInt();
			//赏金声望列表
			playerQueryData.rewardList = [
				new HeroRewardItemData(RewardConst.CAMP_REWARD),
				new HeroRewardItemData(RewardConst.CAMP_DIJING),
				new HeroRewardItemData(RewardConst.CAMP_SHENMIAO),
				new HeroRewardItemData(RewardConst.CAMP_BEIBU),
				new HeroRewardItemData(RewardConst.CAMP_FASHI),
				new HeroRewardItemData(RewardConst.CAMP_AIREN),
				new HeroRewardItemData(RewardConst.CAMP_JINGLING),
				new HeroRewardItemData(RewardConst.CAMP_LONGZU)
				];
			//军衔
			playerQueryData.military_rank = packet.readUnsignedByte();
			//功勋
			playerQueryData.gongxun = packet.readUnsignedInt();
			//圣光秘药标示
			return playerQueryData;
		}
	}
}
