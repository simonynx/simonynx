//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Arena.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Arena.Data.*;

    public class IArenaMediator extends Mediator {

        public static const NAME:String = "IArenaMediator";

        private var bodymodel:Object = null;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;

        public function IArenaMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, ArenaEvent.SHOW_ARENA, EventList.RESIZE_STAGE, ArenaEvent.SHOW_TODAY_RESULT, ArenaEvent.SHOW_ARENA_INVITE, ArenaEvent.UPDATE_ARENA_INFO, ArenaEvent.UPDATE_ARENA_SELF, ArenaEvent.SETUP_ALL_PERSON_INFO, ArenaEvent.CLOSE_ALL_VIEW, ArenaEvent.SEND_GO_ARENA, ArenaEvent.CLOSE_BTN, ArenaEvent.CLOSE_OTHER, ArenaEvent.SHOW_HIGHLEVEL_ARENA_VIEW, ArenaEvent.CLOSE_HIGHLEVEL_ARENA_VIEW, ArenaEvent.SHOW_BOSS_HURT_VIEW, ArenaEvent.CLOSE_BOSS_HURT_VIEW]);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    break;
                case ArenaEvent.CLOSE_OTHER:
                case ArenaEvent.CLOSE_BOSS_HURT_VIEW:
                case EventList.RESIZE_STAGE:
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
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("Arena.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as IMediator));
            facade.removeMediator(IArenaMediator.NAME);
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.Arena.Mediator 
