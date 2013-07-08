//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Hint.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Hint.Mediator.UI.*;

    public class HintMediator extends Mediator {

        public static const NAME:String = "HintMediator";

        private const NUM:int = 4;

        private var textViews:Array;
        private var delayNum:int = 0;
        private var posX:int;
        private var posY:int;
        private var content:Sprite;

        public function HintMediator(){
            textViews = new Array();
            posX = 0;
            posY = 0;
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, HintEvents.RECEIVEINFO, EventList.RESIZE_STAGE]);
        }
        private function showOver(_arg1:Event):void{
            var _local2:HintView = (textViews.shift() as HintView);
            if (content.contains(_local2)){
                content.removeChild(_local2);
            };
            _local2.dispose();
            _local2.removeEventListener(Event.COMPLETE, showOver);
            _local2 = null;
        }
        private function posSort():void{
            var _local1:int;
            while (_local1 < textViews.length) {
                textViews[_local1].Pos = (textViews[0].Pos + _local1);
                _local1++;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:String;
            var _local3:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    if (content == null){
                        content = new Sprite();
                        content.x = (GameCommonData.GameInstance.ScreenWidth - 220);
                        content.y = (GameCommonData.GameInstance.ScreenHeight - 130);
                        GameCommonData.GameInstance.GameUI.addChild(content);
                    };
                    break;
                case HintEvents.RECEIVEINFO:
                    _local2 = (_arg1.getBody().info as String);
                    _local3 = (_arg1.getBody().color as uint);
                    setTextInfo(_local2, _local3);
                    sendNotification(ScreenMessageEvent.ADD_HISTORYINFO, _local2);
                    break;
                case EventList.RESIZE_STAGE:
                    content.x = (GameCommonData.GameInstance.ScreenWidth - 220);
                    content.y = (GameCommonData.GameInstance.ScreenHeight - 130);
                    changePos();
                    break;
            };
        }
        private function changePos():void{
            var _local1:int = textViews.length;
            while (_local1 > 0) {
                _local1--;
                if ((((textViews.length == 1)) || ((_local1 == (textViews.length - 1))))){
                    textViews[_local1].x = posX;
                    textViews[_local1].y = posY;
                    textViews[_local1].Pos = _local1;
                } else {
                    textViews[_local1].x = posX;
                    textViews[_local1].y = (textViews[(_local1 + 1)].y - textViews[_local1].height);
                    textViews[_local1].Pos = _local1;
                };
            };
        }
        private function setTextInfo(_arg1:String, _arg2:uint):void{
            var _local3:HintView;
            var _local4:int;
            var _local5:int;
            var _local6:HintView = new HintView(_arg1, _arg2);
            textViews.push(_local6);
            _local6.Pos = (textViews.length - 1);
            _local6.StartShow();
            _local6.addEventListener(Event.COMPLETE, showOver);
            content.addChild(_local6);
            if (textViews.length > NUM){
                _local3 = (textViews.shift() as HintView);
                if (content.contains(_local3)){
                    content.removeChild(_local3);
                };
                _local3.dispose();
                _local3.removeEventListener(Event.COMPLETE, showOver);
                _local3 = null;
            };
            changePos();
        }

    }
}//package GameUI.Modules.Hint.Mediator 
