//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ToolTip.Mediator {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.ToolTip.Mediator.UI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Mediator.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class ItemToolTipMediator extends Mediator {

        public static const NAME:String = "ItemToolTipMediator";

        private var setItemToolTip:IToolTip;
        private var parallelToolTip_2:IToolTip = null;
        private var itemToolTip:Sprite;
        private var isParallel:Boolean = false;
        private var isExp:Boolean = false;
        private var parallelToolTip_1:IToolTip = null;
        private var hasDetectYPos:Boolean = false;
        private var parallelEquip_1:Sprite = null;
        private var parallelOffsetX:Number = 0;
        private var parallelOffsetY:Number = 0;
        private var parallelEquip_2:Sprite = null;
        private var curDataType:uint = 0;
        private var skillItemTip:IToolTip;

        public function ItemToolTipMediator(){
            super(NAME);
        }
        private function changePos():void{
            var _local1:Number = 0;
            var _local2:Number = 0;
            if (itemToolTip.x > (GameCommonData.GameInstance.ScreenWidth - itemToolTip.width)){
                if (setItemToolTip){
                    _local1 = -(setItemToolTip.BackWidth());
                    itemToolTip.x = (itemToolTip.x - setItemToolTip.BackWidth());
                };
            };
            if (itemToolTip.y > (GameCommonData.GameInstance.ScreenHeight - itemToolTip.height)){
                _local2 = (-(itemToolTip.height) - 25);
                itemToolTip.y = ((itemToolTip.y - itemToolTip.height) - 25);
            };
            if (itemToolTip.y < 0){
                itemToolTip.y = 0;
            };
            if (parallelEquip_2){
                if (parallelEquip_2.x > (GameCommonData.GameInstance.ScreenWidth - parallelEquip_2.width)){
                    parallelEquip_1.x = ((itemToolTip.x - parallelEquip_1.width) - 5);
                    parallelEquip_2.x = ((parallelEquip_1.x - parallelEquip_2.width) - 25);
                };
                if (parallelEquip_2.y > (GameCommonData.GameInstance.ScreenHeight - parallelEquip_2.height)){
                    parallelEquip_1.y = ((parallelEquip_1.y - parallelEquip_1.height) - 25);
                    parallelEquip_2.y = parallelEquip_1.y;
                };
                if (((!((parallelOffsetX == 0))) || (!((parallelOffsetY == 0))))){
                    parallelOffsetX = (parallelOffsetX + _local1);
                    parallelOffsetY = (parallelOffsetY + _local2);
                };
                if (((!((parallelOffsetX == 0))) || (!((parallelOffsetY == 0))))){
                    parallelEquip_1.x = (parallelEquip_1.x + parallelOffsetX);
                    parallelEquip_1.y = (parallelEquip_1.y + parallelOffsetY);
                    parallelEquip_2.x = (parallelEquip_2.x + parallelOffsetX);
                    parallelEquip_2.y = (parallelEquip_2.y + parallelOffsetY);
                };
                if (parallelEquip_2.y < 0){
                    parallelEquip_1.y = 0;
                    parallelEquip_2.y = 0;
                };
            } else {
                if (parallelEquip_1){
                    if (parallelEquip_1.x > (GameCommonData.GameInstance.ScreenWidth - parallelEquip_1.width)){
                        parallelEquip_1.x = (itemToolTip.x - parallelEquip_1.width);
                    };
                    if (parallelEquip_1.y > (GameCommonData.GameInstance.ScreenHeight - parallelEquip_1.height)){
                        parallelEquip_1.y = ((parallelEquip_1.y - parallelEquip_1.height) - 25);
                    };
                    if (((!((parallelOffsetX == 0))) || (!((parallelOffsetY == 0))))){
                        parallelOffsetX = (parallelOffsetX + _local1);
                        parallelOffsetY = (parallelOffsetY + _local2);
                    };
                    if (((!((parallelOffsetX == 0))) || (!((parallelOffsetY == 0))))){
                        parallelEquip_1.x = (parallelEquip_1.x + parallelOffsetX);
                        parallelEquip_1.y = (parallelEquip_1.y + parallelOffsetY);
                    };
                    if (parallelEquip_1.y < 0){
                        parallelEquip_1.y = 0;
                    };
                };
            };
        }
        private function removeParallelEquip():void{
            if (parallelEquip_1){
                if (GameCommonData.GameInstance.TooltipLayer.contains(parallelEquip_1)){
                    GameCommonData.GameInstance.TooltipLayer.removeChild(parallelEquip_1);
                    parallelToolTip_1.Remove();
                    parallelToolTip_1 = null;
                    parallelEquip_1 = null;
                };
            };
            if (parallelEquip_2){
                if (GameCommonData.GameInstance.TooltipLayer.contains(parallelEquip_2)){
                    GameCommonData.GameInstance.TooltipLayer.removeChild(parallelEquip_2);
                    parallelToolTip_2.Remove();
                    parallelToolTip_2 = null;
                    parallelEquip_2 = null;
                };
            };
        }
        private function setValues(_arg1:IToolTip):void{
            _arg1.Show();
            GameCommonData.GameInstance.TooltipLayer.addChild(itemToolTip);
            if (isExp){
                itemToolTip.x = GameCommonData.GameInstance.TooltipLayer.mouseX;
                itemToolTip.y = (GameCommonData.GameInstance.TooltipLayer.mouseY - itemToolTip.height);
            } else {
                itemToolTip.x = (GameCommonData.GameInstance.TooltipLayer.mouseX + 15);
                itemToolTip.y = (GameCommonData.GameInstance.TooltipLayer.mouseY + 15);
                changePos();
            };
        }
        private function setParallelValues():void{
            if (((((parallelEquip_2) && (parallelEquip_1))) && (itemToolTip))){
                if (itemToolTip.x > (GameCommonData.GameInstance.ScreenWidth - itemToolTip.width)){
                    itemToolTip.x = (itemToolTip.x - setItemToolTip.BackWidth());
                };
                if (itemToolTip.y > (GameCommonData.GameInstance.ScreenHeight - itemToolTip.height)){
                    itemToolTip.y = (itemToolTip.y - itemToolTip.height);
                };
                parallelEquip_1.x = ((itemToolTip.x + itemToolTip.width) - 5);
                parallelEquip_2.x = (parallelEquip_1.x + parallelEquip_1.width);
                if (parallelEquip_2.x > (GameCommonData.GameInstance.ScreenWidth - parallelEquip_2.width)){
                    parallelEquip_1.x = (itemToolTip.x - parallelEquip_1.width);
                    parallelEquip_2.x = (parallelEquip_1.x - parallelEquip_2.width);
                };
                parallelEquip_1.y = itemToolTip.y;
                parallelEquip_2.y = itemToolTip.y;
                if (itemToolTip.y < 0){
                    itemToolTip.y = 0;
                };
                if (parallelEquip_2.y > (GameCommonData.GameInstance.ScreenHeight - parallelEquip_2.height)){
                    parallelEquip_1.y = 0;
                    parallelEquip_2.y = 0;
                };
            } else {
                if (((parallelEquip_1) && (itemToolTip))){
                    if (itemToolTip.x > (GameCommonData.GameInstance.ScreenWidth - itemToolTip.width)){
                        itemToolTip.x = (itemToolTip.x - setItemToolTip.BackWidth());
                    };
                    if (itemToolTip.y > (GameCommonData.GameInstance.ScreenHeight - itemToolTip.height)){
                        itemToolTip.y = (itemToolTip.y - itemToolTip.height);
                    };
                    parallelEquip_1.x = (itemToolTip.x + itemToolTip.width);
                    if (parallelEquip_1.x > (GameCommonData.GameInstance.ScreenWidth - parallelEquip_1.width)){
                        parallelEquip_1.x = (itemToolTip.x - parallelEquip_1.width);
                    };
                    parallelEquip_1.y = itemToolTip.y;
                    if (itemToolTip.y < 0){
                        itemToolTip.y = 0;
                    };
                    if (parallelEquip_1.y > (GameCommonData.GameInstance.ScreenHeight - parallelEquip_1.height)){
                        parallelEquip_1.y = 0;
                    };
                };
            };
        }
        private function showTowParallel(_arg1:Array):void{
            var _local3:MovieClip;
            parallelEquip_1 = new Sprite();
            parallelEquip_1.name = "parallelEquip_1";
            parallelEquip_1.mouseEnabled = false;
            parallelEquip_1.mouseChildren = false;
            parallelToolTip_1 = new SetItemToolTip(parallelEquip_1, _arg1[0]);
            parallelToolTip_1.Show();
            GameCommonData.GameInstance.TooltipLayer.addChild(parallelEquip_1);
            var _local2:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcHasEquiped");
            _local2.x = 182;
            _local2.y = 54;
            parallelEquip_1.addChild(_local2);
            if (_arg1.length == 2){
                parallelEquip_2 = new Sprite();
                parallelEquip_2.name = "parallelEquip_2";
                parallelEquip_2.mouseEnabled = false;
                parallelEquip_2.mouseChildren = false;
                parallelToolTip_2 = new SetItemToolTip(parallelEquip_2, _arg1[1]);
                parallelToolTip_2.Show();
                GameCommonData.GameInstance.TooltipLayer.addChild(parallelEquip_2);
                _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcHasEquiped");
                parallelEquip_2.addChild(_local3);
                _local3.x = 182;
                _local3.y = 54;
            };
        }
        private function createItemTooltip(_arg1:Object):void{
            removeToolTip();
            if (!UIConstData.ToolTipShow){
                return;
            };
            itemToolTip = new Sprite();
            itemToolTip.mouseEnabled = false;
            itemToolTip.mouseChildren = false;
            isExp = false;
            hasDetectYPos = false;
            setItemToolTip = new SetItemToolTip(itemToolTip, _arg1);
            setValues(setItemToolTip);
        }
        private function getShowParallel(_arg1:int):Array{
            var _local2:Array = [];
            var _local3:int;
            var _local4:int;
            while (_local4 < ItemConst.EQUIPMENT_SLOT_END) {
                if (RolePropDatas.ItemList[_local4] == null){
                } else {
                    _local3 = RolePropDatas.ItemList[_local4].SubClass;
                    if (_arg1 == _local3){
                        _local2.push(RolePropDatas.ItemList[_local4]);
                    };
                };
                _local4++;
            };
            return (_local2);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWITEMTOOLTIP, EventList.SHOWITEMPARALLELPANEL, EventList.REMOVEITEMTOOLTIP, EventList.MOVEITEMTOOLTIP, IntroConst.SHOWPARALLEL, EventList.SHOW_NPC_SHOP_TOOLTIP, EventList.SHOWTEXTTOOLTIP, EventList.SHOW_SKILL_TIP, EventList.SHOW_ACTIVITY_TOOLTIP]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:uint;
            var _local4:uint;
            var _local5:DataProxy;
            var _local6:GameRole;
            var _local7:int;
            var _local8:uint;
            var _local9:uint;
            var _local10:Array;
            var _local11:Number;
            var _local12:Number;
            switch (_arg1.getName()){
                case EventList.SHOWITEMTOOLTIP:
                    createItemTooltip(_arg1.getBody());
                    break;
                case EventList.SHOW_SKILL_TIP:
                    removeToolTip();
                    isExp = false;
                    itemToolTip = new Sprite();
                    itemToolTip.mouseEnabled = false;
                    itemToolTip.mouseChildren = false;
                    skillItemTip = new SkillItemTip(itemToolTip, _arg1.getBody());
                    setValues(skillItemTip);
                    break;
                case EventList.REMOVEITEMTOOLTIP:
                    UIConstData.ToolTipShow = false;
                    removeToolTip();
                    curDataType = 0;
                    break;
                case EventList.MOVEITEMTOOLTIP:
                    if (!itemToolTip){
                        return;
                    };
                    if (isExp){
                        itemToolTip.x = GameCommonData.GameInstance.TooltipLayer.mouseX;
                        itemToolTip.y = (GameCommonData.GameInstance.TooltipLayer.mouseY - itemToolTip.height);
                    } else {
                        _local11 = (GameCommonData.GameInstance.TooltipLayer.mouseX + 15);
                        _local12 = (GameCommonData.GameInstance.TooltipLayer.mouseY + 15);
                        parallelOffsetX = (_local11 - itemToolTip.x);
                        parallelOffsetY = (_local12 - itemToolTip.y);
                        itemToolTip.x = (GameCommonData.GameInstance.TooltipLayer.mouseX + 15);
                        itemToolTip.y = (GameCommonData.GameInstance.TooltipLayer.mouseY + 15);
                    };
                    changePos();
                    break;
                case EventList.SHOWTEXTTOOLTIP:
                    _local2 = _arg1.getBody();
                    removeToolTip();
                    if (!UIConstData.ToolTipShow){
                        return;
                    };
                    itemToolTip = new Sprite();
                    itemToolTip.mouseEnabled = false;
                    itemToolTip.mouseChildren = false;
                    hasDetectYPos = true;
                    if (_local2.change != undefined){
                        isExp = _local2.change;
                    } else {
                        isExp = false;
                    };
                    if (_local2.maxChar != undefined){
                        setItemToolTip = new TextToolTip(itemToolTip, _local2.data, _local2.maxChar);
                    } else {
                        setItemToolTip = new TextToolTip(itemToolTip, _local2.data);
                    };
                    setValues(setItemToolTip);
                    break;
                case EventList.SHOW_ACTIVITY_TOOLTIP:
                    removeToolTip();
                    _local2 = _arg1.getBody();
                    break;
                case EventList.SHOWITEMPARALLELPANEL:
                    createItemTooltip(_arg1.getBody());
                    if ((_arg1.getBody() as InventoryItemInfo).MainClass == ItemConst.ITEM_CLASS_EQUIP){
                        _local10 = getShowParallel((_arg1.getBody() as InventoryItemInfo).SubClass);
                        if (_local10.length > 0){
                            showTowParallel(_local10);
                            setParallelValues();
                        };
                    };
                    break;
            };
        }
        private function removeToolTip():void{
            if (itemToolTip){
                if (GameCommonData.GameInstance.TooltipLayer.contains(itemToolTip)){
                    GameCommonData.GameInstance.TooltipLayer.removeChild(itemToolTip);
                    if (setItemToolTip){
                        setItemToolTip.Remove();
                        setItemToolTip = null;
                    };
                    if (skillItemTip){
                        skillItemTip.Remove();
                        skillItemTip = null;
                    };
                    itemToolTip = null;
                };
            };
            removeParallelEquip();
        }

    }
}//package GameUI.Modules.ToolTip.Mediator 
