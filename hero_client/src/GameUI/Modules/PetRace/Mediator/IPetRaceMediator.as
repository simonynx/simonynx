//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PetRace.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.PetRace.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import Net.RequestSend.*;

    public class IPetRaceMediator extends Mediator {

        public static const NAME:String = "IPetRaceMediator";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;
        private var bodymodel:Object = null;

        public function IPetRaceMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, PetRaceEvent.HAS_GET_BAG_DATA, EventList.SHOW_PETRACE, EventList.CLOSE_PETRACE, PetRaceEvent.SIGNUP_SUCESS, PetRaceEvent.UPDATE_PETRACE_MEMBER, PetRaceEvent.UPDATE_MEMBER_CANDEFY, PetRaceEvent.SELECTED_MEMBER, PetRaceEvent.UPDATE_PETRACE_DEPLOY, PetRaceEvent.RENAME_PET_TEAM, PetRaceEvent.UPDATE_FORMATION_CONFIG, PetRaceEvent.UPDATE_TEAM_INFO, PetRaceEvent.UPDATE_RANDOM_CONFIG, PetRaceEvent.UPDATE_CHALLENGGE, PetRaceEvent.ADD_RACING_RECORD, PetRaceEvent.FIGHT_SIMULATE, PetRaceEvent.UPDATE_SELF_PET_BLOOD, PetRaceEvent.UPDATE_TARGET_PET_BLOOD, PetRaceEvent.UPDATE_PETRACE_TIMES, PetRaceEvent.REFRESH_WINNER_LIST, PetRaceEvent.REFRESH_LAST_RANKING, PetRaceEvent.SELECTED_REPORT_MEMBER, PetRaceEvent.UPDATE_RACE_STATUS, PetRaceEvent.PETRACE_EFFECT, PetRaceEvent.RESULT_THISROUND, PetRaceEvent.UPDATE_RACE_REPORT]);
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("PetRace.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case PetRaceEvent.HAS_GET_BAG_DATA:
                    if (!PetRaceConstData.hasRequest){
                        PetRaceSend.GetPetRaceListInfo();
                        PetRaceSend.GetPetRaceRankingInfo(0);
                        PetRaceConstData.hasRequest = true;
                    };
                    break;
                case PetRaceEvent.UPDATE_PETRACE_MEMBER:
                case PetRaceEvent.UPDATE_MEMBER_CANDEFY:
                case PetRaceEvent.SELECTED_MEMBER:
                case PetRaceEvent.UPDATE_PETRACE_DEPLOY:
                case PetRaceEvent.RENAME_PET_TEAM:
                case PetRaceEvent.SIGNUP_SUCESS:
                case PetRaceEvent.UPDATE_FORMATION_CONFIG:
                case PetRaceEvent.UPDATE_RANDOM_CONFIG:
                case PetRaceEvent.UPDATE_TEAM_INFO:
                case PetRaceEvent.UPDATE_CHALLENGGE:
                case PetRaceEvent.ADD_RACING_RECORD:
                case PetRaceEvent.FIGHT_SIMULATE:
                case PetRaceEvent.UPDATE_SELF_PET_BLOOD:
                case PetRaceEvent.UPDATE_TARGET_PET_BLOOD:
                case PetRaceEvent.UPDATE_PETRACE_TIMES:
                case PetRaceEvent.REFRESH_WINNER_LIST:
                case PetRaceEvent.REFRESH_LAST_RANKING:
                case PetRaceEvent.SELECTED_REPORT_MEMBER:
                case PetRaceEvent.UPDATE_RACE_STATUS:
                case PetRaceEvent.PETRACE_EFFECT:
                case PetRaceEvent.RESULT_THISROUND:
                case PetRaceEvent.UPDATE_RACE_REPORT:
                    if (loadswfTool == null){
                        return;
                    };
                case EventList.SHOW_PETRACE:
                    if (GameCommonData.IsInCrossServer){
                        return;
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
            facade.removeMediator(IPetRaceMediator.NAME);
            bodymodel["dataProxy"] = this.dataProxy;
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.PetRace.Mediator 
