//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.HButton.*;
    import flash.net.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Activity.*;
    import GameUI.Modules.Activity.VO.*;
    import Net.RequestSend.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Map.SmallMap.Mediator.*;
    import GameUI.Modules.QuickBuy.Command.*;
    import GameUI.Modules.Activity.UI.*;

    public class ActivityMediator extends Mediator {

        public static const NAME:String = "ActivityMediator";

        private const WeiArr:Array = [128, 0x0100, 0x0200, 0x0400, 0x0800];;
        private const ORD:Array = [0, 3, 8, 13, 14, 12, 10, 11, 9, 2, 6, 7, 4, 5, 1];;

        private var chest:SimpleButton;
        private var updateIsInit:Boolean = false;
        private var activityArray:Array;
        private var des:String;
        private var accuLeaf:uint;
        private var every:Object;
        private var exp:uint;
        private var isInitView:Boolean = false;
        private var isShowOff:Boolean;
        private var activityObject:Object;
        private var isCloseChest:Boolean;
        private var type:int = 2;
        private var tryTimes:uint = 0;
        private var DivineTaskIsFinished:Boolean;
        private var oTime:String = "";
        private var dataProxy:DataProxy;
        private var desArray:Array;
        private var loginArray:Object;
        private var mulArray:Array;

        public function ActivityMediator(){
            activityArray = [];
            activityObject = {};
            desArray = [LanguageMgr.GetTranslation("Act1"), LanguageMgr.GetTranslation("Act2"), LanguageMgr.GetTranslation("Act3")];
            mulArray = [1, 1.6, 4];
            des = LanguageMgr.GetTranslation("Act4");
//            ORD = [0, 3, 8, 13, 14, 12, 10, 11, 9, 2, 6, 7, 4, 5, 1];
//            WeiArr = [128, 0x0100, 0x0200, 0x0400, 0x0800];
            super(NAME);
        }
        private function onEveryDay(_arg1:MouseEvent):void{
            var finArray:* = null;
            var unFin:* = null;
            var speId:* = 0;
            var isSendReward:* = false;
            var btnName:* = null;
            var id:* = 0;
            var item:* = null;
            var event:* = _arg1;
            var fuc:* = function (_arg1:int):void{
                if (every[ORD[_arg1]].IsFinish){
                    finArray.push(every[ORD[_arg1]]);
                } else {
                    unFin.push(_arg1);
                };
            };
            finArray = [];
            unFin = [];
            var i:* = 1;
            while (i <= 11) {
                fuc(i);
                i = (i + 1);
            };
            if (GameCommonData.Player.Role.Level < 50){
                speId = 12;
            } else {
                speId = 13;
            };
            fuc(speId);
            fuc(14);
            var btn:* = (event.currentTarget as HLabelButton);
            var count:* = BagData.getCountsByTemplateId(50700028, false);
            switch (event.currentTarget.name){
                case "quickfin":
                    if (count >= unFin.length){
                        if (unFin.length > 0){
                            ActivitySend.sendQuickFinish(unFin);
                        } else {
                            sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("Act6"));
                        };
                    } else {
                        facade.sendNotification(EventList.SHOWALERT, {
                            comfrim:function ():void{
                                ActivitySend.sendQuickFinish(unFin);
                            },
                            cancel:function ():void{
                            },
                            info:((((LanguageMgr.GetTranslation("Act7") + unFin.length) + LanguageMgr.GetTranslation("Act8")) + ((unFin.length - count) * 15)) + LanguageMgr.GetTranslation("Act9")),
                            title:LanguageMgr.GetTranslation("Act10")
                        });
                    };
                    break;
                case "quickget":
                    if (finArray.length >= 1){
                        i = 1;
                        while (i <= view.RewardID) {
                            if ((GameCommonData.activityData[50] & WeiArr[(i - 1)]) != 0){
                            } else {
                                isSendReward = true;
                                CharacterSend.GetReward(4000, i);
                            };
                            i = (i + 1);
                        };
                        if (!isSendReward){
                            MessageTip.popup(LanguageMgr.GetTranslation("Act14"));
                        };
                    } else {
                        sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("Act12"));
                    };
                    break;
            };
            if (event.currentTarget.name.indexOf("_") != -1){
                btnName = event.currentTarget.name.split("_")[0];
                id = uint(event.currentTarget.name.split("_")[1]);
                item = (every[id] as ActivityMustDoItem);
                if (item.special == "职业任务"){
                    if (!dataProxy.TaskIsOpen){
                        sendNotification(EventList.SHOWTASKVIEW, 1);
                    } else {
                        sendNotification(EventList.CLOSETASKVIEW);
                    };
                    return;
                };
                if (item.special == "公会副本"){
                    if (!dataProxy.UnityIsOpen){
                        facade.sendNotification(EventList.SHOWUNITYVIEW, {tog:3});
                    } else {
                        facade.sendNotification(EventList.CLOSEUNITYVIEW);
                    };
                    sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                    return;
                };
                if (item.special == "日常任务书"){
                    if (!dataProxy.TaskDailyBOokIsOpen){
                        sendNotification(EventList.SHOWTASKDAILYBOOK);
                    };
                    return;
                };
                autoClickItem(item.actId);
            };
        }
        private function showChest(_arg1:Boolean):void{
            if (_arg1){
                if ((GameCommonData.NewAndCharge & 3) != 3){
                    chest = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("ChargeChest");
                    chest.addEventListener(MouseEvent.CLICK, onShowChest);
                    chest.name = "CHARGECHEST";
                    chest.x = 251;
                    chest.y = 39;
                    GameCommonData.GameInstance.GameUI.addChild(chest);
                } else {
                    closeChest(true);
                    if ((((((((chest == null)) && ((accuLeaf > 0)))) && (!(isCloseChest)))) && (!((GameCommonData.AccuChargeEnable == 1023))))){
                        chest = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("ChargeChest1");
                        chest.addEventListener(MouseEvent.CLICK, onShowChest1);
                        chest.name = "CHARGECHEST1";
                        chest.x = 251;
                        chest.y = 39;
                        GameCommonData.GameInstance.GameUI.addChild(chest);
                    };
                };
            } else {
                closeChest(true);
                if ((((((((chest == null)) && ((accuLeaf > 0)))) && (!(isCloseChest)))) && (!((GameCommonData.AccuChargeEnable == 1023))))){
                    chest = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("ChargeChest1");
                    chest.addEventListener(MouseEvent.CLICK, onShowChest1);
                    chest.name = "CHARGECHEST1";
                    chest.x = 251;
                    chest.y = 39;
                    GameCommonData.GameInstance.GameUI.addChild(chest);
                };
            };
        }
        private function analyzeEveryDayXML():void{
            var _local2:*;
            var _local3:ActivityMustDoItem;
            every = new Object();
            var _local1:XML = GameCommonData.ActivityEveryDayXML;
            for each (_local2 in _local1.elements()) {
                _local3 = new ActivityMustDoItem();
                _local3.id = int(_local2.@id);
                _local3.Title = _local2.@aname;
                _local3.Max = _local2.@amax;
                _local3.current = 0;
                _local3.ActiveRate = int(_local2.@activeRate);
                _local3.tog = _local2.@tog;
                _local3.actId = _local2.@actId;
                _local3.special = _local2.@special;
                _local3.TextColor = int(_local2.@textColor);
                _local3.Btn_des.name = ("EveryDayDes_" + _local3.id);
                _local3.Btn_des.addEventListener(MouseEvent.CLICK, onEveryDay);
                _local3.Btn_quickComplete.name = ("" + _local3.id);
                _local3.Btn_quickComplete.htmlText = (("<u><a href=\"event:quickCompleteLink\">" + LanguageMgr.GetTranslation("快速完成")) + "</a></u>");
                _local3.Btn_quickComplete.width = 62;
                _local3.Btn_quickComplete.height = 18;
                _local3.Btn_quickComplete.addEventListener(TextEvent.LINK, quickCompleteLink);
                every[_local3.id] = _local3;
            };
        }
        private function quickCompleteLink(_arg1:TextEvent):void{
            var unFin:* = null;
            var oneFun:* = null;
            var event:* = _arg1;
            var count:* = BagData.getCountsByTemplateId(50700028, false);
            var id:* = ORD.indexOf(uint(event.currentTarget.name));
            unFin = [id];
            if (count >= 1){
                ActivitySend.sendQuickFinish(unFin);
            } else {
                oneFun = function ():void{
                    ActivitySend.sendQuickFinish(unFin);
                };
                facade.sendNotification(EventList.SHOWALERT, {
                    comfrim:oneFun,
                    cancel:function ():void{
                    },
                    info:LanguageMgr.GetTranslation("Act13"),
                    title:LanguageMgr.GetTranslation("Act10")
                });
            };
        }
        private function RequestInfo2():void{
            updateActivity(activityObject);
        }
        public function updateLoginDays():void{
            if (isInitView){
                view.updateLoginDays(-1);
            };
        }
        private function showFruit(_arg1:uint):void{
            showActivity();
            view.togArray[4].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            updateExp();
            view.openWelfare(_arg1);
        }
        private function onCom(_arg1:Event):void{
            var _local2:XML = new XML(_arg1.currentTarget.data);
            view.updateUpdate(_local2);
        }
        private function updateExp():void{
            view.setExp(exp.toString());
        }
        private function get view():ActivityView{
            return ((this.viewComponent as ActivityView));
        }
        private function onXMLCom():void{
            var _local2:ActivityVO;
            var _local3:XML;
            var _local1:XML = GameCommonData.ActivityXMLs;
            GameCommonData.ActivityList = [];
            for each (_local3 in _local1.elements()) {
                _local2 = new ActivityVO();
                _local2.id = int(_local3.@id);
                _local2.name = String(_local3.@name);
                _local2.startArr = String(_local3.@start).split(",");
                _local2.endArr = String(_local3.@end).split(",");
                _local2.level = int(_local3.@level);
                _local2.maxLevel = int(_local3.@maxlevel);
                if (_local2.maxLevel <= _local2.level){
                    _local2.maxLevel = 100;
                };
                _local2.total = _local3.@total;
                _local2.tileX = _local3.@tileX;
                _local2.tileY = _local3.@tileY;
                _local2.sceneID = _local3.@sceneID;
                _local2.type = int(_local3.@type);
                _local2.targetID = _local3.@targetID;
                _local2.targetNPC = _local3.@npcname;
                _local2.picPath = _local3.pic;
                _local2.setAward(_local3.award);
                _local2.rule = _local3.rule;
                _local2.reward = _local3.@reward;
                _local2.rewardCnt = _local2.reward.match(/★/g).length;
                _local2.teamType = _local3.@team;
                _local2.timePrompt = _local3.@time;
                GameCommonData.ActivityList.push(_local2);
            };
            RequestInfo2();
            GameCommonData.ActivityXMLs = null;
        }
        private function showActivity():void{
            if (GameCommonData.IsInCrossServer){
                MessageTip.popup(LanguageMgr.GetTranslation("跨服战功能屏蔽提示"));
                return;
            };
            if (!isInitView){
                initView();
                onXMLCom();
                if (isShowOff){
                    isShowOff = false;
                    return;
                };
            };
            updateActivity(activityObject);
            GameCommonData.GameInstance.GameUI.addChild(view);
            view.x = int(((GameCommonData.GameInstance.ScreenWidth - 700) / 2));
            view.y = int(((GameCommonData.GameInstance.ScreenHeight - 472) / 2));
            dataProxy.ActivityViewIsOpen = true;
            view.toggleFit();
            view.updateLoginDays(tryTimes);
            view.handleBtnEnable();
            if (loginArray == null){
                ActivitySend.sendActivityTry(1);
            };
            view.EnableChargeBtns();
            if (!updateIsInit){
                initUpdate();
                updateIsInit = true;
            };
            if (every == null){
                analyzeEveryDayXML();
            };
            updateEvery();
            enableGetAwardBtn();
            updateAccuLeft(accuLeaf);
        }
        private function onGetExp(_arg1:MouseEvent):void{
            OffLineExpSend.sendRequestOffLineExp(type);
        }
        private function enableGetAwardBtn():void{
            var _local1:int;
            var _local2:int;
            var _local3:int;
            var _local4:int;
            if (((((view) && (view.awardItemArr))) && (view.awardItemArr[0]))){
                _local1 = WeiArr.length;
                _local4 = 0;
                while (_local4 < _local1) {
                    if (view.awardItemArr[_local4].getItemEnable()){
                        _local3++;
                    };
                    if ((GameCommonData.activityData[50] & WeiArr[_local4]) != 0){
                        _local2++;
                        view.awardItemArr[_local4].Geted = true;
                    } else {
                        view.awardItemArr[_local4].Geted = false;
                    };
                    _local4++;
                };
                if (_local2 == _local1){
                    view.eiBtns[0].enable = false;
                    view.eiBtns[1].enable = false;
                };
                if (_local3 > _local2){
                    view.isIconFlash = true;
                    (facade.retrieveMediator(SmallMapMediator.NAME) as SmallMapMediator).showActivityFlash();
                } else {
                    view.isIconFlash = false;
                    (facade.retrieveMediator(SmallMapMediator.NAME) as SmallMapMediator).hideActivityFlash();
                };
            };
        }
        private function showOff():void{
            if (!isInitView){
                isShowOff = true;
                showActivity();
            };
            updateExp();
        }
        public function updateAccuLeft(_arg1:int):void{
            if (view){
                view.updateAccuLeft(_arg1);
            };
        }
        private function onRadioGroupClick(_arg1:MouseEvent):void{
            var _local5:Array;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local2:int;
            while (_local2 < 3) {
                (view.radioGroup[_local2] as MovieClip).prevFrame();
                _local2++;
            };
            (_arg1.currentTarget as MovieClip).nextFrame();
            var _local3:Array = _arg1.currentTarget.name.toString().split("");
            type = (_local3[6] - 1);
            var _local4 = "";
            _local4 = desArray[type];
            if (type == 1){
                _local5 = desArray[type].split("_");
                if (exp != 0){
                    _local6 = ((exp / 10) * 3);
                    _local7 = (_local6 / 10000);
                    _local8 = ((_local6 % 10000) / 100);
                    _local9 = (_local6 % 100);
                    _local4 = (((((((("" + _local5[0]) + _local7) + "\\ce") + _local8) + "\\cs") + _local9) + "\\cc") + _local5[1]);
                } else {
                    _local4 = ((("" + _local5[0]) + LanguageMgr.GetTranslation("Act5")) + _local5[1]);
                };
                view.setDes(_local4, true);
            } else {
                view.setDes(_local4);
            };
            view.setMul(mulArray[type]);
        }
        private function onRadioMaskGroupClick(_arg1:Event):void{
            var _local2:int = int(_arg1.currentTarget.name.split("_")[1]);
            view.radioGroup[(_local2 - 1)].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        public function updateEvery():void{
            if (isInitView){
                view.updateEvery(every);
            };
        }
        private function autoClickItem(_arg1:int):void{
            var _local2:ActivityVO;
            var _local3:int;
            var _local4:NewActivityItem;
            for each (_local2 in GameCommonData.ActivityList) {
                if (_local2.id == _arg1){
                    switch (_local2.type){
                        case 2:
                            _local3 = 2;
                            break;
                        case 3:
                            _local3 = 3;
                            break;
                        case 5:
                            _local3 = 4;
                            break;
                        case 7:
                            _local3 = 5;
                            break;
                    };
                    if (_local3 == 0){
                        return;
                    };
                    view.toggleOne(_local3);
                    for each (_local4 in view.actList) {
                        if (_local2 == _local4.getData()){
                            view.autoClickItem((view.actList.indexOf(_local4) + 1));
                            return;
                        };
                    };
                };
            };
        }
        private function onQuickBuy(_arg1:MouseEvent):void{
            sendNotification(QuickBuyCommandList.SHOW_QUICKBUY_UI, {TemplateID:50700002});
        }
        private function onClose():void{
            view.setExpEffect(false);
            view.CurToggleType = 0;
            enableGetAwardBtn();
            dataProxy.ActivityViewIsOpen = false;
            if (GameCommonData.GameInstance.GameUI.contains(view)){
                GameCommonData.GameInstance.GameUI.removeChild(view);
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOW_ACTIVITY, EventList.SHOW_ACTIVITY_WELFARE, EventList.TOGGLE_ACTIVITY, EventList.CLICK_ACTIVITY_ITEM, EventList.SHOW_ACTIVITY_CHARGE, EventList.CLOSE_ACTIVITY, EventList.INITVIEW, EventList.UPDATE_ACTIVITY, EventList.HANDLE_ACTIVITY_BTN, EventList.SHOW_OFFLINEEXP, EventList.CLOSE_OFFLINEEXP, EventList.UPDATE_OFF_EXP, EventList.UPDATE_DAILYAWARD, EventList.UPDATE_EVERY_ACTIVITY, EventList.UPDATE_ACCU_LEAFDAY, EventList.OPEN_ACTIVITY_WELFARE, EventList.SHOW_CHARGE_CHEST, EventList.CLOSE_CHARGE_CHEST, EventList.UPDATE_LEVEL, EventList.UPDATE_RECHARGE_VIEW, EventList.SHOW_BIBLE_TOGACTIVITY, TaskCommandList.UPDATE_COMPLETETASK_LIST, EventList.SHOW_GET_GIFT_EFFECT]);
        }
        private function onShowChest(_arg1:MouseEvent):void{
            sendNotification(EventList.OPEN_ACTIVITY_WELFARE, 2);
        }
        private function closeChest(_arg1:Boolean):void{
            if (chest){
                if ((((((_arg1 == true)) && ((chest.name == "CHARGECHEST")))) || ((((_arg1 == false)) && ((chest.name == "CHARGECHEST1")))))){
                    chest.removeEventListener(MouseEvent.CLICK, onShowChest);
                    if (chest.parent){
                        chest.parent.removeChild(chest);
                        chest = null;
                    };
                };
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            var _local3:Object;
            var _local4:Boolean;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.CLOSE_ACTIVITY:
                    onClose();
                    break;
                case EventList.SHOW_ACTIVITY:
                    showActivity();
                    enableGetAwardBtn();
                    break;
                case EventList.SHOW_ACTIVITY_WELFARE:
                    showActivity();
                    view.toggleWelfare(uint(_arg1.getBody()));
                    break;
                case EventList.TOGGLE_ACTIVITY:
                    showActivity();
                    view.toggleOne(uint(_arg1.getBody()));
                    break;
                case EventList.CLICK_ACTIVITY_ITEM:
                    view.autoClickItem(uint(_arg1.getBody()));
                    break;
                case EventList.SHOW_ACTIVITY_CHARGE:
                    showActivity();
                    view.toggleCharge();
                    break;
                case EventList.UPDATE_ACTIVITY:
                    activityObject = _arg1.getBody();
                    if (isInitView){
                        updateActivity(_arg1.getBody());
                    };
                    break;
                case EventList.HANDLE_ACTIVITY_BTN:
                    if (dataProxy.ActivityViewIsOpen){
                        view.handleBtnEnable();
                    };
                    _local2 = (_arg1.getBody() as uint);
                    if (_local2 == 3){
                    };
                    break;
                case EventList.UPDATE_OFF_EXP:
                    _local3 = _arg1.getBody();
                    this.exp = uint(_local3.expOffLine);
                    if (_local3.describe != undefined){
                        oTime = _local3.describe;
                    };
                    if (((dataProxy) && (dataProxy.ActivityViewIsOpen))){
                        updateExp();
                        view.setTime(oTime);
                    };
                    break;
                case EventList.UPDATE_RECHARGE_VIEW:
                    if (isInitView){
                        view.updateGoldView();
                    };
                    break;
                case EventList.CLOSE_CHARGE_CHEST:
                    isCloseChest = true;
                    closeChest(false);
                    break;
                case EventList.SHOW_OFFLINEEXP:
                    _local4 = (_arg1.getBody() as Boolean);
                    if (_local4){
                        if (exp > 0){
                            showOff();
                            view.setMul(mulArray[type]);
                        };
                    } else {
                        showOff();
                        view.setMul(mulArray[type]);
                    };
                    if (GameCommonData.Player.Role.Level >= 35){
                        showActivity();
                        view.setTit(des);
                        view.setTime(oTime);
                    } else {
                        if (isInitView){
                            view.setTit(des);
                            view.setTime(oTime);
                        };
                    };
                    break;
                case EventList.UPDATE_DAILYAWARD:
                    updateEveryDay(_arg1.getBody());
                    loginArray = _arg1.getBody();
                    break;
                case EventList.UPDATE_EVERY_ACTIVITY:
                    if (every == null){
                        analyzeEveryDayXML();
                    };
                    every[ORD[9]].current = (_arg1.getBody() as uint);
                    updateEvery();
                    break;
                case EventList.UPDATE_LEVEL:
                    if (GameCommonData.Player.Role.Level == 50){
                        if (every == null){
                            analyzeEveryDayXML();
                        };
                        every[ORD[9]].current = (_arg1.getBody() as uint);
                        updateEvery();
                    };
                    break;
                case EventList.UPDATE_ACCU_LEAFDAY:
                    accuLeaf = (_arg1.getBody() as uint);
                    updateAccuLeft((_arg1.getBody() as uint));
                    break;
                case EventList.OPEN_ACTIVITY_WELFARE:
                    if (GameCommonData.IsInCrossServer){
                        MessageTip.popup(LanguageMgr.GetTranslation("跨服战功能屏蔽提示"));
                        return;
                    };
                    showFruit((_arg1.getBody() as uint));
                    break;
                case EventList.SHOW_CHARGE_CHEST:
                    showChest((_arg1.getBody() as Boolean));
                    break;
                case EventList.SHOW_GET_GIFT_EFFECT:
                    view.showGetNewGiftEffect();
                    break;
                case EventList.SHOW_BIBLE_TOGACTIVITY:
                    showActivity();
                    autoClickItem(int(_arg1.getBody()));
                    break;
                case TaskCommandList.UPDATE_COMPLETETASK_LIST:
                    if (TaskCommonData.CompleteTaskIdArray.indexOf(TaskCommonData.DivineBaseTaskId) != -1){
                        DivineTaskIsFinished = true;
                    } else {
                        DivineTaskIsFinished = false;
                    };
                    if (((view) && ((view.CurToggleType > 0)))){
                        updateActivity(activityObject);
                    };
                    break;
            };
        }
        private function initView():void{
            var _local2:MovieClip;
            var _local3:*;
            isInitView = true;
            var _local1:ActivityView = new ActivityView();
            _local1.closeCallBack = onClose;
            this.setViewComponent(_local1);
            for each (_local2 in view.radioGroup) {
                _local2.addEventListener(MouseEvent.CLICK, onRadioGroupClick);
            };
            for each (_local2 in view.radioMaskGroup) {
                _local2.addEventListener(MouseEvent.CLICK, onRadioMaskGroupClick);
            };
            view.getExp.addEventListener(MouseEvent.CLICK, onGetExp);
            view.quickBuy.addEventListener(MouseEvent.CLICK, onQuickBuy);
            for each (_local3 in view.eiBtns) {
                _local3.addEventListener(MouseEvent.CLICK, onEveryDay);
            };
        }
        private function updateEveryDay(_arg1:Object):void{
            view.updateLoginDay(_arg1);
        }
        public function enablleAccuCharge():void{
            if (view){
                view.EnableChargeBtns();
            };
        }
        private function onShowChest1(_arg1:MouseEvent):void{
            sendNotification(EventList.OPEN_ACTIVITY_WELFARE, 3);
        }
        private function updateActivity(_arg1:Object):void{
            var _local2:ActivityVO;
            var _local4:uint;
            var _local5:int;
            var _local6:int;
            var _local7:uint;
            var _local8:Boolean;
            var _local9:int;
            if (_arg1 == null){
                return;
            };
            for each (_local2 in GameCommonData.ActivityList) {
                if (_arg1[_local2.id] != null){
                    _local2.current = (_arg1[_local2.id] % 10000);
                    _local2.Value = _arg1[_local2.id];
                };
                if (_local2.id == 48){
                    _local2.current = (DivineTaskIsFinished) ? _local2.total : 0;
                };
            };
            if (((isInitView) && ((view.CurToggleType > 0)))){
                view.updateActivity();
            };
            var _local3:Object = GameCommonData.activityData;
            tryTimes = GameCommonData.activityData[66];
            view.tryTime = tryTimes;
            if (_local3[65] == undefined){
                trace("");
            } else {
                if (_local3[65] == 0){
                    view.enableTry();
                    view.clearCenter();
                } else {
                    view.onTestStop(_local3[65]);
                    delete _local3[65];
                };
            };
            if (every == null){
                analyzeEveryDayXML();
            };
            if (_local3[67] != undefined){
                every[ORD[1]].current = (_local3[34] % 10000);
                _local4 = (_local3[54] % 100);
                every[ORD[8]].current = ((_local4 > 5)) ? 5 : _local4;
                if (GameCommonData.activityData[23] == 0){
                    every[ORD[9]].current = 0;
                } else {
                    every[ORD[9]].current = GameCommonData.Player.Role.loopTaskIdx;
                };
                every[ORD[12]].current = (_local3[1] % 10000);
                every[ORD[3]].Value = _local3[4];
                every[ORD[13]].current = (_local3[6] % 10000);
                every[ORD[14]].current = int((_local3[44] / 10000));
                _local5 = 0;
                _local7 = 1;
                _local9 = 0;
                while (_local9 < 14) {
                    _local8 = false;
                    if ((((((every[ORD[(_local9 + 1)]].actId == 1)) && ((GameCommonData.Player.Role.Level >= 50)))) || ((((every[ORD[(_local9 + 1)]].actId == 6)) && ((GameCommonData.Player.Role.Level < 50)))))){
                        _local8 = true;
                    };
                    if (!_local8){
                        if ((_local3[67] & _local7) != 0){
                            _local6++;
                            _local5 = (_local5 + (every[ORD[(_local9 + 1)]] as ActivityMustDoItem).ActiveRate);
                            every[ORD[(_local9 + 1)]].IsFinish = true;
                        } else {
                            every[ORD[(_local9 + 1)]].IsFinish = false;
                        };
                    };
                    _local7 = (_local7 << 1);
                    _local9++;
                };
                view.updateEveryProgress(_local6, _local5);
                updateEvery();
            };
            enableGetAwardBtn();
        }
        private function initUpdate():void{
            var _local1:URLLoader = new URLLoader();
            _local1.load(new URLRequest(((GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameData/GameUpdate.xml?v=") + Math.random())));
            _local1.addEventListener(Event.COMPLETE, onCom);
        }

    }
}//package GameUI.Modules.Activity.Mediator 
