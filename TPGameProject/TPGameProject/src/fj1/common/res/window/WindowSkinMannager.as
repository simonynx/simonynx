package fj1.common.res.window
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.window.vo.WindowSkinRes;
	import fj1.common.res.window.vo.WindowTemplRes;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.scene.view.components.WaitLoadingUI;

	import flash.utils.Dictionary;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.rsl.TRslManager;
	import tempest.utils.XMLAnalyser;

	/**
	 *窗口皮肤管理
	 * @author zhangyong
	 *
	 */
	public class WindowSkinMannager
	{
		private static const log:ILogger = TLog.getLogger(WindowSkinMannager);
		/**
		 *窗口配置
		 */
		private var _windowTemplList:Dictionary = null;
		/**
		 *皮肤列表
		 */
		private var _windowSkinList:Dictionary = null;
		/**
		 *加载记录
		 */
		private var _cacheLoadedList:Object = null;
		/**
		 *加载列表
		 */
		private var _loadList:Object = null;
		/**
		 *
		 */
		private var _waitList:Object = null;

		public function WindowSkinMannager()
		{
			_windowSkinList = new Dictionary();
			_windowTemplList = new Dictionary();
			_cacheLoadedList = {};
			_loadList = {};
			_waitList = {};
		}
		private static var _instance:WindowSkinMannager;

		public static function get instance():WindowSkinMannager
		{
			return _instance ||= new WindowSkinMannager();
		}

		/**
		 * 皮肤对应窗口配置
		 * @param data
		 *
		 */
		public function loadWindowSkinRes(data:*):Boolean
		{
			var xmlList:XMLList = ResManagerHelper.getXmlList(data);
			if (xmlList)
			{
				var xml:XML = null;
				for each (xml in xmlList)
				{
					var winSkin:WindowSkinRes = new WindowSkinRes();
					XMLAnalyser.parse(xml, winSkin);
					_windowSkinList[winSkin.id] = winSkin;
					var $xmlList:XMLList = xml.children();
					var $xml:XML = null;
					for each ($xml in $xmlList)
					{
						var winRes:WindowTemplRes = new WindowTemplRes();
						XMLAnalyser.parse($xml, winRes);
						winRes.skinId = winSkin.id;
						_windowTemplList[winRes.id] = winRes;
					}
				}
				return true;
			}
			return false;
		}

		/**
		 *等待加载、创建、注册、映射、弹出
		 * @param $name
		 * @param $object
		 * @param parms
		 * @return
		 *
		 */
		public function watingShow(windowName:String, parms:Array, onComplete:Function):void
		{
			var onComplete2:Function = function(winRes:WindowTemplRes, $parms:Array):void
			{
				var $name:String = winRes.name;
				var $object:Object = $parms[0];
				var $cls:Class = $object.panel as Class;
				var $window:BaseWindow = (new $cls(TRslManager.getInstance(winRes.symbol)) as BaseWindow); //(2)创建窗口
				if ($window)
				{
					$window.isCacheAsBitmap = winRes.isCacheAsBitmap;
					$window.isChangeLineClose = winRes.isChangeLineClose;
					$window.isChangeSceneClose = winRes.isChangeSceneClose;
//					$window.isCloseDispose = winRes.isCloseDispose;
					$window.escClose = winRes.isEseClose;
					$window.isUseEffect = winRes.isUseEffect;
					TWindowManager.instance.registerWindow($name, $window); //(3)注册窗口
					if ($object.mediator) //如果需要注册视图
						$object.onComplete($window, $object.mediator); //(4)注册视图object, parentWindow, modal, useCover, dataParms
					TWindowManager.instance.showPopup($parms[1], $window, $parms[2], $parms[3], null, parms[4], parms[5]); //弹出面板
				}
				else
					log.warn("窗口名：{0},类名：{0}必须继承BaseWindow" + winRes.name);
				if (onComplete != null)
				{
					onComplete($window);
				}
			}
			WindowSkinMannager.instance.loadWindowSkin(windowName, onComplete2, parms); //(1)加载皮肤
		}

		/**
		 *加载窗口皮肤
		 * @param windowId
		 *
		 */
		public function loadWindowSkin(windowName:String, onComplete:Function, parms:Array):void
		{
			var winRes:WindowTemplRes = getWindowTemplResByName(windowName);
			if (winRes)
			{
				var key:String = winRes.skinId;
				var skinRes:WindowSkinRes = getWindowSkinRes(key);
				if (skinRes != null)
				{
					if (!hasLoaded(key)) //未加载过
					{
						if (_loadList[key]) //如果相同的包正在加载
						{
							if (_waitList[key] == null)
								_waitList[key] = [];
							_waitList[key].push({winRes: winRes, onComplete: onComplete, parms: parms}); //等待
						}
						else //直接进入加载
							showLoadingWait(winRes, onComplete, parms);
					}
					else
						onComplete(winRes, parms);
				}
				else
				{
					onComplete(winRes, parms);
					log.warn("窗口ID:{0}的资源ID:{1}不存在", winRes.id, winRes.skinId);
				}
			}
			else
			{
				onComplete(winRes, parms);
				log.warn("窗口NAME:{0}不存在", windowName);
			}
		}

		/**
		 *
		 * @param winRes
		 * @param onComplete
		 * @param parms
		 *
		 */
		private function showLoadingWait(winRes:WindowTemplRes, onComplete:Function, parms:Array):void
		{
			_loadList[winRes.skinId] = winRes.skinId;
			var waitLoadingUI:WaitLoadingUI = new WaitLoadingUI(winRes, onComplete, parms);
			GameInstance.app.addChild(waitLoadingUI);
		}

		/**
		 *添加加载记录
		 * @param key
		 * @return
		 *
		 */
		public function addLoadCache(key:String):void
		{
			if (_waitList[key]) //显示等待列表
			{
				while (_waitList[key].length > 0)
				{
					var obj:Object = _waitList[key].pop();
					obj.onComplete(obj.winRes, obj.parms); //直接弹出
				}
			}
			_loadList[key] = null;
			delete _loadList[key];
			_waitList[key] = null;
			delete _waitList[key];
			_cacheLoadedList[key] = key;
		}

		/**
		 *根据窗口名称获取窗口皮肤
		 * @param name
		 * @return
		 *
		 */
		public function getSkinByWindowName(name:String):*
		{
			var windowTemplRes:WindowTemplRes = getWindowTemplResByName(name);
			return TRslManager.getInstance(windowTemplRes.symbol);
		}

		/**
		 *是否已加载过
		 * @param key
		 * @return
		 *
		 */
		public function hasLoaded(key:String):Boolean
		{
			return _cacheLoadedList[key] != null;
		}

		/**
		 *获取窗口配置
		 * @param windowId
		 * @return
		 *
		 */
		public function getWindowSkinRes(skinId:String):WindowSkinRes
		{
			return _windowSkinList[skinId];
		}

		/**
		 *获取窗口配置
		 * @param windowId
		 * @return
		 *
		 */
		public function getWindowTemplRes(windowId:int):WindowTemplRes
		{
			return _windowTemplList[windowId];
		}

		/**
		 *
		 * @param windowName
		 * @return
		 *
		 */
		public function getWindowTemplResByName(windowName:String):WindowTemplRes
		{
			var windowTemplRes:WindowTemplRes = null;
			for each (windowTemplRes in _windowTemplList)
			{
				if (windowTemplRes.name == windowName)
				{
					return windowTemplRes;
				}
			}
			return null;
		}
	}
}
