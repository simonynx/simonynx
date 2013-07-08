//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.PlayerInfo.UI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.RequestSend.*;
    import flash.system.*;

    public class TeamListInfoMediator extends Mediator {

        public static const NAME:String = "TeamListInfoMediator";
        public static const DEFAULT_POS:Point = new Point(5, 128);

        protected var tl:TeamList;

        public function TeamListInfoMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        override public function listNotificationInterests():Array{
            return ([PlayerInfoComList.INIT_PLAYERINFO_UI, PlayerInfoComList.UPDATE_TEAM, EventList.ENTERMAPCOMPLETE, PlayerInfoComList.UPDATE_TEAM_UI, PlayerInfoComList.SHOW_TEAM_UI, PlayerInfoComList.HIDE_TEAM_UI, EventList.MEMBER_ONLINE_STATUS_TEAM]);
        }
        protected function initData():void{
            var _local1:*;
            var _local2:*;
            var _local3:Object;
            var _local4:GameElementAnimal;
            var _local5:GameRole;
            var _local6:TeamPlayerVo;
            var _local12:uint;
            var _local7:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local8:Array = this.tl.dataPro;
            var _local9:Array = [];
            var _local10:Array = [];
            var _local11:Dictionary = new Dictionary();
            for (_local1 in GameCommonData.TeamPlayerList) {
                if (uint(_local1) != GameCommonData.Player.Role.Id){
                    _local12++;
                    _local11[_local1] = GameCommonData.TeamPlayerList[_local1]["state"];
                    _local3 = GameCommonData.TeamPlayerList[_local1];
                    _local4 = (GameCommonData.SameSecnePlayerList[_local1] as GameElementAnimal);
                    if (_local4 == null){
                        if (this.indexOf(_local8, _local1) != -1){
                            if (_local3.isCaption == true){
                                _local5 = _local8[this.indexOf(_local8, _local1)];
                                _local5.idTeam = GameCommonData.Player.Role.idTeam;
                                _local5.idTeamLeader = _local1;
                                _local9.unshift(_local5);
                            } else {
                                _local5 = _local8[this.indexOf(_local8, _local1)];
                                _local5.idTeam = GameCommonData.Player.Role.idTeam;
                                _local5.idTeamLeader = 0;
                                _local9.push(_local5);
                            };
                        } else {
                            _local6 = this.searchRole(_local1);
                            _local5 = new GameRole();
                            _local5.Id = _local6.Id;
                            _local5.Name = _local6.Name;
                            _local5.Face = _local6.Face;
                            _local5.Level = _local6.Level;
                            _local5.MainJob.Job = _local6.Job;
                            if (_local3.isCaption == true){
                                _local5.idTeam = GameCommonData.Player.Role.idTeam;
                                _local5.idTeamLeader = _local6.Id;
                                _local9.unshift(_local5);
                            } else {
                                _local5.idTeam = GameCommonData.Player.Role.idTeam;
                                _local5.idTeamLeader = 0;
                                _local9.push(_local5);
                            };
                        };
                    } else {
                        if (_local3.isCaption == true){
                            _local9.unshift(_local4.Role);
                        } else {
                            _local9.push(_local4.Role);
                        };
                    };
                };
            };
            if (_local12 > 0){
                sendNotification(PlayerInfoComList.SHOW_EXPANDTEAM_ICON);
            } else {
                sendNotification(PlayerInfoComList.HIDE_EXPANDTEAM_ICON);
            };
            trace(("更新列表：" + _local9.length));
            this.tl.dataPro = _local9;
            _local7.roleDatas = _local9;
            facade.sendNotification(EventList.ITEMREMOVED, {flag:"Role"});
            for (_local2 in _local11) {
                this.tl.updateStatus(_local2, _local11[_local2]);
            };
        }
        protected function onCellClickHandler(_arg1:TeamEvent):void{
            switch (_arg1.flagStr){
                case "离开队伍":
                    facade.sendNotification(EventList.LEAVETEAMCOMMON);
                    break;
                case "移出队伍":
                    facade.sendNotification(EventList.KICKOUTTEAMCOMMON, {id:_arg1.role.Id});
                    break;
                case "提升为队长":
                    facade.sendNotification(EventList.CHANGELEADERTEAMCOMMON, {id:_arg1.role.Id});
                    break;
                case "加为好友":
                    sendNotification(FriendCommandList.ADD_TO_FRIEND, {
                        id:_arg1.role.Id,
                        name:_arg1.role.Name
                    });
                    break;
                case "设为私聊":
                    facade.sendNotification(ChatEvents.QUICKCHAT, _arg1.role.Name);
                    break;
                case "交易":
                    sendNotification(EventList.APPLYTRADE, {id:_arg1.role.Id});
                    break;
                case "查看信息":
                    FriendSend.getFriendInfo(_arg1.role.Id);
                    break;
                case "复制姓名":
                    System.setClipboard(_arg1.role.Name);
                    break;
            };
        }
        protected function upDateTeam(_arg1:uint):void{
            var _local2:int = this.indexOf(this.tl.dataPro, _arg1);
            if (_local2 >= 0){
                if (GameCommonData.SameSecnePlayerList[_arg1] == null){
                    return;
                };
                this.tl.dataPro[_local2] = (GameCommonData.SameSecnePlayerList[_arg1] as GameElementAnimal).Role;
                this.tl.upDate(this.tl.dataPro);
            };
            var _local3:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            _local3.roleDatas = this.tl.dataPro;
        }
        protected function indexOf(_arg1:Array, _arg2:uint):int{
            var _local3:GameRole;
            var _local5:int;
            var _local4:uint = _arg1.length;
            while (_local5 < _local4) {
                _local3 = (_arg1[_local5] as GameRole);
                if (_local3.Id == _arg2){
                    return (_local5);
                };
                _local5++;
            };
            return (-1);
        }
        protected function initSet():void{
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case PlayerInfoComList.INIT_PLAYERINFO_UI:
                    this.tl = new TeamList();
                    this.tl.mouseEnabled = false;
                    this.tl.addEventListener(TeamEvent.CELL_CLICK, onCellClickHandler);
                    break;
                case PlayerInfoComList.UPDATE_TEAM:
                    initData();
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    GameCommonData.GameInstance.GameUI.addChild(this.tl);
                    this.tl.x = DEFAULT_POS.x;
                    this.tl.y = DEFAULT_POS.y;
                    initSet();
                    initData();
                    break;
                case PlayerInfoComList.UPDATE_TEAM_UI:
                    this.upDateTeam(_arg1.getBody()["id"]);
                    break;
                case PlayerInfoComList.SHOW_TEAM_UI:
                    if (this.tl != null){
                        this.tl.visible = true;
                    };
                    break;
                case PlayerInfoComList.HIDE_TEAM_UI:
                    if (this.tl != null){
                        this.tl.visible = false;
                    };
                    break;
                case EventList.MEMBER_ONLINE_STATUS_TEAM:
                    this.tl.updateStatus(_arg1.getBody()["id"], _arg1.getBody()["state"]);
                    break;
            };
        }
        public function get TeamListInfoUI():TeamList{
            return (tl);
        }
        protected function searchRole(_arg1:uint):TeamPlayerVo{
            var _local2:TeamPlayerVo;
            var _local3:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            var _local4:Array = _local3.teamMemberList;
            for each (_local2 in _local4) {
                if (_local2.Id == _arg1){
                    return (_local2);
                };
            };
            return (null);
        }

    }
}//package GameUI.Modules.PlayerInfo.Mediator 
