package tempest.ui.components
{
	import flash.text.TextFieldAutoSize;

	import tempest.ui.components.textFields.TText;

	public class TLabel extends TText
	{
		public function TLabel(constraints:Object = null, _proxy:* = null, text:String = "", autoSizeType:String = TextFieldAutoSize.NONE, tipString:String = null)
		{
			super(constraints, _proxy, text, autoSizeType);
			if (tipString)
			{
				toolTipString = tipString;
			}
		}

		override protected function addChildren():void
		{
			super.addChildren();
			this.selectable = false;
			this.editable = false;
			this.mouseChildren = this.mouseEnabled = false;
		}
	}
}
