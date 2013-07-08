//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Equipment.mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Equipment.model.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Equipment.command.*;

    public class IEquipForge extends Mediator {

        public static const NAME:String = "IEquipForge";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var bodymodel:Object = null;
        private var notifylist:Array;

        public function IEquipForge(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.RESIZE_STAGE, EquipCommandList.UPDATE_QUICKBUY_ITEM, EquipCommandList.UPDATE_EQUIP_FILTER, EquipCommandList.CLOSE_EQ_PANELS_CHANGE_SENCE, EquipCommandList.SHOW_EQUIPCOMPOSE_UI, EquipCommandList.REFRESH_EQUIP_COMPOSE, EquipCommandList.UPDATE_COMPOSE_EQUIP, EquipCommandList.CLOSE_EQUIP_COMPOSE, EquipCommandList.SHOW_EQUIPEMBED_UI, EquipCommandList.REFRESH_EQUIP_EMBED, EquipCommandList.UPDATE_EMBED_EQUIP, EquipCommandList.CLOSE_EQUIP_EMBED, EquipCommandList.SHOW_EQUIPIDENTIFY_UI, EquipCommandList.REFRESH_EQUIP_IDENTIFY, EquipCommandList.UPDATE_IDENTIFY_EQUIP, EquipCommandList.CLOSE_EQUIP_IDENTIFY, EquipCommandList.SHOW_EQUIPREFINE_UI, EquipCommandList.REFRESH_EQUIP_REFINE, EquipCommandList.UPDATE_REFINE_EQUIP, EquipCommandList.CLOSE_EQUIP_REFINE, EquipCommandList.SHOW_EQUIPSTRENGTHEN_UI, EquipCommandList.REFRESH_EQUIP_STRENGTH, EquipCommandList.UPDATE_STRENGTH_EQUIP, EquipCommandList.CLOSE_EQUIP_STRENGTH, EquipCommandList.SHOW_EQUIPTRANSFORM_UI, EquipCommandList.REFRESH_EQUIP_TRANSFORM, EquipCommandList.UPDATE_TRANSFORM_EQUIP, EquipCommandList.CLOSE_EQUIP_TRANSFORM, EquipCommandList.SHOW_EQUIP_UPSTAR, EquipCommandList.REFRESH_UPSTAR_ACTIVE, EquipCommandList.UPDATE_UPSTAR_EQUIP, EquipCommandList.CLOSE_EQUIP_UPSTAR]);
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("EquipForge.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            if (loadswfTool == null){
                switch (_arg1.getName()){
                    case EventList.INITVIEW:
                    case EventList.ENTERMAPCOMPLETE:
                    case EquipCommandList.SHOW_EQUIPCOMPOSE_UI:
                    case EquipCommandList.SHOW_EQUIPEMBED_UI:
                    case EquipCommandList.SHOW_EQUIPIDENTIFY_UI:
                    case EquipCommandList.SHOW_EQUIPREFINE_UI:
                    case EquipCommandList.SHOW_EQUIPSTRENGTHEN_UI:
                    case EquipCommandList.SHOW_EQUIPTRANSFORM_UI:
                    case EquipCommandList.SHOW_EQUIP_UPSTAR:
                        break;
                    default:
                        return;
                };
            };
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    this.dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    break;
                default:
                    if (EquipDataConst.checkInCrossServer(1)){
                        return;
                    };
                    LoadModel();
                    if (bodymodel != null){
                        var _local2 = bodymodel;
                        _local2["handleNotification"](_arg1);
                    } else {
                        notifylist.push(_arg1);
                    };
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            var _local2:*;
            facade.removeMediator(NAME);
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            for each (_local2 in bodymodel) {
                facade.registerMediator(_local2);
                _local2["dataProxy"] = this.dataProxy;
            };
            while (notifylist.length > 0) {
                for each (_local2 in bodymodel) {
                    !(((_local2["listNotificationInterests"]() as Array).indexOf(notifylist[0]) == -1));
                    var _local5 = _local2;
                    _local5["handleNotification"](notifylist[0]);
                };
                notifylist.shift();
            };
        }

    }
}//package GameUI.Modules.Equipment.mediator 
