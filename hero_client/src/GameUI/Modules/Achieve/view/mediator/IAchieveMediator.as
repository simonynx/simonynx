//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Achieve.view.mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import Net.RequestSend.*;

    public class IAchieveMediator extends Mediator {

        public static const NAME:String = "IAchieveMediator";

        private var bodymodel:Object = null;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;

        public function IAchieveMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.ENTERMAPCOMPLETE, EventList.SHOW_ACHIEVEVIEW, EventList.CLOSE_ACHIEVEVIEW, EventList.UPDATE_ACHIEVEVIEW, EventList.UPDATE_ONE_ACHIEVEVIEW, EventList.POP_GETNEWACHIEVE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local4:Array;
            var _local2:uint;
            var _local3:int;
            switch (_arg1.getName()){
                case EventList.ENTERMAPCOMPLETE:
                    AchieveSend.GetAchieveLog();
                    break;
                case EventList.UPDATE_ONE_ACHIEVEVIEW:
                    if (loadswfTool == null){
                        break;
                    };
                default:
                    LoadModel();
                    if (bodymodel != null){
                        var _local5 = bodymodel;
                        _local5["handleNotification"](_arg1);
                    } else {
                        notifylist.push(_arg1);
                    };
            };
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("Achieve.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as Mediator));
            facade.removeMediator(IAchieveMediator.NAME);
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.Achieve.view.mediator 
