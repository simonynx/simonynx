//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PetRace.Data {
    import flash.events.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class PetRacingBattle {

        public static var PetRacingBattleList:Array = [];
        public static var StartBattleTime:uint = 0;
        private static var selfInfo:PetRacingInfo;
        public static var rewardItemId:uint = 0;
        private static var playing:Boolean;
        public static var WinScore:uint = 0;
        private static var racingStep:int = 0;
        public static var DefenseActions:Array = [[], [], []];
        public static var Rounds:Array = [0, 0, 0];
        public static var DefenseParams:Array = [[], [], []];
        public static var TotalRound:uint = 0;
        private static var timer:Timer = null;
        public static var WinnerId:uint = 0;
        private static var targetInfo:PetRacingInfo;
        private static var endFlag:Boolean = true;
        private static var startFlag:Boolean = true;
        private static var counting:uint = 0;
        public static var AttackActions:Array = [[], [], []];
        public static var Winners:Array = [0, 0, 0];

        private static function getColorText(_arg1:String, _arg2:String):String{
            return ((((("<font color='" + _arg2) + "'>") + _arg1) + "</font>"));
        }
        private static function getDefName(_arg1:uint):String{
            var _local2:PetRacingInfo = PetRaceConstData.getDefInfo();
            var _local3:String = getColorText(((("[" + _local2.MasterName.substr(0, 1)) + "]") + _local2.petName[_arg1]), "#fb7204");
            return (_local3);
        }
        public static function startPetRacing():void{
            if (timer){
                timer.removeEventListener(TimerEvent.TIMER, __timer);
                timer = null;
            };
            if (timer == null){
                PetRaceConstData.delayTime = 2000;
                timer = new Timer(2000, 0);
                timer.addEventListener(TimerEvent.TIMER, __timer);
                timer.start();
                PetRacingBattle.PetRacingBattleList = [];
                counting = 0;
                racingStep = 0;
                startFlag = true;
                endFlag = false;
                selfInfo = PetRaceConstData.selfRacingInfo;
                targetInfo = PetRaceConstData.targetRacingInfo;
                playing = true;
            };
        }
        public static function GetActionIndexs(_arg1:int):Array{
            var _local2:int;
            var _local3:int;
            if (_arg1 < Rounds[0]){
                _local2 = 0;
                _local3 = _arg1;
            } else {
                if (_arg1 < (Rounds[0] + Rounds[1])){
                    _local2 = 1;
                    _local3 = (_arg1 - Rounds[0]);
                } else {
                    _local2 = 2;
                    _local3 = ((_arg1 - Rounds[0]) - Rounds[1]);
                };
            };
            return ([_local2, _local3]);
        }
        private static function getAttName(_arg1:uint):String{
            var _local2:PetRacingInfo = PetRaceConstData.getAttInfo();
            var _local3:String = getColorText(((("[" + _local2.MasterName.substr(0, 1)) + "]") + _local2.petName[_arg1]), "#5ae13b");
            return (_local3);
        }
        public static function IsReport():Boolean{
            if (((timer) && ((playing == false)))){
                return (true);
            };
            return (false);
        }
        public static function ReadFromPacket(_arg1:NetPacket):void{
            rewardItemId = _arg1.readUnsignedInt();
            WinnerId = _arg1.readUnsignedInt();
            StartBattleTime = _arg1.readUnsignedInt();
            TotalRound = _arg1.readUnsignedInt();
            WinScore = _arg1.readUnsignedInt();
            var _local2:uint;
            var _local3:uint;
            _local2 = 0;
            while (_local2 < 3) {
                Winners[_local2] = _arg1.readUnsignedInt();
                Rounds[_local2] = _arg1.readUnsignedInt();
                _local3 = 0;
                while (_local3 < Rounds[_local2]) {
                    AttackActions[_local2][_local3] = _arg1.readShort();
                    DefenseActions[_local2][_local3] = _arg1.readShort();
                    DefenseParams[_local2][(_local3 * 2)] = _arg1.readShort();
                    DefenseParams[_local2][((_local3 * 2) + 1)] = _arg1.readShort();
                    _local3++;
                };
                if (Rounds[_local2] == 0){
                    Rounds[_local2] = 1;
                    AttackActions[_local2][_local3] = 0;
                    DefenseActions[_local2][_local3] = 0;
                    DefenseParams[_local2][(_local3 * 2)] = 0;
                    DefenseParams[_local2][((_local3 * 2) + 1)] = 0;
                };
                _local2++;
            };
            TotalRound = ((Rounds[0] + Rounds[1]) + Rounds[2]);
        }
        private static function getTargetName(_arg1:uint):String{
            var _local2:String = getColorText(((("[" + targetInfo.MasterName.substr(0, 1)) + "]") + targetInfo.petName[_arg1]), getColorByInfo(targetInfo));
            return (_local2);
        }
        public static function IsRacing():Boolean{
            if (((timer) && (playing))){
                return (true);
            };
            return (false);
        }
        private static function setWinnerString(_arg1:uint, _arg2:String, _arg3:int=-1):void{
            var _local4 = "";
            var _local5:uint;
            var _local6 = "";
            if (_arg1 == selfInfo.playerId){
                if (_arg3 == -1){
                    _local4 = (((((((("<BR>" + LanguageMgr.GetTranslation("恭喜")) + getColorText(selfInfo.MasterName, getColorByInfo(selfInfo))) + LanguageMgr.GetTranslation("率领的")) + getColorText(selfInfo.TeamName, getColorByInfo(selfInfo))) + LanguageMgr.GetTranslation("取得")) + _arg2) + LanguageMgr.GetTranslation("胜利")) + "!<BR><BR>");
                } else {
                    _local4 = (((((LanguageMgr.GetTranslation("恭喜") + getSelfName(_arg3)) + LanguageMgr.GetTranslation("获得")) + _arg2) + LanguageMgr.GetTranslation("胜利")) + "!");
                };
                if (_arg3 != -1){
                    _local5 = (1 + (Math.random() * (PetRaceConstData.raceLoseList.length - 1)));
                    if (targetInfo.entryid[_arg3] == 0){
                        _local5 = 0;
                    };
                    _local6 = PetRaceConstData.raceLoseList[_local5];
                    _local6 = _local6.replace("*", getTargetName(_arg3));
                    UIFacade.GetInstance().sendNotification(PetRaceEvent.UPDATE_TARGET_PET_BLOOD, {
                        blood:0,
                        team:_arg3
                    });
                };
            } else {
                if (_arg3 == -1){
                    _local4 = (((((((("<BR>" + LanguageMgr.GetTranslation("恭喜")) + getColorText(targetInfo.MasterName, getColorByInfo(targetInfo))) + LanguageMgr.GetTranslation("率领的")) + getColorText(targetInfo.TeamName, getColorByInfo(targetInfo))) + LanguageMgr.GetTranslation("取得")) + _arg2) + LanguageMgr.GetTranslation("胜利")) + "!<BR><BR>");
                } else {
                    _local4 = (((((LanguageMgr.GetTranslation("恭喜") + getTargetName(_arg3)) + LanguageMgr.GetTranslation("获得")) + _arg2) + LanguageMgr.GetTranslation("胜利")) + "!");
                };
                if (_arg3 != -1){
                    _local5 = (1 + (Math.random() * (PetRaceConstData.raceLoseList.length - 1)));
                    if (selfInfo.entryid[_arg3] == 0){
                        _local5 = 0;
                    };
                    _local6 = PetRaceConstData.raceLoseList[_local5];
                    _local6 = _local6.replace("*", getSelfName(_arg3));
                    UIFacade.GetInstance().sendNotification(PetRaceEvent.UPDATE_SELF_PET_BLOOD, {
                        blood:0,
                        team:_arg3
                    });
                };
            };
            if (_arg3 != -1){
                UIFacade.GetInstance().sendNotification(PetRaceEvent.ADD_RACING_RECORD, _local6);
                if (((timer) && ((timer.delay == 2000)))){
                    UIFacade.GetInstance().sendNotification(PetRaceEvent.RESULT_THISROUND, _arg3);
                };
            };
            UIFacade.GetInstance().sendNotification(PetRaceEvent.ADD_RACING_RECORD, _local4);
        }
        private static function getColorByInfo(_arg1:PetRacingInfo):String{
            var _local2 = "";
            if (_arg1.MasterName == PetRaceConstData.attackPlayerName){
                return ("#5ae13b");
            };
            return ("#fb7204");
        }
        private static function getWinnerName():String{
            var _local1 = "";
            if (WinnerId == selfInfo.playerId){
                _local1 = getColorText((("[" + selfInfo.MasterName) + "]"), getColorByInfo(selfInfo));
            } else {
                _local1 = getColorText((("[" + targetInfo.MasterName) + "]"), getColorByInfo(targetInfo));
            };
            return (_local1);
        }
        public static function __timer(_arg1:TimerEvent):void{
            var _local6:uint;
            var _local7:String;
            var _local8:String;
            var _local9:String;
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local13:String;
            var _local14:uint;
            var _local15:uint;
            var _local16:uint;
            var _local2 = "";
            var _local3:Array = PetRacingBattle.GetActionIndexs(counting);
            var _local4:uint = _local3[0];
            var _local5:uint = _local3[1];
            if (racingStep == 0){
                _local2 = getColorText(LanguageMgr.GetTranslation("宠物争霸大赛请交战双方入场句"), "#FFFFFF");
                UIFacade.GetInstance().sendNotification(PetRaceEvent.ADD_RACING_RECORD, _local2);
                _local6 = 0;
                while (_local6 < 3) {
                    updateSelfPetBlood(_local6, 0);
                    updateTargetPetBlood(_local6, 0);
                    _local6++;
                };
                startFlag = true;
                endFlag = false;
                racingStep = 1;
                return;
            };
            if (startFlag == true){
                if ((((_local4 <= 2)) && ((racingStep == 1)))){
                    if (_local4 == 0){
                        _local2 = (("<BR>" + getColorText((("[" + LanguageMgr.GetTranslation("甲组比赛")) + "]"), "#00deff")) + "<BR>");
                    } else {
                        if (_local4 == 1){
                            _local2 = (("<BR>" + getColorText((("[" + LanguageMgr.GetTranslation("乙组比赛")) + "]"), "#00deff")) + "<BR>");
                        } else {
                            _local2 = (("<BR>" + getColorText((("[" + LanguageMgr.GetTranslation("丙组比赛")) + "]"), "#00deff")) + "<BR>");
                        };
                    };
                    UIFacade.GetInstance().sendNotification(PetRaceEvent.ADD_RACING_RECORD, _local2);
                    startFlag = false;
                    endFlag = false;
                    UIFacade.GetInstance().sendNotification(PetRaceEvent.FIGHT_SIMULATE, {
                        attack:-1,
                        index:_local4
                    });
                    return;
                };
            };
            if (endFlag == true){
                if ((((_local4 <= 2)) && ((racingStep == 1)))){
                    if (_local4 == 0){
                        setWinnerString(PetRacingBattle.Winners[0], LanguageMgr.GetTranslation("甲组"), 0);
                    } else {
                        if (_local4 == 1){
                            setWinnerString(PetRacingBattle.Winners[1], LanguageMgr.GetTranslation("乙组"), 1);
                        } else {
                            setWinnerString(PetRacingBattle.Winners[2], LanguageMgr.GetTranslation("丙组"), 2);
                            racingStep = 2;
                        };
                    };
                    startFlag = true;
                    endFlag = false;
                    counting++;
                    return;
                };
            };
            if (((PetRacingBattle.AttackActions[_local4][_local5]) && ((racingStep == 1)))){
                _local7 = String(PetRacingBattle.AttackActions[_local4][_local5]);
                _local8 = (GameCommonData.PetRaceActionList[_local7] as PetRaceActionInfo).act_discription;
                _local7 = String(PetRacingBattle.DefenseActions[_local4][_local5]);
                _local9 = (GameCommonData.PetRaceActionList[_local7] as PetRaceActionInfo).act_discription;
                if ((_local5 % 2) == 0){
                    _local8 = _local8.replace("#", getAttName(_local4));
                    _local8 = _local8.replace("*", getDefName(_local4));
                    _local9 = _local9.replace("#", getAttName(_local4));
                    _local9 = _local9.replace("*", getDefName(_local4));
                    _local9 = (_local9.replace("*", getDefName(_local4)) + "<BR>");
                } else {
                    _local8 = _local8.replace("#", getDefName(_local4));
                    _local8 = _local8.replace("*", getAttName(_local4));
                    _local9 = _local9.replace("#", getDefName(_local4));
                    _local9 = _local9.replace("*", getAttName(_local4));
                    _local9 = (_local9.replace("*", getAttName(_local4)) + "<BR>");
                };
                _local10 = PetRacingBattle.DefenseParams[_local4][(_local5 * 2)];
                _local11 = PetRacingBattle.DefenseParams[_local4][((_local5 * 2) + 1)];
                _local12 = 0;
                if (_local10 != -1){
                    _local9 = _local9.replace("?", _local10);
                    _local12 = (_local12 + _local10);
                };
                if (_local11 != -1){
                    _local9 = _local9.replace("?", _local11);
                    _local12 = (_local12 + _local11);
                };
                UIFacade.GetInstance().sendNotification(PetRaceEvent.ADD_RACING_RECORD, _local8);
                UIFacade.GetInstance().sendNotification(PetRaceEvent.ADD_RACING_RECORD, _local9);
                _local13 = String(PetRacingBattle.DefenseActions[_local4][_local5]).substr(1, 1);
                _local14 = 1;
                if (((((((((_local5 % 2) == 0)) && ((((selfInfo.MasterName == PetRaceConstData.defensePlayerName)) && (!((_local13 == "3"))))))) || ((((selfInfo.MasterName == PetRaceConstData.attackPlayerName)) && ((_local13 == "3")))))) || (((((((_local5 % 2) == 1)) && ((((selfInfo.MasterName == PetRaceConstData.attackPlayerName)) && (!((_local13 == "3"))))))) || ((((selfInfo.MasterName == PetRaceConstData.defensePlayerName)) && ((_local13 == "3")))))))){
                    _local14 = 0;
                };
                _local15 = 1;
                if (((((((_local5 % 2) == 0)) && ((selfInfo.MasterName == PetRaceConstData.attackPlayerName)))) || (((((_local5 % 2) == 1)) && ((selfInfo.MasterName == PetRaceConstData.defensePlayerName)))))){
                    _local15 = 0;
                };
                UIFacade.GetInstance().sendNotification(PetRaceEvent.FIGHT_SIMULATE, {
                    attack:_local15,
                    index:_local4
                });
                if (_local14 == 0){
                    updateSelfPetBlood(_local4, _local12);
                } else {
                    updateTargetPetBlood(_local4, _local12);
                };
                if ((((uint(_local13) >= 1)) && ((uint(_local13) <= 5)))){
                    _local16 = 0;
                    if (((((((_local5 % 2) == 0)) && ((selfInfo.MasterName == PetRaceConstData.defensePlayerName)))) || (((((_local5 % 2) == 1)) && ((selfInfo.MasterName == PetRaceConstData.attackPlayerName)))))){
                        _local16 = 1;
                    };
                    UIFacade.GetInstance().sendNotification(PetRaceEvent.PETRACE_EFFECT, {
                        type:_local13,
                        team:_local4,
                        side:_local16
                    });
                };
            };
            if (_local5 == (PetRacingBattle.Rounds[_local4] - 1)){
                if (racingStep == 1){
                    endFlag = true;
                    return;
                };
            };
            if ((((counting > PetRacingBattle.TotalRound)) && ((racingStep == 2)))){
                setWinnerString(PetRacingBattle.WinnerId, LanguageMgr.GetTranslation("本次斗宠比赛的"));
                if (playing){
                    if (PetRacingBattle.WinnerId == selfInfo.playerId){
                        MessageTip.popup(LanguageMgr.GetTranslation("恭喜你斗宠胜"));
                    } else {
                        MessageTip.popup(LanguageMgr.GetTranslation("你在本次斗宠赛落败"));
                    };
                };
                UIFacade.GetInstance().sendNotification(PetRaceEvent.FIGHT_SIMULATE, {
                    attack:2,
                    index:_local4
                });
                racingStep = 3;
                return;
            };
            if (racingStep == 3){
                if (playing){
                    UIFacade.GetInstance().sendNotification(PetRaceEvent.UPDATE_TEAM_INFO);
                    if (PetRaceConstData.raceStatus == 0){
                        _local2 = LanguageMgr.GetTranslation("x获得y积分z被扣20点积分", getWinnerName(), WinScore, getLoserName());
                        UIFacade.GetInstance().sendNotification(PetRaceEvent.ADD_RACING_RECORD, _local2);
                    };
                    if (UIConstData.ItemDic[rewardItemId]){
                        _local2 = (((getColorText(PetRaceConstData.attackPlayerName, "#5ae13b") + LanguageMgr.GetTranslation("在战斗过程中意外发现")) + getColorText((UIConstData.ItemDic[rewardItemId] as ItemTemplateInfo).Name, IntroConst.EquipColorStr[(UIConstData.ItemDic[rewardItemId] as ItemTemplateInfo).Color])) + "!");
                        UIFacade.GetInstance().sendNotification(PetRaceEvent.ADD_RACING_RECORD, _local2);
                    };
                    if (playing){
                        playing = false;
                    };
                };
                if (timer){
                    timer.removeEventListener(TimerEvent.TIMER, __timer);
                    timer = null;
                    if (playing){
                        playing = false;
                    };
                };
            };
            counting++;
        }
        private static function getSelfName(_arg1:uint):String{
            var _local2:String = getColorText(((("[" + selfInfo.MasterName.substr(0, 1)) + "]") + selfInfo.petName[_arg1]), getColorByInfo(selfInfo));
            return (_local2);
        }
        public static function GetRoundByCount(_arg1:uint):int{
            if (_arg1 >= TotalRound){
                return (-1);
            };
            if (_arg1 < Rounds[0]){
                return (0);
            };
            if (_arg1 < (Rounds[0] + Rounds[1])){
                return (1);
            };
            return (2);
        }
        private static function updateSelfPetBlood(_arg1:int, _arg2:int):void{
            selfInfo.blood[_arg1] = (selfInfo.blood[_arg1] - _arg2);
            if (selfInfo.blood[_arg1] < 0){
                selfInfo.blood[_arg1] = 0;
            };
            UIFacade.GetInstance().sendNotification(PetRaceEvent.UPDATE_SELF_PET_BLOOD, {
                blood:selfInfo.blood[_arg1],
                team:_arg1
            });
        }
        public static function startPetReport(_arg1:PetRacingInfo, _arg2:PetRacingInfo):void{
            var _local3:uint;
            var _local4:uint;
            if (timer){
                timer.removeEventListener(TimerEvent.TIMER, __timer);
                timer = null;
            };
            if (timer == null){
                WinnerId = _arg1.WinnerId;
                StartBattleTime = 0;
                TotalRound = 0;
                _local3 = 0;
                _local4 = 0;
                _local3 = 0;
                while (_local3 < 3) {
                    Winners[_local3] = _arg1.Winners[_local3];
                    Rounds[_local3] = 0;
                    if (Rounds[_local3] == 0){
                        Rounds[_local3] = 1;
                        AttackActions[_local3][_local4] = 0;
                        DefenseActions[_local3][_local4] = 0;
                        DefenseParams[_local3][(_local4 * 2)] = 0;
                        DefenseParams[_local3][((_local4 * 2) + 1)] = 0;
                    };
                    _local3++;
                };
                TotalRound = ((Rounds[0] + Rounds[1]) + Rounds[2]);
                PetRaceConstData.delayTime = 10;
                timer = new Timer(10, 0);
                timer.addEventListener(TimerEvent.TIMER, __timer);
                timer.start();
                PetRacingBattle.PetRacingBattleList = [];
                counting = 0;
                racingStep = 0;
                startFlag = true;
                endFlag = false;
                selfInfo = _arg1;
                targetInfo = _arg2;
            };
        }
        private static function getLoserName():String{
            var _local1 = "";
            if (WinnerId == selfInfo.playerId){
                _local1 = getColorText((("[" + targetInfo.MasterName) + "]"), getColorByInfo(targetInfo));
            } else {
                _local1 = getColorText((("[" + selfInfo.MasterName) + "]"), getColorByInfo(selfInfo));
            };
            return (_local1);
        }
        private static function updateTargetPetBlood(_arg1:int, _arg2:int):void{
            targetInfo.blood[_arg1] = (targetInfo.blood[_arg1] - _arg2);
            if (targetInfo.blood[_arg1] < 0){
                targetInfo.blood[_arg1] = 0;
            };
            UIFacade.GetInstance().sendNotification(PetRaceEvent.UPDATE_TARGET_PET_BLOOD, {
                blood:targetInfo.blood[_arg1],
                team:_arg1
            });
        }

    }
}//package GameUI.Modules.PetRace.Data 
