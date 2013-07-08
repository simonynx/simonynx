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
    import GameUI.ConstData.*;
    import Net.*;
    import OopsEngine.AI.PathFinder.*;
    import GameUI.Modules.ScreenMessage.Date.*;

    public class PlayerUseSkill extends GameAction {

        public static const SPELL_DID_HIT_SUCCESS:int = 0;
        public static const SPELL_DID_HIT_IMMUNE:int = 2;
        public static const SPELL_EFFRET_NORHIT:int = 0;
        public static const SPELL_EFFRET_CRITIHIT:int = 1;
        public static const SPELL_EFFRET_REFLECT:int = 4;
        public static const SPELL_DID_HIT_DODGE:int = 1;
        public static const SPELL_EFFRET_RESIST:int = 2;
        public static const SPELL_EFFRET_ABSORB:int = 3;
        public static const SPELL_EFFRET_REBOUND:int = 5;

        private static var instance:PlayerUseSkill;

        private var timer:Timer;

        public function PlayerUseSkill(){
            super(true);
            timer = new Timer(500);
            if (instance != null){
                throw (new Error("单体"));
            };
        }
        public static function getInstance():PlayerUseSkill{
            if (instance == null){
                instance = new (PlayerUseSkill)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            var _local2:SkillInfo;
            var _local3:int;
            var _local4:GameSkillEffect;
            var _local5:Array;
            var _local6:uint;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local13:Boolean;
            var _local14:GameElementAnimal;
            var _local15:Date;
            var _local16:PlayerSkillHandler;
            var _local17:PlayerActionHandler;
            var _local18:PlayerStateHandler;
            var _local19:Date;
            var _local20:int;
            var _local21:Point;
            var _local22:Point;
            var _local30:GameSkillEffect;
            var _local31:Point;
            var _local23:uint = _arg1.readUnsignedInt();
            var _local24:int = _arg1.readFloat();
            var _local25:int = _arg1.readFloat();
            var _local26:int = _arg1.readUnsignedInt();
            var _local27:int = _arg1.readUnsignedInt();
            _local2 = (GameCommonData.SkillList[_local26] as SkillInfo);
            if (_local2 == null){
                throw (new Error(("找不到该技能" + _local26)));
            };
            var _local28:GameElementAnimal = PlayerController.GetPlayer(_local23);
            var _local29:Array = new Array();
            if (_local28 != null){
                _local28.Role.MountSkinID = 0;
                if ((((((((_local28.Role.Id == GameCommonData.Player.Role.Id)) && (!((_local2 == null))))) && (!(GameSkillMode.isBuffSkill(_local2))))) && (!(GameSkillMode.IsDoctorSkill(_local2, _local28, _local28))))){
                    _local19 = new Date();
                    GameCommonData.AutomatismTime = _local19.time;
                    GameCommonData.Player.Role.UpdateAttackTime();
                    GameCommonData.Player.Stop();
                    SkillManager.UseSkillLock = false;
                };
                if ((((_local28.Role.Id == GameCommonData.Player.Role.Id)) && ((_local2.TypeID == 2301)))){
                    GameCommonData.Player.Stop();
                };
                _local3 = 0;
                _local5 = new Array();
                while (_local3 < _local27) {
                    _local4 = new GameSkillEffect();
                    _local6 = _arg1.readUnsignedInt();
                    _local9 = _arg1.readFloat();
                    _local10 = _arg1.readFloat();
                    _local11 = _arg1.readByte();
                    _local12 = _arg1.readByte();
                    _local13 = _arg1.readBoolean();
                    _local7 = _arg1.readUnsignedInt();
                    _local8 = _arg1.readUnsignedInt();
                    _local14 = PlayerController.GetPlayer(_local6);
                    if (((!((_local14 == null))) && ((_local14.Role.Id == GameCommonData.Player.Role.Id)))){
                        if (_local28.Role.Id != GameCommonData.Player.Role.Id){
                            _local15 = new Date();
                        };
                        if (((!(GameSkillMode.isBuffSkill(_local2))) && (!(GameSkillMode.IsDoctorSkill(_local2, _local28, _local14))))){
                            GameCommonData.Player.Role.UpdateAttackTime();
                            if (_local28.Role.Type == GameRole.TYPE_PLAYER){
                                UIFacade.GetInstance().sendNotification(ScreenMessageEvent.SHOW_BLOOD);
                            };
                        };
                    };
                    if (_local14 != null){
                        if (_local11 == SPELL_DID_HIT_SUCCESS){
                            switch (_local12){
                                case SPELL_EFFRET_NORHIT:
                                    _local4.TargerState = SkillInfo.TARGET_HP;
                                    break;
                                case SPELL_EFFRET_CRITIHIT:
                                    _local4.TargerState = SkillInfo.TARGET_ERUPTIVE_HP;
                                    break;
                                case SPELL_EFFRET_RESIST:
                                    _local4.TargerState = SkillInfo.TARGET_RESIST;
                                    break;
                                case SPELL_EFFRET_REBOUND:
                                    _local4.TargerState = SkillInfo.TARGET_REBOUND;
                                    break;
                            };
                        } else {
                            if (_local11 == SPELL_DID_HIT_DODGE){
                                _local4.TargerState = SkillInfo.TARGET_EVASION;
                            } else {
                                if (_local11 == SPELL_DID_HIT_IMMUNE){
                                    _local4.TargerState = SkillInfo.TARGET_RESIST;
                                };
                            };
                        };
                        _local4.TargerPlayer = PlayerController.GetPlayer(_local6);
                        _local4.TargetValue1 = _local7;
                        _local4.TargetValue2 = _local8;
                        _local29.push(_local4);
                        if (_local13){
                            _local30 = new GameSkillEffect();
                            _local30.TargerState = SkillInfo.TARGET_DEAD;
                            _local30.TargerPlayer = PlayerController.GetPlayer(_local6);
                            _local5.push(_local30);
                        };
                    };
                    _local3++;
                };
            };
            if (((!((_local28 == null))) && (!((_local2 == null))))){
                _local19 = new Date();
                _local20 = _local19.time;
                if (GameSkillMode.IsShowRect(_local2.SkillType)){
                    _local31 = MapTileModel.GetTilePointToStage(_local24, _local25);
                    _local21 = new Point(_local31.x, _local31.y);
                } else {
                    if (_local29.length > 0){
                        _local21 = new Point(_local29[0].TargerPlayer.GameX, _local29[0].TargerPlayer.GameY);
                    } else {
                        _local21 = new Point(_local28.GameX, _local28.GameY);
                    };
                };
                if (GameSkillMode.IsRushSkill(_local2)){
                    _local16 = new PlayerSkillHandler(_local28, null, _local29, _local2, null, _local20, _local21);
                    if (_local28.handler == null){
                        _local28.handler = _local16;
                        _local28.handler.Run();
                    } else {
                        Handler.FindEndHendler(_local28.handler, _local17);
                    };
                } else {
                    _local16 = new PlayerSkillHandler(_local28, null, _local29, _local2, null, _local20, _local21);
                    _local17 = new PlayerActionHandler(_local28, _local16, _local29, _local2, null, _local20, _local21);
                    if (_local28.handler == null){
                        _local28.handler = _local17;
                        _local28.handler.Run();
                    } else {
                        Handler.FindEndHendler(_local28.handler, _local17);
                    };
                };
                if (_local5.length > 0){
                    _local18 = new PlayerStateHandler(_local28, null, _local5, _local2, null, _local20, _local21);
                    if (_local28.handler == null){
                        _local28.handler = _local18;
                        _local28.handler.Run();
                    } else {
                        Handler.FindEndHendler(_local28.handler, _local18);
                    };
                };
                setTimeout(TimeHandler, 2000, _local28, _local20);
            };
        }
        public function TimeHandler(_arg1:GameElementAnimal, _arg2:int):void{
            if (((((_arg1) && (!((_arg1.handler == null))))) && ((_arg1.handler.TimeID == _arg2)))){
                _arg1.handler.Clear();
            };
        }

    }
}//package Net.PackHandler 
