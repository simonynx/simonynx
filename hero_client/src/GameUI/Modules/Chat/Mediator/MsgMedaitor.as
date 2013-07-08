//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Mediator {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.View.Components.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Chat.UI.*;
    import Net.RequestSend.*;
    import GameUI.Mediator.*;
    import GameUI.Modules.OpenItemBox.Data.*;

    public class MsgMedaitor extends Mediator {

        public static const NAME:String = "MsgMedaitor";

        private var delayNum:int = 12000;
        private var isShow:Boolean = false;
        private var leoMsg:Array;
        private var leoDelay:Number = 0;
        private var leoMsgView:MovieClip;
        private var curpos:int = 0;
        private var leoView:ChatCellText;
        private var iScrollPane:UIScrollPane;
        private var back:Sprite;
        private var msgArea:Sprite;
        private var tmpMsgList:Array;
        private var backAlpha:Array;

        public function MsgMedaitor(_arg1:Sprite){
            back = new Sprite();
            backAlpha = [0.8, 0.6, 0.4, 0.2, 0];
            leoMsg = [];
            super(NAME);
            this.viewComponent = _arg1;
        }
        private function clearAllChild():void{
            var _local1:int = (msgArea.numChildren - 1);
            while (_local1 >= 0) {
                msgArea.getChildAt(_local1).removeEventListener(ChatCellEvent.CHAT_CELLLINK_CLICK, getLinkHandler);
                (msgArea.getChildAt(_local1) as ChatCellText).dispose();
                msgArea.removeChildAt(_local1);
                _local1--;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Number;
            switch (_arg1.getName()){
                case ChatEvents.CREATORMSGAREA:
                    createMsgArea();
                    break;
                case ChatEvents.SHOWMSGINFO:
                    tmpMsgList = (_arg1.getBody() as Array);
                    show();
                    break;
                case ChatEvents.CHANGEHEIGHT:
                    changeArea();
                    break;
                case ChatEvents.CHANGEMSGAREA:
                    changeMsgArea();
                    break;
                case ChatEvents.CHANGEMOUSE:
                    curpos++;
                    if (curpos == backAlpha.length){
                        curpos = 0;
                    };
                    _local2 = backAlpha[curpos];
                    back.alpha = _local2;
                    break;
                case ChatEvents.RECEIVELEOMSG:
                    receviceLeoMsg(_arg1.getBody());
                    break;
                case ChatEvents.CLEAR_MSG_CUR_CHANNEL:
                    changeCancel();
                    break;
                case EventList.RESIZE_STAGE:
                    if (back){
                        back.y = ((GameCommonData.GameInstance.ScreenHeight - ChatData.MsgPosArea[ChatData.CurAreaPos].height) - 45);
                    };
                    if (iScrollPane){
                        iScrollPane.y = back.y;
                    };
                    if (leoView){
                        leoView.y = ((back.y - leoMsgView.height) - 1);
                        leoMsgView.y = ((back.y - leoMsgView.height) - 3);
                    };
                    break;
            };
        }
        private function changeCancel():void{
            var _local1:ChatCellText;
            var _local2:int;
            clearAllChild();
            while (_local2 < tmpMsgList.length) {
                _local1 = new ChatCellText(tmpMsgList[_local2].info, tmpMsgList[_local2].dfColor);
                _local1.sendId = tmpMsgList[_local2].sendId;
                _local1.addEventListener(ChatCellEvent.CHAT_CELLLINK_CLICK, getLinkHandler);
                msgArea.addChild(_local1);
                _local1.x = 2;
                _local2++;
            };
            msgArea.width = ChatData.CHAT_WIDTH;
            showElements();
            iScrollPane.refresh();
            iScrollPane.scrollBottom();
            iScrollPane.refresh();
        }
        private function createMsgArea():void{
            msgArea = new Sprite();
            msgArea.name = "msgArea";
            msgArea.mouseEnabled = false;
            back = new Sprite();
            back.name = "msgBack";
            back.mouseEnabled = false;
            back.alpha = backAlpha[curpos];
            msgArea.graphics.beginFill(0xFF00FF, 0);
            msgArea.graphics.drawRect(0, 0, ChatData.MsgPosArea[ChatData.CurAreaPos].width, ChatData.MsgPosArea[ChatData.CurAreaPos].height);
            msgArea.graphics.endFill();
            creatorBack();
            back.width = ChatData.MsgPosArea[ChatData.CurAreaPos].width;
            back.height = ChatData.MsgPosArea[ChatData.CurAreaPos].height;
            back.x = (ChatData.MsgPosArea[ChatData.CurAreaPos].x + 16);
            GameCommonData.GameInstance.GameUI.addChild(back);
            iScrollPane = new UIScrollPane(msgArea);
            iScrollPane.width = ChatData.MsgPosArea[ChatData.CurAreaPos].width;
            iScrollPane.height = ChatData.MsgPosArea[ChatData.CurAreaPos].height;
            iScrollPane.x = ChatData.MsgPosArea[ChatData.CurAreaPos].x;
            iScrollPane.scrollPolicy = UIScrollPane.SCROLLBAR_ALWAYS;
            iScrollPane.setScrollPos();
            iScrollPane.refresh();
            iScrollPane.scrollBottom();
            iScrollPane.refresh();
            GameCommonData.GameInstance.GameUI.addChild(iScrollPane);
            if (back){
                back.y = ((GameCommonData.GameInstance.ScreenHeight - ChatData.MsgPosArea[ChatData.CurAreaPos].height) - 48);
            };
            if (iScrollPane){
                iScrollPane.y = back.y;
            };
        }
        private function showLeo(_arg1:Object):void{
            leoMsgView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LeoMsgView");
            leoMsgView.x = 1;
            leoMsgView.y = ((back.y - leoMsgView.height) - 3);
            GameCommonData.GameInstance.GameUI.addChild(leoMsgView);
            isShow = true;
            leoView = new ChatCellText(_arg1.info, _arg1.dfColor, true);
            leoView.sendId = _arg1.sendId;
            leoView.x = 53;
            leoView.y = ((back.y - leoMsgView.height) - 1);
            GameCommonData.GameInstance.GameUI.addChild(leoView);
            leoView.addEventListener(ChatCellEvent.CHAT_CELLLINK_CLICK, getLinkHandler);
            GameCommonData.GameInstance.GameUI.setChildIndex(leoView, (GameCommonData.GameInstance.GameUI.numChildren - 1));
            leoDelay = setInterval(delayShow, delayNum);
        }
        private function changeArea():void{
            back.height = ChatData.MsgPosArea[ChatData.CurAreaPos].height;
            iScrollPane.height = ChatData.MsgPosArea[ChatData.CurAreaPos].height;
            iScrollPane.setScrollPos();
            iScrollPane.refresh();
            iScrollPane.scrollBottom();
            iScrollPane.refresh();
            msgArea.width = ChatData.CHAT_WIDTH;
            if (back){
                back.y = ((GameCommonData.GameInstance.ScreenHeight - ChatData.MsgPosArea[ChatData.CurAreaPos].height) - 45);
            };
            if (iScrollPane){
                iScrollPane.y = back.y;
            };
            if (leoView){
                leoView.y = ((back.y - leoMsgView.height) - 1);
                leoMsgView.y = ((back.y - leoMsgView.height) - 3);
            };
        }
        private function showElements():void{
            var _local1:DisplayObject;
            var _local3:int;
            var _local2:Number = 1;
            while (_local3 < msgArea.numChildren) {
                _local1 = msgArea.getChildAt(_local3);
                _local1.y = _local2;
                _local2 = (_local2 + _local1.height);
                _local3++;
            };
        }
        private function receviceLeoMsg(_arg1:Object):void{
            leoMsg.push(_arg1);
            if (!isShow){
                showLeo(_arg1);
            };
        }
        private function changeMsgArea():void{
            switch (ChatData.CurShowContent){
                case 0:
                    tmpMsgList = ChatData.AllMsg;
                    ChatData.curSelectModel = 4;
                    break;
                case 1:
                    tmpMsgList = ChatData.UnityMsg;
                    ChatData.curSelectModel = 3;
                    break;
                case 2:
                    tmpMsgList = ChatData.Set1Msg;
                    ChatData.curSelectModel = 1;
                    break;
                case 3:
                    tmpMsgList = ChatData.Set2Msg;
                    ChatData.curSelectModel = 2;
                    break;
                case 4:
                    tmpMsgList = ChatData.NearMsg;
                    ChatData.curSelectModel = 0;
                    break;
                case 5:
                    tmpMsgList = ChatData.FactionMsg;
                    ChatData.curSelectModel = 6;
                    break;
            };
            facade.sendNotification(ChatEvents.SETCHANNEL);
            changeCancel();
        }
        private function delayShow():void{
            clearInterval(leoDelay);
            facade.sendNotification(ChatEvents.HIDEQUICKOPERATOR);
            if (leoView){
                leoView.removeEventListener(ChatCellEvent.CHAT_CELLLINK_CLICK, getLinkHandler);
                leoView.dispose();
                GameCommonData.GameInstance.GameUI.removeChild(leoView);
                GameCommonData.GameInstance.GameUI.removeChild(leoMsgView);
                leoView = null;
            };
            leoMsg.shift();
            isShow = false;
            if (leoMsg.length != 0){
                showLeo(leoMsg[0]);
            };
        }
        private function creatorBack():void{
            back.graphics.beginFill(0, 0.6);
            back.graphics.drawRect(0, 0, 100, 100);
            back.graphics.endFill();
        }
        override public function listNotificationInterests():Array{
            return ([ChatEvents.CREATORMSGAREA, ChatEvents.SHOWMSGINFO, ChatEvents.CHANGEHEIGHT, ChatEvents.CHANGEMSGAREA, ChatEvents.CHANGEMOUSE, ChatEvents.RECEIVELEOMSG, ChatEvents.CLEAR_MSG_CUR_CHANNEL, EventList.RESIZE_STAGE]);
        }
        private function clearFirstChild():void{
            if (msgArea.numChildren > 30){
                msgArea.getChildAt(0).removeEventListener(ChatCellEvent.CHAT_CELLLINK_CLICK, getLinkHandler);
                (msgArea.getChildAt(0) as ChatCellText).dispose();
                msgArea.removeChildAt(0);
            };
        }
        private function getLinkHandler(_arg1:ChatCellEvent):void{
            var _local2:QuickSelectMediator;
            var _local3:int;
            var _local4:Object;
            var _local8:String;
            var _local5:String = (_arg1.data as String);
            var _local6:Array = _local5.split("_");
            var _local7:uint;
            if (_local6[1] == "[VIP]"){
                _local8 = "";
                if (uint(_local6[2]) == 10){
                    _local8 = LanguageMgr.GetTranslation("周卡");
                } else {
                    if (uint(_local6[2]) == 11){
                        _local8 = LanguageMgr.GetTranslation("月卡");
                    } else {
                        if (uint(_local6[2]) == 12){
                            _local8 = LanguageMgr.GetTranslation("半年卡");
                        };
                    };
                };
                UIConstData.ToolTipShow = true;
                facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local8});
                return;
            };
            if (_local6[0] == 2){
                if (uint((_local6[2] == 1))){
                    if (GameCommonData.Player.Role.unityId == 0){
                        GuildSend.ApplyGuild(_local6[3]);
                    } else {
                        MessageTip.popup(LanguageMgr.GetTranslation("聊天提示6"));
                    };
                    return;
                };
                if (uint(_local6[2]) == 2){
                    if (UnityConstData.GuildFBOpened){
                        if (UnityConstData.GuildFB_Line != GameConfigData.CurrentServerId){
                            MessageTip.popup(LanguageMgr.GetTranslation("提示换线进入副本", UnityConstData.GuildFB_Line));
                            return;
                        };
                        GuildSend.EnterGuildFB();
                    };
                    return;
                };
                if (uint(_local6[2]) == 3){
                    if (_local6[3] == "50200044"){
                        facade.sendNotification(EventList.SHOW_ACTIVITY_WELFARE, 3);
                    } else {
                        facade.sendNotification(EventList.SHOW_ACTIVITY_CHARGE);
                    };
                    return;
                };
                if (uint(_local6[2]) == 4){
                    facade.sendNotification(EventList.SHOWMARKETVIEW_TOGGLE, uint(_local6[3]));
                    return;
                };
                if (uint(_local6[2]) == 5){
                    sendNotification(EventList.APPLYTEAM, {
                        id:0,
                        teamId:uint(_local6[3])
                    });
                    return;
                };
                if (uint((_local6[2] == 6))){
                    sendNotification(EventList.TOGGLE_ACTIVITY, uint(_local6[3]));
                    sendNotification(EventList.CLICK_ACTIVITY_ITEM, uint(_local6[4]));
                    return;
                };
            };
            _local7 = 0;
            while (_local7 < GambleData.labelNames.length) {
                if (_local6[1] == (("[" + GambleData.labelNames[_local7]) + "]")){
                    facade.sendNotification(EventList.SHOW_OPENITEMBOX_TOGGLE, _local7);
                    return;
                };
                _local7++;
            };
            if (_local6[0] == 0){
                if ((((((_local6[1] == (("[" + GameCommonData.Player.Role.Name) + "]"))) || ((_local6[1] == GameCommonData.Player.Role.Name)))) || (ChatData.QuickChatIsOpen))){
                    return;
                };
                _local2 = new QuickSelectMediator();
                facade.registerMediator(_local2);
                facade.sendNotification(ChatEvents.SHOWQUICKOPERATOR, {
                    name:_local6[1].substring(1, (_local6[1].length - 1)),
                    sendId:_arg1.sendId,
                    ownerItemId:_arg1.sendId
                });
            } else {
                if (_local6[0] == 1){
                    _local3 = int(_local6[3]);
                    if (_local6.length == 7){
                        _local4 = null;
                        _local4 = UIConstData.ItemDic[_local3];
                        if (_local4){
                            facade.sendNotification(EventList.SHOWITEMTOOLPANEL, {
                                type:_local4.TemplateID,
                                BindFlag:_local6[5],
                                GUID:_local6[2],
                                data:_local4
                            });
                        };
                    } else {
                        BagData.TipShowItemDic[uint(_local6[2])] = new InventoryItemInfo();
                        BagData.TipShowItemDic[uint(_local6[2])].ItemGUID = uint(_local6[2]);
                        BagData.TipShowItemDic[uint(_local6[2])].ParseConcatString(_local6, uint(_local6[3]));
                        BagData.TipShowItemDic[uint(_local6[2])].isBind = uint(_local6[5]);
                        facade.sendNotification(EventList.SHOWITEMTOOLPANEL, {GUID:uint(_local6[2])});
                    };
                };
            };
        }
        private function show():void{
            clearFirstChild();
            var _local1:int = (tmpMsgList.length - 1);
            var _local2:ChatCellText = new ChatCellText(tmpMsgList[_local1].info, tmpMsgList[_local1].dfColor);
            _local2.sendId = tmpMsgList[_local1].sendId;
            _local2.addEventListener(ChatCellEvent.CHAT_CELLLINK_CLICK, getLinkHandler);
            msgArea.addChild(_local2);
            _local2.x = 2;
            msgArea.width = ChatData.CHAT_WIDTH;
            showElements();
            if (iScrollPane.updateFlag){
                iScrollPane.refresh();
                iScrollPane.scrollBottom();
                iScrollPane.refresh();
            };
        }

    }
}//package GameUI.Modules.Chat.Mediator 
