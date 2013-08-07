package fj1.common.net.tcpLoader
{
	import fj1.common.net.GameClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;

	public class NameCheckLoader extends TCPLoader
	{
		private var _playerName:String;

		public function NameCheckLoader(playerName:String)
		{
			_playerName = playerName;
			super();
		}

		override public function getGroup():int
		{
			return TCPLoaderGroup.NAME_CHECK;
		}

		override public function load():void
		{
			super.load();
			GameClient.sendCheckNameRequest(loaderId, _playerName);
		}

		public function get playerName():String
		{
			return _playerName;
		}
	}
}
