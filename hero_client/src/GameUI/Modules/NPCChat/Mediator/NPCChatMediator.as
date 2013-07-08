//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import Net.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.PackHandler.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.NPCChat.Proxy.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.NPCExchange.Mediator.*;
    import GameUI.Modules.NPCShop.Mediator.*;
    import Utils.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NPCChat.View.*;
    import GameUI.Modules.TreasureChests.Mediator.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.NPCChat.Command.*;
    import GameUI.Modules.NPCExchange.Data.*;
    import GameUI.Modules.NPCShop.Data.*;
    import flash.system.*;
    import GameUI.*;

    public class NPCChatMediator extends Mediator {

        public static const DEFAULTPOS:Point = new Point(80, 58);
        public static const STATE_END:int = 2;
        public static const NAME:String = "NPCChatMediator";
        public static const STATE_TASK:int = 1;
        public static const STATE_MENU:int = 0;

        public static var NPCChatIsOpen:Boolean = false;

        public var taskId:int;
        private var menuSprite:Sprite;
        private var npcName:String;
        private var faceItem:FaceItem;
        private var state:int = -1;
        private var rewardPanel:RewardPanel;
        private var changeJobFrame:ChangeJobFrame;
        public var nextTF:NpcChatTaskNextLink;
        private var taskTalkDesArr:Array;
        private var mosterId:uint;
        private var menuCells:Array;
        private var linkId:int;
        private var taskCells:Array;
        public var npcId:uint;
        protected var pipeDataProxy:PipeDataProxy;
        private var npcElement:GameElementNPC;
        private var returnResult:Boolean = true;
        private var currentTaskTalkIdx:int;
        protected var conentUI:NPCDialogPanel;

        public function NPCChatMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        private function GuideAccept(_arg1:TaskInfoStruct):void{
            var _local2:int;
            var _local3:int;
            switch (_arg1.taskId){
                case NewGuideData.TASK_1:
                    _local2 = 1;
                    _local3 = 5;
                    break;
                default:
                    return;
            };
            if (currentTaskTalkIdx >= (taskTalkDesArr.length - 1)){
                if (((_arg1) && (_arg1.IsComplete))){
                } else {
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:_local2,
                        STEP:_local3
                    });
                };
            };
        }
        private function __faceLoadCompleteHandler(_arg1:Event):void{
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, __faceLoadCompleteHandler);
            _arg1.currentTarget.x = 0;
            _arg1.currentTarget.y = -(_arg1.currentTarget.height);
        }
        private function onLinkClick(_arg1:Object):void{
            var dataProxy:* = null;
            var body:* = null;
            var leaveTeam:* = null;
            var createTeam:* = null;
            var showTeamPanel:* = null;
            var comfirm:* = null;
            var cancel:* = null;
            var obj:* = _arg1;
            linkId = obj.linkId;
            var type:* = obj.type;
            var command:* = obj.command;
            var eventid:* = obj.EventID;
            var code:* = obj.code;
            var boxMessage:* = obj.boxm;
            if (code){
                body = new Object();
                body.boxMessage = boxMessage;
                body.npcID = this.npcId;
                body.linkId = linkId;
                facade.registerMediator(new XinShouLiBaoMediator());
                sendNotification(EventList.SHOW_NEW_GIFT, body);
                this.onCloseHandler(null);
                return;
            };
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            if (type == DialogConstData.CHATTYPE_TASK){
                if (((((((GameCommonData.TaskInfoDic[linkId] as TaskInfoStruct).flags == 1)) && (!((GameCommonData.TaskInfoDic[linkId] as TaskInfoStruct).IsAccept)))) && (!(GameCommonData.TaskInfoDic[linkId].IsComplete)))){
                    sendNotification(EventList.SHOW_CONVOY_UI, {
                        npcId:this.npcId,
                        taskId:linkId
                    });
                    this.onCloseHandler(null);
                } else {
                    showTask(linkId);
                };
            } else {
                if (type == DialogConstData.CHATTYPE_OTHER){
                    if (dataProxy.NPCExchangeIsOpen){
                        sendNotification(EventList.CLOSENPCEXCHANGEVIEW);
                    };
                    if (dataProxy.NPCShopIsOpen){
                        sendNotification(EventList.CLOSENPCSHOPVIEW);
                    };
                    switch (eventid){
                        case 1000:
                            if (GameCommonData.Player.Role.isStalling > 0){
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:LanguageMgr.GetTranslation("摆摊时无法进行强化"),
                                    color:0xFFFF00
                                });
                                return;
                            };
                            sendNotification(EquipCommandList.CLOSE_EQ_PANELS_CHANGE_SENCE);
                            sendNotification(EquipCommandList.SHOW_EQUIPSTRENGTHEN_UI);
                            break;
                        case 1002:
                            if (GameCommonData.Player.Role.isStalling > 0){
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:LanguageMgr.GetTranslation("摆摊时无法进行神兵打造"),
                                    color:0xFFFF00
                                });
                                return;
                            };
                            sendNotification(EquipCommandList.CLOSE_EQ_PANELS_CHANGE_SENCE);
                            sendNotification(EquipCommandList.SHOW_TREASUREREBUILD_UI);
                            break;
                        case 6:
                            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                            if (GameCommonData.Player.Role.Id){
                                if (dataProxy.StallIsOpen){
                                    facade.sendNotification(EventList.CLOSESTALL);
                                };
                                sendNotification(EventList.SHOWDEPOTVIEW);
                            };
                            break;
                        case 50001:
                        case 50002:
                        case 50003:
                        case 50004:
                            if (GameCommonData.Player.Role.Level > 40){
                                if (((!(BagData.isHasItem(30500001))) && (!((eventid == 50004))))){
                                    facade.sendNotification(EventList.SHOWALERT, {
                                        comfrim:new Function(),
                                        cancel:null,
                                        isShowClose:false,
                                        info:LanguageMgr.GetTranslation("缺乏相应道具"),
                                        title:LanguageMgr.GetTranslation("提示"),
                                        comfirmTxt:LanguageMgr.GetTranslation("确定")
                                    });
                                    return;
                                };
                                if (((!(BagData.isHasItem(30500002))) && ((eventid == 50004)))){
                                    facade.sendNotification(EventList.SHOWALERT, {
                                        comfrim:new Function(),
                                        cancel:null,
                                        isShowClose:false,
                                        info:LanguageMgr.GetTranslation("缺乏相应道具"),
                                        title:LanguageMgr.GetTranslation("提示"),
                                        comfirmTxt:LanguageMgr.GetTranslation("确定")
                                    });
                                    return;
                                };
                            };
                            facade.sendNotification(EventList.SHOWALERT, {
                                comfrim:sure,
                                cancel:new Function(),
                                isShowClose:false,
                                info:LanguageMgr.GetTranslation("该操作会让你技能点重置"),
                                title:LanguageMgr.GetTranslation("提示"),
                                comfirmTxt:LanguageMgr.GetTranslation("确定"),
                                cancelTxt:LanguageMgr.GetTranslation("取消")
                            });
                            return;
                        case 160000:
                        case 160001:
                        case 160002:
                        case 160003:
                        case 160004:
                        case 160005:
                            sendNotification(UnityEvent.SHOW_GUILDDONATEPANEL, (eventid - 160000));
                            break;
                        case 1003:
                            sendNotification(EventList.SHOW_GOLDLEAFVIEW);
                            break;
                        case 4:
                            changeJobFrame = new ChangeJobFrame(this.npcId, this.linkId, command);
                            changeJobFrame.show();
                            break;
                        case 10000:
                            if (NPCShopConstData.goodList[mosterId] == null){
                                sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                    npcId:npcId,
                                    linkId:linkId
                                });
                            } else {
                                facade.registerMediator(new NPCShopMediator());
                                sendNotification(EventList.SHOWNPCSHOPVIEW, {
                                    npcId:npcId,
                                    shopType:1,
                                    shopName:GameCommonData.SameSecnePlayerList[npcId].Role.Name
                                });
                            };
                            break;
                        case 10001:
                            if (NPCExchangeConstData.goodList[mosterId] == null){
                                sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                    npcId:npcId,
                                    linkId:linkId
                                });
                            } else {
                                facade.registerMediator(new NPCExchangeMediator());
                                sendNotification(EventList.SHOWNPCEXCHANGEVIEW, {
                                    npcId:npcId,
                                    shopName:GameCommonData.SameSecnePlayerList[npcId].Role.Name
                                });
                            };
                            break;
                        case 1006:
                            facade.sendNotification(EventList.SHOWALERT, {
                                comfrim:sureTored,
                                cancel:new Function(),
                                isShowClose:false,
                                info:LanguageMgr.GetTranslation("很长的花费确认后离开监狱提示句"),
                                title:LanguageMgr.GetTranslation("提示"),
                                comfirmTxt:LanguageMgr.GetTranslation("确定"),
                                cancelTxt:LanguageMgr.GetTranslation("取消")
                            });
                            break;
                        case 142018:
                            if (GameCommonData.Player.Role.idTeam > 0){
                                leaveTeam = function ():void{
                                    TeamSend.LeaveTeam();
                                    sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                        npcId:npcId,
                                        linkId:linkId
                                    });
                                    onCloseHandler(null);
                                };
                                facade.sendNotification(EventList.SHOWALERT, {
                                    comfrim:leaveTeam,
                                    cancel:new Function(),
                                    isShowClose:false,
                                    info:LanguageMgr.GetTranslation("退出队伍之后再进入单人副本询问是否退出"),
                                    title:LanguageMgr.GetTranslation("提示"),
                                    comfirmTxt:LanguageMgr.GetTranslation("确定"),
                                    cancelTxt:LanguageMgr.GetTranslation("取消")
                                });
                                return;
                            };
                            sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                npcId:npcId,
                                linkId:linkId
                            });
                            break;
                        case 142001:
                            if (GameCommonData.Player.Role.idTeam == 0){
                                createTeam = function ():void{
                                    TeamSend.CreateTeam();
                                    onCloseHandler(null);
                                };
                                showTeamPanel = function ():void{
                                    if (!dataProxy.TeamIsOpen){
                                        sendNotification(EventList.SHOWTEAM);
                                    };
                                    onCloseHandler(null);
                                };
                                facade.sendNotification(EventList.SHOWALERT, {
                                    comfrim:createTeam,
                                    cancel:showTeamPanel,
                                    isShowClose:true,
                                    info:LanguageMgr.GetTranslation("你现在还末组队请选择"),
                                    title:LanguageMgr.GetTranslation("提示"),
                                    comfirmTxt:LanguageMgr.GetTranslation("创建队伍"),
                                    cancelTxt:LanguageMgr.GetTranslation("加入队伍")
                                });
                                return;
                            };
                            sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                npcId:npcId,
                                linkId:linkId
                            });
                            break;
                        case 1004:
                            sendNotification(TranscriptEvent.SHOW_TRANSCRIPT_INFO, 1);
                            break;
                        case 1005:
                            sendNotification(TranscriptEvent.SHOW_SELECT_TOWER_VIEW);
                            break;
                        case 15:
                            if (((GameCommonData.TranscriptFinish) && ((GameCommonData.Player.Role.Level >= 36)))){
                                comfirm = function ():void{
                                    sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                        npcId:npcId,
                                        linkId:linkId
                                    });
                                };
                                cancel = function ():void{
                                    PlayerActionSend.highLevelOper(0, 0);
                                    GameCommonData.TranscriptFinish = false;
                                };
                                sendNotification(EventList.SHOWALERT, {
                                    comfrim:comfirm,
                                    cancel:cancel,
                                    isShowClose:false,
                                    info:LanguageMgr.GetTranslation("是否再次征战[x]副本", GameCommonData.GameInstance.GameScene.GetGameScene.MapName),
                                    title:LanguageMgr.GetTranslation("提 示"),
                                    comfirmTxt:LanguageMgr.GetTranslation("离开副本"),
                                    cancelTxt:LanguageMgr.GetTranslation("再来一次")
                                });
                            } else {
                                sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                    npcId:npcId,
                                    linkId:linkId
                                });
                            };
                            break;
                        default:
                            sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                npcId:npcId,
                                linkId:linkId
                            });
                    };
                    this.onCloseHandler(null);
                } else {
                    if (type == DialogConstData.CHATTYPE_EXIT){
                        this.onPanelCloseHandler(true);
                    };
                };
            };
        }
        private function sure():void{
            sendNotification(NPCChatComList.SEND_NPC_MSG, {
                npcId:npcId,
                linkId:linkId
            });
        }
        private function addEvents():void{
            view.addEventListener(MouseEvent.CLICK, __mouseDownHandler);
            nextTF.addEventListener(MouseEvent.MOUSE_DOWN, __NextDown);
            nextTF.addEventListener(MouseEvent.MOUSE_UP, __NextUp);
            nextTF.addEventListener(MouseEvent.MOUSE_OUT, __NextOut);
        }
        private function initAddExpEffect():void{
            var _local1:Array = TaskEffectConstData.urls;
            var _local2:LoadSwfTool = new LoadSwfTool(_local1[3]);
            _local2.sendShow = allLoadComp;
            TaskEffectConstData.loadswfTool = _local2;
        }
        private function calexpEffectDesP(_arg1:int):Point{
            var _local5:Number;
            var _local2:uint = UIConstData.ExpDic[GameCommonData.Player.Role.Level];
            var _local3:uint = GameCommonData.Player.Role.Exp;
            _local3 = (_local3 + _arg1);
            var _local4:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene")["mcExp"] as MovieClip);
            if (_local3 > _local2){
                _local3 = (_local3 - _local2);
                _local2 = UIConstData.ExpDic[(GameCommonData.Player.Role.Level + 1)];
                _local5 = ((_local3 / _local2) * _local4.width);
            } else {
                _local5 = ((_local3 / _local2) * _local4.width);
            };
            var _local6:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene")["mcExpMask"] as MovieClip);
            var _local7:Rectangle = _local6.getBounds(GameCommonData.GameInstance.MainStage);
            var _local8:Point = new Point(((_local7.x + _local5) - 15), ((_local7.y - _local7.height) - 10));
            return (_local8);
        }
        private function sureTored():void{
            if (GameCommonData.Player.Role.Money > 60000){
                PlayerActionSend.atonement();
            } else {
                MessageTip.show(LanguageMgr.GetTranslation("您的余额不足,请及时充值"));
            };
        }
        private function doLayout():void{
            var _local2:LinkCell;
            var _local4:Number;
            var _local1:Number = 0;
            view.desTF.height = (view.desTF.numLines * 18);
            _local1 = (view.desTF.y + view.desTF.height);
            if (rewardPanel){
                rewardPanel.x = 18;
                rewardPanel.y = (_local1 + 10);
                _local1 = (rewardPanel.y + rewardPanel.height);
            };
            view.desMc.height = (_local1 + 20);
            view.menuMc.y = ((view.desMc.y + view.desMc.height) + 2);
            menuSprite.x = view.menuMc.x;
            menuSprite.y = view.menuMc.y;
            var _local3:Number = 15;
            for each (_local2 in this.menuCells) {
                _local2.x = 20;
                _local2.y = _local3;
                _local3 = (_local3 + (_local2.height + 10));
            };
            _local4 = 15;
            for each (_local2 in this.taskCells) {
                _local2.x = 140;
                _local2.y = _local4;
                _local4 = (_local4 + (_local2.height + 10));
            };
            if (nextTF.visible){
                nextTF.x = 210;
                nextTF.y = (menuSprite.y + 15);
            };
            view.menuMc.height = (Math.max(_local3, _local4) + 10);
            view.y = (((GameCommonData.GameInstance.ScreenHeight / 2) - menuSprite.y) + 80);
        }
        private function showTask(_arg1:int):void{
            this.state = STATE_TASK;
            this.taskId = _arg1;
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1];
            if (_local2.IsAccept){
                if (_local2.IsComplete){
                    taskTalkDesArr = _local2.taskFinish.split("@@");
                } else {
                    taskTalkDesArr = [_local2.taskUnFinish];
                };
            } else {
                taskTalkDesArr = _local2.taskDes.split("@@");
            };
            currentTaskTalkIdx = -1;
            __nextPageHandler();
        }
        public function get view():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        protected function onPanelCloseHandler(_arg1:Boolean):void{
            var _local2:int;
            var _local3:String;
            var _local4:TextEvent;
            returnResult = true;
            if (GameCommonData.NPCDialogIsOpen){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
            };
            if (((_arg1) && ((GameCommonData.Player.Role.Level <= 12)))){
                switch (state){
                    case STATE_MENU:
                        if (taskCells.length > 0){
                            _local2 = (taskCells[0] as LinkCell).linkId;
                            showTask(_local2);
                            _local3 = GetTaskEventText(nextTF.htmlText);
                            _local4 = new TextEvent(TextEvent.LINK, false, false, _local3);
                            __textEventHandler(_local4);
                        };
                        break;
                    case STATE_TASK:
                        _local3 = GetTaskEventText(nextTF.htmlText);
                        _local4 = new TextEvent(TextEvent.LINK, false, false, _local3);
                        __textEventHandler(_local4);
                        break;
                };
            };
            if (GameCommonData.GameInstance.GameUI.contains(view)){
                GameCommonData.GameInstance.GameUI.removeChild(view);
            };
            GameCommonData.NPCDialogIsOpen = false;
            if (((rewardPanel) && (rewardPanel.parent))){
                rewardPanel.parent.removeChild(rewardPanel);
            };
            rewardPanel = null;
            npcElement = null;
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:String;
            var _local3:Array;
            var _local4:Boolean;
            var _local5:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:"NPCChatAsset"
                    });
                    facade.registerCommand(NPCChatComList.SEND_NPC_MSG, SendNPCMsgCommand);
                    facade.registerCommand(EventList.SELECTED_NPC_ELEMENT, SelectedNPCCommand);
                    facade.registerProxy(new PipeDataProxy());
                    initAddExpEffect();
                    initView();
                    addEvents();
                    break;
                case NPCChatComList.SHOW_NPC_CHAT:
                    this.npcId = (_arg1.getBody() as uint);
                    mosterId = GameCommonData.SameSecnePlayerList[npcId].Role.MonsterTypeID;
                    if (((((facade.hasCommand(Guide_OccupationIntro_Command.NAME)) && (!((mosterId == 0))))) && (!((TaskCommonData.LoopTaskCommitNpcArrTemp.indexOf(mosterId) == -1))))){
                        sendNotification(Guide_OccupationIntro_Command.NAME, {
                            type:1,
                            mosterId:mosterId
                        });
                        return;
                    };
                    this.pipeDataProxy = (facade.retrieveProxy(PipeDataProxy.NAME) as PipeDataProxy);
                    pipeDataProxy.linkArr.push({
                        iconUrl:DialogConstData.getInstance().getSymbolName(1),
                        showText:LanguageMgr.GetTranslation("离开"),
                        linkId:0,
                        type:DialogConstData.CHATTYPE_EXIT
                    });
                    if (NewGuideData.newerHelpIsOpen){
                        _local5 = 0;
                        while (_local5 < pipeDataProxy.linkArr.length) {
                            if (((((((pipeDataProxy.linkArr[_local5]) && ((pipeDataProxy.linkArr[_local5].type == DialogConstData.CHATTYPE_TASK)))) && ((pipeDataProxy.linkArr[_local5].linkId == 1001)))) && (!(GameCommonData.TaskInfoDic[1001].IsComplete)))){
                                pipeDataProxy.linkArr.splice(_local5, 1);
                                break;
                            };
                            _local5++;
                        };
                    };
                    if (GameCommonData.SameSecnePlayerList != null){
                        npcElement = (GameCommonData.SameSecnePlayerList[npcId] as GameElementNPC);
                        if (npcElement){
                            npcName = npcElement.Role.Name;
                        };
                    };
                    if (npcElement == null){
                        return;
                    };
                    _local2 = this.pipeDataProxy.desText;
                    _local3 = this.pipeDataProxy.linkArr;
                    this.pipeDataProxy.reset();
                    nextTF.visible = false;
                    this.view.visible = true;
                    showInfo(_local2, _local3);
                    view.x = ((GameCommonData.GameInstance.ScreenWidth - (view.width - 80)) / 2);
                    GameCommonData.GameInstance.GameUI.addChild(view);
                    GameCommonData.NPCDialogIsOpen = true;
                    if (NewGuideData.newerHelpIsOpen){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
                        if ((((NewGuideData.curType == 1)) && ((NewGuideData.curStep <= 3)))){
                            sendNotification(NewGuideEvent.NEWPLAYER_GUILD_CLOSEGUIDEFRAME);
                        };
                        if (taskCells.length > 0){
                            GuideSelectTask(taskCells[0].linkId);
                        };
                        if (menuCells[0]){
                            switch (menuCells[0].m_eventid){
                                case 142002:
                                    if (((GameCommonData.TaskInfoDic[NewGuideData.TASK_13].IsAccept) && (!(GameCommonData.TaskInfoDic[NewGuideData.TASK_13].IsComplete)))){
                                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                            TYPE:13,
                                            STEP:2,
                                            POINT:menuCells[0]
                                        });
                                    };
                                    break;
                                case 14:
                                    if (((GameCommonData.TaskInfoDic[NewGuideData.TASK_13].IsAccept) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_13].IsComplete))){
                                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                            TYPE:13,
                                            STEP:9,
                                            POINT:menuCells[0]
                                        });
                                    };
                                    break;
                                case 142018:
                                    if (((((GameCommonData.TaskInfoDic[NewGuideData.TASK_SHENGYUAN_SINGLE]) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_SHENGYUAN_SINGLE].IsAccept))) && (!(GameCommonData.TaskInfoDic[NewGuideData.TASK_SHENGYUAN_SINGLE].IsComplete)))){
                                        JianTouMc.getInstance().show(menuCells[0], "", 2, menuCells[0].getBounds(menuCells[0].stage));
                                    };
                                    break;
                                case 10001:
                                    facade.sendNotification(Guide_EquipExchangeCommand.NAME, {
                                        step:2,
                                        target:menuCells[0]
                                    });
                                    break;
                                case 142007:
                                    if (((((GameCommonData.TaskInfoDic[1306]) && (GameCommonData.TaskInfoDic[1306].IsAccept))) && (!(GameCommonData.TaskInfoDic[1306].IsComplete)))){
                                        JianTouMc.getInstance().show(menuCells[0], "", 2, menuCells[0].getBounds(menuCells[0].stage));
                                    };
                                    break;
                            };
                        };
                        if (menuCells[1]){
                            switch (menuCells[1].m_eventid){
                                case 150001:
                                    if (((((GameCommonData.TaskInfoDic[1306]) && (GameCommonData.TaskInfoDic[1306].IsAccept))) && (!(GameCommonData.TaskInfoDic[1306].IsComplete)))){
                                        JianTouMc.getInstance().show(menuCells[1], "", 2, menuCells[1].getBounds(menuCells[1].stage));
                                    };
                                    break;
                            };
                        };
                    };
                    break;
                case NPCChatComList.HIDE_NPC_CHAT:
                    onPanelCloseHandler(false);
                    break;
                case EventList.CLOSE_NPC_ALL_PANEL:
                    onPanelCloseHandler(true);
                    break;
                case EventList.RESIZE_STAGE:
                    if (GameCommonData.NPCDialogIsOpen){
                        view.x = ((GameCommonData.GameInstance.ScreenWidth - (view.width - 80)) / 2);
                        view.y = (((GameCommonData.GameInstance.ScreenHeight / 2) - menuSprite.y) + 80);
                    };
                    if (changeJobFrame){
                        changeJobFrame.x = ((GameCommonData.GameInstance.ScreenWidth - (changeJobFrame.width - 80)) / 2);
                        changeJobFrame.y = ((GameCommonData.GameInstance.ScreenHeight / 2) - 70);
                    };
                    break;
                case TaskCommandList.SHOW_TASKINFO_UI:
                    this.taskId = _arg1.getBody()["taskId"];
                    this.npcId = _arg1.getBody()["npcId"];
                    this.mosterId = GameCommonData.SameSecnePlayerList[npcId].Role.MonsterTypeID;
                    this.npcName = _arg1.getBody()["npcName"];
                    if (GameCommonData.SameSecnePlayerList != null){
                        npcElement = (GameCommonData.SameSecnePlayerList[npcId] as GameElementNPC);
                        if (npcElement){
                            npcName = npcElement.Role.Name;
                        };
                    };
                    if (npcElement == null){
                        return;
                    };
                    if (((faceItem) && (faceItem.parent))){
                        faceItem.parent.removeChild(faceItem);
                        faceItem = null;
                    };
                    faceItem = new FaceItem(String(npcElement.Role.Face), view, "NPCPic");
                    faceItem.x = 0;
                    faceItem.y = -(faceItem.height);
                    faceItem.addEventListener(Event.COMPLETE, __faceLoadCompleteHandler);
                    faceItem.mouseEnabled = false;
                    faceItem.mouseChildren = false;
                    view.addChild(faceItem);
                    showTask(taskId);
                    view.x = ((GameCommonData.GameInstance.ScreenWidth - (view.width - 80)) / 2);
                    view.y = (((GameCommonData.GameInstance.ScreenHeight / 2) - menuSprite.y) + 80);
                    GameCommonData.GameInstance.GameUI.addChild(view);
                    GameCommonData.NPCDialogIsOpen = true;
                    break;
                case NPCChatComList.NPCCHAT_VISIBLE:
                    _local4 = (_arg1.getBody() as Boolean);
                    this.view.visible = _local4;
                    break;
            };
        }
        private function __NextDown(_arg1:MouseEvent):void{
            _arg1.stopImmediatePropagation();
            nextTF.y = (menuSprite.y + 17);
        }
        private function GuideSelectTask(_arg1:int):void{
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[_arg1];
            if (_local2 == null){
                return;
            };
            var _local3:int;
            var _local4:int;
            switch (_local2.taskId){
                case NewGuideData.TASK_1:
                    if (!_local2.IsAccept){
                        _local3 = 1;
                        _local4 = 4;
                    } else {
                        if (_local2.IsComplete){
                            _local3 = 1;
                        };
                        _local4 = 8;
                    };
                    break;
                default:
                    return;
            };
            sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                TYPE:_local3,
                STEP:_local4,
                POINT:taskCells[0]
            });
        }
        private function __textEventHandler(_arg1:TextEvent):void{
            var _local3:int;
            var _local4:NetPacket;
            var _local5:QuestCondition;
            var _local6:int;
            if (ChgLineData.isChooseLine){
                return;
            };
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[taskId];
            if (_local2 == null){
                return;
            };
            state = STATE_END;
            switch (_arg1.text){
                case "next":
                    __nextPageHandler();
                    break;
                case "receiveTask":
                    if (GameCommonData.Player.Role.Level > _local2.maxLevel){
                        MessageTip.popup(LanguageMgr.GetTranslation("等级超过任务领取的最大等级"));
                        return;
                    };
                    if (GameCommonData.Player.Role.Level < _local2.minLevel){
                        MessageTip.popup(LanguageMgr.GetTranslation("等级小于任务领取的最小等级"));
                        return;
                    };
                    TaskSend.AcceptQuest(npcId, taskId);
                    _local3 = BagData.getPanelEmptyNum(0);
                    if ((((_local3 > 2)) && ((((_local2.taskType == QuestType.MAIN)) || ((_local2.taskType == QuestType.SIDE)))))){
                        _local4 = new NetPacket();
                        _local4.opcode = Protocol.SMSG_QUESTGIVER_GETQUEST;
                        _local4.writeUnsignedInt(_local2.taskId);
                        _local4.WriteString("");
                        _local4.writeUnsignedInt(0);
                        _local4.writeUnsignedInt(0);
                        _local4.writeUnsignedInt(0);
                        _local4.writeBoolean(true);
                        _local6 = 0;
                        while (_local6 < 3) {
                            _local5 = _local2.Conditions[_local6];
                            _local4.WriteString(_local5.description);
                            _local4.writeUnsignedInt(0);
                            _local4.writeUnsignedInt(_local5.Target);
                            _local6++;
                        };
                        _local4.position = 0;
                        if (_local2.limitTime == 0){
                            TaskAction.getInstance().Processor(_local4);
                            _local2.IsAccept = true;
                        };
                    };
                    break;
                case "completeTask":
                    if (returnResult == false){
                        return;
                    };
                    returnResult = false;
                    _local3 = BagData.getPanelEmptyNum(0);
                    if (_local3 >= (_local2.ItemRewards.length + ((_local2.ItemRewardsOptionals.length > 0)) ? 1 : 0)){
                        TaskSend.CompleteTask(npcId, taskId);
                        if (_local2.ItemRewards.length > 0){
                            itemMoveTween(_local2.ItemRewards);
                        };
                        addExpEffect();
                        if ((((_local2.taskType == QuestType.MAIN)) || ((_local2.taskType == QuestType.SIDE)))){
                            _local4 = new NetPacket();
                            _local4.opcode = Protocol.SMSG_QUESTLOG_REMOVE_QUEST;
                            _local4.writeUnsignedInt(_local2.taskId);
                            _local4.writeBoolean(true);
                            _local4.position = 0;
                            TaskAction.getInstance().Processor(_local4);
                            _local2.IsAccept = false;
                        };
                    } else {
                        MessageTip.popup(LanguageMgr.GetTranslation("背包满不能完成任务"));
                    };
                    break;
                case "closeTask":
                    onPanelCloseHandler(true);
                    break;
            };
            if (GameCommonData.Player.Role.Level <= 5){
                switch (_arg1.text){
                    case "receiveTask":
                        CharacterSend.sendCurrentStep((("点击接受任务(" + _local2.title) + ")"));
                        break;
                    case "completeTask":
                        CharacterSend.sendCurrentStep((("点击接受任务(" + _local2.title) + ")"));
                        break;
                };
            };
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
            IME.enabled = false;
        }
        private function createCells(_arg1:Array):void{
            var _local2:Object;
            var _local3:LinkCell;
            for each (_local2 in _arg1) {
                _local3 = new LinkCell(_local2.iconUrl, _local2.EventID, _local2.linkId, _local2.showText, _local2.type, _local2.code, _local2.boxmessage);
                _local3.onLinkClick = this.onLinkClick;
                menuSprite.addChild(_local3);
                if (_local2.type == DialogConstData.CHATTYPE_TASK){
                    taskCells.push(_local3);
                } else {
                    menuCells.push(_local3);
                };
            };
        }
        public function itemMoveTween(_arg1:Array):void{
            var _local7:QuestItemReward;
            var _local8:MovieClip;
            var _local9:BitmapData;
            var _local10:Bitmap;
            var _local11:Rectangle;
            var _local2:uint = getTimer();
            var _local3:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene")["btn_4"] as MovieClip);
            var _local4:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene") as MovieClip);
            var _local5:Point = _local4.localToGlobal(new Point(_local3.x, _local3.y));
            var _local6:int;
            while (_local6 < _arg1.length) {
                if (rewardPanel){
                    _local7 = (_arg1[_local6] as QuestItemReward);
                    _local8 = rewardPanel.goodsPanel.getUseItemBy(_local7.ItemId);
                    if (!_local8){
                    } else {
                        _local9 = new BitmapData(_local8.width, _local8.height, true, 0);
                        _local9.draw(_local8);
                        _local10 = new Bitmap(_local9);
                        _local11 = _local8.getBounds(_local8.stage);
                        _local10.x = _local11.x;
                        _local10.y = _local11.y;
                        GameCommonData.GameInstance.GameUI.addChild(_local10);
                        EffectLib.foodMove(_local10, _local5.x, _local5.y);
                    };
                };
                _local6++;
            };
            trace("耗时", (getTimer() - _local2));
        }
        protected function onCloseHandler(_arg1:MouseEvent):void{
            this.onPanelCloseHandler(false);
        }
        private function showInfo(_arg1:String, _arg2:Array):void{
            this.state = STATE_MENU;
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
                faceItem = null;
            };
            if ((((npcElement == null)) || ((npcElement.Role == null)))){
                return;
            };
            faceItem = new FaceItem(String(npcElement.Role.Face), view, "NPCPic");
            faceItem.x = 0;
            faceItem.y = -(faceItem.height);
            faceItem.addEventListener(Event.COMPLETE, __faceLoadCompleteHandler);
            view.addChild(faceItem);
            view.npcNameTF.htmlText = npcName;
            view.desTF.htmlText = _arg1;
            if (((rewardPanel) && (rewardPanel.parent))){
                rewardPanel.parent.removeChild(rewardPanel);
            };
            rewardPanel = null;
            removeAllMenuCells();
            createCells(_arg2);
            doLayout();
        }
        private function removeAllMenuCells():void{
            menuCells = [];
            taskCells = [];
            while (menuSprite.numChildren) {
                menuSprite.removeChildAt(0);
            };
        }
        private function __mouseDownHandler(_arg1:MouseEvent):void{
            var _local2:BitmapData;
            var _local3:Matrix;
            var _local4:String;
            var _local5:TextEvent;
            if (_arg1.target != view){
                return;
            };
            if (((_arg1.currentTarget) && (view))){
                if (((((faceItem) && ((view.width > 0)))) && ((view.height > 0)))){
                    _local2 = new BitmapData(view.width, view.height, true, 0);
                    _local3 = new Matrix();
                    _local3.translate(0, faceItem.height);
                    _local2.draw(view, _local3);
                    if (((_local2.getPixel32(_arg1.currentTarget.mouseX, (_arg1.currentTarget.mouseY + faceItem.height)) >> 24) & 0xFF) == 0){
                        GameCommonData.GameInstance.GameScene.GetGameScene.dispatchEvent(_arg1);
                    };
                };
                if (GameCommonData.Player.Role.Level <= 12){
                    switch (state){
                        case STATE_MENU:
                            if (taskCells.length > 0){
                                (taskCells[0] as LinkCell).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                            };
                            break;
                        case STATE_TASK:
                            _local4 = GetTaskEventText(nextTF.htmlText);
                            _local5 = new TextEvent(TextEvent.LINK, false, false, _local4);
                            __textEventHandler(_local5);
                            break;
                    };
                    _arg1.stopImmediatePropagation();
                };
            };
        }
        private function GetTaskEventText(_arg1:String):String{
            return (_arg1.replace(/.*<a href="event:(.*)" TARGET="".*/gi, "$1").replace(/([ ]{1})/g, ""));
        }
        private function initView():void{
            menuSprite = new Sprite();
            view.addChild(menuSprite);
            view.npcNameTF.mouseEnabled = false;
            view.desTF.mouseEnabled = false;
            view.desTF.multiline = true;
            view.desTF.wordWrap = true;
            view.desMc.mouseEnabled = false;
            view.desMc.mouseChildren = false;
            view.menuMc.mouseEnabled = false;
            view.desMc.mouseChildren = false;
            nextTF = new NpcChatTaskNextLink();
            nextTF.visible = false;
            view.addChild(nextTF);
        }
        private function GuideComplete(_arg1:TaskInfoStruct):void{
            var _local2:int;
            var _local3:int;
            switch (_arg1.taskId){
                case NewGuideData.TASK_1:
                    _local2 = 1;
                    _local3 = 9;
                    break;
                default:
                    return;
            };
            if (currentTaskTalkIdx >= (taskTalkDesArr.length - 1)){
                if (((_arg1) && (_arg1.IsComplete))){
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:_local2,
                        STEP:_local3
                    });
                };
            };
        }
        private function __NextOut(_arg1:MouseEvent):void{
            _arg1.stopImmediatePropagation();
            nextTF.y = (menuSprite.y + 15);
        }
        private function allLoadComp(_arg1):void{
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, NPCChatComList.SHOW_NPC_CHAT, NPCChatComList.HIDE_NPC_CHAT, EventList.CLOSE_NPC_ALL_PANEL, TaskCommandList.SHOW_TASKINFO_UI, NPCChatComList.NPCCHAT_VISIBLE, EventList.RESIZE_STAGE]);
        }
        private function __nextPageHandler():void{
            var _local1:TaskInfoStruct;
            currentTaskTalkIdx++;
            nextTF.visible = true;
            nextTF.reSetTextFormat();
            removeAllMenuCells();
            this.taskTalkDesArr[currentTaskTalkIdx] = this.taskTalkDesArr[currentTaskTalkIdx].replace(/\$MYNAME\$/g, GameCommonData.Player.Role.Name);
            this.taskTalkDesArr[currentTaskTalkIdx] = this.taskTalkDesArr[currentTaskTalkIdx].replace(/\$MYJOB\$/g, ((GameCommonData.Player.Role.MainJob.Job > 0)) ? GameCommonData.RolesListDic[GameCommonData.Player.Role.MainJob.Job] : "");
            createCells([{
                iconUrl:DialogConstData.getInstance().getSymbolName(1),
                showText:LanguageMgr.GetTranslation("离开"),
                linkId:0,
                type:DialogConstData.CHATTYPE_EXIT
            }]);
            view.desTF.htmlText = this.taskTalkDesArr[currentTaskTalkIdx];
            if (currentTaskTalkIdx >= (taskTalkDesArr.length - 1)){
                _local1 = GameCommonData.TaskInfoDic[taskId];
                if (((rewardPanel) && (rewardPanel.parent))){
                    rewardPanel.parent.removeChild(rewardPanel);
                    rewardPanel = null;
                };
                rewardPanel = new RewardPanel(_local1);
                rewardPanel.mouseEnabled = false;
                view.addChild(rewardPanel);
                if (_local1){
                    if (!_local1.IsAccept){
                        nextTF.htmlText = (("<a href=\"event:receiveTask\">       " + LanguageMgr.GetTranslation("接受任务")) + "                       </a>");
                    } else {
                        if (!_local1.IsComplete){
                            nextTF.htmlText = (("<a href=\"event:closeTask\">       " + LanguageMgr.GetTranslation("确定")) + "                      </a>");
                        } else {
                            if (_local1.IsComplete){
                                nextTF.htmlText = (("<a href=\"event:completeTask\">       " + LanguageMgr.GetTranslation("完成任务")) + "                      </a>");
                            };
                        };
                    };
                };
            } else {
                nextTF.htmlText = (("<a href=\"event:next\">       " + LanguageMgr.GetTranslation("下一步")) + "                      </a>");
            };
            doLayout();
            if (NewGuideData.newerHelpIsOpen){
                _local1 = GameCommonData.TaskInfoDic[taskId];
                if (!_local1.IsAccept){
                    GuideAccept(_local1);
                } else {
                    if (_local1.IsComplete){
                        GuideComplete(_local1);
                    };
                };
            };
        }
        private function __NextUp(_arg1:MouseEvent):void{
            _arg1.stopImmediatePropagation();
            nextTF.y = (menuSprite.y + 15);
            var _local2:String = GetTaskEventText(nextTF.htmlText);
            var _local3:TextEvent = new TextEvent(TextEvent.LINK, false, false, _local2);
            __textEventHandler(_local3);
        }
        private function addExpEffect():void{
            var _local1:Rectangle;
            var _local2:Point;
            var _local3:String;
            var _local4:Point;
            var _local5:Object;
            var _local6:String;
            if (GameCommonData.Player.Role.Level >= 100){
                return;
            };
            TaskEffectConstData.params = null;
            if (((rewardPanel) && (!((rewardPanel.expUI.Tf.text == ""))))){
                _local1 = rewardPanel.expUI.getBounds(GameCommonData.GameInstance.MainStage);
                _local2 = new Point((_local1.x + 40), _local1.y);
                _local3 = rewardPanel.expUI.Tf.text;
                _local3 = UIUtils.TrimString(_local3, 1);
                _local4 = calexpEffectDesP(int(_local3.substr(3)));
                _local3 = ("+" + _local3);
                _local5 = new Object();
                _local5.startP = _local2;
                _local5.desP = _local4;
                _local5.expStr = _local3;
                TaskEffectConstData.params = _local5;
            } else {
                return;
            };
            if (((TaskEffectConstData.loadswfTool) && (TaskEffectConstData.loadswfTool.ComplateLoaded))){
                _local5 = TaskEffectConstData.params;
                _local2 = _local5.startP;
                _local4 = _local5.desP;
                _local6 = _local5.expStr;
                EffectLib.addExpEffect(_local2.x, _local2.y, _local4.x, _local4.y, _local6);
            };
        }

    }
}//package GameUI.Modules.NPCChat.Mediator 
