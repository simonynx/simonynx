//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ChangeLine.View {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.View.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.WineParty.Data.*;
    import GameUI.Modules.Arena.Data.*;
    import GameUI.Modules.ChangeLine.Command.*;
    import flash.system.*;
    import GameUI.*;

    public class ChangeLineMediator extends Mediator {

        public static const NAME:String = "ChangeLineMediator";

        private var serverList:Array;
        private var cellContainer:Sprite;
        private var nameArr:Array;
        private var aCell:Array;
        private var dataProxy:DataProxy;
        private var keyScreen_mc:MovieClip;
        private var newLineId:int;
        private var timeOutId:int;
        private var bgPanel:MovieClip;

        public function ChangeLineMediator(){
            bgPanel = new MovieClip();
            aCell = [];
            super(NAME);
        }
        private function clickKeyScreen(_arg1:MouseEvent):void{
            setScreenTxt();
        }
        public function get changeLineView():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function clickCell(_arg1:MouseEvent):void{
            this.newLineId = _arg1.currentTarget.sIndex;
            if (!checkCanChangeLine()){
                return;
            };
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:chooseServer,
                cancel:cancelClose,
                info:LanguageMgr.GetTranslation("是否换线句"),
                title:LanguageMgr.GetTranslation("提 示")
            });
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.CHANGELINEUI
                    });
                    facade.registerCommand(ChgLineSendCommand.NAME, ChgLineSendCommand);
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    initData();
                    initUI();
                    break;
                case ChgLineData.UPDATA_SERVER:
                    refreData();
                    break;
                case ChgLineData.CHG_LINE_GO:
                    goNewLine();
                    break;
                case ChgLineData.CHG_LINE_SUC:
                    chgSucHandler();
                    break;
                case ChgLineData.CHG_LINE_FAIL:
                    SpeciallyEffectController.endCircle();
                    ChgLineData.flyLineId = 0;
                    ChgLineData.isChgLine = false;
                    ChgLineData.isChooseLine = false;
                    changeLineView.addEventListener(MouseEvent.MOUSE_DOWN, showList);
                    break;
                case ChgLineData.ONE_KEY_HIDE:
                    setScreenTxt();
                    break;
                case ChgLineData.PARTY_GO_LINE:
                    this.newLineId = int(_arg1.getBody());
                    if (checkCanChangeLine()){
                        GameCommonData.IsGotoParty = true;
                        chooseServer();
                    } else {
                        if (newLineId == GameConfigData.CurrentServerId){
                            GameCommonData.IsGotoParty = false;
                            UIFacade.GetInstance().sendNotification(WinPartEvent.SEND_GOTO_PARTY);
                        };
                    };
                    break;
                case ChgLineData.ARENA_GO_LINE:
                    this.newLineId = int(_arg1.getBody());
                    if (checkCanChangeLine()){
                        GameCommonData.IsGotoArena = true;
                        chooseServer();
                    } else {
                        if (newLineId == GameConfigData.CurrentServerId){
                            GameCommonData.IsGotoArena = false;
                            UIFacade.GetInstance().sendNotification(ArenaEvent.SEND_GO_ARENA);
                        };
                    };
                    break;
                case ChgLineData.CSB_GO_LINE:
                    this.newLineId = int(_arg1.getBody());
                    if (checkCanChangeLine()){
                        GameCommonData.IsGotoCSB = true;
                        chooseServer();
                    } else {
                        if (newLineId == GameConfigData.CurrentServerId){
                            GameCommonData.IsGotoCSB = false;
                            UIFacade.GetInstance().sendNotification(EventList.CSB_GOREADYSCENE);
                        };
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    changeLineView.x = (GameCommonData.GameInstance.ScreenWidth - 243);
                    cellContainer.x = (GameCommonData.GameInstance.ScreenWidth - 243);
                    break;
            };
        }
        private function checkCanChangeLine():Boolean{
            if (ChgLineData.isChgLine){
                return (false);
            };
            if (GameCommonData.Player.Role.HP == 0){
                MessageTip.show(LanguageMgr.GetTranslation("死亡不能换线"));
                return (false);
            };
            if (dataProxy.TradeIsOpen){
                MessageTip.popup(LanguageMgr.GetTranslation("交易时不允许换线"));
                return (false);
            };
            if (GameCommonData.Player.Role.StallId > 0){
                MessageTip.popup(LanguageMgr.GetTranslation("摆摊时不允许换线"));
                return (false);
            };
            if (GameCommonData.Player.IsAutomatism){
                MessageTip.popup(LanguageMgr.GetTranslation("挂机时不能换线"));
                return (false);
            };
            if (newLineId == GameConfigData.CurrentServerId){
                return (false);
            };
            return (true);
        }
        private function clearCell():void{
            var _local1:uint;
            if (aCell.length > 0){
                _local1 = 0;
                while (_local1 < aCell.length) {
                    if (((aCell[_local1]) && (cellContainer.contains(aCell[_local1])))){
                        cellContainer.removeChild(aCell[_local1]);
                        aCell[_local1] = null;
                    };
                    _local1++;
                };
            };
        }
        private function refreData():void{
            var _local1:Array;
            var _local2:Object;
            var _local3:uint;
            serverList = [];
            while (_local3 < GameCommonData.GameServerArr.length) {
                _local1 = GameCommonData.GameServerArr[_local3];
                _local2 = new Object();
                _local2.index = _local1[0];
                _local2.num = _local1[1];
                dealObj(_local2);
                if (_local2.name != ""){
                    if (_local2.index == GameConfigData.CurrentServerId){
                        GameConfigData.GameSeverNum = _local2.num;
                    };
                    if (_local2.index != GameConfigData.CurrentServerId){
                        serverList.push(_local2);
                    };
                };
                _local3++;
            };
            initCell();
            changeLineView.curServer_txt.htmlText = (ChgLineData.getNameByIndex(GameConfigData.CurrentServerId) + isFull(GameConfigData.GameSeverNum));
        }
        private function initUI():void{
            changeLineView.x = (GameCommonData.GameInstance.ScreenWidth - 243);
            changeLineView.y = 5;
            changeLineView.tabEnabled = false;
            changeLineView.tabChildren = false;
            changeLineView.curServer_txt.textColor = 12492895;
            changeLineView.curServer_txt.mouseEnabled = false;
            changeLineView.curServer_txt.htmlText = (ChgLineData.getNameByIndex(GameConfigData.CurrentServerId) + isFull(GameConfigData.GameSeverNum));
            changeLineView.buttonMode = true;
            changeLineView.name = "changeLineView";
            changeLineView.addEventListener(MouseEvent.MOUSE_DOWN, showList);
            changeLineView.addEventListener(MouseEvent.MOUSE_OVER, overMainHandler);
            GameCommonData.GameInstance.GameUI.addChild(changeLineView);
            GameCommonData.GameInstance.stage.addEventListener(MouseEvent.MOUSE_DOWN, closeList);
            cellContainer = new Sprite();
            cellContainer.mouseEnabled = false;
            cellContainer.x = (GameCommonData.GameInstance.ScreenWidth - 243);
            cellContainer.y = 18.5;
            this.bgPanel = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ListBack");
            bgPanel.width = 90.5;
            bgPanel.x = 0.5;
            bgPanel.y = 2;
            cellContainer.addChild(bgPanel);
            initCell();
        }
        private function initCell():void{
            var _local1:int;
            var _local2:uint;
            var _local3:String;
            var _local4:ChgListCell;
            var _local5:uint;
            clearCell();
            aCell = [];
            serverList.sortOn("index", Array.NUMERIC);
            bgPanel.height = ((18 * serverList.length) + 0.5);
            while (_local5 < serverList.length) {
                _local1 = serverList[_local5].index;
                _local2 = uint(serverList[_local5].num);
                if (_local1 == 10){
                    _local5++;
                } else {
                    _local3 = isFull(_local2);
                    _local4 = new ChgListCell(_local1, _local3);
                    _local4.addEventListener(MouseEvent.MOUSE_DOWN, clickCell);
                    _local4.x = 1;
                    _local4.y = (_local5 * 18);
                    aCell.push(_local4);
                    cellContainer.addChild(_local4);
                    _local5++;
                };
            };
        }
        private function showList(_arg1:MouseEvent):void{
            if (((MapManager.IsInCSBattleReadyScene) || (GameCommonData.IsInCrossServer))){
                return;
            };
            if (!GameCommonData.GameInstance.GameUI.contains(cellContainer)){
                _arg1.stopPropagation();
                GameCommonData.GameInstance.GameUI.addChild(cellContainer);
                return;
            };
            GameCommonData.GameInstance.GameUI.removeChild(cellContainer);
        }
        private function isFull(_arg1:uint):String{
            var _local2:String;
            var _local3:Number = ((_arg1 / ChgLineData.maxServerPerson) * 100);
            if ((((_local3 >= 0)) && ((_local3 <= 30)))){
                _local2 = (("<font color='#00ff00'>（" + LanguageMgr.GetTranslation("流畅")) + "）</font>");
                return (_local2);
            };
            if ((((_local3 > 30)) && ((_local3 <= 80)))){
                _local2 = (("<font color='#ffff00'>（" + LanguageMgr.GetTranslation("正常")) + "）</font>");
                return (_local2);
            };
            _local2 = (("<font color='#ff0000'>（" + LanguageMgr.GetTranslation("繁忙")) + "）</font>");
            return (_local2);
        }
        private function initData():void{
            var _local1:Object;
            var _local2:Array;
            var _local3:uint;
            serverList = [];
            while (_local3 < GameCommonData.GameServerArr.length) {
                _local1 = new Object();
                _local2 = GameCommonData.GameServerArr[_local3];
                _local1.index = _local2[0];
                _local1.num = _local2[1];
                dealObj(_local1);
                if (((!((_local1.name == ""))) && (!((_local1.index == GameConfigData.CurrentServerId))))){
                    serverList.push(_local1);
                };
                _local3++;
            };
        }
        private function chooseServer():void{
            if (ChgLineData.isChooseLine){
                trace("点太快了，稍后再点！");
                return;
            };
            ChgLineData.flyLineId = newLineId;
            if (GameConfigData.CurrentServerId == ChgLineData.flyLineId){
                return;
            };
            ChgLineData.isChooseLine = true;
            GameConnectSend.GetLineList();
        }
        private function overMainHandler(_arg1:MouseEvent):void{
            changeLineView.gotoAndStop(2);
            changeLineView.removeEventListener(MouseEvent.MOUSE_OVER, overMainHandler);
            changeLineView.addEventListener(MouseEvent.MOUSE_OUT, outMainHandler);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, ChgLineData.UPDATA_SERVER, ChgLineData.CHG_LINE_GO, ChgLineData.CHG_LINE_SUC, ChgLineData.CHG_LINE_FAIL, ChgLineData.ONE_KEY_HIDE, ChgLineData.PARTY_GO_LINE, ChgLineData.ARENA_GO_LINE, ChgLineData.CSB_GO_LINE, EventList.RESIZE_STAGE]);
        }
        private function setScreenTxt():void{
            if (ScreenController.IsCanChangeScreen){
                ScreenController.SetScreen();
            };
            if (keyScreen_mc){
                switch (GameCommonData.Screen){
                    case 2:
                        (keyScreen_mc.hint_txt as TextField).text = LanguageMgr.GetTranslation("一键屏蔽");
                        break;
                    case 0:
                        (keyScreen_mc.hint_txt as TextField).text = LanguageMgr.GetTranslation("显示玩家");
                        break;
                    case 1:
                        (keyScreen_mc.hint_txt as TextField).text = LanguageMgr.GetTranslation("显示宠物");
                        break;
                };
            };
        }
        private function cancelClose():void{
        }
        private function dealObj(_arg1:Object):void{
            _arg1.name = ChgLineData.getNameByIndex(_arg1.index);
        }
        private function chgSucHandler():void{
            if (changeLineView){
                changeLineView.curServer_txt.htmlText = (ChgLineData.getNameByIndex(GameConfigData.CurrentServerId) + isFull(GameConfigData.GameSeverNum));
            };
            ChgLineData.flyLineId = 0;
            SpeciallyEffectController.endCircle();
            changeLineView.addEventListener(MouseEvent.MOUSE_DOWN, showList);
            facade.sendNotification(HintEvents.RECEIVEINFO, {
                info:(LanguageMgr.GetTranslation("成功切换至服务器") + ChgLineData.getNameByIndex(GameConfigData.CurrentServerId)),
                color:0xFFFF00
            });
            GameCommonData.Player.Role.UsingPetAnimal = null;
            if (GameCommonData.Player.Role.UsingPet){
                GameCommonData.Player.Role.UsingPet.IsUsing = false;
                sendNotification(PlayerInfoComList.REMOVE_PET_UI);
                GameCommonData.Player.Role.UsingPet = null;
            };
            sendNotification(TeamEventName.LEAVE_TEAM_AFTER_CHANGE_LINE);
            ChgLineData.isChgLine = false;
            ChgLineData.isChooseLine = false;
            sendNotification(FriendCommandList.FRIEND_INFO_CLEAR);
            initData();
            initCell();
            changeLineView.curServer_txt.htmlText = (ChgLineData.getNameByIndex(GameConfigData.CurrentServerId) + isFull(GameConfigData.GameSeverNum));
            if ((GameCommonData.Player.Role.OnLineAwardTime % 10) < 8){
            };
            FriendSend.getFriendList();
        }
        private function outMainHandler(_arg1:MouseEvent):void{
            changeLineView.gotoAndStop(1);
            changeLineView.removeEventListener(MouseEvent.MOUSE_OUT, outMainHandler);
            changeLineView.addEventListener(MouseEvent.MOUSE_OVER, overMainHandler);
        }
        private function closeList(_arg1:MouseEvent):void{
            if (((cellContainer) && (GameCommonData.GameInstance.GameUI.contains(cellContainer)))){
                GameCommonData.GameInstance.GameUI.removeChild(cellContainer);
            };
        }
        private function goNewLine():void{
            var i:* = 0;
            var aNewName:* = [];
            if (GameCommonData.IsChangeOnline){
                return;
            };
            while (i < GameCommonData.GameServerArr.length) {
                if (GameCommonData.GameServerArr[i][0] == ChgLineData.flyLineId){
                    if (GameCommonData.GameServerArr[i][1] > (ChgLineData.maxServerPerson - 20)){
                        trace("服务器爆满，无法切换");
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("爆满无法换线提示句0"),
                            color:0xFFFF00
                        });
                        ChgLineData.isChooseLine = false;
                        return;
                    };
                };
                aNewName.push(GameCommonData.GameServerArr[i][0]);
                i = (i + 1);
            };
            if (aNewName.indexOf(ChgLineData.flyLineId) == -1){
                refreData();
                trace("服务器繁忙，无法切换");
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("繁忙无法换线提示句0"),
                    color:0xFFFF00
                });
                ChgLineData.isChooseLine = false;
                return;
            };
            try {
                initData();
            } catch(e:Error) {
                trace("服务器繁忙，无法切换");
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("繁忙无法换线提示句2"),
                    color:0xFFFF00
                });
                ChgLineData.isChooseLine = false;
                return;
            };
            SpeciallyEffectController.startCircle();
            if (GameCommonData.TargetAnimal){
                GameCommonData.TargetAnimal.IsSelect(false);
                GameCommonData.TargetAnimal = null;
                UIFacade.GetInstance().selectPlayer();
            };
            UIFacade.UIFacadeInstance.closeOpenPanel();
            JianTouMc.getInstance().close();
            facade.sendNotification(ChgLineSendCommand.NAME);
        }

    }
}//package GameUI.Modules.ChangeLine.View 
