package fj1.common.data.interfaces
{

	public interface ICountable
	{
		function get needShowNum():Boolean;
		function set needShowNum(value:Boolean):void;
		function get num():int;
		function set num(value:int):void;
		function getNumStr(value:int):String
	}
}
