//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Constellation.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Constellation.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.HButton.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Constellation.Vo.*;

    public class StarMediator extends Mediator {

        public static const TYPE:int = 2;
        public static const NAME:String = "StarMediator";

        private var speed:StarSpeed;
        private var startload:Boolean = false;
        private var speedisOpen:Boolean = false;
        private var openStatus:int = 0;
        private var starInfo:Object;
        private var dataProxy:DataProxy;
        private var stateObj:Object;
        private var clickStartTime:int;
        private var faceItemArray:Array;
        private var updateInterval:int;
        private var parentView:Sprite;
        private var _studyingNode:int = 0;
        private var leftTime:int;

        public function StarMediator(_arg1:Sprite){
            faceItemArray = [];
            super(NAME);
            parentView = _arg1;
        }
        private function checkStarTip(_arg1:int=0):void{
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:Number;
            var _local10:uint;
            var _local11:uint;
            initXML();
            var _local2:int = GameCommonData.Player.Role.Level;
            if (_arg1 != 0){
                _local2 = _arg1;
            };
            star.reFreshByLevel(_local2);
            star.updateStatus(stateObj);
            if (studyingNode != 0){
                return;
            };
            var _local3:int;
            while (_local3 < star.levelArray.length) {
                if (_local2 < star.levelArray[_local3]){
                    break;
                };
                _local3++;
            };
            var _local4:int;
            while (_local4 < _local3) {
                if (star.aStarArray[_local4].currentFrame == 2){
                    if (_local2 > 30){
                        openStatus = 1;
                        sendNotification(HelpTipsNotiName.HELPTIPS_STARCANLEVELUP_SHOW);
                        return;
                    };
                    if (_local2 > 20){
                        _local5 = star.getAstarID(star.aStarArray[_local4]);
                        if (_local5 != 0){
                            _local6 = (_local5 / 100);
                            _local7 = (_local5 % 100);
                            _local8 = (starInfo[("star_" + _local6)] as StarInfo).costGold[_local7];
                            _local9 = GameCommonData.Player.Role.Gold;
                            _local10 = BagData.getCountsByTemplateId(50700004, false);
                            _local11 = (starInfo[("star_" + _local6)] as StarInfo).costClip[_local7];
                            if ((((_local9 >= _local8)) && ((_local10 >= _local11)))){
                                openStatus = 1;
                                sendNotification(HelpTipsNotiName.HELPTIPS_STARCANLEVELUP_SHOW);
                                return;
                            };
                        };
                    };
                };
                _local4++;
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, RoleEvents.SHOWPROPELEMENT, EventList.CLOSE_STAR, EventList.UPDATE_STAR_STATE, EventList.UPDATE_START_STATE, EventList.UPDATE_FINISH_STATE, EventList.REFRESH_STAR, EventList.SET_STAR_OPEN_STATUS, EventList.UPDATEMONEY, EventList.UPDATEBAG]);
        }
        private function set studyingNode(_arg1:int):void{
            _studyingNode = _arg1;
            if (star){
                star.studyingNode = _arg1;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    facade.sendNotification(EventList.REFRESH_STAR);
                    break;
                case EventList.UPDATE_STAR_STATE:
                    handleStarState(_arg1.getBody());
                    break;
                case EventList.UPDATE_START_STATE:
                    handleStartState(_arg1.getBody());
                    break;
                case EventList.UPDATE_FINISH_STATE:
                    handleFinishState(_arg1.getBody());
                    break;
                case RoleEvents.SHOWPROPELEMENT:
                    if (getViewComponent() == null){
                        LoadStarSwf();
                        break;
                    };
                    if ((_arg1.getBody() as int) != TYPE){
                        facade.sendNotification(RoleEvents.HIDE_ATTRIBUTE);
                        if (((!((dataProxy == null))) && (parentView.contains(star)))){
                            parentView.removeChild(star);
                            star.removeEvents();
                        };
                        return;
                    };
                    if (dataProxy != null){
                        parentView.addChild(star);
                        initXML();
                        star.reFreshByLevel(GameCommonData.Player.Role.Level);
                        star.updateStatus(stateObj);
                        star.clickStar0(openStatus);
                        openStatus = 0;
                        star.setTwinklStar(studyingNode);
                        if (leftTime <= 1){
                            clearInterval(updateInterval);
                            StarSend.sendTrainFinish(0);
                            star.studyBtn.label = LanguageMgr.GetTranslation("学习");
                        };
                    };
                    break;
                case EventList.REFRESH_STAR:
                    LoadStarSwf();
                    _local2 = _arg1.getBody();
                    if (getViewComponent() != null){
                        checkStarTip((_local2 as int));
                    };
                    break;
                case EventList.SET_STAR_OPEN_STATUS:
                    this.openStatus = (_arg1.getBody() as int);
                    break;
                case EventList.UPDATEMONEY:
                    if (getViewComponent() != null){
                        reFreshMoney();
                    };
                    break;
                case EventList.UPDATEBAG:
                    if (getViewComponent() != null){
                        reFreshBag();
                    };
                    break;
            };
        }
        private function onQuiclClick(_arg1:MouseEvent):void{
            if (!speedisOpen){
                GameCommonData.GameInstance.GameUI.addChild(speed);
                speedisOpen = true;
                speed.x = int(((GameCommonData.GameInstance.ScreenWidth - speed.width) / 2));
                speed.y = int((((GameCommonData.GameInstance.ScreenHeight - speed.height) / 2) + 12));
                reFreshIcon();
            };
        }
        private function reFreshIcon():void{
            var _local1:*;
            var _local2:int;
            var _local3:int;
            var _local4:FaceItem;
            for each (_local1 in faceItemArray) {
                if (_local1.parent){
                    _local1.parent.removeChild(_local1);
                };
            };
            faceItemArray = [];
            _local2 = 1;
            while (_local2 < 6) {
                _local3 = BagData.getCountsByTemplateId((50700004 + _local2));
                _local4 = new FaceItem((50700004 + _local2).toString(), null, "bagIcon", 1, _local3);
                if (_local3 > 1){
                    _local4.setNum(_local3);
                };
                _local4.x = 7;
                _local4.y = 5;
                speed.frameArr[_local2].addChild(_local4);
                faceItemArray.push(_local4);
                _local2++;
            };
        }
        private function handleStarState(_arg1:Object):void{
            stateObj = _arg1;
            this.stateObj.current = _arg1.current;
            var _local2:Date = TimeManager.Instance.Now();
            studyingNode = _arg1.current;
            var _local3:Number = ((_arg1.time * 1000) - _local2.time);
            if (_local3 < 0){
                return;
            };
            leftTime = (_local3 / 1000);
            if (star){
                star.studyBtn.label = LanguageMgr.GetTranslation("学习中");
                star.studyBtn.enable = false;
            };
            clearInterval(updateInterval);
            updateInterval = setInterval(updateStudyTime, 1000);
        }
        private function onSpeedClick(_arg1:MouseEvent):void{
            var num:* = 0;
            var comfrim:* = null;
            var numb:* = 0;
            var type:* = 0;
            var index:* = 0;
            var si:* = null;
            var fp:* = 0;
            var costTime:* = 0;
            var passTime:* = 0;
            var gl:* = 0;
            var event:* = _arg1;
            if (this.studyingNode == 0){
                return;
            };
            num = event.currentTarget.name.split("_")[1];
            var count:* = 0;
            var funobj:* = new Object();
            var numArray:* = ["5", "20", "50", "160", "600"];
            count = 0;
            if (num != 0){
                count = BagData.getCountsByTemplateId(((50700005 + num) - 1), false);
            };
            var cancel:* = function ():void{
            };
            if (count > 0){
                funobj.info = LanguageMgr.GetTranslation("消耗加速卡学习", UIConstData.ItemDic[((50700005 + num) - 1)].Name);
                comfrim = function ():void{
                    StarSend.sendTrainFinish(2, (num - 1));
                };
            } else {
                if (num == 0){
                    type = (studyingNode / 100);
                    index = (studyingNode % 100);
                    si = (starInfo[("star_" + type)] as StarInfo);
                    fp = si.fixedPrice[index];
                    costTime = si.costTime[index];
                    passTime = (costTime - leftTime);
                    gl = (passTime / 180);
                    numb = (fp - gl);
                    if ((numb > 5)){
                    } else {
                        numb = 5;
                    };
                } else {
                    numb = numArray[(num - 1)];
                };
                funobj.info = LanguageMgr.GetTranslation("消耗金叶子学习", numb);
                comfrim = function ():void{
                    if (GameCommonData.Player.Role.Money >= (numb * 100)){
                        if (num == 0){
                            StarSend.sendTrainFinish(1);
                        } else {
                            StarSend.sendTrainFinish(2, (num - 1));
                        };
                    } else {
                        sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("请充值"));
                    };
                };
            };
            funobj.comfrim = comfrim;
            funobj.cancel = cancel;
            sendNotification(EventList.SHOWALERT, funobj);
        }
        private function get star():StarView{
            return ((viewComponent as StarView));
        }
        private function reFreshMoney():void{
            star.reFreshMoneyOnly();
        }
        private function get studyingNode():int{
            return (_studyingNode);
        }
        private function reFreshBag():void{
            star.reFreshClipOnly();
        }
        private function LoadStarSwf():void{
            if (startload){
                return;
            };
            startload = true;
            kissmyAss();
            reFreshBag();
            reFreshMoney();
            checkStarTip(GameCommonData.Player.Role.Level);
        }
        private function updateStudyTime():void{
            var _local1:uint = (leftTime % 60);
            var _local2:uint = ((leftTime / 60) % 60);
            var _local3:uint = (leftTime / 3600);
            leftTime--;
            if (star != null){
                star.setStudyTime(((((_local3 + ":") + _local2) + ":") + _local1));
                star.leftTime = leftTime;
                if (leftTime < 1){
                    StarSend.sendTrainFinish(0);
                } else {
                    star.studyBtn.enable = false;
                };
            };
        }
        public function setParentView(_arg1:Sprite):void{
            parentView = _arg1;
        }
        private function closeSpeed():void{
            if (speedisOpen){
                if (speed.parent){
                    speed.parent.removeChild(speed);
                };
                speedisOpen = false;
            };
        }
        private function kissmyAss():void{
            var _local2:HLabelButton;
            setViewComponent(new StarView());
            studyingNode = _studyingNode;
            star.studyBtn.addEventListener(MouseEvent.CLICK, onStudyClick);
            star.quickstudyBtn.addEventListener(MouseEvent.CLICK, onQuiclClick);
            speed = new StarSpeed();
            var _local1:int;
            while (_local1 < speed.btnArr.length) {
                _local2 = speed.btnArr[_local1];
                _local2.addEventListener(MouseEvent.CLICK, onSpeedClick);
                _local1++;
            };
            speed.closeCallBack = closeSpeed;
        }
        private function handleStartState(_arg1:Object):void{
            var _local2:Date = TimeManager.Instance.Now();
            var _local3:Number = (_arg1.time * 1000);
            studyingNode = _arg1.current;
            leftTime = (_local3 / 1000);
            if (this.stateObj == null){
                this.stateObj = new Object();
            };
            this.stateObj.current = _arg1.current;
            clearInterval(updateInterval);
            updateInterval = setInterval(updateStudyTime, 1000);
            if (star){
                star.studyBtn.label = LanguageMgr.GetTranslation("学习中");
                star.studyBtn.enable = false;
                star.setTwinklStar(studyingNode);
            };
        }
        private function handleFinishState(_arg1:Object):void{
            var _local4:int;
            var _local5:int;
            var _local6:String;
            var _local8:Object;
            var _local9:NewInfoTipVo;
            var _local10:uint;
            var _local2:uint = _arg1.node;
            var _local3:uint = _arg1.newTime;
            var _local7 = (("<br><font color=\"#00ff00\"><u><a href=\"event:showRoleEquipPanel_2_0\">" + LanguageMgr.GetTranslation("点击查看总揽")) + "</a></u></font>");
            if (stateObj == null){
                _local8 = new Object();
                _local8.finish = [_local2];
                star.updateStatus(_local8);
                star.reFreshByLevel(GameCommonData.Player.Role.Level);
                leftTime = 0;
                star.setStudyTime("--:--:--");
                clearInterval(updateInterval);
                star.studyBtn.label = LanguageMgr.GetTranslation("学习");
                star.leftTime = 0;
                star.quickstudyBtn.enable = false;
                studyingNode = 0;
                _local4 = (_local2 / 100);
                _local5 = (_local2 % 100);
                if (star.currentIndex == _local4){
                    if (star.currentSelectStar.name.split("_")[1] == _local5){
                        star.studyBtn.label = LanguageMgr.GetTranslation("已学习");
                    };
                };
                _local6 = (("<font color=\"#00ff00\">" + LanguageMgr.starArray[(_local4 - 1)][_local5]) + "</font>");
                _local6 = _local6.replace("+", "-");
                _local6 = _local6.replace("+", ": <font color='#ffff00'>+");
                _local6 = _local6.replace("-", ": <font color='#ffff00'>+");
                _local6 = _local6.replace("\n", "\t<font color=\"#00ff00\">");
                _local6 = (_local6 + _local7);
                openStatus = 1;
                _local9 = new NewInfoTipVo();
                _local9.type = NewInfoTipType.TYPE_STAR;
                _local9.title = LanguageMgr.GetTranslation("守护学习完成");
                facade.sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local9);
            } else {
                if (_local3 == 0){
                    if (!stateObj.finish){
                        stateObj.finish = new Array();
                    };
                    stateObj.finish.push(_local2);
                    star.updateStatus(stateObj);
                    star.reFreshByLevel(GameCommonData.Player.Role.Level);
                    leftTime = 0;
                    star.setStudyTime("--:--:--");
                    clearInterval(updateInterval);
                    star.studyBtn.label = LanguageMgr.GetTranslation("学习");
                    star.leftTime = 0;
                    star.quickstudyBtn.enable = false;
                    studyingNode = 0;
                    _local4 = (_local2 / 100);
                    _local5 = (_local2 % 100);
                    if (star.currentIndex == _local4){
                        if (star.currentSelectStar.name.split("_")[1] == _local5){
                            star.studyBtn.label = LanguageMgr.GetTranslation("已学习");
                        };
                    };
                    _local6 = (("<font color=\"#00ff00\">" + LanguageMgr.starArray[(_local4 - 1)][_local5]) + "</font>");
                    _local6 = _local6.replace("+", "-");
                    _local6 = _local6.replace("+", ": <font color='#ffff00'>+");
                    _local6 = _local6.replace("-", ": <font color='#ffff00'>+");
                    _local6 = _local6.replace("\n", "\t<font color=\"#00ff00\">");
                    _local6 = (_local6 + _local7);
                    openStatus = 1;
                    _local9 = new NewInfoTipVo();
                    _local9.type = NewInfoTipType.TYPE_STAR;
                    _local9.title = LanguageMgr.GetTranslation("守护学习完成");
                    facade.sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local9);
                    star.checkBtnEnable();
                } else {
                    _local10 = (_local3 - (TimeManager.Instance.Now().time / 1000));
                    leftTime = _local10;
                    studyingNode = _local2;
                };
            };
            if (star){
                star.setTwinklStar(studyingNode);
            };
            reFreshIcon();
        }
        private function onStudyClick(_arg1:MouseEvent):void{
            if ((getTimer() - clickStartTime) < 5000){
                sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("学习太快"));
                return;
            };
            clickStartTime = getTimer();
            switch (_arg1.currentTarget.name){
                case "level":
                    sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("等级不够"));
                    return;
                case "money":
                    sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("金钱不够"));
                    return;
                case "clip":
                    sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("碎片不够"));
                    return;
            };
            var _local2:MovieClip = star.currentSelectStar;
            var _local3:int = star.currentIndex;
            if (_local2.currentFrame != 2){
                return;
            };
            var _local4:int = _local2.name.split("_")[1];
            StarSend.sendTrainStart(((_local3 * 100) + _local4));
        }
        private function initXML():void{
            var _local2:XML;
            var _local3:String;
            var _local4:StarInfo;
            if (starInfo != null){
                return;
            };
            starInfo = {};
            var _local1:XML = GameCommonData.Star;
            for each (_local2 in _local1.elements()) {
                _local3 = ("star_" + uint(_local2.@Id));
                _local4 = new StarInfo();
                _local4.id = _local2.@Id;
                _local4.name = _local2.@name;
                _local4.num = _local2.@max_level;
                _local4.needLevel = String(_local2.@need_lv).split(",");
                _local4.costTime = String(_local2.@cost_time).split(",");
                _local4.costExp = String(_local2.@cost_exp).split(",");
                _local4.costClip = String(_local2.@cost_stars).split(",");
                _local4.costGold = String(_local2.@cost_gold).split(",");
                _local4.fixedPrice = String(_local2.@fixed_price).split(",");
                _local4.attackAdd = String(_local2.@attack_add).split(",");
                _local4.defAdd = String(_local2.@def_add).split(",");
                _local4.normalHitAdd = String(_local2.@normal_hit_add).split(",");
                _local4.normalDodgeAdd = String(_local2.@normal_dodge_add).split(",");
                _local4.criDmgAdd = String(_local2.@cri_dmg_add).split(",");
                _local4.criticalAdd = String(_local2.@critical_add).split(",");
                _local4.skillHitAdd = String(_local2.@skill_hit_add).split(",");
                _local4.skillDodogeAdd = String(_local2.@skill_dodge_add).split(",");
                _local4.hpAdd = String(_local2.@hp_add).split(",");
                _local4.mpAdd = String(_local2.@mp_add).split(",");
                _local4.resistance_1 = String(_local2.@resistance_1).split(",");
                _local4.resistance_2 = String(_local2.@resistance_2).split(",");
                _local4.resistance_3 = String(_local2.@resistance_3).split(",");
                _local4.resistance_4 = String(_local2.@resistance_4).split(",");
                _local4.resistance_5 = String(_local2.@resistance_5).split(",");
                star.levelArray = star.levelArray.concat(_local4.needLevel);
                starInfo[("star_" + _local4.id)] = _local4;
            };
            star.starInfo = starInfo;
        }

    }
}//package GameUI.Modules.Constellation.Mediator 
