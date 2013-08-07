package fj1.common.vo.setting
{
	import fj1.common.GameInstance;
	import fj1.common.staticdata.SceneCharacterType;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import tempest.engine.SceneCharacter;

	public class SettingInfo
	{
		public var hideMonsterBar:Boolean = false;
		private var _hidePlayerAvatar:Boolean = false;
		private var _hidePetAvatar:Boolean = false;
		private var _isHidePet:ISignal;
		private var _isHidePlayer:ISignal;

		public function get isHidePet():ISignal
		{
			return _isHidePet ||= new Signal();
		}

		public function get hidePetAvatar():Boolean
		{
			return _hidePetAvatar;
		}

		public function set hidePetAvatar(value:Boolean):void
		{
			_hidePetAvatar = value;
			GameInstance.scene.getCharsbyType(SceneCharacterType.PET).forEach(function(item:SceneCharacter, index:int, arr:Array):void
			{
				if (item.master != GameInstance.mainChar)
				{
					item.setAvatarVisible(!value);
				}
			});
			isHidePet.dispatch();
		}

		public function get isHidePlayer():ISignal
		{
			return _isHidePlayer ||= new Signal();
		}

		public function get hidePlayerAvatar():Boolean
		{
			return _hidePlayerAvatar;
		}

		public function set hidePlayerAvatar(value:Boolean):void
		{
			_hidePlayerAvatar = value;
			GameInstance.scene.getCharsbyType(SceneCharacterType.PLAYER).forEach(function(item:SceneCharacter, index:int, arr:Array):void
			{
				if (!item.isMainChar)
				{
					item.setAvatarVisible(!value);
				}
			});
			isHidePlayer.dispatch();
		}
	}
}
