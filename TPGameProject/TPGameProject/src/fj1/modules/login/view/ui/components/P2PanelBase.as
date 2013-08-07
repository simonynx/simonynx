package fj1.modules.login.view.ui.components
{
	import assets.UISecondPSWLib;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.TInputText;
	import fj1.modules.login.model.LoginModel;
	import flash.events.*;
	import flash.text.TextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.TPUGlobals;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TComponent;
	import tempest.utils.Random;

	public class P2PanelBase extends TComponent
	{
		public var txt_pwd:TInputText; //密码
		public var btn_del:TButton; //删除
		public var btn_sure:TButton; //确定
		private var _numGroup:Array = []; //密码键盘
		private var _onOkClick:ISignal;
		private var _currentInput:TInputText;

		public function P2PanelBase(proxy:* = null)
		{
			super({horizontalCenter: 0, verticalCenter: 0}, proxy);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			txt_pwd = new TInputText(null, null, _proxy.txt_pwd);
			btn_del = new TButton(null, _proxy.btn_del, null, clear);
			btn_sure = new TButton(null, _proxy.btn_sure);
			_numGroup = [new TButton(null, _proxy.mc_num.btn_num0, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num1, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num2, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num3, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num4, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num5, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num6, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num7, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num8, null, onNumButtonClickHandler),
				new TButton(null, _proxy.mc_num.btn_num9, null, onNumButtonClickHandler)];
		}

		protected override function init():void
		{
			super.init();
			_proxy.lbl_name.text = LanguageManager.translate(1062, "二次密码");
			_proxy.lbl_pwd.text = LanguageManager.translate(2039, "輸入密碼")
			_proxy.lbl_notice.text = LanguageManager.translate(1063, "数字键每次打开都会随机排列顺序");
			btn_del.text = LanguageManager.translate(100016, "刪除");
			btn_sure.text = LanguageManager.translate(100008, "確定");
			txt_pwd.passwordModel(LoginModel.P2_MAXLENGTH, true);
			txt_pwd.addEventListener(FocusEvent.FOCUS_IN, onForcusIn);
		}

		protected function onForcusIn(e:Event):void
		{
			_currentInput = e.currentTarget as TInputText;
		}

		private function onNumButtonClickHandler(e:Event):void
		{
			if (_currentInput)
			{
				if (_currentInput.text.length < LoginModel.P2_MAXLENGTH)
					_currentInput.appendText((TButton(e.currentTarget).data).toString());
//				TPUGlobals.stage.focus = _currentInput;
				_currentInput.setSelectionToEnd();
			}
		}

		public function reset():void
		{
			//生成键盘
			var numArr:Array = new Array(10);
			for (var i:int = 0; i != 10; i++)
			{
				numArr[i] = _numGroup.splice(Random.range(0, _numGroup.length - 1), 1)[0];
				numArr[i].text = i.toString();
				numArr[i].data = i;
			}
			_numGroup = numArr;
			clear();
		}

		public function clear(e:Event = null):void
		{
			TPUGlobals.stage.focus = txt_pwd;
			//清空密码输入框
			txt_pwd.text = "";
		}

		/**
		 * 确定
		 * @return
		 *
		 */
		public function get onOkClick():ISignal
		{
			return _onOkClick ||= new NativeMappedSignal(btn_sure, MouseEvent.CLICK, MouseEvent).mapTo(function(e:Event):Array
			{
				return returnValues;
			});
		}

		protected function get returnValues():Array
		{
			return null;
		}
	}
}
