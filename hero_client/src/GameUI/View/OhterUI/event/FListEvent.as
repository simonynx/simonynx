//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.event {
    import flash.events.*;
    import GameUI.View.OhterUI.list.*;

    public class FListEvent extends Event {

        public static const CLICK_CELL:String = "list.click.cell";

        private var _item:FListCellRenderer;

        public function FListEvent(_arg1:String, _arg2:FListCellRenderer, _arg3:Boolean=false, _arg4:Boolean=false){
            this._item = _arg2;
            super(_arg1, _arg3, _arg4);
        }
        public function get item():FListCellRenderer{
            return (this._item);
        }
        public function set item(_arg1:FListCellRenderer):void{
            this._item = _arg1;
        }

    }
}//package GameUI.View.OhterUI.event 
