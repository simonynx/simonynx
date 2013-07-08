//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import GameUI.ConstData.*;
    import OopsEngine.Utils.*;

    public class PlayerSkinsController {

        public static function RemoveSkin(_arg1:String, _arg2:GameElementAnimal):void{
            _arg2.RemoveSkin(_arg1);
        }
        public static function GetMount(_arg1:uint):String{
            if (_arg1 == 0){
                return (null);
            };
            var _local2 = "";
            _local2 = ("?v=" + GameConfigData.PlayerVersion);
            return (((("Resources/Player/Mount/" + _arg1) + ".swf") + _local2));
        }
        public static function SetSkinMountData(_arg1:int, _arg2:GameElementAnimal):void{
            var _local3:String;
            var _local4:XML;
            var _local5:ItemTemplateInfo;
            var _local6:uint;
            var _local7:String;
            if (_arg1 == 0){
                _arg2.Role.MountSkinName = null;
                _arg2.SetMoveSpend(5);
                if (_arg2.Role.ConvoyFlag > 0){
                    ConvoyController.setMoveSpeed(_arg2);
                };
                _arg2.Skins.ChangeSkins = OnChangeSkins;
                RemoveSkin(GameElementSkins.EQUIP_MOUNT, _arg2);
            } else {
                _local3 = GetMount(_arg1);
                _arg2.Role.MountSkinName = _local3;
                _local5 = UIConstData.ItemDic[_arg2.Role.MountSkinID];
                if (_local5.Job > 0){
                    _arg2.Role.personMountSkinName = GetPersonMount(String(_arg2.Role.PersonSkinID));
                } else {
                    _local7 = String(((((String(_arg2.Role.MountSkinID) + "_") + String(_arg2.Role.CurrentJobID)) + "_") + String(_arg2.Role.Sex)));
                    _arg2.Role.personMountSkinName = GetPersonMount(_local7);
                };
                _local6 = 0;
                if (_local5 != null){
                    _local6 = (_local5.Color + 2);
                };
                _arg2.SetMoveSpend((5 + _local6));
                if (_arg2.Skins != null){
                    _arg2.Skins.ChangeSkins = OnChangeSkins;
                    _arg2.SetSkin(GameElementSkins.EQUIP_MOUNT, _arg2.Role.MountSkinName);
                    _arg2.SetSkin(GameElementSkins.EQUIP_PERSON_MOUNT, _arg2.Role.personMountSkinName);
                };
            };
        }
        public static function canSeeWeapon(_arg1:GameElementAnimal):Boolean{
            var _local2:ModelOffset;
            if (isOtherAvtavar(_arg1.Role.PersonSkinID)){
                return (false);
            };
            if (_arg1.Role.CurrentJobID != 0){
                if ((((_arg1.Role.WeaponSkinID == 20102001)) || ((_arg1.Role.WeaponSkinID == 20102002)))){
                    return (false);
                };
                _local2 = getSkinOffset(_arg1.Role);
                if (((_local2) && ((_local2.noseeWeapon == 1)))){
                    return (false);
                };
            };
            if (_arg1.Role.ActionState == GameElementSkins.ACTION_MEDITATION){
                return (false);
            };
            return (true);
        }
        public static function OnChangeSkins(_arg1:String, _arg2:GameElementAnimal):void{
            if (_arg2.isDispose){
                return;
            };
            if (_arg1 == GameElementSkins.EQUIP_MOUNT){
                if (_arg2.Role.Id == GameCommonData.Player.Role.Id){
                } else {
                    _arg2.Stop();
                };
                if (_arg2.Role.HP > 0){
                    if (_arg2.Role.MountSkinID != 0){
                        _arg2.Skins.ChangeAction(GameElementSkins.ACTION_MOUNT_STATIC, true);
                    } else {
                        if (_arg2.Role.IsMediation){
                            _arg2.Skins.ChangeAction(GameElementSkins.ACTION_MEDITATION, true);
                        } else {
                            _arg2.Skins.ChangeAction(GameElementSkins.ACTION_STATIC, true);
                        };
                    };
                };
            } else {
                _arg2.Skins.ChangeAction(_arg2.Role.ActionState, true);
            };
            if (_arg2.handler != null){
                _arg2.handler.Clear();
            };
        }
        public static function GetDress(_arg1:GameRole):String{
            var _local2:String = ("?v=" + GameConfigData.PlayerVersion);
            var _local3:String = String(_arg1.PersonSkinID);
            var _local4:ModelOffset = getSkinOffset(_arg1);
            if (((_local4) && (!((_local4.avatar == ""))))){
                _local3 = _local4.avatar;
            };
            return (((("Resources/Player/Person/" + _local3) + ".swf") + _local2));
        }
        public static function GetWeaponEffect(_arg1:uint, _arg2:uint, _arg3:int):String{
            if (_arg1 == 0){
                return (null);
            };
            var _local4:String = ("?v=" + GameConfigData.PlayerVersion);
            return (((((((("Resources/Player/WeaponEffect/" + _arg1) + "_") + 0) + "_") + _arg3) + ".swf") + _local4));
        }
        public static function SetSkinWeaponEffect(_arg1:int, _arg2:GameElementAnimal):void{
            var _local3:String;
            var _local4:int;
            if ((((_arg1 >= 5)) && ((_arg1 < 7)))){
                _local4 = 1;
            };
            if ((((_arg1 >= 7)) && ((_arg1 < 9)))){
                _local4 = 2;
            };
            if ((((_arg1 >= 9)) && ((_arg1 < 11)))){
                _local4 = 3;
            };
            if (_arg1 >= 11){
                _local4 = 4;
            };
            if (_local4 == 0){
                _arg2.Role.weaponEffectName = null;
                _arg2.Skins.ChangeSkins = OnChangeSkins;
                RemoveSkin(GameElementSkins.EQUIP_WEAPONE_EFFECT, _arg2);
            } else {
                _local3 = GetWeaponEffect(_arg2.Role.CurrentJobID, _arg2.Role.Sex, _local4);
                if (_local3){
                    _arg2.Role.weaponEffectName = _local3;
                    if (_arg2.Skins != null){
                        _arg2.Skins.ChangeSkins = OnChangeSkins;
                        _arg2.SetSkin(GameElementSkins.EQUIP_WEAPONE_EFFECT, _arg2.Role.weaponEffectName);
                    };
                };
            };
        }
        public static function getSkinOffset(_arg1:GameRole):ModelOffset{
            var _local2:String = String(_arg1.PersonSkinID);
            var _local3:ModelOffset = GameCommonData.ModelOffsetPlayer[_local2];
            if (_local3 == null){
                _local3 = GameCommonData.ModelOffsetPlayer[((_local2 + "_") + String(_arg1.CurrentJobID))];
            };
            return (_local3);
        }
        public static function GetPersonMount(_arg1:String):String{
            if (_arg1 == ""){
                return (null);
            };
            var _local2 = "";
            _local2 = ("?v=" + GameConfigData.PlayerVersion);
            return (((("Resources/Player/Person/Mount" + _arg1) + ".swf") + _local2));
        }
        public static function SetSkinWeapenData(_arg1:int, _arg2:GameElementAnimal):void{
            var _local3:String;
            if (_arg1 == 0){
                _arg2.Role.WeaponSkinName = null;
                _arg2.Skins.ChangeSkins = OnChangeSkins;
                RemoveSkin(GameElementSkins.EQUIP_WEAOIB, _arg2);
            } else {
                _local3 = GetWeapen(_arg1, _arg2.Role.Sex);
                _arg2.Role.WeaponSkinName = _local3;
                if (_arg2.Skins != null){
                    _arg2.Skins.ChangeSkins = OnChangeSkins;
                    _arg2.SetSkin(GameElementSkins.EQUIP_WEAOIB, _arg2.Role.WeaponSkinName);
                };
            };
        }
        public static function IsCanUse(_arg1:int, _arg2:int):Boolean{
            if (_arg1 != 0){
                return (true);
            };
            return (false);
        }
        public static function isOtherAvtavar(_arg1:int):Boolean{
            if ((((_arg1 >= 101)) && ((_arg1 <= 105)))){
                return (true);
            };
            return (false);
        }
        public static function GetWeapen(_arg1:uint, _arg2:uint):String{
            if (_arg1 == 0){
                return (null);
            };
            var _local3:String = ("?v=" + GameConfigData.PlayerVersion);
            return (((((("Resources/Player/Weapon/" + _arg1) + "_") + _arg2) + ".swf") + _local3));
        }
        public static function SetSkinPersonData(_arg1:int, _arg2:GameElementAnimal):void{
            var _local3:String;
            var _local4:ModelOffset;
            _local3 = GetDress(_arg2.Role);
            _arg2.Role.PersonSkinName = _local3;
            _local4 = getSkinOffset(_arg2.Role);
            if (_local4 != null){
                _arg2.Offset = new Point(_local4.X, _local4.Y);
                _arg2.OffsetHeight = _local4.H;
            };
            if (_arg2.Skins != null){
                _arg2.Skins.ChangeSkins = OnChangeSkins;
                _arg2.SetSkin(GameElementSkins.EQUIP_PERSON, _arg2.Role.PersonSkinName);
            };
        }
        public static function SetSkin(_arg1:String, _arg2:int, _arg3:GameElementAnimal):void{
            switch (_arg1){
                case GameElementSkins.EQUIP_WEAOIB:
                    SetSkinWeapenData(_arg2, _arg3);
                    break;
                case GameElementSkins.EQUIP_WEAPONE_EFFECT:
                    SetSkinWeaponEffect(_arg2, _arg3);
                    break;
                case GameElementSkins.EQUIP_PERSON:
                    SetSkinPersonData(_arg2, _arg3);
                    break;
                case GameElementSkins.EQUIP_MOUNT:
                    SetSkinMountData(_arg2, _arg3);
                    break;
            };
        }

    }
}//package Manager 
