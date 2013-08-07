package tempest.engine.vo.config
{

	public class SceneConfig
	{
		public static const ZONE_PRE_X:int = 1; //切片水平预加载
		public static const ZONE_PRE_Y:int = 1; //切片垂直预加载
		public static const ZONE_WIDTH:int = 200; //切片宽度
		public static const ZONE_HEIGHT:int = 200; //切片高度
		public static const ZONE_LOAD_DELAY:Number = 20; //切片加载间隔
		public static const ZONE_LOADER_NUM:int = 2; //切片加载器个数
		public static const TILE_WIDTH:int = 48; //网格宽度
		public static const TILE_HEIGHT:int = 24; //网格高度
		public static const MAP_UPDATE_DELAY:int = 500; //切片检测时间间隔
		public static const AVATARPART_LOAD_DELAY:int = 100; //AvatarPart加载间隔
		public static const AVATARPART_LOADER_NUM:int = 2; //AvatarPart加载器个数
		public static const ANIMATION_LOAD_DELAY:int = 100; //AvatarPart加载间隔
		public static const ANIMATION_LOADER_NUM:int = 2; //AvatarPart加载器个数
		/////////////////////////////////////////////////////////////////////////////////
	}
}
