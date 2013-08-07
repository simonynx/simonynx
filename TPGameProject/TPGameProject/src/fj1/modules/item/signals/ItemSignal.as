package fj1.modules.item.signals
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.guide.vo.GuideConfig;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;
	import tempest.ui.components.TListItemRender;

	public class ItemSignal extends SignalSet
	{
		public function ItemSignal()
		{
			super();
		}

		public function get showHeroBag():ISignal
		{
			return getSignal("showHeroBag", Signal);
		}

		public function get showHeroDepot():ISignal
		{
			return getSignal("showHeroDepot", Signal);
		}

		/**
		 * 玩家登陆数据下发完成后触发
		 * @return
		 *
		 */
		public function get loginCompleteCheck():ISignal
		{
			return getSignal("loginCompleteCheck", Signal);
		}

		public function get itemDataGuideChanged():ISignal
		{
			return getSignal("itemDataGuideChanged", Signal, GuideConfig, GuideConfig, TListItemRender);
		}

		/**
		 * 物品被成功使用后触发该信号
		 * 参数中包含物品对象（ItemData）
		 * @return
		 *
		 */
		public function get itemUsed():ISignal
		{
			return getSignal("itemUsed", Signal, ItemData);
		}

		/**
		 * 物品发起使用后，实际使用前触发
		 * 参数中包含物品对象（ItemData）
		 * @return
		 *
		 */
		public function get itemPreUse():ISignal
		{
			return getSignal("itemPreUse", Signal, ItemData);
		}

		/**
		 * 获得物品时触发（包括数量增加）
		 * @return
		 *
		 */
		public function get itemAdd():ISignal
		{
			return getSignal("itemAdd", Signal, ItemData);
		}

		/**
		 * 移除（或数量减少）物品时触发（包括数量增加）
		 * @return
		 *
		 */
		public function get itemRemove():ISignal
		{
			return getSignal("itemRemove", Signal, int);
		}

		public function get removeItemByGuid():ISignal
		{
			return getSignal("removeItemByGuid", Signal, int);
		}

		/**
		 *单机背包物品
		 * @return
		 *
		 */
		public function get bagItemClick():ISignal
		{
			return getSignal("bagItemClick", Signal, ItemData);
		}

		/**
		 * 请求切换背包分页
		 * @return
		 *
		 */
		public function get changeBagTabTo():ISignal
		{
			return getSignal("changeBagTabTo", Signal, int);
		}
	}
}
