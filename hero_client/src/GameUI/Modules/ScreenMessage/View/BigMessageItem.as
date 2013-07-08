//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.View {
    import flash.display.*;
    import flash.text.*;
    import com.greensock.*;
    import flash.filters.*;

    public class BigMessageItem extends Sprite {

        private var msg:String;
        private var tf:TextField;

        public function BigMessageItem(_arg1:String){
            msg = _arg1;
            init();
        }
        private static function myEaseOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number=6):Number{
            _arg1 = ((_arg1 / _arg4) - 1);
            return (((_arg3 * (((_arg1 * _arg1) * (((_arg5 + 1) * _arg1) + _arg5)) + 1)) + _arg2));
        }

        public function init():void{
            var _local1:TextFormat = new TextFormat();
            _local1.size = 18;
            _local1.font = LanguageMgr.DEFAULT_FONT;
            _local1.bold = true;
            _local1.color = 0xFFFF00;
            tf = new TextField();
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.defaultTextFormat = _local1;
            tf.cacheAsBitmap = true;
            var _local2:GlowFilter = new GlowFilter(0, 1, 2, 2, 16);
            var _local3:GlowFilter = new GlowFilter(0xFFFFFF, 0.5, 4, 4, 16);
            var _local4:Array = new Array();
            _local4.push(_local2);
            _local4.push(_local3);
            tf.filters = _local4;
            tf.mouseEnabled = false;
            tf.htmlText = msg;
            this.addChild(tf);
            this.mouseEnabled = false;
        }
        private function onComplete():void{
            TweenLite.to(this, 6, {
                alpha:0,
                onComplete:onComplete1
            });
        }
        private function onComplete1():void{
            if (this.parent){
                this.parent.removeChild(this);
            };
        }
        public function Jump():void{
            this.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - (tf.textWidth / 2));
            this.y = 210;
            GameCommonData.GameInstance.TooltipLayer.addChild(this);
            TweenLite.to(this, 1, {
                y:130,
                ease:myEaseOut,
                onComplete:onComplete
            });
        }

    }
}//package GameUI.Modules.ScreenMessage.View 
