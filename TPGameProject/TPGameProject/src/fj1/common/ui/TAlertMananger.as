package fj1.common.ui
{
	import fj1.common.helper.TAlertHelper;

	import flash.utils.Dictionary;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.ui.components.TAlert;
	import tempest.ui.components.TWindow;
	import tempest.ui.events.TWindowEvent;

	public class TAlertMananger
	{
		public static const CONTAINER_TYPE_HINT:int = 1;
		public static const CONTAINER_TYPE_DEFAULT:int = 2;

		private static var _showingAlertContainers:Dictionary = new Dictionary();

		private static var _alertShowed:ISignal;

		public static function get alertShowed():ISignal
		{
			return _alertShowed = new Signal();
		}

		/**
		 *
		 * @param managerId
		 * @param content
		 * @param modal
		 * @param flag
		 *
		 */
		private static function internalShowAlert(container:Dictionary, managerId:int, content:String, modal:Boolean = true, flag:uint = 4, closeHandler:Function = null, defaultButtonFlag:uint = 4):TAlert
		{
			var alert:TAlert = TAlert(container[managerId]);
			if (alert)
			{
				alert.closeWindow();
			}
			alert = TAlert.Show(content, "", modal, flag, closeHandler, defaultButtonFlag);
			alert.addEventListener(TWindowEvent.WINDOW_CLOSE, function(event:TWindowEvent):void
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				delete container[managerId];
			});
			container[managerId] = alert;
			return alert;
		}

		private static function addAlert(container:Dictionary, managerId:int, alert:TWindow):void
		{
			var al:TWindow = TWindow(container[managerId]);
			if (al)
			{
				al.closeWindow();
			}
			al = alert;
			al.addEventListener(TWindowEvent.WINDOW_CLOSE, function(event:TWindowEvent):void
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				delete container[managerId];
			});
			container[managerId] = al;
		}

		/**
		 * 显示以type和hintId管理的弹窗
		 * 相同type和hintId的弹窗只会出现一个
		 * (不推荐使用)
		 * @param type
		 * @param hintId
		 * @param content
		 * @param modal
		 * @param flag
		 *
		 */
		public static function showHintAlert(type:int, hintId:int, content:String, modal:Boolean = true, flag:uint = 4, closeHandler:Function = null, defaultButtonFlag:uint = 4):TAlert
		{
			var container:Dictionary = getContainer(CONTAINER_TYPE_HINT);
			var alert:TAlert = TAlert.Show(content, "", modal, flag, closeHandler, defaultButtonFlag);
			addAlert(container, getManagerId(type, hintId), alert);
			alertShowed.dispatch(alert, getManagerId(type, hintId), CONTAINER_TYPE_HINT);
			return alert;
		}

		/**
		 * 显示以alertId管理的弹窗, alertId定义在枚举AlertId中
		 * @param alertId
		 * @param content
		 * @param modal
		 * @param flag
		 * @param closeHandler
		 * @param defaultButtonFlag
		 * @return
		 *
		 */
		public static function showAlert(alertId:int, content:String, modal:Boolean = true, flag:uint = 4, closeHandler:Function = null, defaultButtonFlag:uint = 4):TAlert
		{
			var container:Dictionary = getContainer(CONTAINER_TYPE_DEFAULT);
			var alert:TAlert = TAlert.Show(content, "", modal, flag, closeHandler, defaultButtonFlag);
			addAlert(container, alertId, alert);
			alertShowed.dispatch(alert, alertId, CONTAINER_TYPE_DEFAULT);
			return alert;
		}

		/**
		 * 显示一个较大的alert
		 * @param alertId
		 * @param content
		 * @param modal
		 * @param submitText
		 * @param cancelText
		 * @param autoSize
		 * @param closeHandler
		 * @return
		 *
		 */
		public static function showBiggerAlert(alertId:int, content:String, modal:Boolean = true, submitText:String = "", cancelText:String = "", closeHandler:Function = null):BaseDialog
		{
			var container:Dictionary = getContainer(CONTAINER_TYPE_DEFAULT);
			var alert:BaseDialog = TAlertHelper.showBiggerAlert(content, modal, submitText, cancelText, closeHandler);
			addAlert(container, alertId, alert);
			alertShowed.dispatch(alert, alertId, CONTAINER_TYPE_DEFAULT);
			return alert;
		}

		public static function getHintAlert(type:int, hintId:int):TAlert
		{
			return TAlert(getContainer(CONTAINER_TYPE_HINT)[getManagerId(type, hintId)]);
		}

		public static function getAlert(alertId:int):TAlert
		{
			return TAlert(getContainer(CONTAINER_TYPE_DEFAULT)[alertId]);
		}

		private static function getContainer(cType:int):Dictionary
		{
			var container:Dictionary = _showingAlertContainers[cType];
			if (!container)
			{
				container = new Dictionary();
				_showingAlertContainers[cType] = container;
			}
			return container;
		}

		/**
		 * 通过配置类型（如CONFIG_CLIENT）和hintId组合出管理Id
		 * @param type
		 * @param hintId
		 * @return
		 *
		 */
		public static function getManagerId(type:int, hintId:int):int
		{
			return type * 100000 + hintId;
		}
	}
}
