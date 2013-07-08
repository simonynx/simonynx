//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.Modules.Friend.view.ui.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import flash.net.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.Verification.Proxy.*;
    import GameUI.Modules.Verification.Data.*;
    import GameUI.*;
    import flash.external.*;

    public class SelfInfoMediator extends Mediator {

        public static const NAME:String = "SelfInfoMediator";

        private var timer:Timer;
        private var des_hp_w:Number;
        protected var request:URLRequest;
        private var teamListVisible:Boolean;
        protected var face:int = -1;
        protected var menu:MenuItem;
        protected var timerID:uint;
        private var pkBtn:HBaseButton;
        private var HpRectangle:Rectangle;
        private var des_mp_w:Number;
        private var MpRectangle:Rectangle;
        private var isCanMove:Boolean;

        public function SelfInfoMediator(){
            HpRectangle = new Rectangle(73, 42, 119, 0);
            MpRectangle = new Rectangle(68, 55, 110, 0);
            super(NAME);
        }
        private function onLeverOver(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == this.SelfInfoUI["hpLeverBtn"]){
                this.SelfInfoUI["hpLeverBtn"].gotoAndStop(2);
            } else {
                this.SelfInfoUI["mpLeverBtn"].gotoAndStop(2);
            };
        }
        protected function onVerification(_arg1:MouseEvent):void{
            if (VerificationData.HasVerify){
                return;
            };
            facade.sendNotification(VerificationEvent.SHOW_VERIFICATION_VIEW2);
        }
        private function onMpLeverOut(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == this.SelfInfoUI["hpLeverBtn"]){
                this.SelfInfoUI["hpLeverBtn"].gotoAndStop(1);
            } else {
                this.SelfInfoUI["mpLeverBtn"].gotoAndStop(1);
            };
        }
        protected function update():void{
            var _local1:GameRole = GameCommonData.Player.Role;
            des_hp_w = (Math.min((_local1.HP / (_local1.MaxHp + _local1.AdditionAtt.MaxHP)), 1) * 124);
            des_mp_w = (Math.min((_local1.MP / (_local1.MaxMp + _local1.AdditionAtt.MaxMP)), 1) * 117);
            updateBlood();
            this.changeFace(_local1.Face);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case PlayerInfoComList.INIT_PLAYERINFO_UI:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:"Self"
                    });
                    this.SelfInfoUI.mouseEnabled = false;
                    pkBtn = new HBaseButton(this.SelfInfoUI.pkBtnAsset);
                    pkBtn.name = "pkBtn";
                    pkBtn.useBackgoundPos = true;
                    this.SelfInfoUI.addChild(pkBtn);
                    this.menu = new MenuItem();
                    this.menu.addEventListener(MenuEvent.Cell_Click, onCellClickHandler);
                    SelfInfoUI.faceMask.visible = false;
                    this.SelfInfoUI.mc_headImg.mask = SelfInfoUI.faceMask;
                    (this.SelfInfoUI.mc_headImg as MovieClip).addEventListener(MouseEvent.CLICK, onHeadClickHandler);
                    pkBtn.addEventListener(MouseEvent.CLICK, onPkClickHandler);
                    this.SelfInfoUI.btn_official.addEventListener(MouseEvent.CLICK, onLinkButtonClickHandler);
                    this.SelfInfoUI.btn_forum.addEventListener(MouseEvent.CLICK, onLinkButtonClickHandler);
                    this.SelfInfoUI.btn_favorites.addEventListener(MouseEvent.CLICK, onLinkButtonClickHandler);
                    this.SelfInfoUI["btn_expandTeam_up"].addEventListener(MouseEvent.CLICK, onExpandTeamClick);
                    if (VerificationData.VerificationType == VerificationData.ANTIWALLOW_CN){
                        this.SelfInfoUI["btn_Verification2"].visible = false;
                        this.SelfInfoUI["btn_Verification"].addEventListener(MouseEvent.CLICK, onVerification);
                    } else {
                        if (VerificationData.VerificationType == VerificationData.ANTIWALLOW_VN){
                            this.SelfInfoUI["btn_Verification"].visible = false;
                        };
                    };
                    this.SelfInfoUI["btn_expandTeam_down"].addEventListener(MouseEvent.CLICK, onExpandTeamClick);
                    this.SelfInfoUI["hpLeverBtn"].addEventListener(MouseEvent.MOUSE_DOWN, onLeverDown);
                    this.SelfInfoUI["hpLeverBtn"].addEventListener(MouseEvent.MOUSE_OVER, onLeverOver);
                    this.SelfInfoUI["hpLeverBtn"].addEventListener(MouseEvent.MOUSE_OUT, onMpLeverOut);
                    this.SelfInfoUI["mpLeverBtn"].addEventListener(MouseEvent.MOUSE_DOWN, onLeverDown);
                    this.SelfInfoUI["mpLeverBtn"].addEventListener(MouseEvent.MOUSE_OVER, onLeverOver);
                    this.SelfInfoUI["mpLeverBtn"].addEventListener(MouseEvent.MOUSE_OUT, onMpLeverOut);
                    if (VerificationData.HasVerify){
                        this.SelfInfoUI["btn_Verification"].visible = false;
                    };
                    this.SelfInfoUI["btn_expandTeam_up"].visible = false;
                    this.SelfInfoUI["btn_expandTeam_down"].visible = false;
                    this.SelfInfoUI["btn_expandTeam_up"].buttonMode = true;
                    this.SelfInfoUI["btn_expandTeam_down"].buttonMode = true;
                    teamListVisible = true;
                    this.SelfInfoUI.attFaceEffect.mouseEnabled = false;
                    this.SelfInfoUI.attFaceEffect.mouseChildren = false;
                    this.SelfInfoUI["mc_redOne"].mask = this.SelfInfoUI["mc_redOneMask"];
                    this.SelfInfoUI["mc_buleOne"].mask = this.SelfInfoUI["mc_buleOneMask"];
                    this.SelfInfoUI["hpLeverBtn"].x = (int(((Number(SharedManager.getInstance().hpPercent) * 119) / 100)) + 73);
                    this.SelfInfoUI["mpLeverBtn"].x = (int(((Number(SharedManager.getInstance().mpPercent) * 110) / 100)) + 68);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    GameCommonData.GameInstance.GameUI.addChild(this.SelfInfoUI);
                    initSet();
                    initData();
                    updateAll();
                    AttFaceState = false;
                    break;
                case PlayerInfoComList.UPDATE_ATTACK:
                    update();
                    break;
                case PlayerInfoComList.UPDATE_SELF_INFO:
                    this.timerID = setTimeout(this.updateAll, 1000);
                    break;
                case PlayerInfoComList.SHOW_EXPANDTEAM_ICON:
                    this.SelfInfoUI["btn_expandTeam_up"].visible = (teamListVisible) ? true : false;
                    this.SelfInfoUI["btn_expandTeam_down"].visible = (teamListVisible) ? false : true;
                    break;
                case PlayerInfoComList.HIDE_EXPANDTEAM_ICON:
                    this.SelfInfoUI["btn_expandTeam_up"].visible = false;
                    this.SelfInfoUI["btn_expandTeam_down"].visible = false;
                    break;
                case VerificationEvent.CLOSE_VERIFICATION_VIEW2:
                    if (VerificationData.HasVerify){
                        this.SelfInfoUI["btn_Verification"].visible = false;
                    };
                    break;
                case PlayerInfoComList.UPDATE_LEVER:
                    this.SelfInfoUI["hpLeverBtn"].x = (int(((Number(SharedManager.getInstance().hpPercent) * 119) / 100)) + 73);
                    this.SelfInfoUI["mpLeverBtn"].x = (int(((Number(SharedManager.getInstance().mpPercent) * 110) / 100)) + 68);
                    break;
                case EventList.ATTACK_START:
                    AttFaceState = true;
                    break;
                case EventList.ATTACK_STOP:
                    AttFaceState = false;
                    break;
                case VerificationEvent.VERIFICATION_STATE:
                    if (VerificationData.PlayTime >= 10800){
                        this.SelfInfoUI["btn_Verification2"].gotoAndStop(2);
                    } else {
                        if (VerificationData.PlayTime >= 18000){
                            this.SelfInfoUI["btn_Verification2"].gotoAndStop(3);
                        };
                    };
                    break;
            };
        }
        protected function updateAll():void{
            var _local1:GameRole = GameCommonData.Player.Role;
            (this.SelfInfoUI.txt_roleName as TextField).text = GameCommonData.Player.Role.Name;
            (this.SelfInfoUI.txt_level as TextField).text = String(GameCommonData.Player.Role.Level);
            this.changeFace(_local1.Face);
            this.update();
        }
        protected function onExpandTeamClick(_arg1:MouseEvent):void{
            if (this.SelfInfoUI["btn_expandTeam_up"].visible){
                sendNotification(PlayerInfoComList.HIDE_TEAM_UI);
                teamListVisible = false;
                this.SelfInfoUI["btn_expandTeam_up"].visible = false;
                this.SelfInfoUI["btn_expandTeam_down"].visible = true;
            } else {
                teamListVisible = true;
                sendNotification(PlayerInfoComList.SHOW_TEAM_UI);
                this.SelfInfoUI["btn_expandTeam_up"].visible = true;
                this.SelfInfoUI["btn_expandTeam_down"].visible = false;
            };
        }
        private function set AttFaceState(_arg1:Boolean):void{
            if (((MapManager.IsInArena()) || (MapManager.IsInGVG()))){
                return;
            };
            if (_arg1){
                this.SelfInfoUI.attFaceEffect.play();
                this.SelfInfoUI.attFaceEffect.visible = true;
            } else {
                this.SelfInfoUI.attFaceEffect.stop();
                this.SelfInfoUI.attFaceEffect.visible = false;
            };
        }
        public function onLinkButtonClickHandler(_arg1:MouseEvent):void{
            var _local2:URLRequest;
            if (_arg1.currentTarget === this.SelfInfoUI.btn_official){
                _local2 = new URLRequest(GameConfigData.OfficialWebsite);
            };
            if (_arg1.currentTarget === this.SelfInfoUI.btn_forum){
                _local2 = new URLRequest(GameConfigData.BBS);
            };
            if (_arg1.currentTarget === this.SelfInfoUI.btn_favorites){
                ExternalInterface.call("addFavorite");
            };
            if (_local2){
                navigateToURL(_local2);
            };
        }
        private function onLeverMove(_arg1:MouseEvent):void{
            SharedManager.getInstance().hpPercent = String(int((((this.SelfInfoUI["hpLeverBtn"].x - 73) / 119) * 100)));
            SharedManager.getInstance().mpPercent = String(int((((this.SelfInfoUI["mpLeverBtn"].x - 68) / 110) * 100)));
        }
        protected function onStageMouseClick(_arg1:MouseEvent):void{
            if (GameCommonData.GameInstance.GameUI.contains(this.menu)){
                GameCommonData.GameInstance.GameUI.removeChild(this.menu);
            };
        }
        protected function onCellClickHandler(_arg1:MenuEvent):void{
            switch (_arg1.cell.data["type"]){
                case "摆摊":
                    facade.sendNotification(EventList.SHOWSTALL);
                    break;
                case "自建队伍":
                    sendNotification(EventList.SETUPTEAMCOMMON);
                    break;
                case "退出队伍":
                    facade.sendNotification(EventList.LEAVETEAMCOMMON);
                    break;
                case "解散队伍":
                    facade.sendNotification(EventList.DISBANDTEAMCOMMON);
                    break;
                case "收摊":
                    break;
            };
        }
        private function onLeverUp(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == this.SelfInfoUI["hpLeverBtn"]){
                this.SelfInfoUI["hpLeverBtn"].stopDrag();
            } else {
                this.SelfInfoUI["mpLeverBtn"].stopDrag();
            };
            sendNotification(AutoPlayEventList.UPDATE_TEXT);
            GameCommonData.GameInstance.removeEventListener(MouseEvent.MOUSE_MOVE, onLeverMove);
            GameCommonData.GameInstance.removeEventListener(MouseEvent.MOUSE_UP, onLeverUp);
        }
        protected function initData():void{
            this.update();
        }
        private function onLeverDown(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == this.SelfInfoUI["hpLeverBtn"]){
                this.SelfInfoUI["hpLeverBtn"].startDrag(false, HpRectangle);
            } else {
                this.SelfInfoUI["mpLeverBtn"].startDrag(false, MpRectangle);
            };
            GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_UP, onLeverUp);
            GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_MOVE, onLeverMove);
        }
        override public function listNotificationInterests():Array{
            return ([PlayerInfoComList.INIT_PLAYERINFO_UI, EventList.ENTERMAPCOMPLETE, PlayerInfoComList.UPDATE_ATTACK, PlayerInfoComList.UPDATE_SELF_INFO, PlayerInfoComList.SHOW_EXPANDTEAM_ICON, PlayerInfoComList.HIDE_EXPANDTEAM_ICON, VerificationEvent.CLOSE_VERIFICATION_VIEW2, VerificationEvent.VERIFICATION_STATE, EventList.ATTACK_START, EventList.ATTACK_STOP, PlayerInfoComList.UPDATE_LEVER]);
        }
        protected function onHeadClickHandler(_arg1:MouseEvent):void{
            var _local4:Point;
            if (GameCommonData.IsInCrossServer){
                return;
            };
            var _local2:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            _local2.isSelectSelf = true;
            this.sendNotification(PlayerInfoComList.SELECTEDSELF, GameCommonData.Player.Role);
            GameCommonData.TargetAnimal = null;
            var _local3:Point = new Point(this.SelfInfoUI.mouseX, this.SelfInfoUI.mouseY);
            _local4 = this.SelfInfoUI.localToGlobal(_local3);
            var _local5:DisplayObject = GameCommonData.GameInstance.GameUI.getChildByName("MENU");
            if (_local5 != null){
                GameCommonData.GameInstance.GameUI.removeChild(_local5);
            };
            GameCommonData.GameInstance.GameUI.addChild(this.menu);
            var _local6:TeamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
            var _local7:Array = [];
            if (GameCommonData.Player.Role.idTeam != 0){
                _local7.push({
                    cellText:LanguageMgr.GetTranslation("退出队伍"),
                    data:{type:"退出队伍"}
                });
                if (GameCommonData.Player.Role.isTeamLeader){
                    _local7.push({
                        cellText:LanguageMgr.GetTranslation("解散队伍"),
                        data:{type:"解散队伍"}
                    });
                };
            } else {
                if ((((GameCommonData.Player.Role.idTeam == 0)) && (!(_local6.isInviting)))){
                    _local7.push({
                        cellText:LanguageMgr.GetTranslation("自建队伍"),
                        data:{type:"自建队伍"}
                    });
                };
            };
            this.menu.dataPro = _local7;
            this.menu.x = _local4.x;
            this.menu.y = _local4.y;
            _arg1.stopPropagation();
        }
        public function updateBlood():void{
            var _local1:MovieClip = (this.SelfInfoUI.mc_redOneMask as MovieClip);
            var _local2:MovieClip = (this.SelfInfoUI.mc_buleOneMask as MovieClip);
            if (des_hp_w == 124){
                TweenLite.to(_local1, 0, {width:des_hp_w});
            } else {
                TweenLite.to(_local1, 0.5, {width:des_hp_w});
            };
            if (des_mp_w == 117){
                TweenLite.to(_local2, 0, {width:des_mp_w});
            } else {
                TweenLite.to(_local2, 0.5, {width:des_mp_w});
            };
        }
        protected function initSet():void{
            (this.SelfInfoUI.txt_roleName as TextField).mouseEnabled = false;
            (this.SelfInfoUI.txt_level as TextField).mouseEnabled = true;
            (this.SelfInfoUI.txt_level as TextField).selectable = false;
            this.SelfInfoUI.stage.addEventListener(MouseEvent.CLICK, onStageMouseClick);
        }
        protected function changeFace(_arg1:uint):void{
            if (this.face == _arg1){
                return;
            };
            this.face = _arg1;
            var _local2:FaceItem = new FaceItem(String(_arg1), null, "face", 1);
            _local2.offsetPoint = new Point(0, 0);
            var _local3:MovieClip = (this.SelfInfoUI.mc_headImg as MovieClip);
            while (_local3.numChildren > 0) {
                _local3.removeChildAt(0);
            };
            _local3.addChild(_local2);
        }
        public function get SelfInfoUI():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        protected function onPkClickHandler(_arg1:MouseEvent):void{
            sendNotification(EventList.SHOWPKVIEW);
            _arg1.stopPropagation();
        }

    }
}//package GameUI.Modules.PlayerInfo.Mediator 
