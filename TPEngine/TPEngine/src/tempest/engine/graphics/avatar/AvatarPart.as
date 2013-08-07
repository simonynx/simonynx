package tempest.engine.graphics.avatar
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import tempest.TPEngine;
	import tempest.common.pool.Pool;
	import tempest.common.rsl.vo.TRslType;
	import tempest.core.IDisposable;
	import tempest.core.IPoolClient;
	import tempest.engine.graphics.TPBitmap;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;
	import tempest.engine.graphics.avatar.vo.AvatarPartSource;
	import tempest.engine.tools.ScenePool;
	import tempest.utils.Guid;

	public class AvatarPart implements IPoolClient
	{
		[Embed(source = "Role.png")]
		public static var role:Class;
		private static const DEFAULT_ASSET:TPBitmap = new TPBitmap(Bitmap(new role()).bitmapData, 149, 118);
		public var id:int;
		private var _apd:AvatarPartData;
		private var _source:AvatarPartSource = null;
		private var _bitmap:Bitmap = new Bitmap();
		private var _center_x:Number = 175;
		private var _center_y:Number = 225;
		private var _head_offset:Number = -105;
		private var _body_offset:Number = -55;
		private var _depth:int = 0;
		public var _avatar:Avatar = null;
		public var updateNow:Boolean = false;

		public function AvatarPart(avatar:Avatar, apd:AvatarPartData)
		{
			this.reset([avatar, apd]);
		}

		public function get source():AvatarPartSource
		{
			return _source;
		}

		public function set source(value:AvatarPartSource):void
		{
			if (_source)
			{
				_source.release();
				_source = null;
			}
			this._source = value.allocate();
			_center_x = _source.width * 0.5;
			if (!isNaN(_source.center_offset))
			{
				_center_y = _source.center_offset;
				if (!isNaN(_source.head_offset))
					_head_offset = _source.head_offset - _center_y;
				if (!isNaN(_source.body_offset))
					_body_offset = _source.body_offset - _center_y;
			}
			if (_apd.type == AvatarPartType.CLOTH)
			{
				this._avatar.setOffset(_head_offset, _body_offset);
				this._avatar.useDefaultAvatar = false;
				this._avatar.updateNow = true;
			}
			updateNow = true;
			this.update();
		}

		public function get apd():AvatarPartData
		{
			return _apd;
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}

		public function get depth():int
		{
			return _depth;
		}

		public function get avatar():Avatar
		{
			return _avatar;
		}

		public function calculateDepth():void
		{
			_depth = AvatarPartType.getDepth(_apd.type, (_avatar) ? _avatar.dir : -1);
		}

		public function update():void
		{
			if (this.updateNow || this.avatar.updateNow || (this.avatar.sc && this.avatar.sc.updateNow))
			{
				if (this._avatar.useDefaultAvatar && this.avatar.sc)
				{
					if (this._apd.type == AvatarPartType.CLOTH)
					{
						if (this._bitmap.bitmapData != DEFAULT_ASSET.bitmapData)
						{
							DEFAULT_ASSET.updateBM(this._bitmap, _center_x, _center_y);
						}
					}
					else
					{
						if (this._bitmap.bitmapData != null)
						{
							this._bitmap.bitmapData = null;
						}
					}
				}
				else
				{
					if (_source == null)
					{
						_bitmap.bitmapData = null;
					}
					else
					{
						var tp:TPBitmap = _source.get(this.avatar.getStatus(), this.avatar.dir, this.avatar.currentFrame);
						if (tp == null)
						{
							_bitmap.bitmapData = null;
						}
						else
						{
							tp.updateBM(_bitmap, _center_x, _center_y);
						}
					}
				}
			}
			this.updateNow = false;
		}

		/**
		 * 是否与鼠标碰撞
		 * @return
		 */
		public function isMouseHit():Boolean
		{
			return _bitmap.bitmapData && ((_bitmap.bitmapData.getPixel32(_bitmap.mouseX, _bitmap.mouseY) >> 24) & 0xFF) > 0x66;
		}

		///////////////////////////////////////////////////////////////////////
		/* INTERFACE tempest.core.IDisposable */
		public function dispose():void
		{
			_bitmap.bitmapData = null;
			_avatar = null;
			_apd = null;
			if (_source)
			{
				_source.release();
				_source = null;
			}
		}

		/* INTERFACE tempest.core.IPoolClient */
		public function reset(args:Array):void
		{
			this.id = 0;
			this._avatar = args[0];
			this._apd = args[1];
			this._center_x = 175;
			this._center_y = 225;
			this._head_offset = -105;
			this._body_offset = -55;
			this._depth = AvatarPartType.getDepth(_apd.type, (_avatar) ? _avatar.dir : -1);
			if (_apd.type == AvatarPartType.CLOTH)
			{
				this._avatar.setOffset(_head_offset, _body_offset);
			}
			else if (_apd.type == AvatarPartType.WING)
			{
				this._avatar.hasWing = true;
			}
			updateNow = false;
		}

		public static function createAvatarPart(avatar:Avatar, apd:AvatarPartData):AvatarPart
		{
			return ScenePool.avatarPartPool.createObj(AvatarPart, avatar, apd) as AvatarPart;
		}

		public static function disposeAvatarPart(ap:AvatarPart):void
		{
			ScenePool.avatarPartPool.disposeObj(ap);
		}
	}
}
