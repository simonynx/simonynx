package fj1.modules.messageBox.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class MessageSignal extends SignalSet
	{

		public function MessageSignal()
		{
			super();
		}

		public function get showMessagePanel():ISignal
		{
			return getSignal("showMessagePanel", Signal);
		}

		/**
		 * 全部拒绝和全部取消处理
		 * @return
		 *
		 */
		public function get messageBoxAll():ISignal
		{
			return getSignal("messageBoxAll", Signal);
		}

		/**
		 * 关闭消息盒子
		 * @return
		 *
		 */
		public function get closeMessageBoxPanel():ISignal
		{
			return getSignal("closeMessageBoxPanel", Signal);
		}
	}
}
