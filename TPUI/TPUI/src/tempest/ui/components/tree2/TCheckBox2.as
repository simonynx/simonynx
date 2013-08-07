package tempest.ui.components.tree2
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TCheckBox;
	import tempest.ui.components.TComponent;

	public class TCheckBox2 extends TComponent
	{
		protected var _cbox_head:TCheckBox;
		protected var _textField:TextField;
		protected var _text:String;
		protected var _currentFrame:int = 1;

		public function TCheckBox2(constraints:Object = null, proxy:* = null, text:String = null, model:int = 0)
		{
			super(constraints, proxy);
			_cbox_head = new TCheckBox(null, _proxy.mc_checkBox, null, MovieClipResModel.MODEL_FRAME_2);
			_cbox_head.addEventListener(Event.CHANGE, onChange);
			_textField = _proxy.label;
		}

		private function onChange(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get textField():TextField
		{
			return _textField;
		}

		public function set selected(value:Boolean):void
		{
			_cbox_head.selected = value;
		}

		public function get selected():Boolean
		{
			return _cbox_head.selected;
		}

		public function set text(value:String):void
		{
			_text = value ? value : "";
			_textField.text = _text;
		}

		public function get text():String
		{
			return _text;
		}

		override public function set enabled(value:Boolean):void
		{
			if (super.enabled == value)
			{
				return;
			}
			super.enabled = value;
			if (!super.enabled)
			{
				this.setFilter(UIStyle.disableFilter);
				this.mouseEnabled = this.mouseChildren = false;
			}
			else
			{
				this.removeFilters();
				this.mouseEnabled = this.mouseChildren = true;
			}
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			_textField.width = _width - _cbox_head.width;
		}
	}
}
