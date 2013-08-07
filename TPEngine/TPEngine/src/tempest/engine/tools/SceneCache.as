package tempest.engine.tools
{
	import flash.utils.Dictionary;
	import tempest.engine.graphics.avatar.vo.AvatarPartSource;
	import tempest.engine.tools.astar.IMapModel;

	public class SceneCache
	{
//		public static var mapModel:IMapModel;
//		public static var mapTiles:Object = {};
		public static var transports:Object = {};
		public static var avatarPartCache:Dictionary = new Dictionary();
		public static var AnimationSourceCache:Object = {};

		public static function optimize():void
		{
			//优化avatarPartCache
			var aps:AvatarPartSource;
			for each (aps in avatarPartCache)
			{
				if (aps.refNum <= 0)
				{
					avatarPartCache[aps.key] = null;
					delete avatarPartCache[aps.key];
					aps.dispose();
				}
			}
		}
	}
}
