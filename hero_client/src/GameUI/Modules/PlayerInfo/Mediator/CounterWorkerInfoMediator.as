//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Friend.model.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Modules.Friend.view.ui.*;
    import GameUI.Modules.Chat.Data.*;
    import com.greensock.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.PlayerInfo.UI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Friend.view.mediator.*;
    import flash.system.*;
    import GameUI.*;

    public class CounterWorkerInfoMediator extends Mediator {

        public static const DEFAULTPOSITION:Point = new Point(300, 0);
        public static const NAME:String = "CounterWorkerInfoMediator";

        private var buffs:HeadImgList;
        private var timer:Timer;
        protected var face:int = -1;
        protected var menu:MenuItem;
        private var des_w5:Number;
        private var des_w2:Number;
        public var role:GameRole;

        public function CounterWorkerInfoMediator(){
            super(NAME);
        }
        private function setLevel(_arg1:uint):void{
            var _local2:TextField = (this.CounterWorkerInfoUI.txt_level as TextField);
            _local2.mouseEnabled = false;
            if (uint(_local2.text) == _arg1){
                return;
            };
            _local2.text = String(_arg1);
        }
        protected function update():void{
            if (this.role == null){
                return;
            };
            this.setMenuStaus();
            switch (role.Type){
                case GameRole.TYPE_OWNER:
                    if (GameCommonData.TargetAnimal){
                        GameCommonData.TargetAnimal.IsSelect(false);
                    };
                case GameRole.TYPE_PLAYER:
                    this.updatePlayer();
                    this.showBuff();
                    break;
                case GameRole.TYPE_NPC:
                    this.updateNPC();
                    this.buffs.visible = false;
                    break;
                case GameRole.TYPE_ENEMY:
                    this.updateAnimal();
                    this.showBuff();
                    break;
                case GameRole.TYPE_PET:
                    this.updatePet();
                    this.showBuff();
                    break;
            };
        }
        protected function updatePlayer():void{
            this.setBlood(1);
            this.setEmployeement(GameCommonData.RolesListDic[role.CurrentJobID]);
            this.setLevel(role.Level);
            this.setFace(role.Face);
            this.setName(role.Name);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case PlayerInfoComList.INIT_PLAYERINFO_UI:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:"Counter"
                    });
                    this.CounterWorkerInfoUI.mouseEnabled = false;
                    this.menu = new MenuItem();
                    this.buffs = new HeadImgList();
                    this.menu.addEventListener(MenuEvent.Cell_Click, onClickHandler);
                    this.buffs.x = (155 - 60);
                    this.buffs.y = (46 + 20);
                    this.CounterWorkerInfoUI.faceMask.visible = false;
                    (this.CounterWorkerInfoUI.mc_headImg as MovieClip).mask = this.CounterWorkerInfoUI.faceMask;
                    (this.CounterWorkerInfoUI.mc_headImg as MovieClip).addEventListener(MouseEvent.CLICK, onShowMenuHandler);
                    this.CounterWorkerInfoUI["mc_redOne"].mask = this.CounterWorkerInfoUI["mc_redOneMask"];
                    this.CounterWorkerInfoUI["mc_buleOne"].mask = this.CounterWorkerInfoUI["mc_buleOneMask"];
                    this.CounterWorkerInfoUI.jjBtnAsset.visible = false;
                    break;
                case PlayerInfoComList.SELECT_ELEMENT:
                    this.role = (_arg1.getBody() as GameRole);
                    GameCommonData.GameInstance.GameUI.addChild(this.CounterWorkerInfoUI);
                    GameCommonData.GameInstance.GameUI.stage.addEventListener(MouseEvent.CLICK, onStageClickHandler);
                    this.CounterWorkerInfoUI.x = ((GameCommonData.GameInstance.ScreenWidth - CounterWorkerInfoUI.width) / 2);
                    this.CounterWorkerInfoUI.y = DEFAULTPOSITION.y;
                    this.update();
                    break;
                case PlayerInfoComList.SELECTEDSELF:
                    this.role = (_arg1.getBody() as GameRole);
                    GameCommonData.GameInstance.GameUI.addChild(this.CounterWorkerInfoUI);
                    GameCommonData.GameInstance.GameUI.stage.addEventListener(MouseEvent.CLICK, onStageClickHandler);
                    this.CounterWorkerInfoUI.x = ((GameCommonData.GameInstance.ScreenWidth - CounterWorkerInfoUI.width) / 2);
                    this.CounterWorkerInfoUI.y = DEFAULTPOSITION.y;
                    this.update();
                    break;
                case PlayerInfoComList.UPDATE_COUNTER_INFO:
                    this.role = (_arg1.getBody() as GameRole);
                    this.delayUpdate();
                    break;
                case PlayerInfoComList.UPDATE_ATTACK:
                    if (GameCommonData.TargetAnimal == null){
                        return;
                    };
                    this.role = GameCommonData.TargetAnimal.Role;
                    this.update();
                    break;
                case PlayerInfoComList.HIDE_COUNTERWORKER_UI:
                    this.role = null;
                    if (GameCommonData.GameInstance.GameUI.contains(this.CounterWorkerInfoUI)){
                        if (GameCommonData.GameInstance.GameUI.contains(this.menu)){
                            GameCommonData.GameInstance.GameUI.removeChild(this.menu);
                        };
                        GameCommonData.GameInstance.GameUI.removeChild(this.CounterWorkerInfoUI);
                    };
                    break;
                case PlayerInfoComList.UPDATE_COUNTERWORKER_BUFF:
                    this.showBuff();
                    break;
                case EventList.RESIZE_STAGE:
                    this.CounterWorkerInfoUI.x = ((GameCommonData.GameInstance.ScreenWidth - CounterWorkerInfoUI.width) / 2);
                    break;
                case PlayerInfoComList.QUICK_TRADE:
                    if (this.role != null){
                        sendNotification(EventList.APPLYTRADE, {id:role.Id});
                    };
                    break;
            };
        }
        private function setName(_arg1:String):void{
            var _local2:TextField = (this.CounterWorkerInfoUI.txt_roleName as TextField);
            _local2.mouseEnabled = false;
            if (_local2.text == _arg1){
                return;
            };
            _local2.text = _arg1;
        }
        private function setEmployeement(_arg1:String):void{
        }
        protected function onShowMenuHandler(_arg1:MouseEvent):void{
            var _local2:FriendManagerMediator;
            var _local3:FriendInfoStruct;
            var _local4:*;
            if (GameCommonData.IsInCrossServer){
                return;
            };
            var _local5:uint = (GameCommonData.GameInstance.GameUI.numChildren - 1);
            GameCommonData.GameInstance.GameUI.setChildIndex(this.CounterWorkerInfoUI, _local5);
            var _local6:Point = new Point(this.CounterWorkerInfoUI.mouseX, this.CounterWorkerInfoUI.mouseY);
            var _local7:Point = this.CounterWorkerInfoUI.localToGlobal(_local6);
            var _local8:DisplayObject = GameCommonData.GameInstance.GameUI.getChildByName("MENU");
            if (_local8 != null){
                GameCommonData.GameInstance.GameUI.removeChild(_local8);
            };
            var _local9:GameRole = GameCommonData.Player.Role;
            var _local10:GameRole = this.role;
            var _local11:Array = [];
            if (this.role.Type == GameRole.TYPE_PLAYER){
                _local11.push({
                    cellText:LanguageMgr.GetTranslation("交    易"),
                    data:{type:"交易"}
                });
                _local11.push({
                    cellText:LanguageMgr.GetTranslation("切    磋"),
                    data:{type:"切磋"}
                });
                _local11.push({
                    cellText:LanguageMgr.GetTranslation("设为私聊"),
                    data:{type:"设为私聊"}
                });
                _local11.push({
                    cellText:LanguageMgr.GetTranslation("复制姓名"),
                    data:{type:"复制姓名"}
                });
                _local3 = (facade.retrieveMediator(FriendManagerMediator.NAME) as FriendManagerMediator).searchFriend(FriendConstData.FriendList, 0, 0, _local10.Name);
                if (_local3 == null){
                    _local11.push({
                        cellText:LanguageMgr.GetTranslation("加为好友"),
                        data:{type:"加为好友"}
                    });
                };
                if (_local10.idTeam == 0){
                    _local11.push({
                        cellText:LanguageMgr.GetTranslation("邀请入队"),
                        data:{type:"邀请入队"}
                    });
                } else {
                    if (GameCommonData.Player.Role.idTeam == 0){
                        _local11.push({
                            cellText:LanguageMgr.GetTranslation("申请入队"),
                            data:{type:"申请入队"}
                        });
                    };
                };
                _local11.push({
                    cellText:LanguageMgr.GetTranslation("查看信息"),
                    data:{type:"查看信息"}
                });
                _local11.push({
                    cellText:LanguageMgr.GetTranslation("查看宠物"),
                    data:{type:"查看宠物"}
                });
            } else {
                if (this.role.Type == GameRole.TYPE_PET){
                    if (((GameCommonData.Player.Role.UsingPetAnimal) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == this.role.Id)))){
                        _local11.push({
                            cellText:LanguageMgr.GetTranslation("喂    食"),
                            data:{type:"喂食"}
                        });
                        _local11.push({
                            cellText:LanguageMgr.GetTranslation("驯    养"),
                            data:{type:"驯养"}
                        });
                        _local11.push({
                            cellText:LanguageMgr.GetTranslation("休    息"),
                            data:{type:"休息"}
                        });
                    } else {
                        _local11.push({
                            cellText:LanguageMgr.GetTranslation("查看宠物"),
                            data:{type:"查看宠物2"}
                        });
                    };
                };
            };
            if (_local11.length > 0){
                this.menu.dataPro = _local11;
                this.menu.x = _local7.x;
                this.menu.y = _local7.y;
                GameCommonData.GameInstance.GameUI.addChild(this.menu);
            };
            _arg1.stopPropagation();
        }
        protected function updatePet():void{
            this.setBlood(6);
            this.setLevel(this.role.Level);
            this.setFace(this.role.Face);
            this.setEmployeement("宠物");
            this.setName(this.role.Name);
        }
        protected function updateNPC():void{
            this.setBlood(2);
            this.setEmployeement("大宋");
            this.setFace(this.role.Face);
            this.setLevel(this.role.Level);
            this.setName(this.role.Name);
        }
        public function get CounterWorkerInfoUI():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        protected function setMenuStaus():void{
            if ((((((role.Type == GameRole.TYPE_PLAYER)) && (!((role.Id == GameCommonData.Player.Role.Id))))) || ((role.Type == GameRole.TYPE_PET)))){
                (this.CounterWorkerInfoUI.mc_headImg as MovieClip).mouseEnabled = true;
            } else {
                (this.CounterWorkerInfoUI.mc_headImg as MovieClip).mouseEnabled = false;
            };
        }
        private function setFace(_arg1:uint):void{
            if (_arg1 == this.face){
                return;
            };
            this.face = _arg1;
            var _local2:FaceItem = new FaceItem(String(this.face), null, "face", (65 / 67));
            _local2.offsetPoint = new Point(0, 0);
            var _local3:MovieClip = (this.CounterWorkerInfoUI.mc_headImg as MovieClip);
            while (_local3.numChildren > 0) {
                _local3.removeChildAt(0);
            };
            _local3.addChild(_local2);
        }
        protected function onClickHandler(_arg1:MenuEvent):void{
            var _local2:uint;
            if (this.role == null){
                return;
            };
            switch (String(_arg1.cell.data["type"])){
                case "交易":
                    if (this.role != null){
                        sendNotification(EventList.APPLYTRADE, {id:role.Id});
                    };
                    break;
                case "跟随":
                    break;
                case "加为好友":
                    sendNotification(FriendCommandList.ADD_TO_FRIEND, {
                        id:role.Id,
                        name:role.Name
                    });
                    break;
                case "邀请入队":
                    sendNotification(EventList.INVITETEAM, {id:this.role.Id});
                    break;
                case "申请入队":
                    sendNotification(EventList.APPLYTEAM, {
                        id:this.role.Id,
                        teamId:this.role.idTeam
                    });
                    break;
                case "设为私聊":
                    facade.sendNotification(ChatEvents.QUICKCHAT, this.role.Name);
                    break;
                case "查看信息":
                    FriendSend.getFriendInfo(this.role.Id);
                    break;
                case "查看宠物":
                    FriendSend.getFriendInfo(this.role.Id, 2);
                    break;
                case "查看宠物2":
                    FriendSend.getFriendInfo(this.role.MasterId, 3);
                    break;
                case "复制姓名":
                    System.setClipboard(this.role.Name);
                    break;
                case "喂食":
                    break;
                case "驯养":
                    break;
                case "休息":
                    PetSend.Rest();
                    break;
                case "切磋":
                    DuelController.InitiateDuel(GameCommonData.TargetAnimal);
                    break;
            };
        }
        protected function updateAnimal():void{
            this.setBlood(5);
            this.setLevel(role.Level);
            this.setFace(role.Face);
            this.setName(role.Name);
        }
        override public function listNotificationInterests():Array{
            return ([PlayerInfoComList.QUICK_TRADE, PlayerInfoComList.INIT_PLAYERINFO_UI, PlayerInfoComList.HIDE_COUNTERWORKER_UI, PlayerInfoComList.SELECT_ELEMENT, PlayerInfoComList.UPDATE_COUNTER_INFO, PlayerInfoComList.UPDATE_ATTACK, PlayerInfoComList.SELECTEDSELF, PlayerInfoComList.UPDATE_COUNTERWORKER_BUFF, EventList.RESIZE_STAGE]);
        }
        protected function onStageClickHandler(_arg1:MouseEvent):void{
            if (this.menu == null){
                return;
            };
            if (this.CounterWorkerInfoUI.stage == null){
                return;
            };
            if (GameCommonData.GameInstance.GameUI.contains(this.menu)){
                GameCommonData.GameInstance.GameUI.removeChild(this.menu);
            };
        }
        private function showBuff():void{
            var _local1:GameSkillBuff;
            var _local2:GameSkillBuff;
            var _local3:Array;
            var _local4:uint;
            var _local5:uint;
            this.buffs.visible = true;
            if (this.role == null){
                return;
            };
            var _local6:Array = [];
            var _local7:* = 1;
            var _local8:Array = [];
            for each (_local1 in this.role.DotBuff) {
                _local6.push({
                    info:_local1,
                    isDeBuff:true
                });
            };
            for each (_local2 in this.role.PlusBuff) {
                _local6.push({
                    info:_local2,
                    isDeBuff:false
                });
            };
            _local3 = [];
            _local4 = Math.min(_local6.length, 6);
            _local5 = 0;
            while (_local5 < _local4) {
                _local8.push(_local6[_local5]);
                if (_local5 == 2){
                    _local3.push(_local8);
                    _local8 = new Array();
                };
                _local5++;
            };
            _local3.push(_local8);
            this.buffs.dataPro = _local3;
            this.CounterWorkerInfoUI.addChild(this.buffs);
        }
        protected function setBlood(_arg1:uint=0):void{
            var _local2:MovieClip = (this.CounterWorkerInfoUI.mc_redOneMask as MovieClip);
            var _local3:MovieClip = (this.CounterWorkerInfoUI.mc_buleOneMask as MovieClip);
            des_w2 = (Math.min((role.HP / (role.MaxHp + role.AdditionAtt.MaxHP)), 1) * 124);
            des_w5 = (Math.min((role.MP / (role.MaxMp + role.AdditionAtt.MaxMP)), 1) * 118);
            if (des_w2 == 124){
                TweenLite.to(_local2, 0, {width:des_w2});
            } else {
                TweenLite.to(_local2, 0.5, {width:des_w2});
            };
            if (des_w5 == 118){
                TweenLite.to(_local3, 0, {width:des_w5});
            } else {
                TweenLite.to(_local3, 0.5, {width:des_w5});
            };
        }
        protected function delayUpdate(_arg1:uint=1000):void{
            setTimeout(this.update, _arg1);
        }

    }
}//package GameUI.Modules.PlayerInfo.Mediator 
