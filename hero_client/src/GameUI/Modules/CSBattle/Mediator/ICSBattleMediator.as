//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.CSBattle.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import Net.RequestSend.*;

    public class ICSBattleMediator extends Mediator {

        public static const NAME:String = "ICSBattleMediator";

        private var bodymodel:Object = null;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;

        public function ICSBattleMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.ENTERMAPCOMPLETE, EventList.SHOW_CSBPANEL, EventList.CLOSE_CSBPANEL, EventList.CHANGE_SCENEAFTER, EventList.CSB_RECIEVEINVITE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.ENTERMAPCOMPLETE:
                    CSBattleSend.GetMyTeamInfo();
                    break;
                case EventList.CHANGE_SCENEAFTER:
                    if (!MapManager.IsInCSBattleReadyScene){
                        break;
                    };
                default:
                    LoadModel();
                    if (bodymodel != null){
                        var _local2 = bodymodel;
                        _local2["handleNotification"](_arg1);
                    } else {
                        notifylist.push(_arg1);
                    };
            };
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("CSBattle.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as Mediator));
            facade.removeMediator(NAME);
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.CSBattle.Mediator 
