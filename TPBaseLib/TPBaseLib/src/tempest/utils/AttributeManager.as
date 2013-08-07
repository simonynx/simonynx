package tempest.utils
{
	import com.adobe.utils.StringUtil;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import tempest.common.staticdata.Access;

	/**
	 * 属性管理器
	 * @author
	 */
	public final class AttributeManager
	{
		private static const attributes:Dictionary = new Dictionary();

		/**
		 * 注册类型
		 * @param type 要注册的类型
		 * @return
		 */
		public static function registerType(type:*, replace:Object = null):Object
		{
			var typeName:String = getQualifiedClassName(type);
			var m_attributes:Object = {};
			var list:XMLList = (type is Class) ? describeType(type).factory.* : describeType(type).*;
			//trace(list);
			//解析可写变量
			for each (var item:XML in list)
			{
				var name:String = item.name().toString();
				switch (name)
				{
					case "variable":
						var l1:XMLList = item.metadata;
						for each (var i1:XML in l1)
						{
							if (i1.@name == "Attribute")
							{
								var l2:XMLList = i1.arg;
								for each (var i2:XML in l2)
								{
									if (i2.@key == "index")
									{
										var va:Array = i2.@value.split("+");
										var vi:int = 0;
										for each (var v:String in va)
										{
											v = v.replace(" ", "");
											if (replace && replace[v])
												vi += int(replace[v]);
											else
												vi += int(v);
										}
										m_attributes[vi] = item.@name.toString();
										break;
									}
								}
								break;
							}
						}
						break;
					case "accessor":
						var access:String = item.@access;
						if (access == "writeonly" || access == "readwrite")
						{
							var ll1:XMLList = item.metadata;
							for each (var ii1:XML in ll1)
							{
								if (ii1.@name == "Attribute")
								{
									var ll2:XMLList = ii1.arg;
									for each (var ii2:XML in ll2)
									{
										if (ii2.@key == "index")
										{
											var va2:Array = ii2.@value.split("+");
											var vi2:int = 0;
											for each (var v2:String in va2)
											{
												v2 = v2.replace(" ", "");
												if (replace && replace[v2])
													vi2 += int(replace[v2]);
												else
													vi2 += int(v2);
											}
											m_attributes[vi2] = item.@name.toString();
											break;
										}
									}
									break;
								}
							}
						}
						break;
				}
			}
			attributes[typeName] = m_attributes;
			return m_attributes;
		}

		/**
		 * 更新对象
		 * @param	obj 要更新的对象
		 * @param	index 属性索引
		 * @param	value 要更新的值
		 */
		public static function update(obj:*, index:int, value:*, replace:Object = null):void
		{
			if (obj)
			{
				var atts:* = attributes[getQualifiedClassName(obj)];
				if (atts == null)
					atts = registerType(obj, replace);
				if (atts && atts[index])
				{
					obj[atts[index]] = value;
				}
			}
		}

		/**
		 * 获得对象属性对应的属性索引值
		 * @param objClass 类名
		 * @param attrName 属性名
		 * @return 索引值
		 *
		 */
		public static function getAttrIndex(objClass:Class, attrName:String, replace:Object = null):*
		{
			var attrList:* = getAttrList(objClass, replace);
			for (var i:String in attrList)
			{
				if (attrList[i] == attrName)
				{
					return i;
				}
			}
		}

		public static function getAttrList(objClass:Class, replace:Object = null):*
		{
			var atts:* = attributes[getQualifiedClassName(objClass)];
			if (atts == null)
				atts = registerType(objClass, replace);
			return atts;
		}

		/**
		 * 获取属性描述字符串
		 * @param obj
		 */
		public static function getAttString(obj:Object):String
		{
			var attributes:Object = Fun.getProperties(obj, Access.READ_ONLY | Access.READ_WRITE);
			var result:String = "";
			for (var att:String in attributes)
			{
				result += att + ":" + obj[att] + " ";
			}
			return result;
		}
	}
}
