//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.event {
    import flash.events.*;
    import flash.geom.*;
    import GameUI.View.OhterUI.component.*;
    import GameUI.View.OhterUI.dragAndDrop.*;

    public class DragAndDropEvent extends Event {

        public static const DRAG_RECOGNIZED:String = "dragRecongnized";
        public static const DRAG_EXIT:String = "dragExit";
        public static const DRAG_ENTER:String = "dragEnter";
        public static const DRAG_OVERRING:String = "dragOverring";
        public static const DRAG_START:String = "dragStart";
        public static const DRAG_DROP:String = "dragDrop";

        private var relatedTargetComponent:FComponent;
        private var sourceData:SourceData;
        private var targetComponent:FComponent;
        private var mousePos:Point;
        private var dragInitiator:FComponent;

        public function DragAndDropEvent(_arg1:String, _arg2:FComponent, _arg3:SourceData, _arg4:Point, _arg5:FComponent=null, _arg6:FComponent=null){
            super(_arg1);
            this.dragInitiator = _arg2;
            this.sourceData = _arg3;
            this.mousePos = _arg4.clone();
            this.targetComponent = _arg5;
            this.relatedTargetComponent = _arg6;
        }
        public function getSourceData():SourceData{
            return (this.sourceData);
        }
        public function getTargetComponent():FComponent{
            return (this.targetComponent);
        }
        public function getDragInitiator():FComponent{
            return (this.dragInitiator);
        }
        public function getRelatedTargetComponent():FComponent{
            return (this.relatedTargetComponent);
        }
        override public function clone():Event{
            return (new DragAndDropEvent(type, this.dragInitiator, this.sourceData, this.mousePos, this.targetComponent));
        }
        public function getMousePosition():Point{
            return (this.mousePos);
        }

    }
}//package GameUI.View.OhterUI.event 
