package fj1.common.net.gamehandler.objupdate
{
	import fj1.common.GameInstance;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.ObjectType;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.common.vo.character.Player;
	import fj1.modules.main.MainFacade;
	import fj1.modules.scene.signals.SceneSignals;

	import tempest.common.net.IPacketHandler;
	import tempest.common.net.vo.TPacketIn;
	import tempest.core.ISocket;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;

	public class ObjectDestoryHandler implements IPacketHandler
	{


		/**
		 *
		 * @param socket
		 * @param packet
		 */
		public function handPacket(socket:ISocket, packet:TPacketIn):void
		{
			var count:uint = packet.readUnsignedShort();
			for (var i:int = 0; i != count; i++)
			{
				var guid:int = packet.readUnsignedInt();
				var objectType:int = (uint(guid) * 0.000000001) >> 0;
				switch (objectType)
				{
					case ObjectType.TYPEID_PLAYER: //移除玩家
						var player:SceneCharacter = GameInstance.scene.getCharacterById(guid);
						if (player)
						{
							if (!player.isMainChar)
							{
								if (player.follower != null)
								{
									GameInstance.scene.removeCharacterById(player.follower.id); //移除第三方玩家的召唤兽
									player.follower = null;
								}
							}
						}
						GameInstance.scene.removeCharacterById(guid);
//						GameInstance.model.team.onScenePlayerRemove(guid); //解除绑定
//						GameInstance.model.team.delData(GameInstance.model.team.nearPlayerListData, guid); //附近玩家
						sceneSignal.removeCharacter.dispatch(guid);
						break;
					case ObjectType.TYPEID_MONSTER:
						GameInstance.scene.removeCharacterById(guid);
						sceneSignal.removeCharacter.dispatch(guid);
						break;
					case ObjectType.TYPEID_PET:
//						var pet:SceneCharacter = GameInstance.scene.getCharacterById(guid);
//						if (pet)
//						{
//							var master:SceneCharacter = GameInstance.scene.getCharacterById(Pet(pet.data).masterID);
//							if (master)
//							{
//								master.follower = null;
//							}
//						}
//						GameInstance.scene.removeCharacterById(guid);
//						sceneSignal.removeCharacter.dispatch(guid);
						break;
					case ObjectType.TYPEID_DYNAMICOBJECT:
						GameInstance.scene.removeElementById(guid);
						break;
				}
			}
		}

		private function get sceneSignal():SceneSignals
		{
			return MainFacade.instance.inject.getInstance(SceneSignals) as SceneSignals;
		}
	}
}
