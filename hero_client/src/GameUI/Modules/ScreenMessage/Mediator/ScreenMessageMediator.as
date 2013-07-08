//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.Mediator {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Chat.Data.*;
    import com.greensock.*;
    import GameUI.Modules.ScreenMessage.View.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.ScreenMessage.Date.*;

    public class ScreenMessageMediator extends Mediator {

        public static const NAME:String = "ScreenMassageMediator";

        private var dataProxy:DataProxy;
        private var bloodView:MovieClip;
        private var bloodMC:MovieClip;
        private var bloodViewLoader:LoadSwfTool;
        private var flashTime:int = 0;
        private var flashCount:int = 0;

        public function ScreenMessageMediator(){
            super(NAME);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:int;
            var _local4:String;
            var _local5:ChatReceiveMsg;
            var _local6:GameElementAnimal;
            var _local7:*;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    init();
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case ScreenMessageEvent.SHOW_BUGLE:
                    _local2 = _arg1.getBody();
                    _local3 = _local2.type;
                    switch (_local3){
                        case 1:
                            BugleView.instance.sysNotice(_local2.msg);
                            break;
                        case 2:
                            BugleView.instance.fBugle(_local2.msg);
                            break;
                    };
                    break;
                case ScreenMessageEvent.ADD_HISTORYINFO:
                    _local4 = (_arg1.getBody() as String);
                    AllInfoMsgView.Instance.addItem(_local4);
                    break;
                case EventList.RESIZE_STAGE:
                    BugleView.instance.setPos();
                    AllInfoMsgView.Instance.setPos();
                    MsgButton.Instance.setPos();
                    if (bloodView){
                        bloodView.width = GameCommonData.GameInstance.ScreenWidth;
                        bloodView.height = GameCommonData.GameInstance.ScreenHeight;
                    };
                    break;
                case ScreenMessageEvent.OPEN_MESSAGE:
                    if (!dataProxy.AllInfoMsgIsOpen){
                        AllInfoMsgView.Instance.show();
                        dataProxy.AllInfoMsgIsOpen = true;
                    };
                    break;
                case ScreenMessageEvent.CLOSE_MESSAGE:
                    if (dataProxy.AllInfoMsgIsOpen){
                        AllInfoMsgView.Instance.hide();
                    };
                    break;
                case ScreenMessageEvent.ADD_BIGMESSAGE:
                    _local4 = (_arg1.getBody() as String);
                    BigMessageView.instance.addMsgItem(_local4);
                    break;
                case ScreenMessageEvent.SHOW_DIALOGUE:
                    _local5 = (_arg1.getBody() as ChatReceiveMsg);
                    _local5.content = filterItem(_local5);
                    _local5.content = filterItem(_local5);
                    if (_local5.content == ""){
                        break;
                    };
                    _local6 = GameCommonData.SameSecnePlayerList[_local5.sendId];
                    if (_local6 != null){
                        _local6.showDialogue(_local5.content);
                    } else {
                        if (GameCommonData.Player.Role.Id == _local5.sendId){
                            GameCommonData.Player.showDialogue(_local5.content);
                        };
                    };
                    break;
                case ScreenMessageEvent.SHOW_BLOOD:
                    if (((MapManager.IsInArena()) || (MapManager.IsInGVG()))){
                        return;
                    };
                    _local7 = getTimer();
                    if ((_local7 - flashTime) > 3000){
                        if ((_local7 - flashTime) > 20000){
                            flashCount = 0;
                        };
                        if (flashCount < 4){
                            if (bloodView == null){
                                if (bloodViewLoader == null){
                                    bloodViewLoader = new LoadSwfTool("Resources/Effect/redscreen.swf", false);
                                    bloodViewLoader.sendShow = LoadCompleteHandler;
                                    break;
                                };
                                if (bloodMC != null){
                                    bloodView = bloodMC;
                                } else {
                                    break;
                                };
                            };
                            flashTime = _local7;
                            bloodView.alpha = 0;
                            bloodView.width = GameCommonData.GameInstance.ScreenWidth;
                            bloodView.height = GameCommonData.GameInstance.ScreenHeight;
                            GameCommonData.GameInstance.TooltipLayer.addChild(bloodView);
                            TweenLite.to(bloodView, 1, {
                                alpha:0.4,
                                onComplete:bloodViewComplete
                            });
                            flashCount++;
                        };
                    };
                    break;
            };
        }
        private function LoadCompleteHandler(_arg1:MovieClip=null):void{
            bloodView = _arg1;
            bloodMC = _arg1;
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, ScreenMessageEvent.SHOW_BUGLE, EventList.RESIZE_STAGE, ScreenMessageEvent.ADD_HISTORYINFO, ScreenMessageEvent.OPEN_MESSAGE, ScreenMessageEvent.CLOSE_MESSAGE, ScreenMessageEvent.ADD_BIGMESSAGE, ScreenMessageEvent.SHOW_DIALOGUE, ScreenMessageEvent.SHOW_BLOOD]);
        }
        private function filterItem(_arg1:ChatReceiveMsg):String{
            var _local4:uint;
            var _local5:String;
            var _local6:Array;
            var _local2:String = _arg1.content;
            var _local3:int = _local2.indexOf("<1_");
            if (_local3 != -1){
                _local4 = _local2.indexOf(">", _local3);
                _local5 = _local2.substring(_local3, _local4);
                _local6 = _local5.split("_");
                _local2 = ((_local2.substring(0, _local3) + _local6[1]) + _local2.substring((_local4 + 1), _local2.length));
            };
            return (_local2);
        }
        private function init():void{
            MsgButton.Instance.show();
        }
        private function bloodViewComplete():void{
            if (bloodView == null){
                return;
            };
            TweenLite.to(bloodView, 1, {
                alpha:0,
                onComplete:bloodViewComplete
            });
            if (((bloodView.parent) && ((bloodView.alpha == 0)))){
                bloodView.parent.removeChild(bloodView);
                bloodView = null;
            };
        }

    }
}//package GameUI.Modules.ScreenMessage.Mediator 
