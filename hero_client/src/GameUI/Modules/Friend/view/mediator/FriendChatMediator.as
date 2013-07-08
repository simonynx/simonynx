//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Map.SmallMap.SmallMapConst.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.View.*;
    import GameUI.Modules.Friend.view.ui.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import com.greensock.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Mediator.*;
    import GameUI.Modules.Friend.model.proxy.*;
    import flash.ui.*;
    import GameUI.*;

    public class FriendChatMediator extends Mediator {

        public static const NAME:String = "FriendChatMediator";

        protected var sendLeaveMsgTime:Number = 0;
        public var MinimizeItemCells:Array;
        private var MinimizeItemBar:Sprite;
        protected var dataProxy:DataProxy;
        protected var msgProxy:MessageWordProxy;
        protected var friendManager:FriendManagerMediator;
        private var ChatWindowArr:Array;

        public function FriendChatMediator(){
            super(NAME);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:IMChatWindow;
            var _local3:String;
            var _local4:uint;
            var _local5:uint;
            var _local6:FriendInfoStruct;
            var _local7:Array;
            var _local8:Object;
            var _local9:FriendInfoStruct;
            var _local10:MinimizeItemCell;
            var _local11:Array;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    msgProxy = (facade.retrieveProxy(MessageWordProxy.NAME) as MessageWordProxy);
                    ChatWindowArr = [];
                    MinimizeItemCells = [];
                    MinimizeItemBar = new Sprite();
                    MinimizeItemBar.mouseEnabled = false;
                    MinimizeItemBar.x = (GameCommonData.GameInstance.ScreenWidth - 140);
                    MinimizeItemBar.y = (GameCommonData.GameInstance.ScreenHeight - 220);
                    GameCommonData.GameInstance.GameUI.addChild(MinimizeItemBar);
                    break;
                case FriendCommandList.GET_FACE_NAME:
                    _local2 = GetTopChatWindow();
                    _local2.stage.focus = _local2.BgView.txt_chatInput;
                    _local3 = _local2.BgView.txt_chatInput.text;
                    _local3 = (_local3 + ("\\" + _arg1.getBody()));
                    _local3 = UIUtils.filterChat(_local3);
                    _local2.BgView.txt_chatInput.text = _local3;
                    _local2.onTextChangeHandler(null);
                    _local4 = _local2.BgView.txt_chatInput.length;
                    _local2.BgView.txt_chatInput.setSelection(_local4, _local4);
                    break;
                case FriendCommandList.SHOW_RECEIVE_MSG:
                    if (_arg1.getBody() == null){
                        _local5 = msgProxy.popMsgId();
                    } else {
                        _local5 = uint(_arg1.getBody());
                    };
                    _local6 = new FriendInfoStruct();
                    _local6.frendId = _local5;
                    _local7 = msgProxy.getHistory(_local5);
                    if (_local7 != null){
                        _local8 = _local7[(_local7.length - 1)];
                        if ((_local8 is ChatInfoStruct)){
                            _local6.roleName = (_local8 as ChatInfoStruct).roleName;
                        } else {
                            if ((_local8 is MessageStruct)){
                                _local6.roleName = (_local8 as MessageStruct).sendPersonName;
                            };
                        };
                        sendNotification(FriendCommandList.SHOW_SEND_MSG, _local6);
                        _local2 = SearchChatWindow(_local5, true);
                        if (_local2 != null){
                            _local2.initData(_local7.concat());
                        };
                    };
                    UIConstData.FocusIsUsing = true;
                    break;
                case FriendCommandList.SHOW_SEND_MSG:
                    _local9 = (_arg1.getBody() as FriendInfoStruct);
                    _local2 = SearchChatWindow(_local9.frendId, true);
                    if (_local2 == null){
                        _local2 = new IMChatWindow();
                        _local2.info = _local9;
                        _local2.sendMsgFun = sendMsgHandler;
                        _local2.closeCallBackFun = closeCallBack;
                        _local2.minimizeCallBack = minimizeCallBack;
                        _local2.x = (UIConstData.DefaultPos1.x + ((ChatWindowArr.length % 13) * (28 + (int((ChatWindowArr.length / 13)) * 50))));
                        _local2.y = (UIConstData.DefaultPos1.y + ((ChatWindowArr.length % 13) * 28));
                        ChatWindowArr.push(_local2);
                    };
                    if (_local2.IsMinimize){
                        _local10 = GetMinizeCellByChatWindow(_local2);
                        if (_local10){
                            MaxmizeHandler(_local10);
                        };
                    } else {
                        _local2.show();
                    };
                    if (_local9.frendId){
                        _local2.initData(msgProxy.getHistory(_local9.frendId));
                    };
                    UIConstData.FocusIsUsing = true;
                    break;
                case FriendCommandList.ADD_MSG_CHAT:
                    _local5 = uint(_arg1.getBody());
                    _local2 = SearchChatWindow(_local5, true);
                    if (_local2){
                        _local11 = msgProxy.getMsgs(_local2.info.frendId);
                        _local2.addChatCell(_local11[(_local11.length - 1)]);
                    };
                    break;
                case FriendCommandList.SHOW_POSITION:
                    if (GameCommonData.Player.Role.VIP == 3){
                        _local6 = (_arg1.getBody() as FriendInfoStruct);
                        if (_local6.isOnline){
                            FriendSend.getFriendInfo(_local6.frendId, 1);
                        } else {
                            facade.sendNotification(EventList.SHOWALERT, {
                                comfrim:sure,
                                info:LanguageMgr.GetTranslation("该好友不在线"),
                                title:LanguageMgr.GetTranslation("追踪定位")
                            });
                        };
                    } else {
                        facade.sendNotification(EventList.SHOWALERT, {
                            comfrim:sure,
                            cancel:openVIP,
                            isShowClose:true,
                            info:LanguageMgr.GetTranslation("提示非VIP无法享用该特权"),
                            title:LanguageMgr.GetTranslation("追踪定位"),
                            cancelTxt:LanguageMgr.GetTranslation("VIP通道")
                        });
                    };
                    break;
                case FriendCommandList.MINIMIZEITEMCELL_SHINE_START:
                    if (_arg1.getBody() != null){
                        _local2 = SearchChatWindow(_arg1.getBody()["friendId"], true);
                        if (((_local2) && (_local2.IsMinimize))){
                            _local10 = GetMinizeCellByChatWindow(_local2);
                            if (_local10){
                                _local10.startShine();
                            };
                        };
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    MinimizeItemBar.x = (GameCommonData.GameInstance.ScreenWidth - 140);
                    MinimizeItemBar.y = (GameCommonData.GameInstance.ScreenHeight - 220);
                    break;
            };
        }
        private function MaxmizeHandler(_arg1:MinimizeItemCell):void{
            var cw:* = null;
            var bm:* = null;
            var itemCell:* = _arg1;
            cw = itemCell.info;
            var oriPoint:* = itemCell.oriPoint;
            var oriWidth:* = itemCell.oriWdith;
            var oriHeight:* = itemCell.oriHeight;
            if (MinimizeItemCells.indexOf(itemCell) != -1){
                MinimizeItemCells.splice(MinimizeItemCells.indexOf(itemCell), 1);
                itemCell.dispose();
            };
            UpdateMinizeItemCellsPostion();
            bm = cw.getCurrentBitmap();
            bm.x = MinimizeItemBar.x;
            bm.y = MinimizeItemBar.y;
            bm.width = 50;
            bm.height = 30;
            GameCommonData.GameInstance.GameUI.addChild(bm);
//            with ({}) {
//                {}.onComplete = function ():void{
//                    GameCommonData.GameInstance.GameUI.addChild(cw);
//                    cw.IsMinimize = false;
//                    if (((bm) && (bm.parent))){
//                        bm.parent.removeChild(bm);
//                    };
//                };
//            };//geoffyan
            var onCompleteFun:* = function ():void{
                GameCommonData.GameInstance.GameUI.addChild(cw);
                cw.IsMinimize = false;
                if (((bm) && (bm.parent))){
                    bm.parent.removeChild(bm);
                };
            };
            TweenLite.to(bm, 0.3, {
                x:cw.x,
                y:cw.y,
                width:cw.frameWidth,
                height:cw.frameHeight,
                onComplete:onCompleteFun
            });
        }
        public function GetTopChatWindow():IMChatWindow{
            var _local1:IMChatWindow;
            var _local3:int;
            var _local2 = -1;
            var _local4:int;
            while (_local4 < ChatWindowArr.length) {
                if (((ChatWindowArr[_local4]) && (ChatWindowArr[_local4].parent))){
                    _local3 = GameCommonData.GameInstance.GameUI.getChildIndex(ChatWindowArr[_local4]);
                    if (_local2 < _local3){
                        _local1 = ChatWindowArr[_local4];
                        _local2 = _local3;
                    };
                };
                _local4++;
            };
            return (_local1);
        }
        private function openVIP():void{
            if (dataProxy.VipIsOpen == false){
                sendNotification(EventList.SHOW_VIP);
            };
        }
        public function SearchChatWindow(_arg1:uint, _arg2:Boolean=false):IMChatWindow{
            var _local3:IMChatWindow;
            var _local4:int;
            while (_local4 < ChatWindowArr.length) {
                _local3 = ChatWindowArr[_local4];
                if (((_local3) && ((_local3.info.frendId == _arg1)))){
                    if (!_arg2){
                        if (_local3.IsMinimize){
                            return (null);
                        };
                    };
                    return (_local3);
                };
                _local4++;
            };
            return (null);
        }
        private function sure():void{
        }
        public function GetMinizeCellByChatWindow(_arg1:IMChatWindow):MinimizeItemCell{
            var _local2:int;
            while (_local2 < MinimizeItemCells.length) {
                if (((MinimizeItemCells[_local2]) && ((MinimizeItemCells[_local2].info == _arg1)))){
                    return (MinimizeItemCells[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        private function minimizeCallBack(_arg1:IMChatWindow):void{
            var _local2:NewInfoTipVo;
            var _local3:ChatInfoStruct;
            if (_arg1){
                _local2 = new NewInfoTipVo();
                _local2.title = ((("[" + _arg1.info.roleName) + "]") + LanguageMgr.GetTranslation("邀请你聊天"));
                _local2.type = NewInfoTipType.TYPE_CHAT;
                _local2.data = {
                    sendId:_arg1.info.frendId,
                    sendName:_arg1.info.roleName,
                    minimize:true
                };
                sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local2);
                _local3 = new ChatInfoStruct();
                _local3.roleId = GameCommonData.Player.Role.Id;
                _local3.roleName = _arg1.info.roleName;
                _local3.friendId = _arg1.info.frendId;
                _local3.type = FriendActionList.CHAT_FLAG;
                msgProxy.pushSendMsg(_local3);
                closeCallBack(_arg1);
            };
        }
        private function sendMsgHandler(_arg1:IMChatWindow, _arg2:ChatInfoStruct):void{
            if ((((_arg1.BgView.txt_chatInput.text == null)) || ((_arg1.BgView.txt_chatInput.text == "")))){
                MessageTip.show(LanguageMgr.GetTranslation("发送内容不能为空感叹"));
                return;
            };
            _arg1.chatingList.addChatCell(_arg2);
            ChatSend.SendChat(_arg2);
            msgProxy.pushSendMsg(_arg2);
            _arg1.BgView.txt_chatInput.text = "";
        }
        private function UpdateMinizeItemCellsPostion():void{
            var _local1:MinimizeItemCell;
            var _local2:int;
            _local2 = 0;
            while (_local2 < MinimizeItemBar.numChildren) {
                _local1 = (MinimizeItemBar.getChildAt(_local2) as MinimizeItemCell);
                if (((_local1) && (_local1.parent))){
                    _local1.parent.removeChild(_local1);
                };
                _local2++;
            };
            var _local3:Array = MinimizeItemCells.slice(0, 3);
            _local2 = 0;
            while (_local2 < _local3.length) {
                _local1 = _local3[_local2];
                _local1.x = 0;
                _local1.y = ((_local1.height + 2) * _local2);
                MinimizeItemBar.addChild(_local1);
                _local2++;
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, FriendCommandList.GET_FACE_NAME, FriendCommandList.SELECTED_FONT_COLOR, FriendCommandList.SHOW_RECEIVE_MSG, FriendCommandList.SHOW_SEND_MSG, FriendCommandList.ADD_MSG_CHAT, FriendCommandList.REVEIVE_CHAT_INFO, FriendCommandList.SHOW_POSITION, FriendCommandList.MINIMIZEITEMCELL_SHINE_START, EventList.RESIZE_STAGE]);
        }
        private function closeCallBack(_arg1:IMChatWindow):void{
            if (_arg1){
                if (ChatWindowArr.indexOf(_arg1) != -1){
                    ChatWindowArr.splice(ChatWindowArr.indexOf(_arg1), 1);
                };
                _arg1.close();
            };
        }
        public function AddMinimize(_arg1:IMChatWindow, _arg2:Point, _arg3:Point):void{
            var _local4:MinimizeItemCell;
            _local4 = new MinimizeItemCell();
            _local4.oriPoint = _arg2;
            _local4.oriWdith = _arg3.x;
            _local4.oriHeight = _arg3.y;
            _local4.ClickCallBack = MaxmizeHandler;
            _local4.info = _arg1;
            MinimizeItemCells.unshift(_local4);
            _arg1.IsMinimize = true;
            if (GameCommonData.GameInstance.GameUI.contains(_arg1)){
                GameCommonData.GameInstance.GameUI.removeChild(_arg1);
            };
            UpdateMinizeItemCellsPostion();
        }

    }
}//package GameUI.Modules.Friend.view.mediator 
