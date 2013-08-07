package fj1.common.net.tcpLoader
{
	import fj1.modules.rank.model.vo.PlayerNameQueryItem;
	import fj1.common.net.ChatClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;
	
	import tempest.common.net.vo.TPacketIn;
	
	public class RankPlayerSearchLoader extends TCPLoader
	{
		private var name:String;
		public function RankPlayerSearchLoader(name:String)
		{
			this.name = name;
			super();
		}
		
		override public function getGroup():int
		{
			return TCPLoaderGroup.RANK_PLAYER;
		}
		
		override public function load():void
		{
			super.load();
			ChatClient.sendRankPlayerQuery(loaderId, name);
		}
		
		override protected function analysisResponse(packet:TPacketIn):Object
		{
			var resultArray:Array = [];
			var count:int = packet.readByte();
			for (var i:int = 0; i < count; i++)
			{
				var playerId:int = packet.readUnsignedInt();
				var name:String = packet.readUTF();
				resultArray.push(new PlayerNameQueryItem(name, playerId));
			}
			return resultArray;
		}

	}
}