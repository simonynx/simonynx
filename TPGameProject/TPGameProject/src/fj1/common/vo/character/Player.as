package fj1.common.vo.character
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import fj1.common.GameInstance;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.manager.AvatarManager;
	import fj1.manager.FunctionSwitchManager;
	import fj1.manager.HeadFaceManager;
//	import fj1.modules.task.model.vo.TaskData;
//	import fj1.modules.task.model.vo.TaskType;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.utils.Dictionary;

	import tempest.common.staticdata.Colors;
	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.staticdata.Status;
	import tempest.ui.collections.TArrayCollection;

	public class Player extends BaseCharacter
	{
		private static const MUSE_SHAKE_DISTANCE:int = 25;

		public function Player(sc:SceneCharacter)
		{
			super(sc);
			_sc.setBarVisible(true);
			_sc.headLayer.y -= 10;
		}
//		[Bindable]
//		public var professions:uint; //职业
//		[Bindable]
//		public var gender:uint;
//		[Bindable]
//		public var headIcon:uint;
		private var _pkMode:uint;
		private var _teamId:int;
		[Bindable]
		public var temaCaptain:int;
		private var _teamName:String = "";
		private var _guildGuid:int; //公会ID
		[Bindable]
		private var _guildPost:int; //公会职位
		[Bindable]
		private var _guildContribution:int; //公会贡献
		private var _guildLevel:int; //公会等级
		private var _guildName:String = ""; //公会名字
		/**
		 * 角色神力阶段
		 */
		[Bindable]
		public var godPowerLevel:String;
		private var _profeBaseGodPower:int = 0;
		private var _godHoodGodPower:int = 0;
		private var _pointGodPower:int = 0;
		private var _petGodPower:int = 0;
		private var _equipGodPower:int = 0;
		private var _statusGodPower:int = 0;
		private var _spellGodPower:int = 0;
		private var _horseGodPower:int = 0;
		private var _vipAll:int = 0;
		private var _vip:int = 0;
		private var _vipLastTime:int = 0;
		private var _advanceVIPTime:int = 0; //尊贵VIP到期时间
		[Bindable]
		public var vipFlag:int = 0;

		/**
		 *
		 * @return
		 *
		 */
		public function get isInGuild():Boolean
		{
			return guildGuid != 0;
		}

		public function get guildGuid():int
		{
			return _guildGuid;
		}

		/**
		 * 公会ID
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0061")]
		public function set guildGuid(value:int):void
		{
			_guildGuid = value;
		}

		public function get guildPost():int
		{
			return _guildPost;
		}

		/**
		 * 公会职位
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0062")]
		public function set guildPost(value:int):void
		{
			if (_guildPost != value)
			{
				_guildPost = value;
				HeadFaceManager.updateCharCustomHtmlText([this._sc]);
			}
		}

		/**
		 * 公会贡献
		 */
		public function get guildContribution():int
		{
			return _guildContribution;
		}

		/**
		 * 设置公会贡献
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0063")]
		public function set guildContribution(value:int):void
		{
			_guildContribution = value;
		}

		/**
		 * 公会等级
		 */
		public function get guildLevel():int
		{
			return _guildLevel;
		}

		/**
		 * 设置公会等级
		 * @param value
		 *
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0064")]
		public function set guildLevel(value:int):void
		{
			_guildLevel = value;
		}

		/********************************公会END**************************************/
		[Attribute(index = "UNIT_END + 0x004F")]
		public function set teamInfo(value:int):void
		{
			temaCaptain = value % 10;
			teamId = value / 10;
			HeadFaceManager.updateCharLeftIco([this.sc]);
		}

		/**
		 * 是否是队长
		 * @return
		 *
		 */
		public function get isCaptain():Boolean
		{
			return temaCaptain != 0;
		}

		[Bindable]
		public function get vip():int
		{
			return _vip;
		}

		public function set vip(value:int):void
		{
			if (_vip != value)
			{
				_updateProperty("vip", _vip, _vip = value);
				HeadFaceManager.updateCharLeftIco([this.sc]);
			}
		}

		/**
		 * 角色属否是VIP
		 * @param value
		 *
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x005D")]
		public function get vipAll():int
		{
			return _vipAll;
		}

		public function set vipAll(value:int):void
		{
			_vipAll = value;
			vip = value & 0xFFFF;
			vipFlag = value >> 16 & 0xFFFF;
		}

		public function get vipLastTime():int
		{
			return _vipLastTime;
		}

		[Attribute(index = "UNIT_END + 0x005E")]
		public function set vipLastTime(value:int):void
		{
			if (_vipLastTime != value)
			{
				_updateProperty("vipLastTime", _vipLastTime, _vipLastTime = value);
			}
//			if (isVIP)
//			{
//				var surportData:SurportData = VipDataManager.instance.getSurportData(VIPConst.SURPORT_NORMAL_VIP);
//				surportData.endDateTick = _vipLastTime ? (GameInstance.getServerTime(new Date().time) + _vipLastTime * 1000) : 0;
//			}
		}

		/**
		 * 是否是VIP
		 * @return
		 *
		 */
		public function get isVIP():Boolean
		{
			return _vip > 0;
		}

		/**
		 * 尊贵VIP到期时间
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0087")]
		public function set advanceVIPTime(value:int):void
		{
			if (_advanceVIPTime != value)
			{
				_updateProperty("advanceVIPTime", _advanceVIPTime, _advanceVIPTime = value);
				HeadFaceManager.updateCharLeftIco([this.sc]);
			}
		}

		public function get advanceVIPTime():int
		{
			return _advanceVIPTime;
		}
		/**
		 * VIP领取奖励状态标示
		 * @return
		 *
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0088")]
		public var advanceVIPFlag:int;

		[Bindable]
		public function set teamName(value:String):void
		{
			if (_teamName != value)
			{
				_teamName = value;
				HeadFaceManager.updateCharCustomHtmlText([this._sc]);
			}
		}

		public function get teamName():String
		{
			return _teamName;
		}

		public function get guildName():String
		{
			return _guildName;
		}

		[Bindable]
		public function set guildName(value:String):void
		{
			if (_guildName != value)
			{
				_guildName = value;
				HeadFaceManager.updateCharCustomHtmlText([this._sc]);
			}
		}

		/**
		 * 是否有队伍
		 * @return
		 *
		 */
		public function get isInTeam():Boolean
		{
			return teamId != 0;
		}

		/**
		 *是否为队友
		 * @return
		 *
		 */
		public function get isTeamMate():Boolean
		{
			return (this.teamId == GameInstance.mainCharData.teamId);
		}

//		/**
//		 * 基础属性
//		 * 包含职业、性别、头像
//		 * @return
//		 */
//		[Attribute(index = "UNIT_END + 0x0001")]
//		public function get baseProperty():uint
//		{
//			return professions | (gender << 8) | (headIcon << 16) | (pkMode << 24);
//		}

		/**
		 *PK值
		 * @return
		 *
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0032")] //罪恶值
		public function set pk_value(value:int):void
		{
			_updateProperty("pk_value", _pk_value, _pk_value = value);
			HeadFaceManager.updateNickCharName([this._sc], false, true);
		}
		private var _pk_value:int;

		public function get pk_value():int
		{
			return _pk_value;
		}
		private var _pk_state:int = 0;
		private var _gmLevel:int = 0;
		private var _gmFlag:int = 0;

		[Attribute(index = "UNIT_END + 0x0005")] //设置白蓝红名
		public function set pk_state(value:int):void
		{
			_gmLevel = (value & 0xFF00) >> 8;
			if (_pk_state != int(value & 0xFF))
			{
				_pk_state = value & 0xFF;
				HeadFaceManager.updateNickCharName([this._sc], false, true);
			}
			if (_gmFlag != int((value & 0xFF0000) >> 16))
			{
				_gmFlag = (value & 0xFF0000) >> 16;
				HeadFaceManager.updateNickCharName([this._sc], true, false);
			}
		}

		public function get pk_state():int
		{
			return _pk_state;
		}

		///////////////////////////
//		public function set baseProperty(value:uint):void
//		{
//			professions = value & 0xFF;
//			gender = (value & 0xFF00) >> 8;
//			headIcon = (value & 0xFF0000) >> 16;
//			pkMode = (value & 0xFF000000) >> 24;
//		}

		[Bindable]
		[Attribute(index = "UNIT_END + 0x0017")] //27
		public override function get weaponModelId():int
		{
			return super.weaponModelId;
		}

		public override function set weaponModelId(value:int):void
		{
			super.weaponModelId = value;
		}
		private var _mountId:int = 0;
		private var _mountGuid:int;

		/**
		 * 玩家当前坐骑guid
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0045")]
		public function set mountGuid(value:int):void
		{
			_mountGuid = value;
		}

		public function get mountGuid():int
		{
			return _mountGuid;
		}

		public function get mountId():int
		{
			return _mountId;
		}

		/**
		 *玩家坐骑模型ID
		 */
		[Attribute(index = "UNIT_END + 0x0044")]
		public function set mountId(value:int):void
		{
			if (value != _mountId)
			{
				_updateProperty("mountId", _mountId, _mountId = value, true);
				mountModelId = _mountId;
			}
		}

		private var _titleId0:int = 0; //称号0
		private var _titleId1:int = 0; //称号1
		private var _titleId2:int = 0; //称号2
		private var _titleId3:int = 0; //称号3

		private var _titleId4:int = 0; //称号4
		/**
		 * 称号0
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0050")]
		public function set titleId0(value:int):void
		{
			if (_titleId0 == value)
			{
				return;
			}
			_titleId0 = value;
			HeadFaceManager.updateCharTopIco([this._sc]);
		}

		public function get titleId0():int
		{
			return _titleId0;
		}

		/**
		 * 称号1
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0051")]
		public function set titleId1(value:int):void
		{
			if (_titleId1 == value)
			{
				return;
			}
			_titleId1 = value;
			HeadFaceManager.updateCharTopIco([this._sc]);
		}

		public function get titleId1():int
		{
			return _titleId1;
		}

		/**
		 * 称号2
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0052")]
		public function set titleId2(value:int):void
		{
			if (_titleId2 == value)
			{
				return;
			}
			_titleId2 = value;
			HeadFaceManager.updateCharTopIco([this._sc]);
		}

		public function get titleId2():int
		{
			return _titleId2;
		}

		/**
		 * 称号3
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0053")]
		public function set titleId3(value:int):void
		{
			if (_titleId3 == value)
			{
				return;
			}
			_titleId3 = value;
			HeadFaceManager.updateCharTopIco([this._sc]);
		}

		public function get titleId3():int
		{
			return _titleId3;
		}

		/**
		 * 称号4
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0054")]
		public function set titleId4(value:int):void
		{
			if (_titleId4 == value)
			{
				return;
			}
			_updateProperty("titleId4", _titleId4, _titleId4 = value, true);
			HeadFaceManager.updateCharCustomHtmlText([this._sc]);
		}

		public function get titleId4():int
		{
			return _titleId4;
		}
		private var _military_rank:int = 0;

		/**
		 *军衔等级
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x00A1")]
		public function set military_rank(value:int):void
		{
			_military_rank = value;
			HeadFaceManager.updateCharTopIco([this._sc]);
		}

		public function get military_rank():int
		{
			return _military_rank;
		}

//		override public function set isMouseOn(value:Boolean):void
//		{
//			if (this._sc.isMouseOn != value)
//			{
//				if (this._sc.isMouseOn = value)
//				{
//					this._sc.avatar.filters = [new DropShadowFilter(0, 45, Colors.Green, 1, 7, 7)];
//				}
//				else
//					this._sc.avatar.filters = null;
//			}
//		}

		////////////////////////////////////////////////////////////
		private var _fashionModel:int;

		/**
		 * 时装模型id
		 * @param value
		 *
		 *
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0018")]
		public function set fashionModel(value:int):void
		{
			if (_fashionModel != value)
			{
				_fashionModel = value;
				AvatarManager.updateAvatar(this._sc, false, false, true);
			}
		}

		public function get fashionModel():int
		{
			return _fashionModel;
		}

		private var _fashionWeaponModel:int;

		/**
		 * 时装武器模型id
		 * @param value
		 *
		 *
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0019")]
		public function set fashionWeaponModel(value:int):void
		{
			if (_fashionWeaponModel != value)
			{
				_fashionWeaponModel = value;
				AvatarManager.updateAvatar(this._sc, false, false, false, true);
			}
		}

		public function get fashionWeaponModel():int
		{
			return _fashionWeaponModel;
		}

		/**
		 * 获取body模型id
		 * @param includeExtCloth 是否包含变身模型(包括变身功能)
		 * @return
		 *
		 */
		override public function getBodyModelId(includeExtCloth:Boolean):int
		{
			if (includeExtCloth)
			{
				if (extClothId > 0)
				{
					return extClothId;
				}
				else if (transformModel > 0)
				{
					return transformModel;
				}
			}
			if (_fashionModel > 0)
			{
				return _fashionModel;
			}
			else
			{
				return _bodyModelId;
			}
		}

		/**
		 * 获取武器模型id
		 * @return
		 *
		 */
		override public function getWeaponModelId():int
		{
			if (_fashionWeaponModel > 0) //优先使用时装武器
			{
				return _fashionWeaponModel;
			}
			else
			{
				return weaponModelId;
			}
		}

		/**
		 * 翅膀模型
		 * @param value
		 *
		 */
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0016")]
		override public function set wingModelId(value:int):void
		{
			if (super.wingModelId != value)
			{
				super.wingModelId = value;
				AvatarManager.updateAvatar(this._sc, false, false, false, false, true);
			}
		}

		override public function get wingModelId():int
		{
			return super.wingModelId;
		}

		////////////////////////////////////////////////////////////
		public function get isGM():Boolean
		{
			return _gmFlag != 0;
		}
		private var _godPowerIsOpen:Boolean = false;

		private var _godPowerEruptIsOpen:Boolean; //神力爆发
		/**
		 *  服务器广播其他玩家的开关系统
		 */
		[Attribute(index = "UNIT_END + 0x0007")]
		public function set player_function_switch(value:uint):void
		{
			var switchString:String = value.toString(2);
			var length:int = switchString.length;
			for (var i:int = FunctionSwitchManager.GODHOODSWTICH; i < length; i++)
			{
				var isOpen:Boolean = Boolean(value & (1 << i));
				switchDiction[i] = isOpen;
			}

			//更新头顶图标
			HeadFaceManager.updateCharLeftIco([this._sc]);
		}

		/**
		 * 神力爆发是否开启
		 * @return
		 *
		 */
		public function get godPowerEruptIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.GODPOWERERUPT];
		}

		/**
		 * 是否觉醒
		 * @return
		 *
		 */
		public function get isAwaken():Boolean
		{
			return switchDiction[FunctionSwitchManager.AWAKEN];
		}

		/**
		 * 神格是否开启
		 */
		public function get godHoodIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.GODHOODSWTICH];
		}

		/**
		 * 神力是否开启
		 */
		public function get godPowerIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.GODPOWERSWITCH];
		}

		/**
		 * 宠物是否开启
		 */
		public function get petIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.PETSWITCH];
		}

		/**
		 *  精通是否开启
		 */
		public function get masteryIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.MASTERYSWITCH];
		}

		/**
		 * 坐骑是否开启
		 */
		public function get horseIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.HORSESWTICH];
		}

		/**
		 * 太阳神是否开启
		 */
		public function get sunGodIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.SUNGODSWITCH];
		}

		/**
		 * 精通是否全开，并且使用雕琢秘药激活了隐藏属性
		 * @return
		 *
		 */
		public function get hasAllJt_addFreePoint():Boolean
		{
			return switchDiction[FunctionSwitchManager.HASALLJTADDFREEPOINT];
		}

		/**
		 * 是否使用圣光秘药
		 */
		public function get IsAllEquipSoulFull():Boolean
		{
			return switchDiction[FunctionSwitchManager.ISALLEQUIPSOULFULL];
		}

		/**
		 *寻宝是否开启
		 * @return
		 *
		 */
		public function get archIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.ARCHAEOLOGY];
		}

		/**
		 * 装备强化是否开启
		 * @return
		 *
		 */
		public function get equipStrengthenIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.EQUIP_STRENG];
		}

		/**
		 * 龙曜宝典是否开启
		 * @return
		 *
		 */
		public function get esotericalIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.ESOTERICAL];
		}

		/**
		 * 占星是否开启
		 * @return
		 *
		 */
		public function get watchStarIsOpen():Boolean
		{
			return switchDiction[FunctionSwitchManager.WATCHSTAR];
		}

		/**
		 * 所有的开关功能标示
		 */
		public var switchDiction:Dictionary = new Dictionary();

		/**
		 * 根据功能模块的索引来获取此模块是否开启
		 * @param module
		 * @return
		 *
		 */
		public function getSwitchIsOpenByModule(module:int):Boolean
		{
			return switchDiction[module];
		}

		[Bindable]
		public function get teamId():int
		{
			return _teamId;
		}

		public function set teamId(value:int):void
		{
			_teamId = value;
		}

	}
}


