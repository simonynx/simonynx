package fj1.modules.login.view
{
	import fj1.common.GameConfig;
	import fj1.common.GameInstance;
	import fj1.common.config.CustomConfig;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ServerState;
	import fj1.common.vo.line.LineInfo;
	import fj1.modules.login.model.LoginModel;
	import fj1.modules.login.signals.LoginUISignals;
	import fj1.modules.login.view.ui.components.LineSelectPanel;

	import tempest.common.mvc.base.Mediator;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	public class LoginUI_LineSelectPanelMediator extends Mediator
	{
		[Inject]
		public var view:LineSelectPanel;
		[Inject]
		public var model:LoginModel;
		[Inject]
		public var loginUISignals:LoginUISignals;

		public function LoginUI_LineSelectPanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(view.onSelectLine, onSelectLineHandler);
			addSignal(model.signals.linesReceived, onLinesReceived);
		}

		override public function onRemove():void
		{
		}

		private function onLinesReceived(list:Array, newAcc:Boolean):void
		{
			view.lineList.items = list.filter(function(item:LineInfo, index:int, arr:Array):Boolean
			{
				return item.state < ServerState.CLOSE;
			});
			if (view.lineList.items.length > 0)
			{
				view.lineList.selectedIndex = 0;
			}
			if (newAcc && CustomConfig.instance.skip_select_line != 0 && list.length > 0 && LineInfo(list[0]).state < ServerState.FULL)
			{
				onSelectLineHandler(list[0]);
			}
		}

		private function onSelectLineHandler(line:LineInfo):void
		{
			if (line)
			{
				if (line.state >= ServerState.FULL)
				{
					TAlertHelper.showAlert(1720, "服务器已满");
				}
				else
				{
//					TAlert.Show(line.alertStr, "", true, TAlert.OK | TAlert.CANCEL, function(e:TAlertEvent):void
//					{
//						if (e.flag == TAlert.OK)
//						{
					GameConfig.currentLine = line.id;
					loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45004, "正在连接分线服务器..."));
					//发送连接游服请求
					GameClient.Connect(line.host, line.port);
//						}
//					});
				}
			}
		}
	}
}
