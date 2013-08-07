package tempest.ui.components
{
	import com.adobe.utils.ArrayUtil;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

	import mx.core.EventPriority;
	import mx.filters.BaseFilter;

	import tempest.common.logging.*;
	import tempest.ui.DragManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.MouseOperatorLock;
	import tempest.ui.TPSprite;
	import tempest.ui.TToolTipManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.tips.TToolTip;
	import tempest.ui.events.*;
	import tempest.ui.interfaces.IAutoTopable;
	import tempest.ui.layouts.Layout;
	import tempest.utils.Fun;
	import tempest.utils.Geom;

	/**
	 * 组件基类
	 * @author wushangkun
	 */
	[Event(name = "resize", type = "flash.events.Event")]
	[Event(name = "stopRipping", type = "tempest.ui.events.TComponentEvent")]
	[Event(name = "startRipping", type = "tempest.ui.events.TComponentEvent")]
	[Event(name = "draw", type = "tempest.ui.events.TComponentEvent")]
	[Event(name = "show", type = "tempest.ui.events.TComponentEvent")]
	[Event(name = "hide", type = "tempest.ui.events.TComponentEvent")]
	[Event(name = "move", type = "tempest.ui.events.TComponentEvent")]
	[Event(name = "InvalidateComplete", type = "tempest.ui.events.TComponentEvent")]
	[Event(name = "showTip", type = "tempest.ui.events.TComponentEvent")]
	[Event(name = "dropDown", type = "tempest.ui.events.DragEvent")]
	[Event(name = "fetch", type = "tempest.ui.events.FetchEvent")]
	public class TComponent extends TPSprite implements ITInvalite, IAutoTopable
	{
		private static const log:ILogger = TLog.getLogger(TComponent);
		protected var _data:Object = null;
		protected var _rippingTimer:Timer = null;
		protected var _minWidth:Number = 0;
		protected var _minHeight:Number = 0;
		protected var _maxWidth:Number = 10000;
		protected var _maxHeight:Number = 10000;
		protected var _width:Number = 0; //宽
		protected var _height:Number = 0; //高
		protected var _constraints:Object;
		protected var _enabled:Boolean = true;
		protected var _proxy:* = null;
		protected var _toolTip:TToolTip;
		protected var _useDoubleClick:Boolean = false;
		protected var _layout:Layout;
		private var _fetchEnable:Boolean = false;
		public var eventEnabled:Boolean = true;
		private var _toolTipEnabled:Boolean = false; //是否启用ToolTip，（需要设置toolTip属性为基础）
		public var alwaysShowTip:Boolean = false; //在鼠标移动到控件上后，不论数据是否为null，始终显示tip（用于需要动态更新tip的场合）
		protected var _tipData:Object;
		private var _autoTopPriority:int = 0;
		/**
		 * 图片接收位置集合
		 */
		private var _dragAccpetPlaces:Array = null;

		/**
		 *
		 * @param constraints 约束
		 *  例如:{left: 0, right: 0, top: 0, bottom: 0, horizontalCenter: 0, verticalCenter: 0}
		 * @param _proxy
		 */
		public function TComponent(constraints:Object = null, proxy:* = null)
		{
			super();
			_constraints = constraints;
			if (!constraints)
				_constraints = {};
			_width = super.width;
			_height = super.height;
			this.proxy = proxy;
			this.signals.added.add(addedHandler);
			this.signals.removed.add(removedHandler);
			Fun.stopMC(this);
			init();
		}

		public function get constraints():Object
		{
			return _constraints;
		}

		public function set constraints(value:Object):void
		{
			_constraints = value;
			if (!constraints)
				_constraints = {};
			this.invalidateSize();
			this.invalidatePosition();
		}

		public override function set visible(value:Boolean):void
		{
			if (super.visible == value)
				return;
			super.visible = value;
			if (super.visible)
			{
				if (hasEventListener(TComponentEvent.SHOW))
				{
					this.dispatchEvent(new TComponentEvent(TComponentEvent.SHOW));
				}
			}
			else if (!super.visible)
			{
				if (hasEventListener(TComponentEvent.HIDE))
				{
					this.dispatchEvent(new TComponentEvent(TComponentEvent.HIDE));
				}
			}
//			this.dispatchEvent(new TComponentEvent((super.visible = value) ? TComponentEvent.SHOW : TComponentEvent.HIDE));
		}

		public function set proxy(value:*):void
		{
			if (value == null)
				return;
			if (value is String)
				value = getDefinitionByName(value);
			if (value is Class)
				value = new (value as Class)();
			if (value is BitmapData)
				value = new Bitmap((value as BitmapData).clone());
			if (!(value is DisplayObject))
				return;
			_proxy = value;
			if (_proxy == this)
			{
				if (_width == 0 && _height == 0)
				{
					_width = super.width;
					_height = super.height;
				}
				return;
			}
			//			super.name = _proxy.name;
			this.x = _proxy.x;
			this.y = _proxy.y;
			_proxy.x = 0;
			_proxy.y = 0;
			var _oldIndex:int = 0;
			var _oldParent:DisplayObjectContainer = _proxy.parent;
			if (_oldParent)
				_oldIndex = _proxy.parent.getChildIndex(_proxy);
			super.addChild(_proxy);
			if (_width == 0 && _height == 0)
			{
				super.width = _width = _proxy.width;
				super.height = _height = _proxy.height;
			}
			else
			{
				super.width = _proxy.width = _width;
				super.height = _proxy.height = _height;
			}
			this.visible = _proxy.visible;
			_proxy.visible = true;
			if (_oldParent)
				_oldParent.addChildAt(this, _oldIndex);
		}

		public function getProxy():*
		{
			return _proxy;
		}

		private function removedHandler(e:Event):void
		{
			//目标阶段处理销毁事件
			if (e.eventPhase == EventPhase.AT_TARGET)
			{
				if (hasEventListener(TComponentEvent.HIDE))
				{
					this.dispatchEvent(new TComponentEvent(TComponentEvent.HIDE));
				}
			}
		}

		private function addedHandler(e:Event):void
		{
			if (e.eventPhase == EventPhase.AT_TARGET)
			{
				if (this.parent != stage) //目标阶段处理布局事件
				{
					this.invalidateSize();
					this.invalidatePosition();
				}
				if (this.visible && hasEventListener(TComponentEvent.SHOW))
				{
					this.dispatchEvent(new TComponentEvent(TComponentEvent.SHOW));
				}
			}
			if (e.eventPhase == EventPhase.BUBBLING_PHASE)
			{
				if (_useDoubleClick) //冒泡阶段处理双击事件
					Fun.setDoubleClickEnable(e.target, _useDoubleClick);
			}
		}

		protected function init():void
		{
			addChildren();
			invalidate();
			if (hasEventListener(Event.INIT))
			{
				dispatchEvent(new Event(Event.INIT));
			}
		}

		protected function addChildren():void
		{
		}

		protected function invalidate():void
		{
			this.signals.enterFrame.addOnce(onInvalidate);
		}

		protected function onInvalidate(event:Event):void
		{
			invalidateNow();
		}

		public function invalidateNow():void
		{
			//			if(this is DisplayObjectContainer)
			//			{
			//				var container:DisplayObjectContainer = this as DisplayObjectContainer;
			//				for (var i:int = 0; i < container.numChildren; ++i)
			//				{
			//					var child:DisplayObject = container.getChildAt(i);
			//					if(child is TComponent)
			//					{
			//						(child as TComponent).invalidateNow();
			//					}
			//				}
			//			}
			draw();
			if (hasEventListener(TComponentEvent.INVALIDATE_COMPLETE))
			{
				dispatchEvent(new TComponentEvent(TComponentEvent.INVALIDATE_COMPLETE));
			}
		}

		protected function draw():void
		{
			if (hasEventListener(TComponentEvent.DRAW))
			{
				dispatchEvent(new TComponentEvent(TComponentEvent.DRAW));
			}
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			this.mouseEnabled = this.mouseChildren = _enabled = value;
		}

		public function get minWidth():Number
		{
			return _minWidth;
		}

		public function get minHeight():Number
		{
			return _minHeight;
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
//			var oldWidth:Number = _width;
//			var oldHeight:Number = _height;
//			if ((oldWidth != width || oldHeight != height) && hasEventListener(Event.RESIZE))
//				this.dispatchEvent(new Event(Event.RESIZE));
			if (_width != value)
			{
				_width = value;
				this.invalidateSize(true);
			}
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
//			var oldWidth:Number = _width;
//			var oldHeight:Number = _height;
//			if ((oldWidth != width || oldHeight != height) && hasEventListener(Event.RESIZE))
//				this.dispatchEvent(new Event(Event.RESIZE));
			if (_height != value)
			{
				_height = value;
				this.invalidateSize(true);
			}
		}

		public function setSize(w:Number, h:Number):void
		{
//			var oldWidth:Number = _width;
//			var oldHeight:Number = _height;
			if (_width != w || _height != h)
			{
				_width = w;
				_height = h;
				this.invalidateSize(true);
			}
//			if ((oldWidth != width || oldHeight != height) && hasEventListener(Event.RESIZE))
//				this.dispatchEvent(new Event(Event.RESIZE));
		}

		private function setSizeNotInvalidate(w:Number, h:Number):void
		{
//			var oldWidth:Number = _width;
//			var oldHeight:Number = _height;
			_width = w;
			_height = h;
		}

		public function invalidatePosition():void
		{
			if (parent)
			{
				var _xx:Number = x;
				var _yy:Number = y;
				if (!isNaN(_constraints.left))
					_xx = _constraints.left;
				else if (!isNaN(_constraints.right))
					_xx = parent.width - this.width - _constraints.right;
				if (!isNaN(_constraints.horizontalCenter))
					_xx = (parent.width - this.width) / 2 + _constraints.horizontalCenter;
				if (!isNaN(_constraints.top))
					_yy = _constraints.top;
				else if (!isNaN(_constraints.bottom))
					_yy = parent.height - this.height - _constraints.bottom;
				if (!isNaN(_constraints.verticalCenter))
					_yy = (parent.height - this.height) / 2 + _constraints.verticalCenter;
				x = _xx;
				y = _yy;
			}
		}

		public function invalidateDisplayList():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var _child:DisplayObject = this.getChildAt(i);
				if (_child is ITInvalite)
				{
					(_child as ITInvalite).invalidateSize();
					(_child as ITInvalite).invalidatePosition();
				}
			}
		}

		public function invalidateSize(changed:Boolean = false):void
		{
			var oldWidth:Number = _width;
			var oldHeight:Number = _height;
			if (parent)
			{
				if (!isNaN(_constraints.left) && !isNaN(_constraints.right))
					_width = parent.width - _constraints.left - _constraints.right;
				if (!isNaN(_constraints.top) && !isNaN(_constraints.bottom))
					_height = parent.height - _constraints.top - _constraints.bottom;
			}
			_width = Math.min(Math.max(_width, _minWidth), _maxWidth);
			_height = Math.min(Math.max(_height, _minHeight), _maxHeight);
			if (this is ITLayoutContainer)
				this.invalidateDisplayList();
			implementSize(_width, _height);
			if (oldWidth != width || oldHeight != height)
			{
				changed = true;
			}
			if (changed && hasEventListener(Event.RESIZE))
				this.dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * 将宽高应用到资源上（此操作将缩放资源）
		 * 包括资源上的子级控件
		 * 如不希望子级控件被缩放，可以将对应子级控件从资源上移除，加到this上
		 * @param width
		 * @param height
		 *
		 */
		protected function implementSize(width:Number, height:Number):void
		{
			if (_proxy)
			{
				if (_proxy == this)
				{
					if (super.width != width)
					{
						super.width = width;
					}
					if (super.height != height)
					{
						super.height = height;
					}
				}
				else
				{
					if (_proxy.width != width)
					{
						_proxy.width = width;
					}
					if (_proxy.height != height)
					{
						_proxy.height = height;
					}
				}
			}
		}

		public override function dispose():void
		{
			this.signals.removeAll();
			this.toolTipString = "";
			this.data = null;
			//			if (_proxy is Bitmap)
			//				(_proxy as Bitmap).bitmapData.dispose();
			//			//else if (_proxy is MovieClip)
			//			//{
			//			//(_proxy as MovieClip).stop();
			//			//}
			//			_proxy = null;
			//			//this.disposeDisplayList();
		}

		/**********************************Tip***********************************/
		public function get toolTipString():String
		{
			return _tipData as String;
		}

		public function set toolTipString(value:String):void
		{
			if (value && !this.toolTip)
			{
				this.toolTip = UIStyle.toolTip;
			}
			_tipData = value;
		}

		public function set htmlToolTipString(value:String):void
		{
			if (!this.toolTip)
			{
				this.toolTip = UIStyle.htmlToolTip;
			}
			_tipData = value;
		}

		public function get toolTip():TToolTip
		{
			return this._toolTip;
		}

		public function set toolTip(value:TToolTip):void
		{
			if (!_toolTipEnabled)
			{
				_toolTipEnabled = true;
			}
			if (this._toolTip == value)
			{
				return;
			}
			this._toolTip = value;
			if (this._toolTip)
			{
				//设为鼠标可响应
				this.mouseEnabled = true;
				if (this._toolTip.mouseFollow && !this.hasEventListener(MouseEvent.MOUSE_MOVE))
				{
					//跟随状态使用MouseMove
					this.removeEventListener(MouseEvent.ROLL_OVER, onShowTip);
					this.removeEventListener(MouseEvent.MOUSE_MOVE, onShowTip);
					this.addEventListener(MouseEvent.MOUSE_MOVE, onShowTip);
				}
				else
				{
					this.removeEventListener(MouseEvent.MOUSE_MOVE, onShowTip);
					this.removeEventListener(MouseEvent.ROLL_OVER, onShowTip);
					this.addEventListener(MouseEvent.ROLL_OVER, onShowTip);
				}
				this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
			else
			{
				//设置toolTip为null
				this.removeEventListener(MouseEvent.ROLL_OVER, onShowTip);
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onShowTip);
				this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
		}

		public function getTipData():Object
		{
			return _tipData;
		}

		public function setTipData(value:Object):void
		{
			_tipData = value;
		}

		private function onShowTip(event:MouseEvent):void
		{
			if (toolTipEnabled)
			{
				this.addEventListener(TComponentEvent.SHOW_TIP, onDefaultShowTip, false, EventPriority.DEFAULT_HANDLER);
				this.dispatchEvent(new TComponentEvent(TComponentEvent.SHOW_TIP, false, true)); //验证Tip显示
//				TToolTipManager.instance.showTip(_toolTip, this, null);
			}
		}

		private function onDefaultShowTip(event:TComponentEvent):void
		{
			this.removeEventListener(event.type, arguments.callee);
			if (event.isDefaultPrevented())
			{
				return;
			}
			TToolTipManager.instance.showTComponentTip(_toolTip, this);
		}

		private function onMouseOut(event:Event):void
		{
			TToolTipManager.instance.hideTip();
			if (hasEventListener(TComponentEvent.HIDE_TIP))
			{
				dispatchEvent(new TComponentEvent(TComponentEvent.HIDE_TIP));
			}
		}

//		public function set layout(value:Layout):void
//		{
//			if(_layout)
//			{
//				_layout.destory();
//			}
//			_layout = value;
//			//			_layout.setTarget(this);
//		}
//		public function get layout():Layout
//		{
//			return _layout;
//		}
		/**
		 * 获取/设置是否使用双击事件
		 * @return
		 */
		public function get useDoubleClick():Boolean
		{
			return _useDoubleClick;
		}

		public function set useDoubleClick(value:Boolean):void
		{
			if (_useDoubleClick != value)
			{
				_useDoubleClick = value;
				Fun.setDoubleClickEnable(this, value);
			}
		}

		[Bindable]
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if (_data == value)
			{
				return;
			}
			var oldData:Object = _data;
			_data = value;
			if (hasEventListener(DataChangeEvent.DATA_CHANGE))
				dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, oldData, _data));
		}

		/**
		 * 使用基类Sprite的宽高
		 *
		 */
		public function useRawSize(enableEvent:Boolean = false):void
		{
			var changed:Boolean = false;
			if (enableEvent)
			{
				if (this._width != this.$width || this._height != this.$height)
				{
					changed = true;
				}
			}
			this._width = this.$width;
			this._height = this.$height;
			if (changed)
			{
				if (hasEventListener(Event.RESIZE))
				{
					dispatchEvent(new Event(Event.RESIZE));
				}
			}
//			invalidateSize();
		}

		/**
		 * 设置控件是否可以为拖放响应区域
		 * 设置后，控件有物品拖入将发送DragDrop事件
		 * @param value
		 *
		 */
		public function set dragAccpetPlaces(value:Array):void
		{
			_dragAccpetPlaces = value;
			if (_dragAccpetPlaces && _dragAccpetPlaces.length > 0)
			{
				DragManager.dropable(this);
			}
			else
			{
				DragManager.unDropable(this);
			}
		}

		public function get dragAccpetPlaces():Array
		{
			return _dragAccpetPlaces;
		}

		/**
		 * 是否开启了拖放掉落
		 * @return
		 *
		 */
		public function get dragDropEnable():Boolean
		{
			return _dragAccpetPlaces && _dragAccpetPlaces.length != 0;
		}

		/**
		 * 设置是否可以被提取
		 * @param value
		 *
		 */
		public function set fetchEnable(value:Boolean):void
		{
			if (_fetchEnable == value)
				return;
			if (_fetchEnable)
				this.removeEventListener(MouseEvent.CLICK, onFetchClick);
			_fetchEnable = value;
			if (_fetchEnable)
				this.addEventListener(MouseEvent.CLICK, onFetchClick);
		}

		public function get fetchEnable():Boolean
		{
			return _fetchEnable;
		}

		/**
		 * 监听提取
		 * @param event
		 *
		 */
		private function onFetchClick(event:MouseEvent):void
		{
			FetchHelper.instance.processFetch(this);
		}

		/**
		 * 测量子级大小设置宽高
		 * @param proxyAsBackGround 是否将proxy作为背景（如果为true，则proxy将不被考虑到子级测量中，而是跟随总大小自动拉伸）
		 *
		 */
		public function measureChildren(proxyAsBackGround:Boolean = true, setSize:Boolean = true):Point
		{
			var width:Number = 0;
			var height:Number = 0;
			var bgNamedObjArray:Array = [];
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var obj:DisplayObject = this.getChildAt(i);
				if (_proxy && proxyAsBackGround && this.numChildren != 1) //proxy作为背景，不计算宽高
				{
					if (obj == _proxy)
					{
						continue;
					}
					else if (obj.name == "bg" || obj.name == "bg2")
					{
						bgNamedObjArray.push(obj);
						continue;
					}
				}
				width = Math.max(width, obj.x + obj.width);
				height = Math.max(height, obj.y + obj.height);
			}
			if (setSize)
			{
				if (this.width != width || this.height != height)
				{
					for each (var bgNamedObj:DisplayObject in bgNamedObjArray)
					{
						if (bgNamedObj && proxyAsBackGround && bgNamedObj != this)
						{
							bgNamedObj.width = width; //proxy作为背景，先设置宽高
							bgNamedObj.height = height;
						}
					}
					if (_proxy && proxyAsBackGround && _proxy != this)
					{
						_proxy.width = width;
						_proxy.height = height;
					}
					this._width = width;
					this._height = height;
					if (hasEventListener(Event.RESIZE))
					{
						dispatchEvent(new Event(Event.RESIZE));
					}
//					this.setSize(width,height);
				}
			}
			return new Point(width, height);
		}

		public function measureWidth(proxyAsBackGround:Boolean = true, setSize:Boolean = true):Number
		{
			var width:Number = 0;
			var bgNamedObjArray:Array = [];
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var obj:DisplayObject = this.getChildAt(i);
				if (_proxy && proxyAsBackGround && this.numChildren != 1) //proxy作为背景，不计算宽高
				{
					if (obj == _proxy)
					{
						continue;
					}
					else if (obj.name == "bg" || obj.name == "bg2")
					{
						bgNamedObjArray.push(obj);
						continue;
					}
				}
				width = Math.max(width, obj.x + obj.width);
			}
			if (setSize)
			{
				if (this.width != width)
				{
					for each (var bgNamedObj:DisplayObject in bgNamedObjArray)
					{
						if (bgNamedObj && proxyAsBackGround && bgNamedObj != this)
						{
							bgNamedObj.width = width; //proxy作为背景，先设置宽高
						}
					}
					if (_proxy && proxyAsBackGround && _proxy != this)
					{
						_proxy.width = width;
					}
					this._width = width;
					if (hasEventListener(Event.RESIZE))
					{
						dispatchEvent(new Event(Event.RESIZE));
					}
				}
			}
			return width;
		}

		/**
		 * 保持子控件相对位置不变，保证所有子控件坐标为正数，对应扩大宽高
		 *
		 */
		public function keepChildrenPositive(proxyAsBackGround:Boolean = true):void
		{
			//获取最小坐标
			var minX:Number = 0;
			var minY:Number = 0;
			for (var j:int = 0; j < this.numChildren; j++)
			{
				var obj2:DisplayObject = this.getChildAt(j);
				if (proxyAsBackGround && obj2 == _proxy)
				{
					continue;
				}
				minX = Math.min(minX, obj2.x);
				minY = Math.min(minY, obj2.y);
			}
			//如果最小坐标为负数，调整位置
			if (minX < 0 || minY < 0)
			{
				for (var k:int = 0; k < this.numChildren; k++)
				{
					var obj3:DisplayObject = this.getChildAt(k);
					if (proxyAsBackGround && obj3 == _proxy)
					{
						continue;
					}
					if (obj3 is TComponent)
					{
						var component:TComponent = obj3 as TComponent;
						component.eventEnabled = false;
						if (minX < 0)
							component.x -= minX;
						if (minY < 0)
							component.y -= minY;
						component.eventEnabled = true;
					}
					else
					{
						if (minX < 0)
							obj3.x -= minX;
						if (minY < 0)
							obj3.y -= minY;
					}
				}
			}
			//重新测量子级
			measureChildren(proxyAsBackGround);
		}

		/**
		 * 布局
		 * @param value
		 *
		 */
		public function set layout(value:Layout):void
		{
			if (_layout)
			{
				_layout.destory();
			}
			_layout = value;
			if (_layout)
			{
				_layout.setTarget(this);
			}
		}

		public function get layout():Layout
		{
			return _layout;
		}

		/**
		 * 单独设置Proxy宽高
		 * @param width
		 * @param height
		 *
		 */
		public function setProxySize(width:Number, height:Number, dispatch:Boolean = true):void
		{
			if (!_proxy)
			{
				return;
			}
			_proxy.width = width;
			_proxy.height = height;
			var changed:Boolean = false;
			if (_width < _proxy.width)
			{
				_width = _proxy.width;
				changed = true;
			}
			if (_height < _proxy.height)
			{
				_height = _proxy.height;
				changed = true;
			}
			if (changed && dispatch)
			{
				if (hasEventListener(Event.RESIZE))
				{
					dispatchEvent(new Event(Event.RESIZE));
				}
			}
		}

		override public function set x(value:Number):void
		{
			if (super.x != value)
			{
				super.x = value;
				if (hasEventListener(TComponentEvent.MOVE))
				{
					this.dispatchEvent(new TComponentEvent(TComponentEvent.MOVE));
				}
			}
		}

		override public function set y(value:Number):void
		{
			if (super.y != value)
			{
				super.y = value;
				if (hasEventListener(TComponentEvent.MOVE))
				{
					this.dispatchEvent(new TComponentEvent(TComponentEvent.MOVE));
				}
			}
		}

		public function move(x:Number, y:Number):void
		{
			if (super.x != x || super.y != y)
			{
				super.x = x;
				super.y = y;
				if (hasEventListener(TComponentEvent.MOVE))
				{
					this.dispatchEvent(new TComponentEvent(TComponentEvent.MOVE));
				}
			}
		}

		public function cleanAllChilren():void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
		}

		public function set toolTipEnabled(value:Boolean):void
		{
			_toolTipEnabled = value;
			if (_toolTipEnabled && !toolTip)
			{
				toolTip = UIStyle.toolTip;
			}
		}

		public function get toolTipEnabled():Boolean
		{
			return _toolTipEnabled;
		}

		override public function dispatchEvent(event:Event):Boolean
		{
			if (eventEnabled)
				return super.dispatchEvent(event);
			return false;
		}

		/**
		 * 鼠标是否在控件范围外
		 * @return
		 *
		 */
		protected function mouseOutside():Boolean
		{
			return this.mouseX <= 0 || this.mouseY <= 0 || this.mouseX >= this.width || this.mouseY >= this.height;
		}

		/**
		 * 添加滤镜
		 * @param filter
		 *
		 */
		public function setFilter(filter:Object):void
		{
			this.filters = [filter];
//			if(filters)
//			{
//				for (var i:int = 0; i < filters.length; i++)
//				{
//					if(filters[i] == filter)
//					{
//						return;
//					}
//				}
//			}
//			if(!filters)
//			{
//				filters = [filter];
//			}
//			else
//			{
//				var buf:Array = filters.slice();
//				buf.push(filter);
//				filters = buf;
//			}
		}

		/**
		 * 移除滤镜
		 * @param filter
		 *
		 */
		public function removeFilters():void
		{
			this.filters = null;
//			if(filters)
//			{
//				for (var i:int = 0; i < filters.length; i++)
//				{
//					if( filters[i] == filter)
//					{
//						var buf:Array = filters.slice();
//						buf.splice(i, 1);
//						filters	= buf;
//					}
//				}
//			}
		}

		public function get autoTopPriority():int
		{
			return _autoTopPriority;
		}

		public function set autoTopPriority(value:int):void
		{
			_autoTopPriority = value;
		}

		/**
		 * 控件上覆盖一层
		 *
		 */
		public function drawCover(color:uint, alpha:Number):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0, color, alpha);
			this.graphics.beginFill(color, alpha);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}

		/**
		 * 绘出控件的边框 (调试用)
		 *
		 */
		public static function drawBound2(sprite:Sprite, color:uint):void
		{
			sprite.graphics.clear();
			sprite.graphics.lineStyle(0, color);
			sprite.graphics.drawRect(0, 0, sprite.width, sprite.height);
		}

		/****************************************转换**************************************************/
		/**
		 * 开始转换
		 * @param timeOut 超时
		 */
		public function startRipping(timeOut:Number = 0):void
		{
			stopRipping(null);
			if (timeOut != 0)
			{
				_rippingTimer = new Timer(timeOut, 1);
				_rippingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopRipping, false, 0, true);
				_rippingTimer.start();
				if (hasEventListener(TComponentEvent.START_RIPPING))
				{
					dispatchEvent(new TComponentEvent(TComponentEvent.START_RIPPING));
				}
			}
		}

		/**
		 * 停止转换
		 * @param e
		 */
		public function stopRipping(e:Event):void
		{
			if (_rippingTimer)
			{
				_rippingTimer.stop();
				_rippingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopRipping);
				_rippingTimer = null;
				if (hasEventListener(TComponentEvent.STOP_RIPPING))
				{
					dispatchEvent(new TComponentEvent(TComponentEvent.STOP_RIPPING));
				}
			}
		}

		/**
		 * 是否正在转换中
		 * @return
		 *
		 */
		public function isRipping():Boolean
		{
			return _rippingTimer && _rippingTimer.running;
		}

		public function printScale():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var dispObj:DisplayObject = this.getChildAt(i);
				if (!dispObj)
					continue;
				if (dispObj.scaleX != 1)
					log.debug("typeof = " + typeof(dispObj) + " " + dispObj.name + ".scaleX = " + dispObj.scaleX);
				if (dispObj.scaleY != 1)
					log.debug("typeof = " + typeof(dispObj) + " " + dispObj.name + ".scaleY = " + dispObj.scaleY);
				var tcomponent:TComponent = dispObj as TComponent;
				if (tcomponent)
					tcomponent.printScale();
			}
		}

		/**
		 * 迭代查找父级界面中指定类型的界面
		 * 如果查找失败则返回null
		 * @param type
		 * @return
		 *
		 */
		public function getParentView(type:Class):DisplayObject
		{
			var parentView:DisplayObject = this.parent;
			while (parentView)
			{
				if (parentView is type)
				{
					break;
				}
				parentView = parentView.parent;
			}
			return parentView;
		}

		//DEBUG
		public function stopAllChildren():void
		{
			Fun.stopMC(this);
		}
	}
}
