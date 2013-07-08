//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View {
    import GameUI.UICore.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Hint.Events.*;

    public class MessageTip {

        public static function popup(_arg1:String):void{
            UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _arg1);
        }
        public static function show(_arg1:String="", _arg2:uint=0xFFFF00):void{
            UIFacade.GetInstance().sendNotification(HintEvents.RECEIVEINFO, {
                info:_arg1,
                color:_arg2
            });
        }
        public static function bugle(_arg1:String, _arg2:uint=1):void{
            UIFacade.GetInstance().sendNotification(ScreenMessageEvent.SHOW_BUGLE, {
                msg:_arg1,
                type:_arg2
            });
        }

    }
}//package GameUI.View 
