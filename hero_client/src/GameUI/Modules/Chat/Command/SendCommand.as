//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Command {
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Chat.Data.*;
    import Utils.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.*;

    public class SendCommand extends SimpleCommand {

        private var delayTimer:Timer;
        private var worldDelayID:uint = 0;
        private var otherDelayID:uint = 0;

        private function testIsDFilter(_arg1:String):void{
            var _local2:int;
            var _local3:String = LanguageMgr.GetTranslation("你在x黑名单中y收到不你消息", _arg1, _arg1);
            while (_local2 < ChatData.FilterList.length) {
                if (_arg1 == ChatData.FilterList[_local2]){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:_local3,
                        color:0xFFFF00
                    });
                    return;
                };
                _local2++;
            };
        }
        private function getParams(_arg1:String, _arg2:int, _arg3:String, _arg4:int, _arg5:String=" ", _arg6:uint=0):ChatInfoStruct{
            var _local7:String = _arg3.replace(" ", "");
            var _local8:String = _arg3;
            while (_local8 != _local7) {
                _local8 = _local7;
                _local7 = _local7.replace(" ", "");
            };
            var _local9:String = UIUtils.filterChat(_local7);
            var _local10:ChatInfoStruct = new ChatInfoStruct();
            if (_local9 != _local7){
                _local10.content = _local9;
            } else {
                _local10.content = _arg3;
            };
            _local10.roleId = GameCommonData.Player.Role.Id;
            _local10.roleName = GameCommonData.Player.Role.Name;
            _local10.targetName = _arg1;
            _local10.item = "";
            _local10.color = _arg2;
            _local10.type = _arg4;
            _local10.face = 0;
            _local10.jobId = _arg6;
            _local10.timeT = 0;
            return (_local10);
        }
        private function timerHandler(_arg1:TimerEvent):void{
            ChatData.SecondLeftInWorld--;
        }
        override public function execute(_arg1:INotification):void{
            var _local2:Object;
            var _local5:String;
            _local2 = _arg1.getBody();
            var _local3:String = _local2.talkMsg;
            var _local4:ChatInfoStruct = getParams(_local2.name, _local2.color, _local3, _local2.type, _local2.item, _local2.jobId);
            if ((((((_local2.type == ChatData.CHAT_TYPE_WORLD)) && (!(ChatData.worldBool)))) && (!((_local3.charAt(0) == "!"))))){
                _local5 = "";
                _local5 = LanguageMgr.GetTranslation("说话太快歇会吧");
                ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", _local5);
                ChatData.tempItemStr = " ";
                return;
            };
            if (((((!(ChatData.otherBool)) && (!((_local3.charAt(0) == "!"))))) && (!((_local2.type == ChatData.CHAT_TYPE_WORLD))))){
                ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", LanguageMgr.GetTranslation("说话太快歇会吧"));
                ChatData.tempItemStr = " ";
                return;
            };
            if ((((_local2.type == ChatData.CHAT_TYPE_UNITY)) && (!((GameCommonData.Player.Role.GuildBanChatFlag == 0))))){
                ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", LanguageMgr.GetTranslation("你已被禁言"));
                ChatData.tempItemStr = " ";
                return;
            };
            if (_local3.charAt(0) == "!"){
                _local4.content = _local4.content.substr(1, (_local4.content.length - 1));
            };
            ChatSend.SendChat(_local4);
            ChatData.tempItemStr = " ";
            if ((((((_local2.type == ChatData.CHAT_TYPE_WORLD)) && (ChatData.worldBool))) && (!((_local3.charAt(0) == "!"))))){
                ChatData.worldBool = false;
                if (delayTimer){
                    delayTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
                    delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
                    delayTimer = null;
                };
                delayTimer = new Timer(1000, 15);
                delayTimer.addEventListener(TimerEvent.TIMER, timerHandler);
                delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
                delayTimer.start();
                ChatData.SecondLeftInWorld = 15;
                worldDelayID = setInterval(setWorldChatDelay, 15000);
                return;
            };
            ChatData.otherBool = false;
            otherDelayID = setInterval(setOtherChatDelay, 2000);
        }
        private function setWorldChatDelay():void{
            clearInterval(worldDelayID);
            ChatData.worldBool = true;
        }
        private function setOtherChatDelay():void{
            clearInterval(otherDelayID);
            ChatData.otherBool = true;
        }
        private function timerComplete(_arg1:TimerEvent):void{
            delayTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
            delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
            delayTimer = null;
        }

    }
}//package GameUI.Modules.Chat.Command 
