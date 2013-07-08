//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HButton {
    import flash.display.*;
    import flash.geom.*;
    import Utils.*;

    public class HLabelButton extends HBaseButton {

        private var _bgBitmap:Bitmap;
        private var _bgBitmapData:BitmapData;

        public function HLabelButton(_arg1:int=1){
            creatBg(_arg1);
            super(_bgBitmap, "y");
        }
        override public function set label(_arg1:String):void{
            super.label = _arg1;
            width = (textField.width + 10);
        }
        private function creatBg(_arg1:int):void{
            if (_arg1 == 1){
                _bgBitmapData = UILib.GetClassByBitmapData("shooter.view.frame.asset.LabelButtonAccect");
            } else {
                if ((((_arg1 == 2)) || ((_arg1 == 0)))){
                    _bgBitmapData = UILib.GetClassByBitmapData("CommonButton2");
                } else {
                    if (_arg1 == 3){
                        _bgBitmapData = UILib.GetClassByBitmapData("CommonButton3");
                    } else {
                        if (_arg1 == 4){
                            _bgBitmapData = UILib.GetClassByBitmapData("CommonButton4");
                        } else {
                            if (_arg1 == 5){
                                _bgBitmapData = UILib.GetClassByBitmapData("CommonButton5");
                            };
                        };
                    };
                };
            };
            var _local2:Rectangle = new Rectangle();
            _bgBitmap = new ScaleBitmap(_bgBitmapData, "auto", true);
            _local2.left = 7;
            _local2.right = 16;
            _local2.top = 5;
            _local2.bottom = 18;
            _bgBitmap.scale9Grid = _local2;
        }
        override public function dispose():void{
            super.dispose();
            _bgBitmapData = null;
        }

    }
}//package GameUI.View.HButton 
