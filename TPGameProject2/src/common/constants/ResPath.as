package common.constants
{
	import common.CustomConfig;

	import tpe.manager.FilePathManager;

	public class ResPath
	{
		/**
		 * 获取UI路径
		 * @param swfname
		 * @return
		 *
		 */
		public static function getUIPath(swfname:String):String
		{
			return FilePathManager.getPath("base/", swfname);
		}

		/**
		 * 获取初始化资源列表
		 * @return
		 */
		public static function getXMLListPath(locale:String):String
		{
			return FilePathManager.getPath("list_" + locale + ".xml");
		}

		/**
		 * 获取角色资源路径
		 * @param id
		 * @param statusType 角色行为类型
		 * @return
		 *
		 */
		public static function getCharacterPath(id:int, statusType:int = 0):String
		{
			return FilePathManager.getPath("model/character/" + id + ((statusType > 0) ? ("_" + statusType) : "") + ".swf");
		}

		/**
		 * 获取角色武器资源路径
		 * @param id
		 * @param state
		 * @return
		 *
		 */
		public static function getWeaponPath(id:int, state:int = 0):String
		{
			return FilePathManager.getPath("model/weapon/" + id + ((state > 0) ? ("_" + state) : "") + ".swf");
		}

		/**
		 * 获取角色坐骑资源路径
		 * @param id
		 * @return
		 *
		 */
		public static function getMountPath(id:int):String
		{
			return FilePathManager.getPath("model/mount/" + id + ".swf");
		}

	}
}
