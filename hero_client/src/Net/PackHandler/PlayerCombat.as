//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import Net.*;
    import GameUI.Modules.Friend.model.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Friend.view.mediator.*;

    public class PlayerCombat extends GameAction {

        private static var instance:PlayerCombat;

        private const TYPE_EVASION:int = 1;
        private const BIG_TYPE_DEAD:int = 0;
        private const TYPE_HP:int = 0;
        private const BIG_TYPE_LIVE:int = 1;
        private const TYPE_ERUPTIVE_HP:int = 2;

        public function PlayerCombat(){
            super(true);
            if (PlayerCombat.instance != null){
                throw (new Error("单体出错"));
            };
        }
        public static function getInstance():PlayerCombat{
            if (PlayerCombat.instance == null){
                PlayerCombat.instance = new (PlayerCombat)();
            };
            return (PlayerCombat.instance);
        }

        public function CreateHendler(_arg1:uint, _arg2:uint, _arg3:int, _arg4:String):void{
            var _local5:SkillInfo;
            var _local6:Date;
            var _local7:Date;
            var _local8:int;
            var _local9:Array;
            var _local10:GameSkillEffect;
            var _local11:PlayerStateHandler;
            var _local12:PlayerSkillHandler;
            var _local13:PlayerActionHandler;
            var _local14:GameElementAnimal = PlayerController.GetPlayer(_arg1);
            var _local15:GameElementAnimal = PlayerController.GetPlayer(_arg2);
            if (((!((_local14 == null))) && (!((_local15 == null))))){
                _local14.Role.MountSkinID = 0;
                if (_local14.Role.Id == GameCommonData.Player.Role.Id){
                    _local6 = new Date();
                    GameCommonData.AutomatismTime = _local6.time;
                    GameCommonData.Player.Role.UpdateAttackTime();
                };
                if (_local15.Role.Id == GameCommonData.Player.Role.Id){
                    if (_local14.Role.Id != GameCommonData.Player.Role.Id){
                        _local6 = new Date();
                        if (_local14.Role.Type == GameRole.TYPE_PLAYER){
                            UIFacade.GetInstance().sendNotification(ScreenMessageEvent.SHOW_BLOOD);
                        };
                    };
                    GameCommonData.Player.Role.UpdateAttackTime();
                };
                if (((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && ((_local15.Role.Id == GameCommonData.Player.Role.UsingPetAnimal.Role.Id)))){
                    if (((!((_local14.Role.Id == GameCommonData.Player.Role.Id))) && (!((_local14.Role.Id == GameCommonData.Player.Role.UsingPetAnimal.Role.Id))))){
                        _local6 = new Date();
                    };
                    GameCommonData.Player.Role.UpdateAttackTime();
                };
                _local7 = new Date();
                _local8 = _local7.time;
                _local9 = new Array();
                if (_local14.Role.Type == GameRole.TYPE_ENEMY){
                    _local5 = SkillManager.GetAlldefaultSkill();
                } else {
                    _local5 = SkillManager.GetDefaultSkill(_local14);
                };
                if (_local5 == null){
                    _local5 = SkillManager.GetAlldefaultSkill();
                };
                _local10 = new GameSkillEffect();
                _local10.TargerPlayer = _local15;
                _local10.TargerState = _arg4;
                _local10.TargetValue1 = _arg3;
                _local9.push(_local10);
                if (_arg4 == SkillInfo.TARGET_DEAD){
                    _local11 = new PlayerStateHandler(_local14, null, _local9, null, null, _local8, new Point(_local15.GameX, _local15.GameY));
                    if (_local14.handler == null){
                        _local14.handler = _local11;
                        _local14.handler.Run();
                    } else {
                        Handler.FindEndHendler(_local14.handler, _local11);
                    };
                } else {
                    if (_local14.handler){
                        _local14.handler.Clear();
                    };
                    _local12 = new PlayerSkillHandler(_local14, null, _local9, _local5, null, _local8, new Point(_local15.GameX, _local15.GameY));
                    _local13 = new PlayerActionHandler(_local14, _local12, _local9, _local5, null, _local8, new Point(_local15.GameX, _local15.GameY));
                    _local14.handler = _local13;
                    _local14.handler.Run();
                };
                setTimeout(TimeHandler, 2000, _local14, _local8);
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            var _local7:String;
            if (GameCommonData.Player == null){
                return;
            };
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedShort();
            var _local5:uint = _arg1.readUnsignedInt();
            var _local6:uint = _arg1.readUnsignedShort();
            if (_local6 == TYPE_HP){
                CreateHendler(_local2, _local3, _local5, SkillInfo.TARGET_HP);
            } else {
                if (_local6 == TYPE_EVASION){
                    CreateHendler(_local2, _local3, _local5, SkillInfo.TARGET_EVASION);
                } else {
                    if (_local6 == TYPE_ERUPTIVE_HP){
                        CreateHendler(_local2, _local3, _local5, SkillInfo.TARGET_ERUPTIVE_HP);
                    } else {
                        if (_local6 == 4){
                            CreateHendler(_local2, _local3, _local5, SkillInfo.TARGET_SUCK);
                        };
                    };
                };
            };
            if (_local4 == BIG_TYPE_DEAD){
                CreateHendler(_local2, _local3, _local5, SkillInfo.TARGET_DEAD);
            };
            if ((((_local4 == BIG_TYPE_DEAD)) && ((_local3 == GameCommonData.Player.Role.Id)))){
                if (((GameCommonData.SameSecnePlayerList[_local2]) && ((GameCommonData.SameSecnePlayerList[_local2].Role.Type == GameRole.TYPE_PLAYER)))){
                    if (((((((((((!(MapManager.IsMainCity())) && (!(MapManager.IsInArena())))) && (!(MapManager.IsInArenaDieoutBattle)))) && (!(MapManager.IsInGVG())))) && (!(((GameCommonData.GuildBattle_IsStarting) && ((GameCommonData.SameSecnePlayerList[_local2].Role.unityId == UnityConstData.GuildBattle_TargetGuildID))))))) && ((GameCommonData.Player.Role.ConvoyFlag == 0)))){
                        if (FriendConstData.EnemyTempList.indexOf(_local2) == -1){
                            FriendConstData.EnemyTempList.push(_local2);
                            if (!(facade.retrieveMediator(FriendManagerMediator.NAME) as FriendManagerMediator).isEnemy(_local2)){
                                _local7 = (GameCommonData.SameSecnePlayerList[_local2] as GameElementAnimal).Role.Name;
                                facade.sendNotification(FriendCommandList.ADD_ENEMY_FRIEND, {
                                    playerId:_local2,
                                    playerName:_local7
                                });
                            };
                        };
                    };
                };
            };
        }
        public function TimeHandler(_arg1:GameElementAnimal, _arg2:int):void{
            if (((!((_arg1.handler == null))) && ((_arg1.handler.TimeID == _arg2)))){
                _arg1.handler.Clear();
            };
        }

    }
}//package Net.PackHandler 
