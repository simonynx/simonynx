package fj1.common.data.dataobject.items.toolTipShowers
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.dataobject.items.PackHolderData;
	import fj1.common.res.lan.LanguageManager;

	import tempest.utils.HtmlUtil;

	public class PackHolderToolTipShower extends ItemToolTipShower
	{
		public function PackHolderToolTipShower(itemData:ItemData)
		{
			super(itemData);
		}

		protected function get packHolderData():PackHolderData
		{
			return PackHolderData(_itemData);
		}

		protected override function getEffectString():String
		{
			if (!packHolderData.wrap)
			{
				return super.getEffectString();
			}
			else
			{
				if (_itemData.itemTemplate.useeffect_descriptionExtend && _itemData.itemTemplate.useeffect_descriptionExtend.length > 0)
				{
					return getHtmlTextWithAlign("left", normalBlue, LanguageManager.translate(2036, "使用效果：") + _itemData.itemTemplate.useeffect_descriptionExtend);
				}
				else
				{
					return "";
				}
			}
		}

		protected override function getDescription():String
		{
			if (!packHolderData.wrap)
			{
				return super.getDescription();
			}
			else
			{
				if (_itemData.itemTemplate.descriptionExtend && _itemData.itemTemplate.descriptionExtend.length > 0)
				{
					return getHtmlTextWithAlign("left", normalGreen, "“" + _itemData.itemTemplate.descriptionExtend + "”");
				}
				else
				{
					return "";
				}
			}
		}
	}
}
