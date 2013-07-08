//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GameTarget.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.observer.*;
    import GameUI.Modules.GameTarget.View.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.GameTarget.VO.*;

    public class TargetMediator extends Mediator {

        public static const NAME:String = "TargetMediator";

        private var heroTarget:SimpleButton;
        private var enterTime:uint;
        private var timer:Timer;
        private var effect:MovieClip;
        private var isInitView:Boolean = false;
        private var dataProxy:DataProxy;
        private var statusObj:Object;
        private var guildTime:uint;
        private var discribeObj:Object;
        private var status:Boolean;

        public function TargetMediator(){
            discribeObj = [];
            timer = new Timer(60000, 0);
            statusObj = {};
            super(NAME);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.SHOW_TARGET:
                    showTarget();
                    break;
                case EventList.CLOSE_TARGET:
                    closeTarget();
                    break;
                case EventList.UPDATE_TARGET_SINGLE:
                    HandleSingle(_arg1.getBody());
                    break;
                case EventList.UPDATE_TARGET_STATUS:
                    HandleStatus(_arg1.getBody());
                    break;
                case EventList.UPDATE_TARGET_TIMES:
                    HandleTimes(_arg1.getBody());
                    break;
            };
        }
        private function get tv():TargetView{
            return ((viewComponent as TargetView));
        }
        private function initTVEvents():void{
            var _local2:Sprite;
            var _local1:int;
            while (_local1 < tv.btnArray.length) {
                tv.updateBtnStatus(statusObj[_local1], _local1);
                _local2 = tv.btnArray[_local1];
                _local2.addEventListener(MouseEvent.CLICK, onBtnClick);
                _local2["Tname"].text = discribeObj[_local1].name;
                _local1++;
            };
        }
        private function onBtnClick(_arg1:MouseEvent):void{
            var _local2:int = _arg1.currentTarget.name.split("_")[1];
            tv.UpdateAllDiscribe(discribeObj[_local2].target, discribeObj[_local2].start, discribeObj[_local2].limit, discribeObj[_local2].help);
            tv.updateAwards(discribeObj[_local2].award);
            tv.updateBtnStatus(statusObj[_local2], _local2);
        }
        private function initView():void{
            isInitView = true;
            setViewComponent(new TargetView());
            tv.closeCallBack = closeTarget;
            tv.x = 230;
            tv.y = 95;
            tv.awardBtn.addEventListener(MouseEvent.CLICK, onGetAward);
        }
        private function removeEffects():void{
            if (((effect) && (effect.parent))){
                effect.parent.removeChild(effect);
            };
            effect = null;
        }
        private function checkStatus():Boolean{
            var _local1:Boolean;
            var _local2:int;
            while (_local2 < 10) {
                if (statusObj[_local2] == 3){
                    _local1 = true;
                };
                _local2++;
            };
            return (_local1);
        }
        private function initTargetBtn():void{
            heroTarget = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("HeroTarget");
            GameCommonData.GameInstance.GameUI.addChild(heroTarget);
            heroTarget.addEventListener(MouseEvent.CLICK, onShowTarget);
            heroTarget.x = 215;
            heroTarget.y = 2;
        }
        private function HandleTimes(_arg1:Object):void{
            if (_arg1[1]){
                guildTime = _arg1[1];
            };
        }
        private function HandleStatus(_arg1:Object):void{
            enterTime = _arg1.enter;
            guildTime = _arg1.guild;
            var _local2:Boolean;
            var _local3:Boolean;
            var _local4:int;
            while (_local4 < 10) {
                statusObj[_local4] = _arg1[_local4];
                if (isInitView){
                    tv.updateBtnStatus(_arg1[_local4], _local4);
                };
                if (_arg1[_local4] == 3){
                    _local2 = true;
                };
                if ((((((statusObj[_local4] == 0)) || ((statusObj[_local4] == 1)))) || ((statusObj[_local4] == 3)))){
                    _local3 = true;
                };
                _local4++;
            };
            if (!_local3){
                if (heroTarget){
                    GameCommonData.GameInstance.GameUI.removeChild(heroTarget);
                    heroTarget.removeEventListener(MouseEvent.CLICK, onShowTarget);
                    heroTarget = null;
                };
            } else {
                initTargetBtn();
                timer.addEventListener(TimerEvent.TIMER, onTimer);
                timer.start();
            };
            if (_local2){
                addEffects();
            };
        }
        private function onGetAward(_arg1:MouseEvent):void{
            if (tv.CurrentRank != -1){
                GameTargetSend.sendRequest((tv.CurrentRank + 1), 5);
                EffectLib.foodsMove(tv.getAwardsUI());
                if ((tv.CurrentRank + 1) == 2){
                    facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETUPSTAR_STARTUP);
                } else {
                    if ((tv.CurrentRank + 1) == 3){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETQUALITYREFRESH_STARTUP);
                    };
                };
            };
        }
        private function closeTarget():void{
            if (tv.parent){
                GameCommonData.GameInstance.GameUI.removeChild(tv);
            };
            dataProxy.GameTargetViewIsOpen = false;
            if (checkStatus()){
                addEffects();
            };
        }
        private function onShowTarget(_arg1:MouseEvent):void{
            if (effect != null){
                removeEffects();
            };
            if (dataProxy.GameTargetViewIsOpen){
                closeTarget();
            } else {
                showTarget();
            };
        }
        private function showTarget():void{
            var _local9:*;
            var _local10:TargetItem;
            var _local11:String;
            var _local12:Array;
            var _local13:int;
            var _local14:int;
            var _local15:int;
            var _local16:Object;
            if (!isInitView){
                initView();
            };
            UpdateViewAfterHandleStatus();
            GameCommonData.GameInstance.GameUI.addChild(tv);
            tv.x = int(((GameCommonData.GameInstance.ScreenWidth - tv.width) / 2));
            tv.y = int(((GameCommonData.GameInstance.ScreenHeight - tv.height) / 2));
            dataProxy.GameTargetViewIsOpen = true;
            var _local1:Date = TimeManager.Instance.Now();
            var _local2:Date = new Date((enterTime * 1000));
            var _local3:Number = (TimeManager.Instance.Now().time - (enterTime * 1000));
            var _local4:uint = ((((_local3 / 1000) / 60) / 60) / 24);
            var _local5:uint = ((((_local3 / 1000) / 60) / 60) - (_local4 * 24));
            var _local6:uint = (((_local3 / 1000) / 60) / 60);
            var _local7:XML = GameCommonData.TargetXMLs;
            var _local8:int;
            for each (_local9 in _local7.elements()) {
                _local10 = new TargetItem();
                _local10.day = _local9.@Id;
                _local10.name = _local9.@name;
                _local10.target = _local9.@discription;
                _local10.limit = LanguageMgr.GetTranslation("开启后的x消失内完成", _local9.@validtime);
                _local11 = "";
                if ((_local8 * 24) >= _local6){
                    if (((_local8 * 24) - _local6) == 0){
                    } else {
                        if ((_local8 * 24) > _local6){
                            _local14 = (_local8 - _local4);
                            _local15 = (24 - _local5);
                        };
                    };
                };
                _local10.distanceTime = _local11;
                _local10.start = LanguageMgr.GetTranslation("进入游戏的第x天开始y", _local9.@startday, _local11);
                _local10.help = _local9.@tips;
                _local12 = _local9.@bonus.split(",");
                _local13 = 0;
                while (_local13 < _local12[0]) {
                    _local16 = new Object();
                    _local16.awardID = _local12[((_local13 * 2) + 1)];
                    _local16.num = _local12[((_local13 * 2) + 2)];
                    _local10.award.push(_local16);
                    _local13++;
                };
                discribeObj[uint((_local10.day - 1))] = _local10;
                _local8++;
            };
            initTVEvents();
            tv.btnArray[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOW_TARGET, EventList.CLOSE_TARGET, EventList.UPDATE_TARGET_STATUS, EventList.UPDATE_TARGET_SINGLE, EventList.UPDATE_TARGET_TIMES]);
        }
        private function HandleSingle(_arg1:Object):void{
            statusObj[_arg1.day] = _arg1.op;
            if (isInitView){
                tv.updateBtnStatus(_arg1.op, _arg1.day);
            };
            if ((((_arg1.op == 3)) && ((effect == null)))){
                addEffects();
            };
        }
        private function onTimer(_arg1:TimerEvent):void{
            var _local9:int;
            var _local2:Date = TimeManager.Instance.Now();
            _local2.hours = 23;
            _local2.minutes = 59;
            _local2.seconds = 59;
            var _local3:Number = (_local2.time - (enterTime * 1000));
            var _local4:Number = (TimeManager.Instance.Now().time - (guildTime * 1000));
            var _local5:Date = new Date((enterTime * 1000));
            var _local6:Date = new Date();
            var _local7:uint = ((((_local3 / 1000) / 60) / 60) / 24);
            var _local8:uint = ((((_local4 / 1000) / 60) / 60) / 24);
            if (_local7 >= 1){
                _local9 = 1;
                while (_local9 <= _local7) {
                    if (statusObj[_local9] == 0){
                        GameTargetSend.sendRequest((_local9 + 1), 1);
                    };
                    _local9++;
                };
            };
            if ((((_local7 >= 7)) && (!((_local8 == 0))))){
                if ((_local7 - _local8) >= 3){
                    if (statusObj[4] != 3){
                        GameTargetSend.sendRequest(5, 3);
                    };
                };
            };
        }
        private function updateAllBtnStatus(_arg1:Notification):void{
        }
        private function UpdateViewAfterHandleStatus():void{
            var _local1:int;
            while (_local1 < 10) {
                if (isInitView){
                    tv.updateBtnStatus(statusObj[_local1], _local1);
                };
                _local1++;
            };
        }
        private function addEffects():void{
            effect = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TargetEffect");
            effect.mouseEnabled = false;
            effect.mouseChildren = false;
            GameCommonData.GameInstance.GameUI.addChild(effect);
            effect.x = (heroTarget.x + 59);
            effect.y = (heroTarget.y + 30);
        }

    }
}//package GameUI.Modules.GameTarget.Mediator 
