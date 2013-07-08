//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import OopsEngine.Graphics.Tagger.*;

    public class PlayerSkillBuff extends GameAction {

        private static var _instance:PlayerSkillBuff;

        public function PlayerSkillBuff(){
            super(false);
            if (_instance != null){
                throw (new Error("单体类"));
            };
        }
        public static function getInstance():PlayerSkillBuff{
            if (_instance == null){
                _instance = new (PlayerSkillBuff)();
            };
            return (_instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            var _local2:GameElementAnimal;
            var _local3:GameElementAnimal;
            var _local4:int;
            var _local5:GameSkillBuff;
            var _local6:GameSkillBuff;
            var _local7:int = _arg1.readUnsignedInt();
            var _local8:int = _arg1.readUnsignedInt();
            var _local9:int = _arg1.readByte();
            var _local10:Boolean = _arg1.readBoolean();
            var _local11:* = _arg1.readUnsignedInt();
            var _local12:Boolean = _arg1.readBoolean();
            var _local13:int = _arg1.readShort();
            var _local14:int = _arg1.readInt();
            var _local15:int = _arg1.readInt();
            var _local16:int = _arg1.readUnsignedInt();
            var _local17:int = (_arg1.readInt() / 1000);
            var _local18:Boolean = _arg1.readBoolean();
            if (GameCommonData.Player != null){
                _local3 = PlayerController.GetPlayer(_local8);
                _local4 = 0;
                if (_local3 != null){
                    if (_local3.Role.Id != GameCommonData.Player.Role.Id){
                        _local4 = _local3.Role.Id;
                    };
                    _local5 = (GameCommonData.BuffList[_local11] as GameSkillBuff);
                    if (_local5 != null){
                        _local6 = new GameSkillBuff();
                        _local6.BuffID = _local11;
                        _local6.BuffTime = _local17;
                        _local6.BuffType = _local5.BuffType;
                        _local6.BuffName = _local5.BuffName;
                        _local6.TypeID = _local5.TypeID;
                        _local6.BuffEffect = _local5.BuffEffect;
                        switch (_local13){
                            case 16:
                                if ((((_local14 > 0)) && ((Math.abs(_local14) < 1000000)))){
                                    _local3.showAttackFace(AttackFace.CHANGE_HP_RECOVER, _local14);
                                };
                                if ((((_local15 > 0)) && ((Math.abs(_local15) < 1000000)))){
                                    _local3.showAttackFace(AttackFace.CHANGE_MP, _local15);
                                };
                                if (_local17 > 0){
                                    if (_local12){
                                        _local3.Role.UpdateBuff(_local6);
                                        UIFacade.GetInstance().changeBuffStatus(1, _local4, _local6);
                                    } else {
                                        if (_local3.Role.IsBuff(_local11)){
                                            _local3.Role.UpdateBuffTime(_local11, _local17);
                                            UIFacade.GetInstance().changeBuffStatus(7, _local4, _local6);
                                        } else {
                                            _local3.Role.UpdateBuff(_local6);
                                            UIFacade.GetInstance().changeBuffStatus(1, _local4, _local6);
                                        };
                                    };
                                } else {
                                    if (_local17 == 0){
                                        if (_local3.Role.PlusBuff.length > 0){
                                            if (_local3.Role.DelteBuff(_local6)){
                                                UIFacade.GetInstance().changeBuffStatus(3, _local4, _local6);
                                            };
                                        };
                                    } else {
                                        if (_local17 == -1){
                                            _local3.Role.UpdateBuff(_local6);
                                            UIFacade.GetInstance().changeBuffStatus(2, _local4, _local6);
                                        };
                                    };
                                };
                                break;
                            case 8:
                                if ((((_local14 > 0)) && ((Math.abs(_local14) < 1000000)))){
                                    _local3.showAttackFace(AttackFace.CHANGE_HP, -(_local14));
                                };
                                if ((((_local15 > 0)) && ((Math.abs(_local15) < 1000000)))){
                                    _local3.showAttackFace(AttackFace.CHANGE_MP, -(_local15));
                                };
                                if (_local17 > 0){
                                    if (_local12){
                                        if (_local6.TypeID == 306){
                                            UIFacade.GetInstance().sendNotification(EventList.ATTACK_START);
                                        };
                                        _local3.Role.UpdateDot(_local6);
                                        UIFacade.GetInstance().changeBuffStatus(4, _local4, _local6);
                                    } else {
                                        if (_local3.Role.IsDot(_local11)){
                                            _local3.Role.UpdateBuffTime(_local11, _local17);
                                        };
                                        UIFacade.GetInstance().changeBuffStatus(7, _local4, _local6);
                                    };
                                } else {
                                    if (_local17 == 0){
                                        if (_local3.Role.DotBuff.length > 0){
                                            if (_local3.Role.DelteDot(_local6)){
                                                UIFacade.GetInstance().changeBuffStatus(6, _local4, _local6);
                                            };
                                        };
                                        if (_local6.TypeID == 306){
                                            UIFacade.GetInstance().sendNotification(EventList.ATTACK_STOP);
                                        };
                                    } else {
                                        if (_local17 == -1){
                                            _local3.Role.UpdateDot(_local6);
                                            UIFacade.GetInstance().changeBuffStatus(5, _local4, _local6);
                                        };
                                    };
                                };
                                if (_local18){
                                    setDieAction(_local7, _local8, _local14, _local15);
                                };
                                break;
                        };
                    };
                };
            };
        }
        private function setDieAction(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void{
            var _local5:GameElementAnimal;
            var _local6:GameElementAnimal;
            var _local10:PlayerStateHandler;
            var _local7:GameSkillEffect = new GameSkillEffect();
            var _local8:Array = [];
            var _local9:Date = new Date();
            trace("dot死亡");
            _local5 = PlayerController.GetPlayer(_arg1);
            _local6 = PlayerController.GetPlayer(_arg2);
            if (_local5){
                _local7.TargerState = SkillInfo.TARGET_DEAD;
                _local7.TargerPlayer = _local6;
                _local7.TargetValue1 = _arg3;
                _local7.TargetValue2 = _arg4;
                _local8.push(_local7);
                _local10 = new PlayerStateHandler(_local5, null, _local8, null, null, _local9.time);
                if (_local5.handler == null){
                    _local5.handler = _local10;
                    _local5.handler.Run();
                } else {
                    Handler.FindEndHendler(_local5.handler, _local10);
                };
            } else {
                UIFacade.UIFacadeInstance.upDateInfo(6);
                _local6.SetAction(GameElementSkins.ACTION_DEAD);
            };
        }

    }
}//package Net.PackHandler 
