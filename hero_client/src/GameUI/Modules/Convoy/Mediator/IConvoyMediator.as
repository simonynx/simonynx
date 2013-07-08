//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Convoy.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;

    public class IConvoyMediator extends Mediator {

        public static const NAME:String = "IConvoyMediator";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var bodymodel:Object = null;
        private var notifylist:Array;

        public function IConvoyMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.CLOSE_CONVOY_UI, EventList.BAGTOCONVOY, EventList.CONVOY_READY, EventList.CONVOY_OVER, EventList.CONVOY_GUIDE, EventList.REFRESH_CONVOY_QUALITY, EventList.SHOW_CONVOY_UI]);
        }
        private function LoadModel():void{
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("Convoy.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    this.dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.SHOW_CONVOY_UI:
                case EventList.BAGTOCONVOY:
                case EventList.REFRESH_CONVOY_QUALITY:
                case EventList.REFRESH_SELF_RECORD:
                default:
                    LoadModel();
                    if (bodymodel != null){
                        var _local3 = bodymodel;
                        _local3["handleNotification"](_arg1);
                    } else {
                        notifylist.push(_arg1);
                    };
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as Mediator));
            facade.removeMediator(IConvoyMediator.NAME);
            bodymodel["dataProxy"] = this.dataProxy;
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.Convoy.Mediator 
