package fj1.common.res.item
{
	import com.adobe.utils.ArrayUtil;
	import fj1.common.data.dataobject.items.EquipmentData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.item.vo.LuckBoxAwardData;
	import fj1.common.staticdata.ItemConst;
	import flash.utils.Dictionary;
	import tempest.utils.Random;
	import tempest.utils.XMLAnalyser;

	public class LuckBoxAwardPool
	{
		private static var _instance:LuckBoxAwardPool;

		public static function getInstance():LuckBoxAwardPool
		{
			if (!_instance)
			{
				new LuckBoxAwardPool();
			}
			return _instance;
		}
		private var _awardPoolDic:Dictionary = new Dictionary();
		private var _awardPool:Array;

//		private var _bTree:BinarySearchTree;
		public function LuckBoxAwardPool()
		{
//			if (_instance)
//				throw new Error("该类只能有一个实例");
			_instance = this;
			_awardPoolDic = new Dictionary();
			_awardPool = [];
//			_bTree = new BinarySearchTree(compare);
		}

		public function get awarPool():Array
		{
			return _awardPool;
		}
		private var sumRate:Number = 0;

		public function initAddAward(luckBoxData:LuckBoxAwardData):void
		{
			_awardPoolDic[luckBoxData.id] = luckBoxData;
			sumRate += luckBoxData.appear_rate; //累加概率
			luckBoxData.purAppearRate = luckBoxData.appear_rate;
			luckBoxData.appear_rate = sumRate;
			_awardPool.push(luckBoxData);
		}

//		public function load(xml:XML):void
//		{
//			if (xml)
//			{
//				var xmlList:XMLList = xml.*;
//				var arr:Array = XMLAnalyser.getParseList(xml, LuckBoxAwardData);
//				var count:int = 0;
//				var hasReappearItem:Boolean = false;
//				for each (var luckBoxData:LuckBoxAwardData in arr)
//				{
//					_awardPoolDic[luckBoxData.id] = luckBoxData;
//					sumRate += luckBoxData.appear_rate; //累加概率
//					luckBoxData.purAppearRate = luckBoxData.appear_rate;
//					luckBoxData.appear_rate = sumRate;
////					_bTree.insert(luckBoxData);
//					_awardPool.push(luckBoxData);
//					++count;
//				}
//				if (sumRate != 1000000)
//				{
//					throw new Error("初始化错误！奖池中物品出现概率和不等于1");
//				}
//				if (!hasReappearItem && count < ItemConst.LUCK_BOX_SIZE)
//				{
//					throw new Error("初始化错误！奖池中物品都不可重复出现且数量<" + ItemConst.LUCK_BOX_SIZE);
//				}
//			}
//		}
		private function find(rand:int):LuckBoxAwardData
		{
			var item:LuckBoxAwardData;
			for each (item in _awardPool)
			{
				if (item.appear_rate == rand)
				{
					return item;
				}
			}
			return null;
		}

		private function randomFind(iterationCount:int = 0):LuckBoxAwardData
		{
			if (iterationCount >= 50)
			{
				//防止无限递归，递归超过50次时取确定的结果返回
				var item2:LuckBoxAwardData;
				for each (item2 in _awardPool)
				{
					if (!item2.tempDisabled)
					{
						return item2;
					}
				}
				return null;
			}
			var rand:int = Random.range(0, 1000000);
			var itemFound:LuckBoxAwardData;
			var item:LuckBoxAwardData;
			for each (item in _awardPool)
			{
				if (item.appear_rate >= rand)
				{
					itemFound = item;
					break;
				}
			}
			if (itemFound.tempDisabled) //遇到已经被禁用的奖品，重新查找一次
			{
				itemFound = randomFind(++iterationCount);
			}
			return itemFound;
		}

		public function getDataList(exceptId:int, num:int):Array
		{
			var exceptData:LuckBoxAwardData = _awardPoolDic[exceptId];
			if (exceptData && !exceptData.iscan_reappear)
			{
				exceptData.tempDisabled = true; //临时禁用
			}
			var showedItemList:Array = []; //出现过，且不能重复出现的物品
			var resultList:Array = [];
			for (var i:int = 0; i < num; i++)
			{
				var result:LuckBoxAwardData = randomFind();
				if (!result)
				{
					throw new Error("查找抽奖物品出错");
				}
				resultList.push(result.itemData);
				if (!result.iscan_reappear)
				{
					result.tempDisabled = true; //临时禁用
					showedItemList.push(result);
				}
			}
			//将之前删除的重新插入查找树
			for each (var showedItem:LuckBoxAwardData in showedItemList)
			{
				showedItem.tempDisabled = false;
			}
			if (exceptData)
				exceptData.tempDisabled = false;
			return resultList;
		}

		private function compare(left:LuckBoxAwardData, right:LuckBoxAwardData):int
		{
			return left.appear_rate - right.appear_rate;
		}
	}
}
