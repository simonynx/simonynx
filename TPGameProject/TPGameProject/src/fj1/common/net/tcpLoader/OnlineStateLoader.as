package fj1.common.net.tcpLoader
{
	import fj1.common.net.ChatClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;

	import tempest.common.net.vo.TPacketIn;

	public class OnlineStateLoader extends TCPLoader
	{
		private var _playerIdArray:Array;

		public function OnlineStateLoader(playerIdArray:Array)
		{
			_playerIdArray = playerIdArray;
			super();
		}

		override public function getGroup():int
		{
			return TCPLoaderGroup.ONLINE_STATE_BYID;
		}

		override public function load():void
		{
			super.load();
			ChatClient.sendQueryOnlineByGuid(loaderId, _playerIdArray);
		}

		override protected function analysisResponse(packet:TPacketIn):Object
		{
			var len:int = packet.readByte();
			var stateArray:Array = [];
			for (var i:int = 0; i < len; ++i)
			{
				stateArray.push(packet.readInt());
				stateArray.push(packet.readByte() ? true : false);
			}
			return stateArray;
		}

		public function get playerIdArray():Array
		{
			return _playerIdArray;
		}
	}
}
