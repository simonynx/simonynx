//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Mail.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Mail.Data.*;

    public class IMailMediator extends Mediator {

        public static const NAME:String = "IMailMediator";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;
        private var bodymodel:Object = null;

        public function IMailMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOWMAIL, EventList.CLOSEMAIL, EventList.RESIZE_STAGE, MailEvent.REFRESHMAIL, MailEvent.READMAILBODY, MailEvent.RECEIVEMAIL, MailEvent.DELMAIL, MailEvent.ADDMAIL, MailEvent.CLOSEMAILNEW, MailEvent.TAKEMAILITEM]);
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("Mail.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local4:Array;
            var _local2:uint;
            var _local3:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.RESIZE_STAGE:
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
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as Mediator));
            facade.removeMediator(IMailMediator.NAME);
            bodymodel["dataProxy"] = this.dataProxy;
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.Mail.Mediator 
