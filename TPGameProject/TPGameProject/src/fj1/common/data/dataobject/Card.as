package fj1.common.data.dataobject
{
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.data.interfaces.ISlotItem;
	import fj1.common.res.ResPaths;
	import fj1.common.res.card.CardTemplateManager;
	import fj1.common.res.card.vo.CardStarLevelTemplate;
	import fj1.common.res.card.vo.CardTemplate;
	import fj1.common.staticdata.StatusType;
	import fj1.common.vo.character.BaseCharacter;
	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.avatar.Avatar;
	import tempest.engine.graphics.avatar.AvatarPartType;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;
	import tempest.ui.interfaces.IIcon;
	import tempest.ui.interfaces.IToolTipClient;
	import tempest.utils.Fun;

	[Bindable]
	public class Card extends BaseCharacter implements ISlotItem, IIcon
	{
		private var _guId:int;
		private var _typeId:int;
		private var _needShowNum:Boolean;
		private var _num:int;
		private var _locked:Boolean;
		private var _slot:int;
		private var _ownerId:int;
		private var _cardTemplate:CardTemplate;
		private var _cardStarLevelTemplate:CardStarLevelTemplate;
		private var _starLevel:int;
		private var _state:int;
		[Attribute(index = "OBJECT_FIELD_ENTRY")]
		public var template:int;

		public function Card(ownerId:int, guId:int, cardTemplate:CardTemplate, sc:SceneCharacter)
		{
			super(sc);
			_guId = guId;
			_ownerId = ownerId;
			_cardTemplate = cardTemplate;
		}

		public function get guId():uint
		{
			return _guId;
		}

		public function get typeId():uint
		{
			return _typeId;
		}

		public function get cardTemplate():CardTemplate
		{
			return _cardTemplate;
		}

		public function copy():ICopyable
		{
			var newCard:Card = new Card(_ownerId, guId, _cardTemplate, _sc);
			Fun.copyProperties(newCard, this);
			return newCard;
		}

		/**
		 * 星级
		 * @param value
		 *
		 */
		public function set starLevel(value:int):void
		{
			if (_starLevel == value)
			{
				return;
			}
			_starLevel = value;
			_cardStarLevelTemplate = CardTemplateManager.getStarLevelTemplate(_starLevel);
		}

		public function get starLevel():int
		{
			return _starLevel;
		}

		public function get cardStarLevelTemplate():CardStarLevelTemplate
		{
			return _cardStarLevelTemplate;
		}

		public function getNumStr(value:int):String
		{
			return num.toString();
		}

		public function get needShowNum():Boolean
		{
			return _needShowNum;
		}

		public function set needShowNum(value:Boolean):void
		{
			_needShowNum = value;
		}

		public function get num():int
		{
			return _num;
		}

		[Attribute(index = "OBJECT_FIELD_ENTRY + 0x0002")]
		public function set num(value:int):void
		{
			_num = value;
		}

		public function get locked():Boolean
		{
			return _locked;
		}

		public function set locked(value:Boolean):void
		{
			_locked = value;
		}

		[Attribute(index = "OBJECT_FIELD_ENTRY + 0x0001")]
		public function get slot():int
		{
			return _slot;
		}

		public function set slot(value:int):void
		{
			_slot = value;
		}

		public function get templateId():int
		{
			return _cardTemplate.id;
		}

		public function canCombine(targetItem:ISlotItem):Boolean
		{
			return false;
		}

		public function getCmpValue(name:String):int
		{
			return 0;
		}

		public function get max_stack():int
		{
			return 0;
		}

		public function get subtype():int
		{
			return 0;
		}

		public function get type():int
		{
			return 0;
		}

		public function createAvatar():Avatar
		{
			var avatar:Avatar = new Avatar(null);
			avatar.addAvatarPart(new AvatarPartData(AvatarPartType.CLOTH, ResPaths.getCharacterPath(_cardTemplate.model_id, StatusType.STAND)));
			return avatar;
		}

		public function getIconUrl(sizeType:int = -1):String
		{
			return ResPaths.getIconPath(_cardTemplate.face_ico, sizeType);
		}

		public function get quality():int
		{
			var ret:int = _starLevel - 1;
			if (ret < 1)
			{
				ret = 1;
			}
			return ret;
		}

		public function get toolTipShower():IToolTipClient
		{
			return null;
		}

		public function get attack():int
		{
			return 0;
		}

		public function get defence():int
		{
			return 0;
		}

		/**
		 * 出战状态
		 * @return
		 *
		 */
		public function get state():int
		{
			return _state;
		}

		/**
		 * 出战状态
		 * @param value
		 *
		 */
		public function set state(value:int):void
		{
			_state = value;
		}
	}
}
