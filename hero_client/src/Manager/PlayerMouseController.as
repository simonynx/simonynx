//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.MouseCursor.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.Modules.Pk.Data.*;

    public class PlayerMouseController {

        public static var CurrentSkinId:uint;

        public static function onMouseOverTarger(_arg1:GameElementAnimal):void{
            var _local2:Boolean;
            CurrentSkinId = _arg1.skins.SelfSkinId;
            switch (_arg1.Role.Type){
                case GameRole.TYPE_PLAYER:
                    _local2 = true;
                    if (_arg1.Role.Level < 30){
                        _local2 = false;
                    };
                    if ((((GameCommonData.Player.Role.idTeam == _arg1.Role.idTeam)) && (!((GameCommonData.Player.Role.idTeam == 0))))){
                        _local2 = false;
                    };
                    if (PkData.PkStateList[0] == true){
                        if ((((_arg1.Role.unityId == GameCommonData.Player.Role.unityId)) && (!((GameCommonData.Player.Role.unityId == 0))))){
                            _local2 = false;
                        };
                    };
                    if (PkData.PkStateList[1] == true){
                        if (_arg1.Role.PkTime == 0){
                            _local2 = false;
                        };
                    };
                    if (PkData.PkStateList[2] == true){
                        if (_arg1.Role.PkTime > 0){
                            _local2 = false;
                        };
                    };
                    if (_arg1 == GameCommonData.DuelAnimal){
                        _local2 = true;
                    };
                    if (_arg1.Role.ArenaTeamId == -1){
                        _local2 = false;
                    } else {
                        if (((!((GameCommonData.Player.Role.ArenaTeamId == 0))) && (!((_arg1.Role.ArenaTeamId == 0))))){
                            if (GameCommonData.Player.Role.ArenaTeamId != _arg1.Role.ArenaTeamId){
                                _local2 = true;
                            };
                        };
                    };
                    if (GameCommonData.GuildBattle_IsStarting){
                        if (_arg1.Role.unityId == GameCommonData.Player.Role.unityId){
                            _local2 = false;
                        } else {
                            if (_arg1.Role.unityId == UnityConstData.GuildBattle_TargetGuildID){
                                if (GameCommonData.Player.Role.Level < 30){
                                    _local2 = false;
                                };
                                _local2 = true;
                            };
                        };
                    };
                    if (_local2){
                        SysCursor.GetInstance().setMouseType(SysCursor.ATTACK_CURSOR);
                    } else {
                        SysCursor.GetInstance().revert();
                    };
                    break;
                case GameRole.TYPE_PET:
                    if (((!((GameCommonData.Player.Role.UsingPetAnimal == _arg1))) && (_arg1.Role.MasterPlayer))){
                        _local2 = true;
                        if (_arg1.Role.MasterPlayer.Role.Level < 30){
                            _local2 = false;
                        };
                        if ((((_arg1.Role.MasterPlayer.Role.idTeam == GameCommonData.Player.Role.idTeam)) && (!((GameCommonData.Player.Role.idTeam == 0))))){
                            _local2 = false;
                        };
                        if (PkData.PkStateList[0] == true){
                            if ((((_arg1.Role.MasterPlayer.Role.unityId == GameCommonData.Player.Role.unityId)) && (!((GameCommonData.Player.Role.unityId == 0))))){
                                _local2 = false;
                            };
                        };
                        if (PkData.PkStateList[1] == true){
                            if (_arg1.Role.MasterPlayer.Role.PkTime == 0){
                                _local2 = false;
                            };
                        };
                        if (PkData.PkStateList[2] == true){
                            if (_arg1.Role.MasterPlayer.Role.PkTime > 0){
                                _local2 = false;
                            };
                        };
                        if (GameCommonData.GuildBattle_IsStarting){
                            if (_arg1.Role.MasterPlayer.Role.unityId == GameCommonData.Player.Role.unityId){
                                _local2 = false;
                            } else {
                                if (_arg1.Role.MasterPlayer.Role.unityId == UnityConstData.GuildBattle_TargetGuildID){
                                    if (GameCommonData.Player.Role.Level < 30){
                                        _local2 = false;
                                    };
                                    _local2 = true;
                                };
                            };
                        };
                    };
                    if (_local2){
                        SysCursor.GetInstance().setMouseType(SysCursor.ATTACK_CURSOR);
                    } else {
                        SysCursor.GetInstance().revert();
                    };
                    break;
                case GameRole.TYPE_ENEMY:
                    if (((!((_arg1.Role.ArenaTeamId == -1))) && (!((_arg1.Role.Title == "可抓捕"))))){
                        if (_arg1.Role.ArenaTeamId == 0){
                            SysCursor.GetInstance().setMouseType(SysCursor.ATTACK_CURSOR);
                        } else {
                            if (_arg1.Role.ArenaTeamId != GameCommonData.Player.Role.ArenaTeamId){
                                SysCursor.GetInstance().setMouseType(SysCursor.ATTACK_CURSOR);
                            };
                        };
                    };
                    break;
                case GameRole.TYPE_NPC:
                    SysCursor.GetInstance().setMouseType(SysCursor.STALK_CURSOR);
                    break;
                case GameRole.TYPE_COLLECT:
                    SysCursor.GetInstance().setMouseType(SysCursor.PICK_CURSOR);
                    break;
            };
        }
        public static function onChooseTarger(_arg1:GameElementAnimal):void{
            if (GameCommonData.TargetAnimal != null){
                GameCommonData.TargetAnimal.IsSelect(false);
            };
            GameCommonData.IsMoveTargetAnimal = true;
            GameCommonData.TargetAnimal = _arg1;
            GameCommonData.TargetAnimal.IsSelect(true);
        }
        public static function onMouseOutTarger(_arg1:GameElementAnimal):void{
            CurrentSkinId = -1;
            SysCursor.GetInstance().revert();
        }

    }
}//package Manager 
