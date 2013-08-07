package fj1.common.helper
{
	import assets.UIResourceLib;

	import fj1.common.res.hint.HintResManager;
	import fj1.common.res.hint.vo.BaseHintConfig;
	import fj1.common.res.hint.vo.HintConfig;
	import fj1.common.res.hint.vo.HintData;
	import fj1.common.res.hint.vo.ScriptHintConfig;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.HintConst;
	import fj1.common.ui.AutoActionAlert;
	import fj1.common.ui.BaseDialog;
	import fj1.common.ui.TAlertMananger;
	import fj1.common.ui.TWindowManager;

	import flash.utils.Dictionary;

	import tempest.common.logging.*;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TWindowEvent;

	public class TAlertHelper
	{
		private static var log:ILogger = TLog.getLogger(TAlertHelper);

		/**
		 * 通过提示配置显示对话框，可以添加closeHandler回调
		 * @param hintId 提示id
		 * @param defaultHint 默认文本
		 * @param modal 是否模式对话框
		 * @param flags TAlert.OK等
		 * @param closeHandler 关闭窗口回调
		 * @param defaultButtonFlag
		 * @param params 如果提示id对应的是文本格式字符串，此参数为字符串中的文本替换值
		 * @return 创建的TAlert对象
		 *
		 */
		public static function showDialog(hintId:int, defaultHint:String = null, modal:Boolean = true, flags:uint = 0x0004 /*TAlert.OK*/, closeHandler:Function = null, defaultButtonFlag:uint = 0x0004 /*TAlert.OK*/, ... params):TAlert
		{
			var content:String = getContent(HintConst.CONFIG_CLIENT, hintId, defaultHint, params);
			return TAlert.Show(content, "", modal, flags, closeHandler, defaultButtonFlag);
//			return TAlertMananger.show(HintConst.CONFIG_CLIENT, hintId, content, modal, flags, closeHandler, defaultButtonFlag);
		}

		/**
		 *  通过提示配置显示提示框
		 * (不推荐使用)
		 * @param hintId 提示id
		 * @param defaultHint 默认文本
		 * @param params 如果提示id对应的是文本格式字符串，此参数为字符串中的文本替换值
		 * @return 创建的TAlert对象
		 *
		 */
		public static function showAlert(hintId:int, defaultHint:String = null, ... params):TAlert
		{
			var content:String = getContent(HintConst.CONFIG_CLIENT, hintId, defaultHint, params);
			return TAlertMananger.showHintAlert(HintConst.CONFIG_CLIENT, hintId, content, false, TAlert.OK, null, TAlert.OK); //显示以hintId管理的弹窗
		}

		private static function getContent(type:int, hintId:int, defaultHint:String, params:Array):String
		{
			var cfg:BaseHintConfig = HintResManager.getInstance(type).getHintConfig(hintId);
			if (!cfg)
			{
				return StringFormatHelper.format2.apply(null, [defaultHint].concat(params));
			}
			else
			{
				return StringFormatHelper.format2.apply(null, [cfg.pattern].concat(params));
			}
		}

		public static function showScriptDialog(type:int, hintId:int, defaultHint:String = null, modal:Boolean = true, flags:uint = 0x0004 /*TAlert.OK*/, closeHandler:Function = null, defaultButtonFlag:uint =
			0x0004 /*TAlert.OK*/, params:Array = null):TAlert
		{
			var cfg:BaseHintConfig = HintResManager.getInstance(type).getHintConfig(hintId);
			if (!cfg)
			{
				log.error("脚本提示显示错误，找不到提示配置， hintId = " + hintId + ", type = " + type);
				return null;
			}
			else
			{
				var scriptHintConfig:ScriptHintConfig = cfg as ScriptHintConfig;
				if (!scriptHintConfig)
				{
					//
					log.error("脚本提示显示错误，scriptHintConfig == null, 检查提示配置标签是否为scriptAlert， hintId = " + hintId);
					return null;
				}
				if (scriptHintConfig.autoAction != "none" && scriptHintConfig.delay != 0)
				{
					return AutoActionAlert.Show(StringFormatHelper.format2(cfg.pattern, params), "", modal, flags, closeHandler, scriptHintConfig.autoAction, scriptHintConfig.delay, scriptHintConfig.pattern2, defaultButtonFlag);
				}
				else
				{
					return TAlertMananger.showHintAlert(HintConst.CONFIG_CLIENT, hintId, StringFormatHelper.format2(cfg.pattern, params), modal, flags, closeHandler, defaultButtonFlag)
//					return TAlert.Show(hintData.content, "", modal, flags, closeHandler, defaultButtonFlag);
				}
			}
		}

		/**
		 * 显示较大的Alert窗口
		 * @param text
		 * @param modal
		 * @param submitText
		 * @param cancelText
		 * @param autoSize
		 * @return
		 *
		 */
		public static function showBiggerAlert(text:String, modal:Boolean, submitText:String = "", cancelText:String = "", closeHandler:Function = null):BaseDialog
		{
			var alert:BaseDialog = new BaseDialog(UIResourceLib.UI_GAME_GUI_ALERT_SKIN2, "", "", text, submitText, cancelText);
			alert.addEventListener(TWindowEvent.WINDOW_CLOSE, function(e:TWindowEvent):void
			{
				if (closeHandler != null)
				{
					closeHandler();
				}
			});
			TWindowManager.instance.showPopup(null, alert, modal);
			return alert;
		}
	}
}
