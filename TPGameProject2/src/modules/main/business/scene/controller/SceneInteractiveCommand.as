package modules.main.business.scene.controller
{
	import common.GameInstance;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import modules.main.business.battle.signals.BattleSignals;
	import modules.main.business.scene.constants.SceneCharacterType;
	import modules.main.business.scene.model.SceneModel;
	import modules.main.common.TWindowManager;
	import modules.main.constants.WindowName;

	import tempest.common.mvc.base.Command;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.vo.map.MapTile;
	import tempest.engine.vo.move.MoveCallBack;

	public class SceneInteractiveCommand extends Command
	{
		[Inject]
		public var sceneModel:SceneModel;

		[Inject]
		public var battleSignals:BattleSignals;

		public override function getHandle():Function
		{
			return onhandle;
		}

		private function onhandle(e:MouseEvent, element:BaseElement):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					onMouseDown(e, element);
					break;
				case MouseEvent.MOUSE_MOVE:
					onMouseMove(e, element);
					break;
				case MouseEvent.MOUSE_OUT:
					onMouseOut(e, element);
					break;
				case MouseEvent.MOUSE_WHEEL:
					onMouseWeel(e, element);
			}
		}

		private function onMouseWeel(e:MouseEvent, element:BaseElement):void
		{
			CONFIG::debugging
			{
				if (e.ctrlKey)
				{
				}
				else
				{
					if (e.delta > 0)
						GameInstance.mainChar.dir += 1;
					else
						GameInstance.mainChar.dir -= 1;
				}
			}
		}

		private function onMouseDown(e:MouseEvent, element:BaseElement):void
		{
			var graphicPoint:Point = new Point(e.localX, e.localY);
			var logicPoint:Point = SceneUtil.Pixel2Tile(graphicPoint);

			if (element is SceneCharacter)
			{
				sceneModel.selectChar = element as SceneCharacter;

				if (element.type == SceneCharacterType.NPC)
				{
					var callBack:MoveCallBack = new MoveCallBack();
					callBack.onWalkArrived = function(char:SceneCharacter, targetTile:MapTile):void //到达NPC回调函数
					{
//						GameInstance.signal.mainChar.talkWithNpc.dispatch(Npc(sc.data).npcRes, null);
						battleSignals.battleStart.dispatch(); //战斗开始
//						TWindowManager.instance.showPopup2(null, WindowName.BAG_VIEW);
					}
					GameInstance.mainChar.walk(element.tile, -1, 0, callBack);
				}
			}
			else
			{
				GameInstance.mainChar.walk(logicPoint, -1, 0, null);
			}
//			GameInstance.scene.showMouseChar(logicPoint, false);


		}

		/**
		 *场景鼠标移动
		 * @param e
		 * @param element
		 *
		 */
		private function onMouseMove(e:MouseEvent, element:BaseElement):void
		{
			var graphicPoint:Point = new Point(e.localX, e.localY);
			var logicPoint:Point = SceneUtil.Pixel2Tile(graphicPoint);
			sceneModel.mouseOnElement = element;
//			if (FightManager.instance.isHandUp)
//			{
//				FightManager.instance.initAttackCurors();
//			}
//			GameInstance.mouseOnElement = element;
//			if (GameInstance.mouseOnElement is SceneCharacter)
//			{
//				var character:SceneCharacter = SceneCharacter(GameInstance.mouseOnElement);
//				if (character.type == SceneCharacterType.NPC)
//				{
//					CursorManager.instance.setCursor(CursorLib.TALK);
//				}
//				else if (character.type == SceneCharacterType.MONSTER) //采集
//				{
//					var monster:Monster = Monster(character.data);
//					if (monster && monster.canCollect)
//					{
//						TToolTipManager.instance.showTip2(ToolTipName.DEFAULT_HTML, character, SkillHelper.getCollectTip(monster.collectTemplate));
//						CursorManager.instance.setCursor(CursorLib.COLLECT);
//					}
//				}
//			}
//			else
//			{
//				if (TToolTipManager.instance.getToolTipInstance(ToolTipName.DEFAULT_HTML))
//				{
//					TToolTipManager.instance.hideTip();
//				}
//				CursorManager.instance.setDefaultCursor();
//			}
		}

		private function onMouseOut(e:MouseEvent, element:BaseElement):void
		{
//			CursorManager.instance.setDefaultCursor();
		}
	}
}
