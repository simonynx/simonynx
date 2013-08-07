package fj1.modules.chat.model.interfaces
{
	import org.osflash.signals.ISignal;

	public interface IChatLinkAdapter
	{
		/**
		 * 构造物品链接的聊天内容
		 * @return
		 *
		 */
		function buildContentLinkMask():String;
		/**
		 * 构造物品链接
		 * @param senderId
		 * @return
		 *
		 */
		function buildItemLink(senderId:int):String;
		/**
		 * 解析的属性个数
		 * @return
		 *
		 */
		function get properNumInContent():int;
		/**
		 * 发送至输入框的名称
		 * @return
		 *
		 */
		function get nameInput():String;
		/**
		 * 链接点击响应
		 *
		 */
		function onTextLink():void;
		/**
		 * 点击链接向外部抛信号
		 * @return
		 *
		 */
		function get textLinkSignal():ISignal;
	}
}
