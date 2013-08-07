package fj1.modules.login.view.ui
{
	import fj1.common.config.CustomConfig;
	import fj1.common.res.ResPaths;

	import fj1.modules.login.view.ui.components.*;

	import flash.geom.Rectangle;

	import tempest.ui.TPApplication;
	import tempest.ui.TPUGlobals;
	import tempest.ui.components.*;
	import tempest.utils.Fun;

	public class LoginUI extends TLayoutContainer
	{
		private var _loginPanel:LoginPanel;
		private var _lineSelectPanel:LineSelectPanel;
		private var _roleCreatePanel:RoleCreatePanel;
		private var _p2Panel:P2Panel;
		private var _p2ResetPanel:P2ResetPanel;
		private var _p2SetPanel:P2SetPanel;
		private var _tipPanel:LoginTipPanel;
		private var _currentPanel:TComponent = null;
		private var _loginBG:LoginBackground;

		public function LoginUI()
		{
			super({left: 0, right: 0, top: 0, bottom: 0});
		}

		override protected function addChildren():void
		{
			_loginBG = new LoginBackground({left: 0, right: 0, top: 0, bottom: 0});
			this.addChild(_loginBG);
		}

		protected override function init():void
		{
			super.init();
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			super.invalidateSize();
		}


		public function showTipPanel(tip:String, color:uint = 0xFFFFFF):void
		{
			tipPanel.setLabel(tip, color);
			this.showPanel(tipPanel);
		}

		public function showPanel(panel:TComponent):void
		{
			if (_currentPanel == panel)
			{
				return;
			}
			this.hideAllPanel();
			_currentPanel = panel;
			this.addChild(panel);
		}

		public function hideAllPanel():void
		{
			if (_currentPanel != null)
			{
				if (_currentPanel.parent)
					_currentPanel.parent.removeChild(_currentPanel);
				_currentPanel = null;
			}
		}

		public function show():void
		{
			_loginBG.load(ResPaths.loginBgPath);
			TPUGlobals.app.application.addChild(this);
		}

		public function hide():void
		{
			if (this.parent)
				this.parent.removeChild(this);
			_loginBG.dispose();
		}

		public function get loginPanel():LoginPanel
		{
			return _loginPanel ||= new LoginPanel();
		}

		public function get lineSelectPanel():LineSelectPanel
		{
			return _lineSelectPanel ||= new LineSelectPanel();
		}

		public function get roleCreatePanel():RoleCreatePanel
		{
			return _roleCreatePanel ||= new RoleCreatePanel();
		}

		public function get tipPanel():LoginTipPanel
		{
			return _tipPanel ||= new LoginTipPanel();
		}

		public function get p2Panel():P2Panel
		{
			return _p2Panel ||= new P2Panel();
		}

		public function get p2ResetPanel():P2ResetPanel
		{
			return _p2ResetPanel ||= new P2ResetPanel();
		}

		public function get p2SetPanel():P2SetPanel
		{
			return _p2SetPanel ||= new P2SetPanel();
		}
	}
}
