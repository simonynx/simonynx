//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;

	/**
	 *有交互的PNG显示对象 
	 * @author wengliqiang
	 * 
	 */	
    public class InteractivePNG extends Sprite {

        private var boo:Boolean;
        protected var _threshold:uint = 128;
        protected var _basePoint:Point;
        private var _isAct:Boolean;
        protected var _buttonModeCache:Number = NaN;
        protected var _mousePoint:Point;
        protected var _transparentMode:Boolean = false;
        private var _isDispose:Boolean;
        protected var _bitmapHit:Boolean = false;
        protected var _bitmapForHitDetection:Bitmap;
        protected var _interactivePngActive:Boolean = false;

        public function InteractivePNG(_arg1:Boolean=false):void{
            _basePoint = new Point();
            _mousePoint = new Point();
            enableInteractivePNG();
            _isAct = _arg1;
        }
        override public function set hitArea(_arg1:Sprite):void{
            if (((!((_arg1 == null))) && ((super.hitArea == null)))){
                disableInteractivePNG();
            } else {
                if ((((_arg1 == null)) && (!((super.hitArea == null))))){
                    enableInteractivePNG();
                };
            };
            super.hitArea = _arg1;
        }
        public function get interactivePngActive():Boolean{
            return (_interactivePngActive);
        }
        public function get alphaTolerance():uint{
            return (_threshold);
        }
        protected function removeFilters():void{
        }
        public function enableInteractivePNG():void{
            disableInteractivePNG();
            if (hitArea != null){
                return;
            };
            activateMouseTrap();
            _interactivePngActive = true;
        }
        protected function captureMouseEvent(_arg1:Event):void{
            if (!_transparentMode){
                if ((((_arg1.type == MouseEvent.MOUSE_OVER)) || ((_arg1.type == MouseEvent.ROLL_OVER)))){
                    setButtonModeCache();
                    _transparentMode = true;
                    super.mouseEnabled = false;
                    addEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds, false, 10000, true);
                    trackMouseWhileInBounds();
                };
            };
            if (!_bitmapHit){
                _arg1.stopImmediatePropagation();
            };
        }
        public function set alphaTolerance(_arg1:uint):void{
            _threshold = Math.min(0xFF, _arg1);
        }
        protected function trackMouseWhileInBounds(_arg1:Event=null):void{
            boo = bitmapHitTest();
            if (_isDispose){
                return;
            };
            if (boo != _bitmapHit){
                _bitmapHit = !(_bitmapHit);
                if (_bitmapHit){
                    deactivateMouseTrap();
                    setButtonModeCache(true, true);
                    _transparentMode = false;
                    super.mouseEnabled = true;
                } else {
                    _transparentMode = true;
                    super.mouseEnabled = false;
                };
            };
            var _local2:Point = _bitmapForHitDetection.localToGlobal(_mousePoint);
            if (hitTestPoint(_local2.x, _local2.y) == false){
                endFrame();
            };
        }
        private function endFrame():void{
            removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
            _transparentMode = false;
            setButtonModeCache(true);
            super.mouseEnabled = true;
            activateMouseTrap();
            removeFilters();
        }
        private function disPoseHandler():void{
            removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
            _transparentMode = false;
            setButtonModeCache();
            super.mouseEnabled = false;
            deactivateMouseTrap();
            removeFilters();
        }
        protected function bitmapHitTest():Boolean{
            if (!_isAct){
                if (_bitmapForHitDetection == null){
                    drawBitmapHitArea();
                };
            } else {
                drawBitmapHitArea();
            };
            if (_bitmapForHitDetection == null){
                _isDispose = true;
                return (false);
            };
            _mousePoint.x = _bitmapForHitDetection.mouseX;
            _mousePoint.y = _bitmapForHitDetection.mouseY;
            return (_bitmapForHitDetection.bitmapData.hitTest(_basePoint, _threshold, _mousePoint));
        }
        public function disableInteractivePNG():void{
            deactivateMouseTrap();
            removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
            try {
                removeChild(_bitmapForHitDetection);
            } catch(e:Error) {
            };
            (_bitmapForHitDetection == null);
            super.mouseEnabled = true;
            _transparentMode = false;
            setButtonModeCache(true);
            _bitmapHit = false;
            _interactivePngActive = false;
        }
        public function drawBitmapHitArea(_arg1:Event=null):void{
            var _local2 = !((_bitmapForHitDetection == null));
            if (_local2){
                if (contains(_bitmapForHitDetection)){
                    removeChild(_bitmapForHitDetection);
                };
                _bitmapForHitDetection.bitmapData.dispose();
                _bitmapForHitDetection = null;
            };
            var _local3:Rectangle = getBounds(this);
            var _local4:Number = _local3.left;
            var _local5:Number = _local3.top;
            if ((((_local3.width == 0)) || ((_local3.height == 0)))){
                disPoseHandler();
                return;
            };
            var _local6:BitmapData = new BitmapData(_local3.width, _local3.height, true, 0);
            _bitmapForHitDetection = new Bitmap(_local6);
            _bitmapForHitDetection.name = "interactivePngHitMap";
            _bitmapForHitDetection.visible = false;
            var _local7:Matrix = new Matrix();
            _local7.translate(-(_local4), -(_local5));
            _local6.draw(this, _local7);
            addChildAt(_bitmapForHitDetection, 0);
            _bitmapForHitDetection.x = _local4;
            _bitmapForHitDetection.y = _local5;
        }
        protected function deactivateMouseTrap():void{
            removeEventListener(MouseEvent.ROLL_OVER, captureMouseEvent);
            removeEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent);
            removeEventListener(MouseEvent.ROLL_OUT, captureMouseEvent);
            removeEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent);
            removeEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent);
        }
        override public function set mouseEnabled(_arg1:Boolean):void{
            if (isNaN(_buttonModeCache) == false){
                disableInteractivePNG();
            };
            super.mouseEnabled = _arg1;
        }
        protected function setButtonModeCache(_arg1:Boolean=false, _arg2:Boolean=false):void{
            if (_arg1){
                if (_buttonModeCache == 1){
                    buttonMode = true;
                };
                if (!_arg2){
                    _buttonModeCache = NaN;
                };
                return;
            };
            _buttonModeCache = ((buttonMode == true)) ? 1 : 0;
            buttonMode = false;
        }
        protected function activateMouseTrap():void{
            addEventListener(MouseEvent.ROLL_OVER, captureMouseEvent, false, 10000, true);
            addEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent, false, 10000, true);
            addEventListener(MouseEvent.ROLL_OUT, captureMouseEvent, false, 10000, true);
            addEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent, false, 10000, true);
            addEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent, false, 10000, true);
        }

    }
}//package Utils 
