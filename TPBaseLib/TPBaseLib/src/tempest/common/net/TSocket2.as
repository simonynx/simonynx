package tempest.common.net
{
	import flash.events.*;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import tempest.common.logging.*;
	import tempest.common.net.vo.TPacketIn;
	import tempest.common.net.vo.TPacketOut;
	import tempest.core.IDisposable;
	import tempest.core.ISocket;

	public class TSocket2 implements ISocket, IDisposable
	{
		private static const log:ILogger = TLog.getLogger(TSocket2);
		public static const STACK_SIZE:int = 10;
		private var _packetStack:Vector.<TPacketIn> = new Vector.<TPacketIn>();
		private var _bytesCache:ByteArray = new ByteArray();
		private var _name:String;
		private var _socket:Socket;
		private var _signals:TSocketSignal = new TSocketSignal();

		public function TSocket2(name:String = "")
		{
			this._name = name;
			_socket = new Socket();
			this.addListens();
		}

		public function get name():String
		{
			return _name;
		}

		public function get socket():Socket
		{
			return _socket;
		}

		public function get signals():TSocketSignal
		{
			return _signals;
		}

		public function get bytesAvailable():uint
		{
			return _socket.bytesAvailable;
		}

		public function close():void
		{
			_socket.close();
		}

		public function connect(host:String, port:int):void
		{
			_socket.connect(host, port);
		}

		public function get connected():Boolean
		{
			return _socket.connected;
		}

		public function get endian():String
		{
			return _socket.endian;
		}

		public function set endian(value:String):void
		{
			_socket.endian = value;
		}

		public function flush():void
		{
			_socket.flush();
		}

		public function get objectEncoding():uint
		{
			return _socket.objectEncoding;
		}

		public function set objectEncoding(value:uint):void
		{
			_socket.objectEncoding = value;
		}

		public function readBoolean():Boolean
		{
			return _socket.readBoolean();
		}

		public function readByte():int
		{
			return _socket.readByte();
		}

		public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			_socket.readBytes(bytes, offset, length);
		}

		public function readDouble():Number
		{
			return _socket.readDouble();
		}

		public function readFloat():Number
		{
			return _socket.readFloat();
		}

		public function readInt():int
		{
			return _socket.readInt();
		}

		public function readMultiByte(length:uint, charSet:String):String
		{
			return _socket.readMultiByte(length, charSet);
		}

		public function readObject():*
		{
			return _socket.readObject();
		}

		public function readShort():int
		{
			return _socket.readShort();
		}

		public function readUTF():String
		{
			return _socket.readUTF();
		}

		public function readUTFBytes(length:uint):String
		{
			return _socket.readUTFBytes(length);
		}

		public function readUnsignedByte():uint
		{
			return _socket.readUnsignedByte();
		}

		public function readUnsignedInt():uint
		{
			return _socket.readUnsignedInt();
		}

		public function readUnsignedShort():uint
		{
			return _socket.readUnsignedShort();
		}

		public function get timeout():uint
		{
			return _socket.timeout;
		}

		public function set timeout(value:uint):void
		{
			_socket.timeout = value;
		}

		public function writeBoolean(value:Boolean):void
		{
			_socket.writeBoolean(value);
		}

		public function writeByte(value:int):void
		{
			_socket.writeByte(value);
		}

		public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			_socket.writeBytes(bytes, offset, length);
		}

		public function writeDouble(value:Number):void
		{
			_socket.writeDouble(value);
		}

		public function writeFloat(value:Number):void
		{
			_socket.writeFloat(value);
		}

		public function writeInt(value:int):void
		{
			_socket.writeInt(value);
		}

		public function writeMultiByte(value:String, charSet:String):void
		{
			_socket.writeMultiByte(value, charSet);
		}

		public function writeObject(object:*):void
		{
			_socket.writeObject(object);
		}

		public function writeShort(value:int):void
		{
			_socket.writeShort(value);
		}

		public function writeUTF(value:String):void
		{
			_socket.writeUTF(value);
		}

		public function writeUTFBytes(value:String):void
		{
			_socket.writeUTFBytes(value);
		}

		public function writeUnsignedInt(value:uint):void
		{
			_socket.writeUnsignedInt(value);
		}

		private function addListens():void
		{
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, receiveHandler);
			_socket.addEventListener(Event.CLOSE, closehandler);
			_socket.addEventListener(Event.CONNECT, connectHandle);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandle);
		}

		private function removeListens():void
		{
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, receiveHandler);
			_socket.removeEventListener(Event.CLOSE, closehandler);
			_socket.removeEventListener(Event.CONNECT, connectHandle);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandle);
		}

		private function securityHandle(event:SecurityErrorEvent):void
		{
			this._signals.securityError.dispatch(this);
		}

		private function ioErrorHandle(event:IOErrorEvent):void
		{
			this._signals.ioError.dispatch(this);
		}

		private function connectHandle(event:Event):void
		{
			this._bytesCache.clear();
			this._packetStack.length = 0;
			this._signals.connect.dispatch(this);
		}

		private function closehandler(event:Event):void
		{
			this._signals.close.dispatch(this);
		}

		private function receiveHandler(event:ProgressEvent):void
		{
			if (this.bytesAvailable > 0)
			{
				//将数据读取到缓存中
				this._bytesCache.position = this._bytesCache.length;
				this.readBytes(_bytesCache);
				//解析包
				this._bytesCache.position = 0;
				while (this._bytesCache.bytesAvailable >= 4)
				{
					var len:uint = this._bytesCache[this._bytesCache.position] << 8 | this._bytesCache[this._bytesCache.position + 1]; //读取长度
					//长度异常
					if (len < 2)
					{
						this._bytesCache.position += 1;
						this.traceStack();
						log.warn("data exception!!!len:{0} pos:{1} bytesAvailable:{2}", len, this._bytesCache.position, this._bytesCache.bytesAvailable);
						continue;
					}
					//数据不够
					if (this._bytesCache.bytesAvailable < len + 2)
					{
						break;
					}
					var packetIn:TPacketIn = new TPacketIn();
					packetIn.len = len;
					this._bytesCache.position += 2; //跳过len两字节
					packetIn.cmd = this._bytesCache.readUnsignedByte() << 8 | this._bytesCache.readUnsignedByte();
					this._bytesCache.readBytes(packetIn, 0, len - 2);
					this._signals.socketData.dispatch(this, packetIn);
					_packetStack.push(packetIn);
					if (_packetStack.length > STACK_SIZE)
					{
						_packetStack.shift().clear();
					}
				}
				if (this._bytesCache.bytesAvailable != this._bytesCache.length)
					this._bytesCache.length = this._bytesCache.bytesAvailable;
			}
		}

		/**
		 * 强行连接
		 * @param host
		 * @param port
		 */
		public function connect2(host:String, port:int):void
		{
			if (_socket && !_socket.connected)
			{
				removeListens();
				_socket = new Socket();
				addListens();
			}
			this.connect(host, port);
		}

		/**
		 * 发送封包
		 * @param packet
		 */
		public function send(packet:TPacketOut):void
		{
			//写入封包长度
			packet.writePacketLength();
			packet.position = 0;
			if (this.connected)
			{
				this.writeBytes(packet);
				this.flush();
			}
			packet.clear();
		}

		public function traceStack():void
		{
			var len:int = _packetStack.length;
			for (var i:int = 0; i != len; i++)
			{
				log.debug("PacketStack[{0}] " + _packetStack[i].toString(), i);
			}
		}

		public function toString():String
		{
			return "[TSocket] name:" + _name;
		}

		public function dispose():void
		{
			if (_socket)
			{
				removeListens();
			}
			_signals.removeAll();
		}
	}
}
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;
import org.osflash.signals.utilities.SignalSet;
import tempest.common.net.TSocket2;
import tempest.common.net.vo.TPacketIn;

class TSocketSignal extends SignalSet
{
	public function TSocketSignal()
	{
		super();
	}

	public function get close():ISignal
	{
		return getSignal("close", Signal, TSocket2);
	}

	public function get connect():ISignal
	{
		return getSignal("connect", Signal, TSocket2);
	}

	public function get ioError():ISignal
	{
		return getSignal("ioError", Signal, TSocket2);
	}

	public function get securityError():ISignal
	{
		return getSignal("securityError", Signal, TSocket2);
	}

	public function get socketData():ISignal
	{
		return getSignal("socketData", Signal, TSocket2, TPacketIn);
	}
}
