package tempest.ui.components
{

	public interface ITInvalite
	{
		function invalidateSize(changed:Boolean = false):void;
		function invalidatePosition():void;
		function invalidateDisplayList():void;
	}
}
