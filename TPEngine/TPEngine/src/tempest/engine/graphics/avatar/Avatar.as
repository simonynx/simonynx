package tempest.engine.graphics.avatar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import tempest.core.IDisposable;
	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.avatar.vo.Action;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;
	import tempest.engine.graphics.avatar.vo.AvatarPlayCondition;
	import tempest.engine.signals.SceneAction_Status;
	import tempest.engine.staticdata.Status;
	import tempest.engine.tools.loader.AvatarPartLoader;

	public class Avatar extends Sprite implements IDisposable
	{
		public var sc:SceneCharacter;
		private var _dir:int = 4;
		private var _status:int = 0;
		public var avatarParts:Array = [];
		public var currentFrame:int = 0;
		protected var timeOffset:int = 0;
		public var useDefaultAvatar:Boolean = true;
		public var updateNow:Boolean = false;
		protected var _avatarPlayCondition:AvatarPlayCondition = AvatarPlayCondition.getDefaultAvatarPlayCondition(_status);
		public var actionFrame:Action = Action.getDefaultAction(_status);
		private var _onEffectFrame:Function = null;
		private var _playEffectFrame:Boolean = false;
		private var _head_offset:Number = 0;
		private var _body_offset:Number = 0;
		public var hasWing:Boolean = false;
		private var _onActionComplete:Function = null; //动作完成时回调

		public function Avatar(char:SceneCharacter)
		{
			super();
			this.mouseChildren = this.mouseEnabled = false;
			this.sc = char;
		}

		public function get head_offset():Number
		{
			return _head_offset;
		}

		public function get body_offset():Number
		{
			return _body_offset;
		}

		/**
		 * 设置偏移
		 * @param ho
		 * @param bo
		 */
		public function setOffset(ho:Number, bo:Number):void
		{
			if (_head_offset != ho || _body_offset != bo)
			{
				_head_offset = ho;
				_body_offset = bo;
				if (sc)
				{
					sc.layoutNow = true;
				}
			}
		}
		private var _isOnMount:Boolean = false;

		public function get isOnMount():Boolean
		{
			return _isOnMount;
		}

		public function set isOnMount(value:Boolean):void
		{
			_isOnMount = value;
		}

		public function getStatus():int
		{
			return _status;
		}

		public function get dir():int
		{
			return _dir;
		}

		public function set dir(value:int):void
		{
			var $dir:int;
			if (value < 0)
			{
				value = value % 8 + 8;
			}
			else if (value > 7)
			{
				value %= 8;
			}
			if (_dir != value)
			{
				$dir = _dir;
				_dir = value;
				this.updateNow = true;
				//处理翅膀
				if (hasWing)
				{
					if ($dir > 1 && $dir < 7)
					{
						if (!(value > 1 && value < 7))
						{
							sortParts();
						}
					}
					else
					{
						if (value > 1 && value < 7)
						{
							sortParts();
						}
					}
				}
			}
		}

		public function isMouseHit():Boolean
		{
			if (!this.visible)
			{
				return false;
			}
			var len:int = avatarParts.length;
			for (var i:int = 0; i < len; i++)
			{
				if (avatarParts[i].isMouseHit())
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * 播放
		 * @param status 状态
		 * @param dir 方向
		 * @param apc 播放条件
		 */
		public function playTo(status:int = -1, dir:int = -1, apc:AvatarPlayCondition = null, onEffectFrame:Function = null, onActionComplete:Function = null):void
		{
			var $status:int = status;
			var $dir:int = dir;
			var $apc:AvatarPlayCondition = apc || AvatarPlayCondition.getDefaultAvatarPlayCondition($status);
			var change:Boolean = false;
			if ($status != -1 && this._status != $status)
			{
				this._status = $status;
				this.actionFrame = Action.getDefaultAction(this._status);
				change = true;
				if (this.sc && this.sc.scene && this.sc == this.sc.scene.mainChar)
				{
					this.sc.scene.signal.status.dispatch(SceneAction_Status.CHANGE, status);
				}
				this._onActionComplete = onActionComplete;
			}
			if ($dir != -1 && _dir != $dir)
			{
				this.dir = $dir;
				change = true;
			}
			if ($apc.playAtBegin && currentFrame != 0)
			{
				this.currentFrame = 0;
				change = true;
			}
			var endFrame:int = this.actionFrame.total - 1;
			if ($apc.showEnd && currentFrame != endFrame)
			{
				currentFrame = endFrame;
				change = true;
			}
			_avatarPlayCondition = $apc;
			if (this._onEffectFrame != null)
			{
				this._onEffectFrame();
				this._onEffectFrame = null;
				this._playEffectFrame = false;
			}
			this._onEffectFrame = onEffectFrame;
			if (onEffectFrame != null && (this.currentFrame >= this.actionFrame.effect || this.actionFrame.effect > this.actionFrame.total - 1))
			{
				this._playEffectFrame = true;
			}
			if (change)
			{
				this.timeOffset = 0;
				this.updateNow = true;
			}
		}

		/**
		 *
		 */
		public function run(diff:uint):void
		{
			timeOffset += diff;
			if (currentFrame >= this.actionFrame.total - 1 && (!_avatarPlayCondition.stayAtEnd) && Status.isLoopOnce(this._status))
			{
				if(this._onActionComplete != null)
				{
					this._onActionComplete(/*this._status*/);
					this._onEffectFrame = null;
				}
				this.playTo(Status.STAND);
				return;
			}
			var interval:int = this.actionFrame.interval;
			if (timeOffset > interval)
			{
				while (timeOffset > interval)
				{
					timeOffset -= (interval || timeOffset);
					if (this.currentFrame >= this.actionFrame.total - 1)
					{
						if (_avatarPlayCondition.stayAtEnd || Status.isLoopOnce(this._status))
						{
							this.timeOffset = 0;
							this.currentFrame = this.actionFrame.total - 1;
							if(this._onActionComplete != null)
							{
								this._onActionComplete(/*this._status*/);
								this._onEffectFrame = null;
							}
							break;
						}
						else
						{
							this.currentFrame = 0;
						}
					}
					else
					{
						currentFrame++;
					}
					///////////////////////////////////////
					if (this.currentFrame == this.actionFrame.effect)
					{
						this._playEffectFrame = true;
					}
					if (this.currentFrame == this.actionFrame.total - 1)
					{
					}
					///////////////////////////////////////
					this.updateNow = true;
				}
			}
			if (this._playEffectFrame)
			{
				if (this._onEffectFrame != null)
				{
					this._onEffectFrame();
					this._onEffectFrame = null;
				}
				this._playEffectFrame = false;
			}
		}

		public function update():void
		{
			if (!this.visible || (this.sc && this.sc.visible == false))
			{
				return;
			}
			///////////////////////更新//////////////////////////////////////
			var len:int = avatarParts.length;
			for (var i:int = 0; i < len; i++)
			{
				avatarParts[i].update();
			}
			this.updateNow = false;
		}

		private function sortParts():void
		{
			var len:int = avatarParts.length;
			var i:int;
			for (i = 0; i < len; i++)
			{
				avatarParts[i].calculateDepth();
			}
			avatarParts.sortOn("depth", Array.NUMERIC);
			for (i = 0; i < len; i++)
			{
				setChildIndex(avatarParts[i].bitmap, i);
			}
		}

		/**
		 * 添加部件
		 * @param	apd
		 */
		public function addAvatarPart(apd:AvatarPartData):void
		{
			if (hasSameAvatarPart(apd))
			{
				return;
			}
			removeAvatarPartByType(apd.type);
			var ap:AvatarPart = AvatarPart.createAvatarPart(this, apd);
			avatarParts.push(ap);
			avatarParts.sortOn("depth", Array.NUMERIC);
			this.addChildAt(ap.bitmap, avatarParts.indexOf(ap));
			AvatarPartLoader.loadAvatarPart(ap);
			this.updateNow = true;
		}

		private function getAvatarPartByType(type:int):AvatarPart
		{
			var ap:AvatarPart;
			for each (ap in avatarParts)
			{
				if (ap.apd.type == type)
				{
					return ap;
				}
			}
			return null;
		}

		private function hasSameAvatarPart(apd:AvatarPartData):Boolean
		{
			var ap:AvatarPart;
			for each (ap in avatarParts)
			{
				if (ap.apd.equals(apd))
				{
					return true;
				}
			}
			return false;
		}

		public function removeAllAvatarPart():void
		{
			while (avatarParts.length > 0)
			{
				this.removeChild(avatarParts[0].bitmap);
				AvatarPartLoader.removeWaitingAvatarPartById(avatarParts[0].id);
				AvatarPart.disposeAvatarPart(avatarParts[0]);
				avatarParts.splice(0, 1);
			}
		}

		/**
		 * 通过类型移除部件
		 * @param	type
		 */
		public function removeAvatarPartByType(type:int):void
		{
			var len:int = avatarParts.length;
			for (var i:int = 0; i < len; i++)
			{
				if (avatarParts[i].apd.type == type)
				{
					this.removeChild(avatarParts[i].bitmap);
					AvatarPartLoader.removeWaitingAvatarPartById(avatarParts[i].id);
					AvatarPart.disposeAvatarPart(avatarParts[i]);
					avatarParts.splice(i, 1);
					this.updateNow = true;
					if (type == AvatarPartType.CLOTH)
					{
						useDefaultAvatar = true;
					}
					else if (type == AvatarPartType.WING)
					{
						hasWing = false;
					}
					break;
				}
			}
		}

		public function dispose():void
		{
			this._onEffectFrame = null;
			this.sc = null;
			this._avatarPlayCondition = null;
			this.actionFrame = null;
			this.removeAllAvatarPart();
		}
	}
}
