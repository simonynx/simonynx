//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Unity.Data.*;
    import flash.net.*;
    import GameUI.View.Components.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.MainScene.Mediator.*;
    import GameUI.Mediator.*;
    import GameUI.Modules.QuickBuy.Command.*;
    import GameUI.Modules.Chat.Command.*;
    import flash.system.*;
    import GameUI.*;

    public class ChatMediator extends Mediator {

        public static const NAME:String = "ChatMediator";

        private var isHideMouse:Boolean = false;
        private var curColor:uint = 0;
        private var msgMediator:MsgMedaitor;
        private var maxItem:int = 2;
        private var reg:RegExp;
        private var iScrollPane:UIScrollPane;
        private var chacheInputStr:String = "";
        private var msgArea:Sprite = null;
        private var facePanelMediator:FacePanelMediator;
        private var selectChannelMedator:SelectChanalMediator = null;
        private var dataProxy:DataProxy = null;
        private var curWelcomeIndex:int = 0;
        private var contactListMediator:ContactListMediator;
        private var curIndex:int = 0;

        public function ChatMediator(){
            facePanelMediator = new FacePanelMediator();
            reg = /(.*)(<[0-9一-龥]*>)$/gm;
            super(NAME);
        }
        private function textFormat(_arg1:uint=0):TextFormat{
            var _local2:TextFormat = new TextFormat();
            _local2.color = _arg1;
            return (_local2);
        }
        private function hasPrivate(_arg1:String):void{
            var _local2:int;
            while (_local2 < LanguageMgr.channelModel.length) {
                if (LanguageMgr.channelModel[_local2] == undefined){
                } else {
                    if (LanguageMgr.channelModel[_local2].rece == _arg1){
                        ChatData.curSelectModel = _local2;
                        return;
                    };
                };
                _local2++;
            };
            ChatData.curSelectModel = 2;
        }
        private function selectModel(_arg1:MouseEvent):void{
            var _local2:int;
            while (_local2 < 6) {
                chatView[("mcCh_" + _local2)].btnChang.visible = true;
                chatView[("txtCh_" + _local2)].textColor = 39372;
                _local2++;
            };
            var _local3:int = _arg1.currentTarget.name.split("_")[1];
            ChatData.CurShowContent = _local3;
            chatView[("mcCh_" + _local3)].btnChang.visible = false;
            chatView[("txtCh_" + _local3)].textColor = 0xFFCC00;
            facade.sendNotification(ChatEvents.CHANGEMSGAREA);
        }
        private function initChatSence():void{
            var _local2:int;
            var _local1:MovieClip = ((facade.retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip);
            chatView.x = 0;
            if ((GameCommonData.GameInstance.ScreenWidth - _local1.x) < chatView.width){
                chatView.y = ((GameCommonData.GameInstance.ScreenHeight - chatView.height) - 72);
            } else {
                chatView.y = (GameCommonData.GameInstance.ScreenHeight - chatView.height);
            };
            GameCommonData.GameInstance.GameUI.addChild(chatView);
            ChatData.HtmlStyle.parseCSS("a:hover{color:#00FFFF;background-color:black;cursor:none;}");
            ChatData.NameStyle.parseCSS("a:hover{color:#00FF00;background-color:black;cursor:none;}");
            while (_local2 < 6) {
                chatView[("mcCh_" + _local2)].addEventListener(MouseEvent.CLICK, selectModel);
                chatView[("txtCh_" + _local2)].mouseEnabled = false;
                if (_local2 == ChatData.CurShowContent){
                    chatView[("mcCh_" + _local2)].btnChang.visible = false;
                };
                _local2++;
            };
            chatView.txtCurChanel.textColor = ChatData.CHAT_COLORS[ChatData.curSelectModel];
            chatView[("txtCh_" + 0)].textColor = 0xFFCC00;
            chatView.txtInput.maxChars = 40;
            chatView.txtCurChanel.text = LanguageMgr.channelModel[ChatData.curSelectModel].name;
            chatView.txtCurChanel.mouseEnabled = false;
            chatView.btnSelectCh.addEventListener(MouseEvent.CLICK, selectChannel);
            chatView.btnSetHeight.addEventListener(MouseEvent.CLICK, setMsgAreaHandler);
            chatView.btnSend.addEventListener(MouseEvent.CLICK, sendMsg);
            chatView.btnClear.addEventListener(MouseEvent.CLICK, clearMsg);
            chatView.btnFace.addEventListener(MouseEvent.CLICK, selectFace);
            chatView.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            chatView.txtInput.addEventListener(FocusEvent.FOCUS_IN, onFoucsIn);
            chatView.txtInput.addEventListener(FocusEvent.FOCUS_OUT, onFoucsOut);
            creatorMsgArea();
            if (GameCommonData.Player.Role.Level < 45){
                _local2 = 0;
                while (_local2 < ChatData.WELCOME_ARR.length) {
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_POST, "", "", ChatData.WELCOME_ARR[_local2]);
                    _local2++;
                };
                setTimeout(startNotice, 20000);
            };
        }
        private function get chatView():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function onFoucsIn(_arg1:FocusEvent):void{
            GameCommonData.isFocusIn = true;
            IME.enabled = true;
            ChatData.txtIsFoucs = true;
        }
        private function showWelcome():void{
            if (curWelcomeIndex == ChatData.WELCOME_ARR.length){
                curWelcomeIndex = 0;
            };
            ChatData.SimpleChat(ChatData.CHAT_TYPE_POST, "", "", ChatData.WELCOME_ARR[curWelcomeIndex]);
            curWelcomeIndex++;
        }
        private function showNotice():void{
            var _local1:uint = (Math.random() * ChatData.NOTICE_ARR.length);
            while (_local1 == ChatData.lastPlayIndex) {
                _local1 = (Math.random() * ChatData.NOTICE_ARR.length);
            };
            ChatData.lastPlayIndex = _local1;
            ChatData.SimpleChat(ChatData.CHAT_TYPE_TIPS, "", "", ChatData.NOTICE_ARR[_local1]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:int;
            var _local3:String;
            var _local4:String;
            var _local5:Array;
            var _local6:String;
            var _local7:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.CHAT
                    });
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    selectChannelMedator = new SelectChanalMediator();
                    facade.registerMediator(selectChannelMedator);
                    contactListMediator = new ContactListMediator();
                    facade.registerMediator(contactListMediator);
                    facade.registerCommand(ChatEvents.SENDCOMMAND, SendCommand);
                    facade.registerCommand(CommandList.RECEIVECOMMAND, ReceiveChatCommand);
                    chatView.txtInput.addEventListener(Event.CHANGE, txtChgHandler);
                    curColor = ChatData.CHAT_COLORS[ChatData.curSelectModel];
                    ChatData.SelectedMsgColor = curColor;
                    chatView.txtInput.defaultTextFormat = textFormat(curColor);
                    chatView.txtInput.setTextFormat(textFormat(curColor));
                    break;
                case EventList.KEYBORADEVENT:
                    _local2 = (_arg1.getBody() as int);
                    if (((!((chatView.stage.focus == chatView.txtInput))) && (!(UIConstData.FocusIsUsing)))){
                        chatView.stage.focus = chatView.txtInput;
                        chatView.txtInput.setSelection(chatView.txtInput.length, chatView.txtInput.length);
                        return;
                    };
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    initChatSence();
                    break;
                case ChatEvents.SETCHANNEL:
                    getChannel();
                    break;
                case ChatEvents.LOCKCHAT:
                    chatView.btnSelectCh.mouseEnabled = false;
                    chatView.txtInput.mouseEnabled = false;
                    chatView.btnSend.mouseEnabled = false;
                    break;
                case ChatEvents.UNLOCKCHAT:
                    chatView.btnSelectCh.mouseEnabled = true;
                    chatView.txtInput.mouseEnabled = true;
                    chatView.btnSend.mouseEnabled = true;
                    break;
                case ChatEvents.SET_PRIVATE_NAME:
                    _local3 = _arg1.getBody().name;
                    ChatData.curSelectModel = 2;
                    chatView.stage.focus = chatView.txtInput;
                    chatView.txtInput.text = (("/" + _local3) + " ");
                    chatView.txtCurChanel.text = LanguageMgr.channelModel[ChatData.curSelectModel].name;
                    chatView.txtInput.setSelection(chatView.txtInput.length, chatView.txtInput.length);
                    break;
                case ChatEvents.SELECTEDFONTCOLOR:
                    curColor = (_arg1.getBody() as uint);
                    ChatData.SelectedMsgColor = curColor;
                    chatView.txtInput.defaultTextFormat = textFormat(curColor);
                    chatView.txtInput.setTextFormat(textFormat(curColor));
                    chatView.stage.focus = chatView.txtInput;
                    break;
                case ChatEvents.QUICKCHAT:
                    _local6 = (_arg1.getBody() as String);
                    hasPrivate(_local6);
                    chatView.stage.focus = chatView.txtInput;
                    chatView.txtInput.text = (("/" + _local6) + " ");
                    chatView.txtCurChanel.text = LanguageMgr.channelModel[ChatData.curSelectModel].name;
                    chatView.txtInput.setSelection(chatView.txtInput.length, chatView.txtInput.length);
                    chatView.txtCurChanel.textColor = ChatData.CHAT_COLORS[ChatData.curSelectModel];
                    chatView.txtInput.textColor = ChatData.CHAT_COLORS[ChatData.curSelectModel];
                    chatView.stage.focus = chatView.txtInput;
                    ChatData.SelectedMsgColor = ChatData.CHAT_COLORS[ChatData.curSelectModel];
                    break;
                case ChatEvents.SELECTEDFACETOCHAT:
                    chatView.stage.focus = chatView.txtInput;
                    chatView.txtInput.text = (chatView.txtInput.text + (("\\" + _arg1.getBody()) as String));
                    chatView.txtInput.setSelection(chatView.txtInput.length, chatView.txtInput.length);
                    break;
                case ChatEvents.ADDITEMINCHAT:
                    _local4 = (_arg1.getBody() as String);
                    if ((_local4.split("_")[1].length + chatView.txtInput.text.length) >= chatView.txtInput.maxChars){
                        return;
                    };
                    _local5 = [];
                    if (chatView.txtInput.text == ""){
                        ChatData.tempItemStr = "";
                    } else {
                        ChatData.tempItemStr = ChatData.tempItemStr.replace(/^\s*|\s*$/g, "").split(" ").join("");
                        _local5 = ChatData.tempItemStr.split("&");
                    };
                    if (_local5.length >= maxItem){
                        return;
                    };
                    _local7 = 0;
                    while (_local7 < _local5.length) {
                        if (_local4 == _local5[_local7]){
                            return;
                        };
                        _local7++;
                    };
                    if (ChatData.tempItemStr == ""){
                        ChatData.tempItemStr = _local4;
                    } else {
                        ChatData.tempItemStr = ((ChatData.tempItemStr + "&") + _local4);
                    };
                    _local6 = _local4.split("_")[1];
                    chatView.txtInput.text = (chatView.txtInput.text + (("<" + _local6.substring(1, (_local6.length - 1))) + ">"));
                    break;
                case EventList.RESIZE_STAGE:
                    chatView.x = 0;
                    chatView.y = (GameCommonData.GameInstance.ScreenHeight - chatView.height);
                    break;
                case ChatEvents.TEAMER_CHAT:
                    sendMsg(null);
                    break;
            };
        }
        private function onKeyUp(_arg1:KeyboardEvent):void{
            var _local2:RegExp;
            var _local3:Array;
            var _local4:String;
            var _local5:uint;
            var _local6:Boolean;
            var _local7:uint;
            var _local8:String;
            var _local9:Array;
            if (chatView.stage.focus != chatView.txtInput){
                return;
            };
            if (_arg1.keyCode == 40){
                curIndex++;
                if (curIndex > (ChatData.tmpChatInfo.length - 1)){
                    curIndex = 0;
                };
                if (ChatData.tmpChatInfo[curIndex]){
                    chatView.txtInput.text = ChatData.tmpChatInfo[curIndex];
                };
                chatView.txtInput.setSelection(chatView.txtInput.length, chatView.txtInput.length);
            } else {
                if (_arg1.keyCode == 38){
                    curIndex--;
                    if (curIndex < 0){
                        curIndex = (ChatData.tmpChatInfo.length - 1);
                    };
                    if (ChatData.tmpChatInfo[curIndex]){
                        chatView.txtInput.text = ChatData.tmpChatInfo[curIndex];
                    };
                    chatView.txtInput.setSelection(chatView.txtInput.length, chatView.txtInput.length);
                } else {
                    if (_arg1.keyCode == 8){
                        _local2 = /(<.*?>)/g;
                        _local3 = this.chacheInputStr.split(_local2);
                        _local4 = "";
                        _local6 = false;
                        for each (_local8 in _local3) {
                            if (_local2.test(_local8)){
                                if (((((!(_local6)) && ((chatView.txtInput.caretIndex >= _local4.length)))) && ((chatView.txtInput.caretIndex < (_local4.length + _local8.length))))){
                                    _local5 = _local4.length;
                                    _local6 = true;
                                    continue;
                                };
                                if (!_local6){
                                    _local7++;
                                };
                            };
                            _local4 = (_local4 + _local8);
                        };
                        if (_local6){
                            chatView.txtInput.setSelection(_local5, _local5);
                            chatView.txtInput.text = _local4;
                            _local9 = ChatData.tempItemStr.split("&");
                            if (_local9.length == 2){
                                ChatData.tempItemStr = _local9[Math.abs((_local7 - 1))];
                            } else {
                                ChatData.tempItemStr = "";
                            };
                        };
                    };
                };
            };
        }
        private function filterChatInfo(_arg1:String):Boolean{
            var _local2:int;
            while (_local2 < ChatData.tmpChatInfo.length) {
                if (_arg1 == ChatData.tmpChatInfo[_local2]){
                    return (false);
                };
                _local2++;
            };
            return (true);
        }
        private function cancelFat():void{
        }
        private function onKeyDown(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == 8){
                this.chacheInputStr = chatView.txtInput.text;
            };
            onKeyUp(_arg1);
            if ((((_arg1.keyCode == 13)) && ((chatView.stage.focus == chatView.txtInput)))){
                sendMsg(null);
            };
        }
        private function setMsgAreaHandler(_arg1:MouseEvent):void{
            ChatData.CurAreaPos++;
            if (ChatData.CurAreaPos == ChatData.MsgPosArea.length){
                ChatData.CurAreaPos = 0;
            };
            facade.sendNotification(ChatEvents.CHANGEHEIGHT);
        }
        private function getChannel():void{
            var _local1:Array;
            chatView.txtCurChanel.text = LanguageMgr.channelModel[ChatData.curSelectModel].name;
            chatView.txtCurChanel.textColor = ChatData.CHAT_COLORS[ChatData.curSelectModel];
            chatView.stage.focus = chatView.txtInput;
            var _local2:String = chatView.txtInput.text;
            if (_local2.charAt(0) == "/"){
                _local1 = _local2.split(" ");
                _local1.shift();
                _local2 = _local1.join("");
            };
            if (LanguageMgr.channelModel[ChatData.curSelectModel].rece != "ALLUSER"){
                chatView.txtInput.text = ("/" + _local2);
                chatView.txtInput.setSelection(chatView.txtInput.length, chatView.txtInput.length);
            } else {
                chatView.txtInput.text = _local2;
            };
            facade.sendNotification(ChatEvents.SELECTEDFONTCOLOR, ChatData.CHAT_COLORS[ChatData.curSelectModel]);
        }
        private function txtChgHandler(_arg1:Event):void{
            var _local2:String = chatView.txtInput.text.substring((chatView.txtInput.text.length - 1), chatView.txtInput.text.length);
            if (!_local2){
                return;
            };
            if (_local2 == "<"){
                chatView.txtInput.text = chatView.txtInput.text.substring(0, (chatView.txtInput.text.length - 1));
            };
        }
        private function sendMsg(_arg1:MouseEvent):void{
            var _local2:String;
            var _local3:Array;
            var _local4:String;
            var _local5:String;
            var _local6 = "";
            var _local7:uint = ChatData.curSelectModel;
            if (((!((chatView.stage.focus == chatView.txtInput))) && ((_arg1 == null)))){
                chatView.txtInput.text = ChatData.TeamerChat;
                _local7 = 4;
            };
            _local6 = chatView.txtInput.text;
            _local6 = _local6.replace(/^\s*/g, "");
            _local6 = _local6.replace(/\s*$/g, "");
            if (_local6 == ""){
                ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", LanguageMgr.GetTranslation("聊天提示1"));
                chatView.stage.focus = null;
                UIConstData.FocusIsUsing = false;
                return;
            };
            var _local8:Object = {};
            if (LanguageMgr.channelModel[_local7].rece != "ALLUSER"){
                _local2 = getItemStr(chatView.txtInput.text);
                _local3 = _local2.split(" ");
                _local4 = _local3.shift();
                _local8.name = _local4.slice(1, _local4.length);
                _local5 = _local3.join(" ");
                _local5 = _local5.replace(/^\s*/g, "");
                _local5 = _local5.replace(/\s*$/g, "");
                if (_local5 == ""){
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", LanguageMgr.GetTranslation("聊天提示1"));
                    chatView.stage.focus = null;
                    UIConstData.FocusIsUsing = false;
                    return;
                };
                if (((!((chatView.stage.focus == chatView.txtInput))) && ((_arg1 == null)))){
                } else {
                    if (filterChatInfo(chatView.txtInput.text)){
                        ChatData.tmpChatInfo.push(chatView.txtInput.text);
                    };
                };
                _local8.talkMsg = _local5;
                hasPrivate(_local8.name);
                chatView.txtCurChanel.text = LanguageMgr.channelModel[_local7].name;
                chatView.txtInput.text = (("/" + _local8.name) + " ");
                _local8.type = LanguageMgr.channelModel[_local7].channel;
                _local8.color = ChatData.CHAT_COLORS[_local7];
                _local8.jobId = 0;
                chatView.txtInput.setSelection(chatView.txtInput.length, chatView.txtInput.length);
            } else {
                _local8.jobId = 0;
                if (_local7 == 1){
                    if (GameCommonData.Player.Role.idTeam == 0){
                        ChatData.SimpleChat(ChatData.CHAT_TYPE_TEAM, LanguageMgr.GetTranslation("聊天提示2"));
                        return;
                    };
                } else {
                    if (_local7 == 3){
                        if (UnityConstData.IsLoadMyGuildInfo == false){
                            return;
                        };
                        if (GameCommonData.Player.Role.unityId == 0){
                            ChatData.SimpleChat(ChatData.CHAT_TYPE_UNITY, LanguageMgr.GetTranslation("聊天提示3"));
                            return;
                        };
                    } else {
                        if (_local7 == 4){
                            if (GameCommonData.Player.Role.Level < 10){
                                ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", LanguageMgr.GetTranslation("聊天提示4"));
                                return;
                            };
                        } else {
                            if (_local7 == 5){
                                if (BagData.getCountsByTemplateId(50100001, false) == 0){
                                    facade.sendNotification(QuickBuyCommandList.SHOW_QUICKBUY_UI, {TemplateID:50100001});
                                    UIConstData.FocusIsUsing = false;
                                    return;
                                };
                                if (GameCommonData.IsInCrossServer){
                                    ChatData.SimpleChat(ChatData.CHAT_TYPE_WORLD, LanguageMgr.GetTranslation("聊天提示8"));
                                    return;
                                };
                            } else {
                                if (_local7 == 6){
                                    if (MapManager.IsInFormation() == false){
                                        ChatData.SimpleChat(ChatData.CHAT_TYPE_FACTION, LanguageMgr.GetTranslation("聊天提示5"));
                                        return;
                                    };
                                    if (GameCommonData.IsInCrossServer){
                                        ChatData.SimpleChat(ChatData.CHAT_TYPE_FACTION, LanguageMgr.GetTranslation("聊天提示8"));
                                        return;
                                    };
                                };
                            };
                        };
                    };
                };
                _local8.name = LanguageMgr.channelModel[_local7].rece;
                _local8.type = LanguageMgr.channelModel[_local7].channel;
                _local8.talkMsg = getItemStr(chatView.txtInput.text);
                _local8.color = ChatData.CHAT_COLORS[_local7];
                if (((!((chatView.stage.focus == chatView.txtInput))) && ((_arg1 == null)))){
                } else {
                    if (filterChatInfo(chatView.txtInput.text)){
                        ChatData.tmpChatInfo.push(chatView.txtInput.text);
                    };
                };
                chatView.txtInput.text = "";
            };
            if (((!((chatView.stage.focus == chatView.txtInput))) && ((_arg1 == null)))){
            } else {
                chatView.stage.focus = chatView.txtInput;
                if (ChatData.tmpChatInfo.length > 10){
                    ChatData.tmpChatInfo.shift();
                };
            };
            _local8.item = ChatData.tempItemStr;
            curIndex = 0;
            ChatData.tempItemStr = "";
            facade.sendNotification(ChatEvents.SENDCOMMAND, _local8);
            UIConstData.FocusIsUsing = false;
        }
        private function startNotice():void{
            setInterval(showNotice, ((ChatData.NOTICE_HELP_INTERVAL * 60) * 1000));
            showNotice();
        }
        private function creatorMsgArea():void{
            msgMediator = new MsgMedaitor(msgArea);
            facade.registerMediator(msgMediator);
            facade.sendNotification(ChatEvents.CREATORMSGAREA);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, ChatEvents.SETCHANNEL, ChatEvents.LOCKCHAT, ChatEvents.UNLOCKCHAT, ChatEvents.SET_PRIVATE_NAME, ChatEvents.SELECTEDFONTCOLOR, EventList.KEYBORADEVENT, ChatEvents.QUICKCHAT, ChatEvents.SELECTEDFACETOCHAT, ChatEvents.ADDITEMINCHAT, ChatEvents.TEAMER_CHAT, EventList.RESIZE_STAGE]);
        }
        private function getItemStr(_arg1:String):String{
            var _local2:RegExp;
            var _local3:Array;
            var _local4:Array;
            var _local5:uint;
            var _local6:String;
            var _local7 = "";
            ChatData.tempItemStr = ChatData.tempItemStr.replace(/^\s*|\s*$/g, "").split(" ").join("");
            if (ChatData.tempItemStr){
                _local2 = /(<.*?>)/g;
                _local3 = ChatData.tempItemStr.split("&");
                _local4 = chatView.txtInput.text.split(_local2);
                _local5 = 0;
                for each (_local6 in _local4) {
                    if (_local2.test(_local6)){
                        if (_local3[_local5] != null){
                            _local7 = (_local7 + _local3[_local5]);
                        };
                        _local5++;
                    } else {
                        _local7 = (_local7 + _local6);
                    };
                };
            } else {
                _local7 = _arg1;
            };
            return (_local7);
        }
        private function setMsgArea(_arg1:MouseEvent):void{
            facade.sendNotification(ChatEvents.CHANGEMOUSE);
        }
        private function selectChannel(_arg1:MouseEvent):void{
            if (!ChatData.SelectChannelOpen){
                facade.sendNotification(ChatEvents.OPENCHANNEL);
                ChatData.SelectChannelOpen = true;
            } else {
                facade.sendNotification(ChatEvents.CLOSESELECTCHANNEL);
            };
        }
        private function clearMsg(_arg1:MouseEvent):void{
            facade.sendNotification(CommandList.RECEIVECOMMAND);
        }
        private function onFoucsOut(_arg1:FocusEvent):void{
            GameCommonData.isFocusIn = false;
            IME.enabled = false;
            ChatData.txtIsFoucs = false;
        }
        private function selectFace(_arg1:MouseEvent):void{
            var _local2:Point;
            var _local3:Number;
            var _local4:Number;
            if (!UIConstData.SelectFaceIsOpen){
                facade.registerMediator(facePanelMediator);
                _local2 = _arg1.currentTarget.parent.localToGlobal(new Point(_arg1.currentTarget.x, _arg1.currentTarget.y));
                _local3 = (_local2.x + 20);
                _local4 = (_local2.y - 140);
                facade.sendNotification(EventList.SHOWFACEVIEW, {
                    x:_local3,
                    y:_local4,
                    type:"chat"
                });
            } else {
                facade.sendNotification(EventList.HIDESELECTFACE);
            };
        }

    }
}//package GameUI.Modules.Chat.Mediator 
