package tempest.ui.interfaces
{
	import flash.display.DisplayObject;
	
	import tempest.ui.components.tips.TRichTextToolTip;

	public interface IRichTextTipClient extends IToolTipClient
	{
		/**
		 * Tip中图片数据列表
		 * {id: "img", imgUrl: path, defaultImg:defaultBitmapData, w: 36, h: 36, align: "lineHead", marginX:140, marginY:0}
		 * @return
		 *
		 */
		function getImageList():Array

		function getIconImage():DisplayObject;
		/**
		 * TipCSS样式
		 * @return
		 *
		 */
		function getCssType():String
		/**
		 * 获取Tip显示数据
		 * @return
		 *
		 */
		function getTipDataArray(params:Object):Array;
		/**
		 * 获得Tip宽度
		 * @return
		 *
		 */
		function getTipWidth():int

		/**
		 * TIP隐藏触发
		 * 
		 */			
		function onTipHide(tip:TRichTextToolTip):void;
	}
}
