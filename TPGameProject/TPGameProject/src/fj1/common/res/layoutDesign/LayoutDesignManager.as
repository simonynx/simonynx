package fj1.common.res.layoutDesign
{
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.layoutDesign.vo.LayoutDesignInfo;

	public class LayoutDesignManager
	{
		public static var layoutDesignInfoArr:Array = [];
		/**
		 * 加载XML
		 * @param data
		 * @return
		 *
		 */
		public static function initXML(data:*):Boolean
		{
//			return ResManagerHelper.mapArryList(layoutDesignInfoArr, LayoutDesignInfo, data);
			var xmlList:XMLList = ResManagerHelper.getXmlList(data);
			if (xmlList)
			{
				for each (var item:XML in xmlList)
				{
					var layoutDesignInfo:LayoutDesignInfo = new LayoutDesignInfo();
					layoutDesignInfo.id = item.@id;
					var obj:Object = new Object;
					if(item.hasOwnProperty("@left"))
						obj.left = parseInt(item.@left);
					if(item.hasOwnProperty("@right"))
						obj.right = parseInt(item.@right);
					if(item.hasOwnProperty("@top"))
						obj.top = parseInt(item.@top);
					if(item.hasOwnProperty("@bottom"))
						obj.bottom = parseInt(item.@bottom);
					if(item.hasOwnProperty("@horizontalCenter"))
						obj.horizontalCenter = parseInt(item.@horizontalCenter);
					if(item.hasOwnProperty("@verticalCenter"))
						obj.verticalCenter = parseInt(item.@verticalCenter);
					layoutDesignInfo.constraints = obj;
					layoutDesignInfoArr.push(layoutDesignInfo);
				}
				return true;
			}
			return false;
		}
		
		/**
		 * 根据ID获得布局数据 
		 * @param id
		 * @return 
		 * 
		 */		
		public static function getConstraintsByID(id:int):Object
		{
			var layoutDesignInfo:LayoutDesignInfo;
			for each(layoutDesignInfo in layoutDesignInfoArr)
			{
				if(id == layoutDesignInfo.id)
					return layoutDesignInfo.constraints;
			}
			return null;
		}
	}
}