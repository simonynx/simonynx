package fj1.modules.scene.model
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResPaths;
	import fj1.common.res.map.MapResManager;
	import fj1.common.res.map.vo.TransportRes;
	import fj1.common.res.npc.vo.NpcRes;
	import fj1.common.staticdata.AnimationConst;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.common.staticdata.StatusType;
	import fj1.common.vo.character.Npc;
	import fj1.common.vo.element.Transport;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.ui.Keyboard;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Actor;
	import tempest.common.staticdata.Colors;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.avatar.AvatarPartType;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;
	import tempest.engine.tools.SceneCache;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.vo.map.MapTile;

	import tpe.Input;

	public class SceneModel extends Actor
	{
		private static const log:ILogger = TLog.getLogger(SceneModel);

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
			var npc:Npc;
			list.forEach(function(item:NpcRes, index:int, arr:Array):void
			{
				sc = new SceneCharacter(SceneCharacterType.NPC, GameInstance.scene);
				npc = new Npc(sc, item);
				sc.data = npc;
				sc.id = item.id;
				sc.tile_x = item.pos_x;
				sc.tile_y = item.pos_y;
				sc.dir = item.orient;
				if (!item.template)
				{
					return;
				}
				sc.avatar.addAvatarPart(new AvatarPartData(AvatarPartType.CLOTH, ResPaths.getCharacterPath(item.template.modelId, StatusType.STAND)));
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

		public function loadTransport():Boolean
		{
			SceneCache.transports = {};
			var list:Array = MapResManager.getTransportList(GameInstance.scene.id);
			var trans:Transport = null;
			var mapTile:MapTile = null;
			list.forEach(function(item:TransportRes, index:int, arr:Array):void
			{
				try
				{
					trans = new Transport(item.template.displayId);
					trans.id = item.id;
					trans.mapId = item.mapId;
					trans.tile_x = item.pos_x;
					trans.tile_y = item.pos_y;
					trans.targetMapId = item.template.targetMapId;
					trans.targetCoordX = item.template.target_x;
					trans.targetCoordY = item.template.target_y;
					trans.fullName = item.template.name;
					GameInstance.scene.addElement(trans);
					SceneCache.transports[(trans.tile_x >> 0) + "_" + (trans.tile_y >> 0)] = trans;
					mapTile = GameInstance.scene.mapConfig.getMapTile(trans.tile_x, trans.tile_y);
					if (mapTile)
					{
						mapTile.isTransport = true;
					}
				}
				catch (e:Error)
				{
					log.warn("Transport Error id:{0}", item.id);
				}
			});
			return true;
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
