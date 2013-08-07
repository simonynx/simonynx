package fj1.common
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

		public function get decode():Function
		{
			return _decode;
		}

		/**
		 * 返回XMLList
		 * @param data
		 * @return
		 *
		 */
		public function toXML(data:*):*
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

		/**
		 * 配置文件解码成String
		 * @param data
		 * @return
		 *
		 */
		public function toString(data:*):String
		{
			if (data is ByteArray)
			{
				if (_decode != null)
				{
					data = _decode(data);
				}
				return String(data);
			}
			else if (data != null)
			{
				return data;
			}
			return null;
		}
	}
}
