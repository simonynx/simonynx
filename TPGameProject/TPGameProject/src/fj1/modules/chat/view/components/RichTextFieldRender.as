package fj1.modules.chat.view.components
{
	import assets.UIHudLib;
	import com.riaidea.text.plugins.ShortcutPlugin;
	import fj1.common.GameInstance;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.TextFieldMouseDownPlugin;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.model.vo.ChatData;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.textFields.TRichTextField;

	public class RichTextFieldRender extends TListItemRender
	{
		protected var _rtf:TRichTextField;
		protected var _txtFormat:TextFormat = new TextFormat(UIStyle.fontName, UIStyle.fontSize, UIStyle.NORMAL_TEXT, null, null, null, null, null, null, null, null, null, 2);

		public function get rtf():TRichTextField
		{
			return _rtf;
		}

		public function RichTextFieldRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
			initTextField();
			this.addChild(_rtf);
			this.measureChildren();
		}

		protected function initTextField():void
		{
			_rtf = new TRichTextField();
			_rtf.html = true;
			_rtf.selectable = false;
			_rtf.defaultTextFormat = _txtFormat;
			_rtf.textfield.filters = [UIStyle.textBoundFilter];
			_rtf.textfield.autoSize = TextFieldAutoSize.LEFT;
			_rtf.textfield.mouseWheelEnabled = false;
			_rtf.setSize(315, 20);
			_rtf.addPlugin(new TextFieldMouseDownPlugin(GameInstance.scene.interactiveLayer));
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			var mc:MovieClip;
			_rtf.clear();
			var chatHistoryData:ChatData = ChatData(value);
			if (!value)
			{
				return;
			}
			_rtf.append(chatHistoryData.contentBuilded, chatHistoryData.simleys);
			var str:String = _rtf.text.slice(1, 3);
			switch (str)
			{
				case LanguageManager.translate(12005, "龙曜"):
					mc = TRslManager.getInstance(UIHudLib.UI_GAME_GUI_LOGO);
					break;
			}
			if (mc)
				_rtf.replace(0, 4, "", [{src: mc, index: 0}]);
			_rtf.setSize(_rtf.textfield.width, _rtf.textfield.height);
			this.measureChildren();
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			_rtf.setSize(_width, _height);
			_rtf.setSize(_rtf.textfield.width, _rtf.textfield.height);
			//		this.measureChildren();
			_width = _rtf.width;
			_height = _rtf.height;
		}
	}
}
