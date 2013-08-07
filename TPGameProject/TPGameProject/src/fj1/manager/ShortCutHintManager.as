package fj1.manager
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.DataObject;
	import fj1.common.helper.StringFormatHelper;
	import fj1.common.res.hint.HintResManager;
	import fj1.common.res.hint.ShortCutHintResMananger;
	import fj1.common.res.hint.vo.BaseHintConfig;
	import fj1.common.res.hint.vo.HintData;
	import fj1.common.res.hint.vo.ShortCutHintConfig2;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ColorConst;
	import fj1.common.staticdata.HintConst;
	import fj1.common.staticdata.ShortCutHintConst;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.mainui.view.components.ShortCutHintPanel;
	import flash.profiler.profile;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.staticdata.Colors;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.TWindowPool;
	import tempest.ui.components.TWindow;
	import tempest.ui.events.TWindowEvent;
	import tempest.utils.HtmlUtil;
	import tempest.utils.StringUtil;

	/**
	 * 快捷提示管理器，用于显示管理逻辑触发的快捷提示
	 * @author linxun
	 *
	 */
	public class ShortCutHintManager
	{
		private static const log:ILogger = TLog.getLogger(ShortCutHintManager);
		private static var _windowPool:TWindowPool;
		private static var _showingWindowList:Vector.<ShortCutHintPanel> = new Vector.<ShortCutHintPanel>();
		/**
		 * 开启/去除快捷提示的等级限制
		 */
		public static var levelLimited:Boolean = true;

		private static function get windowPool():TWindowPool
		{
			return _windowPool ||= new TWindowPool("ShortCutHint", ShortCutHintPanel);
		}

		/**
		 * 显示提示
		 * @param singleId 标示当前显示窗口是唯一的，相同singleId的窗口只可能出现一个
		 * @param hintId 提示ID，对应提示配置
		 * @param obj 提示对应显示的物品
		 * @param handler
		 * @param params
		 *
		 */
		public static function show(singleId:int, hintId:int, obj:DataObject, handler:Function, ... params):ShortCutHintPanel
		{
			var hintConfig:ShortCutHintConfig2 = ShortCutHintResMananger.get(hintId);
			if (levelLimited &&
				(GameInstance.mainCharData.level < hintConfig.level || (hintConfig.maxLevel > 0 && GameInstance.mainCharData.level > hintConfig.maxLevel)))
			{
				return null;
			}
			if (hintConfig.closed || !hintConfig.enabled)
			{
				return null;
			}
			//显示窗口
			var window:ShortCutHintPanel
			window = getSingleWindow(singleId); //根据singleId区别重复窗口
			if (!window)
			{
				window = findWindowByData(obj); //根据data区别重复窗口
			}
			if (window)
			{
				//已存在窗口，置顶
				window.moveToTop();
			}
			else
			{
				//不存在窗口，打开新的
				window = ShortCutHintPanel(windowPool.showWindow());
				window.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
				_showingWindowList.push(window);
			}
			//更新窗口数据
			window.hintId = hintId;
			window.titleText = hintConfig.title;
			window.content = StringFormatHelper.format.apply(null, [hintConfig.content].concat(params));
			window.btnText = hintConfig.buttonText;
			window.ensureHandler = handler;
			window.data = obj;
			window.singleId = singleId;
			return window;
		}

		/**
		 *
		 * @param hintId
		 * @param enabled
		 *
		 */
		public static function setEnabled(hintId:int, enabled:Boolean):void
		{
			var hintConfig:ShortCutHintConfig2 = ShortCutHintResMananger.get(hintId);
			hintConfig.enabled = enabled;
		}

		/**
		 *
		 * @param enabled
		 *
		 */
		public static function setAllEnabled(enabled:Boolean):void
		{
			var configDic:Dictionary = ShortCutHintResMananger.configDic;
			for each (var hintConfig:ShortCutHintConfig2 in configDic)
			{
				hintConfig.enabled = enabled;
			}
		}

		/**
		 * 隐藏提示
		 * @param hintId
		 *
		 */
		public static function hide(hintId:int):void
		{
			for each (var panel:ShortCutHintPanel in _showingWindowList)
			{
				if (panel.hintId == hintId)
				{
					panel.closeWindow();
				}
			}
		}

		private static function onWindowClose(event:TWindowEvent):void
		{
			_showingWindowList.splice(_showingWindowList.indexOf(ShortCutHintPanel(event.currentTarget)), 1);
		}

		/**
		 * 获取已经显示的窗口中相同singleId的窗口
		 * @param singleId
		 * @return
		 *
		 */
		private static function getSingleWindow(singleId:int):ShortCutHintPanel
		{
			if (singleId < 0)
			{
				return null;
			}
			for each (var panel:ShortCutHintPanel in _showingWindowList)
			{
				if (panel.singleId == singleId)
				{
					return panel;
				}
			}
			return null;
		}

		/**
		 * 获取已经显示的窗口中相同data的窗口
		 * @param data
		 * @return
		 *
		 */
		private static function findWindowByData(data:Object):ShortCutHintPanel
		{
			if (!data)
			{
				return null;
			}
			for each (var panel:ShortCutHintPanel in _showingWindowList)
			{
				if (panel.data == data)
				{
					return panel;
				}
			}
			return null;
		}

		/**
		 * 关闭提示
		 * @param hintId
		 *
		 */
		public static function disableHint(hintId:int):void
		{
			var hintConfig:ShortCutHintConfig2 = ShortCutHintResMananger.get(hintId);
			hintConfig.closed = true;
		}

		/**
		 * 重新设置面板的文字显示
		 * @param hintId
		 *
		 */
		public static function setHintText(hintId:int):void
		{
			for each (var panel:ShortCutHintPanel in _showingWindowList)
			{
				if (panel.hintId == hintId)
				{
					panel.showTimer(ShortCutHintPanel.TIMES);
				}
			}
		}

		/**
		 * 显示倒计时
		 * @param time 时间的单位是秒
		 *
		 */
		public static function showCountDown(time:int):void
		{
			var shortCutHintPanel:ShortCutHintPanel = show(ShortCutHintConst.ID_ASSITE, 2118, null, function(obj:Object):void
			{
				GameInstance.signal.assist.start.dispatch(1);
			});
			if (shortCutHintPanel)
			{
				shortCutHintPanel.showTimer(time);
			}
		}

		/**
		 *使用神力技能
		 * @param time
		 *
		 */
		public static function showUseGodSKill(time:int):void
		{
			var shortCutHintPanel:ShortCutHintPanel = show(ShortCutHintConst.ID_GODSKILL, 2121, null, function(obj:Object):void
			{
				GameInstance.signal.fight.useGodSkill.dispatch();
			});
			if (shortCutHintPanel)
			{
				shortCutHintPanel.showTimer(time);
			}
		}
	}
}
