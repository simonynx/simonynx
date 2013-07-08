//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.events.*;
    import flash.display.*;

    public class Main extends Sprite {

        private var info:Object;

        public function Main():void{
            if (stage){
                init();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, init);
            };
        }
        private function init(_arg1:Event=null):void{
            stage.stageFocusRect = false;
			trace("aasdasdsasdasdasd");
            removeEventListener(Event.ADDED_TO_STAGE, init);
            var _local2:StartInterface = new StartInterface();
            _local2.Run(this, info);
        }

    }
}//package 
