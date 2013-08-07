package fj1.modules.mall.signal
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class MallSignal extends SignalSet
	{
		public function get queryItem():ISignal
		{
			return getSignal("queryItem", Signal);
		}

		public function get queryCategory():ISignal
		{
			return getSignal("queryCategory", Signal);
		}

		public function get updateCategory():ISignal
		{
			return getSignal("updateCategory", Signal);
		}

		public function get loadStart():ISignal
		{
			return getSignal("loadStart", Signal);
		}

		/////////////////////信仰力市场
		/**
		 *税率
		 * @return
		 *
		 */
		public function get beliefRate():ISignal
		{
			return getSignal("beliefRate", Signal, int);
		}

		/**
		 *更新页数
		 * @return
		 *
		 */
		public function get updatePage():ISignal
		{
			return getSignal("updatePage", Signal);
		}

		/**
		 *设置最大页
		 * @return
		 *
		 */
		public function get setCurAndMaxPageFromServer():ISignal
		{
			return getSignal("setCurAndMaxPageFromServer", Signal, int, int);
		}

		/**
		 *设置页数
		 * @return
		 *
		 */
		public function get setPage():ISignal
		{
			return getSignal("setPage", Signal, int);
		}

		public function get updateHostList():ISignal
		{
			return getSignal("updateHostList", Signal, Array);
		}

		/**
		 *购买系统信仰力成功
		 * @return
		 *
		 */
		public function get buySuccees():ISignal
		{
			return getSignal("buySuccees", Signal, int, int);
		}

		/**
		 * 购买物品返回
		 * @return
		 *
		 */
		public function get buyItemRetun():ISignal
		{
			return getSignal("buyItemRetun", Signal);
		}

		/**
		 * 打开商城面板 需要抛出三个参数，第一个是modelId ，打开窗口的模式，第二个参数是itemId，第三个是tabIndex 选项卡页
		 * @return
		 *
		 */
		public function get showMallPanelByLink():ISignal
		{
			return getSignal("showMallPanelByLink", Signal, int, int, int);
		}
	}
}
