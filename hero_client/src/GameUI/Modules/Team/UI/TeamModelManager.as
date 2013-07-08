//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Team.UI {
    import flash.display.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.View.HButton.*;

    public class TeamModelManager {

        public var refushBtn:HLabelButton;
        private var teamDataProxy:TeamDataProxy;
        public var giveCaptainBtn:HLabelButton;
        public var autoJoinTeamBtn:HCheckBox;
        public var sendApplyBtn:HLabelButton;
        public var levelTeamBtn:HLabelButton;
        private var team:MovieClip = null;
        public var createTeamBtn:HLabelButton;
        public var chatBtn:HLabelButton;
        public var acceptJoinBtn:HLabelButton;
        public var sendInviteBtn:HLabelButton;
        public var sendTeamToChatBtn:HLabelButton;
        public var addFriendBtn:HLabelButton;

        public function TeamModelManager(_arg1:MovieClip, _arg2:TeamDataProxy){
            this.team = _arg1;
            this.teamDataProxy = _arg2;
            init();
        }
        private function init():void{
            this.addFriendBtn = new HLabelButton();
            addFriendBtn.label = LanguageMgr.GetTranslation("加为好友");
            addFriendBtn.name = "btnAddFriend";
            addFriendBtn.x = 15;
            addFriendBtn.y = 438;
            team.addChild(addFriendBtn);
            this.chatBtn = new HLabelButton();
            chatBtn.label = LanguageMgr.GetTranslation("聊天");
            chatBtn.name = "btnChat";
            chatBtn.x = 100;
            chatBtn.y = 438;
            team.addChild(chatBtn);
            this.refushBtn = new HLabelButton();
            refushBtn.label = LanguageMgr.GetTranslation("刷新");
            refushBtn.name = "btnRefush";
            refushBtn.x = 155;
            refushBtn.y = 438;
            team.addChild(this.refushBtn);
            this.giveCaptainBtn = new HLabelButton();
            giveCaptainBtn.label = LanguageMgr.GetTranslation("转交队长");
            giveCaptainBtn.name = "btnGiveCaptain";
            giveCaptainBtn.x = 180;
            giveCaptainBtn.y = 438;
            team.addChild(giveCaptainBtn);
            this.sendInviteBtn = new HLabelButton();
            sendInviteBtn.label = LanguageMgr.GetTranslation("邀请入队");
            sendInviteBtn.name = "btnSendInvite";
            sendInviteBtn.x = 260;
            sendInviteBtn.y = 438;
            team.addChild(sendInviteBtn);
            this.acceptJoinBtn = new HLabelButton();
            acceptJoinBtn.label = LanguageMgr.GetTranslation("同意入队");
            acceptJoinBtn.name = "btnAcceptJoin";
            acceptJoinBtn.x = 260;
            acceptJoinBtn.y = 438;
            team.addChild(acceptJoinBtn);
            this.sendApplyBtn = new HLabelButton();
            sendApplyBtn.label = LanguageMgr.GetTranslation("申请入队");
            sendApplyBtn.name = "btnSendApply";
            sendApplyBtn.x = 340;
            sendApplyBtn.y = 438;
            team.addChild(sendApplyBtn);
            this.levelTeamBtn = new HLabelButton();
            levelTeamBtn.label = LanguageMgr.GetTranslation("退出队伍");
            levelTeamBtn.name = "btnLevelTeamBtn";
            levelTeamBtn.x = 340;
            levelTeamBtn.y = 438;
            team.addChild(levelTeamBtn);
            this.createTeamBtn = new HLabelButton();
            createTeamBtn.label = LanguageMgr.GetTranslation("创建队伍");
            createTeamBtn.name = "btnLevelTeamBtn";
            createTeamBtn.x = 260;
            createTeamBtn.y = 438;
            team.addChild(createTeamBtn);
            this.autoJoinTeamBtn = new HCheckBox(LanguageMgr.GetTranslation("自动入队"));
            autoJoinTeamBtn.x = 250;
            autoJoinTeamBtn.y = 35;
            team.addChild(autoJoinTeamBtn);
            this.sendTeamToChatBtn = new HLabelButton();
            this.sendTeamToChatBtn.label = LanguageMgr.GetTranslation("发送至聊天");
            this.sendTeamToChatBtn.name = "sendTeamToChatBtn";
            this.sendTeamToChatBtn.x = 320;
            this.sendTeamToChatBtn.y = 470;
            team.addChild(sendTeamToChatBtn);
        }
        private function lockBtns(_arg1:Boolean):void{
            addFriendBtn.enable = _arg1;
            chatBtn.enable = _arg1;
            refushBtn.enable = _arg1;
            sendInviteBtn.enable = _arg1;
            sendApplyBtn.enable = _arg1;
            acceptJoinBtn.enable = _arg1;
            giveCaptainBtn.enable = _arg1;
            levelTeamBtn.enable = _arg1;
            createTeamBtn.enable = _arg1;
        }
        private function modelTeam():void{
            addFriendBtn.visible = true;
            chatBtn.visible = true;
            refushBtn.visible = false;
            sendInviteBtn.visible = false;
            sendApplyBtn.visible = false;
            acceptJoinBtn.visible = ((GameCommonData.Player.Role.idTeam > 0)) ? true : false;
            createTeamBtn.visible = ((GameCommonData.Player.Role.idTeam > 0)) ? false : true;
            acceptJoinBtn.enable = (GameCommonData.Player.Role.isTeamLeader) ? true : false;
            giveCaptainBtn.visible = true;
            giveCaptainBtn.enable = (GameCommonData.Player.Role.isTeamLeader) ? true : false;
            levelTeamBtn.visible = true;
            levelTeamBtn.enable = ((GameCommonData.Player.Role.idTeam > 0)) ? true : false;
        }
        public function setModel(_arg1:int):void{
            if (!this.team){
                return;
            };
            switch (_arg1){
                case 0:
                    modelNear();
                    break;
                case 1:
                    modelTeam();
                    break;
            };
        }
        private function modelNear():void{
            addFriendBtn.visible = true;
            chatBtn.visible = true;
            refushBtn.visible = true;
            sendInviteBtn.visible = true;
            sendApplyBtn.visible = true;
            acceptJoinBtn.visible = false;
            createTeamBtn.visible = false;
            acceptJoinBtn.enable = (GameCommonData.Player.Role.isTeamLeader) ? true : false;
            giveCaptainBtn.visible = false;
            giveCaptainBtn.enable = (GameCommonData.Player.Role.isTeamLeader) ? true : false;
            levelTeamBtn.visible = false;
        }

    }
}//package GameUI.Modules.Team.UI 
