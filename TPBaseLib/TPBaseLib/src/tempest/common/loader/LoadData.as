package tempest.common.loader
{
	
	/**
	 * 加载数据
	 * @author wushangkun
	 */
	public class LoadData
	{
		public var url:String = "";
		public var name:String = "";
		public var key:String = "";
		public var priority:int = 0;
		public var target:String = "same";
		public var onComplete:Function;
		public var onProgress:Function;
		public var onError:Function;
		public var decode:Function;
		public var userData:Object;
		/**
		 * 加载数据
		 * @param url 加载地址
		 * @param onComplete 完成回调
		 * @param onProgress 加载进度回调
		 * @param onError 错误回调
		 * @param name 资源名
		 * @param key 键
		 * @param target 目标
		 * @param priority 优先级
		 * @param decode 解密回调
		 */
		public function LoadData(url:String = "",onComplete:Function = null,onProgress:Function = null,onError:Function = null,name:String = "",key:String = "",target:String = "same",priority:int = 0,decode:Function = null)
		{
			this.url = url;
			this.name = name;
			this.key = key;
			this.priority = priority;
			this.target = target;
			this.onComplete = onComplete;
			this.onProgress = onProgress;
			this.onError = onError;
			this.decode = decode;
		}
	}
}