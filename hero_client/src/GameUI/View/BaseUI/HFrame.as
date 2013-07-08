//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.events.*;
    import flash.display.*;
    import OopsFramework.Content.*;
    import flash.geom.*;
    import Manager.*;
    import flash.text.*;
    import com.greensock.*;
    import flash.filters.*;
    import com.greensock.easing.*;

    public class HFrame extends Sprite {

        protected var _minimizeBtn:SimpleButton;
        private var _titleField:TextField;
        private var _titleText:String;
        private var _bgBitmap:Sprite;
        protected var _content:Sprite;
        public var IsSetFouse:Boolean = true;
        private var _moveEnable:Boolean = true;
        private var _float:Sprite;
        private var _height:int;
        public var autoDispose:Boolean = false;
        private var _isCenterTitle:Boolean = false;
        private var _showClose:Boolean;
        protected var _minimizeCallBack:Function;
        private var _bgBitmapData:BitmapData;
        protected var _fireEvent:Boolean = false;
        private var _topCenter:Bitmap;
        private var isplayEffect:Boolean = false;
        private var allContent:Sprite;
        protected var _closeBtn:SimpleButton;
        private var _HL:Bitmap;
        private var _IsTop:Boolean;
        private var dragrt:Rectangle;
        private var _rightPattern:Bitmap;
        private var _titleActive:Boolean = true;
        private var _width:int;
        private var _leftPattern:Bitmap;
        private var _alphaDarger:Sprite;
        private var _blackGound:Boolean = true;
        private var _HL1:Bitmap;
        private var _HL2:Bitmap;
        private var _closeFunction:Function;
        protected var _bgContainer:Sprite;

        public function HFrame(_arg1:MovieClip=null, _arg2:Number=0, _arg3:Number=0){
            dragrt = new Rectangle(-1000, -1000, 4000, 4000);
            init();
            initEvent();
            if (_arg1 != null){
                setSize(_arg2, _arg3);
                addContent(_arg1);
            };
        }
        public function set closeCallBack(_arg1:Function):void{
            _closeFunction = _arg1;
        }
        public function get centerTitle():Boolean{
            return (_isCenterTitle);
        }
        public function set centerTitle(_arg1:Boolean):void{
            _isCenterTitle = _arg1;
            _titleField.y = 5;
            if (_arg1){
                _titleField.x = int((((_width - _titleField.width) / 2) + 1));
            } else {
                _titleField.x = 10;
            };
        }
        public function set fireEvent(_arg1:Boolean):void{
            _fireEvent = _arg1;
            if (_fireEvent){
                addEventListener(MouseEvent.CLICK, __onClickFocus);
            } else {
                removeEventListener(MouseEvent.CLICK, __onClickFocus);
            };
        }
        public function setFoucs():void{
            if (stage){
                stage.focus = this;
            };
        }
        public function show():void{
            GameCommonData.GameInstance.GameUI.addChild(this);
        }
        private function init():void{
            allContent = new Sprite();
            addChild(allContent);
            _alphaDarger = new Sprite();
            _float = new Sprite();
            _bgContainer = new Sprite();
            _content = new Sprite();
            allContent.addChild(_bgContainer);
            allContent.addChild(_content);
            _bgBitmap = UILib.GetClassBySprite("shooter.view.frame.asset.FrameBgAccect");
            _bgContainer.addChild(_bgBitmap);
            addEventListener(Event.ADDED_TO_STAGE, __addToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, __removeToStage);
            moveEnable = _moveEnable;
            allContent.addChild(_alphaDarger);
            var _local1:BitmapData = UILib.GetClassByBitmapData("shooter.view.frame.asset.FramePatternAccect");
            this._leftPattern = new Bitmap(_local1);
            this._rightPattern = new Bitmap(_local1);
            var _local2:BitmapData = UILib.GetClassByBitmapData("shooter.view.frame.asset.FramePatternAccect2");
            this._rightPattern.scaleX = -1;
            _leftPattern.y = 1;
            _rightPattern.y = 1;
            var _local3:BitmapData = UILib.GetClassByBitmapData("shooter.view.frame.asset.FrameHLgAccect");
            var _local4:BitmapData = UILib.GetClassByBitmapData("shooter.view.frame.asset.FrameHLg2Accect");
            _HL = new Bitmap(_local3);
            _HL1 = new Bitmap(_local4);
            _HL.y = 2;
            _HL1.y = -4;
            _bgContainer.addChild(_HL);
            _bgContainer.addChild(_leftPattern);
            _bgContainer.addChild(_rightPattern);
            _bgContainer.addChild(_HL1);
            var _local5:BitmapData = UILib.GetClassByBitmapData("shooter.view.frame.asset.TopCenter");
            _topCenter = new Bitmap(_local5);
            _topCenter.y = -4;
            _bgContainer.addChild(_topCenter);
            _titleField = creatTitleField();
            allContent.addChild(_titleField);
            centerTitle = _isCenterTitle;
            _closeBtn = UILib.GetClassByButton("CloseBtn");
            allContent.addChild(_closeBtn);
            _closeBtn.y = 2;
        }
        private function setChildIndexHandler(_arg1:MouseEvent):void{
            if (GameCommonData.GameInstance.GameUI.contains(this)){
                GameCommonData.GameInstance.GameUI.addChild(this);
            };
        }
        public function removeActiveEvent():void{
            _closeBtn.removeEventListener(MouseEvent.CLICK, __closeClick);
        }
        public function centerFrame():void{
            if (GameCommonData.GameInstance){
                this.x = int(((GameCommonData.GameInstance.ScreenWidth - this.frameWidth) / 2));
                this.y = int(((GameCommonData.GameInstance.ScreenHeight - this.frameHeight) / 2));
            };
        }
        private function comp2():void{
            allContent.alpha = 1;
            if (parent){
                parent.removeChild(this);
            };
        }
        private function comP1():void{
            allContent.alpha = 1;
            _closeFunction();
        }
        public function get frameHeight():int{
            return (_height);
        }
        public function dispose():void{
            _closeFunction = null;
            graphics.clear();
            if (((!(autoDispose)) && (parent))){
                parent.removeChild(this);
            };
            if (((_float) && (_float.parent))){
                allContent.removeChild(_float);
                _float.removeEventListener(MouseEvent.MOUSE_DOWN, __outsideMouseDown);
                _float.removeEventListener(MouseEvent.MOUSE_UP, __outsideMouseUp);
                _float = null;
            };
            if (_bgBitmapData){
                _bgBitmapData.dispose();
            };
            _bgBitmapData = null;
            _bgBitmap = null;
            if (_closeBtn){
                _closeBtn.removeEventListener(MouseEvent.CLICK, __closeClick);
                if (this.hasEventListener(MouseEvent.MOUSE_DOWN)){
                    this.removeEventListener(MouseEvent.MOUSE_DOWN, setChildIndexHandler);
                };
                _closeBtn.parent.removeChild(_closeBtn);
            };
            _closeBtn = null;
            if (_minimizeBtn){
                _minimizeBtn.removeEventListener(MouseEvent.CLICK, __minimizeHandler);
                if (this.hasEventListener(MouseEvent.MOUSE_DOWN)){
                    this.removeEventListener(MouseEvent.MOUSE_DOWN, setChildIndexHandler);
                };
                if (_minimizeBtn.parent){
                    _minimizeBtn.parent.removeChild(_minimizeBtn);
                };
            };
            _minimizeBtn = null;
            _content = null;
            if (_alphaDarger){
                _alphaDarger.removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
                _alphaDarger.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
                _alphaDarger = null;
            };
            removeEventListener(MouseEvent.CLICK, __onClickFocus);
            removeEventListener(Event.ADDED_TO_STAGE, __addToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE, __removeToStage);
        }
        protected function __removeToStage(_arg1:Event):void{
            graphics.clear();
            removeEventListener(MouseEvent.CLICK, __onClickFocus);
            if (_float.parent){
                allContent.removeChild(_float);
            };
            if (autoDispose){
                removeEventListener(Event.REMOVED_FROM_STAGE, __removeToStage);
                dispose();
            };
        }
        private function __mouseDownHandler(_arg1:MouseEvent):void{
            this.x = int(this.x);
            this.y = int(this.y);
            this.startDrag(false, dragrt);
        }
        public function get closeBtn():SimpleButton{
            return (_closeBtn);
        }
        public function setBg(_arg1:DisplayObject):void{
            _arg1.x = 3;
            _arg1.y = 3;
            _bgContainer.addChildAt(_arg1, 1);
        }
        protected function __addToStage(_arg1:Event):void{
            if (_blackGound){
                graphics.clear();
                graphics.beginFill(0, 0.5);
                graphics.drawRect(-3000, -3000, 6000, 6000);
                graphics.endFill();
            };
            if (_float){
                allContent.addChildAt(_float, 0);
            };
            if (IsSetFouse){
                stage.focus = this;
            };
            if (_fireEvent){
                addEventListener(MouseEvent.CLICK, __onClickFocus);
            } else {
                removeEventListener(MouseEvent.CLICK, __onClickFocus);
            };
        }
        public function getContent():DisplayObject{
            return (_content);
        }
        protected function __onClickFocus(_arg1:MouseEvent):void{
            _arg1.stopImmediatePropagation();
            stage.focus = this;
        }
        protected function __closeClick(_arg1:MouseEvent):void{
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "closeBtnSound");
            isplayEffect = false;
            if (_closeFunction != null){
                if (_closeBtn){
                };
                isplayEffect = true;
                TweenLite.to(allContent, 0.15, {
                    alpha:0.2,
                    ease:Linear.easeOut,
                    onComplete:comP1
                });
            } else {
                close();
            };
        }
        public function set titleText(_arg1:String):void{
            _titleText = _arg1;
            _titleField.htmlText = _titleText;
            centerTitle = _isCenterTitle;
        }
        public function hideFrame(_arg1:Boolean):void{
            _bgContainer.alpha = (_arg1) ? 1 : 0;
        }
        public function removeContent(_arg1:DisplayObject):void{
            _content.removeChild(_arg1);
        }
        public function set IsTop(_arg1:Boolean):void{
            _IsTop = _arg1;
            if (_arg1){
                addEventListener(MouseEvent.MOUSE_DOWN, __top);
            } else {
                removeEventListener(MouseEvent.MOUSE_DOWN, __top);
            };
        }
        public function get Y():int{
            return (int(super.y));
        }
        public function center():void{
        }
        public function get X():int{
            return (int(super.x));
        }
        public function get frameWidth():int{
            return (_width);
        }
        public function setContentSize(_arg1:Number, _arg2:Number):void{
            setSize((_arg1 + 43), (_arg2 + 60));
            _content.x = 20;
            _content.y = 45;
        }
        private function get UILib():ContentTypeReader{
            if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary)){
                return (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary));
            };
            return (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrarySelectRole));
        }
        private function initEvent():void{
            this.addEventListener(MouseEvent.MOUSE_DOWN, setChildIndexHandler);
            _closeBtn.addEventListener(MouseEvent.CLICK, __closeClick);
        }
        public function set moveEnable(_arg1:Boolean):void{
            if (_alphaDarger){
                if (_arg1){
                    _alphaDarger.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
                    _alphaDarger.addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
                } else {
                    _alphaDarger.removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
                    _alphaDarger.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
                };
            };
        }
        public function set minimizeCallBack(_arg1:Function):void{
            _minimizeCallBack = _arg1;
        }
        private function closeAfterEffect():void{
            allContent.alpha = 1;
        }
        public function set showMinimize(_arg1:Boolean):void{
            if (_minimizeBtn == null){
                _minimizeBtn = UILib.GetClassByButton("CloseButton");
                _minimizeBtn.x = ((_closeBtn.x - _minimizeBtn.width) - 1);
                _minimizeBtn.y = 4;
                allContent.addChild(_minimizeBtn);
                _minimizeBtn.addEventListener(MouseEvent.CLICK, __minimizeHandler);
            };
            _minimizeBtn.visible = _arg1;
        }
        public function get closeCallBack():Function{
            return (_closeFunction);
        }
        public function get titleActive():Boolean{
            return (_titleActive);
        }
        public function setSize(_arg1:Number, _arg2:Number):void{
            _width = _arg1;
            _height = _arg2;
            _bgBitmap.width = _arg1;
            _bgBitmap.height = _arg2;
            _alphaDarger.graphics.beginFill(0xFF00FF, 0);
            _alphaDarger.graphics.drawRect(0, 0, ((_bgBitmap.width - _closeBtn.width) - 10), 31);
            _alphaDarger.graphics.endFill();
            _leftPattern.x = 0;
            _rightPattern.x = (_bgBitmap.width - 0);
            _topCenter.x = ((_bgBitmap.width - _topCenter.width) / 2);
            _closeBtn.x = ((_bgBitmap.width - _closeBtn.width) - 1);
            if (_minimizeBtn){
                _minimizeBtn.x = ((_closeBtn.x - _minimizeBtn.width) - 1);
            };
            _HL.width = (_bgBitmap.width - 4);
            _HL.x = 2;
            if (_bgBitmap.width > _HL1.width){
                _HL1.x = int(((_bgBitmap.width - _HL1.width) / 2));
            } else {
                _HL1.x = 2;
            };
            centerTitle = _isCenterTitle;
        }
        public function set blackGound(_arg1:Boolean):void{
            _blackGound = _arg1;
            if (_arg1){
                graphics.clear();
                graphics.beginFill(0, 0.5);
                graphics.drawRect(-2000, -2000, 4000, 4000);
                graphics.endFill();
            } else {
                graphics.clear();
            };
        }
        public function set alphaGound(_arg1:Boolean):void{
            if (_arg1){
                _float.graphics.clear();
                _float.graphics.beginFill(0xFFFFFF, 0);
                _float.graphics.drawRect(-500, -500, 2000, 2000);
                _float.graphics.endFill();
                _float.addEventListener(MouseEvent.MOUSE_DOWN, __outsideMouseDown);
                _float.addEventListener(MouseEvent.MOUSE_UP, __outsideMouseUp);
            } else {
                _float.graphics.clear();
                _float.removeEventListener(MouseEvent.MOUSE_DOWN, __outsideMouseDown);
                _float.removeEventListener(MouseEvent.MOUSE_UP, __outsideMouseUp);
            };
        }
        private function __top(_arg1:MouseEvent):void{
            show();
        }
        private function __outsideMouseUp(_arg1:MouseEvent):void{
            if (_bgBitmap){
                _bgBitmap.filters = null;
            };
        }
        public function addContent(_arg1:DisplayObject, _arg2:Boolean=false):void{
            _content.addChild(_arg1);
            center();
        }
        private function __outsideMouseDown(_arg1:MouseEvent):void{
            if (_bgBitmap){
                _bgBitmap.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 10)];
            };
        }
        public function get titleText():String{
            return (_titleText);
        }
        public function get IsTop():Boolean{
            return (_IsTop);
        }
        public function set X(_arg1:int){
            super.x = _arg1;
        }
        public function set Y(_arg1:int){
            super.y = _arg1;
        }
        public function setHLVisible(_arg1:Boolean):void{
            _HL1.visible = _arg1;
        }
        public function get moveEvable():Boolean{
            return (_moveEnable);
        }
        public function addActiveEvent():void{
            _closeBtn.addEventListener(MouseEvent.CLICK, __closeClick);
        }
        public function offsetCloseBtnPos(_arg1:int, _arg2:int):void{
            _closeBtn.x = (_closeBtn.x + _arg1);
            _closeBtn.y = (_closeBtn.y + _arg2);
        }
        private function __mouseUpHandler(_arg1:MouseEvent):void{
            this.stopDrag();
        }
        private function creatTitleField():TextField{
            var _local1:TextField = new TextField();
            var _local2:TextFormat = new TextFormat();
            _local2.size = 14;
            _local2.color = 12776447;
            _local2.bold = true;
            _local1.defaultTextFormat = _local2;
            _local1.filters = [new GlowFilter(0, 1, 3, 3, 10)];
            _local1.mouseEnabled = false;
            _local1.selectable = false;
            _local1.autoSize = "left";
            return (_local1);
        }
        protected function __minimizeHandler(_arg1:MouseEvent):void{
            if (_minimizeCallBack != null){
                _minimizeCallBack();
            };
        }
        public function set showClose(_arg1:Boolean):void{
            _showClose = _arg1;
            _closeBtn.visible = _showClose;
        }
        public function get showClose():Boolean{
            return (_showClose);
        }
        public function set titleActive(_arg1:Boolean):void{
            _titleActive = _arg1;
            if (_titleActive){
                if (!this.hasEventListener(MouseEvent.MOUSE_DOWN)){
                    this.addEventListener(MouseEvent.MOUSE_DOWN, setChildIndexHandler);
                };
            } else {
                if (this.hasEventListener(MouseEvent.MOUSE_DOWN)){
                    this.removeEventListener(MouseEvent.MOUSE_DOWN, setChildIndexHandler);
                };
            };
        }
        public function close():void{
            if (parent){
                if (!isplayEffect){
                    TweenLite.to(allContent, 0.15, {
                        alpha:0.2,
                        ease:Linear.easeOut,
                        onComplete:comp2
                    });
                } else {
                    parent.removeChild(this);
                };
            };
        }

    }
}//package GameUI.View.BaseUI 
