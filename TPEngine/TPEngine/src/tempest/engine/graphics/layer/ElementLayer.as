package tempest.engine.graphics.layer
{
	import com.adobe.utils.ArrayUtil;

	import flash.display.Sprite;

	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.engine.TScene;
	import tempest.utils.Fun;

	/**
	 * 容器层
	 * @author wushangkun
	 */
	public class ElementLayer extends Sprite
	{
		public static const SORT_DELAY:int = 200;
		private var _scene:TScene;

		public function ElementLayer(scene:TScene)
		{
			super();
			_scene = scene;
			this.tabEnabled = this.tabChildren = this.mouseEnabled = this.mouseChildren = false;
		}

		public function run(diff:uint):void
		{
//			var element:BaseElement;
//			var _elements:Array = _scene.elements;
//			var dx:int;
//			var dy:int;
//			var mx:int = _scene.mainChar.tile_x;
//			var my:int = _scene.mainChar.tile_y;
//			for each (element in _elements)
//			{
//				dx = mx - element.x;
//				dy = my - element.y;
//				element.distance = dx * dx + dy * dy;
//				if (element.inSight())
//				{
//				}
//				else
//				{
//				}
//			}
//			if (_waitToAddList.length != 0)
//			{
//				addNext(_waitToAddList.pop());
//			}
			//排序
			this.sortDepth(diff);
			//////////////////////////////执行avatar///////////////////////////////////////////
			var sc:SceneCharacter = null;
			var characters:Array = _scene.charList;
			for each (sc in characters)
			{
				//执行Avatar
				sc.runAvatar(diff);
				sc.updateAvatar();
				sc.checkShading();
			}
		}
		private var timeOffset:int = 0;

		public function sortDepth(diff:uint):void
		{
			timeOffset += diff;
			if (timeOffset < SORT_DELAY)
			{
				return;
			}
			timeOffset = 0;
			//排序
			var elements:Array = this._scene.elements;
			elements.sortOn(["pixel_y", "id", "priority", "distance"], [Array.NUMERIC, Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
			var element:BaseElement;
//			for (var i:int = 0; i != elements.length; i++)
//			{
//				element = elements[i];
//				if (this.contains(element) && this.getChildIndex(element) != i)
//					this.setChildIndex(element, Math.min(i, this.numChildren - 1));
//			}
//			if (this.contains(element) && this.getChildIndex(element) != i)
//				this.setChildIndex(element, Math.min(i, this.numChildren - 1));
			var preIndex:int = -1;
			var currentIndex:int = 0;
			for (var i:int = 0; i != elements.length; i++)
			{
				element = elements[i];
				if (!this.contains(element))
				{
					continue;
				}
				if (preIndex == -1)
				{
					preIndex = this.getChildIndex(element);
					continue;
				}
				currentIndex = this.getChildIndex(element);
				if (currentIndex < preIndex)
				{
					this.setChildIndex(element, Math.min(preIndex + 1, this.numChildren - 1));
					continue;
				}
				preIndex = currentIndex;
			}
		}

//		private function addNext(element:BaseElement):void
//		{
//			element.added = true;
//			element.checkShading();
//			this.addChild(element);
//		}
//		private var _waitToAddList:Array = [];
		public function addElement(element:BaseElement):void
		{
			element.added = true;
			element.checkShading();
			this.addChild(element);
		}

		public function removeElement(element:BaseElement):void
		{
			if (element.added)
			{
				element.added = false;
				this.removeChild(element);
				return;
			}
//			ArrayUtil.removeValueFromArray(_waitToAddList, element);
		}

		public function dispose():void
		{
//			_waitToAddList = [];
			Fun.removeAllChildren(this, true, true, true);
		}
	}
}
