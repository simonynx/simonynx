package fj1.common.res
{
	import fj1.common.GameInstance;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import tempest.ui.collections.TArrayCollection;
	import tempest.utils.XMLAnalyser;

	/**
	 * 配置解析辅助类
	 * @author linxun
	 *
	 */
	public class ResManagerHelper
	{
		/**
		 * 解析为Dictionary格式的配置项集合
		 * @param clss 配置项类型
		 * @param data 未解析的配置数据
		 * @param saveProperty 配置项中用来作为字典key的属性
		 * @return
		 *
		 */
		public static function getDictionary(clss:Class, data:*, saveProperty:String = "id"):Dictionary
		{
			var xml:XML = GameInstance.decoder.toXML(data);
			if (xml == null)
			{
				return null;
			}
			var dic:Dictionary = new Dictionary();
			var arr:Array = XMLAnalyser.getParseList(xml, clss);
			var item:* = null;
			for each (item in arr)
			{
				dic[item[saveProperty]] = item;
			}
			return dic;
		}

		/**
		 * 解析为Array格式的配置项集合
		 * @param clss 配置项类型
		 * @param data 未解析的配置数据
		 * @param saveProperty 如果为null，将获得序列数组，反之则获得关联数组，关联数组的key值为配置项的saveProperty对应值
		 * @return
		 *
		 */
		public static function getArray(clss:Class, data:*, saveProperty:String = null):Array
		{
			var xml:XML = GameInstance.decoder.toXML(data);
			if (xml == null)
			{
				return null;
			}
			var arr:Array = XMLAnalyser.getParseList(xml, clss);
			if (!saveProperty)
			{
				return arr;
			}
			else
			{
				var list:Array = [];
				var item:* = null;
				for each (item in arr)
				{
					list[item[saveProperty]] = item;
				}
				return list;
			}
		}

		/**
		 *返回XMLList
		 * @param data
		 * @return
		 *
		 */
		public static function getXmlList(data:*):XMLList
		{
			var xml:XML = GameInstance.decoder.toXML(data);
			if (xml == null)
			{
				return null;
			}
			return xml.* as XMLList;
		}

		/**
		 *配置文件解码成String
		 * @param data
		 * @return
		 *
		 */
		public static function getString(data:*):String
		{
			return GameInstance.decoder.toString(data);
		}

		/**
		 *配置文件解码成XML
		 * @param data
		 * @return
		 *
		 */
		public static function decodeData(data:*):*
		{
			return GameInstance.decoder.toXML(data);
		}
	}
}
