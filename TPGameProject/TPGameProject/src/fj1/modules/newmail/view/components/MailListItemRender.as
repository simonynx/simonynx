package fj1.modules.newmail.view.components
{
	import fj1.common.res.lan.LanguageManager;
	import fj1.modules.newmail.model.vo.MailInfo;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import tempest.common.staticdata.Colors;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.components.TCheckBox;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.textFields.TText;

	public class MailListItemRender extends TListItemRender
	{
		public var item:MovieClip;
		public var mc_cbox_select:TCheckBox; //单选
		public var mc_readState:TextField; //读取状态
		public var txt_senderName:TextField; //发送者名字
		public var txt_sendTime:TextField; //发送时间
		public var txt_title:TText; //邮件标题
		public var guid:int;
		public var mc_bound:MovieClip;
		private static var _greenFormat:TextFormat = new TextFormat(null, null, 0x00FF00);
		private static var _redFormat:TextFormat = new TextFormat(null, null, 0xFF0000);

		public function MailListItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			item = _proxy.item;
			item.stop();
			mc_bound = _proxy.mc_bound;
			mc_bound.visible = false;
//			mc_bound = _proxy.mc_bound;
//			mc_bound.visible = false;
			mc_cbox_select = new TCheckBox(null, _proxy.mc_cbox_select, null, MovieClipResModel.MODEL_FRAME_2);
			mc_readState = _proxy.mc_readState;
			txt_senderName = _proxy.txt_senderName;
			txt_sendTime = _proxy.txt_sendTime;
			txt_title = new TText(null, _proxy.txt_title, "");
			txt_title.setByteLimit(12, TText.OL_ADD_TAIL);
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			var mailInfo:MailInfo = MailInfo(value);
			//发件人名称
			txt_senderName.text = mailInfo.senderName;
			//时间
			_proxy.txt_sendTime.text = LanguageManager.translate(10008, "剩余:{0}天", String(MailInfo.MAIL_MAX_DAY - mailInfo.ownTime));
			//标题
			txt_title.text = mailInfo.title;
			//读取状态
			_changeWatcherManger.bindSetter(setTextColor, mailInfo, "readState");
			//图标
			_changeWatcherManger.bindSetter(setMailIcon, mailInfo, "mailIcon");
			//选中状态
			_changeWatcherManger.bindSetter(setCheckBox, mailInfo, "checcked");
		}

		override protected function onClick(event:MouseEvent):void
		{
			if (!_selectable)
				return;
			if (!_selected && !(event.target is SimpleButton))
			{
				dispatchEvent(new Event(Event.SELECT));
			}
		}

		/**
		 * 邮件状态以及对应的颜色
		 * @param value
		 *
		 */
		private function setTextColor(value:int):void
		{
			mc_readState.text = value == MailInfo.STATE_UNREAD ? LanguageManager.translate(10009, "未读取") : LanguageManager.translate(10010, "已阅读");
			mc_readState.setTextFormat(value == MailInfo.STATE_UNREAD ? _redFormat : _greenFormat);
		}

		/**
		 * 邮件图标
		 * @param value
		 *
		 */
		private function setMailIcon(value:int):void
		{
			//邮件类型
			switch (value)
			{
				case MailInfo.MAIL_ICON_ITEM:
					item.gotoAndStop(3);
					break;
				case MailInfo.MAIL_ICON_MONEY:
					item.gotoAndStop(2);
					break;
				case MailInfo.MAIL_ICON_TEXT:
					item.gotoAndStop(1);
					break;
			}
		}

		/**
		 * 选中状态
		 * @param value
		 *
		 */
		private function setCheckBox(value:int):void
		{
			mc_cbox_select.selected = value == MailInfo.MAIL_CHECKED ? true : false;
		}

		/**
		 * 选中效果
		 * @param selected
		 *
		 */
		override protected function changeSelectedEffect(selected:Boolean):void
		{
			if (selected)
			{
				mc_bound.visible = true;
			}
			else
			{
				mc_bound.visible = false;
			}
		}
	}
}


