package fj1.common.data.dataobject.items
{
	import assets.CursorLib;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.staticdata.FetchType;
	import fj1.common.staticdata.ItemConst;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.FetchHelper;

	public class IdentifierData extends ItemData
	{
		private static const log:ILogger = TLog.getLogger(IdentifierData);

		public function IdentifierData(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean)
		{
			super(ownerId, guId, info, num, cdEnabled);
		}

		override protected function checkUseCondition(onReqSendSuccess:Function = null):Boolean
		{
			//鉴定符类型
			var num:int = FetchType.IDENTIFIER;
			var str:String;
			//根据不同的鉴定符子类型出现不同的手势
			switch (itemTemplate.subtype)
			{
				case ItemConst.SUB_TYPE_IDENTIFY_GREEN:
					str = CursorLib.EQUIPMENT_GREEN;
					break;
				case ItemConst.SUB_TYPE_IDENTIFY_BLUE:
					str = CursorLib.EQUIPMENT_BLUE;
					break;
				case ItemConst.SUB_TYPE_IDENTIFY_PURPLE:
					str = CursorLib.EQUIPMENT_PURPLE;
					break;
				case ItemConst.SUB_TYPE_IDENTIFY_ORANGE:
					str = CursorLib.EQUIPMENT_ORANGE;
					break;
				case ItemConst.SUB_TYPE_IDENTIFY_RED:
					str = CursorLib.EQUIPMENT_RED;
					break;
				case ItemConst.SUB_TYPE_IDENTIFY_SUPER:
					str = CursorLib.EQUIPMENT_SUPER;
					break;
				default:
					log.error("ItemOperateHelper.checkUse()无效的鉴定符类型: " + itemTemplate.subtype);
					break;
			}
			if (FetchHelper.instance.isFetching)
			{
				if (FetchHelper.instance.fetchType != num)
				{
					FetchHelper.instance.begingFetch(num, str, true, this);
				}
				else
				{
					FetchHelper.instance.cancelFetch();
				}
			}
			else
			{
				FetchHelper.instance.begingFetch(num, str, true, this);
			}
			return false;
		}
	}
}
