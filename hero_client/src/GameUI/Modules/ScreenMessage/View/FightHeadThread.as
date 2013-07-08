//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.View {
    import flash.events.*;
    import OopsFramework.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;

    public class FightHeadThread {

        private static var _instance:FightHeadThread;

        private var _htDataArr:Array;
        private var _td:Timer;

        public function FightHeadThread(){
            this._htDataArr = [];
            this._td = new Timer(300);
            this._td.addEventListener(TimerEvent.TIMER, timerHandler);
            if (_instance){
                throw (new Error("单体"));
            };
        }
        public static function get Instance():FightHeadThread{
            if (_instance == null){
                _instance = new (FightHeadThread)();
            };
            return (_instance);
        }

        private function timerHandler(_arg1:TimerEvent):void{
            var _local2:Array;
            if (this._htDataArr.length > 0){
                _local2 = this._htDataArr.shift();
                HandlerHelper.execute(this.showAttackEffect, _local2);
            } else {
                this._td.stop();
            };
        }
        private function showAttackEffect(_arg1:GameElementAnimal, _arg2:String, _arg3:Number=0, _arg4:Boolean=false, _arg5:String="", _arg6:uint=0, _arg7:uint=0):void{
            _arg1.showAttackFace(_arg2, _arg3, _arg5, _arg6, _arg7);
        }
        public function push(_arg1:GameElementAnimal, _arg2:String, _arg3:Number, _arg4:Boolean=false, _arg5:Boolean=false, _arg6:String="", _arg7:uint=0, _arg8:uint=0):void{
            if (_arg5){
                this.showAttackEffect(_arg1, _arg2, _arg3, _arg4, _arg6, _arg7, _arg8);
            } else {
                this._htDataArr.push([_arg1, _arg2, _arg3, _arg4, _arg6, _arg7, _arg8]);
                if (!this._td.running){
                    this._td.start();
                };
            };
        }

    }
}//package GameUI.Modules.ScreenMessage.View 
