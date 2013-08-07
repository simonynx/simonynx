package tempest.ui.components.tree2.data
{
	import flash.events.EventDispatcher;

	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.events.TTreeEvent;

	public class TTreeNode extends EventDispatcher
	{
		public var childList:TArrayCollection;
		public var text:String;
		public var level:int;
		public var data:Object;
		public var spreadableAlways:Boolean = false;
		public var levelIndent:int;
		public var dataExtend:int;
		public var selectEnabled:Boolean = true;
		private static const LEVEL_INDENT:int = 18;

		public function TTreeNode(level:int, text:String, childList:TArrayCollection, data:Object = null, spreadableAlways:Boolean = false, levelIndent:int = -1, extend:int = 0, selectEnable:Boolean = true)
		{
			super(this);
			if (levelIndent == -1)
			{
				this.levelIndent = LEVEL_INDENT;
			}
			this.level = level;
			this.text = text;
			this.childList = childList;
			this.data = data;
			this.spreadableAlways = spreadableAlways;
			this.dataExtend = extend;
			this.selectEnabled = selectEnable;
		}

		public function spread():void
		{
			this.dispatchEvent(new TTreeEvent(TTreeEvent.SPREAD_NODE));
		}

		public function spreadAllChildren():void
		{
			spread();
			for each (var subNode:Object in childList)
			{
				if (subNode is TTreeNode)
				{
					TTreeNode(subNode).spreadAllChildren();
				}
			}
		}

		public function retract():void
		{
			this.dispatchEvent(new TTreeEvent(TTreeEvent.RETRACT_NODE));
		}

		public function retractAllChildren():void
		{
			retract();
			for each (var subNode:Object in childList)
			{
				if (subNode is TTreeNode)
				{
					TTreeNode(subNode).retractAllChildren();
				}
			}
		}
	}
}
