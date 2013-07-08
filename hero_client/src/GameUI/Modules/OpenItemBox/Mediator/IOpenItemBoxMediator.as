//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.OpenItemBox.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;

    public class IOpenItemBoxMediator extends Mediator {

        public static const NAME:String = "IOpenItemBoxMediator";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var bodymodel:Object = null;
        private var notifylist:Array;

        public function IOpenItemBoxMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.UPDATEMONEY, EventList.REFRESH_OPENITEMBOX_UI, EventList.OPENITEMBOX_RESULT, EventList.REFRESH_SELF_RECORD, EventList.REFRESH_GLOBAL_RECORD, EventList.CLOSE_OPENITEMBOX_UI, EventList.SHOW_OPENITEMBOX_TOGGLE, EventList.SHOW_OPENITEMBOX_UI, EventList.OPENITEMBOX_OPEN_DEPOT]);
        }
        private function LoadModel():void{
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("OpenBox.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    this.dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.REFRESH_GLOBAL_RECORD:
                case EventList.UPDATEMONEY:
                    if (bodymodel == null){
                        break;
                    };
                case EventList.SHOW_OPENITEMBOX_UI:
                case EventList.SHOW_OPENITEMBOX_TOGGLE:
                case EventList.CLOSE_OPENITEMBOX_UI:
                case EventList.REFRESH_OPENITEMBOX_UI:
                case EventList.REFRESH_SELF_RECORD:
                case EventList.OPENITEMBOX_RESULT:
                case EventList.OPENITEMBOX_OPEN_DEPOT:
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
            facade.removeMediator(IOpenItemBoxMediator.NAME);
            bodymodel["dataProxy"] = this.dataProxy;
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.OpenItemBox.Mediator 
