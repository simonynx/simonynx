//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Team.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.Modules.Team.Datas.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class RefushNearPlayerTeamCommand extends SimpleCommand {

        public static const NAME:String = "refushNearPlayerTeamCommand";

        override public function execute(_arg1:INotification):void{
            var _local4:String;
            var _local5:GameRole;
            var _local6:TeamPlayerVo;
            var _local8:int;
            var _local2:Dictionary = (_arg1.getBody() as Dictionary);
            var _local3:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            _local3.teamNearHasTeamPlayerList = [];
            _local3.teamNearNoTeamPlayerList = [];
            var _local7:Array = [];
            for (_local4 in GameCommonData.SameSecnePlayerList) {
                _local5 = GameCommonData.SameSecnePlayerList[_local4].Role;
                if (_local5.Type == GameRole.TYPE_PLAYER){
                    if (_local5.idTeam > 0){
                    } else {
                        if (DistanceController.TwoAnimalDistance(GameCommonData.Player, GameCommonData.SameSecnePlayerList[_local4], 20)){
                            _local6 = new TeamPlayerVo();
                            _local6.Id = _local5.Id;
                            _local6.Name = _local5.Name;
                            _local6.Face = _local5.Face;
                            _local6.Level = _local5.Level;
                            _local6.Job = _local5.MainJob.Job;
                            _local6.teamId = _local5.idTeam;
                            _local7.push(_local6);
                        };
                    };
                };
            };
            _local8 = 0;
            while ((((_local3.teamNearNoTeamPlayerList.length < 5)) && ((_local7.length > 0)))) {
                _local8 = Math.floor((Math.random() * _local7.length));
                _local6 = _local7[_local8];
                _local7.splice(_local8, 1);
                if (_local6){
                    _local3.teamNearNoTeamPlayerList.push(_local6);
                };
            };
            for (_local4 in _local2) {
                if (((_local2[_local4]) && ((_local3.teamNearHasTeamPlayerList.length < 5)))){
                    _local3.teamNearHasTeamPlayerList.push(_local2[_local4]);
                };
            };
            sendNotification(TeamEventName.REFUSH_NEARTEAM);
        }

    }
}//package GameUI.Modules.Team.Command 
