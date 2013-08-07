package fj1.modules.login.view.ui.components
{
	import assets.UISecondPSWLib;

	import tempest.common.rsl.RslManager;
	import fj1.common.res.lan.LanguageManager;

	import flash.events.MouseEvent;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeMappedSignal;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.utils.StringUtil;

	/**
	 * 二次密码验证面板
	 * @author wushangkun
	 */
	public class P2Panel extends P2PanelBase
	{
		public var btn_change:TButton; //更改
		private var _onChangeClick:ISignal;

		public function P2Panel()
		{
			super(RslManager.getDefinition(UISecondPSWLib.UI_GAME_GUI_SECONDPSD));
		}

		override protected function addChildren():void
		{
			super.addChildren();
			btn_change = new TButton(null, _proxy.btn_change);
		}

		protected override function init():void
		{
			super.init();
			_proxy.lbl_describe.text = LanguageManager.translate(1064, "登入二次密码");
			btn_change.text = LanguageManager.translate(100050, "更改");
		}

		/**
		 * 更改
		 * @return
		 *
		 */
		public function get onChangeClick():ISignal
		{
			return _onChangeClick ||= new NativeMappedSignal(btn_change, MouseEvent.CLICK, MouseEvent);
		}

		protected override function get returnValues():Array
		{
			return [StringUtil.trim(txt_pwd.text)];
		}
	}
}
