//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Equipment.mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Equipment.command.*;

    public class EquipMenuMediator extends Mediator {

        public static const NAME:String = "EquipMenuMediator";

        private var mcSubMenu:MovieClip;
        private var sacrificeVisibleFlag:Boolean = false;
        private var transferVisibleFlag:Boolean = false;
        public var mcFail:MovieClip = null;
        public var mcSucess:MovieClip = null;
        public var mcPrev:MovieClip = null;
        private var mcTransformEffect:MovieClip = null;
        private var _equipMenu:MovieClip;
        private var transformVisibleFlag:Boolean = false;
        private var currChoice:uint = 0;

        public function EquipMenuMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    _equipMenu = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("equipMenu");
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    mcSubMenu = equipMenu.EquipForgeMenu;
                    mcSubMenu[("mcPage_" + DataProxy.FORGE_EQUIP_TRANSFER)].visible = false;
                    mcSubMenu[("txtPage_" + DataProxy.FORGE_EQUIP_TRANSFER)].visible = false;
                    mcSubMenu[("mcPage_" + DataProxy.FORGE_EQUIP_REFINE)].visible = (GameCommonData.ModuleCloseConfig[4] == 0);
                    mcSubMenu[("txtPage_" + DataProxy.FORGE_EQUIP_REFINE)].visible = (GameCommonData.ModuleCloseConfig[4] == 0);
                    equipMenu.TreasureMenu[("mcPage_" + DataProxy.FORGE_TREASURE_SACRIFICE)].visible = sacrificeVisibleFlag;
                    equipMenu.TreasureMenu[("txtPage_" + DataProxy.FORGE_TREASURE_SACRIFICE)].visible = sacrificeVisibleFlag;
                    equipMenu.TreasureMenu[("mcPage_" + DataProxy.FORGE_TREASURE_TRANSFORM)].visible = sacrificeVisibleFlag;
                    equipMenu.TreasureMenu[("txtPage_" + DataProxy.FORGE_TREASURE_TRANSFORM)].visible = sacrificeVisibleFlag;
                    mcSubMenu[("mcPage_" + DataProxy.FORGE_EQUIP_UPSTAR)].visible = transformVisibleFlag;
                    mcSubMenu[("txtPage_" + DataProxy.FORGE_EQUIP_UPSTAR)].visible = transformVisibleFlag;
                    break;
                case EventList.UPDATE_LEVEL:
                    if (GameCommonData.Player.Role.Level >= 34){
                        sacrificeVisibleFlag = true;
                        equipMenu.TreasureMenu[("mcPage_" + DataProxy.FORGE_TREASURE_SACRIFICE)].visible = true;
                        equipMenu.TreasureMenu[("txtPage_" + DataProxy.FORGE_TREASURE_SACRIFICE)].visible = true;
                        equipMenu.TreasureMenu[("mcPage_" + DataProxy.FORGE_TREASURE_TRANSFORM)].visible = true;
                        equipMenu.TreasureMenu[("txtPage_" + DataProxy.FORGE_TREASURE_TRANSFORM)].visible = true;
                    };
                    if (GameCommonData.Player.Role.Level >= 40){
                        transformVisibleFlag = true;
                        equipMenu.EquipForgeMenu[("mcPage_" + DataProxy.FORGE_EQUIP_UPSTAR)].visible = true;
                        equipMenu.EquipForgeMenu[("txtPage_" + DataProxy.FORGE_EQUIP_UPSTAR)].visible = true;
                    };
                    break;
            };
        }
        public function getFailMc():MovieClip{
            var _local1:LoadSwfTool;
            if (mcFail == null){
                _local1 = new LoadSwfTool(GameConfigData.EquipFailSwf, false);
                _local1.sendShow = sendFailShow;
                return (null);
            };
            return (mcFail);
        }
        public function resetChoice(_arg1:uint=0):void{
            var _local2:uint;
            var _local3:uint;
            if ((((_arg1 >= DataProxy.FORGE_EQUIP_START)) && ((_arg1 < DataProxy.FORGE_EQUIP_END)))){
                equipMenu.TreasureMenu.visible = false;
                mcSubMenu = equipMenu.EquipForgeMenu;
                _local2 = DataProxy.FORGE_EQUIP_START;
                _local3 = DataProxy.FORGE_EQUIP_END;
            } else {
                equipMenu.EquipForgeMenu.visible = false;
                mcSubMenu = equipMenu.TreasureMenu;
                _local2 = DataProxy.FORGE_TREASURE_START;
                _local3 = DataProxy.FORGE_TREASURE_END;
            };
            mcSubMenu.visible = true;
            var _local4:uint = _local2;
            while (_local4 < _local3) {
                mcSubMenu[("mcPage_" + _local4)].buttonMode = true;
                mcSubMenu[("txtPage_" + _local4)].mouseEnabled = false;
                mcSubMenu[("mcPage_" + _local4)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                if (_local4 == _arg1){
                    mcSubMenu[("mcPage_" + _local4)].gotoAndStop(1);
                    mcSubMenu[("txtPage_" + _local4)].textColor = 16496146;
                    mcSubMenu[("mcPage_" + _local4)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
                } else {
                    mcSubMenu[("mcPage_" + _local4)].gotoAndStop(2);
                    mcSubMenu[("txtPage_" + _local4)].textColor = 250597;
                };
                _local4++;
            };
            currChoice = _arg1;
        }
        public function getSucessMc():MovieClip{
            var _local1:LoadSwfTool;
            if (mcSucess == null){
                _local1 = new LoadSwfTool(GameConfigData.EquipSucessSwf, false);
                _local1.sendShow = sendSucessShow;
                return (null);
            };
            return (mcSucess);
        }
        public function getPrevMc():MovieClip{
            var _local1:LoadSwfTool;
            if (mcPrev == null){
                _local1 = new LoadSwfTool(GameConfigData.PrevEquipSwf, false);
                _local1.sendShow = sendPrevEquipShow;
                return (null);
            };
            return (mcPrev);
        }
        private function sendFailShow(_arg1:DisplayObject):void{
            mcFail = (_arg1 as MovieClip);
            mcFail.gotoAndStop(1);
        }
        public function getTransformMc():MovieClip{
            var loadswfTool:* = null;
            var func:* = function (_arg1:DisplayObject):void{
                mcTransformEffect = (_arg1 as MovieClip);
                mcTransformEffect.gotoAndStop(1);
            };
            if (mcTransformEffect == null){
                loadswfTool = new LoadSwfTool(GameConfigData.TransformEffectSwf, false);
                loadswfTool.sendShow = func;
                return (null);
            };
            return (mcTransformEffect);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.UPDATE_LEVEL, EventList.ENTERMAPCOMPLETE]);
        }
        public function get equipMenu():MovieClip{
            return ((this._equipMenu as MovieClip));
        }
        private function sendSucessShow(_arg1:DisplayObject):void{
            mcSucess = (_arg1 as MovieClip);
            mcSucess.gotoAndStop(1);
        }
        private function sendPrevEquipShow(_arg1:DisplayObject):void{
            mcPrev = (_arg1 as MovieClip);
            mcPrev.gotoAndStop(1);
        }
        private function choicePageHandler(_arg1:MouseEvent):void{
            var _local3:uint;
            var _local4:uint;
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
            var _local2:uint = uint(_arg1.currentTarget.name.split("_")[1]);
            if (mcSubMenu == equipMenu.EquipForgeMenu){
                _local3 = DataProxy.FORGE_EQUIP_START;
                _local4 = DataProxy.FORGE_EQUIP_END;
            } else {
                _local3 = DataProxy.FORGE_TREASURE_START;
                _local4 = DataProxy.FORGE_TREASURE_END;
            };
            var _local5:int = _local3;
            while (_local5 < _local4) {
                mcSubMenu[("mcPage_" + _local5)].gotoAndStop(2);
                mcSubMenu[("txtPage_" + _local5)].textColor = 250597;
                mcSubMenu[("mcPage_" + _local5)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                _local5++;
            };
            mcSubMenu[("mcPage_" + _local2)].gotoAndStop(1);
            mcSubMenu[("txtPage_" + _local2)].textColor = 16496146;
            mcSubMenu[("mcPage_" + _local2)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
            sendNotification(EquipCommandList.CLOSE_EQ_PANELS_CHANGE_SENCE);
            if (mcSubMenu == equipMenu.EquipForgeMenu){
                switch (_local2){
                    case DataProxy.FORGE_EQUIP_STRENGTH:
                        sendNotification(EquipCommandList.SHOW_EQUIPSTRENGTHEN_UI);
                        break;
                    case DataProxy.FORGE_EQUIP_EMBED:
                        sendNotification(EquipCommandList.SHOW_EQUIPEMBED_UI);
                        break;
                    case DataProxy.FORGE_EQUIP_IDENTIFY:
                        sendNotification(EquipCommandList.SHOW_EQUIPIDENTIFY_UI);
                        break;
                    case DataProxy.FORGE_EQUIP_COMPOSE:
                        sendNotification(EquipCommandList.SHOW_EQUIPCOMPOSE_UI);
                        break;
                    case DataProxy.FORGE_EQUIP_REFINE:
                        if (GameCommonData.ModuleCloseConfig[4] == 1){
                            break;
                        };
                        sendNotification(EquipCommandList.SHOW_EQUIPREFINE_UI);
                        break;
                    case DataProxy.FORGE_EQUIP_UPSTAR:
                        sendNotification(EquipCommandList.SHOW_EQUIP_UPSTAR);
                        break;
                    case DataProxy.FORGE_EQUIP_TRANSFORM:
                        sendNotification(EquipCommandList.SHOW_EQUIPTRANSFORM_UI);
                        break;
                };
            } else {
                switch (_local2){
                    case DataProxy.FORGE_TREASURE_REBUILD:
                        sendNotification(EquipCommandList.SHOW_TREASUREREBUILD_UI);
                        break;
                    case DataProxy.FORGE_TREASURE_SACRIFICE:
                        sendNotification(EquipCommandList.SHOW_TREASURESACRIFICE_UI);
                        break;
                    case DataProxy.FORGE_TREASURE_RESET:
                        sendNotification(EquipCommandList.SHOW_TREASURERESET_UI);
                        break;
                    case DataProxy.FORGE_TREASURE_TRANSFER:
                        sendNotification(EquipCommandList.SHOW_TREASURETRANSFER_UI);
                        break;
                    case DataProxy.FORGE_TREASURE_TRANSFORM:
                        sendNotification(EquipCommandList.SHOW_TREASURETRANSFORM_UI);
                        break;
                };
            };
        }

    }
}//package GameUI.Modules.Equipment.mediator 
