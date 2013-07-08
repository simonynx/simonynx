//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Mediator {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import Utils.*;

    public class JianTouMc extends Sprite {

        public static const TYPE_VIPFLYTIP:String = "TYPE_VIPFLYTIP";
        public static const TYPE_CONVOY:String = "TYPE_CONVOY";
        public static const TYPE_LEVE_SHILIAN:String = "TYPE_LEVE_SHILIAN";
        public static const TYPE_STRENGTHEN:String = "TYPE_STRENGTHEN";
        public static const TYPE_PETREQUALITY:String = "TYPE_PETREQUALITY";
        public static const TYPE_USEBAGITEM:String = "TYPE_USEBAGITEM";
        public static const TYPE_DEFAULT:String = "TYPE_DEFAULT";
        public static const TYPE_PETUPSTAR:String = "TYPE_PETUPSTAR";
        public static const TYPE_SKILL:String = "TYPE_SKILL";
        public static const TYPE_EQUIPEXCHANGE:String = "TYPE_EQUIPEXCHANGE";

        private static var isLoadResoure:Boolean = false;
        private static var instanceDic:Dictionary = new Dictionary();

        private var loadQueue:Array;
        private var _tipsMc:MovieClip;
        private var _dir:int;
        private var target:DisplayObject;
        private var _recBoundSprite:Sprite;
        public var clickCallBack:Function;
        private var timeoutId:int;
        private var _jtMc:MovieClip;
        private var _closeBtn:SimpleButton;
        private var rectangleArr:Array;

        public function JianTouMc(){
            loadQueue = [];
            super();
        }
        public static function getInstance(_arg1:String="TYPE_DEFAULT"):JianTouMc{
            var _local2:String;
            var _local3:LoadSwfTool;
            if (!instanceDic[_arg1]){
                instanceDic[_arg1] = new (JianTouMc)();
            };
            if (isLoadResoure == false){
                _local2 = "Resources/Effect/BagSelectEffect.swf";
                _local3 = new LoadSwfTool(_local2, false);
                isLoadResoure = true;
            };
            return ((instanceDic[_arg1] as JianTouMc));
        }
        public static function hasInstance(_arg1:String):Boolean{
            return ((instanceDic[_arg1]) ? true : false);
        }
        public static function deleteInstance(_arg1:String):void{
            if (hasInstance(_arg1)){
                delete instanceDic[_arg1];
            };
        }

        public function get jtMc():MovieClip{
            return (_jtMc);
        }
        public function closeBtn():SimpleButton{
            return (_closeBtn);
        }
        public function setJTToTargetPostion(_arg1:DisplayObject):void{
            var _local2:Rectangle = target.getBounds(_arg1);
            var _local3:Point = new Point((_local2.x + (_local2.width / 2)), (_local2.y + (_local2.height / 2)));
            switch (_dir){
                case 1:
                    _jtMc.rotation = -180;
                    _tipsMc.x = (-(_tipsMc.width) / 2);
                    _tipsMc.y = (_jtMc.height + 20);
                    _local3.y = (_local3.y + (_local2.height / 2));
                    break;
                case 2:
                    _jtMc.rotation = -90;
                    _tipsMc.x = -(((_jtMc.width + _tipsMc.width) + 20));
                    _tipsMc.y = (-(_tipsMc.height) / 2);
                    _local3.x = (_local3.x - (_local2.width / 2));
                    break;
                case 3:
                    _jtMc.rotation = 0;
                    _tipsMc.x = (-(_tipsMc.width) / 2);
                    _tipsMc.y = (-((_jtMc.height + _tipsMc.height)) - 20);
                    _local3.y = (_local3.y - (_local2.height / 2));
                    break;
                case 4:
                    _jtMc.rotation = 90;
                    _tipsMc.x = (_jtMc.width + 10);
                    _tipsMc.y = (-(_tipsMc.height) / 2);
                    _local3.x = (_local3.x + (_local2.width / 2));
                    break;
            };
            _closeBtn.x = (((_tipsMc.x + _tipsMc.width) - _closeBtn.width) - 5);
            _closeBtn.y = (_tipsMc.y + 5);
            this.x = _local3.x;
            this.y = _local3.y;
            if ((_arg1 is DisplayObjectContainer)){
                (_arg1 as DisplayObjectContainer).addChild(this);
                if (((rectangleArr) && ((rectangleArr.length > 0)))){
                    showLightBound(rectangleArr);
                } else {
                    closeLightBound();
                };
            };
        }
        public function set autoClose_timeout(_arg1:int):void{
            if (_arg1 > 0){
                timeoutId = setTimeout(close, _arg1);
            };
        }
        public function set autoClickClean(_arg1:Boolean):void{
            if (target){
                if (_arg1){
                    target.addEventListener(MouseEvent.MOUSE_DOWN, close);
                } else {
                    target.removeEventListener(MouseEvent.MOUSE_DOWN, close);
                };
            };
        }
        private function showLightBound(_arg1:Array):void{
            var _local2:Rectangle;
            var _local3:int;
            var _local4:Number;
            var _local5:Number;
            var _local6:Point;
            if (_recBoundSprite){
                _recBoundSprite.graphics.clear();
                if (_recBoundSprite.parent){
                    _recBoundSprite.parent.removeChild(_recBoundSprite);
                };
                _recBoundSprite = null;
            };
            if (_arg1 == null){
                return;
            };
            _recBoundSprite = new Sprite();
            _recBoundSprite.mouseEnabled = false;
            _recBoundSprite.mouseChildren = false;
            _recBoundSprite.graphics.clear();
            if (loadQueue){
                _local3 = 0;
                while (_local3 < loadQueue.length) {
                    loadQueue[_local3].sendShow = null;
                    _local3++;
                };
            };
            loadQueue = [];
            for each (_local2 in _arg1) {
                _local4 = _local2.x;
                _local5 = _local2.y;
                if (this.parent != GameCommonData.GameInstance.TooltipLayer){
                    _local6 = this.parent.globalToLocal(new Point(_local4, _local5));
                    _local4 = _local6.x;
                    _local5 = _local6.y;
                };
                if ((((((_local2.width >= 32)) && ((_local2.width <= 36)))) && ((((_local2.height >= 32)) && ((_local2.height <= 36)))))){
                    loadBagEffect((_local4 - 8), (_local5 - 4));
                } else {
                    _recBoundSprite.graphics.lineStyle(3, 0xFF0000, 1);
                    _recBoundSprite.graphics.moveTo(_local4, _local5);
                    _recBoundSprite.graphics.lineTo((_local4 + _local2.width), _local5);
                    _recBoundSprite.graphics.lineTo((_local4 + _local2.width), (_local5 + _local2.height));
                    _recBoundSprite.graphics.lineTo(_local4, (_local5 + _local2.height));
                    _recBoundSprite.graphics.lineTo(_local4, _local5);
                };
            };
            if (this.parent){
                this.parent.addChild(_recBoundSprite);
            };
        }
        private function closeLightBound():void{
            if (((_recBoundSprite) && (_recBoundSprite.parent))){
                _recBoundSprite.parent.removeChild(_recBoundSprite);
            };
        }
        public function setVisible(_arg1:Boolean):void{
            this.visible = _arg1;
            if (_recBoundSprite){
                _recBoundSprite.visible = _arg1;
            };
        }
        private function loadBagEffect(_arg1:int, _arg2:int):void{
            var toX:* = _arg1;
            var toY:* = _arg2;
            var url:* = "Resources/Effect/BagSelectEffect.swf";
            var loadswfTool:* = new LoadSwfTool(url, false);
            loadswfTool.sendShow = function (_arg1:MovieClip):void{
                var _local2:MovieClip = _arg1;
                if (_local2){
                    _local2.x = toX;
                    _local2.y = toY;
                    if (_recBoundSprite){
                        _recBoundSprite.addChild(_local2);
                    };
                };
            };
            loadQueue.push(loadswfTool);
        }
        public function show(_arg1:DisplayObject, _arg2:String="", _arg3:int=2, ... _args):JianTouMc{
            target = _arg1;
            _dir = _arg3;
            if (((_jtMc) && (_jtMc.parent))){
                _jtMc.parent.removeChild(_jtMc);
            };
            if (((_tipsMc) && (_tipsMc.parent))){
                _tipsMc.parent.removeChild(_tipsMc);
            };
            if (((_closeBtn) && (_closeBtn.parent))){
                _closeBtn.parent.removeChild(_closeBtn);
            };
            _jtMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("JianTouAsset");
            _tipsMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GuideTipsAsset");
            _closeBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("NewGuidCloseBtn");
            _closeBtn.addEventListener(MouseEvent.CLICK, close);
            _closeBtn.visible = false;
            addChild(_jtMc);
            addChild(_tipsMc);
            addChild(_closeBtn);
            _tipsMc.tips.multiline = true;
            _tipsMc.tips.wordWrap = true;
            _tipsMc.tips.autoSize = TextFieldAutoSize.LEFT;
            _tipsMc.tips.y = 18;
            _tipsMc.tips.htmlText = _arg2;
            _tipsMc.tips.selectable = false;
            _tipsMc.tips.width = 150;
            _tipsMc.tips.width = ((_tipsMc.tips.textWidth < 130)) ? (_tipsMc.tips.textWidth + 20) : 150;
            _tipsMc.tips.height = _tipsMc.tips.textHeight;
            _tipsMc.bg.width = (_tipsMc.tips.width + 20);
            _tipsMc.bg.height = (_tipsMc.tips.height + 30);
            if ((((((target == null)) || ((target.parent == null)))) || ((target.stage == null)))){
                close();
                return (this);
            };
            setJTToTargetPostion(GameCommonData.GameInstance.TooltipLayer);
            if (_args.length > 0){
                if ((_args[0] is Array)){
                    rectangleArr = _args[0];
                } else {
                    rectangleArr = _args;
                };
                showLightBound(rectangleArr);
            } else {
                rectangleArr = [];
                closeLightBound();
            };
            if (_arg2 == ""){
                _tipsMc.visible = false;
                _closeBtn.visible = false;
            };
            return (this);
        }
        public function close(_arg1:MouseEvent=null):void{
            var _local2:Function;
            if (GameCommonData.GameInstance.TooltipLayer.contains(this)){
                GameCommonData.GameInstance.TooltipLayer.removeChild(this);
            };
            if (this.parent){
                this.parent.removeChild(this);
            };
            if (target){
                if (target.hasEventListener(MouseEvent.MOUSE_DOWN)){
                    target.removeEventListener(MouseEvent.MOUSE_DOWN, close);
                    if (clickCallBack){
                        _local2 = clickCallBack;
                        clickCallBack = null;
                        _local2();
                    };
                };
            };
            clearTimeout(timeoutId);
            closeLightBound();
        }

    }
}//package GameUI.Modules.NewGuide.Mediator 
