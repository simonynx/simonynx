package tempest.engine.graphics.animation
{
	import com.gskinner.motion.GTweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import tempest.TPEngine;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.core.IPoolClient;
	import tempest.engine.graphics.TPBitmap;
	import tempest.engine.graphics.animation.vo.AnimationEntity;
	import tempest.engine.graphics.animation.vo.AnimationSource;
	import tempest.engine.tools.ScenePool;
	import tempest.engine.tools.loader.AnimationLoader;
	import tempest.manager.HandlerManager;
	import tempest.utils.XMLAnalyser;
	
	import tpe.manager.FilePathManager;

	public class Animation extends Sprite implements IPoolClient
	{
		public var guid:int = 0;
		public var priority:int = 0;
		private static const log:ILogger = TLog.getLogger(Animation);
		private var _id:int = 0;
		private var _body:Bitmap = null;
		private var _type:int = 0;
		private var _currentFrame:int = 1;
		private var _totalFrames:int = 1;
		private var _bodyWidth:int = 0;
		protected var timeOffset:int = 0;
		private var _interval:int = 10000;
		private var _running:Boolean = false;
		public var onComplete:Function = null; //动画完成回调
		public var onChange:Function = null;
		private var _position:Point = null;
		
		private static var _renderSpeed:int = 1;
		
		//
		//
		public function Animation(id:int = -1, posX:Number = 0, posY:Number = 0, directory:String = "model/animation/")
		{
			this.mouseChildren = this.mouseEnabled = false;
			_body = new Bitmap();
			this.addChild(_body);
			this._id = id;
			this.move(posX, posY);
			this.init(directory);
		}
		///////////////////////////////////////////////////////////////////////////////////////////
		private static var _currentTime:Number;
		private static var driver:Shape;
		private static var ticks:Dictionary = new Dictionary(true);
		staticInit();
		
		public static function get renderSpeed():int
		{
			return _renderSpeed;
		}
		
		public static function set renderSpeed(value:int):void
		{
			_renderSpeed = value;
		}

		private static function staticInit():void
		{
			(driver = new Shape()).addEventListener(Event.ENTER_FRAME, onStaticTick);
			_currentTime = new Date().time;
		}

		private static function onStaticTick(e:Event):void
		{
			var now:Number = new Date().time;
			var msDiff:int = (now - _currentTime)*renderSpeed;
			_currentTime = now;
			var pt:Object;
			for (pt in ticks)
			{
				pt.onTick(msDiff);
			}
		}

		/**
		 * @private
		 */
		private function onTick(diff:int):void
		{
			timeOffset += diff;
			if (this._currentFrame >= this._totalFrames && this._type == AnimationType.OnceTODispose)
			{
				disposeAnimation(this);
				return;
			}
			if (timeOffset > _interval)
			{
				while (timeOffset > _interval)
				{
					timeOffset -= (_interval || timeOffset);
					if (this._currentFrame >= this._totalFrames)
					{
						if (this._type == AnimationType.Loop)
						{
							this._currentFrame = 1;
						}
						else
						{
							this.timeOffset = 0;
							this._currentFrame = _totalFrames;
							break;
						}
					}
					else
					{
						_currentFrame++;
					}
					if (this.hasEventListener(Event.CHANGE))
					{
						this.dispatchEvent(new Event(Event.CHANGE));
					}
					HandlerManager.execute(this.onChange, [this]);
					if (_currentFrame == this._totalFrames && this._type != AnimationType.Loop)
					{
						if (this.hasEventListener(Event.COMPLETE))
						{
							this.dispatchEvent(new Event(Event.COMPLETE));
						}
						HandlerManager.execute(this.onComplete, [this]);
					}
					///////////////////////////////////////
					updateNow = true;
				}
			}
			this.update();
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		private function init(directory:String):void
		{
			var config:AnimationEntity = animations[_id] as AnimationEntity;
			if (config == null)
			{
				log.error("沒有找到Animation配置文件 code:{0}", _id);
				disposeAnimation(this);
				return;
			}
			this.rpX = config.centerX;
			this.rpY = config.centerY;
			this._type = config.kind;
			this.scaleX = config.scale_x;
			this.scaleY = config.scale_y;
			this.blendMode = AnimationBlendMode.getBlendMode(config.blend_mode);
			this._bodyWidth = config.body_width;
			this._totalFrames = config.frameTotal;
			this._interval = config.interval;
			this._path = FilePathManager.getPath(directory + this._id + ".swf");
			AnimationLoader.loadAnimation(this);
			play();
		}

		/**
		 *获取默认图片长度
		 * @return
		 *
		 */
		public function get bodyWidth():int
		{
			return _bodyWidth;
		}

		public function get id():int
		{
			return _id;
		}

		public function get body():Bitmap
		{
			return _body;
		}

		public function get bodySource():BitmapData
		{
			return _body.bitmapData;
		}

		public function set bodySource(value:BitmapData):void
		{
			if (_body.bitmapData != value)
			{
				_body.bitmapData = value;
			}
		}

		public function get position():Point
		{
			return _position ||= new Point(x, y);
		}

		public function move(posX:Number, posY:Number):void
		{
			this.x = posX;
			this.y = posY;
		}

		public function clone():Animation
		{
			return createAnimation(_id, this.x, this.y);
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		public var updateNow:Boolean = true;
		private var _path:String;
		protected var rpX:int = 0;
		protected var rpY:int = 0;

		public function get path():String
		{
			return _path;
		}
		private var _source:AnimationSource;

		public function get source():AnimationSource
		{
			return _source;
		}

		public function set source(value:AnimationSource):void
		{
			if (value)
			{
				_source = value.allocate();
				this.updateNow = true;
				this.update();
			}
		}

		private function update():void
		{
			if (this.updateNow)
			{
				if (_source)
				{
					var tp:TPBitmap = _source.get(this._currentFrame);
					if (tp)
					{
						tp.updateBM(_body, rpX, rpY);
					}
					else
					{
						_body.bitmapData = null;
					}
				}
				else
				{
					_body.bitmapData = null;
				}
			}
			this.updateNow = false;
		}

		public function reset(args:Array):void
		{
			guid = 0;
			_type = 0;
			_currentFrame = 1;
			_totalFrames = 1;
			_bodyWidth = 0;
			timeOffset = 0;
			_interval = 10000;
			_running = false;
			this._id = args[0];
			this.move(args[1], args[2]);
			this.init(args[3]);
		}

		/**
		 *释放
		 *
		 */
		public function dispose():void
		{
			stop();
			GTweener.removeTweens(this);
			AnimationLoader.removeWaitingAnimationById(this.guid);
			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
			onComplete = null;
			onChange = null;
			this.alpha = 1;
			this.visible = true;
			this.rotation = 0;
			this.filters = null;
			this.scaleX = this.scaleY = 1;
			this.blendMode = BlendMode.NORMAL;
			this.body.x = 0;
			this.body.y = 0;
			this.body.filters = null;
			if (_body.bitmapData)
			{
				_body.bitmapData = null;
			}
			if (_source)
			{
				_source.release();
				_source = null;
			}
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function play():void
		{
			if (!_running)
			{
				ticks[this] = true;
			}
			_running = true;
		}

		public function stop():void
		{
			if (_running)
			{
				ticks[this] = null;
				delete ticks[this];
			}
			_running = false;
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public static function createAnimation(id:int = -1, posX:Number = 0, posY:Number = 0, directory:String = "model/animation/"):Animation
		{
			return ScenePool.animationPool.createObj(Animation, id, posX, posY, directory) as Animation;
		}

		public static function disposeAnimation(animation:Animation):void
		{
			ScenePool.animationPool.disposeObj(animation);
		}
		/**---资源缓存相关---*/
		public static var animations:Dictionary = new Dictionary();

		/**
		 *初始化配置加载数据
		 * @param xml
		 *
		 */
		public static function loadConfig(data:*):Boolean
		{
			if (data is ByteArray)
			{
				if (!(TPEngine.decode == null))
				{
					data = TPEngine.decode(data);
				}
				data = XML(data);
			}
			if (data == null)
			{
				return false;
			}
			data = XMLAnalyser.getParseList(data, AnimationEntity);
			for each (var item:AnimationEntity in data)
				animations[item.id] = item;
			return true;
		}
	}
}
