//------------------------------------------------------------------------------
//   QYFZ  
//   Copyright 2011 
//   All rights reserved. 
//------------------------------------------------------------------------------
package tempest.engine
{
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.Dictionary;

	import tempest.core.IDisposable;
	import tempest.engine.core.ISceneCharacterPlugin;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.avatar.Avatar;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;
	import tempest.engine.graphics.avatar.vo.AvatarPlayCondition;
	import tempest.engine.helper.MoveHelper;
	import tempest.engine.staticdata.Status;
	import tempest.engine.tools.*;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.tools.move.WalkStep;
	import tempest.engine.vo.move.MoveCallBack;
	import tempest.engine.vo.move.MoveData;
	import tempest.utils.Fun;

	/**
	 * 游戏精灵类
	 * @author wushangkun
	 */
	public class SceneCharacter extends BaseElement implements IDisposable
	{
		///////////////////////////属性////////////////////////////////////
		public var isSelected:Boolean = false; //是否被选中
		public var updateNow:Boolean = false;
		public var layoutNow:Boolean = false;
		private var _avatar:Avatar;
		private var _plugins:Vector.<ISceneCharacterPlugin>;

		public function get avatar():Avatar
		{
			return _avatar;
		}

		/**
		 * 角色朝向
		 * @return
		 */
		public function get dir():int
		{
			return _avatar.dir;
		}

		public function set dir(value:int):void
		{
			_avatar.dir = value;
		}

		public function get head_offset():Number
		{
			return _avatar.head_offset;
		}

		public function get body_offset():Number
		{
			return _avatar.body_offset;
		}
		private var _shadow:Bitmap;

		public function SceneCharacter(type:int, scene:TScene)
		{
			super(type, scene);
			_plugins = new Vector.<ISceneCharacterPlugin>();
			this._avatar = new Avatar(this);
			//***************
			this.mouseChildren = this.mouseEnabled = false;
			_shadow = new shadow() as Bitmap;
			_shadow.x = -_shadow.width / 2;
			_shadow.y = -_shadow.height / 2;
			this._mainLayer.addChild(_shadow);
			this._mainLayer.addChild(avatar);
			flyTextArr = new Vector.<DisplayObject>();
		}

		/**
		 * 添加插件
		 * @param plugin
		 * @return
		 *
		 */
		public function addPlugin(plugin:ISceneCharacterPlugin):ISceneCharacterPlugin
		{
			_plugins.push(plugin);
			plugin.setup(this);
			return plugin;
		}

		/**
		 * 移除插件
		 * @param name
		 * @return
		 *
		 */
		public function removePlugin(name:String):ISceneCharacterPlugin
		{
			for (var i:int = 0; i < _plugins.length; ++i)
			{
				var plu:ISceneCharacterPlugin = _plugins[i];
				if (plu.name == name)
				{
					_plugins.splice(i, 1);
					plu.shutdown();
					return plu;
				}
			}
			return null;
		}

		/**
		 * 获取插件
		 * @param name
		 * @return
		 *
		 */
		public function getPlugin(name:String):ISceneCharacterPlugin
		{
			for each (var plu:ISceneCharacterPlugin in _plugins)
			{
				if (plu.name == name)
				{
					return plu;
				}
			}
			return null;
		}

		/**
		 * 更新插件
		 *
		 */
		public function updatePlugin():void
		{
			for each (var plu:ISceneCharacterPlugin in _plugins)
			{
				plu.update();
			}
		}

		public function setAvatarVisible(value:Boolean):void
		{
			if (this._avatar.visible != value)
			{
				this._avatar.visible = value;
				this._shadow.visible = value;
				if (this._avatar.visible)
				{
					this.updateNow = true;
				}
				var ani:Animation = null;
				for each (ani in effects)
				{
					if (value)
					{
						ani.play();
					}
					else
					{
						ani.stop();
					}
					ani.visible = value;
				}
				if (this._selectEffect)
				{
					this._selectEffect.visible = value;
				}
			}
		}

		/**
		 * 说话
		 * @param msg
		 */
		public function talk(msg:String, talkSimleys:Array = null, taklDelay:int = 5000):void
		{
			this._headFace.setTalkText(msg, talkSimleys, taklDelay);
		}

		public function get isOnMount():Boolean
		{
			return this.avatar.isOnMount;
		}

		public function set isOnMount(value:Boolean):void
		{
			this.avatar.isOnMount = value;
		}

		/**
		 * 是英雄？
		 * @return
		 */
		public function get isMainChar():Boolean
		{
			return this == scene.mainChar;
		}
		/***********************飞行文字管理*******************************************/
		public var flyTextArr:Vector.<DisplayObject> = null;

		public function showFlyText(flyText:DisplayObject):void
		{
			flyTextArr.push(flyText);
		}
		/**
		* 光效列表
		 * @default
		 */
		public var effects:Dictionary = new Dictionary(true);

		/**
		 *添加状态表现光效
		 * @param effect 光效
		 * @param isLand是否地效
		 * @param isFoot是否添加到脚上
		 * @param isBody是否加到身体重心
		 * @param isHead是否加到头部
		 */
		public function addEffect(ani:Animation, isLand:Boolean, isFoot:Boolean, isBody:Boolean, isHead:Boolean):void
		{
			if (ani)
			{
				removeEffect(ani.id);
				if (isBody)
				{
					ani.y = this._avatar.body_offset;
				}
				else if (isHead)
				{
					ani.y = this._avatar.head_offset;
				}
				ani.onComplete = onAniDispose;
				effects[ani.id] = ani; //添加到角色光效列表
				ani.visible = this._avatar.visible;
				if (isLand)
				{
					this.addChildAt(ani, 0);
				}
				else
				{
					this.addChild(ani);
				}
			}
		}

		private function onAniDispose(ani:Animation):void
		{
			removeEffect(ani.id);
		}

		/**
		 * 移除特效
		 * @param effect 光效
		 */
		public function removeEffect(id:int):void
		{
			var _ani:Animation = effects[id];
			if (_ani)
			{
				Animation.disposeAnimation(_ani);
				delete effects[id];
				_ani = null;
			}
		}

		/**
		 *移除角色身上所有光效
		 *
		 */
		public function removeAllEffect():void
		{
			var ani:Animation = null;
			for each (ani in effects)
			{
				Animation.disposeAnimation(ani);
			}
			effects = new Dictionary();
		}
		private var _selectEffect:Animation = null;

		/**
		 * 隐藏选中特效
		 */
		public function hideSelectEffect():void
		{
			if (_selectEffect)
			{
				Animation.disposeAnimation(this._selectEffect);
				this._selectEffect = null;
			}
		}

		/**
		 * 显示选中特效
		 * @param effect
		 */
		public function showSelectEffect(effect:Animation):void
		{
			if (effect)
			{
				hideSelectEffect();
				this.addChildAt(effect, 0);
				this._selectEffect = effect;
			}
		}

		public function setVisible(value:Boolean):void
		{
			if (this.visible != value)
			{
				this.visible = value;
				if (this.visible)
				{
					this.updateNow = true;
				}
			}
		}

		/**********************************************************************/ /**
		 * 鼠标是否碰撞
		 * @return
		 */
		override public function get isMouseHit():Boolean
		{
			if (this.getStatus() == Status.DEAD) //死亡后不可选中
			{
				return false;
			}
			return this.visible && avatar.isMouseHit() /*|| isMouseHitShadow()*/;
		}

		private function isMouseHitShadow():Boolean
		{
			return _shadow.bitmapData && ((_shadow.bitmapData.getPixel32(_shadow.mouseX, _shadow.mouseY) >> 24) & 0xFF) > 0x10;
		}

		/**
		 *
		 * @param value
		 */
		override public function set isMouseOn(value:Boolean):void
		{
			if (_isMouseOn != value)
			{
				_isMouseOn = value;
			}
		}

		override public function dispose():void
		{
			this.follower = null;
			this.master = null;
			this.removeAllEffect();
			if (this.flyTextArr)
			{
				this.flyTextArr = null;
			}
			avatar.dispose();
			if (_walkData)
			{
				_walkData.clear();
				_walkData = null;
			}
			super.dispose();
			Fun.removeAllChildren(this, true);
		}

		////////////////////////////////////////////////光效管理/////////////////////////////////////////////////////////////////////////////////////////////////
		/*************************************************************************************************************************************************
		 * Avatar
		 *************************************************************************************************************************************************/
		public function playTo(status:int = -1, dir:int = -1, apc:AvatarPlayCondition = null, onEffectFrame:Function = null):void
		{
			avatar.playTo(status, dir, apc, onEffectFrame);
		}

		/*************************************************************************************************************************************************
		 * 场景移动
		 *************************************************************************************************************************************************/
		public function getStatus():int
		{
			return this.avatar.getStatus();
		}
		private var _walkData:MoveData = null;

		/**
		 * 行走数据
		 * @return
		 */
		public function get walkData():MoveData
		{
			return _walkData ||= new MoveData();
		}

		/**
		 * 面向像素点
		 * @param px
		 * @param py
		 */
		public function faceTo(p:Point):void
		{
			if (!_pixel.equals(p))
			{
				this.faceToTile(SceneUtil.Pixel2Tile(p));
			}
		}

		/**
		 * 面向网格
		 * @param tx
		 * @param ty
		 */
		public function faceToTile(p:Point):void
		{
			if (!_tile.equals(p))
			{
				this.dir = SceneUtil.getDirection(_tile, p);
			}
		}

		/**
		 * 面向角色
		 * @param char
		 */
		public function faceToSC(sc:SceneCharacter):void
		{
			this.faceToTile(sc.tile);
		}

		/**
		 * 步进
		 */
		public function runWalk():void
		{
			WalkStep.Step(this);
		}

		/**
		 * 根据目标点寻走
		 * @param targetTile
		 * @param walk_speed
		 * @param walk_standDis
		 * @param walk_callBack
		 */
		public function walk(targetTile:Point, walk_speed:Number = -1, walk_standDis:int = 0, walk_callBack:MoveCallBack = null):void
		{
			MoveHelper.walk(this, targetTile, walk_speed, walk_standDis, walk_callBack);
		}

		/**
		 * 根据路径行走
		 * @param walk_path
		 * @param targetTile
		 * @param walk_speed
		 * @param walk_standDis
		 * @param walk_callBack
		 */
		public function walk0(walk_path:Array, targetTile:Point, walk_speed:Number = -1, walk_standDis:int = 0, walk_callBack:MoveCallBack = null):void
		{
			MoveHelper.walk0(this, walk_path, targetTile, walk_speed, walk_standDis, walk_callBack);
		}

		/**
		 * 根据路径行走
		 * @param walk_path
		 * @param targetTile
		 * @param walk_speed
		 * @param walk_standDis
		 * @param walk_callBack
		 */
		public function walk1(vecX:int, vecY:int, walk_speed:Number = -1):void
		{
			MoveHelper.walk1(this, vecX, vecY, walk_speed);
		}

		/**
		 * 停止行走
		 */
		public function stopWalk(stand:Boolean = true):void
		{
			MoveHelper.stopMove(this, stand);
		}

		/**
		 * 修正移动
		 */
		public function reviseTile(tx:int, ty:int):void
		{
			this.tile_x = tx;
			this.tile_y = ty;
			MoveHelper.reviseMove(this);
		}

		/**
		 *一点是否在于角色指定距离内
		 * @param position
		 * @param distance
		 * @return
		 *
		 */
		public function inDistance(position:Point, distance:int):Boolean
		{
			return Point.distance(this._tile, position) <= distance;
		}

		public function lineTo(targetPixel:Point, speed:Number, callBack:MoveCallBack = null):void
		{
			MoveHelper.lineTo(this, targetPixel, speed, callBack);
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 添加Avatar部件
		 * @param apd
		 */
		public function addAvatarPart(apd:AvatarPartData):void
		{
			this.avatar.addAvatarPart(apd);
		}

		/**
		 * 根据类型移除部件
		 * @param type
		 */
		public function removeAvatarPartByType(type:int):void
		{
			this.avatar.removeAvatarPartByType(type);
		}

		public function runAvatar(diff:uint):void
		{
			this.avatar.run(diff);
			this._headFace.run(diff);
		}

		public function updateAvatar():void
		{
			this.avatar.update();
			this._headFace.update();
			this.updateNow = false;
			this.layout();
		}

		/////////////////////////////////////////////////////////////////////////////////
		private function layout():void
		{
			if (!layoutNow)
				return;
			//布局头顶显示
			this._headFace.y = _avatar.head_offset;
			//布局光效
			layoutNow = false;
		}
		///////////////////////////////////////////////////////////////////////////////
		public var follower:SceneCharacter = null;
		public var master:SceneCharacter = null;

		//////////////////////////////////////////////////////////////////////////////////
		public function get nickName():String
		{
			return _headFace.nickName;
		}

		public function setNickNameVisible(value:Boolean):void
		{
			_headFace.setNickNameVisible(value);
		}

		public function setNickName(nickName:String, nickNameColor:uint):void
		{
			_headFace.setNickName(nickName, nickNameColor);
		}

		public function get nickNameColor():uint
		{
			return _headFace.nickNameColor;
		}

		public function get customTitle():String
		{
			return _headFace.customTitle;
		}

		public function setCustomTitle(value:String):void
		{
			_headFace.setCustomTitle(value);
		}

		public function setBarVisible(value:Boolean):void
		{
			_headFace.setBarVisible(value);
		}

		public function setBar(minValue:int, maxValue:int):void
		{
			_headFace.setBar(minValue, maxValue);
		}

		public function get leftIco():DisplayObject
		{
			return _headFace.leftIco;
		}

		public function setLeftIco(value:DisplayObject):void
		{
			_headFace.setLeftIco(value);
		}

		public function get topIco():DisplayObject
		{
			return _headFace.topIco;
		}

		public function setTopIco(value:DisplayObject):void
		{
			_headFace.setTopIco(value);
		}
	}
}
