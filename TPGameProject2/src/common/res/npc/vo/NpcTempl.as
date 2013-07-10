package common.res.npc.vo
{

	public class NpcTempl
	{
		public var id:int;
		public var level:int;
		public var name:String;
		public var type:int;
		public var type2:int;
		public var subtype:int;
		public var modelId:int;
		public var shop_id:int;
		public var headIcoId:int;
		public var dialogText:String;
		public var unDialoglishdialogText:String;
		public var is_turn_face:int;
		public var transport_id:int; //传送ID
		public var begin_datetime:int;
		public var end_datetime:int;
		public var npc_title:String = ""; //NPC称号
		public var top_ico_id:int; //npc头顶图标ID

		public function NpcTempl()
		{
		}
	}
}
