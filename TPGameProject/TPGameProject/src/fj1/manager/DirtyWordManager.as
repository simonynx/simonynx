package fj1.manager
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;

	import flash.utils.ByteArray;

	import tempest.utils.StringUtil;

	/**
	 * 脏字辅助类
	 * @author wushangkun
	 */
	public class DirtyWordManager
	{
		private static var minWordLen:int = int.MAX_VALUE;
		private static var maxWordLen:int = int.MAX_VALUE;
		private static var fastCheck:Array = [];
		private static var charCheck:Array = [];
		private static var hash:Object = {};

		/**
		 * 初始化脏字表
		 * @param dirtywords
		 * @param delim
		 */
		public static function init(data:*, delim:String = "|"):Boolean
		{
			var str:String = ResManagerHelper.getString(data);
			if (str == null)
			{
				return false;
			}
			fastCheck = [];
			charCheck = [];
			hash = {};
			data = str.split(delim);
			var word:String;
			for each (word in data)
			{
				word = word.replace(/^\s+/, "").replace(/\s+$/, "");
				if (word.length != 0)
				{
					minWordLen = Math.min(minWordLen, word.length);
					maxWordLen = Math.max(maxWordLen, word.length);
					var len:int = word.length;
					for (var i:int = 0; i < 7 && i < len; i++)
					{
						fastCheck[word.charCodeAt(i)] |= (1 << i);
					}
					for (var j:int = 7; j < len; j++)
					{
						fastCheck[word.charCodeAt(i)] |= 0x80;
					}
					if (word.length == 1)
					{
						charCheck[word.charCodeAt(0)] = true;
					}
					else
					{
						hash[word] = null;
					}
				}
			}
			return true;
		}

		/**
		 * 是否含有脏字
		 * @param source 要检查的字符串
		 * @return
		 */
		public static function hasDirtyWord(source:String):Boolean
		{
			var index:int = 0;
			var len:int = source.length;
			var loops:int;
			var sub:String;
			while (index < len)
			{
				if ((fastCheck[source.charCodeAt(index)] & 1) == 0)
				{
					while ((index < len - 1) && (fastCheck[source.charCodeAt(++index)] & 1) == 0)
					{
					}
				}
				//单字节检测
				if (minWordLen == 1 && charCheck[source.charCodeAt(index)])
				{
					return true;
				}
				//多字节检测
				loops = Math.min(maxWordLen, len - index - 1);
				for (var i:int = 1; i <= loops; i++)
				{
					//快速排除
					if ((fastCheck[source.charCodeAt(index + i)] & (1 << ((i > 7) ? 7 : i))) == 0)
					{
						break;
					}
					if (i + 1 >= minWordLen)
					{
						sub = source.substr(index, i + 1);
						if (hash.hasOwnProperty(sub))
						{
							return true;
						}
					}
				}
				++index;
			}
			return false;
		}

		/**
		 * 替换脏字
		 * @param source 源字符串
		 * @param replaceStr 替代字符
		 */
		public static function replaceDirtyWord(source:String, replaceStr:String = "*"):String
		{
			var $replaceStr:String = (replaceStr.length > 1) ? replaceStr.charAt(0) : replaceStr;
			var len:int = source.length;
			var loops:int;
			var sub:String;
			for (var index:int = 0; index < len; index++)
			{
				if ((fastCheck[source.charCodeAt(index)] & 1) == 0)
				{
					while (index < len - 1 && (fastCheck[source.charCodeAt(++index)] & 1) == 0)
					{
					}
				}
				//单字节检测
				if (minWordLen == 1 && charCheck[source.charCodeAt(index)])
				{
					source = source.replace(source.charAt(index), $replaceStr);
					continue;
				}
				//多字节检测
				loops = Math.min(maxWordLen, len - index - 1);
				for (var i:int = 1; i <= loops; i++)
				{
					//快速排除
					if ((fastCheck[source.charCodeAt(index + i)] & (1 << ((i > 7) ? 7 : i))) == 0)
					{
						break;
					}
					if (i + 1 >= minWordLen)
					{
						sub = source.substr(index, i + 1);
						if (hash.hasOwnProperty(sub))
						{
							source = source.replace(sub, StringUtil.padRight($replaceStr, i + 1, $replaceStr));
							//替换字符操作
							index += i;
							break;
						}
					}
				}
			}
			return source;
		}
	}
}
