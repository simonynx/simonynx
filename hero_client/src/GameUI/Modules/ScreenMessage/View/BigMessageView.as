//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.View {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;

    public class BigMessageView extends Sprite {

        private static var _instance:BigMessageView;

        private var timer:Timer;
        private var posArr:Array;
        private var list:Array;

        public function BigMessageView(){
            init();
            super();
        }
        public static function get instance():BigMessageView{
            if (_instance == null){
                _instance = new (BigMessageView)();
            };
            return (_instance);
        }

        private function init():void{
            list = [];
            timer = new Timer(500);
            timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
        }
        public function addMsgItem(_arg1:String):void{
            var _local2:BigMessageItem = new BigMessageItem(_arg1);
            list.push(_local2);
            if (!timer.running){
                timer.start();
                if (list.length == 1){
                    onTimerHandler(null);
                };
            };
        }
        private function onTimerHandler(_arg1:TimerEvent):void{
            var _local2:BigMessageItem;
            if (list.length > 0){
                _local2 = list.shift();
                _local2.Jump();
            } else {
                timer.stop();
            };
        }

    }
}//package GameUI.Modules.ScreenMessage.View 
