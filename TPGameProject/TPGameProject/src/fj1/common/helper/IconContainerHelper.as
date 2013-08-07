package fj1.common.helper
{
	import com.gskinner.motion.GTweener;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;

	import tempest.TPEngine;
	import tempest.ui.TPUGlobals;
	import tempest.ui.components.TComponent;

	public class IconContainerHelper extends TComponent
	{
		private var _obj:DisplayObject;
		public var objArr:Array = [];
		public static const NAME:String = "MessageContatiner";

		public function IconContainerHelper(constraints:Object = null)
		{
			var shape:Shape = new Shape();
			shape.graphics.drawRect(0, 0, 1, 1);
			super(constraints, shape);
			this.width = TPUGlobals.app.width;
			this.name = NAME;
			TPUGlobals.app.addEventListener(Event.RESIZE, changeSize);
		}

		public function changeSize(event:Event):void
		{
			this.x = (TPUGlobals.app.width - this.width) / 2;
		}

		public function get obj():DisplayObject
		{
			return _obj;
		}

		public function setChild(obj:DisplayObject):void
		{
			objArr.push(obj);
			_obj = obj;
			this.addChild(obj);
			obj.x = this.width - obj.width;
			setIconPos();
			measureChildren();
		}

		public function setIconPos():void
		{
			var arr:Array = getIconPos(objArr.length);
			for (var i:int = 0; i < objArr.length; i++)
			{
				GTweener.to(objArr[i], 2, {x: arr[i]});
			}
		}

		public function getIconPos(num:int):Array
		{
			var _width:int = _obj.width + 10 * num - 10;
			var _pos:int = (this.width - _width) / 2;
			var arr:Array = [];
			for (var i:int = 0; i < num; i++)
			{
				arr.push(_pos + (_obj.width * i) + 10);
			}
			return arr;
		}

		public function delArr(mc:DisplayObject):void
		{
			for (var i:int = 0; i < objArr.length; i++)
			{
				if (objArr[i] == mc)
				{
					objArr.splice(i, 1);
				}
			}

		}
	}
}
