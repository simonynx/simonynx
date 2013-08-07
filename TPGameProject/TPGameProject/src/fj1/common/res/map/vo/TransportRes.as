package fj1.common.res.map.vo
{
	import fj1.common.res.map.MapResManager;

	public class TransportRes
	{
		public var id:int;
		public var mapId:int;
		public var pos_x:int;
		public var pos_y:int;
		public var templateId:int;
		private var _template:TransportTempl;

		public function TransportRes()
		{
		}

		public function get template():TransportTempl
		{
			return _template ||= MapResManager.getTransportTempl(this.templateId);
		}
	}
}
