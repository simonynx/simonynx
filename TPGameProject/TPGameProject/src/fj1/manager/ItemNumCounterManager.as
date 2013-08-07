package fj1.manager
{
	import fj1.common.data.dataobject.ItemNumCounter;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.modules.item.events.ItemEvent;
	
	import flash.utils.Dictionary;
	
	import mx.events.PropertyChangeEvent;

	public class ItemNumCounterManager
	{
		private var _summerDic:Dictionary;
		private static var _instance:ItemNumCounterManager = null;
		
		public static function get instance():ItemNumCounterManager
		{
			if (_instance == null)
				new ItemNumCounterManager();
			return _instance;
		}
		
		public function ItemNumCounterManager()
		{
			if (_instance != null)
				throw new Error("该类只能创建一个实例");
			_instance = this;
			
			_summerDic = new Dictionary();
			
			with(BagItemManager.instance)
			{
				addEventListener(ItemEvent.ADD, onItemAdd);
				addEventListener(ItemEvent.REMOVE, onItemRemove);
				addEventListener(ItemEvent.UPDATE, onItemUpdate);
			}
		}
		
		/**
		 * 获取物品数量统计对象 
		 * @param templateId
		 * @return 
		 * 
		 */		
		public function getCounter(templateId:int):ItemNumCounter
		{
			var summer:ItemNumCounter = _summerDic[templateId] as ItemNumCounter;
			if(!summer)
				return sumItemNumChange(templateId, 0);
			else
				return summer;
		}
		
		/**
		 * 统计物品数量 
		 * @param templateId
		 * @param numChanged
		 * @return 
		 * 
		 */		
		public function sumItemNumChange(templateId:int, numChanged:int):ItemNumCounter
		{
			var summer:ItemNumCounter = _summerDic[templateId] as ItemNumCounter;
			if(!summer)
			{
				summer = new ItemNumCounter(templateId);
				_summerDic[templateId] = summer;
			}
			summer.num += numChanged;
			return summer;
		}
		
		private function onItemAdd(event:ItemEvent):void
		{
			var itemData:ItemData = event.data as ItemData;
			if(itemData.isValid)
			{
				sumItemNumChange(itemData.templateId, itemData.num);
			}
		}
		
		private function onItemRemove(event:ItemEvent):void
		{
			var itemData:ItemData = event.data as ItemData;
			if(itemData.isValid)
			{
				sumItemNumChange(itemData.templateId, -itemData.num);
			}
		}
		
		private function onItemUpdate(event:ItemEvent):void
		{
			var changeEvent:PropertyChangeEvent = event.data;
			var item:ItemData = ItemData(changeEvent.currentTarget);
			switch(changeEvent.property)
			{
				case "num":
					if(item.isValid)
					{
						sumItemNumChange(item.templateId, int(changeEvent.newValue) - int(changeEvent.oldValue));
					}
					break;
				case "isValid":
					if(changeEvent.newValue)
					{
						//有效
						sumItemNumChange(item.templateId, item.num);
					}
					else
					{
						//失效
						sumItemNumChange(item.templateId, -item.num);
					}
					break;
			}
		}
	}
}