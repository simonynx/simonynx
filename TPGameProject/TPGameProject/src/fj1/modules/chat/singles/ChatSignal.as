package fj1.modules.chat.singles
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class ChatSignal extends SignalSet
	{
		/**
		 * 设置输入频道
		 * @return
		 *
		 */
		public function get setInputChannel():ISignal
		{
			return getSignal("setInputChannel", Signal);
		}

		/**
		 * 设置输入频道
		 * @return
		 *
		 */
		public function get setOutputChannel():ISignal
		{
			return getSignal("setOutputChannel", Signal);
		}

		/**
		 * 接收聊天消息
		 * @return
		 *
		 */
		public function get resive():ISignal
		{
			return getSignal("resive", Signal);
		}

		/**
		 * 交互频道消息点击处理
		 * @return
		 *
		 */
		public function get processMutualLink():ISignal
		{
			return getSignal("processMutualLink", Signal);
		}

		/**
		 * 密聊按钮的闪烁
		 */
		public function get playPrivateEffect():ISignal
		{
			return getSignal("playPrivateEffect", Signal, Boolean);
		}

		/**
		 * 向输入框中添加物品链接
		 * @return
		 *
		 */
		public function get addLink():ISignal
		{
			return getSignal("addItemLink", Signal);
		}

		/**
		 *向号角输入框中添加物品链接
		 * @return
		 *
		 */
		public function get addHornItemLink():ISignal
		{
			return getSignal("addHornItemLink", Signal);
		}

		/**
		 *光标移回输入框
		 * @return
		 *
		 */
		public function get focusToText():ISignal
		{
			return getSignal("focusToText", Signal);
		}

		/**
		 * 号角播放光效
		 * @return
		 *
		 */
		public function get playNormalEffect():ISignal
		{
			return getSignal("playNormalEffect", Signal);
		}
	}
}
