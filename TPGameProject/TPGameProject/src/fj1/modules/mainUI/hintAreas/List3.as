package fj1.modules.mainUI.hintAreas
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.utils.Dictionary;
	import tempest.common.pool.Pool;
	import tempest.core.IPoolClient;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TListItemRender;

	public class List3 extends TComponent
	{
		private var _renderList:Array;
		private var _renderPool:Pool;
		private var _renderClass:Class;
		private var _renderProxy:*;
		private static const SHOW_SPAN:Number = 0.5;
		private static const HOLD_SPAN:Number = 2;
		private static const HIDE_SPAN:Number = 1;
		public var max_lenth:int = 0;

//		private var _itemsCache:Array;//列表项添加后的缓冲容器，按照一定的时间间隔添加
		public function List3(constraints:Object, width:Number, renderClass:Class, renderProxy:*, max_lenth:int = 0)
		{
			var shape:Shape = new Shape();
			shape.graphics.drawRect(0, 0, width, 10);
			this.max_lenth = max_lenth;
			super(constraints, shape);
			_renderClass = renderClass;
			_renderProxy = renderProxy;
			_renderPool = new Pool();
			_renderList = [];
//			_itemsCache = [];
		}

		public function get renderList():Array
		{
			return _renderList;
		}
		private var _moveTweens:Dictionary = new Dictionary();

		/**
		 *
		 * @param value
		 *
		 */
		public function push(value:Object):void
		{
			if (max_lenth != 0)
			{
				while (_renderList.length > max_lenth)
				{
					removeRender(_renderList[0]);
				}
			}
			var newRender:TListItemRender = addRender();
			var delay:Number = HOLD_SPAN;
			newRender.data = value;
			newRender.y = -newRender.height;
			newRender.alpha = 0;
			if (newRender.data.hintConfig.hasOwnProperty("delay"))
			{
				if (newRender.data.hintConfig.delay > 0)
				{
					delay = newRender.data.hintConfig.delay;
				}
			}
			GTweener.to(newRender, SHOW_SPAN, {alpha: 1}).nextTween =
				new GTween(newRender, HIDE_SPAN, {alpha: 0}, {delay: delay, onComplete: function(gTween:GTween):void
				{
					removeRender(newRender);
				}});
			//调整其他项的当前位置
			for (var i:int = 0; i < _renderList.length; ++i)
			{
				var render:DisplayObject = _renderList[i];
				render.y = -render.height * (i + 1);
				GTweener.to(render, SHOW_SPAN, {y: -render.height * (i + 2)});
			}
		}

		private function addRender():TListItemRender
		{
			var newRender:TListItemRender = TListItemRender(_renderPool.createObj(_renderClass, _renderProxy));
			_renderList.splice(0, 0, newRender);
			this.addChild(newRender);
			return newRender;
		}

		private function removeRender(render:TListItemRender):void
		{
			_renderList.splice(_renderList.indexOf(render), 1);
			_renderPool.disposeObj(IPoolClient(render));
			if (render.parent)
			{
				this.removeChild(render);
			}
		}
	}
}
