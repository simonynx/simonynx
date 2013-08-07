package tempest.engine
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import tempest.core.IDisposable;
	import tempest.engine.graphics.tagger.HeadFace;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.vo.config.SceneConfig;
	import tempest.utils.Fun;

	/**
	 * 游戏元素
	 * 一切游戏对象基类
	 * @author wushangkun
	 */
	public class BaseElement extends Sprite implements IDisposable
	{
		public var id:int = 0;
		protected var _headFace:HeadFace;
		protected var _mainLayer:Sprite;
		protected var _customLayer:Sprite;
		public var priority:int = 0;
		public var distance:int = 0;
		public var added:Boolean = false;
		////////////////////////////////////////////////////////////////
		protected var _fullName:String = ""; //名字
		private var _usable:Boolean = true;
		public var data:Object;
		protected var _type:int = -1;

		public function get type():int
		{
			return _type;
		}
		[Embed(source = "投影4.png")]
		public var shadow:Class;
		/**
		 *场景
		 */
		public var scene:TScene = null;

		//////////////////////新属性系统/////////////////////////////////
		public function BaseElement(type:int, scene:TScene)
		{
			super();
			this._type = type;
			this.scene = scene;
			_mainLayer = new Sprite();
			this.addChild(_mainLayer);
			_customLayer = new Sprite();
			this.addChild(_customLayer);
			_headFace = new HeadFace(_fullName, 0xFFFFFF);
			this.addChild(_headFace);
		}

		public function get fullName():String
		{
			return _fullName;
		}

		public function set fullName(value:String):void
		{
			_fullName = value;
		}

		public function get isMouseHit():Boolean
		{
			return false;
		}
		protected var _isMouseOn:Boolean = false; //是否获取鼠标焦点

		/**
		 *获取/设置鼠标焦点事件
		 * @return
		 */
		public function get isMouseOn():Boolean
		{
			return _isMouseOn;
		}

		/**
		 *
		 * @param value
		 */
		public function set isMouseOn(value:Boolean):void
		{
			_isMouseOn = value;
		}

		/**
		 * 在视野中
		 * @return
		 */
		public function inSight():Boolean
		{
			return scene && scene.sceneCamera.canSee(this);
		}

		/**
		 * 是否显示阴影
		 * @return
		 */
		public function get isInMask():Boolean
		{
			return scene.mapConfig.isMask(this.tile_x, this.tile_y);
		}
		public var opacity:Number = 1;

		public function checkShading():void
		{
			//			if (getStatus() == Status.DEAD)
			//			{
			//				return;
			//			}
			var a:Number = Math.min((isInMask) ? 0.5 : 1, opacity);
			if (_mainLayer.alpha != a)
				_mainLayer.alpha = a;
		}

		public function dispose():void
		{
			_usable = false;
			if (this.data is IDisposable)
			{
				IDisposable(this.data).dispose();
			}
			HeadFace.disposeHeadFace(this._headFace);
			this._headFace = null;
			this.data = null;
			this.scene = null;
		}

		public function get headLayer():HeadFace
		{
			return _headFace;
		}

		public function get usable():Boolean
		{
			return _usable;
		}
		////////////////////////////////////////////////////////////////////////////
		protected var _pixel:Point = new Point(); //坐标
		protected var _tile:Point = new Point(); //坐标

		/**
		 * 获取/设置逻辑坐标
		 * @return
		 */
		public function get tile():Point
		{
			return _tile;
		}

		public function set tile(value:Point):void
		{
			this.tile_x = value.x;
			this.tile_y = value.y;
		}

		public function get tile_x():Number
		{
			return _tile.x;
		}

		public function set tile_x(value:Number):void
		{
			this._tile.x = value;
			this._pixel.x = (value + 0.5) * SceneConfig.TILE_WIDTH;
			this.x = this._pixel.x;
		}

		public function get tile_y():Number
		{
			return _tile.y;
		}

		public function set tile_y(value:Number):void
		{
			this._tile.y = value;
			this._pixel.y = (value + 0.5) * SceneConfig.TILE_HEIGHT;
			this.y = this._pixel.y;
		}

		/**
		 * 获取/设置像素坐标
		 * @return
		 */
		public function get pixel():Point
		{
			return _pixel;
		}

		public function set pixel(value:Point):void
		{
			this.pixel_x = value.x;
			this.pixel_y = value.y;
		}

		/**
		 * 获取/设置像素X坐标
		 * @return
		 */
		public function get pixel_x():Number
		{
			return _pixel.x;
		}

		public function set pixel_x(value:Number):void
		{
			this._pixel.x = value;
			this._tile.x = _pixel.x / SceneConfig.TILE_WIDTH;
			this.x = this._pixel.x;
		}

		/**
		 * 获取/设置像素Y坐标
		 * @return
		 */
		public function get pixel_y():Number
		{
			return _pixel.y;
		}

		public function set pixel_y(value:Number):void
		{
			this._pixel.y = value;
			this._tile.y = _pixel.y / SceneConfig.TILE_HEIGHT;
			this.y = this._pixel.y;
		}
	}
}
