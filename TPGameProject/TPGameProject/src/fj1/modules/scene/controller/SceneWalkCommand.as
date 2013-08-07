package fj1.modules.scene.controller
{
	import fj1.common.GameInstance;
	import fj1.common.net.GameClient;
	import fj1.common.vo.element.Transport;
	import fj1.manager.MessageManager;
	import fj1.modules.scene.net.SceneService;
	import fj1.modules.scene.signals.SceneSignals;

	import tempest.common.logging.*;
	import tempest.common.mvc.base.Command;
	import tempest.engine.SceneCharacter;
	import tempest.engine.signals.SceneAction_Walk;
	import tempest.engine.tools.SceneCache;
	import tempest.engine.vo.map.MapTile;

	public class SceneWalkCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(SceneWalkCommand);

		[Inject]
		public var sceneService:SceneService;

		[Inject]
		public var sceneSignals:SceneSignals;

		public override function getHandle():Function
		{
			return this.onWalk;
		}

		private function onWalk(action:String, char:SceneCharacter, mapTile:MapTile, path:Array):void
		{
			switch (action)
			{
				case SceneAction_Walk.READY:
					this.onMainCharMove();
					break;
				case SceneAction_Walk.THROUGH:
//					GameInstance.signal.mainChar.autoMuse.dispatch();
//					//	SpecialEffectManager.addSound(SoundType.Sound_Walk.toString(), SoundType.walkAutio);
//					if (char.follower != null && char.follower.data != null) //召唤兽非战斗状态
//					{
//						if (Pet(char.follower.data).moveModel == 0)
//						{
//							PetHelper.onCharWalkThrough(char, mapTile);
//						}
//					}
					this.onMainCharMove();
					break;
				case SceneAction_Walk.ARRIVED:
					if (mapTile.isTransport)
					{
//						if (GameInstance.mainCharData.autoFighting)
//						{
//							log.warn("挂机踩到传送点");
//							return;
//						}
						log.info("踩到传送点");
						var trans:Transport = SceneCache.transports[mapTile.tile_x + "_" + mapTile.tile_y];
						if (trans)
						{
							sceneService.sendTransportRequest(trans.id);
						}
					}
					this.onMainCharMove();
					break;
				case SceneAction_Walk.UNABLE:
					MessageManager.instance.addHintById_client(10008, "该位置无法前往");
					log.debug("不能行走。" + mapTile);
					this.onMainCharMove();
					break;
				case SceneAction_Walk.SENDPATH:
					if (char.follower == null)
					{
						sceneService.sendMove(0, 0, path);
					}
					else
					{
						sceneService.sendMove(2, 0, path, char.follower.tile);
					}
					break;
			}
		}

		private function onMainCharMove():void
		{
			sceneSignals.mainCharMove.dispatch();
		}
	}
}
