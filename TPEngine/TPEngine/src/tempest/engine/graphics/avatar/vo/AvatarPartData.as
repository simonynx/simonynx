package tempest.engine.graphics.avatar.vo
{

	public class AvatarPartData
	{
		private var _type:int;
		private var _path:String;
		public var priority:int = 0;

		/**
		 *角色部件配置
		 * @param type   部件类型
		 * @param path   部件资源路径
		 * @param isCache  部件资源是否缓存
		 *
		 */
		public function AvatarPartData(type:int, path:String, priority:int = 0)
		{
			this._type = type;
			this._path = path;
			this.priority = priority;
		}

		public function get type():int
		{
			return _type;
		}

		public function get path():String
		{
			return _path;
		}

		public function equals(toCompare:AvatarPartData):Boolean
		{
			if (toCompare == null)
			{
				return false;
			}
			return this._type == toCompare._type && this._path == toCompare._path;
		}
	}
}
