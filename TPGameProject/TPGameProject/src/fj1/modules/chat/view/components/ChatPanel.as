package fj1.modules.chat.view.components
{
	import fj1.common.GameInstance;
	import fj1.common.helper.MouseEventHepler;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.ui.WindowGroup;
	import flash.text.TextFormat;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.UIConst;
	import tempest.ui.UIStyle;
	import tempest.ui.components.*;
	import tempest.ui.components.tips.TRichTextToolTip;

	public class ChatPanel extends TLayoutContainer
	{
		public var btn_clean:TButton;
		protected var _radioButtonGroup:TGroup;
		protected var _channelBtnPanel:TComponent;
		public var rbtn_channel_normal:TRadioButton;
		public var rbtn_channel_world:TRadioButton;
		public var rbtn_channel_team:TRadioButton;
		public var rbtn_channel_guild:TRadioButton;
		public var rbtn_channel_round:TRadioButton;
		public var rbtn_channel_private:TRadioButton;
		public var rbtn_channel_mutual:TRadioButton;
		public var rbtn_channel_hearsay:TRadioButton;
		public var rbtn_channel_battleLand:TRadioButton;
		private var _txtFormat:TextFormat = new TextFormat(UIStyle.fontName, UIStyle.fontSize, UIStyle.NORMAL_TEXT, null, null, null, null, null, null, null, null, null, 2);
		private var _goodsToolTip:TRichTextToolTip;
		public var tlist2_chat_content:TList2;
		public var bg:TComponent;
		private var _itemTipWindowGroup:WindowGroup;

		public function ChatPanel(constraints:Object = null, _proxy:* = null)
		{
			super(constraints, _proxy);
			_maxWidth = this.width * 1.5;
			bg = new TComponent({left: 0, right: 0, top: 0, bottom: 0}, _proxy.window_chat);
			this.addChild(bg);
			initOutputArea();
			btn_clean = new TButton(null, _proxy.mc_channels.btn_clean, null);
			btn_clean.toolTipString = LanguageManager.translate(12015, "点击后清空当前聊天频道内所有信息");
			this.addChild(btn_clean);
			initChannelBts();
			MouseEventHepler.forwarding(bg, GameInstance.scene.interactiveLayer); //转移鼠标事件和焦点到场景
			MouseEventHepler.forwarding(_proxy.chat_content, GameInstance.scene.interactiveLayer); //转移鼠标事件和焦点到场景
			_itemTipWindowGroup = new WindowGroup();
		}

		private function initOutputArea():void
		{
			_proxy.vscollbar0.parent.removeChild(_proxy.vscollbar0);
			tlist2_chat_content = new TList2(null, _proxy.chat_content, _proxy.vscollbar0, RichTextFieldRender); //{right: 3, left: 3, top: 3, bottom: 23}
			tlist2_chat_content.constraints = {left: 5, right: width - tlist2_chat_content.width - tlist2_chat_content.x,
					top: tlist2_chat_content.y, bottom: height - tlist2_chat_content.height - tlist2_chat_content.y};
			tlist2_chat_content.scrollLineSize = 18;
			tlist2_chat_content.scrollBarPosType = UIConst.LEFT;
			tlist2_chat_content.verticalGap = -2;
			tlist2_chat_content.autoScroll = true;
			tlist2_chat_content.scrollbarAutoHide = false;
			this.addChild(tlist2_chat_content);
		}

		private function initChannelBts():void
		{
			_radioButtonGroup = new TGroup();
			rbtn_channel_normal = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_normal, LanguageManager.translate(12000, "综合"), ChatConst.CHANNEL_ALL);
			rbtn_channel_world = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_world, LanguageManager.translate(12001, "世界"), ChatConst.CHANNEL_WORLD);
			rbtn_channel_team = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_team, LanguageManager.translate(12003, "队伍"), ChatConst.CHANNEL_TEAM);
			rbtn_channel_guild = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_guild, LanguageManager.translate(12004, "公会"), ChatConst.CHANNEL_GUILD);
			rbtn_channel_round = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_round, LanguageManager.translate(12002, "附近"), ChatConst.CHANNEL_ROUND);
			rbtn_channel_private = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_private, LanguageManager.translate(12007, "密聊"), ChatConst.CHANNEL_PRIVATE);
			rbtn_channel_mutual = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_mutual, LanguageManager.translate(12010, "交互"), ChatConst.CHANNEL_MUTUAL);
			rbtn_channel_hearsay = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_hearsay, LanguageManager.translate(12009, "传言"), ChatConst.CHANNEL_HEARSAY);
			rbtn_channel_battleLand = createChannelBtn(_radioButtonGroup, _proxy.mc_channels.mc_channel_battleLand, LanguageManager.translate(12024, "戰場"), ChatConst.CHANNEL_BATTLELAND);
			_channelBtnPanel = new TComponent({left: 0, top: 0}, _proxy.mc_channels);
		}

		private function createChannelBtn(group:TGroup, proxy:*, name:String, data:int):TRadioButton
		{
			var rbtn:TRadioButton = new TRadioButton(group, null, proxy, name, MovieClipResModel.MODEL_FRAME_4);
			rbtn.data = data;
			this.addChild(rbtn);
			return rbtn;
		}

		private function onTimer():void
		{
//			_timerData.stop();
			tlist2_chat_content.alpha = 0;
		}

		/**
		 * 设置输出频道，当点击输入频道按钮时，连动上面的输出频道的选中
		 */
		public function setOutputChannel(channelId:int):void
		{
			var rbt:TRadioButton = getChannelrbt(channelId);
			if (rbt)
			{
				rbt.select();
			}
		}

		private function getChannelrbt(channelId:int):TRadioButton
		{
			switch (channelId)
			{
				case ChatConst.CHANNEL_ALL:
					return rbtn_channel_normal;
				case ChatConst.CHANNEL_WORLD:
					return rbtn_channel_world;
				case ChatConst.CHANNEL_ROUND:
					return rbtn_channel_round;
				case ChatConst.CHANNEL_TEAM:
					return rbtn_channel_team;
				case ChatConst.CHANNEL_GUILD:
					return rbtn_channel_guild;
				case ChatConst.CHANNEL_INFO:
					return null;
				case ChatConst.CHANNEL_NOTICE:
					return null;
				case ChatConst.CHANNEL_PRIVATE:
					return rbtn_channel_private;
				case ChatConst.CHANNEL_HORN:
					return null;
				default:
					throw new Error("无效的channelId：" + channelId);
			}
		}

		public function set bgAlpha(value:Number):void
		{
//			if (value == 0)
//			{
//				_timerData.reset();
//				_timerData.start();
//			}
//			else
//			{
//				_timerData.reset();
//				_timerData.stop();
//				_tlist2_chat_content.alpha = 1;
//			}
//			_proxy.vscollbar0.alpha = value;
			bg.alpha = value;
//			_btn_clean.alpha = value;
//			var buttons:Array = _radioButtonGroup.radioButtonArray;
//			var len:int = buttons.length;
//			for (var i:int = 0; i < len; ++i)
//			{
//				var bt:TRadioButton = buttons[i] as TRadioButton;
//				bt.alpha = value;
//			}
		}

		public function get bgAlpha():Number
		{
			return bg.alpha;
		}

		override protected function implementSize(width:Number, height:Number):void
		{
		}
	}
}
