//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;

    public class MinimizeItemCell extends Sprite {

        public var ClickCallBack:Function;
        public var oriWdith:Number;
        private var _info:IMChatWindow;
        public var oriPoint:Point;
        private var bgBtn:HLabelButton;
        public var oriHeight:Number;

        private function __clickHandler(_arg1:MouseEvent):void{
            if (ClickCallBack != null){
                ClickCallBack(this);
            };
        }
        public function set info(_arg1:IMChatWindow):void{
            _info = _arg1;
            if (((bgBtn) && (bgBtn.parent))){
                bgBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
                bgBtn.dispose();
            };
            bgBtn = new HLabelButton(0);
            bgBtn.label = info.info.roleName;
            bgBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            addChild(bgBtn);
        }
        public function startShine():void{
            this.filters = [];
            TweenMax.to(this, 1, {
                yoyo:true,
                repeat:6,
                colorMatrixFilter:{colorize:0xFF00}
            });
        }
        public function get info():IMChatWindow{
            return (_info);
        }
        public function stopShine():void{
            this.filters = [];
        }
        public function dispose():void{
            if (((bgBtn) && (bgBtn.parent))){
                bgBtn.removeEventListener(MouseEvent.CLICK, __clickHandler);
                bgBtn.dispose();
            };
            if (parent){
                parent.removeChild(this);
            };
            bgBtn = null;
            ClickCallBack = null;
            _info = null;
        }

    }
}//package GameUI.Modules.Friend.view.ui 
