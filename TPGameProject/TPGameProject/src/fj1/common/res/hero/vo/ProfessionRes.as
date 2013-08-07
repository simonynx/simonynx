package fj1.common.res.hero.vo
{

	public class ProfessionRes
	{
		public var icons:Array;
		public var descript:String;
		public var gender:int;
		public var id:int;
		private var _gPointDesc:String;
		private var _fPointDesc:String;
		private var _mPointDesc:String;
		private var _tPointDesc:String;
		public var gDesc:String;
		public var hp:Number;
		public var mp:Number;
		public var g:Number;
		public var f:Number;
		public var b:Number;
		public var l:Number;
		public var star_atk:int;
		public var star_def:int;
		public var star_recover:int;
		public var star_eruption:int;

		public function ProfessionRes()
		{
			icons = [];
		}

		public function get gPointDesc():String
		{
			return _gPointDesc;
		}

		public function set gPointDesc(value:String):void
		{
			g = Number(value);
			_gPointDesc = value;
		}

		public function get fPointDesc():String
		{
			return _fPointDesc;
		}

		public function set fPointDesc(value:String):void
		{
			f = Number(value);
			_fPointDesc = value;
		}

		public function get mPointDesc():String
		{
			return _mPointDesc;
		}

		public function set mPointDesc(value:String):void
		{
			b = Number(value.split(",")[0]);
			l = Number(value.split(",")[1]);
			_mPointDesc = value;
		}

		public function get tPointDesc():String
		{
			return _tPointDesc;
		}

		public function set tPointDesc(value:String):void
		{
			hp = Number(value.split(",")[0]);
			mp = Number(value.split(",")[1]);
			_tPointDesc = value;
		}
	}
}
