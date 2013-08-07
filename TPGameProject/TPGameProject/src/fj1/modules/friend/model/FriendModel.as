package fj1.modules.friend.model
{
	import fj1.common.core.*;
	import fj1.common.staticdata.FriendConst;
	import fj1.modules.friend.dataBehavior.*;
	import fj1.modules.friend.interfaces.IAddDataBehavior;
	import fj1.modules.friend.interfaces.IDelDataBehavior;
	import fj1.modules.friend.interfaces.IEntity;
	import fj1.modules.friend.interfaces.IInDataBehavior;
	import fj1.modules.friend.model.vo.FriendInfo;
	import flash.utils.Dictionary;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.events.CollectionEvent;

	public class FriendModel
	{
//		public static const FRIEND_LIST:int = 0;
//		public static const BLACK_LIST:int = 1;
//		public static const ENEMY_LIST:int = 2;
		private var _containers:Dictionary = new Dictionary();
		//消息提示窗口
		public var friendMessageArr:Array = [];
		//好友列表状态 0好友列表 1黑名单列表 2仇人列表
		private var _friendListState:int;

		public function get friendListState():int
		{
			return _friendListState;
		}

		public function set friendListState(value:int):void
		{
			_friendListState = value;
		}
//		public var friendListState:int;
		public var save_input_word:String; //输入的文本
		public var findInfo:FindInfo;
		private var _autoRefuseRequest:Boolean; //设置是否接受好友要求
		//Behaviors
		public var addDataBehavior:IAddDataBehavior; //添加数据
		public var delDataBehavior:IDelDataBehavior; //删除数据
		public var delAllDataBehavior:IDelDataBehavior; //删除所有数据
		public var inDataBehavior:IInDataBehavior; //是否有在数据里

		/**
		 * 初始化
		 *
		 */
		public function FriendModel()
		{
			//初始化集合行为
			addDataBehavior = new AddDataBehavior();
			delDataBehavior = new DelDataBehavior();
			delAllDataBehavior = new DelAllDataBehavior();
			inDataBehavior = new InDataBehavior();
		}

		public function addContainer(type:int, arrayCollection:TArrayCollection):void
		{
			_containers[type] = arrayCollection;
		}

		/**
		 * 获取是否接受好友要求
		 * @return
		 *
		 */
		public function get autoRefuseRequest():Boolean
		{
			return _autoRefuseRequest;
		}

		/**
		 * 设置是否接受好友要求
		 */
		public function set autoRefuseRequest(value:Boolean):void
		{
			_autoRefuseRequest = value;
		}

		//
		/**
		 * 根据名字查询好友或黑名单或仇人的guid
		 * @param friDataArr
		 * @param _name
		 * @return
		 *
		 */
		public function getItem(friDataArr:TArrayCollection, _name:String):FriendInfo
		{
			var friendInfo:FriendInfo;
			for each (friendInfo in friDataArr)
			{
				if (_name == friendInfo.name)
				{
					return friendInfo;
				}
			}
			return null;
		}

		public function addRelation(type:int, value:IEntity):void
		{
			addEntity(type, value);
			var container:TArrayCollection = getContainer(type);
			switch (type)
			{
				case FriendConst.TYPE_FRIEND:
				case FriendConst.TYPE_BLACK:
				case FriendConst.TYPE_ENEMY:
					sortArray(container);
					break;
			}
		}

		public function sortArray(friDataArr:TArrayCollection):void
		{
			friDataArr.source.sortOn(["online", "level"], [Array.DESCENDING, Array.DESCENDING | Array.NUMERIC]);
			friDataArr.source = friDataArr.source;
			/////////////直接对控件排序//////////////
			//			var s:Sort = new Sort();  
			//			var sortFields:SortField = new SortField("");
			//			s.fields = [sortFields];
			//			friDataArr.sort = s;
			//			friDataArr.refresh();
		}

		public function getFirendInfoByName(name:String):FriendInfo
		{
			var container:TArrayCollection = getContainer(FriendConst.TYPE_FRIEND);
			for each (var entity:FriendInfo in container)
			{
				if (entity.name == name)
				{
					return entity;
				}
			}
			return null;
		}

		/*******************************公共操作************************************/
		/**
		 * 添加数据
		 * @param type
		 * @param value
		 *
		 */
		public function addEntity(type:int, value:IEntity):void
		{
			var container:TArrayCollection = getContainer(type);
			addDataBehavior.addData(container, value);
		}

		/**
		 * 添加数据到列表开头
		 * @param type
		 * @param value
		 *
		 */
		public function addEntityAt(type:int, value:IEntity, index:int):void
		{
			var container:TArrayCollection = getContainer(type);
			container.addItemAt(value, index);
		}

		/**
		 * 删除数据
		 * @param type
		 * @param value
		 *
		 */
		public function removeEntity(type:int, id:int):IEntity
		{
			var container:TArrayCollection = getContainer(type);
			for (var i:int = 0; i < container.length; ++i)
			{
				var info:IEntity = IEntity(container.getItemAt(i));
				if (id == info.id)
				{
					container.removeItemAt(i);
					return info;
				}
			}
			return null;
		}

		/**
		 * 删除全部
		 * @param data
		 *
		 */
		public function delAllData(type:int):void
		{
			var container:TArrayCollection = getContainer(type);
			container.removeAll();
//			delAllDataBehavior.delData(container);
		}

		/**
		 * 获取数据
		 * @param type
		 * @param id
		 * @return
		 *
		 */
		public function getEntity(type:int, id:int):IEntity
		{
			var container:TArrayCollection = getContainer(type);
			for each (var entity:IEntity in container)
			{
				if (entity.id == id)
				{
					return entity;
				}
			}
			return null;
		}

		public function getContainer(type:int):TArrayCollection
		{
			return _containers[type];
		}
	}
}
