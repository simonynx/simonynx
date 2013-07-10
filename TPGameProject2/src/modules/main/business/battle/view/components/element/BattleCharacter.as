package modules.main.business.battle.view.components.element
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import common.constants.ResPath;
	
	import modules.main.business.battle.model.entity.BattlePlayer;
	import modules.main.business.battle.signals.BattlePlayerSignals;
	import modules.main.business.scene.constants.StatusType;
	
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.avatar.Avatar;
	import tempest.engine.graphics.avatar.AvatarPartType;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;
	import tempest.ui.ChangeWatcherManager;
	import tempest.utils.ListenerManager;

	public class BattleCharacter extends BattleElement
	{
		private var _avatar:Avatar;
		private var _player:BattlePlayer;
		private var _changeWatcherMgr:ChangeWatcherManager;
		private var _listenerMgr:ListenerManager;
		public var flyTextArr:Vector.<DisplayObject>;
		public var hurtFlag:int;
		/**
		 * 光效列表
		 * @default
		 */
		public var effects:Dictionary = new Dictionary(true);

		public function BattleCharacter(guid:int)
		{
			super(guid);
			_changeWatcherMgr = new ChangeWatcherManager();
			_changeWatcherMgr.createAlways = true;
			_listenerMgr = new ListenerManager();
			_avatar = new Avatar(null);
			_mainLayer.addChild(_avatar);
			flyTextArr = new Vector.<DisplayObject>();
		}

		override public function dispose():void
		{
			this.data = null;
		}

		override public function set data(value:Object):void
		{
			if (super.data == value)
			{
				return;
			}
			_changeWatcherMgr.unWatchAll();
			_listenerMgr.removeAll();
			updateModel(0);
			super.data = value;
			_player = BattlePlayer(data);
			if (_player)
			{
				_changeWatcherMgr.bindSetter(updateHP, _player, "hp");
				_changeWatcherMgr.bindSetter(updateHP, _player, "maxHp");
				_changeWatcherMgr.bindSetter(updateName, _player, "name");
				_changeWatcherMgr.bindSetter(updateName, _player, "nameColor");
				updateModel(_player.modelId);
				this.logicX = _player.logicX;
				this.logicY = _player.logicY;
				this.camp = _player.camp;
			}
		}

		private function updateHP(value:int):void
		{
			_headFace.setBar(_player.hp, _player.maxHp);
		}

		private function updateName(name:String):void
		{
			_headFace.setNickName(_player.name, _player.nameColor);
		}

		private function updateModel(modelId:int):void
		{
			if (modelId)
			{
				_avatar.addAvatarPart(new AvatarPartData(AvatarPartType.CLOTH, ResPath.getCharacterPath(modelId, StatusType.STAND)));
			}
			else
			{
				_avatar.removeAllAvatarPart();
			}
		}
		
		/**
		 * 飞行文字管理
		 * @param flyText
		 * 
		 */		
		public function showFlyText(flyText:DisplayObject):void
		{
			flyTextArr.push(flyText);
		}
		
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
		
		private function onAniDispose(ani:Animation):void
		{
			removeEffect(ani.id);
		}

		override public function update(diff:uint):void
		{
			_avatar.run(diff);
			_avatar.update();
		}
	}
}
