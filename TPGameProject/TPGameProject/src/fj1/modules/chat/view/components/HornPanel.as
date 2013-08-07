package fj1.modules.chat.view.components
{
	import assets.UIHudLib;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Back;
	import fj1.common.GameInstance;
	import fj1.common.helper.MouseEventHepler;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.MenuOperationType;
	import fj1.common.ui.TextFieldMouseDownPlugin;
	import fj1.manager.MessageManager;
	import fj1.modules.chat.helper.ChatStringHelper;
	import fj1.modules.chat.model.ChatLinkAdapterFactory;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.model.interfaces.IChatLinkAdapter;
	import fj1.modules.chat.model.vo.ChatData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import org.osflash.signals.OnceSignal;
	import tempest.common.rsl.TRslManager;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.TPApplication;
	import tempest.ui.UIStyle;
	import tempest.ui.components.MenuListItemRender;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TLayoutContainer;
	import tempest.ui.components.TList;
	import tempest.ui.components.TListMenu;
	import tempest.ui.components.textFields.TRichTextField;
	import tempest.ui.components.textFields.TText;

	public class HornPanel extends TComponent
	{
		private var txtFormat:TextFormat = new TextFormat(UIStyle.fontName, UIStyle.fontSize, UIStyle.NORMAL_TEXT);
		public var rtf_chat_content:TRichTextField;
		public var bg:MovieClip;
		public var mc_word_effect:MovieClip;

		public function HornPanel(constraints:Object = null, _proxy:* = null)
		{
			super(constraints, _proxy);
			mc_word_effect = TRslManager.getInstance(UIHudLib.HORNEFFECT);
			mc_word_effect.y = -15;
			_proxy.bg.visible = false;
			MouseEventHepler.forwarding(_proxy.bg, GameInstance.scene.interactiveLayer); //转移鼠标事件和焦点到场景
			MouseEventHepler.forwarding(_proxy.content, GameInstance.scene.interactiveLayer); //转移鼠标事件和焦点到场景
		}

		override protected function addChildren():void
		{
			//输入框
			initChatOutput();
			super.addChildren();
			bg = _proxy.bg;
		}

		private function initChatOutput():void
		{
			rtf_chat_content = new TRichTextField();
			rtf_chat_content.html = true;
			rtf_chat_content.textfield.selectable = false;
			rtf_chat_content.x = _proxy.content.x;
			rtf_chat_content.y = _proxy.content.y;
			rtf_chat_content.defaultTextFormat = txtFormat;
			rtf_chat_content.textfield.filters = [UIStyle.textBoundFilter];
			rtf_chat_content.setSize(_proxy.content.width, _proxy.content.height);
			rtf_chat_content.textfield.wordWrap = true;
			rtf_chat_content.addPlugin(new TextFieldMouseDownPlugin(GameInstance.scene.interactiveLayer));
			this.addChild(rtf_chat_content);
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			super.invalidateSize(changed);
		}
	}
}
