package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import mx.events.PropertyChangeEvent;
	
	import tempest.ui.UIConst;
	import tempest.ui.UIStyle;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.layouts.LayoutUtil;

	public class TList2 extends TComponent
	{
		protected var _items:Array;
		protected var _itemHolder:Sprite;
		protected var _selectedIndex:int = -1;
		protected var _scrollbar:TScrollBar;
		protected var _scrollBarProxy:*;
		protected var _useScorllBar:Boolean = true;
		protected var _autoSize:Boolean = false;
		protected var _renderPool:RenderPool;
		protected var _placeHolderList:Array;
		protected var _maximun:Number = 0;
		protected var _offset:Number = 0;
		protected var _verticalGap:Number = 0;
		protected var _horizontalGap:Number = 0;
		protected var _verticalAlign:String;
		protected var _horizontalAlign:String;
		protected var _type:String;
		protected var _lineSize:int;
		protected var _autoScroll:Boolean = false;
		protected var _scrollBarAutoPos:Boolean;
		protected var _scrollBarPosType:String;
		private var _collection:IList;
		
		//invalidate状态参数
		private var _indexChanged:Boolean = false;//索引变化
		private var _selectChanged:Boolean = false;//选中变化
		private var _renderToDisposeArray:Array = [];//需要释放的Render列表
		private var _scrollToEnd:Boolean = false;//滚动到末尾
		
		public function TList2(constraints:Object = null, proxy:* = null, scrollBarProxy:* = null, itemRenderClass:* = null, listItemSkinClass:* = null, items:Array = null, useScorllBar:Boolean = true)
		{
			_type = UIConst.VERTICAL;
			_verticalAlign = UIConst.TOP;
			_horizontalAlign = UIConst.LEFT;
			if (!itemRenderClass)
			{
				itemRenderClass = TListItemRender;
			}
			_useScorllBar = useScorllBar;
			_scrollBarPosType = UIConst.RIGHT;
			_scrollBarProxy = scrollBarProxy;
			_renderPool = new RenderPool(itemRenderClass, listItemSkinClass, this, onRenderSelect);
			_itemHolder = new Sprite();
			_placeHolderList = [];
			if (!proxy)
			{
				proxy = new Sprite();
				proxy.graphics.drawRect(0, 0, 1, 1);
			}
			super(constraints, proxy);
			this.addChild(_itemHolder);
			initScrollBar();
			scrollLineSize = 1;
			this.scrollRect = new Rectangle(0, 0, width, height);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			this.items = items;
		}
		

		override protected function draw():void
		{
			super.draw();
			updateMaximun();
			disposeRender();
			reflashRender();
		}
		
		private function initScrollBar():void
		{
			if(_useScorllBar)
			{
				_scrollBarAutoPos = true;
				if (!_scrollBarProxy)
				{
					_scrollBarProxy = new UIStyle.scrollBar();
				}
				else if (_scrollBarProxy is Class)
				{
					//程序设置位置
					_scrollBarProxy = new _scrollBarProxy();
				}
				else if(_scrollBarProxy.parent)
				{
					//使用滑调本身位置
					_scrollBarAutoPos = false;
				}
				
				_scrollbar = new TScrollBar(null, _scrollBarProxy, TScrollBar.VERTICAL, onScroll);
				_scrollbar.pageSize = this.height;
				_scrollbar.autoHide = true;
				moveScrollBar();
				_scrollbar.height = this.height; //- 8;
				_scrollbar.setSliderParams(0, 0, 0);
				if(_scrollBarAutoPos)
				{
					this.addChild(_scrollbar);
				}
			}
		}
		
		private function moveScrollBar():void
		{
			if (_scrollBarAutoPos)
			{
				if(_scrollBarPosType == UIConst.RIGHT)
				{
					_scrollbar.move(this.width - _scrollbar.width, 0);
					_itemHolder.x = 0;
				}
				else if(_scrollBarPosType == UIConst.LEFT)
				{
					_scrollbar.move(0, 0);
					_itemHolder.x = _scrollbar.width;
				}
			}
		}
		
		private function getListWidth():Number
		{
			if(_useScorllBar && _scrollBarAutoPos)
			{
				return this.width - _scrollbar.width;
			}
			else
			{
				return this.width;
			}
		}
		
		private function disposeRender():void
		{
			if(_renderToDisposeArray.length > 0)
			{
				for each(var render:TListItemRender in _renderToDisposeArray)
				{
					if(render.parent)
					{
						render.parent.removeChild(render);
					}
					_renderPool.dispose(render);
				}
			}
			_renderToDisposeArray.length = 0;
		}
		
		public function set scrollLineSize(value:int):void
		{
			if(_useScorllBar)
			{
				_scrollbar.lineSize = value;
			}
			_lineSize = value;
		}
		
		public function set scrollBarPosType(value:String):void
		{
			_scrollBarPosType = value;
			moveScrollBar();
		}

		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
		}
		
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		
		public function set verticalGap(value:Number):void
		{
			_verticalGap = value;
			invalidate();
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set items(value:Array):void
		{
			if (!value)
			{
				value = [];
			}
			
			if(_items == value)
			{
				return;
			}
			
			if(_items && _placeHolderList.length != 0)
			{
				for (var i:int = 0; i < _itemHolder.numChildren; ++i)
				{
					_renderToDisposeArray.push(_itemHolder.getChildAt(i));
				}
			}
			_placeHolderList.length = 0;
			
			_items = value.slice();

			//刷新整个placeholder列表
			var render:TListItemRender;
			var item:Object;
			var placeHolder:PlaceHolder;
			for each (item in _items)
			{
				render = _renderPool.get(getListWidth());
				placeHolder = new PlaceHolder(render, item);
				_placeHolderList.push(placeHolder);
			}
			_indexChanged = true;
			if(_autoScroll)
			{
				_scrollToEnd = true;
			}
			invalidate();
		}

		public function get items():Array
		{
			return _items;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function addItem(value:Object):void
		{
			_items.push(value);
			//创建PlaceHolder并添加
			var render:TListItemRender = _renderPool.get(getListWidth());
			var placeHolder:PlaceHolder = new PlaceHolder(render, value);
			_placeHolderList.push(placeHolder);
			_indexChanged = true;			
			if(_autoScroll)
			{
				_scrollToEnd = true;
			}
			invalidate();
		}

		/**
		 * 
		 * @param value
		 * @param index
		 * 
		 */		
		public function addItemAt(value:Object, index:int):void
		{
			_items.splice(index, 0, value);
			//创建PlaceHolder并添加
			var render:TListItemRender = _renderPool.get(getListWidth());
			var placeHolder:PlaceHolder = new PlaceHolder(render, value);
			_placeHolderList.splice(index, 0, placeHolder);
			_indexChanged = true;
			if(_autoScroll)
			{
				_scrollToEnd = true;
			}
			invalidate();
		}
		
		public function setItemAt(value:Object, index:int):void
		{
			_items[index] = value;
			//更新placeholder，和对应itemRender
			var placeHolder:PlaceHolder = _placeHolderList[index];
			if(placeHolder.itemRender)
			{
				placeHolder.data = value;
			}
			else
			{
				var render:TListItemRender = _renderPool.get(getListWidth());
				placeHolder.init(render, value);
			}
			invalidate();
		}

		public function removeItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
			removeItemAt(index);
		}

		public function removeItemAt(index:int):void
		{
			_items.splice(index, 1);
			var result:Array = _placeHolderList.splice(index, 1) as Array
			var placeHolder:PlaceHolder = result[0];
			if(placeHolder.itemRender)
			{
				if(placeHolder.showing())
				{
					_renderToDisposeArray.push(placeHolder.itemRender);
				}
				placeHolder.disposeRender();
			}
			_indexChanged = true;
			invalidate();
		}
		
		/**
		 * Sets / gets the index of the selected list item.
		 */
		public function set selectedIndex(value:int):void
		{
			if (value < 0 && value >= _items.length)
			{
				value = -1;
			}
			if(_selectedIndex == value)
			{
				return;
			}
			_selectedIndex = value;
			dispatchEvent(new Event(Event.SELECT));
			_selectChanged = true;
			invalidate();
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedItem(value:Object):void
		{
			selectedIndex = _items.indexOf(value);
		}
		
		public function get selectedItem():Object
		{
			if(_selectedIndex == -1)
			{
				return null;
			}
			else				
			{
				return _items[_selectedIndex];
			}
		}

		public function getItemRender(index:int):TListItemRender
		{
			for each(var render:TListItemRender in _itemHolder)
			{
				if(render.index == index)
				{
					return render;
				}
			}
			
			return null;
		}
		
		
		public function get autoScroll():Boolean
		{
			return _autoScroll;
		}

		public function set autoScroll(value:Boolean):void
		{
			_autoScroll = value;
			invalidate();
		}

		/**
		 * 重新布局render
		 * 
		 */		
		private function reflashRender():void
		{
			var sumHeight:Number = 0;
			var placeHolder:PlaceHolder;
			var index:int = 0;
			var prevRender:TListItemRender;
			var layoutY:Number;
			var beginLayout:Boolean = false;
			for each (placeHolder in _placeHolderList)
			{
				if (sumHeight < _offset + this.height &&sumHeight + placeHolder.height > _offset)
				{
					//显示范围内的ItemRender
					if (!placeHolder.itemRender)
					{
						placeHolder.init(_renderPool.get(getListWidth()), placeHolder.data);
					}
					if(!placeHolder.showing())
					{
						placeHolder.itemRender.index = index;
						placeHolder.itemRender.selected = placeHolder.itemRender.index == _selectedIndex;
						_itemHolder.addChild(placeHolder.itemRender);
					}
					else if(_indexChanged)
					{
						placeHolder.itemRender.index = index;
						placeHolder.itemRender.selected = placeHolder.itemRender.index == _selectedIndex;
					}
					else if(_selectChanged)
					{
						placeHolder.itemRender.selected = placeHolder.itemRender.index == _selectedIndex;
					}
					if(!beginLayout)
					{
						beginLayout = true;//第一次布局，记录下起始布局位置
						layoutY = sumHeight - _offset;
					}
					
					placeHolder.itemRender.x = 0;
					placeHolder.itemRender.y = 0;
					layoutRender(placeHolder.itemRender, prevRender, this, _itemHolder.x, layoutY, getListWidth());
					prevRender = placeHolder.itemRender;
				}
				else
				{
					if (placeHolder.itemRender)
					{
						if(placeHolder.showing())
						{
							_itemHolder.removeChild(placeHolder.itemRender);
						}
						_renderPool.dispose(placeHolder.itemRender);
						placeHolder.disposeRender();
					}
				}
				sumHeight += placeHolder.height + _verticalGap;
				index++;
				
				//更新选中状态
				if(_selectedIndex != -1 && placeHolder.itemRender && placeHolder.itemRender.index == _selectedIndex)
				{
					placeHolder.itemRender.selected = true;
				}
			}
			_selectChanged = false;
			_indexChanged = false;
		}

		private function onRenderSelect(event:Event):void
		{
			selectedIndex = (event.currentTarget as TListItemRender).index;
		}

		private function updateMaximun():void
		{
			var oldMaximun:Number = _maximun;
			var sumHeight:Number = 0;
			var placeHolder:PlaceHolder;
			for each (placeHolder in _placeHolderList)
			{
				if(sumHeight == 0)
				{
					sumHeight += placeHolder.height;
				}
				else
				{
					sumHeight += placeHolder.height + _verticalGap;
				}
			}
			_maximun = sumHeight > this.height ? sumHeight - this.height : 0;
			if(_offset > _maximun)
			{
				_offset = _maximun;
			}
			if(_scrollToEnd)
			{
				_scrollToEnd = false;
				if(_offset >= oldMaximun)//在聊天框在最底部是autoScroll才生效
				{
					_offset = _maximun;
				}
			}
			updateScrollBar();
		}
		
		private function updateScrollBar():void
		{
			if(_useScorllBar)
			{
				_scrollbar.setSliderParams(0, _maximun, _offset);
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
				LayoutUtil.silder(obj, container, null, _verticalAlign, x, y);
				if (!prev)
					LayoutUtil.silder(obj, container, _horizontalAlign, null, x, y);
				else
					LayoutUtil.horizontal(obj, prev, container, _horizontalGap, _horizontalAlign);
			}
			else if (_type == UIConst.VERTICAL)
			{
				LayoutUtil.silder(obj, container, _horizontalAlign, null, x, y);
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
		
		protected function onScroll(event:Event):void
		{
			_offset = Math.max(0, _scrollbar.value);
			_offset = Math.min(_offset, _maximun);
			reflashRender();
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			offset -= event.delta * _lineSize;
		}
		
		public function set offset(value:Number):void
		{
			if (_useScorllBar)
			{
				_scrollbar.value = value;
				_offset = _scrollbar.value;
			}
			else
			{
				_offset = Math.max(0, value);
				_offset = Math.min(_offset, _maximun);
			}
			reflashRender();
		}
		
		public function get offset():Number
		{
			return _offset;
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
					this._items[event.location] = (event.items[0] as PropertyChangeEvent).target;
					break;
			}
		}
		
		override public function invalidateSize(changed:Boolean=false):void
		{
 			super.invalidateSize(changed);
				this.scrollRect = new Rectangle(0, 0, width, height);
				moveScrollBar();
				_scrollbar.pageSize = this.height;
				_scrollbar.height = this.height; //- 8;
				var placeHolder:PlaceHolder;
				var listwidth:Number = getListWidth();
				for each (placeHolder in _placeHolderList)
				{
					placeHolder.resize(listwidth, _renderPool);
				}
				invalidate();
		}
		
		public function set scrollbarAutoHide(value:Boolean):void
		{
			_scrollbar.autoHide = value;
			_scrollbar.setSliderParams(0, _maximun, _offset);
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
	}
}
import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Rectangle;

import mx.core.IFactory;

import tempest.ui.components.TList2;
import tempest.ui.components.TListItemRender;
import tempest.ui.events.ListEvent;

class RenderPool
{
	private var _renderList:Array;
	private var _renderClass:*;
	private var _renderSkinClass:*;
	private var _list:TList2;
	private var _selectHandler:Function;

	public function RenderPool(renderClass:*, renderSkinClass:*, list:TList2, selectHandler:Function)
	{
		_renderClass = renderClass;
		_renderSkinClass = renderSkinClass;
		_renderList = [];
		_list = list;
		_selectHandler = selectHandler;
	}

	public function get(width:Number):TListItemRender
	{
		if (_renderList.length > 0)
		{
			return _renderList.pop() as TListItemRender;
		}
		else
		{
			var newRender:TListItemRender;
			if (_renderClass is IFactory)
			{
				newRender = (_renderClass as IFactory).newInstance();
			}
			else
			{
				newRender = new _renderClass(_renderSkinClass);
			}
			newRender.width = width;
			newRender.addEventListener(Event.SELECT, _selectHandler);
			_list.dispatchEvent(new ListEvent(ListEvent.ITEM_RENDER_CREATE, newRender));
			return newRender;
		}
		
	}
	
	public function dispose(render:TListItemRender):void
	{
		render.data = null;
		if(render.selected)
		{
			render.selected = false;
		}
		_renderList.push(render);
	}
}

class PlaceHolder
{
	public var width:Number;
	public var height:Number;
	public var _itemRender:TListItemRender;
	private var _data:Object;

	public function PlaceHolder(itemRender:TListItemRender, data:Object)
	{
		_data = data;
		_itemRender = itemRender;
		_itemRender.data = _data;
		this.width = itemRender.width;
		this.height = itemRender.height;
	}

	public function get itemRender():TListItemRender
	{
		return _itemRender;
	}
	
	public function disposeRender():void
	{
		_itemRender = null;
	}
	
	public function showing():Boolean
	{
		return _itemRender.parent ? true : false;
	}
	
	public function init(itemRender:TListItemRender, data:Object):void
	{
		_data = data;
		_itemRender = itemRender;
		_itemRender.data = _data;
		this.width = itemRender.width;
		this.height = itemRender.height;
	}
	
	public function get data():Object
	{
		return _data;
	}
	
	public function set data(value:Object):void
	{
		_data = value;
		_itemRender.data = _data;
		this.width = itemRender.width;
		this.height = itemRender.height;		
	}

	public function resize(width:Number, renderPool:RenderPool):void
	{
		var render:TListItemRender = _itemRender;
		if(render)
		{
			render.width = width;	
			this.width = render.width;
			this.height = render.height;	
		}
		else
		{
			render = renderPool.get(width);
			if(render.parent)
			{
				render.parent.removeChild(render);
			}
			render.data = data;
			this.width = render.width;
			this.height = render.height;	
			renderPool.dispose(render);
		}
			
	}
}
