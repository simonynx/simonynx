//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.OtherCountryFt {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;

    public class ITWHeroMediator extends Mediator {

        public static const NAME:String = "ITWHeroMediator";

        private var bodymodel:Object = null;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;

        public function ITWHeroMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.FBLINK_UPDATEHEROESRECORD, EventList.FBLINK_SHOWHEROESBBS, EventList.FBLINK_CLOSEHEROESBBS, EventList.FBLINK_RESULT]);
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
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("OtherCountryFt.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as IMediator));
            facade.removeMediator(ITWHeroMediator.NAME);
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.OtherCountryFt 
