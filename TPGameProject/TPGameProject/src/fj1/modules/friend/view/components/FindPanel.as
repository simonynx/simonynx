package fj1.modules.friend.view.components
{
	import assets.UIResourceLib;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.TInputText;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.rsl.RslManager;
	import tempest.ui.components.TButton;
	import tempest.utils.Fun;

	/**
	 * ...
	 * @author ...
	 */
	public dynamic class FindPanel extends BaseWindow
	{
		public static const NAME:String = "FindPanel";
		//添加好友按钮
		public var btn_friendAdd:TButton;
		//查询好友按钮
		public var btn_search:TButton;
		//添加好友的signal
		private var addFriSignal:ISignal;
		//查看资料的signal
		private var infoSignal:ISignal;
		//查找的signal
		private var searchSignal:ISignal;
		//输入框
		public var tf_search:TInputText;
		public var lbl_name:TextField;
		public var lbl_level:TextField;
		public var lbl_pro:TextField;
		public var lbl_power:TextField;
		public var lbl_state:TextField;

		public function FindPanel(_proxy:*)
		{
			super({horizontalCenter: 0, verticalCenter: 0}, _proxy, NAME);
			btn_friendAdd = new TButton(null, _proxy.btn_Add, LanguageManager.translate(9002, "添加好友"));
			btn_search = new TButton(null, _proxy.btn_search, LanguageManager.translate(9008, "查找"));
			tf_search = new TInputText(null, null, _proxy.tf_search);
			lbl_name = _proxy.lbl_name;
			lbl_level = _proxy.lbl_level;
			lbl_pro = _proxy.lbl_pro;
			lbl_power = _proxy.lbl_power;
			lbl_state = _proxy.lbl_state;
			invalidate();
		}

		//添加好友的signal
		public function get addFri():ISignal
		{
			return addFriSignal ||= new NativeSignal(btn_friendAdd, MouseEvent.CLICK, MouseEvent);
		}

		//查找的signal
		public function get searchFri():ISignal
		{
			return searchSignal ||= new NativeSignal(btn_search, MouseEvent.CLICK, MouseEvent);
		}
	}
}
