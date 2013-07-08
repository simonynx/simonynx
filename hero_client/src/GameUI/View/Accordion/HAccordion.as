//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.Accordion {
    import flash.events.*;
    import flash.display.*;
    import com.greensock.*;
    import GameUI.View.Components.*;
    import com.greensock.easing.*;

    public class HAccordion extends UISprite {

        public static const SELECT_CHANGE:String = "SELECT_CHANGE";
        public static const CHILD_REMOVE:String = "CHILD_REMOVE";
        public static const CHILD_ADD:String = "CHILD_ADD";

        private var contentHeight:Number = 0;
        private var visibles:Array;
        private var _onlyOneOpen:Boolean = true;
        private var contentWidth:Number = 0;
        private var enables:Array;
        private var _selectedIndex:int = -1;
        private var titles:Array;
        private var tweenMasks:Array;
        private var contentSprite:Sprite;
        private var mainBtns:Array;
        private var _mainBtnClass:Class;
        private var scrollPanel:UIScrollPane;
        private var children:Array;

        public function HAccordion(_arg1:Number=300, _arg2:Number=300){
            this.contentWidth = _arg1;
            this.contentHeight = _arg2;
            initUI();
        }
        public function setSize(_arg1:Number, _arg2:Number):void{
            this.contentWidth = _arg1;
            this.contentHeight = _arg2;
            this.contentSprite.width = contentWidth;
            this.contentSprite.height = contentHeight;
            this.scrollPanel.width = contentWidth;
            this.scrollPanel.height = contentHeight;
            this.scrollPanel.refresh();
        }
        public function get onlyOneOpen():Boolean{
            return (_onlyOneOpen);
        }
        public function get selectedIndex():int{
            if (_selectedIndex != -1){
                return (_selectedIndex);
            };
            return (0);
        }
        private function __selectIdxHandler(_arg1:MouseEvent):void{
            var _local3:int;
            var _local2:IAccordionMainCell = (_arg1.currentTarget as IAccordionMainCell);
            if (_local2){
                _local3 = mainBtns.indexOf(_local2);
                if (_local3 > -1){
                    selectedIndex = _local3;
                };
            };
        }
        protected function insertProperties(_arg1:int, _arg2:String=""):void{
            insertToArray(titles, _arg1, _arg2);
            insertToArray(enables, _arg1, true);
            insertToArray(visibles, _arg1, false);
        }
        private function createMask():void{
            var _local1:Shape;
            tweenMasks = [];
            var _local2:int;
            while (_local2 < mainBtns.length) {
                _local1 = new Shape();
                if (children[_local2]){
                    _local1.graphics.beginFill(0, 0.3);
                    _local1.graphics.drawRect(0, 0, (children[_local2].width + children[_local2].x), children[_local2].height);
                    _local1.graphics.endFill();
                    _local1.x = mainBtns[_local2].x;
                    _local1.y = (mainBtns[_local2].y + mainBtns[_local2].height);
                    children[_local2].parent.addChild(_local1);
                    children[_local2].mask = _local1;
                };
                tweenMasks[_local2] = _local1;
                _local2++;
            };
        }
        public function set onlyOneOpen(_arg1:Boolean):void{
            _onlyOneOpen = _arg1;
            if (_onlyOneOpen){
                updateOnlyOne(selectedIndex);
                setLayout();
            };
        }
        private function updateOnlyOne(_arg1:int):void{
            var _local2:int;
            while (_local2 < visibles.length) {
                if (_local2 == _arg1){
                } else {
                    visibles[_local2] = false;
                };
                _local2++;
            };
        }
        protected function insertImp(_arg1:int, _arg2:DisplayObjectContainer, _arg3:String="", _arg4:Object=null):void{
            var _local5:IAccordionMainCell;
            if (_arg2.parent != null){
                _arg2.parent.removeChild(_arg2);
            };
            _local5 = new MainBtnClass(_arg1);
            _local5.param = _arg4;
            _local5.title = _arg3;
            _local5.addEventListener(MouseEvent.CLICK, __selectIdxHandler);
            _local5.x = 8;
            contentSprite.addChild((_local5 as DisplayObjectContainer));
            if (_arg1 < 0){
                children.push(_arg2);
                contentSprite.addChild(_arg2);
                mainBtns.push(_local5);
            } else {
                contentSprite.addChildAt(_arg2, _arg1);
                children.splice(_arg1, 0, _arg2);
                mainBtns.splice(_arg1, 0, _local5);
            };
            setLayout(false);
        }
        private function cleanMask():void{
            var _local1:int;
            while (_local1 < tweenMasks.length) {
                if (((tweenMasks[_local1]) && (tweenMasks[_local1].parent))){
                    tweenMasks[_local1].parent.removeChild(tweenMasks[_local1]);
                };
                children[_local1].mask = null;
                _local1++;
            };
            tweenMasks = [];
        }
        public function cleanAllChilds():void{
            var _local1:int;
            _local1 = 0;
            while (_local1 < mainBtns.length) {
                if (mainBtns[_local1]){
                    mainBtns[_local1].removeEventListener(MouseEvent.CLICK, __selectIdxHandler);
                    mainBtns[_local1].dispose;
                };
                _local1++;
            };
            _local1 = 0;
            while (_local1 < children.length) {
                if (((children[_local1]) && (children[_local1].parent))){
                    children[_local1].parent.removeChild(children[_local1]);
                };
                _local1++;
            };
            while (contentSprite.numChildren) {
                contentSprite.removeChildAt(0);
            };
            mainBtns = [];
            children = [];
            titles = [];
            enables = [];
            visibles = [];
            tweenMasks = [];
        }
        public function getComponentCount():int{
            return (children.length);
        }
        public function dispose():void{
            cleanAllChilds();
            if (parent){
                this.parent.removeChild(this);
            };
        }
        public function appendTab(_arg1:DisplayObjectContainer, _arg2:String="", _arg3:Object=null):void{
            insertTab(-1, _arg1, _arg2, _arg3);
        }
        public function insertTab(_arg1:int, _arg2:DisplayObjectContainer, _arg3:String="", _arg4:Object=null):void{
            if (_arg1 > getComponentCount()){
                throw (Error("error"));
            };
            if (_arg1 < 0){
                _arg1 = getComponentCount();
            };
            insertProperties(_arg1, _arg3);
            var _local5:int = selectedIndex;
            var _local6:int = _local5;
            if (_arg1 <= _local5){
                _local6 = (_local5 + 1);
            } else {
                if (_local5 < 0){
                    _local6 = _arg1;
                };
            };
            insertImp(_arg1, _arg2, _arg3, _arg4);
        }
        private function initUI():void{
            mainBtns = [];
            children = [];
            titles = [];
            enables = [];
            visibles = [];
            tweenMasks = [];
            this.contentSprite = new UISprite();
            this.contentSprite.width = contentWidth;
            this.contentSprite.height = contentHeight;
            this.scrollPanel = new UIScrollPane(contentSprite);
            this.scrollPanel.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            this.scrollPanel.width = contentWidth;
            this.scrollPanel.height = contentHeight;
            this.scrollPanel.x = 0;
            this.scrollPanel.y = 0;
            addChild(scrollPanel);
            MainBtnClass = AccordionMainCell;
        }
        public function get MainCells():Array{
            return (mainBtns);
        }
        public function set MainBtnClass(_arg1:Class):void{
            _mainBtnClass = _arg1;
        }
        protected function insertToArray(_arg1:Array, _arg2:int, _arg3:Object):void{
            if (_arg2 < 0){
                _arg1.push(_arg3);
            } else {
                _arg1.splice(_arg2, 0, _arg3);
            };
        }
        public function get MainBtnClass():Class{
            return (_mainBtnClass);
        }
        public function getChildContent(_arg1:int):DisplayObject{
            return (children[_arg1]);
        }
        private function setLayout(_arg1:Boolean=true):void{
            var toY:* = NaN;
            var tweenEnable:Boolean = _arg1;
            cleanMask();
            createMask();
            var yT:* = 5;
            var maxWidth:* = 0;
            var i:* = 0;
            while (i < mainBtns.length) {
                if (tweenEnable){
                    TweenLite.to(tweenMasks[i], 0.3, {y:(yT + mainBtns[i].height)});
                    TweenLite.to(mainBtns[i], 0.3, {y:yT});
                } else {
                    mainBtns[i].y = yT;
                };
                if (selectedIndex == i){
                };
                yT = (yT + (mainBtns[i].height + 2));
                contentSprite.setChildIndex(children[i], 0);
                mainBtns[i].bg.bg.gotoAndStop((visibles[i]) ? 2 : 1);
                if (visibles[i]){
                    children[i].visible = true;
                    if (tweenEnable){
                        TweenLite.to(children[i], 0.3, {
                            y:yT,
                            ease:Quad.easeOut
                        });
                    } else {
                        children[i].y = yT;
                    };
                    yT = (yT + children[i].height);
                } else {
                    toY = (yT - children[i].height);
                    if (tweenEnable){
                        TweenLite.to(children[i], 0.3, {
                            y:toY,
                            ease:Quad.easeIn,
                            onCompleteParams:[children[i]],
                            onComplete:function (_arg1:Sprite):void{
                                _arg1.visible = false;
                            }
                        });
                    } else {
                        children[i].y = toY;
                        children[i].visible = false;
                    };
                };
                if (maxWidth < mainBtns[i].width){
                    maxWidth = mainBtns[i].width;
                };
                if (maxWidth < children[i].width){
                    maxWidth = children[i].width;
                };
                i = (i + 1);
            };
            contentSprite.height = yT;
            contentSprite.width = maxWidth;
            scrollPanel.refresh();
        }
        public function set selectedIndex(_arg1:int):void{
            if (_arg1 == -1){
                return;
            };
            if (((onlyOneOpen) && ((_arg1 == _selectedIndex)))){
                return;
            };
            _selectedIndex = _arg1;
            visibles[_selectedIndex] = !(visibles[_selectedIndex]);
            if (_onlyOneOpen){
                updateOnlyOne(_selectedIndex);
            };
            setLayout();
            dispatchEvent(new Event(SELECT_CHANGE));
        }

    }
}//package GameUI.View.Accordion 
