//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.HeroSkill.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsFramework.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.MainScene.Data.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.AutoPlay.Data.*;

    public class NewSkillCell extends Sprite implements IUpdateable {

        private var startDragTmp:Sprite;
        private var iconBitmap:Bitmap;
        private var isLoadComplete:Boolean;
        protected var _skillInfo:SkillInfo;
        protected var cdDelay:uint;
        private var totalCount:int;
        private var isMaigcWeaponSkill:Boolean = false;
        private var isCanMove:Boolean;
        public var IsCdTimer:Boolean;
        public var isLearn:Boolean = false;
        private var _height:Number = 32;
        public var curCdCount:Number;
        private var startTime:int;
        public var cdTotalTime:uint;
        protected var _layer:int;
        protected var _index:int;
        private var _width:Number = 32;
        private var nextTime:int;
        public var dragEnabled:Boolean = true;
        protected var cdLayer:UICoolDownView;
        protected var icon:Bitmap;
        private var timeFactor:Number;
        protected var _job:int;

        public function NewSkillCell(_arg1:int=0, _arg2:int=0, _arg3:int=0){
            _index = _arg3;
            _job = _arg1;
            _layer = _arg2;
            init();
            initEvent();
        }
        public function get isAuto():Boolean{
            if (_skillInfo){
                return (_skillInfo.isAuto);
            };
            return (false);
        }
        public function setSize(_arg1:Number, _arg2:Number):void{
            this._width = _arg1;
            this._height = _arg2;
        }
        public function getIconBitmap():Bitmap{
            return (iconBitmap);
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        public function setGuildSKillInfo(_arg1:SkillInfo):void{
            _skillInfo = _arg1;
            _job = 100;
            loadIcon();
        }
        private function init():void{
            this.name = "skillCell";
            this.cacheAsBitmap = true;
            _skillInfo = SkillManager.getSkillInfo(_job, _layer, _index);
            if (_skillInfo != null){
                loadIcon();
            };
            QuickBarData.SkillItemList.push(this);
        }
        public function clearCd():void{
            IsCdTimer = false;
            if (this.contains(cdLayer)){
                this.removeChild(cdLayer);
            };
            GameCommonData.GameInstance.GameUI.Elements.Remove(this);
        }
        public function get skillInfo():SkillInfo{
            return (_skillInfo);
        }
        public function get Enabled():Boolean{
            return (true);
        }
        private function onDownCell(_arg1:MouseEvent):void{
            if ((((((this.mouseX <= 2)) || ((this.mouseY >= (this.width - 2))))) || ((((this.mouseY <= 2)) || ((this.mouseY >= (this.height - 2))))))){
                return;
            };
            if (isMaigcWeaponSkill == true){
                return;
            };
            if (!dragEnabled){
                return;
            };
            if (!isLoadComplete){
                return;
            };
            if ((((this.isLearn == false)) || ((this.skillInfo.Type == SkillInfo.ATTRIBUTES_PASSIVE)))){
                return;
            };
            this.addEventListener(MouseEvent.MOUSE_MOVE, onCellMove);
            isCanMove = true;
            _arg1.stopImmediatePropagation();
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function startCd(_arg1:uint, _arg2:int):void{
            if (this.IsCdTimer){
                return;
            };
            if (cdLayer == null){
                cdLayer = new UICoolDownView(this._width, this._height);
            };
            this.addChild(cdLayer);
            this.curCdCount = _arg2;
            this.totalCount = (240 - curCdCount);
            this.cdTotalTime = _arg1;
            this.timeFactor = (this.totalCount / this.cdTotalTime);
            this.cdLayer.update(curCdCount);
            this.startTime = getTimer();
            IsCdTimer = true;
            GameCommonData.GameInstance.GameUI.Elements.Add(this);
        }
        public function setData(_arg1:int, _arg2:int):void{
            _job = _arg1;
            _layer = _arg2;
            var _local3:uint = 6;
            while (_local3 > 0) {
                _skillInfo = SkillManager.getMySkillInfo(_job, _layer, _index, _local3);
                if (_skillInfo != null){
                    this.isLearn = true;
                    return;
                };
                _local3--;
            };
            this.isLearn = false;
            _skillInfo = SkillManager.getSkillInfo(_job, _layer, _index);
            if (_skillInfo != null){
                if (icon == null){
                    loadIcon();
                };
            };
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function updateInfo():void{
            setData(_job, _layer);
        }
        public function setLearnSkillInfo(_arg1:SkillInfo):void{
            if (icon){
                if (icon.parent){
                    icon.parent.removeChild(icon);
                };
                icon = null;
            };
            if (_arg1 != null){
                _skillInfo = _arg1;
                _job = _skillInfo.Job;
                _index = _skillInfo.Index;
                _layer = _skillInfo.JobLevel;
                loadIcon();
                if (SkillManager.getMyIdSkillInfo(_skillInfo.Id) != null){
                    this.isLearn = true;
                } else {
                    this.isLearn = false;
                };
            } else {
                _skillInfo = null;
                _job = 0;
                _index = 0;
                _layer = 0;
                this.isLearn = false;
            };
            if (this.isLearn){
                this.filters = null;
            } else {
                this.filters = [ColorFilters.BlackGoundFilter];
            };
        }
        public function setPetSkillInfo(_arg1:SkillInfo):void{
            _skillInfo = _arg1;
            _job = 6;
            loadIcon();
        }
        private function gameUIMouseUp(_arg1:MouseEvent):void{
            this.removeEventListener(MouseEvent.MOUSE_MOVE, onCellMove);
            GameCommonData.GameInstance.GameUI.mouseEnabled = false;
            startDragTmp.stopDrag();
            if (startDragTmp.parent){
                GameCommonData.GameInstance.GameUI.removeChild(startDragTmp);
            };
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
            startDragTmp = null;
            var _local2:String = _arg1.target.name.split("_")[0];
            var _local3:int = int(_arg1.target.name.split("_")[1]);
            var _local4:Object = new Object();
            if (_local2 == "UILayer"){
                this.dispatchEvent(new DropEvent(DropEvent.DRAG_THREW, this));
            } else {
                _local4.type = _local2;
                _local4.index = _local3;
                _local4.target = _arg1.target;
                _local4.source = this;
                this.dispatchEvent(new DropEvent(DropEvent.DRAG_DROPPED, _local4));
                if (this.name.indexOf("key") == -1){
                    UIFacade.GetInstance().dragSkillItem(_local4);
                };
            };
        }
        public function dispose():void{
            this.removeEventListener(MouseEvent.MOUSE_MOVE, onCellMove);
            this.removeEventListener(MouseEvent.MOUSE_DOWN, onDownCell);
            this.removeEventListener(MouseEvent.MOUSE_UP, onCellUp);
            GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
            if (icon){
                if (icon.parent){
                    icon.parent.removeChild(icon);
                };
            };
            startDragTmp = null;
            var _local1:int = QuickBarData.SkillItemList.indexOf(this);
            if (_local1 > -1){
                QuickBarData.SkillItemList.splice(_local1, 1);
            };
        }
        protected function cdTime(_arg1:Number):void{
            this.curCdCount = (this.curCdCount + _arg1);
            if (cdLayer == null){
                GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                return;
            };
            this.setChildIndex(cdLayer, (this.numChildren - 1));
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
        private function onCellMove(_arg1:MouseEvent):void{
            var _local2:Point;
            this.removeEventListener(MouseEvent.MOUSE_MOVE, onCellMove);
            if (isCanMove){
                if (this.IsCdTimer){
                    UIFacade.GetInstance().ShowHint(LanguageMgr.GetTranslation("技能cd中无法拖动"));
                    return;
                };
                startDragTmp = DragManager.DragItem;
                startDragTmp.alpha = 0.8;
                startDragTmp.addChild(iconBitmap);
                startDragTmp.mouseChildren = false;
                startDragTmp.mouseEnabled = false;
                _local2 = (this.localToGlobal(new Point(this.x, this.y)) as Point);
                startDragTmp.x = _local2.x;
                startDragTmp.y = _local2.y;
                startDragTmp.startDrag();
                GameCommonData.GameInstance.GameUI.addChild(startDragTmp);
                GameCommonData.GameInstance.GameUI.addEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
                GameCommonData.GameInstance.GameUI.mouseEnabled = true;
            };
            isCanMove = false;
        }
        public function get index():int{
            return (this._index);
        }
        public function setWeaponSkill(_arg1:InventoryItemInfo):void{
            isMaigcWeaponSkill = true;
            if (_arg1 == null){
                AutoPlayData.MagicWeaponSkillId = 0;
                _skillInfo = null;
                _job = 0;
                if (icon){
                    if (icon.parent){
                        icon.parent.removeChild(icon);
                    };
                    icon = null;
                };
                return;
            };
            var _local2:int = ((_arg1.AdditionFields[0] * 100) + _arg1.Enchanting);
            if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_AUXILIARY]){
                if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_AUXILIARY].AdditionFields[0] == _arg1.AdditionFields[0]){
                    _local2++;
                };
            };
            if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_SECRETBOOK]){
                if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_SECRETBOOK].AdditionFields[0] == _arg1.AdditionFields[0]){
                    _local2++;
                };
            };
            _skillInfo = GameCommonData.SkillList[_local2];
            _job = int((_arg1.AdditionFields[0] / 1000));
            _skillInfo.TypeID = _arg1.AdditionFields[0];
            AutoPlayData.MagicWeaponSkillId = _local2;
            loadIcon();
        }
        private function onCellUp(_arg1:MouseEvent):void{
            this.removeEventListener(MouseEvent.MOUSE_MOVE, onCellMove);
            isCanMove = false;
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function Update(_arg1:GameTime):void{
            this.nextTime = getTimer();
            var _local2:Number = ((this.nextTime - this.startTime) * this.timeFactor);
            if (_local2 >= 8){
                this.startTime = this.nextTime;
                cdTime(_local2);
            };
        }
        private function initEvent():void{
            this.addEventListener(MouseEvent.MOUSE_DOWN, onDownCell);
            this.addEventListener(MouseEvent.MOUSE_UP, onCellUp);
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        private function setNoResource():void{
            if (this.icon == null){
                this.icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("NoResource");
            };
            this.addChild(icon);
        }
        protected function onLoabdComplete():void{
            if (icon){
                if (this.icon.parent){
                    this.icon.parent.removeChild(icon);
                };
                icon = null;
            };
            icon = ResourcesFactory.getInstance().getBitMapResourceByUrl(((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + "SkillIcon/") + _job) + "/") + _skillInfo.TypeID) + ".png"));
            if ((((_width > 0)) && ((_height > 0)))){
                icon.width = _width;
                icon.height = _height;
            };
            this.addChild(icon);
            iconBitmap = new Bitmap(icon.bitmapData);
            isLoadComplete = true;
            if (((cdLayer) && ((cdLayer.parent == this)))){
                this.setChildIndex(cdLayer, (this.numChildren - 1));
            };
        }
        protected function loadIcon():void{
            setNoResource();
            ResourcesFactory.getInstance().getResource((((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + "SkillIcon/") + _job) + "/") + _skillInfo.TypeID) + ".png?v=") + GameConfigData.SkillVersion), onLoabdComplete);
        }

    }
}//package GameUI.Modules.HeroSkill.View 
