package fj1.common.data.dataobject.items
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.items.toolTipShowers.PetEggToolTipShower;
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.pet.PetTemplateInfoManager;
	import fj1.common.staticdata.ItemQuality;
	import fj1.manager.MessageManager;
	import tempest.ui.components.TAlert;
	import tempest.utils.HtmlUtil;

	public class PetEggData extends ItemData
	{
		public function PetEggData(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean = true)
		{
			super(ownerId, guId, info, num, cdEnabled);
			_toolTipShower = new PetEggToolTipShower(this);
		}

		override public function copy():ICopyable
		{
			var item:PetEggData = new PetEggData(_ownerId, guId, itemTemplate, num);
			copyPropertys(item);
			return item;
		}

		/**
		 *使用召唤兽蛋
		 * @return
		 *
		 */
		override public function useObj(onReqSendSuccess:Function = null):Boolean
		{
			if (GameInstance.mainCharData.petIsOpen)
			{
				if (GameInstance.model.pet.petDataArr.length == PetTemplateInfoManager.PET_MAX_NUM)
				{
					MessageManager.instance.addHintById_client(1035, "召唤兽栏已满，请先封印召唤兽释放空位后再解封");
					return false;
				}
				else
				{
					super.useObj();
					return true;
				}
			}
			else
			{
				TAlertHelper.showDialog(1040, "你还未掌握驾驭召唤兽的能力，无法解除封印！", true, TAlert.OK);
				return false;
			}
		}
	}
}
