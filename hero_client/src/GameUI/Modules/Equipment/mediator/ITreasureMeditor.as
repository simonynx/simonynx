//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Equipment.mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Equipment.command.*;

    public class ITreasureMeditor extends Mediator {

        public static const NAME:String = "ITreasureMeditor";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var bodymodel:Object = null;
        private var notifylist:Array;

        public function ITreasureMeditor(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.RESIZE_STAGE, EquipCommandList.UPDATE_QUICKBUY_ITEM, EquipCommandList.UPDATE_EQUIP_FILTER, EquipCommandList.CLOSE_EQ_PANELS_CHANGE_SENCE, EquipCommandList.SHOW_TREASUREREBUILD_UI, EquipCommandList.REFRESH_TREASURE_REBUILD, EquipCommandList.UPDATE_REBUILD_TREASURE, EquipCommandList.CLOSE_TREASURE_REBUILD, EquipCommandList.SHOW_TREASURESACRIFICE_UI, EquipCommandList.REFRESH_TREASURE_SACRIFICE, EquipCommandList.UPDATE_SACRIFICE_TREASURE, EquipCommandList.CLOSE_TREASURE_SACRIFICE, EquipCommandList.REFRESH_SACRIFICE_SOUL, EquipCommandList.REFRESH_SACRIFICE_CD_TIME, EquipCommandList.SHOW_TREASURERESET_UI, EquipCommandList.REFRESH_TREASURE_RESET, EquipCommandList.UPDATE_RESET_TREASURE, EquipCommandList.CLOSE_TREASURE_RESET, EquipCommandList.SHOW_TREASURETRANSFORM_UI, EquipCommandList.REFRESH_TREASURE_TRANSFORM, EquipCommandList.UPDATE_TRANSFORM_TREASURE, EquipCommandList.CLOSE_TREASURE_TRANSFORM, EquipCommandList.SHOW_TREASURETRANSFER_UI, EquipCommandList.REFRESH_TREASURE_TRANSFER, EquipCommandList.UPDATE_TRANSFER_TREASURE, EquipCommandList.CLOSE_TREASURE_TRANSFER]);
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("TreasureBuild.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Boolean;
            var _local3:NewInfoTipVo;
            if (loadswfTool == null){
                switch (_arg1.getName()){
                    case EventList.INITVIEW:
                    case EquipCommandList.SHOW_TREASUREREBUILD_UI:
                    case EquipCommandList.SHOW_TREASURESACRIFICE_UI:
                    case EquipCommandList.SHOW_TREASURERESET_UI:
                    case EquipCommandList.SHOW_TREASURETRANSFORM_UI:
                    case EquipCommandList.SHOW_TREASURETRANSFER_UI:
                    case EventList.ENTERMAPCOMPLETE:
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
                    _local2 = false;
                    if ((GameCommonData.treasureCDTime - (TimeManager.Instance.Now().time / 1000)) <= 0){
                        _local2 = true;
                    };
                    if (SharedManager.getInstance().onlineTimeToday != TimeManager.Instance.Now().day){
                        _local2 = true;
                        SharedManager.getInstance().onlineTimeToday = TimeManager.Instance.Now().day;
                    };
                    if (((((_local2) && ((GameCommonData.treasureSoul >= 100)))) && ((GameCommonData.Player.Role.Level >= 34)))){
                        _local3 = new NewInfoTipVo();
                        _local3.type = NewInfoTipType.TYPE_FH;
                        _local3.title = LanguageMgr.GetTranslation("提示二次附魂机会");
                        facade.sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local3);
                    };
                    break;
                default:
                    if (EquipDataConst.checkInCrossServer(2)){
                        return;
                    };
                    LoadModel();
                    if (bodymodel != null){
                        var _local4 = bodymodel;
                        _local4["handleNotification"](_arg1);
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
