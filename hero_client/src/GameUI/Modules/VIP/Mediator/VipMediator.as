//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.VIP.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Maket.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.VIP.View.*;
    import Net.RequestSend.*;
    import GameUI.Modules.VIP.VO.*;

    public class VipMediator extends Mediator {

        public static var NAME:String = "VipMediator";

        private var itemArray:Array;
        private var times:String = "--:--";
        private var request:Boolean = true;
        private var intval:uint;
        private var isInitView:Boolean = false;
        private var viptime:Number;
        private var dataProxy:DataProxy;

        public function VipMediator(){
            itemArray = [];
            super(NAME);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:*;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.SHOW_VIP:
                    showVIP();
                    break;
                case EventList.CLOSE_VIP:
                    onClose();
                    break;
                case EventList.UPDATE_VIP_TIME:
                    updateTime((_arg1.getBody() as uint));
                    break;
                case EventList.UPDATE_VIP_ARRAY:
                    if (!isInitView){
                        return;
                    };
                    updateInfos((_arg1.getBody() as Array));
                    break;
                case MarketEvent.UPDATE_MARKETSALES:
                    if (dataProxy.VipIsOpen){
                        view.updatePlayerName(GameCommonData.Player.Role.Name);
                    };
                    break;
                case EventList.SHOW_VIP_WARN_VIEW:
                    _local2 = new VipWarnView();
                    _local2.x = int(((GameCommonData.GameInstance.ScreenWidth - _local2.width) / 2));
                    _local2.y = int(((GameCommonData.GameInstance.ScreenHeight - _local2.height) / 2));
                    GameCommonData.GameInstance.GameUI.addChild(_local2);
                    break;
            };
        }
        private function initView():void{
            var _local1:VipView;
            isInitView = true;
            _local1 = new VipView();
            _local1.x = ((GameCommonData.GameInstance.ScreenWidth - _local1.width) / 2);
            _local1.y = ((GameCommonData.GameInstance.ScreenHeight - _local1.height) / 2);
            _local1.closeCallBack = onClose;
            setViewComponent(_local1);
        }
        private function onClose():void{
            if (dataProxy.VipIsOpen){
                if (view.parent){
                    view.parent.removeChild(view);
                };
            };
            dataProxy.VipIsOpen = false;
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.CLOSE_VIP, EventList.SHOW_VIP, EventList.UPDATE_VIP_TIME, EventList.UPDATE_VIP_ARRAY, MarketEvent.UPDATE_MARKETSALES, EventList.SHOW_VIP_WARN_VIEW]);
        }
        private function updateTimeTime():void{
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local1:Number = (viptime - TimeManager.Instance.Now().time);
            if (_local1 < 0){
                if (isInitView){
                    view.updateWelcomeInfo(0);
                };
                if (GameCommonData.Scene){
                };
                clearInterval(intval);
            } else {
                _local2 = (_local1 / 1000);
                _local3 = ((_local1 / 1000) / 60);
                _local4 = (((_local1 / 1000) / 60) / 60);
                _local5 = ((((_local1 / 1000) / 60) / 60) / 24);
                _local6 = (_local4 - (_local5 * 24));
                _local7 = (_local3 - (_local4 * 60));
                times = "";
                if (_local5 > 0){
                    times = (times + (_local5 + LanguageMgr.GetTranslation("天")));
                };
                if (_local6 > 0){
                    times = (times + (_local6 + LanguageMgr.GetTranslation("小时")));
                };
                if (_local7 > 0){
                    times = (times + (_local7 + LanguageMgr.GetTranslation("分钟")));
                };
                if (((dataProxy) && (dataProxy.VipIsOpen))){
                    view.updateTime(times);
                    view.updateWelcomeInfo(GameCommonData.Player.Role.VIP);
                };
            };
        }
        private function get view():VipView{
            return ((viewComponent as VipView));
        }
        private function showVIP():void{
            if (GameCommonData.IsInCrossServer){
                return;
            };
            MarketSend.getShopItemList(MarketConstData.SHOPTYPE_SALES);
            if (!isInitView){
                initView();
            };
            if (request){
                VIPSend.sendRequest();
                request = false;
            };
            if (!dataProxy.VipIsOpen){
                GameCommonData.GameInstance.GameUI.addChild(view);
                dataProxy.VipIsOpen = true;
            };
            view.updateStatus();
            view.updateWelcomeInfo(GameCommonData.Player.Role.VIP);
            view.updatePlayerName(GameCommonData.Player.Role.Name);
            view.updateTime(times);
            view.updatePlayerInfos(itemArray);
        }
        private function updateTime(_arg1:uint):void{
            this.viptime = (_arg1 * 1000);
            if (_arg1 == 0){
                if (isInitView){
                    view.updateWelcomeInfo(0);
                };
            } else {
                clearInterval(intval);
                intval = setInterval(updateTimeTime, 1000);
                updateTimeTime();
            };
        }
        private function updateInfos(_arg1:Array):void{
            var _local3:Object;
            var _local4:VipItems;
            var _local5:Boolean;
            var _local6:int;
            var _local2:int;
            while (_local2 < _arg1.length) {
                _local3 = _arg1[_local2];
                _local4 = new VipItems();
                _local4.guid = _local3.guid;
                _local4.vipType = _local3.viptype;
                _local4.roleName = _local3.name;
                _local4.sex = _local3.sex;
                _local4.job = _local3.job;
                _local4.level = _local3.level;
                _local4.guildName = _local3.guild;
                _local4.init();
                _local5 = false;
                _local6 = 0;
                while (_local6 < itemArray.length) {
                    if (itemArray[_local6].guid == _local4.guid){
                        itemArray[_local6] = _local4;
                        _local5 = true;
                    };
                    _local6++;
                };
                if (!_local5){
                    itemArray.push(_local4);
                };
                _local2++;
            };
            itemArray.sortOn(["vipType", "level"], [Array.NUMERIC, Array.NUMERIC]);
            itemArray.reverse();
            if (isInitView){
                view.updatePlayerInfos(itemArray);
            };
        }

    }
}//package GameUI.Modules.VIP.Mediator 
