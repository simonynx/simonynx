package fj1.modules.newmail.model
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.baseConfig.BaseConfigManager;
	import fj1.common.staticdata.BaseConfigKeys;
	import fj1.manager.MessageManager;
	import fj1.modules.newmail.model.vo.MailInfo;
	import tempest.ui.collections.TArrayCollection;

	public class MailModel
	{
		private var _mailListArr:TArrayCollection;
		public var mailDataList:TArrayCollection;
		/**
		 * 向服务器查询的邮件GUID
		 */
		public var guid:int;
		/**
		 * 发件箱的附件列表
		 */
		public var itemList:TArrayCollection = new TArrayCollection([null, null, null, null, null]);
		/**
		 * 从聊天框点击发送邮件储存的名字
		 */
		public var chatName:String = "";
		/**
		 * 服务器下发的邮件guid
		 */
		public var guidArr:Array;
		public var currSendMailNum:int = 0; //今日已发送的邮件数
		private var _maxMailNum:int = 0; //每天发送邮件的最大数量

		public function MailModel()
		{
			mailListArr = new TArrayCollection();
			mailDataList = new TArrayCollection();
			guidArr = [];
		}

		/**
		 * 根据类型获得对应的数组
		 * @return
		 *
		 */
		public function getMailByKind(kind:int):Array
		{
			var mailInfo:MailInfo;
			var arr:Array = [];
			for each (mailInfo in mailListArr)
			{
				if (kind == mailInfo.kind)
				{
					arr.push(mailInfo);
				}
			}
			return arr;
		}

		/**
		 * 获得系统邮件的数组
		 * @return
		 *
		 */
		public function getSysMail():Array
		{
			var mailInfo:MailInfo;
			var arr:Array = [];
			for each (mailInfo in mailListArr)
			{
				if (mailInfo.kind != MailInfo.MAIL_PERSONAL)
				{
					arr.push(mailInfo);
				}
			}
			return arr;
		}

		/**
		 * 根据邮件读取状态获得对应的数组
		 * @return
		 *
		 */
		public function getMailByRead(readState:int):Array
		{
			var mailInfo:MailInfo;
			var arr:Array = [];
			for each (mailInfo in mailListArr)
			{
				if (readState == mailInfo.readState)
				{
					arr.push(mailInfo);
				}
			}
			return arr;
		}

		/**
		 * 判断全选按钮的状态
		 * @param arrData 当前页的数据
		 * @return 真假
		 *
		 */
		public function checkSelectAll(arrData:Array):Boolean
		{
			var mailInfo:MailInfo;
			for each (mailInfo in arrData)
			{
				if (mailInfo.checcked == 0)
					return false;
			}
			return true;
		}

		/**
		 * 改变选中状态
		 * @param guid
		 *
		 */
		public function changeSelectState(guid:int):void
		{
			var mailInfo:MailInfo;
			for each (mailInfo in mailListArr)
			{
				if (guid == mailInfo.guid)
				{
					if (mailInfo.checcked == 0)
						mailInfo.checcked = 1;
					else
						mailInfo.checcked = 0;
				}
			}
		}

		/**
		 * 查询选中的邮件的GUID
		 * @return 邮件GUID数组
		 *
		 */
		public function findSelectMail():Array
		{
			var mailGuidArr:Array = [];
			var mailInfo:MailInfo;
			for each (mailInfo in mailListArr)
			{
				if (mailInfo.checcked == MailInfo.MAIL_CHECKED)
					mailGuidArr.push(mailInfo.guid)
			}
			return mailGuidArr.length == 0 ? null : mailGuidArr;
		}

		/**
		 * 获取邮件数据和改变邮件的已读未读状态
		 * @param guid
		 * @return 返回这条邮件的在列表的信息
		 *
		 */
		public function getAndChangeMailState(guid:int):MailInfo
		{
			var mailInfo:MailInfo;
			for each (mailInfo in mailListArr)
			{
				if (guid == mailInfo.guid)
				{
					if (mailInfo.readState == 0)
					{
						mailInfo.readState = 1;
					}
					return mailInfo;
				}
			}
			return null;
		}

		/**
		 * 初始化邮件选中状态
		 *
		 */
		public function initSelectState():void
		{
			var mailInfo:MailInfo;
			for each (mailInfo in mailListArr)
			{
				if (mailInfo.checcked == 1)
					mailInfo.checcked = 0;
			}
		}

		/**
		 * 全选操作（选择）
		 * @param arrData
		 *
		 */
		public function selectAll(arrData:Array):void
		{
			var mailInfo:MailInfo;
			for each (mailInfo in arrData)
			{
				if (mailInfo.checcked == 0)
					mailInfo.checcked = 1;
			}
		}

		/**
		 * 全选操作（取消）
		 * @param arrData
		 *
		 */
		public function unSelectAll(arrData:Array):void
		{
			var mailInfo:MailInfo;
			for each (mailInfo in arrData)
			{
				if (mailInfo.checcked == 1)
					mailInfo.checcked = 0;
			}
		}

		/**
		 * 根据guid查找mailinfo
		 * @param guid
		 * @return mailinfo
		 *
		 */
		public function getMailInfoByID(guid:int):MailInfo
		{
			var mailInfo:MailInfo;
			for each (mailInfo in mailListArr)
			{
				if (mailInfo.guid == guid)
					return mailInfo;
			}
			return null;
		}

		/**
		 * 删除邮件里面附件和金钱的数据
		 * @param mailInfo 某封邮件的具体数据
		 *
		 */
		public function delAffixAndMoneyData(mailInfo:MailInfo):void
		{
			mailInfo.itemArr = [];
			mailInfo.sendMoney = 0;
			mailInfo.sendMoJin = 0;
			mailInfo.sendStone = 0;
			mailInfo.mailIcon = MailInfo.MAIL_ICON_TEXT;
		}

		/**
		 * 清除发件箱的附件列表
		 *
		 */
		public function delAllItemList():void
		{
			var itemData:ItemData;
			for (var i:int = 0; i < itemList.length; i++)
			{
				if (itemList[i])
				{
					itemData = itemList[i];
					itemData.locked = false;
					itemList[i] = null;
				}
			}
		}

		/**
		 * 删除发件箱的单个附件
		 * @param index 附件的位置
		 *
		 */
		public function delItemList(index:int):void
		{
			var itemData:ItemData;
			if (itemList[index])
			{
				itemData = itemList[index];
				itemData.locked = false;
				itemList[index] = null;
			}
		}

		/**
		 * 添加发件箱的附件
		 * @param itemData 添加的附件
		 * @param index 添加的位置
		 *
		 */
		public function addItemList(itemData:ItemData, index:int):void
		{
			if (itemList[index])
			{
				itemList[index].locked = false;
			}
			itemList[index] = itemData;
			itemData.locked = true;
		}

		public function addItemList2(itemData:ItemData):void
		{
			for (var i:int = 0; i < itemList.length; i++)
			{
				if (!itemList[i])
				{
					itemList[i] = itemData;
					itemData.locked = true;
					return;
				}
			}
			MessageManager.instance.addHintById_client(2060, "附件已满");
		}

		/**
		 * 获取发件箱附件列表物品的ID
		 *
		 */
		public function getItemID():Array
		{
			var arr:Array = [];
			var itemData:ItemData;
			for (var i:int = 0; i < itemList.length; i++)
			{
				if (itemList[i] != null)
				{
					itemData = itemList[i];
					arr.push(itemData.guId);
				}
				else
				{
					arr.push(0);
				}
			}
			return arr;
		}

		/**
		 * 根据邮件ID数组删除邮件
		 * @param guid
		 *
		 */
		public function delMailByIDArr(arr:Array):void
		{
			for (var i:int = 0; i < arr.length; i++)
			{
				var mailInfo:MailInfo;
				for each (mailInfo in mailListArr)
				{
					if (arr[i] == mailInfo.guid)
					{
						mailListArr.removeItem(mailInfo);
						mailDataList.source = mailListArr.source.slice();
						break;
					}
				}
			}
		}

		/**
		 * 按时间排序
		 *
		 */
		public function sortMail():void
		{
			mailListArr.source.sortOn("sendTime", [Array.DESCENDING]);
			mailListArr.source = mailListArr.source;
		}

		/**
		 * 邮件的最大数量
		 * @return
		 *
		 */
		public function get maxMailNum():int
		{
			if (_maxMailNum == 0)
			{
				_maxMailNum = int(BaseConfigManager.getConfig(BaseConfigKeys.MAIL_SEND_MAX_NUM));
			}
			return _maxMailNum;
		}

		/**
		 * 所有邮件列表
		 */
		public function get mailListArr():TArrayCollection
		{
			return _mailListArr;
		}

		/**
		 * @private
		 */
		public function set mailListArr(value:TArrayCollection):void
		{
			_mailListArr = value;
		}
	}
}
