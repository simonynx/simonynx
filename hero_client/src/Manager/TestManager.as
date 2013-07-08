//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.events.*;
    import flash.display.*;
    import GameUI.View.items.*;
    import OopsEngine.Utils.*;
    import OopsFramework.Utils.*;

    public class TestManager extends Sprite {

        public static var num:Number;
        public static var radius:Number;
        private static var _instance:TestManager;
        public static var finished:Boolean;
        public static var age:Number;

        private var timer:Timer;
        private var timer1:Timer;
        private var timer2:Timer;
        private var timer3:Timer;
        private var move:SmoothMove;
        private var bloodWidth:int = -1;
        private var pic:Sprite;
        private var blood:Sprite;

        public function TestManager(){
            timer = new Timer();
            timer1 = new Timer();
            timer2 = new Timer();
            timer3 = new Timer();
            super();
            if (_instance != null){
                throw (new Error("单体出错"));
            };
            addEventListener(Event.ENTER_FRAME, update);
            timer.Frequency = 24;
            timer1.Frequency = 2;
            timer2.Frequency = 5;
            timer3.DistanceTime = 5000;
        }
        public static function ResetShake():void{
            finished = false;
            age = 0;
            radius = 4;
            num = 0;
        }
        public static function getInstance():TestManager{
            if (_instance == null){
                _instance = new (TestManager)();
            };
            return (_instance);
        }

        private function moveComplete():void{
            if (pic){
                if (pic.parent){
                    pic.parent.removeChild(pic);
                    pic = null;
                };
            };
        }
        private function update(_arg1:Event):void{
            var _local2:DragItem;
            var _local3:int;
            if (pic){
                if (move){
                    move.Update(null);
                };
            };
            if (timer2.IsNextTime(GameCommonData.GameInstance.getGameTime())){
                if (GameCommonData.PackageList){
                    for each (_local2 in GameCommonData.PackageList) {
                        _local2.updateTime(GameCommonData.GameInstance.getGameTime());
                    };
                };
            };
            if (blood){
                if (bloodWidth != -1){
                    _local3 = (blood.width - bloodWidth);
                    blood.width = (blood.width - ((_local3 / Math.abs(_local3)) * 2));
                    if (Math.abs(_local3) < 3){
                        blood.width = bloodWidth;
                        blood = null;
                        bloodWidth = -1;
                    };
                };
            };
        }
        public function setBloodTest(_arg1:Sprite, _arg2:int):void{
            if (blood != _arg1){
                if (bloodWidth != -1){
                    blood.width = bloodWidth;
                };
                blood = null;
                bloodWidth = -1;
            };
            blood = _arg1;
            bloodWidth = _arg2;
        }

    }
}//package Manager 
