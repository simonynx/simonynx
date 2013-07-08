//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Entrust.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Entrust.Data.*;

    public class IEntrustMediator extends Mediator {

        public static const NAME:String = "IEntrustMediator";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;
        private var bodymodel:Object = null;

        public function IEntrustMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.REFRESH_ENTRUST_LIST, EventList.REFRESH_MYENTRUST_LIST, EventList.UPDATEMONEY, EventList.ENTRUST_SUCESS, EventList.CLOSE_ENTRUST_UI, EventList.SHOW_ENTRUST_UI, EventList.BAGTOENTRUST, EventList.REFRESH_MYENTRUST, EventList.REFRESH_MYENTRUST_LIST, EventList.ENTRUST_SUCESS, EventList.CLOSE_ENTRUST_POP_UI, EventList.SHOW_ENTRUST_POP_UI]);
        }
        private function LoadModel():void{
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("Entrust.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            if (GameCommonData.ModuleCloseConfig[11] == 1){
                return;
            };
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.UPDATEMONEY:
                    if (loadswfTool == null){
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
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as Mediator));
            facade.removeMediator(IEntrustMediator.NAME);
            bodymodel["dataProxy"] = this.dataProxy;
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.Entrust.Mediator 
