//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.View.BaseUI.*;
    import Net.RequestSend.*;
    import GameUI.Mediator.*;
    import GameUI.Modules.Friend.model.proxy.*;
    import flash.ui.*;

    public class IMChatWindow extends HFrame {

        public var closeCallBackFun:Function;
        public var chatingList:ChatList;
        private var _friendInfo:FriendInfoStruct;
        public var IsMinimize:Boolean;
        private var btn_send:HLabelButton;
        private var btn_close:HLabelButton;
        private var btn_getRoleInfo:HLabelButton;
        private var bm:Bitmap;
        public var chatHistoryList:ChatList;
        public var sendMsgFun:Function;
        private var _bgView:MovieClip;
        private var btn_addFriend:HLabelButton;

        public function IMChatWindow(){
            initView();
            addEvents();
        }
        private function setFace(_arg1:TextField):void{
            var _local2:RegExp = /(\\\d{3})/g;
            var _local3:Array = _arg1.text.split(_local2);
            if (((!(_local3)) || ((_local3.length == 0)))){
                return;
            };
            var _local4:int;
            var _local5:int;
            var _local6:int;
            while (_local4 < _local3.length) {
                if (((_local2.test(_local3[_local4])) && ((int(int(_local3[_local4].slice(1, 4))) <= ChatData.FACE_NUM)))){
                    if (_local6 == 5){
                        break;
                    };
                    if (_arg1.getCharBoundaries(_local5) == null){
                        setTimeout(setFace, 50);
                        return;
                    };
                    setBmpMask(_arg1.getCharBoundaries(_local5));
                    addImg(_arg1, _local3[_local4].slice(1, 4), _arg1.getCharBoundaries(_local5));
                    _local6++;
                    _local5 = (_local5 + _local3[_local4].length);
                } else {
                    _local5 = (_local5 + _local3[_local4].length);
                };
                _local4++;
            };
        }
        protected function onOpenMsgHistory(_arg1:MouseEvent):void{
            var _local2:MessageWordProxy;
            if (_bgView.contains(this.chatHistoryList)){
                _bgView.chatHistoryBgAsset.visible = false;
                _bgView.removeChild(this.chatHistoryList);
                setSize(372, 372);
            } else {
                _bgView.chatHistoryBgAsset.visible = true;
                _bgView.addChild(this.chatHistoryList);
                _local2 = (UIFacade.GetInstance().retrieveProxy(MessageWordProxy.NAME) as MessageWordProxy);
                this.chatHistoryList.dataPro = (_local2.getHistory(info.frendId) as Array).concat();
                this.chatHistoryList.scrollBottom();
                setSize(590, 372);
            };
        }
        public function onTextChangeHandler(_arg1:Event=null):void{
            setFace(_bgView.txt_chatInput);
        }
        public function initData(_arg1:Array):void{
            chatingList.dataPro = _arg1;
            chatingList.scrollBottom();
        }
        private function update():void{
            titleText = LanguageMgr.GetTranslation("和x聊天中", info.roleName);
        }
        protected function onTextKeyUp(_arg1:KeyboardEvent):void{
            if (((_arg1.ctrlKey) && ((_arg1.keyCode == Keyboard.ENTER)))){
                this.onSendMsgClick(null);
                this.stage.focus = this._bgView.txt_chatInput;
            };
        }
        public function addChatCell(_arg1:Object):void{
            this.chatingList.addChatCell(_arg1);
        }
        public function getCurrentBitmap():Bitmap{
            var _local1:BitmapData = new BitmapData(this.frameWidth, this.frameHeight);
            _local1.draw(this);
            if (bm == null){
                bm = new Bitmap();
            };
            bm.bitmapData = _local1;
            return (bm);
        }
        public function get info():FriendInfoStruct{
            return (_friendInfo);
        }
        private function initView():void{
            var _local1:TextField;
            titleText = LanguageMgr.GetTranslation("好友聊天");
            setSize(372, 372);
            blackGound = false;
            showMinimize = true;
            closeCallBack = closeBtnHandler;
            _bgView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("FriendChatPanel");
            _bgView.x = 9;
            _bgView.y = 35;
            addContent(_bgView);
            _bgView.txt_chatInput.text = "";
            this.chatingList = new ChatList(343, 192);
            chatingList.x = 5;
            chatingList.y = 6;
            this.chatHistoryList = new ChatList(200, 315);
            chatHistoryList.x = 370;
            chatHistoryList.y = 6;
            _bgView.chatHistoryBgAsset.visible = false;
            btn_close = new HLabelButton();
            btn_close.label = LanguageMgr.GetTranslation("关闭");
            btn_close.x = 235;
            btn_close.y = 305;
            _bgView.addChild(btn_close);
            btn_send = new HLabelButton();
            btn_send.label = LanguageMgr.GetTranslation("发送");
            btn_send.x = 295;
            btn_send.y = 305;
            _bgView.addChild(btn_send);
            btn_addFriend = new HLabelButton();
            btn_addFriend.label = LanguageMgr.GetTranslation("添加好友");
            btn_addFriend.x = 105;
            btn_addFriend.y = 202;
            _bgView.addChild(btn_addFriend);
            btn_getRoleInfo = new HLabelButton();
            btn_getRoleInfo.label = LanguageMgr.GetTranslation("查看信息");
            btn_getRoleInfo.x = 190;
            btn_getRoleInfo.y = 202;
            _bgView.addChild(btn_getRoleInfo);
            _local1 = new TextField();
            _local1.textColor = 0xFFFFFF;
            _local1.text = LanguageMgr.GetTranslation("Ctrl+Enter快速发送消息");
            _local1.selectable = false;
            _local1.x = 3;
            _local1.y = 305;
            _local1.width = 130;
            _bgView.addChild(_local1);
            _bgView.addChild(this.chatingList);
        }
        private function setBmpMask(_arg1:Rectangle):void{
            var _local2:Shape;
            if (_arg1){
                _local2 = new Shape();
                _local2.graphics.beginFill(0xFFFFFF, 1);
                _local2.graphics.drawRect((_arg1.x - 1), _arg1.y, (_arg1.width + 19), _arg1.height);
                _local2.graphics.endFill();
                _local2.blendMode = BlendMode.ERASE;
                this.addChild(_local2);
            };
        }
        private function addImg(_arg1:TextField, _arg2:String, _arg3:Rectangle):void{
            var _local4:Bitmap = new Bitmap();
            _local4.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData(("F" + _arg2));
            _local4.x = _arg3.x;
            _local4.y = (_arg3.y - 4);
        }
        public function set info(_arg1:FriendInfoStruct):void{
            _friendInfo = _arg1;
            update();
        }
        private function addFriendHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(FriendCommandList.ADD_TO_FRIEND, {name:info.roleName});
        }
        override protected function __minimizeHandler(_arg1:MouseEvent):void{
            if (_minimizeCallBack != null){
                _minimizeCallBack(this);
            };
        }
        private function closeBtnHandler(_arg1:MouseEvent=null):void{
            if (closeCallBackFun != null){
                closeCallBackFun(this);
            };
        }
        public function getParam():ChatInfoStruct{
            var _local1:ChatInfoStruct = new ChatInfoStruct();
            _local1.roleId = GameCommonData.Player.Role.Id;
            _local1.roleName = GameCommonData.Player.Role.Name;
            _local1.friendId = info.frendId;
            _local1.content = this._bgView.txt_chatInput.text;
            _local1.item = " ";
            _local1.color = this._bgView.txt_chatInput.textColor;
            _local1.type = FriendActionList.CHAT_FLAG;
            _local1.face = GameCommonData.Player.Role.Face;
            _local1.jobId = 0;
            _local1.timeT = TimeManager.Instance.Now().time;
            return (_local1);
        }
        private function getRoleInfoHandler(_arg1:MouseEvent):void{
            FriendSend.getFriendInfo(info.frendId);
        }
        public function get BgView():MovieClip{
            return (_bgView);
        }
        private function addEvents():void{
            btn_send.addEventListener(MouseEvent.CLICK, onSendMsgClick);
            btn_close.addEventListener(MouseEvent.CLICK, closeBtnHandler);
            btn_addFriend.addEventListener(MouseEvent.CLICK, addFriendHandler);
            btn_getRoleInfo.addEventListener(MouseEvent.CLICK, getRoleInfoHandler);
            _bgView.btn_msgHistory.addEventListener(MouseEvent.CLICK, onOpenMsgHistory);
            _bgView.btn_face.addEventListener(MouseEvent.CLICK, onSelectFaceHandler);
            _bgView.txt_chatInput.addEventListener(Event.CHANGE, onTextChangeHandler);
            _bgView.txt_chatInput.addEventListener(KeyboardEvent.KEY_UP, onTextKeyUp);
        }
        protected function onSendMsgClick(_arg1:MouseEvent):void{
            if (sendMsgFun != null){
                sendMsgFun(this, getParam());
            };
        }
        private function removeEvents():void{
            btn_send.removeEventListener(MouseEvent.CLICK, onSendMsgClick);
            btn_close.removeEventListener(MouseEvent.CLICK, closeBtnHandler);
            btn_addFriend.removeEventListener(MouseEvent.CLICK, addFriendHandler);
            btn_getRoleInfo.removeEventListener(MouseEvent.CLICK, getRoleInfoHandler);
            _bgView.btn_msgHistory.removeEventListener(MouseEvent.CLICK, onOpenMsgHistory);
            _bgView.btn_face.removeEventListener(MouseEvent.CLICK, onSelectFaceHandler);
            _bgView.txt_chatInput.removeEventListener(Event.CHANGE, onTextChangeHandler);
            _bgView.txt_chatInput.removeEventListener(KeyboardEvent.KEY_UP, onTextKeyUp);
        }
        public function ShowHistory():void{
            _bgView.chatHistoryBgAsset.visible = true;
            _bgView.addChild(this.chatHistoryList);
            var _local1:MessageWordProxy = (UIFacade.GetInstance().retrieveProxy(MessageWordProxy.NAME) as MessageWordProxy);
            this.chatHistoryList.dataPro = (_local1.getHistory(info.frendId) as Array).concat();
            this.chatHistoryList.scrollBottom();
            setSize(590, 372);
        }
        protected function onSelectFaceHandler(_arg1:MouseEvent):void{
            if (!UIConstData.SelectFaceIsOpen){
                UIFacade.GetInstance().registerMediator(new FacePanelMediator());
                UIFacade.GetInstance().sendNotification(EventList.SHOWFACEVIEW, {
                    x:(this.x + 30),
                    y:(this.y + 135),
                    type:"friend"
                });
            } else {
                UIFacade.GetInstance().sendNotification(EventList.HIDESELECTFACE);
            };
        }
        override public function show():void{
            GameCommonData.GameInstance.GameUI.addChild(this);
            _bgView.stage.focus = _bgView.txt_chatInput;
            if (_bgView.contains(this.chatHistoryList)){
                _bgView.removeChild(this.chatHistoryList);
            };
        }
        override public function close():void{
            super.close();
            removeEvents();
            if (parent){
                parent.removeChild(this);
            };
            if (((_bgView) && (_bgView.parent))){
                _bgView.parent.removeChild(_bgView);
            };
            _bgView = null;
            if (btn_close){
                btn_close.dispose();
                btn_close = null;
            };
            if (btn_send){
                btn_send.dispose();
                btn_send = null;
            };
            if (chatingList){
                chatingList.dispose();
                chatingList = null;
            };
            if (chatHistoryList){
                chatHistoryList.dispose();
                chatHistoryList = null;
            };
            _friendInfo = null;
            sendMsgFun = null;
            closeCallBackFun = null;
            if (bm){
                if (bm.bitmapData){
                    bm.bitmapData.dispose();
                    bm.bitmapData = null;
                };
                bm = null;
            };
        }

    }
}//package GameUI.Modules.Friend.view.ui 
