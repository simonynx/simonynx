//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Rank.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;

    public class IRankMediator extends Mediator {

        public static const NAME:String = "IRankMediator";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var bodymodel:Object = null;
        private var notifylist:Array;

        public function IRankMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOW_RANK, EventList.CLOSE_RANK]);
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("Rank.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
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
            facade.removeMediator(IRankMediator.NAME);
            bodymodel["dataProxy"] = this.dataProxy;
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.Rank.Mediator 
