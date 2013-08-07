package tempest.engine.graphics.layer
{
	import flash.display.Sprite;
	import tempest.core.IDisposable;
	import tempest.utils.Fun;
	import tempest.engine.TScene;

	public class SmallMapLayer extends Sprite implements IDisposable
	{
		public var scene:TScene;

		public function SmallMapLayer(scene:TScene)
		{
			super();
			this.scene = scene;
			this.tabEnabled = this.tabChildren = this.mouseChildren = this.mouseEnabled = false;
		}

		public function dispose():void
		{
			Fun.removeAllChildren(this, true, true, true);
		}
	}
}
