package tempest.common.net.vo
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class TPacketIn extends TByteArray
	{
		public var cmd:uint;
		public var len:uint;

		public function TPacketIn()
		{
			super();
		}

		public function resolve():void
		{
			this.len = this.readUnsignedByte() << 8 | this.readUnsignedByte();
			this.cmd = this.readUnsignedByte() << 8 | this.readUnsignedByte();
		}

		public override function toString():String
		{
			return "TPacketIn(cmd:" + cmd + " len:" + len + ")\n" + super.toString();
		}
	}
}
