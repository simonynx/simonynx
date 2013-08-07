package fj1.common.net.tcpLoader
{
	import fj1.modules.rank.model.vo.RankSummeryItem;
	import fj1.common.net.ChatClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;
	
	import tempest.common.net.vo.TPacketIn;
	
	public class RankSummaryLoader extends TCPLoader
	{
		public function RankSummaryLoader(playerId:int)
		{
			super(playerId);
		}
		
		override public function getGroup():int
		{
			return TCPLoaderGroup.RANK_STAT;
		}
		
		override public function load():void
		{
			super.load();
			ChatClient.sendRankSummeryQuery(loaderId);
		}
		
		override protected function analysisResponse(packet:TPacketIn):Object
		{
			var rankStatArray:Array = [];
			var count:int = packet.readByte();
			for (var i:int = 0; i < count; i++)
			{
				var subCategory:int = packet.readByte();
				var num:int = packet.readByte();
				rankStatArray.push(new RankSummeryItem(subCategory, num));
			}
			return rankStatArray;
		}
	}
}