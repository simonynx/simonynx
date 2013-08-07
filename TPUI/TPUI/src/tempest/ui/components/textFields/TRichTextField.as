package tempest.ui.components.textFields
{
	import com.riaidea.text.RichTextField;

	import flash.events.MouseEvent;
	import flash.text.TextFieldType;

	import tempest.ui.CursorManager;

	public class TRichTextField extends RichTextField
	{
		public function TRichTextField()
		{
			super();

			if (selectable || editable)
			{
				this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
			else
			{
				this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			CursorManager.instance.setDefaultCursor();
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			CursorManager.instance.removeDefaultCursor();
		}

		public function set editable(value:Boolean):void
		{
			if (value)
			{
				this.textfield.type = TextFieldType.INPUT;
				this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
			else
			{
				this.textfield.type = TextFieldType.DYNAMIC;
				this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
		}

		public function get editable():Boolean
		{
			return this.textfield.type == TextFieldType.INPUT ? true : false;
		}

		public function set selectable(value:Boolean):void
		{
			this.textfield.selectable = value;
			if (this.textfield.selectable)
			{
				this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
			else
			{
				this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
		}

		public function get selectable():Boolean
		{
			return this.textfield.selectable;
		}

	}
}
