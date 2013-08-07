package tempest.common.handler.helper
{

	public class HandlerHelper
	{
		public static function execute(handler:Function, argArray:Array = null, thisArg:* = null):*
		{
			if (handler == null)
			{
				return null;
			}
			return handler.apply(thisArg, argArray);
		}
	}
}
