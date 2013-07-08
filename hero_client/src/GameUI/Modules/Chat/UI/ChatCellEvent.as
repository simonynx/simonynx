//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.UI {
    import flash.events.*;

    public class ChatCellEvent extends Event {

        public static const CHAT_CELLLINK_CLICK:String = "chat_cellLink_click";

        public var data:Object;
        public var sendId:uint;

        public function ChatCellEvent(_arg1:String, _arg2:Object, _arg3:uint, _arg4:Boolean=false, _arg5:Boolean=false){
            super(_arg1, _arg4, _arg5);
            this.data = _arg2;
            this.sendId = _arg3;
        }
    }
}//package GameUI.Modules.Chat.UI 
