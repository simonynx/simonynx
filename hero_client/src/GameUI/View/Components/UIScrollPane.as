//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.Components {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;

    public class UIScrollPane extends UISprite {

        public static const SCROLLBAR_NEVER:int = 2;
        public static const SCROLLBAR_ALWAYS:int = 0;
        public static const SCROLLBAR_AS_NEEDED:int = 1;

        private var scrollDir:int;
        private var paddings:Object;
        private var scrollBar:Sprite;
        private var downArrow:SimpleButton;
        private var arrowHeight:int;
        private var programatic:Boolean;
        private var thumbDown:Sprite;
        private var view:DisplayObject;
        private var thumbUp:Sprite;
        private var upArrow:SimpleButton;
        private var viewMask:Sprite;
        private var policy:int;
        private var barBackGround:Sprite;
        private var timer:Timer;
        private var step:int;
        private var textField:TextField;
        private var grip:Sprite;
        private var pos:int;
        public var updateFlag:Boolean = true;
        private var thumb:Sprite;
        private var thumbRect:Rectangle;
        private var _viewContainer:Sprite;
        private var thumbDragging:Boolean;
        private var max:int;

        public function UIScrollPane(_arg1:DisplayObject):void{
            thumbRect = new Rectangle();
            view = _arg1;
            scrollBar = new Sprite();
            this.addChild(scrollBar);
            barBackGround = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BarBackground");
            barBackGround.addEventListener(MouseEvent.MOUSE_DOWN, onBarMouseDown);
            scrollBar.addChild(barBackGround);
            upArrow = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("UpArrow");
            upArrow.addEventListener(MouseEvent.MOUSE_DOWN, onUpArrowMouseDown);
            scrollBar.addChild(upArrow);
            downArrow = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("DownArrow");
            downArrow.addEventListener(MouseEvent.MOUSE_DOWN, onDownArrowMouseDown);
            scrollBar.addChild(downArrow);
            thumb = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Thumb");
            thumb.y = arrowHeight;
            thumb.x = 0;
            thumb.visible = false;
            thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
            scrollBar.addChild(thumb);
            grip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Grip");
            grip.mouseEnabled = false;
            grip.visible = false;
            grip.x = int(((thumb.width - grip.width) / 2));
            scrollBar.addChild(grip);
            viewContainer = new Sprite();
            viewContainer.name = "scrollBarViewContainer";
            viewContainer.mouseEnabled = false;
            if ((view is TextField)){
                textField = new TextField();
                textField.addEventListener(Event.SCROLL, onTextScroll);
            } else {
                viewMask = new Sprite();
                viewMask.mouseEnabled = false;
                viewMask.graphics.lineStyle(0, 0, 0);
                viewMask.graphics.beginFill(0);
                viewMask.graphics.drawRect(0, 0, view.width, view.height);
                viewMask.graphics.endFill();
                viewContainer.addChild(viewMask);
                viewContainer.mask = viewMask;
            };
            this.addChild(viewContainer);
            viewContainer.addChild(view);
            arrowHeight = (upArrow.height - 2);
            thumbRect.x = thumb.x;
            thumbRect.y = arrowHeight;
            thumbRect.width = 0;
            pos = 0;
            max = 0;
            step = 15;
            paddings = {
                left:0,
                right:0,
                top:0,
                bottom:0
            };
            setPaddings(paddings);
            timer = new Timer(300, 0);
            timer.addEventListener(TimerEvent.TIMER, onTimer);
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            MouseWheel = true;
        }
        public function setScrollPos():void{
            scrollBar.x = 0;
            viewContainer.x = scrollBar.width;
        }
        public function setPaddings(_arg1:Object):void{
            if (_arg1){
                this.paddings.left = _arg1.left;
                this.paddings.right = _arg1.right;
                this.paddings.top = _arg1.top;
                this.paddings.bottom = _arg1.bottom;
            };
            this.width = paddings.right;
            this.height = paddings.bottom;
            viewContainer.x = paddings.left;
            viewContainer.y = paddings.top;
        }
        private function updateScrollPos():void{
            pos = ((thumb.y - arrowHeight) / (((iBackground.height - thumb.height) - (2 * arrowHeight)) / max));
            if (pos <= (this.step / 2)){
                pos = 0;
            };
            if (pos >= (max - (step / 2))){
                pos = max;
            };
            setUpdateFlag();
            programatic = true;
            if (textField != null){
                textField.scrollV = (pos + 1);
            } else {
                view.y = -(pos);
            };
            programatic = false;
        }
        private function onBarMouseDown(_arg1:MouseEvent):void{
            var _local2:Number = this.mouseY;
            thumb.y = (_local2 - (thumb.height / 2));
            if (thumb.y < arrowHeight){
                thumb.y = arrowHeight;
            };
            if ((thumb.y + thumb.height) > (this.iBackground.height - arrowHeight)){
                thumb.y = ((iBackground.height - arrowHeight) - thumb.height);
            };
            setUpdateFlag();
            grip.y = int((thumb.y + ((thumb.height - grip.height) / 2)));
            updateScrollPos();
        }
        public function set scrollPos(_arg1:Number):void{
            pos = _arg1;
            if (pos > max){
                pos = max;
            };
            if (pos < 0){
                pos = 0;
            };
            updateUI();
        }
        private function scrollDown():void{
            pos = (pos + step);
            if (pos > (max - (step / 2))){
                pos = max;
            };
            setUpdateFlag();
            updateThumbPos();
        }
        override public function set width(_arg1:Number):void{
            super.width = _arg1;
            scrollBar.x = (iBackground.width - scrollBar.width);
            if (scrollBar.visible){
                if (textField != null){
                    textField.width = ((iBackground.width - scrollBar.width) - (paddings.left + paddings.right));
                } else {
                    view.width = ((iBackground.width - scrollBar.width) - (paddings.left + paddings.right));
                };
            } else {
                if (textField != null){
                    textField.width = (iBackground.width - (paddings.left + paddings.right));
                } else {
                    view.width = (iBackground.width - (paddings.left + paddings.right));
                };
            };
        }
        protected function updateUI():void{
            var _local1:Number;
            if (max > 0){
                if (this.policy == SCROLLBAR_AS_NEEDED){
                    scrollBar.visible = true;
                };
                if (textField != null){
                    _local1 = (((iBackground.height - (arrowHeight * 2)) * (textField.bottomScrollV - textField.scrollV)) / ((textField.bottomScrollV - textField.scrollV) + max));
                } else {
                    _local1 = (((iBackground.height - (arrowHeight * 2)) * (iBackground.height - (paddings.top + paddings.bottom))) / view.height);
                };
                if (_local1 < (arrowHeight * 2)){
                    _local1 = (arrowHeight * 2);
                };
                if (_local1 > (iBackground.height - (arrowHeight * 2))){
                    thumb.visible = false;
                    grip.visible = false;
                } else {
                    thumb.height = _local1;
                    thumbRect.bottom = Math.ceil(((iBackground.height - arrowHeight) - thumb.height));
                    grip.visible = true;
                    thumb.visible = true;
                };
                updateThumbPos();
            } else {
                if (this.policy == SCROLLBAR_AS_NEEDED){
                    scrollBar.visible = false;
                };
                programatic = true;
                if (textField != null){
                    textField.scrollV = 0;
                } else {
                    view.y = 0;
                };
                programatic = false;
                thumb.visible = false;
                grip.visible = false;
            };
        }
        public function dispose():void{
            scrollBar.removeChild(barBackGround);
            scrollBar.removeChild(upArrow);
            scrollBar.removeChild(downArrow);
            scrollBar.removeChild(thumb);
            scrollBar.removeChild(grip);
            if (((viewMask) && (viewMask.parent))){
                viewContainer.removeChild(viewMask);
            };
            viewContainer.removeChild(view);
            this.removeChild(viewContainer);
            this.removeChild(scrollBar);
        }
        private function onTimer(_arg1:TimerEvent):void{
            if (timer.delay == 300){
                timer.delay = 100;
            };
            if (scrollDir > 0){
                if (pos == max){
                    return;
                };
                pos = (pos + step);
                if (pos > (max - (step / 2))){
                    pos = max;
                };
                updateThumbPos();
            } else {
                if (pos == 0){
                    return;
                };
                pos = (pos - step);
                if (pos < (step / 2)){
                    pos = 0;
                };
                updateThumbPos();
            };
        }
        public function set viewContainer(_arg1:Sprite):void{
            _viewContainer = _arg1;
        }
        public function get hasScrollBar():Boolean{
            return (scrollBar.visible);
        }
        public function set MouseWheel(_arg1:Boolean):void{
            if (_arg1){
                this.addEventListener(MouseEvent.MOUSE_WHEEL, onScrollMouseWheel);
            } else {
                this.removeEventListener(MouseEvent.MOUSE_WHEEL, onScrollMouseWheel);
            };
        }
        public function set scrollPolicy(_arg1:int):void{
            if (policy == _arg1){
                return;
            };
            policy = _arg1;
            if (_arg1 == SCROLLBAR_AS_NEEDED){
                scrollBar.visible = (max > 0);
            } else {
                if (_arg1 == SCROLLBAR_NEVER){
                    scrollBar.visible = false;
                } else {
                    scrollBar.visible = true;
                };
            };
        }
        private function updateThumbPos():void{
            thumb.y = (arrowHeight + ((pos * ((this.barBackGround.height - thumb.height) - (2 * this.arrowHeight))) / max));
            grip.y = int((thumb.y + ((thumb.height - grip.height) / 2)));
            programatic = true;
            if (textField != null){
                textField.scrollV = (pos + 1);
            } else {
                view.y = -(pos);
            };
            programatic = false;
        }
        private function onTextScroll(_arg1:Event):void{
            if (!programatic){
            };
        }
        public function set scrollBarOpaque(_arg1:Boolean):void{
            if (_arg1){
                this.barBackGround.alpha = 1;
            } else {
                this.barBackGround.alpha = 0;
            };
        }
        public function get scrollPos():Number{
            return (pos);
        }
        private function onAddedToStage(_arg1:Event):void{
            if (_arg1.target == this){
                stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            };
        }
        private function onStageMouseUp(_arg1:MouseEvent):void{
            if (scrollDir != 0){
                timer.delay = 300;
                timer.reset();
                scrollDir = 0;
            };
            if (thumbDragging){
                thumb.stopDrag();
                thumbDragging = false;
                if (stage != null){
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
                };
                grip.y = int((thumb.y + ((thumb.height - grip.height) / 2)));
                updateScrollPos();
                thumb.y = (this.arrowHeight + ((pos * ((this.iBackground.height - thumb.height) - (2 * arrowHeight))) / max));
            };
        }
        public function get scrollStep():int{
            return (step);
        }
        private function scrollUp():void{
            pos = (pos - step);
            if (pos < (step / 2)){
                pos = 0;
            };
            updateThumbPos();
        }
        private function onUpArrowMouseDown(_arg1:MouseEvent):void{
            if (max > 0){
                scrollUp();
                scrollDir = -1;
                timer.start();
            };
            setUpdateFlag();
        }
        public function get Content():DisplayObject{
            return (view);
        }
        public function refresh():void{
            var _local1:Number;
            var _local2:*;
            if (textField != null){
                _local1 = textField.maxScrollV;
                _local2 = _local1;
                _local1--;
                max = _local2;
            } else {
                max = (view.height - (iBackground.height - (paddings.top + paddings.bottom)));
            };
            if (max < 0){
                max = 0;
            };
            if (pos > max){
                pos = max;
            };
            updateUI();
        }
        public function get scrollMax():Number{
            return (max);
        }
        private function onDownArrowMouseDown(_arg1:MouseEvent):void{
            if (max > 0){
                scrollDown();
                scrollDir = 1;
                timer.start();
            };
        }
        public function scrollTop():void{
            pos = 0;
            updateUI();
        }
        public function get viewContainer():Sprite{
            return (_viewContainer);
        }
        override public function set height(_arg1:Number):void{
            super.height = _arg1;
            this.barBackGround.height = this.iBackground.height;
            if (_arg1 < (this.arrowHeight * 2)){
            };
            downArrow.y = (this.barBackGround.height - this.downArrow.height);
            if (this.textField != null){
                this.textField.height = (this.iBackground.height - (paddings.top + paddings.bottom));
            } else {
                this.viewMask.height = (this.iBackground.height - (paddings.top + paddings.bottom));
            };
        }
        private function onScrollMouseWheel(_arg1:MouseEvent):void{
            _arg1.currentTarget.scrollPos = (_arg1.currentTarget.scrollPos - (_arg1.delta * 6));
            _arg1.stopImmediatePropagation();
        }
        public function scrollToView(_arg1:DisplayObject):void{
            if (_arg1.y < pos){
                scrollPos = _arg1.y;
            } else {
                if ((_arg1.y + _arg1.height) > (pos + viewMask.height)){
                    scrollPos = ((_arg1.y + _arg1.height) - viewMask.height);
                };
            };
        }
        private function setUpdateFlag():void{
            if ((thumb.y + thumb.height) >= (this.iBackground.height - arrowHeight)){
                if (updateFlag == false){
                    refresh();
                    scrollBottom();
                    refresh();
                };
                updateFlag = true;
            } else {
                updateFlag = false;
            };
        }
        public function scrollBottom():void{
            pos = ((max + step) + 6);
            updateUI();
        }
        public function set scrollStep(_arg1:int):void{
            step = _arg1;
        }
        private function onThumbMouseDown(_arg1:MouseEvent):void{
            thumb.startDrag(false, thumbRect);
            thumbDragging = true;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        }
        private function onStageMouseMove(_arg1:MouseEvent):void{
            if (thumbDragging){
                grip.y = int((thumb.y + ((thumb.height - grip.height) / 2)));
                updateScrollPos();
            };
        }

    }
}//package GameUI.View.Components 
