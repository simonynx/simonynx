//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.display.*;
    import OopsFramework.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import Utils.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.*;

    public class ItemBase extends Sprite implements IUpdateable {

        public static const OFFSET:uint = 2;
        public static const TXTHEIGHT:uint = 16;

        protected var num:Number = 0;
        private var _info:InventoryItemInfo;
        protected var mkDir:String = "bagIcon";
        private var maskShape:Shape;
        public var tmpX:Number = 0;
        public var tmpY:Number = 0;
        public var iconName:String = "";
        public var IsBind:uint = 0;
        protected var cdDelay:uint;
        private var totalCount:int;
        public var WIDTH:uint = 32;
        public var HEIGHT:uint = 32;
        private var maskLock:Shape;
        public var IsCdTimer:Boolean = false;
        public var ItemParent:DisplayObjectContainer = null;
        public var IsBroken:uint = 0;
        public var Pos:int = -1;
        protected var maxCD:Number = 25;
        private var isEnable:Boolean = true;
        private var startTime:int;
        public var cdTotalTime:uint;
        protected var textX:int = -1;
        public var iconType:uint = 0;
        public var curCdCount:Number;
        private var _Id:int = 0;
        protected var textY:int = -1;
        public var Type:int = 0;
        private var nextTime:int;
        private var maskRect:Rectangle;
        protected var tf:TextField;
        protected var isLock:Boolean = false;
        protected var cdLayer:UICoolDownView;
        private var timeFactor:Number;

        public function ItemBase(_arg1:String, _arg2:DisplayObjectContainer, _arg3:String="bagIcon"){
            maskRect = new Rectangle(0, 0, 32, 32);
            super();
            this.cacheAsBitmap = true;
            tf = new TextField();
            this.iconName = _arg1;
            this.doubleClickEnabled = true;
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.ItemParent = _arg2;
            this.mkDir = _arg3;
            if (iconType == 1){
                mkDir = "icon";
            };
            loadIcon();
            tf.filters = OopsEngine.Graphics.Font.Stroke(0);
            tf.mouseEnabled = false;
            tf.selectable = false;
            this.maskLock = new Shape();
            this.maskShape = new Shape();
        }
        public function Update(_arg1:GameTime):void{
            this.nextTime = getTimer();
            var _local2:Number = ((this.nextTime - this.startTime) * this.timeFactor);
            if (_local2 >= 4){
                this.startTime = this.nextTime;
                cdTime(_local2);
            };
        }
        public function clearCd():void{
            IsCdTimer = false;
            GameCommonData.GameInstance.GameUI.Elements.Remove(this);
            if (this.contains(cdLayer)){
                this.removeChild(cdLayer);
            };
        }
        public function init(_arg1:String, _arg2:DisplayObjectContainer, _arg3:uint=0, _arg4:String="bagIcon"):void{
            this.cacheAsBitmap = true;
            tf = new TextField();
            this.iconName = _arg1;
            this.Type = uint(_arg1);
            this.doubleClickEnabled = true;
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.ItemParent = _arg2;
            this.mkDir = _arg4;
            loadIcon();
            tf.filters = OopsEngine.Graphics.Font.Stroke(0);
            tf.mouseEnabled = false;
            tf.selectable = false;
            this.maskLock = new Shape();
            this.maskShape = new Shape();
        }
        public function get Enabled():Boolean{
            return (true);
        }
        public function set MaskRect(_arg1:Rectangle):void{
            maskRect = _arg1;
        }
        public function set IsLock(_arg1:Boolean):void{
            if (this.isLock == _arg1){
                return;
            };
            this.isLock = _arg1;
            if (_arg1){
                this.maskLock.graphics.clear();
                maskLock.graphics.beginFill(0xFF0000, 0.6);
                maskLock.graphics.drawRect(0, 0, 32, 32);
                maskLock.graphics.endFill();
                this.addChild(maskLock);
            } else {
                if (this.contains(this.maskLock)){
                    this.removeChild(this.maskLock);
                };
            };
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        protected function onLoabdComplete():void{
            tf.width = WIDTH;
            tf.height = TXTHEIGHT;
            if ((((textX == -1)) && ((textY == -1)))){
                tf.x = 2;
                tf.y = ((HEIGHT - TXTHEIGHT) + 3);
            } else {
                tf.x = 2;
                tf.y = (textY + 3);
            };
            tf.setTextFormat(UIUtils.getTextFormat());
            this.addChild(tf);
        }
        public function set Enabled(_arg1:Boolean):void{
            if (this.isEnable == _arg1){
                return;
            };
            this.isEnable = _arg1;
            if (_arg1){
                if (this.contains(this.maskShape)){
                    this.removeChild(this.maskShape);
                };
            } else {
                this.maskShape.graphics.clear();
                maskShape.graphics.beginFill(0, 0.5);
                maskShape.graphics.drawRect(maskRect.x, maskRect.y, maskRect.width, maskRect.height);
                maskShape.graphics.endFill();
                this.addChild(maskShape);
            };
        }
        public function get Id():int{
            return (_Id);
        }
        public function reset():void{
            ResourcesFactory.getInstance().deleteCallBackFun((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + iconName) + ".png"), onLoabdComplete);
            num = 0;
            isLock = false;
            mkDir = "bagIcon";
            if (iconType == 1){
                mkDir = "icon";
            };
            tmpX = 0;
            tmpY = 0;
            Pos = -1;
            ItemParent = null;
            iconName = "";
            IsBind = 0;
            Type = 0;
            Id = 0;
            if (((!((this.cdLayer == null))) && (this.contains(cdLayer)))){
                this.removeChild(cdLayer);
            };
            curCdCount = 0;
            cdTotalTime = 0;
            GameCommonData.GameInstance.GameUI.Elements.Remove(this);
            IsCdTimer = false;
            isEnable = true;
            maskRect = new Rectangle(0, 0, 32, 32);
            if (((!((tf == null))) && (this.contains(tf)))){
                this.removeChild(tf);
            };
            this.tf = null;
            if (this.contains(this.maskShape)){
                this.removeChild(this.maskShape);
            };
            if (this.contains(this.maskLock)){
                this.removeChild(this.maskLock);
            };
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        public function startCd(_arg1:uint, _arg2:int):void{
            if (this.IsCdTimer){
                return;
            };
            if (cdLayer == null){
                cdLayer = new UICoolDownView();
            };
            this.addChild(cdLayer);
            this.curCdCount = _arg2;
            this.cdTotalTime = _arg1;
            this.totalCount = (240 - curCdCount);
            this.timeFactor = (this.totalCount / this.cdTotalTime);
            this.cdLayer.update(curCdCount);
            this.startTime = getTimer();
            IsCdTimer = true;
            GameCommonData.GameInstance.GameUI.Elements.Add(this);
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function set otherEnable(_arg1:Boolean):void{
            if (_arg1){
                this.filters = null;
            } else {
                this.filters = [ColorFilters.BWFilter];
            };
        }
        public function get IsLock():Boolean{
            return (this.isLock);
        }
        public function get Num():int{
            return (this.num);
        }
        public function set Id(_arg1:int):void{
            _Id = _arg1;
            _info = IntroConst.ItemInfo[_Id];
            if (_info != null){
                IsBind = _info.isBind;
                IsBroken = _info.isBroken;
            };
        }
        public function set Num(_arg1:int):void{
            this.num = _arg1;
            tf.visible = true;
            tf.text = _arg1.toString();
            if (_arg1 == 1){
                tf.visible = false;
            };
            tf.setTextFormat(UIUtils.getTextFormat());
        }
        protected function cdTime(_arg1:Number):void{
            this.curCdCount = (this.curCdCount + _arg1);
            if (cdLayer == null){
                GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                return;
            };
            if (this.curCdCount >= 240){
                IsCdTimer = false;
                if (this.contains(cdLayer)){
                    this.removeChild(cdLayer);
                };
                GameCommonData.GameInstance.GameUI.Elements.Remove(this);
            } else {
                this.cdLayer.update(this.curCdCount);
            };
        }
        protected function loadIcon():void{
            if (mkDir == "face"){
                ResourcesFactory.getInstance().getResource(((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + iconName) + ".jpg?v=") + GameConfigData.FaceVersion), onLoabdComplete);
            } else {
                if (mkDir == "NPCPic"){
                    ResourcesFactory.getInstance().getResource(((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + iconName) + ".swf?v=") + GameConfigData.FaceVersion), onLoabdComplete);
                } else {
                    ResourcesFactory.getInstance().getResource(((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + iconName) + ".png?v=") + GameConfigData.ItemIconVersion), onLoabdComplete);
                };
            };
        }

    }
}//package GameUI.View.BaseUI 
