package fj1.common.ui.boxes
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.ItemNumCounter;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.factories.ItemDataFactory;
	import tempest.ui.UIStyle;
	import tempest.ui.interfaces.IIcon;
	import tempest.ui.interfaces.IToolTipHolder;

	/**
	 * 物品数量显示类
	 * 当物品数量为0时以灰态显示
	 * @author linxun
	 *
	 */
	public class ItemCounterBox extends BaseDataBox
	{
		/**
		 *数量统计
		 */
		private var _numCounter:ItemNumCounter;
		/**
		 *数量变化
		 */
		public var onNumChange:Function = null;
		/**
		 * 是否在数量为0时自动置灰
		 */
		public var autoGray:Boolean;
		private var _needNum:int = 1;

		public function ItemCounterBox(_proxy:* = null, dragBackAreaArray:Array = null)
		{
			autoGray = true;
			super(_proxy, dragBackAreaArray);
		}

		override public function set data(value:Object):void
		{
			if (!value)
			{
				super.data = null;
				changeWatcherMananger.unWatchSetter(setItemNum);
			}
			else
			{
				_numCounter = ItemNumCounter(value);
				var itemData:ItemData = ItemDataFactory.createByID(GameInstance.scene.mainChar.id, 0, _numCounter.templateId);
				if (itemData)
				{
					itemData.needShowNum = true;
					super.data = itemData;
					changeWatcherMananger.bindSetter(setItemNum, _numCounter, "num");
				}
			}
		}

		public function set needShowNum(value:Boolean):void
		{
			(super.data as ItemData).needShowNum = false;
		}

		override public function getTipData():Object
		{
			if (!super.data)
			{
				return null;
			}
			return IToolTipHolder(super.data).toolTipShower;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get itemData():ItemData
		{
			return ItemData(super.data);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get numCounter():ItemNumCounter
		{
			return _numCounter;
		}

		/**
		 *获取物品数量
		 * @return
		 *
		 */
		public function get itemNum():int
		{
			return _numCounter.num;
		}

		/**
		 *设置数量
		 * @param value
		 *
		 */
		private function setItemNum(value:int):void
		{
			if (autoGray)
			{
				if (value < _needNum)
				{
					this.filters = [UIStyle.disableFilter];
				}
				else
				{
					this.filters = null;
				}
			}
			var itemdata:ItemData = ItemData(super.data);
			itemdata.num = value;
			if (onNumChange != null)
			{
				onNumChange(value);
			}
		}

		/**
		 * 设置需求的最小数量
		 * 如果autoGray == true且当前数量小于需求最小数量时，格子将被置灰
		 * @param value
		 *
		 */
		public function set needNum(value:int):void
		{
			if (_needNum == value)
			{
				return;
			}
			_needNum = value;
			if (autoGray)
			{
				if (value < _needNum)
				{
					this.filters = [UIStyle.disableFilter];
				}
				else
				{
					this.filters = null;
				}
			}
		}

		public function get needNum():int
		{
			return _needNum;
		}
	}
}
