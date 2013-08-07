package fj1.common.res
{
	import fj1.common.config.CustomConfig;
	import tpe.manager.FilePathManager;

	public class ResPaths extends FilePathManager
	{
		/**
		 * 获取UI路径
		 * @param swfname
		 * @return
		 *
		 */
		public static function getUIPath(swfname:String):String
		{
			return FilePathManager.getPath("base", swfname);
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
		public static function getWeaponPath(id:int, statusType:int = 0):String
		{
			return FilePathManager.getPath("model/weapon/" + id + ((statusType > 0) ? ("_" + statusType) : "") + ".swf");
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

		public static function get loginBgPath():String
		{
			return FilePathManager.getPath("images/background/loginBG.jpg");
		}

		/**
		 * 获取头像路径
		 * @param id
		 * @return
		 */
		public static function getHeadPath(id:int):String
		{
			return FilePathManager.getPath("images/head/" + id + ".jpg");
		}

		/**
		 * 获取创角形象路径
		 * @param id
		 * @return
		 */
		public static function getRoleFigurePath(id:int):String
		{
			return FilePathManager.getPath("images/figure/" + id + ".swf");
		}

		/**
		 * 获取创角形象路径
		 * @param id
		 * @return
		 */
		public static function getRoleFigurePath2(id:int):String
		{
			return FilePathManager.getPath("images/figure/1" + id + ".swf");
		}

		/**
		 * 获取翅膀模型路径
		 * @param id
		 * @param state
		 * @return
		 *
		 */
		public static function getWingPath(id:int, statusType:int = 0):String
		{
			return FilePathManager.getPath("model/flyer/" + id + ((statusType > 0) ? ("_" + statusType) : "") + ".swf");
		}

		/**
		 * 获取图标路径
		 * @param id
		 * @param iconSizeType
		 * @return
		 */
		public static function getIconPath(id:int, iconSizeType:int = 36):String
		{
			return getPath("images/icon/" + iconSizeType + "/" + id + ".jpg");
		}
		
		/**
		 * 获取窗口资源
		 * @param name
		 * @return
		 *
		 */
		public static function getWindowPath(name:String):String
		{
			return getPath("base/window/" + name + ".swf");
		}
	}
}
