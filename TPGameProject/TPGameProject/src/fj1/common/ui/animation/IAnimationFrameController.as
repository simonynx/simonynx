package fj1.common.ui.animation
{
	import org.osflash.signals.ISignal;

	public interface IAnimationFrameController
	{
		/**
		 * 添加帧率监听函数
		 * @param handler
		 *
		 */
		function addFrameListener(handler:Function):void;
		/**
		 *移除帧率监听函数
		 * @param handler
		 *
		 */
		function removeFrameListener(handler:Function):void;
		/**
		 *
		 * 开始触发
		 */
		function play():void;
		/**
		 * 停止触发
		 *
		 */
		function stop():void;
		function get tick():int;
		function set tick(value:int):void;
	}
}
