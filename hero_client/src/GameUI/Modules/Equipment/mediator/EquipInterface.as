//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Equipment.mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsFramework.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Mediator.*;
    import GameUI.Modules.FilterBag.Mediator.*;
    import GameUI.Modules.FilterBag.Proxy.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.*;

    public class EquipInterface extends Mediator implements IUpdateable {

        protected var oriMoneyColor:String = "#ffffff";
        protected var faceItem:Array;
        protected var moneyContainer:Sprite;
        private var enabled:Boolean = true;
        protected var commitFlag:Boolean = false;
        protected var localMS:Number;
        protected var equipItem:Array;
        public var dataProxy:DataProxy;
        protected var loadPro:MovieClip;
        protected var equipId:Array;
        protected var moneyTextField:TextField;
        protected var timeCounter:Number = 2000;

        public function EquipInterface(_arg1:String=null, _arg2:Object=null){
            super(_arg1, _arg2);
        }
        protected function textFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.font = LanguageMgr.DEFAULT_FONT;
            _local1.leading = 5;
            return (_local1);
        }
        protected function showView(_arg1:uint):void{
            if (dataProxy.ForgeOpenFlag == _arg1){
                return;
            };
            dataProxy.ForgeOpenFlag = _arg1;
            GameCommonData.GameInstance.GameUI.addChild((this.viewUI as EquipView));
            if (!dataProxy.FilterBagIsOpen){
                sendNotification(EventList.SHOWFILTERBAG);
                dataProxy.FilterBagIsOpen = true;
            } else {
                facade.sendNotification(EventList.UPDATEFILTERBAG);
            };
            if (dataProxy.BagIsOpen){
                sendNotification(EventList.CLOSEBAG);
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        protected function Cancel():void{
        }
        protected function onClosePanelHandler():void{
            dataProxy.EQUIP_OPER_POSX = viewUI.x;
            dataProxy.EQUIP_OPER_POSY = viewUI.y;
            commitFlag = false;
            loadPro.visible = false;
            dataProxy.ForgeOpenFlag = 0;
            GameCommonData.GameInstance.GameUI.removeChild(viewUI);
            viewUI.contentSprite.removeChild((facade.retrieveMediator(EquipMenuMediator.NAME) as EquipMenuMediator).equipMenu);
            viewUI.removeChild((facade.retrieveMediator(FilterBagMediator.NAME).getViewComponent() as MovieClip));
            if (dataProxy.FilterBagIsOpen){
                facade.sendNotification(EventList.CLOSEFILTERBAG);
            };
        }
        protected function resetLocation(_arg1:Boolean=false):void{
            if (_arg1){
                dataProxy.EQUIP_OPER_POSX = ((GameCommonData.GameInstance.ScreenWidth - EquipDataConst.WIDTH) / 2);
                dataProxy.EQUIP_OPER_POSY = ((GameCommonData.GameInstance.ScreenHeight - EquipDataConst.HEIGHT) / 2);
            };
            this.viewUI.x = dataProxy.EQUIP_OPER_POSX;
            this.viewUI.y = dataProxy.EQUIP_OPER_POSY;
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        protected function addEquip(_arg1:UseItem, _arg2:uint):void{
        }
        public function get Enabled():Boolean{
            return (enabled);
        }
        protected function initViewUI(_arg1:EquipView):void{
            setViewComponent(_arg1);
            this.viewUI.btn_commit.addEventListener(MouseEvent.CLICK, onCommitHandler);
            this.moneyContainer = new Sprite();
            this.moneyTextField = new TextField();
            this.moneyTextField.filters = OopsEngine.Graphics.Font.Stroke();
            this.moneyTextField.defaultTextFormat = this.textFormat();
            this.moneyTextField.width = 600;
            this.moneyTextField.autoSize = TextFieldAutoSize.LEFT;
            this.moneyTextField.wordWrap = false;
            this.moneyTextField.mouseEnabled = false;
            this.moneyTextField.selectable = false;
            this.moneyContainer.addChild(this.moneyTextField);
            this.viewUI.content.addChild(moneyContainer);
            loadPro = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("CollectProgressAsset");
            loadPro.progressMc.mask = loadPro.progressMask;
            loadPro.TargetNameTF.text = "";
            this.viewUI.content.addChild(loadPro);
            loadPro.progressMask.width = 0;
            loadPro.visible = false;
            loadPro.x = 80;
            loadPro.y = 230;
            moneyContainer.x = 123;
            moneyContainer.y = 215;
        }
        protected function onContainerMouseClickHandler(_arg1:MouseEvent):void{
            if (commitFlag){
                return;
            };
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            var _local3:uint = _arg1.target.name.split("_")[2].toString();
            removeItem((_local2 as FaceItem), true, equipItem[_local3]);
            faceItem[_local3] = null;
            equipItem[_local3] = null;
            equipId[_local3] = 0;
        }
        protected function addItemEvent(_arg1:FaceItem):void{
            _arg1.addEventListener(MouseEvent.CLICK, onContainerMouseClickHandler);
            _arg1.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
            _arg1.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
        }
        protected function removeItem(_arg1:FaceItem, _arg2:Boolean=true, _arg3:UseItem=null):void{
            if (((_arg1) && (_arg1.parent))){
                SetFrame.RemoveFrame(_arg1.parent, "RedFrame");
                SetFrame.RemoveFrame(_arg1.parent);
                if (_arg1.hasEventListener(MouseEvent.MOUSE_OVER)){
                    _arg1.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
                };
                if (_arg1.hasEventListener(MouseEvent.MOUSE_OUT)){
                    _arg1.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
                };
                if (MouseEvent.CLICK){
                    _arg1.removeEventListener(MouseEvent.CLICK, onContainerMouseClickHandler);
                };
                if (_arg2){
                    _arg1.parent.removeChild(_arg1);
                    _arg1 = null;
                    if (_arg3){
                        this.cancelLock(_arg3);
                        _arg3 = null;
                    };
                };
            };
        }
        protected function commitEquip():void{
        }
        protected function closePanelHandler():void{
        }
        protected function comfirm():void{
        }
        protected function cancelLock(_arg1:UseItem):void{
            if (_arg1 == null){
                return;
            };
            _arg1.IsLock = false;
            sendNotification(EventList.FILTERBAGITEMUNLOCK, _arg1.Id);
        }
        protected function onMouseOutHandler(_arg1:MouseEvent):void{
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            SetFrame.RemoveFrame(_local2.parent, "RedFrame");
        }
        override public function handleNotification(_arg1:INotification):void{
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        protected function lockItem(_arg1:uint):void{
            var _local2:uint;
            _local2 = 0;
            while (_local2 < FilterBagData.AllItems[0].length) {
                if (((FilterBagData.AllItems[0][_local2]) && ((FilterBagData.AllItems[0][_local2].ItemGUID == _arg1)))){
                    FilterBagData.GridUnitList[_local2].Item.IsLock = true;
                    FilterBagData.AllLocks[0][_local2] = true;
                    break;
                };
                _local2++;
            };
        }
        public function Update(_arg1:GameTime):void{
            if (commitFlag == false){
                return;
            };
            localMS = (localMS + ((1 / 12) * 1000));
            loadPro.progressMask.width = (((localMS * 1) / timeCounter) * loadPro.progressMc.width);
            loadPro.lightAsset.x = (loadPro.progressMask.x + loadPro.progressMask.width);
            loadPro.load_txt.text = (int((100 * ((localMS * 1) / timeCounter))) + "%");
            if (localMS > timeCounter){
                loadPro.visible = false;
                commitEquip();
                commitFlag = false;
            };
        }
        public function get UpdateOrder():int{
            return (0);
        }
        protected function InventoryItem(_arg1:UseItem):InventoryItemInfo{
            var _local4:uint;
            var _local2:InventoryItemInfo;
            var _local3:uint = FilterBagData.AllItems[0][_arg1.Pos].Place;
            if (_local3 >= ItemConst.EQUIP_SLOT_END){
                _local4 = ItemConst.placeToOffset(_local3);
                _local2 = BagData.AllItems[0][_local4];
            } else {
                _local2 = RolePropDatas.ItemList[_local3];
            };
            return (_local2);
        }
        protected function changeMoney(_arg1:int, _arg2:String):void{
            var _local3:uint;
            this.moneyTextField.width = 300;
            var _local4:String = _arg2;
            if (GameCommonData.Player.Role.Gold < _arg1){
                _local4 = _local4.replace(oriMoneyColor, "#ff0000");
            };
            this.moneyTextField.htmlText = _local4;
            ShowMoney.ShowIcon(this.moneyContainer, this.moneyTextField, true);
        }
        protected function onMouseOverHandler(_arg1:MouseEvent):void{
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            SetFrame.UseFrame2(_local2, "RedFrame", 0, 0, 40, 40);
        }
        override public function listNotificationInterests():Array{
            return ([]);
        }
        public function get viewUI():EquipView{
            return ((this.viewComponent as EquipView));
        }
        protected function onCommitHandler(_arg1:MouseEvent):void{
        }

    }
}//package GameUI.Modules.Equipment.mediator 
