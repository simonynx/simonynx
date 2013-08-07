package tempest.ui.layouts
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import tempest.ui.components.TComponent;

	public class Layout
	{
		private var _target:DisplayObjectContainer;

		private var _targetProxy:DisplayObjectContainer;
		/**
		 * 是否在子对象发生变化的时候重新布局，否则就只在添加和删除对象的时候布局
		 */
		public var autoLayout:Boolean = true;

		/**
		 * 是否以舞台的边框作为范围
		 */
		public var isRoot:Boolean;

		/**
		 * 是否根据子对象的大小来确认容器的大小
		 */
		public var enabledMeasureChildren:Boolean = true;

		/**
		 * 是否延迟调用
		 */
		public var delayCall:Boolean = true;

		/**
		 *
		 * @param target	容器
		 * @param isRoot	是否以舞台的边框作为范围
		 *
		 */
		public function Layout(target:DisplayObjectContainer = null, isRoot:Boolean = false)
		{
			if (target)
				setTarget(target, isRoot);
		}

		/**
		 * 设置容器
		 * @param value
		 *
		 */
		public function setTarget(value:DisplayObjectContainer, isRoot:Boolean = false):void
		{
			if (_target)
			{
				for (var i:int; i < _targetProxy.numChildren; ++i)
				{
					_targetProxy.getChildAt(i).removeEventListener(Event.RESIZE, childResizeHandler);
				}
			}

			_target = value;

			if (_target)
			{
				if (_target is TComponent)
				{
					//如果是TComponent取proxy为布局容器
					var tComTarget:TComponent = _target as TComponent;
					if (tComTarget.getProxy())
					{
						_targetProxy = tComTarget.getProxy();
					}
				}

				for (var j:int; j < _targetProxy.numChildren; ++j)
				{
					_targetProxy.getChildAt(j).addEventListener(Event.RESIZE, childResizeHandler);
				}
			}

		}

		/**
		 * 更新布局
		 *
		 */
		public function vaildLayout():void
		{
			if (!_target)
				return;

			var rect:Rectangle;
			if (isRoot)
			{
				var stage:Stage = _target.stage;
				rect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}
			else
			{
				rect = _target.getRect(_target);
			}

			layoutChildren(rect.x, rect.y, rect.width, rect.height);

			if (enabledMeasureChildren)
				measureChildren();
		}

		/**
		 * 销毁
		 *
		 */
		public function destory():void
		{
			setTarget(null);
		}

		/**
		 * 在下一次更新布局
		 *
		 */
		public function invalidateLayout():void
		{
			if (delayCall)
				_target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			else
				vaildLayout();
		}

		/**
		 * 根据Children决定自身体积，重写时需要重新指定width,height
		 *
		 */
		protected function measureChildren(proxyAsBackGround:Boolean = true, setSize:Boolean = true):Point
		{
			if (_target is TComponent)
			{
				return (_target as TComponent).measureChildren(proxyAsBackGround, setSize);
			}
			return new Point(_target.width, _target.height);
		}

		/**
		 * 对Chilren布局
		 *
		 * @param x
		 * @param y
		 * @param w
		 * @param h
		 *
		 */
		protected function layoutChildren(x:Number, y:Number, w:Number, h:Number):void
		{
		}

		private function childResizeHandler(event:Event):void
		{
			if (autoLayout)
				invalidateLayout();
		}

		private function onEnterFrame(event:Event):void
		{
			_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

			vaildLayout();
		}

		/**
		 * 容器
		 * @return
		 *
		 */
		public function get target():DisplayObjectContainer
		{
			return _target;
		}

		public function get targetProxy():DisplayObjectContainer
		{
			return _targetProxy;
		}
	}
}
