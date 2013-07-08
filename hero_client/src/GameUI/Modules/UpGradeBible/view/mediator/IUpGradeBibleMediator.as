//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.UpGradeBible.view.mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;

    public class IUpGradeBibleMediator extends Mediator {

        public static const NAME:String = "IUpGradeBibleMediator";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;
        private var bodymodel:Object = null;

        public function IUpGradeBibleMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.UPDATE_ACTIVITY, EventList.SHOW_UPGRADE_BIBLE, EventList.UPDATE_MAINBTN_RIGHT, EventList.CLOSE_UPGRADE_BIBLE, EventList.SHOW_UPGRADE_BIBLE_ICON]);
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("GradeBible.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.UPDATE_MAINBTN_RIGHT:
                    if (GameCommonData.TaskInfoDic[1307].IsComplete){
                        LoadModel();
                        if (bodymodel != null){
                            var _local2 = bodymodel;
                            _local2["handleNotification"](_arg1);
                        } else {
                            notifylist.push(_arg1);
                        };
                    };
                    break;
                case EventList.UPDATE_ACTIVITY:
                    if (loadswfTool == null){
                        break;
                    };
                default:
                    LoadModel();
                    if (bodymodel != null){
                        _local2 = bodymodel;
                        _local2["handleNotification"](_arg1);
                    } else {
                        notifylist.push(_arg1);
                    };
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as Mediator));
            facade.removeMediator(IUpGradeBibleMediator.NAME);
            bodymodel["dataProxy"] = this.dataProxy;
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.UpGradeBible.view.mediator 
