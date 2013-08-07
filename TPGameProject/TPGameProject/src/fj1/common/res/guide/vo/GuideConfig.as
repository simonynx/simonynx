package fj1.common.res.guide.vo
{
	import fj1.common.GameInstance;

	public class GuideConfig
	{
		public var actionId:int;
		public var taskId:int;
		public var taskType:int;
		public var step:int;
		public var backToStage:int = -1;
		public var arrowDirection:int = -1;
		public var arrowRotation:int;
		public var _gap:Number = 0;
		public var gapX:Number = 0;
		public var gapY:Number = 0;
		public var xOffset:Number = 0;
		public var yOffset:Number = 0;
		public var width:Number = 0;
		public var height:Number = 0;
		public var chatIndex:int = 0;
		public var npcId:int = 0;
		public var npcWidth:int = 0;
		public var npcHeight:int = 0;
		public var autoHideTime:Number = 0; //自动隐藏引导的时间
		public var text:String;
		public var description:String;
		public var description2:String;
		public var useBorder:Boolean = true;
		public var arrowIngoreBorder:Boolean = false;
		public var visible:Boolean = true;
		public var arrowOffsetX:int = 0;
		public var arrowOffsetY:int = 0;
		public var chatActionId:int = 0;
		public var descriptionResloved:String;
		public var description2Resloved:String;
		public var html:Boolean = false;
		public var displayCover:Boolean = false; //是否显示蒙版
		public var useEffect:Boolean = false; //是否显示引导蒙版效果（在显示蒙版前提下才有效）
		public var hideArrow:Boolean = false;
		public var sceneId:int;
		public var itemId:int = 0;
		public var itemId1:int;
		public var itemId2:int;
		public var itemId3:int;
		public var itemId4:int;
		public var item2Id:int = 0;
		public var item2Id1:int;
		public var item2Id2:int;
		public var item2Id3:int;
		public var item2Id4:int;
		public var imgPath:String;
		public var delay:int;
		public var eventTargetLink:String = "";
		public var targetWindowLink:String = "";
		public var targetLink:String = "";
		public var targetParentLink:String = "";
		public var moviePath:String = ""; //影片路径
		public var movieConstrants:String = ""; //影片布局

		public function GuideConfig()
		{
		}

		public function set gap(value:int):void
		{
			_gap = value;
			gapX = _gap;
			gapY = _gap
		}

		public function get gap():int
		{
			return _gap;
		}

		public function get itemIdReal():int
		{
//			if (itemId == 0)
//			{
//				itemId = this["itemId" + GameInstance.mainCharData.professions];
//			}
			return itemId;
		}

		public function get item2IdReal():int
		{
//			if (item2Id == 0)
//			{
//				item2Id = this["item2Id" + GameInstance.mainCharData.professions];
//			}
			return item2Id;
		}

		public function get movieConstrantsObj():Object
		{
			var ret:Object = {};
			if (!movieConstrants)
			{
				return ret;
			}
			var parms:Array = movieConstrants.split(",");
			for each (var parm:String in parms)
			{
				var values:Array = parm.split(":");
				ret[values[0]] = parseInt(values[1]);
			}
			return ret;
		}
	}
}
