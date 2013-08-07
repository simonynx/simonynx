package fj1.modules.scene.view.components
{
	import flash.text.TextField;
	
	import assets.EmbedRes;
	import assets.UISkinLib;
	
	import fj1.common.GameInstance;
	import fj1.common.res.ResPaths;
	import fj1.common.res.window.WindowSkinMannager;
	import fj1.common.res.window.vo.WindowTemplRes;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.rsl.TRslManager;
	import tempest.common.rsl.vo.TRslType;
	import tempest.common.rsl.vo.TRslVO;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TProgressBar;

	/**
	 *加载资源等待窗口
	 * @author zhangyong
	 *
	 */
	public class WaitLoadingUI extends TComponent
	{
		private static const log:ILogger=TLog.getLogger(WaitLoadingUI);
		private var _textFiled:TextField;
		private var _progressBar:TProgressBar;
		private var _parm:Array;
		private var _winRes:WindowTemplRes;
		private var _onComplete:Function;

		public function WaitLoadingUI(winRes:WindowTemplRes, complete:Function, parm:Array)
		{
			super({horizontalCenter: 150, verticalCenter: 0}, new EmbedRes.waitingLoadBar());
			_winRes=winRes;
			_onComplete=complete;
			_parm=parm;
			_progressBar.currentValue=0;
			makeText(0);
			TRslManager.load(_winRes.skinId, ResPaths.getWindowPath(_winRes.skinId), onComplete, onProgress, onError, GameInstance.decoder.decode, TRslType.LIB);
		}

		protected override function addChildren():void
		{
			_progressBar=new TProgressBar(null, _proxy.bar, 0, 100, false);
			_textFiled=_proxy.lbl_value;
			_textFiled.filters=[UIStyle.textBoundFilter];
		}

		/**
		 * 更新进度条
		 * @param tip
		 * @param value
		 */
		public function onProgress(t:TRslVO):void
		{
			var value:int=t.ratioLoaded * 100
			_progressBar.currentValue=value;
			makeText(value);

		}

		/**
		 *设置进度文字
		 * @param value
		 *
		 */
		private function makeText(value:int):void
		{
			_textFiled.text="正在加载 " + value + "%";
		}

		/**
		 * 加载错误
		 * @param t
		 *
		 */
		private function onError(t:TRslVO):void
		{
			log.warn("资源加载错误，请刷新浏览器!-" + t.key);
			throw new Error("资源加载错误，请刷新浏览器!-" + t.key);
		}

		/**
		 *加载完毕
		 * @param t
		 *
		 */
		private function onComplete(t:TRslVO):void
		{
			if (_onComplete != null)
			{
				_onComplete(_winRes, _parm);
				_onComplete=null;
				_winRes=null;
				_parm=null;
			}
			t.unload();
			WindowSkinMannager.instance.addLoadCache(t.key);
			if (this.parent)
				this.parent.removeChild(this);
		}

		protected override function implementSize(width:Number, height:Number):void
		{

		}
	}
}
