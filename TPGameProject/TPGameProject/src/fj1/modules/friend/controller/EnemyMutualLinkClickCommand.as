package fj1.modules.friend.controller
{
	import fj1.common.staticdata.ChatConst;
	import fj1.modules.scene.util.MainCharWalkManager;
	import flash.geom.Point;
	import tempest.common.mvc.base.Command;

	public class EnemyMutualLinkClickCommand extends Command
	{
		public override function getHandle():Function
		{
			return this.onMutualChannelLink;
		}

		/**
		 * 交互频道链接处理，寻路到仇人处
		 * @param type
		 * @param params
		 *
		 */
		private function onMutualChannelLink(type:String, params:String):void
		{
			if (type != ChatConst.MUTUAL_TYPE_ENEMY)
			{
				return;
			}
			var paramArray:Array = params.split(",");
			var mapId:int = parseInt(paramArray[0]);
			var posX:int = parseInt(paramArray[1]);
			var posY:int = parseInt(paramArray[2]);
			MainCharWalkManager.heroWalk([mapId, new Point(posX, posY), 0]);
		}
	}
}
