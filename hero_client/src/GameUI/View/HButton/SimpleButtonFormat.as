//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HButton {
    import flash.text.*;
    import flash.filters.*;

    public class SimpleButtonFormat implements IButtonFormat {

        private var lightingFilter:BitmapFilter;
        private var hitFormat:TextFormat;
        private var _textFilter:Array;
        private var myColorMatrix_filter:ColorMatrixFilter;
        private var upFormat:TextFormat;
        private var overFormat:TextFormat;

        public function SimpleButtonFormat():void{
            init();
        }
        private function setUpLintingFilter():void{
            var _local1:* = new Array();
            _local1 = _local1.concat([1, 0, 0, 0, 25]);
            _local1 = _local1.concat([0, 1, 0, 0, 25]);
            _local1 = _local1.concat([0, 0, 1, 0, 25]);
            _local1 = _local1.concat([0, 0, 0, 1, 0]);
            lightingFilter = new ColorMatrixFilter(_local1);
        }
        public function setDownFormat(_arg1:HBaseButton):void{
            if (_arg1.textField){
                _arg1.textField.defaultTextFormat = overFormat;
            };
            _arg1.container.x = 1;
            _arg1.container.y = 1;
            _arg1.filters = [lightingFilter];
        }
        public function setUpFormat(_arg1:HBaseButton):void{
            if (_arg1.textField){
                _arg1.textField.defaultTextFormat = overFormat;
            };
            _arg1.container.x = 0;
            _arg1.container.y = 0;
        }
        public function setEnable(_arg1:HBaseButton):void{
            _arg1.filters = null;
        }
        private function init():void{
            overFormat = new TextFormat(null, 13, 16777113, false);
            overFormat.letterSpacing = 2;
            hitFormat = new TextFormat(null, 13, 16777113, false);
            upFormat = new TextFormat(null, 13, 16777113, false);
            setUpGrayFilter();
            setUpLintingFilter();
        }
        public function setOutFormat(_arg1:HBaseButton):void{
            if (_arg1.textField){
                _arg1.textField.defaultTextFormat = overFormat;
            };
            _arg1.container.x = 0;
            _arg1.container.y = 0;
            _arg1.filters = null;
        }
        public function dispose():void{
            overFormat = null;
            hitFormat = null;
            upFormat = null;
            myColorMatrix_filter = null;
            lightingFilter = null;
            _textFilter = null;
        }
        public function setOverFormat(_arg1:HBaseButton):void{
            if (_arg1.textField){
                _arg1.textField.defaultTextFormat = overFormat;
            };
            _arg1.filters = [lightingFilter];
        }
        private function setUpGrayFilter():void{
            var _local1:Array;
            _local1 = [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0];
            myColorMatrix_filter = new ColorMatrixFilter(_local1);
        }
        public function setNotEnable(_arg1:HBaseButton):void{
            _arg1.filters = [myColorMatrix_filter];
        }

    }
}//package GameUI.View.HButton 
