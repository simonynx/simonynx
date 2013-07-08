//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.component {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.View.OhterUI.event.*;
    import GameUI.View.OhterUI.dragAndDrop.*;

    public class FComponent extends Sprite {

        private var dragAcceptableInitiator:Dictionary;
        private var dropTrigger:Boolean;
        private var dragAcceptableInitiatorAppraiser:Function;

        public function set DropTrigger(_arg1:Boolean):void{
            this.dropTrigger = _arg1;
        }
        public function fireDragDropEvent(_arg1:FComponent, _arg2:SourceData, _arg3:Point):void{
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_DROP, _arg1, _arg2, _arg3, this));
        }
        public function fireDragExitEvent(_arg1:FComponent, _arg2:SourceData, _arg3:Point, _arg4:FComponent):void{
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_EXIT, _arg1, _arg2, _arg3, this, _arg4));
        }
        public function get DropTrigger():Boolean{
            return (this.dropTrigger);
        }
        public function fireDragEnterEvent(_arg1:FComponent, _arg2:SourceData, _arg3:Point, _arg4:FComponent):void{
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_ENTER, _arg1, _arg2, _arg3, this, _arg4));
        }
        public function isDragAcceptableInitiator(_arg1:FComponent):Boolean{
            if (this.dragAcceptableInitiator != null){
                return ((this.dragAcceptableInitiator[_arg1] == true));
            };
            if (this.dragAcceptableInitiatorAppraiser != null){
                return (this.dragAcceptableInitiatorAppraiser(_arg1));
            };
            return (false);
        }
        public function setDragAcceptableInitiatorAppraiser(_arg1:Function):void{
            this.dragAcceptableInitiatorAppraiser = _arg1;
        }
        public function fireDragOverringEvent(_arg1:FComponent, _arg2:SourceData, _arg3:Point):void{
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_OVERRING, _arg1, _arg2, _arg3, this));
        }
        public function removeDragAcceptableInitiator(_arg1:FComponent):void{
            if (this.dragAcceptableInitiator != null){
                this.dragAcceptableInitiator[_arg1] = undefined;
                delete this.dragAcceptableInitiator[_arg1];
            };
        }
        public function getMousePosition():Point{
            return (new Point(mouseX, mouseY));
        }
        private function fireDragRecognizedEvent(_arg1:FComponent):void{
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_RECOGNIZED, this, null, new Point(stage.mouseX, stage.mouseY)));
        }
        public function addDragAcceptableInitiator(_arg1:FComponent):void{
            if (this.dragAcceptableInitiator == null){
                this.dragAcceptableInitiator = new Dictionary(true);
            };
            this.dragAcceptableInitiator[_arg1] = true;
        }

    }
}//package GameUI.View.OhterUI.component 
