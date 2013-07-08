//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Data {
    import GameUI.UICore.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import Utils.*;

    public class ChatData {

        public static const CHAT_TYPE_TEAM:uint = 2003;
        public static const OPENSCROLLNOTICE:String = "OPENSCROLLNOTICE";
        public static const USE_BIG_LEO:String = "USE_BIG_LEO";
        public static const CHAT_TYPE_UNITY:uint = 2004;
        public static const CHAT_TYPE_POST:uint = 77777;
        public static const CHAT_TYPE_WORLD:uint = 2016;
        public static const CHAT_TYPE_LEO:uint = 2030;
        public static const CHAT_TYPE_FACTION:uint = 2020;
        public static const FACE_NUM:uint = 42;
        public static const CHAT_TYPE_STS:uint = 1007;
        public static const MAX_AMOUNT_MSG:int = 30;
        public static const CHAT_TYPE_FRIEND:uint = 2019;
        public static const CHAT_TYPE_PRIVATE:uint = 2001;
        public static const CHAT_TYPE_NEAR:uint = 2013;
        public static const CHAT_TYPE_STSTEM:uint = 9999;
        public static const CHAT_TYPE_TIPS:uint = 4001;
        public static const CHAT_WIDTH:uint = 266;

        public static var tempItemStrLeo:String = "";
        public static var Set5ChannelList:Object = {
            CHAT_TYPE_WORLD:false,
            CHAT_TYPE_UNITY:false,
            CHAT_TYPE_TEAM:false,
            CHAT_TYPE_PRIVATE:false,
            CHAT_TYPE_NEAR:true,
            CHAT_TYPE_TIPS:false,
            CHAT_TYPE_STS:false,
            CHAT_TYPE_NEAR:false,
            CHAT_TYPE_FACTION:true,
            CHAT_TYPE_STSTEM:false
        };
        public static var lastPlayIndex:int = -1;
        public static var NearMsg:Array = new Array();
        public static var otherBool:Boolean = true;
        public static var ScrollNotice:Array = new Array();
        public static var WELCOME_INTERVAL:Number = 0;
        public static var curSelectModel:int = 4;
        public static var SelectChannelOpen:Boolean = false;
        public static var SetLeoIsOpen:Boolean = false;
        public static var SecondLeftInWorld:uint = 15;
        public static var UPDATAGUN:String = "UPDATAGUN";
        public static var SelectedMsgColor:uint = 0xFFFFFF;
        public static var CHAT_COLORS:Array = [0xFFFFFF, 7971583, 15830527, 2412592, 57087, 0xA8FF00, 16611586, 0xFFFF00, 15830527, 0xBA00FF, 0xFFFF00, 0xFF00, 0xFF00FF, 42577, 16724530, 0xFF00FF, 26367, 0xFF0000, 16687984];
        public static var Set2Msg:Array = new Array();
        public static var CurAreaPos:int = 2;
        public static var AllMsg:Array = new Array();
        public static var tmpLeoPoint:Point = new Point(50, 100);
        public static var ContactListOpen:Boolean = false;
        public static var FilterList:Array = new Array();
        public static var tmpChatInfo:Array = [];
        public static var Set3ChannelList:Object = {
            CHAT_TYPE_WORLD:false,
            CHAT_TYPE_UNITY:true,
            CHAT_TYPE_TEAM:false,
            CHAT_TYPE_PRIVATE:true,
            CHAT_TYPE_NEAR:false,
            CHAT_TYPE_STS:false,
            CHAT_TYPE_NEAR:false,
            CHAT_TYPE_TIPS:false,
            CHAT_TYPE_FACTION:false,
            CHAT_TYPE_STSTEM:false
        };
        public static var MsgPosArea:Array = [{
            width:CHAT_WIDTH,
            height:120,
            x:0,
            y:413
        }, {
            width:CHAT_WIDTH,
            height:162,
            x:0,
            y:371
        }, {
            width:CHAT_WIDTH,
            height:200,
            x:0,
            y:333
        }];
        public static var NOTICE_ARR:Array = null;
        public static var tmpCreatePoint:Point = new Point(50, 100);
        public static var tmpFilterPoint:Point = new Point(50, 100);
        public static var TeamerChat:String = "";
        public static var CurShowContent:int = 0;
        public static var FilterListIsOpen:Boolean = false;
        public static var SetBigLeoIsOpen:Boolean = false;
        public static var mcFaceDic:Dictionary = new Dictionary();
        public static var Set1ChannelList:Object = {
            CHAT_TYPE_WORLD:false,
            CHAT_TYPE_UNITY:false,
            CHAT_TYPE_TEAM:true,
            CHAT_TYPE_PRIVATE:true,
            CHAT_TYPE_NEAR:false,
            CHAT_TYPE_STS:false,
            CHAT_TYPE_NEAR:false,
            CHAT_TYPE_TIPS:false,
            CHAT_TYPE_FACTION:false,
            CHAT_TYPE_STSTEM:false
        };
        public static var loadswfTool:LoadSwfTool;
        public static var worldBool:Boolean = true;
        public static var HtmlStyle:StyleSheet = new StyleSheet();
        public static var txtIsFoucs:Boolean = false;
        public static var Set4ChannelList:Object = {
            CHAT_TYPE_WORLD:false,
            CHAT_TYPE_UNITY:false,
            CHAT_TYPE_TEAM:false,
            CHAT_TYPE_PRIVATE:false,
            CHAT_TYPE_NEAR:true,
            CHAT_TYPE_STS:false,
            CHAT_TYPE_NEAR:false,
            CHAT_TYPE_TIPS:false,
            CHAT_TYPE_FACTION:false,
            CHAT_TYPE_STSTEM:false
        };
        public static var tempItemStr:String = "";
        public static var isGun:Boolean = false;
        public static var ColorIsOpen:Boolean = false;
        public static var QuickChatIsOpen:Boolean = false;
        public static var CreateChannelIsOpen:Boolean = false;
        public static var ContactList:Array = new Array();
        public static var WELCOME_ARR:Array = null;
        public static var NameStyle:StyleSheet = new StyleSheet();
        public static var SelectedLeoColor:uint = 0xFFFFFF;
        public static var Set1Msg:Array = new Array();
        public static var currFaceGuid:uint = 0;
        public static var NOTICE_HELP_INTERVAL:Number = 0;
        public static var UnityMsg:Array = new Array();
        public static var channelModel:Array = [{
            label:"<font color='#ffffff'>附近</font>",
            name:"附近",
            channel:CHAT_TYPE_NEAR,
            rece:"ALLUSER",
            color:"#ffffff"
        }, {
            label:"<font color='#79a2ff'>队伍</font>",
            name:"队伍",
            channel:CHAT_TYPE_TEAM,
            rece:"ALLUSER",
            color:"#79a2ff"
        }, {
            label:"<font color='#f18dff'>私聊</font>",
            name:"私聊",
            channel:CHAT_TYPE_PRIVATE,
            rece:"私聊对象",
            color:"#f18dff"
        }, {
            label:"<font color='#24d030'>公会</font>",
            name:"公会",
            channel:CHAT_TYPE_UNITY,
            rece:"ALLUSER",
            color:"0x24d030"
        }, {
            label:"<font color='#00deff'>世界</font>",
            name:"世界",
            channel:CHAT_TYPE_WORLD,
            rece:"ALLUSER",
            color:"#00deff"
        }, {
            label:"<font color='#a8ff00'>喇叭</font>",
            name:"喇叭",
            channel:CHAT_TYPE_LEO,
            rece:"ALLUSER",
            color:"#a8ff00"
        }, {
            label:"<font color='#fd7902'>阵营</font>",
            name:"阵营",
            channel:CHAT_TYPE_FACTION,
            rece:"ALLUSER",
            color:"#fd7902"
        }];
        public static var Set2ChannelList:Object = {
            CHAT_TYPE_WORLD:false,
            CHAT_TYPE_UNITY:false,
            CHAT_TYPE_TEAM:false,
            CHAT_TYPE_PRIVATE:true,
            CHAT_TYPE_NEAR:false,
            CHAT_TYPE_STS:false,
            CHAT_TYPE_NEAR:false,
            CHAT_TYPE_TIPS:false,
            CHAT_TYPE_FACTION:false,
            CHAT_TYPE_STSTEM:false
        };
        public static var FactionMsg:Array = new Array();

        public static function Notification(_arg1:String):void{
            var _local2:ChatReceiveMsg = new ChatReceiveMsg();
            _local2.htmlText = _arg1;
            _local2.info = "";
            _local2.name = "";
            _local2.type = 9999;
            UIFacade.GetInstance().sendNotification(CommandList.RECEIVECOMMAND, _local2);
        }
        public static function SimpleChat(_arg1:uint, _arg2:String, _arg3:String="", _arg4:String=""):void{
            var _local5:ChatReceiveMsg = new ChatReceiveMsg();
            _local5.htmlText = _arg3;
            _local5.info = _arg4;
            _local5.name = _arg2;
            _local5.type = _arg1;
            if (_arg1 == CHAT_TYPE_UNITY){
                _local5.talkObj = new Array(5);
                _local5.talkObj[3] = (("<3_" + _arg3) + "_3>");
            };
            UIFacade.GetInstance().sendNotification(CommandList.RECEIVECOMMAND, _local5);
        }
        public static function getFaceGUID():uint{
            currFaceGuid++;
            var _local1:uint = currFaceGuid;
            return (_local1);
        }

    }
}//package GameUI.Modules.Chat.Data 
