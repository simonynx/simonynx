//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Mail.Data {
    import flash.events.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class MailConstData {

        public static const MAX_EMPTY_GRIDs:int = 7;
        public static const MAX_MAIL_ITEMS:int = 7;

        public static var noReadNum:int;
        public static var curMailIndex:int = -1;
        public static var SelectIndex:int = 0;
        public static var curItemIndex:int = -1;
        public static var mailSelfList:Array = new Array();
        public static var lastMailIndex:int = -1;
        public static var hasGetData:Boolean;
        public static var curPage:uint = 1;
        public static var visibleList:Array = new Array();
        public static var mailList:Array = new Array();
        public static var willtakeIndex:int = 0;
        public static var isSelectAll:Boolean;

        public static function onClickLink(_arg1:TextEvent):void{
            var _local2:Array = _arg1.text.split("_");
            switch (uint(_local2[0])){
                case 10001:
                    UIFacade.GetInstance().sendNotification(EventList.SHOWMARKETVIEW_TOGGLE, uint(_local2[1]));
                    break;
                case 10002:
                    UIFacade.GetInstance().sendNotification(EventList.SHOW_ACTIVITY_WELFARE, uint(_local2[1]));
                    break;
                case 10003:
                    UIFacade.GetInstance().sendNotification(EventList.TOGGLE_ACTIVITY, uint(_local2[1]));
                    break;
            };
        }

    }
}//package GameUI.Modules.Mail.Data 
