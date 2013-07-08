//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.model.vo {

    public class MessageStruct {

        public var msg:String;
        public var sendId:uint;
        public var receivePersonName:String;
        public var isleave:Boolean = false;
        public var isOnline:uint;
        public var face:uint;
        public var feel:String;
        public var sendPersonName:String = "test";
        public var isFriend:uint;
        public var style:String;
        public var sendTime:Number;
        public var action:uint;

        public function toString():void{
            var _local1:*;
            for (_local1 in this) {
                trace(((_local1 + ":") + this[_local1]));
            };
        }

    }
}//package GameUI.Modules.Friend.model.vo 
