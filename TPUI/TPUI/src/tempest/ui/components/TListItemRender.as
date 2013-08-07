package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.core.ITListItemRender;
	import tempest.utils.Fun;

	public class TListItemRender extends TComponent implements ITListItemRender
	{
		public var bg:DisplayObject; //效果背景
		public var bg2:DisplayObject; //背景
		//----------------------------------------------------
		protected var _bkMovieClip:MovieClip;
		protected var _selected:Boolean;
		protected var _index:int;
		private var _autoSwitchBk:Boolean = true; //是否自动切换底图
		protected var _selectable:Boolean = true;
		/**
		 * 在列表项中需用此类代替 BindingUtils，避免重复绑定
		 */
		protected var _changeWatcherManger:ChangeWatcherManager = new ChangeWatcherManager();

		public function TListItemRender(proxy:* = null, data:Object = null)
		{
			super(null, proxy);
			if (_proxy)
			{
				Fun.stopMC(proxy);
				if (!_bkMovieClip)
				{
					if (_proxy.hasOwnProperty("bg"))
					{
						_bkMovieClip = _proxy.bg as MovieClip;
						if (_bkMovieClip)
						{
							_bkMovieClip.mouseEnabled = _bkMovieClip.mouseChildren = false;
						}
					}
					else
					{
						_bkMovieClip = _proxy as MovieClip;
					}
				}
			}
			if (_bkMovieClip)
			{
				_bkMovieClip.gotoAndStop(1);
			}
			this._data = data;
		}

		/**
		 * 设置是否在鼠标移动到列表项上时，自动切换背景
		 * @param value
		 *
		 */
		protected function set autoSwitchBk(value:Boolean):void
		{
			_autoSwitchBk = value;
			if (!_bkMovieClip)
			{
				return;
			}
			if (!_autoSwitchBk && _bkMovieClip.currentFrame != 1)
			{
				_bkMovieClip.gotoAndStop(1);
			}
			if (_autoSwitchBk && _selected)
			{
				_bkMovieClip.gotoAndStop(3);
			}
		}

		protected function get autoSwitchBk():Boolean
		{
			return _autoSwitchBk;
		}

		/**
		 * 是否可以选中
		 * @return
		 *
		 */
		public function get selectable():Boolean
		{
			return _selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_selectable = value;
		}

		/**
		 * Initilizes the component.
		 */
		protected override function init():void
		{
			super.init();
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		protected function onMouseOver(event:MouseEvent):void
		{
			if (!_autoSwitchBk)
				return;
			if (!_selected && _bkMovieClip)
			{
				_bkMovieClip.gotoAndStop(2);
			}
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			if (!_autoSwitchBk)
				return;
			if (!_selected && _bkMovieClip)
			{
				_bkMovieClip.gotoAndStop(1);
			}
		}

		protected function onClick(event:MouseEvent):void
		{
			if (!_selectable)
				return;
			if (!_selected)
			{
				dispatchEvent(new Event(Event.SELECT));
//				selected = true;
			}
		}

		public function setSelect():void
		{
			if (!_selectable)
				return;
			if (!_selected)
			{
				dispatchEvent(new Event(Event.SELECT));
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function set selected(value:Boolean):void
		{
			if (_selected == value)
			{
				return;
			}
			_selected = value;
			changeSelectedEffect(_selected);
//			if (_selected)
//			{
//				dispatchEvent(new Event(Event.SELECT));
//			}
		}

		/**
		 * 用于设置列表项的选中效果
		 * 如果需要设置选中，不能直接设置该值，需设置列表的selectedIndex或selectedItem属性
		 * 覆盖该函数自定义选中效果
		 * @param value
		 *
		 */
		protected function changeSelectedEffect(selected:Boolean):void
		{
			if (!_bkMovieClip || !_autoSwitchBk)
			{
				return;
			}
			if (selected)
			{
				_bkMovieClip.gotoAndStop(3);
			}
			else
			{
				_bkMovieClip.gotoAndStop(1);
			}
		}

		public function unSelect():void
		{
			dispatchEvent(new Event("unSelect"));
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		override public function set data(value:Object):void
		{
//			if(super.data != value)
//			{
//				changeWatcherManger.unWatchAll();
//			}
			super.data = value;
		}

		/**
		 * 获得ItemRender子级对象,对应的ItemRender的Index
		 * @param child
		 * @return
		 *
		 */
		public static function getParentRenderIndex(child:DisplayObject):int
		{
			return getParentRender(child).index;
		}

		/**
		 * 获得ItemRender子级对象,对应的ItemRender
		 * @param child
		 * @return
		 *
		 */
		public static function getParentRender(child:DisplayObject):TListItemRender
		{
			var nowParent:DisplayObject = child;
			while (!(nowParent is TListItemRender))
			{
				nowParent = nowParent.parent;
			}
			return nowParent as TListItemRender;
		}
	}
}
