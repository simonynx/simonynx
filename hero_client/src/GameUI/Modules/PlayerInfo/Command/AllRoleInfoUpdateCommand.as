//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.Team.Datas.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.PlayerInfo.Mediator.*;

    public class AllRoleInfoUpdateCommand extends SimpleCommand {

        override public function execute(_arg1:INotification):void{
            var _local6:GameElementAnimal;
            var _local2:uint = _arg1.getBody()["id"];
            var _local3:uint = _arg1.getBody()["type"];
            var _local4:CounterWorkerInfoMediator = (facade.retrieveMediator(CounterWorkerInfoMediator.NAME) as CounterWorkerInfoMediator);
            var _local5:PetInfoMediator = (facade.retrieveMediator(PetInfoMediator.NAME) as PetInfoMediator);
            if (GameCommonData.SameSecnePlayerList == null){
                return;
            };
            if (_local2 == GameCommonData.Player.Role.Id){
                _local6 = GameCommonData.Player;
            } else {
                _local6 = GameCommonData.SameSecnePlayerList[_local2];
            };
            if (((_local6) && ((((_local6.Role.Type == GameRole.TYPE_PLAYER)) || ((_local6.Role.Type == GameRole.TYPE_OWNER)))))){
                (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).setPlayerTeamIcon(_local6);
            };
            switch (_local3){
                case 0:
                    if (((!((GameCommonData.TeamPlayerList == null))) && (!((GameCommonData.TeamPlayerList[_local2] == null))))){
                        this.sendNotification(PlayerInfoComList.UPDATE_TEAM_UI, {id:_local2});
                    };
                    break;
                case 1:
                    this.sendNotification(PlayerInfoComList.UPDATE_TEAM);
                    break;
                case 6:
                    this.sendNotification(PlayerInfoComList.UPDATE_ATTACK);
                    break;
                case 31:
                    this.sendNotification(PlayerInfoComList.HIDE_COUNTERWORKER_UI);
                    break;
                case 1001:
                    if (((!((_local4.role == null))) && ((_local4.role.Id == _local2)))){
                        if (_local4.role.Id == GameCommonData.Player.Role.Id){
                            sendNotification(PlayerInfoComList.UPDATE_COUNTER_INFO, GameCommonData.Player.Role);
                        } else {
                            if (GameCommonData.SameSecnePlayerList[_local2] != null){
                                sendNotification(PlayerInfoComList.UPDATE_COUNTER_INFO, GameCommonData.SameSecnePlayerList[_local2].Role);
                            };
                        };
                    };
                    if (_local2 == GameCommonData.Player.Role.Id){
                        sendNotification(PlayerInfoComList.UPDATE_SELF_INFO, GameCommonData.Player.Role);
                    };
                    if (((!((GameCommonData.TeamPlayerList == null))) && (!((GameCommonData.TeamPlayerList[_local2] == null))))){
                        this.sendNotification(PlayerInfoComList.UPDATE_TEAM_UI, {id:_local2});
                    };
                    if (_local5.role){
                        if (_local5.role.Id == _local2){
                            sendNotification(PlayerInfoComList.UPDATE_PET_UI);
                        };
                    };
                    break;
                case 41:
                    if (_local5.role){
                        if (_local5.role.Id == _local2){
                            if (GameCommonData.Player.Role.UsingPet){
                                GameCommonData.Player.Role.UsingPet.IsUsing = false;
                                sendNotification(PlayerInfoComList.REMOVE_PET_UI);
                                GameCommonData.Player.Role.UsingPet = null;
                            };
                        };
                    };
                    if (_local4.role){
                        if (_local4.role.Id == _local2){
                            this.sendNotification(PlayerInfoComList.HIDE_COUNTERWORKER_UI);
                        };
                    };
                    break;
            };
        }

    }
}//package GameUI.Modules.PlayerInfo.Command 
