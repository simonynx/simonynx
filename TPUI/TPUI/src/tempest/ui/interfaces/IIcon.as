package tempest.ui.interfaces
{
	import flash.display.BitmapData;

	public interface IIcon extends IToolTipHolder
	{
		/**
		 * 获取图标
		 * @return
		 *
		 */
		function getIconUrl(sizeType:int = -1):String;
		/**
		 *获取物品品质
		 * @return
		 *
		 */
		function get quality():int;
//		/**
//		 * 资源加载失败时的默认图标 
//		 * @return 
//		 * 
//		 */			
//		function getDefaultBitmapData():BitmapData
	}
}
