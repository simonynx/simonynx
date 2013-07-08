//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Net {
    import flash.events.*;
    import flash.utils.*;
    import flash.net.*;

	/**
	 *对socket封装 
	 * @author wengliqiang
	 * 
	 */	
    public class BaseSocket extends EventDispatcher {

        private var port:uint;
        private var host:String;
        private var socket:Socket;
        private var receBytes:ByteArray;

        public function BaseSocket(_arg1:String, _arg2:uint=80){
            this.host = _arg1;
            this.port = _arg2;
            this.socket = new Socket();
            this.receBytes = new ByteArray();
            this.receBytes.endian = Endian.LITTLE_ENDIAN;
            this.socket.addEventListener(Event.CONNECT, Handler);
            this.socket.addEventListener(Event.CLOSE, Handler);
            this.socket.addEventListener(IOErrorEvent.IO_ERROR, Handler);
            this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, Handler);
            this.socket.addEventListener(ProgressEvent.SOCKET_DATA, Handler);
        }
        public function get Connected():Boolean{
            return (this.socket.connected);
        }
        public function Connect():void{
            this.socket.connect(host, port);
        }
        public function get Host():String{
            return (host);
        }
        private function Handler(_arg1:Event):void{
            switch (_arg1.type){
                case Event.CLOSE:
                    this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.CLOSE));
                    break;
                case Event.CONNECT:
                case IOErrorEvent.IO_ERROR:
                case SecurityErrorEvent.SECURITY_ERROR:
                    this.dispatchEvent(new BaseSocketEvent(_arg1.type));
                    break;
                case ProgressEvent.SOCKET_DATA:
                    this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.RECEIVED));
                    break;
            };
        }
        public function Send(_arg1:ByteArray=null):void{
            if (((!(this.Connected)) || ((_arg1 == null)))){
                return;
            };
            if (_arg1){
                this.socket.writeBytes(_arg1, 0, _arg1.length);
                this.socket.flush();
            };
        }
        public function Close():void{
            this.socket.close();
        }
        public function get Port():uint{
            return (port);
        }
        public function get netSocket():Socket{
            return (socket);
        }

    }
}//package OopsFramework.Net 
