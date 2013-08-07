package fj1.modules.scene.controller
{
	import fj1.common.GameInstance;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.common.staticdata.WindowName;
	import fj1.common.ui.TWindowManager;
	import fj1.common.vo.character.Npc;
	import fj1.modules.battle.signals.BattleSignals;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.scene.model.SceneModel;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import tempest.common.mvc.base.Command;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.vo.map.MapTile;
	import tempest.engine.vo.move.MoveCallBack;
	import tempest.ui.DragManager;
	import tempest.ui.FetchHelper;

	public class SceneInteractiveCommand extends Command
	{
		[Inject]
		public var sceneModel:SceneModel;
		[Inject]
		public var battleSignals:BattleSignals;
		[Inject]
		public var mailSignal:MailSignal;

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

		/**
		 *检测鼠标手型状态
		 * @return
		 *
		 */
		private static function get checkCursor():Boolean
		{
			if (FetchHelper.instance.isFetching)
			{
				return true;
			}
			if (DragManager.isDraging())
			{
				return true;
			}
			return false;
		}

		private function onMouseDown(e:MouseEvent, element:BaseElement):void
		{
			if (checkCursor)
			{
				return;
			}
			var graphicPoint:Point = new Point(e.localX, e.localY);
			var logicPoint:Point = SceneUtil.Pixel2Tile(graphicPoint);
			if (element is SceneCharacter)
			{
				var eleChar:SceneCharacter = element as SceneCharacter;
				GameInstance.selectChar = element as SceneCharacter;
				var callBack:MoveCallBack = new MoveCallBack();
				switch (element.type)
				{
					case SceneCharacterType.NPC:
						callBack.onWalkArrived = function(char:SceneCharacter, targetTile:MapTile):void //到达NPC回调函数
						{
							eleChar.dir = SceneUtil.getDirection(eleChar.tile, char.tile);
						}
						GameInstance.mainChar.walk(element.tile, -1, 2, callBack);
						break;
					case SceneCharacterType.MONSTER:
						callBack.onWalkArrived = function(char:SceneCharacter, targetTile:MapTile):void //到达NPC回调函数
						{
//							GameInstance.signal.mainChar.talkWithNpc.dispatch(Npc(sc.data).npcRes, null);
							battleSignals.battleStart.dispatch(); //战斗开始
//							mailSignal.showMailPanel.dispatch();
						}
						GameInstance.mainChar.walk(element.tile, -1, 1, callBack);
						break;
				}
			}
			else
			{
				//DEBUG
//				var sc:SceneCharacter = GameInstance.scene.getCharacterById(2000000210);
//				sc.walk(logicPoint, 135, 0, null);
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
			GameInstance.mouseOnElement = element;
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
