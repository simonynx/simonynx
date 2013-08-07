package fj1.modules.messageBox.model
{
	import fj1.common.GameInstance;
	import fj1.common.core.*;
	import fj1.common.helper.IconContainerHelper;
	import fj1.manager.FloatIconManager;
	import fj1.modules.friend.dataBehavior.*;
	import fj1.modules.friend.interfaces.IAddDataBehavior;
	import fj1.modules.friend.interfaces.IDelDataBehavior;
	import fj1.modules.friend.interfaces.IInDataBehavior;
	import fj1.modules.messageBox.model.vo.MessageInfo;
	import fj1.modules.messageBox.signals.MessageSignal;
	import flash.display.MovieClip;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.collections.TArrayCollection;

	public class MessageModel
	{
		[Inject]
		public var messageSignal:MessageSignal;
		public var friendMessage:TArrayCollection = new TArrayCollection(); //好友
		public var teamMessage:TArrayCollection = new TArrayCollection(); //队伍
		public var tradeMessage:TArrayCollection = new TArrayCollection(); //交易
		public var guildMessage:TArrayCollection = new TArrayCollection(); //公会
		public var addDataBehavior:IAddDataBehavior; //添加数据
		public var delDataBehavior:IDelDataBehavior; //删除数据
		public var delAllDataBehavior:IDelDataBehavior; //删除所有数据
		public var inDataBehavior:IInDataBehavior; //是否有在数据里

		public function MessageModel()
		{
			addDataBehavior = new AddDataBehavior();
			delDataBehavior = new DelDataBehavior();
			delAllDataBehavior = new DelAllDataBehavior();
			inDataBehavior = new InDataBehavior();
		}

		/**
		 * 清空
		 * @param arr
		 *
		 */
		public function delAll(arr:TArrayCollection, result:int):void
		{
			var messageInfo:MessageInfo;
			for each (messageInfo in arr)
			{
				if (result == MessageInfo.MESSAGE_ALL_AGREE)
					messageInfo.agreeFun(messageInfo);
				else
					messageInfo.disagreeFun(messageInfo);
			}
			delAllData(arr);
		}

		public function findArr(kind:int):TArrayCollection
		{
			switch (kind)
			{
				case MessageInfo.MESSAGE_KIND_FRIEND:
					return friendMessage;
					break;
				case MessageInfo.MESSAGE_KIND_TEAM:
					return teamMessage;
					break;
				case MessageInfo.MESSAGE_KIND_TRADE:
					return tradeMessage;
					break;
				case MessageInfo.MESSAGE_KIND_GUILD:
					return guildMessage;
					break;
			}
			return null;
		}

		public function removeUIAndData():void
		{
			var myImgArea:IconContainerHelper = GameInstance.app.mainUI.messageContainer.getChildByName(IconContainerHelper.NAME) as IconContainerHelper;
			if (!myImgArea)
				return;
			for (var i:int = 0; i < myImgArea.numChildren; i++)
			{
				FloatIconManager.instance.myImgArea.delArr(myImgArea.getChildAt(i));
				myImgArea.removeChildAt(i);
				i--;
			}
			GameInstance.app.mainUI.messageContainer.removeChild(myImgArea);
			delAllData(friendMessage);
			delAllData(teamMessage);
			delAllData(tradeMessage);
			delAllData(guildMessage);
			//删除窗口
			messageSignal.closeMessageBoxPanel.dispatch();
		}

		public function getMessageBoxNameByKind(kind:int):String
		{
			switch (kind)
			{
				case MessageInfo.MESSAGE_KIND_FRIEND:
					return FloatIconManager.NAME_FRIEND;
					break;
				case MessageInfo.MESSAGE_KIND_TEAM:
					return FloatIconManager.NAME_TEAM;
					break;
				case MessageInfo.MESSAGE_KIND_TRADE:
					return FloatIconManager.NAME_TRADE;
					break;
				case MessageInfo.MESSAGE_KIND_GUILD:
					return FloatIconManager.NAME_GUILD;
					break;
			}
			return "";
		}

		/*******************************公共操作************************************/
		/**
		 * 添加数据
		 * @param data 原始数据对象(TArrayCollection)
		 * @param value 要被添加的对象
		 *
		 */
		public function addData(data:TArrayCollection, value:*):void
		{
			if (data.length >= 10)
				data.removeItemAt(data.length - 1)
			addDataBehavior.addData(data, value);
		}

		/**
		 * 删除数据
		 * @param data 原始数据对象(TArrayCollection)
		 * @param value 要被删除的对象的id
		 *
		 */
		public function delData(data:TArrayCollection, value:*):void
		{
			delDataBehavior.delData(data, value);
		}

		/**
		 * 删除全部
		 * @param data
		 *
		 */
		public function delAllData(data:TArrayCollection):void
		{
			delAllDataBehavior.delData(data);
		}

		/**
		 * 查看是否在数据里
		 * @param data 原始数据对象(TArrayCollection)
		 * @param value 被查询的条件 guid
		 * @return
		 *
		 */
		public function isInData(data:TArrayCollection, value:*):*
		{
			return inDataBehavior.isInData(data, value);
		}
	}
}
