//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.Accordion {
    import flash.events.*;
    import flash.display.*;

    public interface IAccordionMainCell extends IEventDispatcher {

        function set title(_arg1:String):void;
        function set y(_arg1:Number):void;
        function set x(_arg1:Number):void;
        function get Tips():String;
        function set param(_arg1:Object):void;
        function addChild(_arg1:DisplayObject):DisplayObject;
        function dispose():void;

    }
}//package GameUI.View.Accordion 
