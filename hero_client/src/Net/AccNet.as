//Created by Action Script Viewer - http://www.buraks.com/asv
package Net {
    import flash.utils.*;
    import OopsFramework.Net.*;
    import Net.RequestSend.*;

	/**
	 *访问用户通信类 
	 * @author wengliqiang
	 * 
	 */	
    public class AccNet {

        public var m_sendpacket:NetPacket;
        private var gam:GameActionManager;
        public var m_revpacket:NetPacket;
        private var socket:BaseSocket;

        public function AccNet(_arg1:String="", _arg2:uint=0){
            m_revpacket = new NetPacket();
            m_sendpacket = new NetPacket();
            this.gam = new GameActionManager();
            this.socket = new BaseSocket(_arg1, _arg2);
            this.socket.addEventListener(BaseSocketEvent.CONNECT, onConnect);
            this.socket.addEventListener(BaseSocketEvent.RECEIVED, onReceived);
            this.socket.addEventListener(BaseSocketEvent.IO_ERROR, onError);
            this.socket.addEventListener(BaseSocketEvent.CLOSE, onClose);
            this.socket.Connect();
        }
        private function onReceived(_arg1:BaseSocketEvent):void{
            var _local2:int;
            if (m_revpacket.ReadPacket(socket.netSocket)){
                _local2 = m_revpacket.opcode;
                if (this.gam.ActionList[_local2] != null){
                    this.gam.ActionList[_local2].Processor(m_revpacket);
                };
            };
        }
        private function removeLis():void{
            this.socket.removeEventListener(BaseSocketEvent.CONNECT, onConnect);
            this.socket.removeEventListener(BaseSocketEvent.RECEIVED, onReceived);
            this.socket.removeEventListener(BaseSocketEvent.IO_ERROR, onError);
            this.socket.removeEventListener(BaseSocketEvent.CLOSE, onClose);
        }
        private function onConnect(_arg1:BaseSocketEvent):void{
            if (GameCommonData.Tiao){
				trace("连接成功!");
                //GameCommonData.Tiao.content_txt.text = "连接成功,正在验证.....";
            };
            AccLoginSend.AccLoginCreate(GameCommonData.Accmoute, GameCommonData.Password, GameConfigData.CurrentServer);
        }
        private function onClose(_arg1:BaseSocketEvent):void{
            removeLis();
            this.socket = null;
        }
        private function onError(_arg1:BaseSocketEvent):void{
            if (GameCommonData.Tiao){
               // GameCommonData.Tiao.content_txt.text = "连接登录服务器失败.....";
            };
            trace("连接登录服务器失败");
        }
        public function SendPacket():void{
            m_sendpacket.Flush(socket.netSocket);
        }
        public function Close():void{
            this.socket.Close();
        }

    }
}//package Net 
