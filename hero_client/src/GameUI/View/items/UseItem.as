//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.items {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import flash.filters.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.Depot.Data.*;
    import GameUI.*;

    public class UseItem extends ItemBase {

        public var dragFlag:uint;
        private var startDragTmp:Sprite = null;
        private var _itemIemplateInfo:ItemTemplateInfo;
        private var lockIcon:Bitmap = null;
        private var noFitJobShape:Shape;
        public var ContentHeight:int = 0;
        public var canUseIt:Boolean = true;
        private var dataProxy:DataProxy;
        public var ContentWidth:int = 0;
        private var icon:Bitmap;

        public function UseItem(_arg1:int, _arg2:int, _arg3:DisplayObjectContainer, _arg4:uint=0, _arg5:uint=0){
            var _local6:String;
            var _local10:ItemTemplateInfo;
            var _local11:uint;
            iconType = _arg5;
            tf = new TextField();
            var _local7:* = UIConstData.ItemDic;
            if (_arg2 != 0){
                _local10 = UIConstData.ItemDic[String(_arg2)];
                if (((((((_local10) && ((_local10.MainClass == ItemConst.ITEM_CLASS_USABLE)))) && ((_local10.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))) && ((_local10.HpBonus > 4)))){
                    if (_arg4 != 0){
                        _local11 = 0;
                        if (BagData.getItemById(_arg4)){
                            _local11 = (BagData.getItemById(_arg4).Add1 * 10);
                        } else {
                            _local11 = (DepotConstData.getItemById(_arg4).Add1 * 10);
                        };
                        _local6 = String((_local10.img + _local11));
                    } else {
                        _local6 = String(_local10.img);
                    };
                } else {
                    if (_local10){
                        _local6 = String(_local10.img);
                    };
                };
            };
            var _local8:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BuffGrid");
            _local8.gotoAndStop(1);
            var _local9:BitmapData = new BitmapData(_local8.width, _local8.height);
            _local9.draw(_local8);
            this.icon = new Bitmap(_local9);
            this.addChildAt(this.icon, 0);
            super(_local6, _arg3);
            this.Type = _arg2;
            this.Id = _arg4;
            tf.filters = OopsEngine.Graphics.Font.Stroke(0);
            tf.mouseEnabled = false;
            tf.selectable = false;
            this.Pos = _arg1;
            dragFlag = 0;
            dataProxy = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
            this._itemIemplateInfo = (UIConstData.ItemDic[_arg2] as ItemTemplateInfo);
        }
        private function removeFrame(_arg1:DisplayObjectContainer):void{
            if (_arg1){
                if (_arg1.getChildByName("yellowFrame")){
                    _arg1.removeChild(_arg1.getChildByName("yellowFrame"));
                };
            };
        }
        public function setEnable(_arg1:Boolean):void{
            this.mouseChildren = _arg1;
            this.mouseEnabled = _arg1;
        }
        public function setContentWH(_arg1:int, _arg2:int):void{
            this.ContentWidth = _arg1;
            this.ContentHeight = _arg2;
            WIDTH = ContentWidth;
            HEIGHT = ContentHeight;
            if (icon){
                onLoabdComplete();
            };
        }
        private function gameUIMouseDown(_arg1:MouseEvent):void{
            var _local3:int;
            var _local4:Object;
            var _local2:String = _arg1.target.name.split("_")[0];
            if ((((((((_local2 == "key")) || ((_local2 == "keyF")))) || ((_local2 == "autoPlayHp")))) || ((_local2 == "autoPlayMp")))){
                return;
            };
            if (((dataProxy.BagIsSplit) || (dataProxy.BagIsDestory))){
                _local3 = int(_arg1.target.name.split("_")[1]);
                _local4 = new Object();
                if (_local2 == "UILayer"){
                } else {
                    _local4.type = _local2;
                    _local4.index = _local3;
                    _local4.target = _arg1.target;
                    _local4.source = this;
                    this.dispatchEvent(new DropEvent(DropEvent.DRAG_DROPPED, _local4));
                };
                return;
            };
            if ((((dragFlag == 1)) && (!((UIConstData.PanelGridList.indexOf(_local2) == -1))))){
                dragFlag = 0;
                return;
            };
            dragFlag = 0;
            dataProxy.BagIsDrag = false;
            removeFrame(_arg1.target.parent);
            GameCommonData.GameInstance.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GameCommonData.GameInstance.GameUI.mouseEnabled = false;
            if (startDragTmp){
                startDragTmp.stopDrag();
                if (startDragTmp.parent){
                    startDragTmp.parent.removeChild(startDragTmp);
                };
                startDragTmp = null;
            };
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
            _local3 = int(_arg1.target.name.split("_")[1]);
            _local4 = new Object();
            if (_local2 == "UILayer"){
                this.dispatchEvent(new DropEvent(DropEvent.DRAG_THREW, this));
            } else {
                _local4.type = _local2;
                _local4.index = _local3;
                _local4.target = _arg1.target;
                _local4.source = this;
                this.dispatchEvent(new DropEvent(DropEvent.DRAG_DROPPED, _local4));
            };
        }
        public function setNoFitJobShape(_arg1:Boolean):void{
            if (_arg1){
                if (this.noFitJobShape == null){
                    this.noFitJobShape = new Shape();
                    this.noFitJobShape.graphics.clear();
                    this.noFitJobShape.graphics.beginFill(0, 0.5);
                    this.noFitJobShape.graphics.drawRect(0, 0, 32, 32);
                    this.noFitJobShape.graphics.endFill();
                };
                this.addChild(this.noFitJobShape);
            } else {
                if (((!((this.noFitJobShape == null))) && (this.contains(this.noFitJobShape)))){
                    this.removeChild(this.noFitJobShape);
                };
            };
        }
        public function set itemIemplateInfo(_arg1:ItemTemplateInfo):void{
            _itemIemplateInfo = _arg1;
        }
        override public function reset():void{
            super.reset();
            ResourcesFactory.getInstance().deleteCallBackFun((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + iconName) + ".png"), onLoabdComplete);
            if (((!((this.icon == null))) && (this.contains(this.icon)))){
                this.removeChild(this.icon);
            };
            this.icon = null;
            if (((!((this.startDragTmp == null))) && (!((this.startDragTmp.parent == null))))){
                this.startDragTmp.parent.removeChild(this.startDragTmp);
            };
            this.startDragTmp = null;
            if (((!((this.noFitJobShape == null))) && (this.contains(this.noFitJobShape)))){
                this.removeChild(this.noFitJobShape);
            };
            clearThumbLock();
        }
        public function clearThumbLock():void{
            if (((lockIcon) && (this.contains(lockIcon)))){
                this.removeChild(lockIcon);
            };
        }
        override protected function onLoabdComplete():void{
            super.onLoabdComplete();
            this.removeChild(this.icon);
            if (iconType == 0){
                this.icon = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/bagIcon/") + this.iconName) + ".png"));
            } else {
                this.icon = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/icon/") + this.iconName) + ".png"));
            };
            if (icon == null){
                icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("NoResource");
            };
            if (((!((ContentWidth == 0))) && (!((ContentHeight == 0))))){
                icon.width = ContentWidth;
                icon.height = ContentHeight;
            };
            icon.smoothing = true;
            this.addChildAt(icon, 0);
            tf.width = WIDTH;
            tf.height = TXTHEIGHT;
            tf.x = 2;
            tf.y = ((HEIGHT - TXTHEIGHT) + 3);
            tf.setTextFormat(UIUtils.getTextFormat());
            this.addChildAt(tf, 1);
            if (this.getChildByName("maskLock")){
                this.setChildIndex(this.getChildByName("maskLock"), (this.numChildren - 1));
            };
        }
        public function setBroken(_arg1:uint):void{
            var _local2:Array;
            var _local3:ColorMatrixFilter;
            if (_arg1){
                _local2 = [0.2, 0.2, 0.2, 0, 0, 0.2, 0.2, 0.2, 0, 0, 0.2, 0.2, 0.2, 0, 0, 0, 0, 0, 1, 0];
                _local3 = new ColorMatrixFilter(_local2);
                this.filters = [_local3];
            } else {
                this.filters = [];
            };
        }
        public function setThumbLock():void{
            lockIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("LockIcon");
            lockIcon.y = 22;
            this.addChild(lockIcon);
        }
        private function mouseOutHandler(_arg1:MouseEvent):void{
            gc();
        }
        public function gc():void{
            GameCommonData.GameInstance.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
            GameCommonData.GameInstance.GameUI.mouseEnabled = false;
            if (startDragTmp){
                startDragTmp.stopDrag();
                if (startDragTmp.parent){
                    startDragTmp.parent.removeChild(startDragTmp);
                };
                startDragTmp = null;
                dragFlag = 0;
                dataProxy.BagIsDrag = false;
            };
        }
        public function get itemIemplateInfo():ItemTemplateInfo{
            return (_itemIemplateInfo);
        }
        public function onMouseDown():void{
            var _local1:Bitmap;
            var _local2:BitmapData;
            var _local3:Point;
            this.ItemParent = this.parent;
            tmpX = this.x;
            tmpY = this.y;
            if ((((dataProxy.BagIsSplit == false)) && ((dataProxy.BagIsDestory == false)))){
                _local1 = new Bitmap();
                _local2 = new BitmapData(WIDTH, HEIGHT);
                _local2.draw(this.icon);
                _local1.bitmapData = _local2;
                startDragTmp = DragManager.DragItem;
                startDragTmp.alpha = 0.8;
                startDragTmp.addChild(_local1);
                startDragTmp.mouseChildren = false;
                startDragTmp.mouseEnabled = false;
                _local3 = (this.ItemParent.localToGlobal(new Point(this.x, this.y)) as Point);
                startDragTmp.x = _local3.x;
                startDragTmp.y = _local3.y;
                startDragTmp.startDrag();
                GameCommonData.GameInstance.GameUI.addChild(startDragTmp);
                startDragTmp.name = "useItemTmp";
                dragFlag = 1;
                dataProxy.BagIsDrag = true;
            };
            GameCommonData.GameInstance.GameUI.addEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
            GameCommonData.GameInstance.GameUI.addEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            GameCommonData.GameInstance.GameUI.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GameCommonData.GameInstance.GameUI.mouseEnabled = true;
            GameCommonData.GameInstance.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
        }
        override public function set Num(_arg1:int):void{
            this.num = _arg1;
            tf.visible = true;
            tf.text = _arg1.toString();
            if (_arg1 <= 1){
                tf.visible = false;
            };
            tf.setTextFormat(UIUtils.getTextFormat());
        }
        public function canUse(_arg1:Boolean):void{
            setNoFitJobShape(!(_arg1));
            canUseIt = _arg1;
        }
        override public function get Num():int{
            return (this.num);
        }
        public function resetIcon(_arg1:String):void{
            this.iconName = _arg1;
            loadIcon();
        }
        private function gameUIMouseUp(_arg1:MouseEvent):void{
            var _local2:String = _arg1.target.name.split("_")[0];
            if (((((((((((((((((((!((dragFlag == 2))) && (!((_local2 == "key"))))) && (!((_local2 == "keyF"))))) && (!((_local2 == "autoPlayHp"))))) && (!((_local2 == "autoPlayMp"))))) && (!((_local2 == "stall"))))) && (!((_local2 == "stalldown"))))) && (!((_local2 == "mcPhoto"))))) && (!((_local2 == "donateprop"))))) && (!((_local2 == "NPCShopSale"))))){
                return;
            };
            dataProxy.BagIsDrag = false;
            dragFlag = 0;
            removeFrame(_arg1.target.parent);
            GameCommonData.GameInstance.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GameCommonData.GameInstance.GameUI.mouseEnabled = false;
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_DOWN, gameUIMouseDown);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
            if (startDragTmp){
                startDragTmp.stopDrag();
                if (startDragTmp.parent){
                    startDragTmp.parent.removeChild(startDragTmp);
                };
                startDragTmp = null;
            };
            var _local3:String = _arg1.target.name.split("_")[0];
            var _local4:int = int(_arg1.target.name.split("_")[1]);
            if (UIConstData.TipsItemList.indexOf(_local3) != -1){
                _local4 = int(_arg1.target.name.split("_")[2]);
            };
            var _local5:Object = new Object();
            if (_local3 == "UILayer"){
                this.dispatchEvent(new DropEvent(DropEvent.DRAG_THREW, this));
            } else {
                _local5.type = _local3;
                _local5.index = _local4;
                _local5.target = _arg1.target;
                _local5.source = this;
                this.dispatchEvent(new DropEvent(DropEvent.DRAG_DROPPED, _local5));
            };
        }
        override public function init(_arg1:String, _arg2:DisplayObjectContainer, _arg3:uint=0, _arg4:String="bagIcon"):void{
            var _local5:String;
            tf = new TextField();
            _local5 = String(UIConstData.ItemDic[_arg1].img);
            var _local6:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BuffGrid");
            _local6.gotoAndStop(1);
            var _local7:BitmapData = new BitmapData(_local6.width, _local6.height);
            _local7.draw(_local6);
            this.icon = new Bitmap(_local7);
            this.addChildAt(this.icon, 0);
            super.init(_local5, _arg2);
            this.Type = uint(_arg1);
            tf.filters = OopsEngine.Graphics.Font.Stroke(0);
            tf.mouseEnabled = false;
            tf.selectable = false;
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            if (startDragTmp){
                dragFlag = 2;
                GameCommonData.GameInstance.GameUI.setChildIndex(startDragTmp, (GameCommonData.GameInstance.GameUI.numChildren - 1));
                _arg1.updateAfterEvent();
            };
        }

    }
}//package GameUI.View.items 
