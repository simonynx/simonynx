package tempest.ui.components
{
	import com.adobe.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IFactory;
	import mx.events.PropertyChangeEvent;
	
	import tempest.ui.UIConst;
	import tempest.ui.UIStyle;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.tips.TToolTip;
	import tempest.ui.core.IProxyFactory;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.DataChangeEvent;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.ListEvent;
	import tempest.ui.layouts.LayoutUtil;
	import tempest.ui.layouts.LinearLayout;

	[Event(name="select", type="flash.events.Event")]
	[Event(name="itemRenderCreate", type="tempest.ui.events.ListEvent")]
	public class TList extends TComponent
	{
		protected var _items:Array;
		protected var _itemHolder:TComponent;
		protected var _selectedIndex:int = -1;
		protected var _itemRenderClass:* = TListItemRender;
		protected var _listItemSkinClass:Class;
		protected var _scrollbar:TScrollBar;
		protected var _scrollBarProxy:*;
		private var _listItemHeight:Number = 0;
		private var _offset:int;
		private var _maximun:int;
		private var _useScorllBar:Boolean = true;
		private var _autoScroll:Boolean;
		private var _fixedHeight:Number = -1;				
		private var _fixedWidth:Number = -1;
		private var _columnCount:Number = 1;
		private var _needValidateMaximun:Boolean = false;	//是否需要计算高度
		private var _added:Boolean = false;
		private var _listItemWidth:Number;
		private var _collection:IList;
		private var _type:String = UIConst.VERTICAL;
		private var _verticalAlign:String = UIConst.TOP;
		private var _horizontalAlign:String = UIConst.LEFT;
		private var _horizontalGap:Number = 0;
		private var _verticalGap:Number = 0;
		private var _lineHeightFixed:Boolean = true;		//是否固定行高
		private var _maxlineNum:Number = 0;				//固定的行数（通过第一次给ItemRender赋值数据计算出来）
		protected var _resetItemData:Boolean = true;		//invalidate的时候，是否重新设置ItemRender的data
		private var _itemRenderBuff:Array = [];
		private var _selectable:Boolean = true;
		private var _autoAdjustSize:Boolean = false;		//设置是否自动改变列表项宽高，使其适应列表宽高（当前仅对自动大小的列表有效）
//		public var invalidateLayout:Boolean = true;
		private var _minItemWidth:Number = 0;				//最小宽度
		private var _minItemHeight:Number = 0;				//最小高度
		private var _invalidateSelectNow:Boolean = false;	//是否在设置选中时立刻更新选中（默认为否）
		public var scrollStep:Number = 3;					//鼠标滚动时的变化量
		/**
		 *
		 * @param _proxy	列表UI资源
		 * @param scrollBarProxy 滚动条资源，如果为null则使用默认滚动条
		 * @param listItemClass 用来实例化列表项内容的类
		 * @param items	列表项对应的数据集合
		 * @param useScorllBar 是否使用滚动条
		 */
		public function TList(constraints:Object = null, _proxy:* = null, scrollBarProxy:* = null, itemRenderClass:* = null, listItemSkinClass:* = null, items:Array = null, useScorllBar:Boolean = true)
		{
			if (items != null)
			{
				_items = items//.slice(); 
			}
			else
			{
				_items = [];
			}
			_scrollBarProxy = scrollBarProxy;
			_itemRenderClass = itemRenderClass;
			
			if (!_itemRenderClass)
			{
				_itemRenderClass = TListItemRender;
			}
			
			_listItemSkinClass = listItemSkinClass;
			
			_useScorllBar = useScorllBar;
			
			if (_proxy)
			{
				_fixedHeight = _proxy.height;
				_fixedWidth = _proxy.width;
			}
			else
			{
				_fixedHeight = -1;
				_fixedWidth = -1;
			}

			super(constraints, _proxy);
			_listItemWidth = this.width;
		}

		/**
		 * Initilizes the component.
		 */
		protected override function init():void
		{
			super.init();
			if (sizeFiexed())
			{
				addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				_needValidateMaximun = true;
				clipContent();
			}
//			this.invalidate();
			this.addEventListener("resize", onResize);
		}
		
		protected override function draw():void
		{
			super.draw();
			
			updateList();
			if(!_invalidateSelectNow)
			{
				updateSelect();
			}
			if (this._needValidateMaximun)
			{
				if(sizeFiexed())
				{
					updateScrollMaximun();
				}
				this._needValidateMaximun = false;
			}
			if (_added && this._autoScroll)
			{
				_added = false;
				this.offset = this.maximun;
			}
			
			
		}
		
//		override protected function invalidate():void
//		{
//			invalidateNow();
//		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren():void
		{
			super.addChildren();
			if(!sizeFiexed())
			{
				_useScorllBar = false;//可变高度时，不使用滚动条
			}
//			if (this._fixedHeight != -1)
//				this.height = this._fixedHeight;
//			else
//				_useScorllBar = false;
			_itemHolder = new TAutoSizeComponent();
			_itemHolder.graphics.drawRect(0, 0, _fixedWidth > 0 ? _fixedWidth : 0, _fixedHeight > 0 ? _fixedHeight : 0);
			this.addChild(_itemHolder);
			initScrollBar();
		}
		
		protected function initScrollBar():void			
		{
			if (_useScorllBar)
			{
				var autoPos:Boolean = true;
				if (!_scrollBarProxy)
				{
					_scrollBarProxy = new UIStyle.scrollBar();
				}
				else if (_scrollBarProxy is Class)
				{
					//程序设置位置
					_scrollBarProxy = new _scrollBarProxy();
				}
				else
				{
					//使用滑调本身位置
					autoPos = false;
				}
				
				_scrollbar = new TScrollBar(null, _scrollBarProxy, TScrollBar.VERTICAL, onScroll);
				_scrollbar.autoHide = true;
				if (autoPos)
				{
					_scrollbar.move(this.width - _scrollbar.width, 0);
				}
				_scrollbar.height = this.height; //- 8;
				_scrollbar.setSliderParams(0, 0, 0);
				if(autoPos)
				{
					this.addChild(_scrollbar);
				}
			}
		}

		protected function updateList():void
		{
			if (!sizeFiexed())
			{
				updateListAutoHeight();
			}
			else
			{
				updateListFixedHeight();
			}
		}
		
		private function removeNotUseRender(layoutedNum:int):void
		{
			while (layoutedNum < _itemHolder.numChildren)
			{
				_itemHolder.removeChildAt(_itemHolder.numChildren - 1);
			}
		}

		private function updateSelect():void
		{
			for (var i:int = 0; i < _itemHolder.numChildren; ++i)
			{
				var itemRender:TListItemRender = _itemHolder.getChildAt(i) as TListItemRender;
				itemRender.removeEventListener(Event.SELECT, onSelect);
				if(itemRender.index == _selectedIndex)
				{
					itemRender.selected = true;
				}
				else
				{
					itemRender.selected = false;
				}
				itemRender.addEventListener(Event.SELECT, onSelect);
			}
		}
		
		private function updateListAutoHeight():void
		{
			var oldSize:Point = new Point(width, height);
			//未指定高度，自动伸长
			var prev:DisplayObject;
			var i:int = 0;
			var item:TListItemRender;
			for (var j:int = 0; j < this._items.length; ++j)
			{
				item = createItem(j);
				item.visible = true;
				item.index = j;
				item.eventEnabled = false;//因为此时已经在布局中，避免设置data时item抛出resize事件再次触发父级布局，导致无限递归
				if(_resetItemData)
					item.data = this._items[j];
//				item.invalidateNow();
				resizeRender(item, _fixedWidth, _fixedHeight, _minItemWidth, _minItemHeight);//A
				layoutRender(item,prev,this,0,0,_fixedWidth);//B
				item.eventEnabled = true;
				prev = item;
			}
			
			removeNotUseRender(this._items.length);
//			if(_autoAdjustSize)
//			{
				_itemHolder.keepChildrenPositive();//展开列表
//			}
			this.removeEventListener(Event.RESIZE, onResize);
			measureChildren();
			this.addEventListener(Event.RESIZE, onResize);
			if(_autoAdjustSize)
			{
				adjustRenderSize(_fixedWidth, _fixedHeight);	//调整列表项，使之宽（高）等同于列表
			}			
		}
		
		/**
		 * 让列表采用最大宽度的列表项，并对宽度小的列表项应用该宽度
		 * 
		 */		
		public function setItemRenderWidth(newW:Number):void
		{
			for (var i:int = 0; i < _itemHolder.numChildren; ++i)
			{
				_itemHolder.getChildAt(i).width = newW;
			}
		}
		
		/**
		 * 检查列表项是否超出边界，应该结束布局 
		 * @param obj
		 * @return 
		 * 
		 */		
		private function checkOutOfBound(obj:DisplayObject):Boolean
		{
			switch(_type)
			{
				case UIConst.HORIZONTAL:
					if((_horizontalAlign == UIConst.LEFT && obj.x + obj.width >= this.width)
						|| (_horizontalAlign == UIConst.RIGHT && obj.x <= 0))
						return true;
					break;
				
				case UIConst.VERTICAL:
					if((_verticalAlign == UIConst.TOP && obj.y + obj.height >= this.height)
						|| (_verticalAlign == UIConst.BOTTOM && obj.y <= 0))
						return true;
					break;
				
				case UIConst.TILE:
					//横向达到边界（不超出）
					//&&
					//纵向达到边界
					if(((_horizontalAlign == UIConst.LEFT && (obj.x + obj.width == this.width || obj.x + obj.width * 2 + _horizontalGap > this.width))
						|| (_horizontalAlign == UIConst.RIGHT && (obj.x == 0 || obj.x - obj.width - _horizontalGap < 0)))
						&&
						((_verticalAlign == UIConst.TOP && obj.y + obj.height >= this.height)
						|| (_verticalAlign == UIConst.BOTTOM && obj.y <= 0)))
						return true;
					break;
			}
			
			return false;
		}

		/**
		 *
		 * @param x
		 * @param y
		 * @param w
		 * @param h
		 * @param xIndex
		 * @param yIndex
		 * @return 布局过的render数
		 *
		 */
		private function layOutItemRenders(x:Number, y:Number, w:Number, h:Number, xIndex:int = 0, yIndex:int = 0, reLayout:Boolean = false):int
		{
			var i:int = xIndex + yIndex * _columnCount;
			var j:int = 0; //布局对象索引
			//--------------------------------------------------
			var prev:DisplayObject;
			if(_items.length == 0)
			{
				return 0;
			}
			while (true)
			{
				var obj:TListItemRender = createItem(j);
				obj.visible = true;
				if(_resetItemData)
					obj.data = _items[i];
				obj.index = i;
				layoutRender(obj,prev,this,x,y,w);
				if(checkOutOfBound(obj))
				{
					return j + 1;
				}
				prev = obj;
				++j;
				++i;
				
				if (i > _items.length - 1)
				{
					if(maximun != 0 && offset == maximun && !reLayout/*重新排列时不进入*/)
					{
						//差半行，无法布局满
						var topObj:TListItemRender = createItem(j);
						if (_type == UIConst.HORIZONTAL)
						{
							var space:Number = this.width - (obj.x + obj.width); //计算超出长度
							return layOutItemRenders(x - topObj.width + space + _horizontalGap, y, w, h, xIndex - 1, yIndex, true); //回到前一行重新布局
						}
						else if (_type == UIConst.VERTICAL)
						{
							var space2:Number = this.height - (obj.y + obj.height); //计算超出长度
							return layOutItemRenders(x, y - topObj.height + space2 + _verticalGap, w, h, xIndex, yIndex - 1, true); //回到前一行重新布局
						}
						else if(_type == UIConst.TILE)
						{
							var space3:Number = this.height - (obj.y + obj.height); //计算超出长度
							return layOutItemRenders(x, y - topObj.height + space3 + _verticalGap, w, h, xIndex, yIndex - 1, true); //回到前一行重新布局
						}
						else
						{
							throw new Error("错误的_type ：" +　_type);
						}
					}
					return j;
				}
			}
			return j;
		}
		
		/**
		 * 调整列表项，使之宽（高）等同于列表 
		 * @param fixedWidth
		 * @param fixedHeight
		 * 
		 */		
		private function adjustRenderSize(fixedWidth:Number, fixedHeight:Number):void
		{
			if(_type == UIConst.TILE)
				return;
			
			for (var i:int = 0; i < _itemHolder.numChildren; i++)
			{
				var render:TListItemRender = _itemHolder.getChildAt(i) as TListItemRender;
				if(_type == UIConst.VERTICAL && fixedWidth <= 0)
				{
					if(render.width != this._itemHolder.width)
						render.width = this._itemHolder.width;
				}
				else if(_type == UIConst.HORIZONTAL && fixedHeight <= 0)
				{
					if(render.height != this._itemHolder.height)
						render.height = this._itemHolder.height;
				}
			}
		}
				
		/**
		 * 根据列表宽高调整 render宽高
		 * @param obj
		 * @param fixedWidth
		 * @param fixedHeight
		 * 
		 */		
		private function resizeRender(obj:TListItemRender, fixedWidth:Number, fixedHeight:Number, minWidth:Number, minHeight:Number):void
		{
			if (_type == UIConst.VERTICAL && fixedWidth > 0)
			{
				if(obj.width != fixedWidth)
				{
					obj.width = fixedWidth;
				}
			}
			else if (_type == UIConst.HORIZONTAL && fixedHeight > 0)
			{
				if(obj.height != fixedHeight)
				{
					obj.height = fixedHeight;
				}
			}
			
			//
			if(_type == UIConst.VERTICAL && minWidth > 0)
			{
				if(obj.width < minWidth)
				{
					obj.width = minWidth;
				}
			}
			else if(_type == UIConst.HORIZONTAL && minHeight > 0)
			{
				if(obj.height < minHeight)
				{
					obj.height = minHeight;
				}
			}
		}

		/**
		 * 
		 * @param obj
		 * @param prev
		 * @param x
		 * @param y
		 * @param w
		 * 
		 */		
		private function layoutRender(obj:TListItemRender, prev:DisplayObject, container:DisplayObjectContainer, x:Number, y:Number, w:Number):void
		{
			if (_type == UIConst.HORIZONTAL)
			{
				LayoutUtil.silder(obj, container, null, _verticalAlign);
				if (!prev)
					LayoutUtil.silder(obj, container, _horizontalAlign, null, x, y);
				else
					LayoutUtil.horizontal(obj, prev, container, _horizontalGap, _horizontalAlign);
			}
			else if (_type == UIConst.VERTICAL)
			{
				LayoutUtil.silder(obj, container, _horizontalAlign);
				if (!prev)
					LayoutUtil.silder(obj, container, null, _verticalAlign, x, y);
				else
					LayoutUtil.vertical(obj, prev, container, _verticalGap, _verticalAlign);
			}
			else if (_type == UIConst.TILE)
			{
				if (!prev)
				{
					LayoutUtil.silder(obj, container, _horizontalAlign, _verticalAlign, x, y);
				}
				else
				{
					LayoutUtil.horizontal(obj, prev, container, _horizontalGap, _horizontalAlign);
					if ((_horizontalAlign == UIConst.LEFT && obj.x + obj.width > x + w)
						|| (_horizontalAlign == UIConst.RIGHT && obj.x < 0)
						)
					{
						//超过一行，换行
						obj.y = _verticalAlign == UIConst.TOP ? prev.y + prev.height + _verticalGap : prev.y - obj.height - _verticalGap;
						obj.x = _horizontalAlign == UIConst.RIGHT ? x + w - obj.width : 0;
					}
					else
					{
						obj.y = prev.y;
					}
				}
			}
			else
			{
				throw new Error("错误的_type ：" +　_type);
			}
		}
		
		private function updateListFixedHeight():void
		{
			
			_offset = Math.min(_offset, Math.max(0, _items.length - 1));
			var layoutedNum:int = 0;
			if (_type == UIConst.HORIZONTAL)
			{
				layoutedNum = layOutItemRenders(0, 0, this.width, this.height, offset < 0 ? 0 : offset, 0);
			}
			else if (_type == UIConst.VERTICAL)
			{
				layoutedNum = layOutItemRenders(0, 0, this.width, this.height, 0, offset < 0 ? 0 : offset);
			}
			else if (_type == UIConst.TILE)
			{
				layoutedNum = layOutItemRenders(0, 0, this.width, this.height, 0, offset < 0 ? 0 : offset);
			}
			if (this._scrollbar)
			{
				this._scrollbar.pageSize = layoutedNum / this._columnCount;
			}
			
			removeNotUseRender(layoutedNum);
		}

		private function hideAllItem():void
		{
//			for (var i:int = 0; i < _itemHolder.numChildren; ++i)
//			{
//				(_itemHolder.getChildAt(i) as TListItemRender).visible = false;
//				
//			}
			while(_itemHolder.numChildren > 0)
			{
				_itemRenderBuff.push(_itemHolder.getChildAt(_itemHolder.numChildren - 1));//移除的ItemRender放入缓存
				_itemHolder.removeChildAt(_itemHolder.numChildren - 1);
			}
		}

		protected function updateScrollMaximun():void
		{
			this.maximun = getMaximum(0, 0, this.width, this.height);
			if (this.offset > this.maximun)
			{
				this.offset = this.maximun;
			}
		}

		/**
		 * 从下往上统计高度, 计算最多可翻页数
		 * @return
		 *
		 */
		private function getMaximum(x:Number, y:Number, w:Number, h:Number):int
		{
			var prev:DisplayObject;
			var i:int = _items.length - 1;
			var j:int = 0;
			if(_lineHeightFixed)
			{
				if(i < 0)
					return 0;
				//固定行高模式下
				var maxLineNum:Number = getMaxLineNum();
				
				var ret:Number = Math.ceil(_items.length / _columnCount) - maxLineNum;
				if(ret < 0)
					ret = 0;
				return ret;
			}
			while (true)
			{
				if (i < 0)
				{
					//无法填满
					return 0;
				}
				var obj:TListItemRender = createItem(j);
				obj.data = _items[i];
				
				layoutRender(obj,prev,this,x,y,w);
				if(_type == UIConst.HORIZONTAL)
				{
					if (obj.x + obj.width == this.width) //布局达到边界
					{
						return i;
					}
					else if (obj.x + obj.width > this.width) //布局超过边界
					{
						return i + 1;
					}
				}
				else if(_type == UIConst.VERTICAL)
				{
					if (obj.y + obj.height == this.height)
					{
						return i;
					}
					else if (obj.y + obj.height > this.height)
					{
						return i + 1;
					}
				}
				else if(_type == UIConst.TILE)
				{
					if (obj.x + obj.width >= this.width)
					{
						if (obj.y + obj.height == this.height)
						{
							return j / _columnCount;
						}
						else if (obj.y + obj.height > this.height)
						{
							return j / _columnCount + 1;
						}
					}
				}
				
				prev = obj;
				++j;
				--i;
			}
			return 0;
		}
		
		/**
		 * 获取最大可显示行数（固定高模式下） 
		 * @return 
		 * 
		 */		
		private function getMaxLineNum():Number
		{
			if(_items.length == 0)
			{
				return 0;
			}
			var ret:Number;
			var _lineHeight:Number;
			if(_lineHeightFixed && _maxlineNum == 0)
			{
				if (_type == UIConst.HORIZONTAL)
				{
					_lineHeight = createItem(0, true).width;
					ret = Math.floor(this.width / (_lineHeight + horizontalGap));
				}
				else if (_type == UIConst.VERTICAL)
				{
					_lineHeight = createItem(0, true).height;
					ret = Math.floor(this.height / (_lineHeight + verticalGap));
				}
				else if(_type == UIConst.TILE)
				{
					_lineHeight = createItem(0, true).height;
					ret = Math.floor(this.height / (_lineHeight + verticalGap));
				}
			}
			return ret;
		}

		/**
		 * 获取一个item显示对象，如果超出界限则创建新的添加并返回
		 * @param index
		 * @return
		 *
		 */
		private function createItem(index:int, visible:Boolean = false):TListItemRender
		{
			var item:TListItemRender = null;
			if (index < this._itemHolder.numChildren)
			{
				item = this._itemHolder.getChildAt(index) as TListItemRender;
			}
			else if(_itemRenderBuff.length > 0)	//从缓存中取出ItemRender
			{
				item = _itemRenderBuff.pop();
			}
			else
			{
				if(_itemRenderClass is IFactory)
				{
					if(_itemRenderClass is IProxyFactory)
					{
						IProxyFactory(_itemRenderClass).proxy = _listItemSkinClass;
					}
					item = IFactory(_itemRenderClass).newInstance();
				}
				else
				{
					item = new _itemRenderClass(_listItemSkinClass, null);
				}
				item.addEventListener(Event.SELECT, onSelect);
				item.addEventListener("unSelect", onUnSelect);
				item.selectable = _selectable;
				
				dispatchEvent(new ListEvent(ListEvent.ITEM_RENDER_CREATE, item));
				
				
			}
			item.visible = visible;
			
			if(!item.parent)
			{
				_itemHolder.addChild(item);
			}
			return item;
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////
		/**
		 * Adds an item to the list.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 */
		public function addItem(item:Object):void
		{
			_items.push(item);
			if (_autoScroll)
			{
				this.offset = this.maximun;
			}
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			invalidate();
			dispatchEvent(new ListEvent(ListEvent.ADD, item));
		}

		/**
		 * Adds an item to the list at the specified index.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 * @param index The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			index = Math.max(0, index);
			index = Math.min(_items.length, index);
			_items.splice(index, 0, item);
			this._added = true;
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			invalidate();
			dispatchEvent(new ListEvent(ListEvent.ADD, item));
		}

		public function setItemAt(item:Object, index:int):void
		{
			if (index < 0 || index > _items.length - 1)
			{
				throw new Error("TList outOfBounds: " + index.toString());
			}
			var itemRender:TListItemRender = getItemRender(index);
			if (itemRender)
			{
				itemRender.data = item;
				_items[index] = item;
			}
		}

		/**
		 * 遍历当前的ItemRender，查找索引对应的ItemRender 
		 * @param data
		 * @return 
		 * 
		 */	
		public function getItemRender(index:int):TListItemRender
		{
			if(index >= _itemHolder.numChildren)
			{
				return null;
			}
			for (var i:int = 0; i < _itemHolder.numChildren; ++i)
			{
				var render:TListItemRender = _itemHolder.getChildAt(i) as TListItemRender;
				if (render.index == index)
				{
					return render;
				}
			}
			return null;
		}
		
		/**
		 * 遍历当前的ItemRender，查找数据对应的ItemRender 
		 * @param data
		 * @return 
		 * 
		 */		
		public function getItemRenderByData(data:Object):TListItemRender
		{
			for (var i:int = 0; i < _itemHolder.numChildren ; ++i)
			{
				var render:TListItemRender = _itemHolder.getChildAt(i) as TListItemRender;
				if (render.data == data)
				{
					return render;
				}
			}
			return null;
		}

		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
		 */
		public function removeItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
			removeItemAt(index);
		}

		/**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.
		 */
		public function removeItemAt(index:int):void
		{
			if (index < 0 || index >= _items.length)
				return;
			var deledArr:Array = _items.splice(index, 1);
//			updateScrollMaximun();
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			dispatchEvent(new ListEvent(ListEvent.REMOVE, deledArr[0]));
			invalidate();
			//updateList();
//			updateScrollBar();
//			fillItems();
		}

		/**
		 * Removes all items from the list.
		 */
		public function removeAll():void
		{
			_items.length = 0;
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			invalidate();
		}

		public function setToBottom():void
		{
			this.offset = this.maximun;
			invalidate();
		}

		private function clipContent():void
		{
			if(sizeFiexed())
				this.scrollRect = new Rectangle(0, 0, this.width + 2, this.height + 2);	
			else
				this.scrollRect = null;
		}
		
		private function sizeFiexed():Boolean
		{
			return (_fixedHeight > 0 && _type == UIConst.VERTICAL) 
				|| (_fixedWidth > 0 && _type == UIConst.HORIZONTAL)
				|| (_fixedHeight > 0 && _type == UIConst.TILE);
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		/**
		 * Called when a user selects an item in the list.
		 */
		protected function onSelect(event:Event):void
		{
			if (!(event.currentTarget is TListItemRender))
				return;
			
			var curOffset:int = offset;
			if(_itemHolder.numChildren + curOffset > _items.length)//当前超过末尾状态下，offset - 1
			{
				--curOffset;
			}
			
			for (var i:int = 0; i < _itemHolder.numChildren; i++)
			{
				var itemRender:TListItemRender = TListItemRender(_itemHolder.getChildAt(i));
				itemRender.removeEventListener(Event.SELECT, onSelect);
				if (_itemHolder.getChildAt(i) == event.currentTarget)
				{
					_selectedIndex = i + curOffset;
					itemRender.selected = true;
				}
				else
				{
					itemRender.selected = false;
				}
				itemRender.addEventListener(Event.SELECT, onSelect);
				
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		
		protected function onUnSelect(event:Event):void
		{
			selectedIndex = -1;
		}

		/**
		 * Called when the mouse wheel is scrolled over the component.
		 */
		protected function onMouseWheel(event:MouseEvent):void
		{
			offset -= event.delta * scrollStep / 3;
		}

		/**
		 * Called when the user scrolls the scroll bar.
		 */
		protected function onScroll(event:Event):void
		{
			this._offset = Math.max(0, _scrollbar.value);
			this._offset = Math.min(this._offset, this.maximun);
			this.invalidate();
		}

		protected function onResize(event:Event):void
		{
			if(_fixedHeight > 0)
				updateScrollMaximun();
			updateList();
			clipContent();
		}

		protected function collectionChangeHandler(event:CollectionEvent):void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
					this.addItemAt(event.items[0], event.location);
					break;
//				case CollectionEventKind.MOVE:
//					
//					break;
//				
				case CollectionEventKind.REFRESH:
					this.items = _collection ? _collection.toArray() : null;
					break;
				case CollectionEventKind.REMOVE:
					this.removeItemAt(event.location);
					break;
				case CollectionEventKind.REPLACE:
					this.setItemAt((event.items[0] as PropertyChangeEvent).newValue, event.location);
					break;
				case CollectionEventKind.RESET:
					this.items = _collection ? _collection.toArray() : null;
					break;
				case CollectionEventKind.UPDATE:
					if(event.location >= 0)
					{
						this._items[event.location] = (event.items[0] as PropertyChangeEvent).target;
					}
					break;
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
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
			this.selectedIndex = -1;
			for (var i:int = 0; i < _itemHolder.numChildren; i++)
			{
				var element:TListItemRender = TListItemRender(_itemHolder[i]);
				element.selectable = false;
			}
		}
		
//		private var __selectedIndex:int = -1;
//		
//		private function get _selectedIndex():int
//		{
//			return __selectedIndex;
//		}
//		
//		private function set _selectedIndex(value:int):void
//		{
//			__selectedIndex = value;
//		}
		
		/**
		 * Sets / gets the index of the selected list item.
		 */
		public function set selectedIndex(value:int):void
		{
			if (value >= 0 && value < _items.length)
			{
				_selectedIndex = value;
			}
			else
			{
				_selectedIndex = -1;
			}
			if(_invalidateSelectNow)
			{
				updateSelect();
			}
			else
			{
				this.invalidate();
			}
			dispatchEvent(new Event(Event.SELECT));
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
			selectedIndex = index;
		}

		public function get selectedItem():Object
		{
			if (_selectedIndex >= 0 && _selectedIndex < _items.length)
			{
				return _items[_selectedIndex];
			}
			return null;
		}

		/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value:Array):void
		{
			if(_items == value)
			{
				return;
			}
			if(!value)
			{
				value = [];
			}
			_items = value;//.slice(); 
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			this.invalidate();
		}

		public function get items():Array
		{
			return _items;
		}

		/**
		 * Sets / gets the class used to render list items. Must extend ListItem.
		 */
		public function set listItemClass(value:Class):void
		{
			_itemRenderClass = value;
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			this.invalidate();
		}

		public function get listItemClass():Class
		{
			return _itemRenderClass;
		}

		public function set offset(value:int):void
		{
			if (_scrollbar)
			{
				_scrollbar.value = value;
				this._offset = _scrollbar.value;
			}
			else
			{
				this._offset = Math.max(0, value);
				this._offset = Math.min(this._offset, this.maximun);
			}
			this.invalidate();
		}

		public function get offset():int
		{
			return this._offset;
		}

		protected function set maximun(value:int):void
		{
			if (_scrollbar)
			{
				this._scrollbar.maximum = value;
				
					if (this._scrollbar.maximum == 0)
					{
//						this._scrollbar.visible = false;
						_listItemWidth = this.width;
					}
					else
					{
//						this._scrollbar.visible = true;
						_listItemWidth = this.width - _scrollbar.width;
					}
					
				this._maximun = this._scrollbar.maximum;
			}
			else
			{
				this._maximun = value;
			}
		}

		protected function get maximun():int
		{
			return this._maximun;
		}

		public function set autoScroll(value:Boolean):void
		{
			this._autoScroll = value;
		}

		public function get autoScroll():Boolean
		{
			return this._autoScroll;
		}

		public function set siliderTip(value:TToolTip):void
		{
			_scrollbar.siliderTip = value;
		}

		public function get siliderTip():TToolTip
		{
			return _scrollbar.siliderTip;
		}

		public function set siliderTipString(value:String):void
		{
			_scrollbar.siliderTipString = value;
		}

		public function get columnCount():Number
		{
			return _columnCount;
		}

		public function set columnCount(value:Number):void
		{
			_columnCount = value;
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			this.invalidate();
		}

		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign(value:String):void
		{
			_verticalAlign = value;
			this.invalidate();
		}

		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		public function set horizontalAlign(value:String):void
		{
			_horizontalAlign = value;
			this.invalidate();
		}

		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}

		public function set horizontalGap(value:Number):void
		{
			_horizontalGap = value;
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			this.invalidate();
		}

		public function get verticalGap():Number
		{
			return _verticalGap;
		}

		public function set verticalGap(value:Number):void
		{
			_verticalGap = value;
			if(sizeFiexed())
			{
				this._needValidateMaximun = true;
			}
			this.invalidate();
		}
		
		public function set fixedHeight(value:Number):void
		{
			_fixedHeight = value;
			if(_proxy)
			{
				_proxy.height = value;
			}
			else
			{
				var listproxy:Sprite = new Sprite();
				listproxy.graphics.drawRect(0, 0, _fixedWidth, _fixedHeight);
				proxy = listproxy;
			}
			
			invalidate();
			clipContent();
		}
		
		public function set fixedWidth(value:Number):void
		{
			_fixedWidth = value;
			
			if(_proxy)
			{
				_proxy.width = value;
			}
			else
			{
				var listproxy:Sprite = new Sprite();
				listproxy.graphics.drawRect(0, 0, _fixedWidth, _fixedHeight);
				proxy = listproxy;
			}
			
			invalidate();
			clipContent();
		}
		
		/**
		 * 最小宽度 
		 * @param value
		 * 
		 */		
		public function set minItemWidth(value:Number):void
		{
			_minItemWidth = value;
			invalidate();
		}
		
		/**
		 * 最小高度 
		 * @param value
		 * 
		 */		
		public function set minItemHeight(value:Number):void
		{
			_minItemHeight = value;
			invalidate();
		}

		public function set autoHideScorllBar(value:Boolean):void
		{
			_scrollbar.autoHide = value;
		}

		public function get autoHideScorllBar():Boolean
		{
			return _scrollbar.autoHide;
		}
		
		public function set type(value:String):void
		{
			_type = value;
			invalidate();
		}
		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 是否在设置选中时立刻更新选中（默认为否） 
		 * @param value
		 * 
		 */		
		public function set invalidateSelectNow(value:Boolean):void
		{
			_invalidateSelectNow = value;
		}
		
		public function get invalidateSelectNow():Boolean
		{
			return _invalidateSelectNow;
		}

		/**
		 * 设置数据源 
		 * @param value
		 * 
		 */		
		public function set dataProvider(value:IList):void
		{
			if (_collection)
			{
				_collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			_collection = value;
			this.items = _collection ? _collection.toArray() : [];
			if (_collection)
			{
				_collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
		}

		public function get dataProvider():IList
		{
			return _collection;
		}
		
		/**
		 * 设置是否固定行高 
		 * @param value
		 * 
		 */		
		public function set lineHeightFixed(value:Boolean):void
		{
			_lineHeightFixed = value;
		}
		
		public function get lineHeightFixed():Boolean
		{
			return _lineHeightFixed;
		}
		
		/**
		 * 设置是否自动改变列表项宽高，使其适应列表宽高（当前仅对自动大小的列表有效） 
		 * @param value
		 * 
		 */		
		public function set autoAdjustSize(value:Boolean):void
		{
			_autoAdjustSize = value;
		}
		
		///////////////////////////////////
		// 额外附加控制按钮
		///////////////////////////////////
		public function AddScrollUpButton(bt:TButton):void
		{
			bt.addEventListener(MouseEvent.CLICK, onScorllUp);
		}

		private function onScorllUp(event:Event):void
		{
			this.offset -= 1;
		}

		public function AddScrollDownButton(bt:TButton):void
		{
			bt.addEventListener(MouseEvent.CLICK, onScorllDown);
		}

		private function onScorllDown(event:Event):void
		{
			this.offset += 1
		}

		public function AddScrollBottomButton(bt:TButton):void
		{
			bt.addEventListener(MouseEvent.CLICK, onScorllBotton);
		}

		private function onScorllBotton(event:Event):void
		{
			this.setToBottom();
		}
	}
}