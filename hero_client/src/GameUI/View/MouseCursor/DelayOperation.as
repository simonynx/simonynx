//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.MouseCursor {
    import flash.utils.*;

    public class DelayOperation {

        private static var _instance:DelayOperation;

        public var lockDic:Dictionary;
        private var isNpcTalkLockId:uint;
        public var isNpcTalkLock:Boolean;

        public static function getInstance():DelayOperation{
            if (_instance == null){
                _instance = new (DelayOperation)();
            };
            return (_instance);
        }

        public function unLockNpcTalk():void{
            clearTimeout(isNpcTalkLockId);
            isNpcTalkLock = false;
        }
        public function lockNpcTalk():void{
            isNpcTalkLock = true;
            isNpcTalkLockId = setTimeout(unLockNpcTalk, (3 * 1000));
        }
        public function addDelayItem(_arg1, _arg2:uint):void{
        }

    }
}//package GameUI.View.MouseCursor 
