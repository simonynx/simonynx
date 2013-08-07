package tempest.ui.interfaces
{

	public interface IToolTipClient
	{
		function getTipString(place:int = 0):String
		/**
		 * Tip类型
		 * @return
		 *
		 */
		function getTipType():String
	}
}
