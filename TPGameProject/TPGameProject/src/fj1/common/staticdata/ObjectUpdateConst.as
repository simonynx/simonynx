package fj1.common.staticdata
{

	public class ObjectUpdateConst
	{
		public static const UPDATETYPE_VALUES:uint = 0; //更新值
		public static const UPDATETYPE_CREATE_OBJECT:uint = 1; //创建对象
		public static const UPDATETYPE_CREATE_HERO:uint = 2; //创建英雄
		public static const UPDATETYPE_QUERY_OBJECT:uint = 3; //其?它¨¹玩ª?家¨°查¨¦询¡¥OBJECT属º?性?
		///////////////////////////
		public static const OBJECT_FIELD_ENTRY:uint = 0x0000;
		public static const OBJECT_END:uint = 0x0003;
		public static const ITEM_END:uint = OBJECT_END + 0x0008;
		public static const EQUIP_END:uint = ITEM_END + 0x0025;
		public static const WORLDOBJECT_END:uint = OBJECT_END + 0x0005;
		public static const DYNAMICOBJECT_END:uint = WORLDOBJECT_END + 0x0002;
		public static const DROPITEM_END:uint = DYNAMICOBJECT_END + 0x0001;
		public static const MAGICWARD_END:uint = DYNAMICOBJECT_END + 0x0006;
		public static const UNIT_END:uint = WORLDOBJECT_END + 0x0019;
		public static const PLAYER_END:uint = UNIT_END + 0x0086;
		public static const PET_END:uint = UNIT_END + 0x0028;
		public static const REPLACE:Object = {"OBJECT_FIELD_ENTRY": OBJECT_FIELD_ENTRY, "OBJECT_END": OBJECT_END, "ITEM_END": ITEM_END, "EQUIP_END": EQUIP_END, "WORLDOBJECT_END": WORLDOBJECT_END, "UNIT_END": UNIT_END,
				"DYNAMICOBJECT_END": DYNAMICOBJECT_END, "DROPITEM_END": DROPITEM_END, "MAGICWARD_END": MAGICWARD_END, "PLAYER_END": PLAYER_END, "PET_END": PET_END};

		public function ObjectUpdateConst()
		{
		}
	}
}
