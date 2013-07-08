//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.MouseCursor {
    import flash.utils.*;

    public class RepeatRequest {

        private static var _instance:RepeatRequest;

        public var successFlags:Array;
        public var taskCount:uint;
        public var skillItemCount:uint;
        public var quickKeyCount:uint;
        public var cdCount:uint;
        private var processDic:Dictionary;
        public var bagItemCount:uint;
        public var petItemCount:uint;
        public var otherCount:uint;

        public function RepeatRequest(){
            successFlags = [false, false, false, false, false, false, false];
            super();
            processDic = new Dictionary();
        }
        public static function getInstance():RepeatRequest{
            if (_instance == null){
                _instance = new (RepeatRequest)();
            };
            return (_instance);
        }

        public function removeDelayProcessFun(_arg1:String):void{
            var _local2:* = this.processDic[_arg1];
            if (_local2 != null){
                clearTimeout(_local2);
            };
        }
        public function addDelayProcessFun(_arg1:String, _arg2:Function, _arg3:uint):void{
            var _local4:uint = setInterval(_arg2, _arg3);
            this.processDic[_arg1] = _local4;
        }
        public function clearAllInterval():void{
            var _local1:*;
            for each (_local1 in processDic) {
                clearTimeout(_local1);
            };
        }

    }
}//package GameUI.View.MouseCursor 
