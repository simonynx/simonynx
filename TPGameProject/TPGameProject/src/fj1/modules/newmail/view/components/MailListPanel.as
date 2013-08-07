package fj1.modules.newmail.view.components
{
	import assets.UIResourceLib;
	import fj1.common.GameInstance;
	import tempest.common.rsl.RslManager;
	import fj1.common.res.lan.LanguageManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.rsl.TRslManager;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TCheckBox;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TGroup;
	import tempest.ui.components.TList;
	import tempest.ui.components.TPageController;
	import tempest.ui.components.TRadioButton;

	public class MailListPanel extends TComponent
	{
		public var mailList:TList;
		public var cbox_selectAll:TCheckBox; //全选
		public var btn_openMail:TButton; //打开邮件
		public var btn_deleteMail:TButton; //删除邮件
		public var txt_tip:TextField; //小提示
		//--------邮件分类-------
		public var group:TGroup;
		public var rbt_all:TRadioButton; //全部
		public var rbt_system:TRadioButton; //系统
		public var rbt_personal:TRadioButton; //个人
		public var rbt_read:TRadioButton; //已读
		public var rbt_unread:TRadioButton; //未读
		//分页
		public var pageController:TPageController;
		//-------------
		private var _openMailSignal:ISignal;
		private var _deleteMailSignal:ISignal;

		public function MailListPanel(proxy:* = null)
		{
			super(null, proxy);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			mailList = new TList(null, _proxy.mc_mailList, null, MailListItemRender, RslManager.getDefinition(UIResourceLib.mailListItem));
			cbox_selectAll = new TCheckBox(null, _proxy.mc_selectAll, null, MovieClipResModel.MODEL_FRAME_2);
			btn_openMail = new TButton(null, _proxy.btn_openMail, LanguageManager.translate(10014, "收取邮件"));
			btn_openMail.visible = false;
			btn_deleteMail = new TButton(null, _proxy.btn_deleteMail, LanguageManager.translate(100016, "删除"));
			txt_tip = _proxy.txt_tip;
			txt_tip.text = LanguageManager.translate(10029, "小提示：邮箱只能存放50封邮件。");
			//选项卡
			group = new TGroup();
			rbt_all = new TRadioButton(group, null, _proxy.mc_tab_all, LanguageManager.translate(100022, "全部"), MovieClipResModel.MODEL_FRAME_4);
			rbt_all.name = "mc_tab_all";
			rbt_system = new TRadioButton(group, null, _proxy.mc_tab_system, LanguageManager.translate(10015, "系统"), MovieClipResModel.MODEL_FRAME_4);
			rbt_system.name = "rbt_system";
			rbt_personal = new TRadioButton(group, null, _proxy.mc_tab_personal, LanguageManager.translate(10016, "个人"), MovieClipResModel.MODEL_FRAME_4);
			rbt_personal.name = "mc_tab_personal";
			rbt_read = new TRadioButton(group, null, _proxy.mc_tab_read, LanguageManager.translate(10017, "已读"), MovieClipResModel.MODEL_FRAME_4);
			rbt_read.name = "mc_tab_read";
			rbt_unread = new TRadioButton(group, null, _proxy.mc_tab_unread, LanguageManager.translate(10018, "未读"), MovieClipResModel.MODEL_FRAME_4);
			rbt_unread.name = "mc_tab_unread";
			//分页
			pageController = new TPageController(_proxy.pageControl);
		}

		/**
		 * 打开邮件
		 * @return
		 *
		 */
		public function get openMailSignal():ISignal
		{
			return _openMailSignal ||= new NativeSignal(btn_openMail, MouseEvent.CLICK, MouseEvent);
		}

		/**
		 * 删除邮件
		 * @return
		 *
		 */
		public function get deleteMailSignal():ISignal
		{
			return _deleteMailSignal ||= new NativeSignal(btn_deleteMail, MouseEvent.CLICK, MouseEvent);
		}
	}
}
