package modules.main.business.scene.model
{
	import common.GameInstance;
	import common.constants.AnimationConst;
	import common.constants.ResPath;
	import common.res.map.MapResManager;
	import common.res.npc.vo.NpcRes;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.ui.Keyboard;

	import modules.main.business.scene.constants.SceneCharacterType;
	import modules.main.business.scene.constants.StatusType;

	import tempest.common.mvc.base.Actor;
	import tempest.common.staticdata.Colors;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.avatar.AvatarPartType;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;

	import tpe.Input;

	public class SceneModel extends Actor
	{
		private var _mouseOnElement:BaseElement = null;





		public function SceneModel()
		{
			super();
		}

		//////////////////////////////人物行走相关键盘事件捕获///////////////////////////////
		private var _mc:Shape = new Shape();

		public function enableTick():void
		{
			_mc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function disableTick():void
		{
			_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function loadNpc():void
		{
			var list:Array = MapResManager.getMapRes(GameInstance.scene.id).npcs;
			var sc:SceneCharacter;
			list.forEach(function(item:NpcRes, index:int, arr:Array):void
			{
				sc = new SceneCharacter(SceneCharacterType.NPC, GameInstance.scene);
				sc.id = item.id;
				sc.tile_x = item.pos_x;
				sc.tile_y = item.pos_y;
				sc.dir = item.orient;
				if (!item.template)
				{
					return;
				}
				sc.avatar.addAvatarPart(new AvatarPartData(AvatarPartType.CLOTH, ResPath.getCharacterPath(item.template.modelId, StatusType.STAND)));
//				npc.headIcon = item.template.headIcoId;
//				HeadFaceManager.updateNickCharName([sc]);
//				HeadFaceManager.updateCharCustomHtmlText([sc]);
//				if (item.template.top_ico_id > 0)
//				{
//					HeadFaceManager.updateCharTopIco([sc]);
//				}
				GameInstance.scene.addCharacter(sc);
			});

		}

		public function get mouseOnElement():BaseElement
		{
			return _mouseOnElement;
		}

		public function set mouseOnElement(value:BaseElement):void
		{
			if (value)
			{
				if (_mouseOnElement)
				{
					if (_mouseOnElement == value)
					{
						return;
					}
					_mouseOnElement.isMouseOn = false;
					if (_mouseOnElement is SceneCharacter)
					{
						SceneCharacter(_mouseOnElement).avatar.filters = null;
					}
				}
				_mouseOnElement = value;
				_mouseOnElement.isMouseOn = true;
				if (_mouseOnElement is SceneCharacter)
				{
					SceneCharacter(_mouseOnElement).avatar.filters = [new DropShadowFilter(0, 45, Colors.White, 1, 7, 7)];
				}
			}
			else
			{
				if (_mouseOnElement)
				{
					_mouseOnElement.isMouseOn = false;
					if (_mouseOnElement is SceneCharacter)
					{
						SceneCharacter(_mouseOnElement).avatar.filters = null;
					}
				}
				_mouseOnElement = null;
			}
		}

		private var _selectChar:SceneCharacter;

		public function get selectChar():SceneCharacter
		{
			return _selectChar;
		}

		public function set selectChar(value:SceneCharacter):void
		{
			if (_selectChar == value)
			{
				return;
			}
			//切换不同的目标时中断轮循
//			if (FightManager.instance.isPolling)
//			{
//				FightManager.instance.stopPoll();
//			}
			if (_selectChar != null)
			{
				_selectChar.isSelected = false;
				_selectChar.hideSelectEffect();
//				if (_selectChar.type == SceneCharacterType.NPC)
//				{
//					var npc:Npc = _selectChar.data as Npc;
//					if (npc)
//					{
//						_selectChar.dir = npc.npcRes.orient;
//					}
//				}
			}
			_selectChar = value;
//			if (_scene)
//			{
//				_scene.selectedChar = _selectChar;
//			}
			GameInstance.scene.selectedChar = _selectChar;
			if (_selectChar)
			{
				_selectChar.isSelected = true;
				_selectChar.showSelectEffect(Animation.createAnimation( /*FightHelper.isHostile(_selectChar)*/isHostile(_selectChar) ? AnimationConst.Ani_CheckMonster : AnimationConst.Ani_CheckPlayer));
			}
		}

		/**
		 * 是否敌对
		 * @param selectChar
		 * @return
		 *
		 */
		private function isHostile(sc:SceneCharacter):Boolean
		{
			return sc.type != SceneCharacterType.NPC;
		}

		private var cur_vecX:int = 0;
		private var cur_vecY:int = 0;

		private function onEnterFrame(e:Event):void
		{
//			if (!Input.active)
//				return;
//			var l:int = Input.getKey(Keyboard.LEFT) ? -1 : 0;
//			var r:int = Input.getKey(Keyboard.RIGHT) ? 1 : 0;
//			var u:int = Input.getKey(Keyboard.UP) ? -1 : 0;
//			var d:int = Input.getKey(Keyboard.DOWN) ? 1 : 0;
//			var vecX:int = l + r;
//			var vecY:int = u + d;
//			if (vecX == cur_vecX && cur_vecY == vecY)
//			{
//				return;
//			}
//			cur_vecX = vecX;
//			cur_vecY = vecY;
//			if (cur_vecX == 0 && cur_vecY == 0)
//			{
//				MainCharWalkManager.stopMove();
//			}
//			else
//			{
//				GameInstance.mainChar.walk(
//				MainCharWalkManager.heroWalk2(cur_vecX, cur_vecY);
//			}
		}
	}
}
