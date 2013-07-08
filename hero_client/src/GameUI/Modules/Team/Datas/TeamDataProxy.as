//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Team.Datas {
    import OopsEngine.Scene.StrategyElement.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;

    public class TeamDataProxy extends Proxy {

        public static const STEAMCMD_INVITER_REJECT_ENTERTEAM:int = 18;
        public static const STEAMCMD_PLAYERLEAVE:int = 17;
        public static const STEAMCMD_CHANGE_JOINTEAMMODE:int = 10;
        public static const CTEAMCMD_KICKPLAYER:int = 5;
        public static const STEAMCMD_JOINTEAMREPLY:int = 14;
        public static const NAME:String = "TeamDataProxy";
        public static const CTEAMCMD_CHANGE_JOINTEAMMODE:int = 9;
        public static const STEAMCMD_KICKPLAYER:int = 6;
        public static const CTEAMCMD_CHANGELEADER:int = 1;
        public static const STEAMCMD_CHANGE_LOOTMETHOD:int = 8;
        public static const CTEAMCMD_JOINTEAMREPLY:int = 13;
        public static const STEAMCMD_NEWLEADERINFO:int = 16;
        public static const CTEAMCMD_NULL:int = 0;
        public static const CTEAMCMD_INVITE:int = 3;
        public static const STEAMCMD_REQUEST_JOIN:int = 15;
        public static const STEAMCMD_DISBANDTEAM:int = 12;
        public static const CTEAMCMD_CHANGE_LOOTMETHOD:int = 7;
        public static const STEAMCMD_CHANGELEADER:int = 2;
        public static const CTEAMCMD_DISBANDTEAM:int = 11;
        public static const STEAMCMD_INVITE:int = 4;

        public var teamNearHasTeamPlayerSelected:TeamVo;
        public var inviteIsOpen:Boolean;
        public var teamMemberList:Array;
        public var curInvitePage:int = 0;
        public var memberPosList:Array;
        public var teamNearHasTeamPlayerItemList:Array;
        public var teamMemItemList:Array;
        public var autoJoinMode:Boolean = false;
        public var invitePageCount:int = 0;
        public var teamNearNoTeamPlayerSelected:TeamPlayerVo;
        public var inviteIdList:Array;
        public var teamReqSelected:TeamPlayerVo;
        public var invitePerson:Object;
        public var arenaMemberList:Array;
        public var teamNearNoTeamPlayerList:Array;
        public var inviteMemList:Array;
        public var teamReqList:Array;
        public var isInviting:Boolean;
        public var curPage:int = 0;
        public var teamNearHasTeamPlayerList:Array;
        public var teamReqItemList:Array;
        public var teamMemSelected:TeamPlayerVo;
        public var autoAllowApplyTeamMode:Boolean = false;
        public var teamNearNoTeamPlayerItemList:Array;
        public var inviteMemItemList:Array;

        public function TeamDataProxy(){
            inviteIdList = [];
            invitePerson = new Object();
            inviteMemList = [];
            inviteMemItemList = [];
            teamMemItemList = [];
            teamReqItemList = [];
            teamMemberList = [];
            teamReqList = [];
            teamNearHasTeamPlayerList = [];
            teamNearHasTeamPlayerItemList = [];
            teamNearNoTeamPlayerList = [];
            teamNearNoTeamPlayerItemList = [];
            super(NAME, data);
        }
        public function getMemberById(_arg1:int):TeamPlayerVo{
            var _local2:int;
            while (_local2 < teamMemberList.length) {
                if ((teamMemberList[_local2] as TeamPlayerVo).Id == _arg1){
                    return (teamMemberList[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public function changeLeader(_arg1:int):void{
            var _local2:String;
            var _local3:TeamPlayerVo;
            for (_local2 in teamMemberList) {
                if (teamMemberList[_local2].Id == _arg1){
                    teamMemberList[_local2].isLeader = true;
                } else {
                    teamMemberList[_local2].isLeader = false;
                };
            };
        }
        public function setPlayerTeamIcon(_arg1:GameElementAnimal):void{
            if (_arg1.Role.StallId > 0){
                _arg1.SetTeamLeader(false);
                _arg1.SetTeam(false);
            } else {
                if (_arg1.Role.idTeam == 0){
                    _arg1.SetTeamLeader(false);
                    _arg1.SetTeam(false);
                } else {
                    if (_arg1.Role.isTeamLeader){
                        _arg1.SetTeamLeader(true);
                        _arg1.SetTeam(false);
                    } else {
                        if (_arg1.Role.idTeam == GameCommonData.Player.Role.idTeam){
                            _arg1.SetTeamLeader(false);
                            _arg1.SetTeam(true);
                        } else {
                            _arg1.SetTeamLeader(false);
                            _arg1.SetTeam(false);
                        };
                    };
                };
            };
        }

    }
}//package GameUI.Modules.Team.Datas 
