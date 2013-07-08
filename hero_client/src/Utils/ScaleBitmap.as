//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.display.*;
    import flash.geom.*;

    public class ScaleBitmap extends Bitmap {

        protected var _scale9Grid:Rectangle = null;
        protected var _originalBitmap:BitmapData;

        public function ScaleBitmap(_arg1:BitmapData=null, _arg2:String="auto", _arg3:Boolean=false){
            super(_arg1, _arg2, _arg3);
            _originalBitmap = _arg1.clone();
        }
        public function getOriginalBitmapData():BitmapData{
            return (_originalBitmap);
        }
        private function validGrid(_arg1:Rectangle):Boolean{
            return ((((_arg1.right <= _originalBitmap.width)) && ((_arg1.bottom <= _originalBitmap.height))));
        }
        public function setSize(_arg1:Number, _arg2:Number):void{
            if (_scale9Grid == null){
                super.width = _arg1;
                super.height = _arg2;
            } else {
                _arg1 = Math.max(_arg1, (_originalBitmap.width - _scale9Grid.width));
                _arg2 = Math.max(_arg2, (_originalBitmap.height - _scale9Grid.height));
                resizeBitmap(_arg1, _arg2);
            };
        }
        private function assignBitmapData(_arg1:BitmapData):void{
            super.bitmapData.dispose();
            super.bitmapData = _arg1;
        }
        override public function set scale9Grid(_arg1:Rectangle):void{
            var _local2:Number;
            var _local3:Number;
            if ((((((_scale9Grid == null)) && (!((_arg1 == null))))) || (((!((_scale9Grid == null))) && (!(_scale9Grid.equals(_arg1))))))){
                if (_arg1 == null){
                    _local2 = width;
                    _local3 = height;
                    _scale9Grid = null;
                    assignBitmapData(_originalBitmap.clone());
                    setSize(_local2, _local3);
                } else {
                    if (!validGrid(_arg1)){
                        throw (new Error("#001 - The _scale9Grid does not match the original BitmapData"));
                    };
                    _scale9Grid = _arg1.clone();
                    resizeBitmap(width, height);
                    scaleX = 1;
                    scaleY = 1;
                };
            };
        }
        override public function set width(_arg1:Number):void{
            if (_arg1 != width){
                setSize(_arg1, height);
            };
        }
        override public function set height(_arg1:Number):void{
            if (_arg1 != height){
                setSize(width, _arg1);
            };
        }
        override public function set bitmapData(_arg1:BitmapData):void{
            _originalBitmap = _arg1.clone();
            if (_scale9Grid != null){
                if (!validGrid(_scale9Grid)){
                    _scale9Grid = null;
                };
                setSize(_arg1.width, _arg1.height);
            } else {
                assignBitmapData(_originalBitmap.clone());
            };
        }
        override public function get scale9Grid():Rectangle{
            return (_scale9Grid);
        }
        protected function resizeBitmap(_arg1:Number, _arg2:Number):void{
            var _local8:Rectangle;
            var _local9:Rectangle;
            var _local12:int;
            var _local3:BitmapData = new BitmapData(_arg1, _arg2, true, 0);
            var _local4:Array = [0, _scale9Grid.top, _scale9Grid.bottom, _originalBitmap.height];
            var _local5:Array = [0, _scale9Grid.left, _scale9Grid.right, _originalBitmap.width];
            var _local6:Array = [0, _scale9Grid.top, (_arg2 - (_originalBitmap.height - _scale9Grid.bottom)), _arg2];
            var _local7:Array = [0, _scale9Grid.left, (_arg1 - (_originalBitmap.width - _scale9Grid.right)), _arg1];
            var _local10:Matrix = new Matrix();
            var _local11:int;
            while (_local11 < 3) {
                _local12 = 0;
                while (_local12 < 3) {
                    _local8 = new Rectangle(_local5[_local11], _local4[_local12], (_local5[(_local11 + 1)] - _local5[_local11]), (_local4[(_local12 + 1)] - _local4[_local12]));
                    _local9 = new Rectangle(_local7[_local11], _local6[_local12], (_local7[(_local11 + 1)] - _local7[_local11]), (_local6[(_local12 + 1)] - _local6[_local12]));
                    _local10.identity();
                    _local10.a = (_local9.width / _local8.width);
                    _local10.d = (_local9.height / _local8.height);
                    _local10.tx = (_local9.x - (_local8.x * _local10.a));
                    _local10.ty = (_local9.y - (_local8.y * _local10.d));
                    _local3.draw(_originalBitmap, _local10, null, null, _local9, smoothing);
                    _local12++;
                };
                _local11++;
            };
            assignBitmapData(_local3);
        }

    }
}//package Utils 
