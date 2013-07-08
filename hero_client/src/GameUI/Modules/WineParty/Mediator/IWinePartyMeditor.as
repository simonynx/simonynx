//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.WineParty.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.WineParty.Data.*;

    public class IWinePartyMeditor extends Mediator {

        public static const NAME:String = "IWinePartyMeditor";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var bodymodel:Object = null;
        private var notifylist:Array;

        public function IWinePartyMeditor(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([WinPartEvent.UPDATE_PARTY_VIEW]);
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("WineParty.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
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
            facade.removeMediator(IWinePartyMeditor.NAME);
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.WineParty.Mediator 
