package tempest.common.net.vo
{

	public class TPacketOut extends TByteArray
	{
		public function TPacketOut(opcode:uint)
		{
			super();
			this.writeShort(0x00); //长度
			this.writeShort(opcode); //代码
		}
		public function writePacketLength():uint
		{
			this.position = 0;
			this.writeShort(this.length);
			return this.length;
		}
	}
}