//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.Components {
    import flash.display.*;

    public class UISprite extends Sprite {

        protected var iBackground:DisplayObject;

        public function UISprite(){
            this.name = "UISprite";
            this.mouseEnabled = false;
            var _local1:Shape = new Shape();
            _local1.graphics.lineStyle(0, 0, 0);
            _local1.graphics.beginFill(0, 0);
            _local1.graphics.drawRect(0, 0, 10, 10);
            _local1.graphics.endFill();
            iBackground = _local1;
            addChildAt(iBackground, 0);
        }
        override public function get width():Number{
            return (iBackground.width);
        }
        override public function set width(_arg1:Number):void{
            iBackground.width = _arg1;
        }
        override public function set height(_arg1:Number):void{
            iBackground.height = _arg1;
        }
        override public function get height():Number{
            return (iBackground.height);
        }

    }
}//package GameUI.View.Components 
