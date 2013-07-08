//Created by Action Script Viewer - http://www.buraks.com/asv
package Net {
    import flash.events.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import OopsFramework.Net.*;
    import OopsFramework.Debug.*;
    import flash.net.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Verification.Proxy.*;
    import flash.external.*;

	/**
	 *跟游戏服务器通信类 
	 * @author wengliqiang
	 * 
	 */	
    public class GameNet {

        public static var S_CURRENT_TIME:int;
        public static var PING_DALAY:int = 0;
        public static var C_CURRENT_TIME:int;

        private var intervalId:uint;
        public var m_sendpacket:NetPacket;
        private var socket:BaseSocket;
        private var tim:Number;
        public var m_revpacket:NetPacket;
        private var gam:GameActionManager;
        public var heartTimer:Timer;

        public function GameNet(_arg1:String="", _arg2:uint=0){
            heartTimer = new Timer(10000);
            super();
            m_revpacket = new NetPacket(2);
            m_sendpacket = new NetPacket(2);
            this.gam = new GameActionManager();
            this.socket = new BaseSocket(_arg1, _arg2);
            this.socket.addEventListener(BaseSocketEvent.CONNECT, onConnect);
            this.socket.addEventListener(BaseSocketEvent.RECEIVED, onReceived);
            this.socket.addEventListener(BaseSocketEvent.DECODE_ERROR, deCodeError);
            this.socket.addEventListener(BaseSocketEvent.CLOSE, onClose);
            this.socket.addEventListener(BaseSocketEvent.SECURITY_ERROR, deCodeError);
            this.socket.Connect();
        }
        private function showAlert():void{
            if (VerificationData.TimeLimitFlag != VerificationData.TIME_LIMIT_NOTIMELEFT){
                UIFacade.GetInstance().sendNotification(EventList.SHOW_OFFLINETIP);
            };
        }
        private function onConnect(_arg1:BaseSocketEvent):void{
            GameConnectSend.GameServerConnect(GameCommonData.Accmoute, GameCommonData.GServerInfo.dwData, GameConfigData.CurrentServer);
            CharacterSend.sendCurrentStep((GameConfigData.Env + "环境"));
            heartTimer.addEventListener(TimerEvent.TIMER, onPingHandler);
            heartTimer.start();
            onPingHandler(null);
        }
        private function deCodeError(_arg1:BaseSocketEvent):void{
            Logger.Info(this, "deCodeError", "安全错");
        }
        private function callJs(_arg1:String, _arg2:String=""):void{
            var _arg1:* = _arg1;
            var _arg2:String = _arg2;
            var name:* = _arg1;
            var para:* = _arg2;
            try {
                ExternalInterface.call(name, -2);
            } catch(e:Error) {
            };
        }
        private function onReceived(_arg1:BaseSocketEvent):void{
            var opcode:* = 0;
            var _arg1:* = _arg1;
            while (((socket) && (m_revpacket.ReadPacket(socket.netSocket)))) {
                m_revpacket.m_compressed = false;
                if (m_revpacket.opcode >= 10000){
                    m_revpacket.opcode = (m_revpacket.opcode - 10000);
                    m_revpacket.m_compressed = true;
                    try {
                        m_revpacket.uncompress();
                    } catch(e:Error) {
                        throw (new Error(((("解压出错，类型:" + m_revpacket.opcode.toString()) + "长度:") + m_revpacket.packlen.toString())));
                    };
                };
                opcode = m_revpacket.opcode;
                if (this.gam.ActionList[opcode] != null){
                    this.gam.ActionList[opcode].Processor(m_revpacket);
                };
            };
        }
        public function SendPacket():void{
            if (socket){
                m_sendpacket.Flush(socket.netSocket);
            };
        }
        private function onPingHandler(_arg1:TimerEvent):void{
            var _local2:Date = new Date();
            tim = _local2.time;
            GameNet.C_CURRENT_TIME = getTimer();
            m_sendpacket.opcode = Protocol.CMSG_PING;
            m_sendpacket.writeUnsignedInt(GameNet.C_CURRENT_TIME);
            m_sendpacket.writeUnsignedInt(GameNet.PING_DALAY);
            SendPacket();
            if ((GameNet.C_CURRENT_TIME - TimeManager.Instance.GetLastPong()) > (120 * 1000)){
                heartTimer.stop();
                CharacterSend.sendCurrentStep("error 客户端检测到Ping超时");
                UIFacade.GetInstance().sendNotification(EventList.SHOW_OFFLINETIP);
            };
        }
        public function get Gam():GameActionManager{
            return (gam);
        }
        public function endGameNet():void{
            this.socket.Close();
            this.socket = null;
        }
        private function onClose(_arg1:BaseSocketEvent):void{
            this.socket = null;
            showAlert();
        }

    }
}//package Net 
