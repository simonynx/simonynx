package fj1.common.net.tcpLoader
{
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;

	public class QueryForIdByNameLoader extends TCPLoader
	{
		private var _playerName:String;

		public function QueryForIdByNameLoader(playerName:String)
		{
			_playerName = playerName;
			super();
		}

		override public function getGroup():int
		{
			return TCPLoaderGroup.QUERY_PLAYERID_BYNAME;
		}

		override public function load():void
		{
			super.load();
			ChatClient.sendQueryPlayerIdByName(loaderId, _playerName);
		}

		public function get playerName():String
		{
			return _playerName;
		}

		public function get playerId():int
		{
			return int(this.content);
		}
	}
}
