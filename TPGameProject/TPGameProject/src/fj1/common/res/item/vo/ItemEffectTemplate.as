package fj1.common.res.item.vo
{

	public class ItemEffectTemplate
	{
		public var id:int;
		public var sortId:int; //分类Id
		public var role_modelid:int;
		public var bag_icon:int;
		public var bag_iconExtend:int; //物品背包图标扩展ID
		public var drop_icon:int;
		public var use_sound:int; //物品使用音效
		public var get_sound:int; //物品获得音效
		public var drop_sound:int; //物品掉落音效
		public var can_be_use:Boolean;
		public var description:String;
		public var descriptionExtend:String;
		public var useeffect_description:String;
		public var useeffect_descriptionExtend:String;
		public var alertId:int; //提示框Id
		public var taking_sort:int; //拾取的类别

		public function ItemEffectTemplate()
		{
		}
	}
}
