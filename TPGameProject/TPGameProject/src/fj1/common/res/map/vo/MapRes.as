package fj1.common.res.map.vo
{
	import fj1.common.GameConfig;
	import fj1.common.res.npc.NpcResManager;

	import flash.geom.Point;

	public class MapRes
	{
		public var id:int;
		public var name:String;
		public var type:int;
		public var resId:int;
		public var canPK:int;
		public var canRevive:int;
		public var revive_x:int;
		public var revive_y:int;
		public var canAssist:int;
		public var canSit:int;
		public var stateFlag:int;
		public var transId:int;
		public var enter_effectpath:String;
		private var _transports:Array;
		private var _npcs:Array;
		private var _creatures:Array;
		private var _currentLine:int = 0;
		//
		public var minxiang_x:int;
		public var minxiang_y:int;
		private var _minxiang_distance:int;
		public var minxiangCenter:Point = null;

		public function get minxiang_distance():int
		{
			if (minxiangCenter == null)
			{
				minxiangCenter = new Point(minxiang_x, minxiang_y);
			}
			return _minxiang_distance;
		}

		public function set minxiang_distance(value:int):void
		{
			_minxiang_distance = value;
		}

		public function get npcs():Array
		{
//			if (_currentLine != GameConfig.currentLine)
//			{
//				_currentLine = GameConfig.currentLine;
//				_npcs = null;
//			}
			return _npcs ||= NpcResManager.getNpcList(this.id, _currentLine % 10);
		}
//
//		public function get transports():Array
//		{
//			return _transports ||= MapResManager.getTransportList(this.id);
//		}
//
//		public function getCreatures(type:int):Array
//		{
//			return _creatures ||= MapResManager.getCreatureList(this.id).filter(function(item:CreatureRes, index:int, arr:Array):Boolean
//			{
//				return item.type == (type & item.type);
//			});
//		}
	}
}
