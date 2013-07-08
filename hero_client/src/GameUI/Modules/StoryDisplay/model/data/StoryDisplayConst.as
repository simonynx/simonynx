//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.StoryDisplay.model.data {
    import flash.text.*;
    import GameUI.ConstData.*;
    import Utils.*;

    public class StoryDisplayConst {

        public static const TASK_ACCEPT:String = "taskAccept";
        public static const BAG_ITEM:String = "bagItem";
        public static const PLAYER_STOP:String = "playerStop";
        public static const COORD_COMPLETE:String = "coordComplete";
        public static const COORD_TYPE:String = "coordAccpte";
        public static const dialogTextFormat:TextFormat = UIUtils.getTextFormat(12, 0xFFFFFF, TextFieldAutoSize.LEFT);
        public static const nameTextFormat:TextFormat = UIUtils.getTextFormat(12, 0xFFFF, TextFieldAutoSize.LEFT);
        public static const TASK_COMMIT:String = "taskCommit";
        public static const TASK_COMPLETE:String = "taskComplete";

        public static var maxTaskId:int;
        public static var bagitem:InventoryItemInfo;
        public static var isInitView:Boolean;
        public static var minTaskId:int;

    }
}//package GameUI.Modules.StoryDisplay.model.data 
