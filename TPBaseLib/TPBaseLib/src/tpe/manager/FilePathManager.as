package tpe.manager
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.BinaryItem;
	import flash.utils.ByteArray;
	import tempest.common.logging.*;
	import tempest.utils.StringUtil;

	public class FilePathManager
	{
		private static var _inited:Boolean = false;
		private static var _host:String = "";
		private static var _revFix:int = 0;
		private static var revisions:Object = {};
		private static var _types:Object = {};
		private static const log:ILogger = TLog.getLogger(FilePathManager);

		/**
		 *
		 * @param host 根目录
		 * @param types 替换后缀 用逗号个|标识   例如 txt|tps,swf|tpk
		 */
		public static function register(host:String = "", types:String = ""):void
		{
			_host = host;
			if (_host.length != 0 && _host.lastIndexOf("/") != _host.length - 1)
				_host += "/";
			_types = {};
			//解析types
			StringUtil.trimArrayElements(types.toLocaleLowerCase().replace(/，/g, ","), ",").split(",").forEach(function(item:String, index:int, arr:Array):void
			{
				if (item.length > 0)
				{
					var temp:Array = item.split("|");
					if (temp.length != 2)
					{
						log.error("types is error");
					}
					else
					{
						_types[temp[0]] = temp[1];
						BulkLoader.registerNewType(temp[1], temp[1], BinaryItem); //注册加载类型
					}
				}
			});
		}

		/**
		 * 初始化版本信息
		 * @param revision 版本信息为Svn导出
		 * @param checkRev 比对版本信息是否一致
		 * @param revFix 版本修正
		 */
		public static function initRevision(revision:String = "", checkRev:int = 0, revFix:int = 0):void
		{
			_revFix = revFix;
			var list:Array = revision.split("\r\n");
			var len:int = list.length;
			if (len < 1)
			{
				log.warn("Revision File is Empty");
				return;
			}
			var v:String = list.shift();
			if (v != checkRev.toString())
			{
				log.warn("RevCheck Faild v:{0} res_ver:{1}", v, checkRev);
			}
			var temp:Array;
			list.forEach(function(item:String, index:int, arr:Array):void
			{
				temp = item.split(" ");
				if (temp.length != 2)
				{
					log.warn("异常版本信息条目---" + item);
				}
				else
				{
					revisions[temp[1].toLocaleLowerCase()] = parseInt(temp[0]);
				}
			});
		}

		/**
		 *
		 * @param url 用于获取版本号的地址
		 * @param file 默认为空 如果不为空 则文件以目录版本为准
		 * @return
		 */
		public static function getPath(url:String, file:String = ""):String
		{
			url = url.toLocaleLowerCase();
			var str:String;
			if (file == "")
			{
				str = _host + replaceExtension(url);
				if (!(revisions[url] == undefined))
				{
					str += ("?v=" + (int(revisions[url]) + _revFix));
				}
			}
			else
			{
				str = _host + url + "/" + replaceExtension(file) + getRevision(url);
			}
			return str;
		}

		public static function getRevision(file:String):String
		{
			var v:String = revisions[file];
			return (v == null) ? "" : "?v=" + (int(v) + _revFix);
		}

		private static function replaceExtension(file:String):String
		{
			var index:int = file.lastIndexOf(".");
			if (index != -1)
			{
				var type:String = file.substring(index + 1);
				if (!(_types[type] == undefined))
				{
					file = file.substring(0, index + 1) + _types[type];
				}
			}
			return file;
		}
	}
}
