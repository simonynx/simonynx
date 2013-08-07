package fj1.common.vo.element
{
	import fj1.common.GameInstance;
	import flash.display.Bitmap;
	import tempest.engine.BaseElement;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.animation.AnimationType;

	/**
	 *动态元素对象
	 * @author zhangyong
	 *
	 */
	public class TDynamicElement extends BaseElement
	{
		public function TDynamicElement(type:int, aniID:int)
		{
			super(type, GameInstance.scene);
			var _shadow:Bitmap = new shadow() as Bitmap;
			_shadow.x = -_shadow.width / 2;
			_shadow.y = -_shadow.height / 2;
			this._mainLayer.addChildAt(_shadow, 0);
			displayId = aniID;
		}
		/**
		 *
		 * @default
		 */
		public var ani:Animation;

		/**
		 *设置显示对象
		 * @param value
		 *
		 */
		private function set displayId(value:int):void
		{
			if (value != -1)
			{
				ani = Animation.createAnimation(value);
				ani.move(pixel_x, pixel_y);
				ani.type = AnimationType.Loop;
				this._mainLayer.addChild(ani);
			}
		}

		/**
		 *清除显示对象
		 *
		 */
		public override function dispose():void
		{
			super.dispose();
			if (ani)
			{
				Animation.disposeAnimation(ani);
			}
		}
	}
}
