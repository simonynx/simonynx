package common
{
	import flash.utils.ByteArray;

	public class Decoder
	{
		private var _decode:Function;

		public function Decoder()
		{
		}

		public function set decode(value:Function):void
		{
			_decode = value;
		}

		public function decodeToXML(data:*):*
		{
			if (data is ByteArray)
			{
				if (_decode != null)
				{
					data = _decode(data);
				}
				return XML(data);
			}
			return data;
		}
	}
}
