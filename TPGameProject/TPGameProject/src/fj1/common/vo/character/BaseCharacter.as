package fj1.common.vo.character
{
	import com.gskinner.motion.GTweener;

	import fj1.common.GameInstance;
//	import fj1.common.data.dataobject.StatusData;
//	import fj1.common.vo.character.info.AvatarInfo;
	import fj1.manager.AvatarManager;
	import fj1.manager.HeadFaceManager;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import mx.events.PropertyChangeEvent;

	import tempest.core.IDisposable;
	import tempest.engine.SceneCharacter;
	import tempest.engine.staticdata.Status;
	import tempest.ui.collections.TArrayCollection;

	public class BaseCharacter extends EventDispatcher implements IDisposable
	{
		protected var _sc:SceneCharacter;

//		protected var _avatarInfo:AvatarInfo = null;

		public function get sc():SceneCharacter
		{
			return _sc;
		}

//		public function get avatarInfo():AvatarInfo
//		{
//			return _avatarInfo ||= new AvatarInfo();
//		}
		/*********************角色状态属性******************************/
		public var statusDataList:Dictionary = null
		public var statusTree:TArrayCollection = null;

//		/**
//		 *删除状态数据
//		 * @param statusID
//		 *
//		 */
//		public function deleteStatus(statusID:int):void
//		{
//			var stausData:StatusData = statusDataList[statusID];
//			if (stausData)
//			{
//				statusTree.removeItem(stausData);
//				stausData = null;
//				delete statusDataList[statusID];
//			}
//		}
//
//		/**
//		 *根据状态ID获取状态
//		 * @return
//		 *
//		 */
//		public function getStatus(statusID:int):StatusData
//		{
//			return statusDataList[statusID];
//		}

		public function BaseCharacter(sc:SceneCharacter)
		{
			statusDataList = new Dictionary();
			statusTree = new TArrayCollection([]);
			_sc = sc;
		}
		/////////////////////////////状态限制/////////////////////////////
		/**
		 *是否限制移动
		 */
		public var isLimitMove:Boolean = false;
		/**
		 *是否限制使用技能
		 */
		public var isLimitSpell:Boolean = false;
		/**
		 *是否限制使用普通攻击
		 */
		public var isLimitAttack:Boolean = false;
		/**
		 *是否限制是否用物品
		 */
		public var isLimitItem:Boolean = false;
		/**
		 *是否限制冥想
		 */
		public var isLimitMuse:Boolean = false;
		/**
		 *是否限制传送
		 */
		public var isLimitTrasport:Boolean = false;
		/**
		 *是否限制采集
		 */
		public var isLimitCollect:Boolean = false;

		/**
		 * 更新属性
		 * @param property
		 * @param oldValue
		 * @param newValue
		 */
		protected function _updateProperty(property:String, oldValue:Object = null, newValue:Object = null, useEvent:Boolean = true):void
		{
			if (oldValue != newValue && useEvent)
			{
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, property, oldValue, newValue));
			}
		}

		public function dispose():void
		{
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////
		protected var _health:int = 0; //生命
		protected var _healthMax:int = 1;
		/**
		 * 魔法值
		 * @default
		 */
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x000C")]
		public var mana:int = 0;
		/**
		 * 最大魔法值
		 * @default
		 */
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x000D")]
		public var manaMax:int = 1;
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0004")]
		public var attact:uint = 0; //攻击
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0005")]
		public var definse:uint = 0; //防御
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0006")]
		public var delicacy:uint = 0; //灵巧
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0007")]
		public var heyMaker:uint = 0; //暴击

		/**
		*阵营
		*/
		private var _zhenying:int

		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0017")]
		public function set zhenying(value:int):void
		{
			_updateProperty("zhenying", _zhenying, _zhenying = value, false);
			HeadFaceManager.updateCharLeftIco([this._sc]);
		}

		public function get zhenying():int
		{
			return _zhenying;
		}
		private var _broken:int;

		/**
		 * 破甲
		 */
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0015")]
		public function set broken(value:int):void
		{
			_updateProperty("broken", _broken, _broken = value, false);
		}

		public function get broken():int
		{
			return _broken;
		}
		private var _transformModel:int;

		/**
		 * 变身卡ModelID
		 */
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0018")]
		public function set transformModel(value:int):void
		{
			if (_transformModel != value)
			{
				_transformModel = value;
				AvatarManager.updateAvatar(this._sc, true);
			}
		}

		public function get transformModel():int
		{
			return _transformModel;
		}

		private var _level:uint = 0;

		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0000")] //6
		public function get level():uint
		{
			return _level;
		}

		public function set level(value:uint):void
		{
			_level = value;
			if (_level != value)
			{
				_updateProperty("level", _level, _level = value, false);
			}
		}

		public function get health():int
		{
			return _health;
		}
		/**
		 *是否已死亡
		 */
		public var isDead:Boolean = false;

		/**
		 *血量
		 * @param value
		 */
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0001")] //7
		public function set health(value:int):void
		{
			if (_health != value)
			{
				var oldValue:int = _health;
				_updateProperty("health", _health, _health = value);
				this._sc.setBar(_health, _healthMax);
				if (_health == 0 && oldValue > 0)
				{
					isDead = true;
					this.onDead();
				}
				else if (oldValue == 0 && _health > 0)
				{
					isDead = false;
					this.onRevive();
				}
			}
		}

		protected function onDead():void
		{
			this._sc.playTo(Status.DEAD);
			if (GameInstance.selectChar != null && GameInstance.selectChar.id == this._sc.id)
			{
				GameInstance.selectChar = null;
			}
		}

		protected function onRevive():void
		{
			this._sc.playTo(Status.STAND);
		}

		/**
		 * 生命最大值
		 * @default
		 */
		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0002")] //8
		public function get healthMax():int
		{
			return _healthMax;
		}

		public function set healthMax(value:int):void
		{
			if (_healthMax != value)
			{
				_updateProperty("healthMax", _healthMax, _healthMax = value);
				this._sc.setBar(_health, _healthMax);
			}
		}
		private var _extClothId:int = 0;

		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x000E")]
		public function get extClothId():int
		{
			return _extClothId;
		}

		public function set extClothId(value:int):void
		{
			if (_extClothId != value)
			{
				_extClothId = value;
				AvatarManager.updateAvatar(this._sc, true);
			}
		}

		/**
		 * 获取变身形象id
		 * 当此id存在时，将屏蔽坐骑和武器显示
		 * @return
		 *
		 */
		public function getExtCloth():int
		{
			if (extClothId > 0)
			{
				return extClothId;
			}
			else if (transformModel > 0)
			{
				return transformModel;
			}
			else
			{
				return 0;
			}
		}

		/**
		 * 获取body模型id
		 * @param includeExtCloth 是否包含变身模型(包括变身功能)
		 * @return
		 *
		 */
		public function getBodyModelId(includeExtCloth:Boolean):int
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
			return _bodyModelId;
		}

		private var _size:Number = 10000;

		[Attribute(index = "WORLDOBJECT_END + 0x000F")]
		public function get size():Number
		{
			return _size;
		}

		public function set size(value:Number):void
		{
			if (_size != value)
			{
				_size = value;
				var s:Number = Math.max(0.1, Math.min((_size / 10000), 10));
				GTweener.to(this._sc, 1, {scaleX: s, scaleY: s})
			}
		}

		protected var _bodyModelId:int = 0; //装备模型ID
		/**
		 *
		 * @return
		 */
		[Bindable]
		[Attribute(index = "OBJECT_FIELD_ENTRY")]
		public function get bodyModelId():int
		{
			return _bodyModelId;
		}

		/**
		 *
		 * @param value
		 */
		public function set bodyModelId(value:int):void
		{
			if (_bodyModelId != value)
			{
				_updateProperty("bodyModelId", _bodyModelId, _bodyModelId = value, true);
				AvatarManager.updateAvatar(this._sc, false, false, true);
			}
		}
		private var _mountModelId:int = -1;

		public function get mountModelId():int
		{
			return _mountModelId;
		}

		public function set mountModelId(value:int):void
		{
			_mountModelId = value;
			if (_mountModelId > 0)
			{
				this._sc.isOnMount = true;
			}
			else
			{
				this._sc.isOnMount = false;
			}
			AvatarManager.updateAvatar(this._sc, false, true);
		}
		private var _weaponModelId:int = -1;

		public function get weaponModelId():int
		{
			return _weaponModelId;
		}

		public function set weaponModelId(value:int):void
		{
			if (_weaponModelId != value)
			{
				_updateProperty("weaponModelId", _weaponModelId, _weaponModelId = value, true);
				AvatarManager.updateAvatar(this._sc, false, false, false, true);
			}
		}

		private var _wingModelId:int

		/**
		 * 翅膀模型
		 * @param value
		 *
		 */
		public function set wingModelId(value:int):void
		{
			_wingModelId = value;
		}

		public function get wingModelId():int
		{
			return _wingModelId;
		}

		/**
		 * 获取武器模型id
		 * @return
		 *
		 */
		public function getWeaponModelId():int
		{
			return _weaponModelId;
		}

		[Bindable]
		[Attribute(index = "WORLDOBJECT_END + 0x0003")] //9
		public function get speed():int
		{
			return this._sc.walkData.walk_speed;
		}

		public function set speed(value:int):void
		{
			if (this._sc.walkData.walk_speed != value)
			{
				_updateProperty("speed", this._sc.walkData.walk_speed, this._sc.walkData.walk_speed = value);
			}
		}
		/////////////////////////////////////////////
		private var _name:String = "";

		[Bindable]
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_updateProperty("name", _name, _name = value, true);
			HeadFaceManager.updateNickCharName([this._sc], true, false);
		}
	}
}
