package fj1.common.res.sound.vo
{

	public class SoundEntity
	{
		public var id:int;
		public var name:String;
		public var filename:String;
		public var type:int;

		public function get namePath():String
		{
			return name.split(".")[0];
		}
	}
}
