package fj1.common
{
	import fj1.common.staticdata.AnimationConst;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.common.vo.character.Hero;
	import fj1.common.vo.setting.SettingInfo;
	import fj1.modules.battle.view.components.BattleScene;
	import flash.filters.DropShadowFilter;
	import tempest.common.staticdata.Colors;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.engine.TScene;
	import tempest.engine.graphics.animation.Animation;
	import tempest.ui.DragManager;

	public class GameInstance
	{
		public static var app:GameProject;
		private static var _scene:TScene;
		private static var _decoder:Decoder;
		public static var time_diff:Number = 0;
		private static var _signal:SignalInstance;
		private static var _battleScene:BattleScene;

		public static function get scene():TScene
		{
			if (_scene == null)
			{
				_scene = new TScene();
				DragManager.dropOutTarget = _scene.interactiveLayer;
			}
			return _scene;
		}

		public static function get battleScene():BattleScene
		{
			return _battleScene ||= new BattleScene();
		}

		public static function get decoder():Decoder
		{
			return _decoder ||= new Decoder();
		}

		public static function get signal():SignalInstance
		{
			return _signal ||= new SignalInstance();
		}
		public static var mainChar:SceneCharacter;
		public static var lines:Array;
		public static var roles:Array;
		private static var _mouseOnElement:BaseElement = null;

		public static function get mouseOnElement():BaseElement
		{
			return _mouseOnElement;
		}

		public static function set mouseOnElement(value:BaseElement):void
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
		private static var _selectChar:SceneCharacter;

		public static function get selectChar():SceneCharacter
		{
			return _selectChar;
		}

		public static function set selectChar(value:SceneCharacter):void
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
		private static function isHostile(sc:SceneCharacter):Boolean
		{
			if (sc == GameInstance.mainChar)
			{
				return false;
			}
			return sc.type != SceneCharacterType.NPC;
		}

		public static function get mainCharData():Hero
		{
			return mainChar.data as Hero;
		}

		/**
		 * 将服务器时间转换为本地时间
		 * @param st 服务器时间
		 * @param useSec 服务器时间是否秒
		 * @return 毫秒
		 */
		public static function getLocalTime(st:Number, useSec:Boolean = true):Number
		{
			return time_diff + ((useSec) ? (st * 1000) : st);
		}

		/**
		 * 将本地时间转换为服务器时间
		 * @param ct 本地时间
		 * @return
		 *
		 */
		public static function getServerTime(ct:Number):Number
		{
			return ct - time_diff;
		}
		public static const setting:SettingInfo = new SettingInfo();
	}
}
