package fj1.common.ui.tips
{
	import fj1.common.data.interfaces.IDataObject;
	import fj1.common.net.tcpLoader.base.ILoaderFailClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.staticdata.ColorConst;

	import flash.events.Event;
	import flash.text.StyleSheet;

	import mx.core.IFactory;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.common.staticdata.Colors;
	import tempest.ui.UIStyle;
	import tempest.ui.components.tips.TRichTextToolTip;
	import tempest.ui.effects.LoadingCoverEffect;
	import tempest.ui.events.TComponentEvent;
	import tempest.ui.interfaces.IIcon;
	import tempest.ui.interfaces.IToolTipHolder;
	import tempest.utils.HtmlUtil;

	public class LoaderTip extends TRichTextToolTip
	{
		private var _tcpLoader:TCPLoader;
		private var _loadingEffect:LoadingCoverEffect;

		private var _complete:ISignal;

		public function get complete():ISignal
		{
			return _complete;
		}

		public function LoaderTip(_proxy:* = null, mouseFollow:Boolean = false, yOffset:Number = 0, xOffset:Number = 0, maxTipWidth:Number = 100, tipStyleSheet:StyleSheet = null)
		{
			super(_proxy, mouseFollow, yOffset, xOffset, maxTipWidth, tipStyleSheet);
			_loadingEffect = new LoadingCoverEffect(this, 200, 200);
			_complete = new Signal();
			this.addEventListener(TComponentEvent.HIDE, onHide);

		}

		public function get getTipContentHandler():Function
		{
			return this.showParams as Function;
		}

		private function onHide(event:TComponentEvent):void
		{
			if (_tcpLoader)
			{
				_tcpLoader.signals.complete.remove(onLoadComplete); //COMPLETE监听移除
				_tcpLoader.signals.timeOut.remove(onTimeOut);
			}
		}

		override public function set data(value:Object):void
		{
			if (_tcpLoader)
			{
				_tcpLoader.signals.complete.remove(onLoadComplete); //旧的COMPLETE监听移除
				_tcpLoader.signals.timeOut.remove(onTimeOut);
				_tcpLoader.signals.failed.remove(onFailed);
			}
			if (_loadingEffect.playing)
				_loadingEffect.stop();
			if (!value)
			{
				super.data = value;
				return;
			}
			if (!(value is TCPLoader))
			{
				if (getTipContentHandler != null)
				{
					super.data = getTipContentHandler(value);
				}
				else
				{
					if (value is IToolTipHolder)
					{
						super.data = IToolTipHolder(value).toolTipShower;
					}
					else
					{
						//不是TCPLoader，直接赋值数据
						super.data = value;
					}
				}
			}
			else
			{
				_tcpLoader = value as TCPLoader;

				if (!_tcpLoader.completed)
				{
					super.data = null;
					_loadingEffect.play();
					this.measureChildren();
					if (!_tcpLoader.loading)
						_tcpLoader.load();
					_tcpLoader.signals.complete.add(onLoadComplete);
					_tcpLoader.signals.timeOut.add(onTimeOut);
					_tcpLoader.signals.failed.add(onFailed);
				}
				else
				{
					if (_tcpLoader.failed)
					{
						showFailContent(_tcpLoader);
					}
					else
					{
						var content:IToolTipHolder = IToolTipHolder(_tcpLoader.content);
						if (content)
						{
							if (getTipContentHandler != null)
							{
								super.data = getTipContentHandler(content);
							}
							else
							{
								super.data = content.toolTipShower;
							}
						}
					}
				}
			}
		}

		public function get completed():Boolean
		{
			if (!data)
			{
				return false;
			}
			if (!(data is TCPLoader))
			{
				return true;
			}
			return _tcpLoader.completed;
		}

		private function showFailContent(loader:TCPLoader):void
		{
			var iLoaderFailClient:ILoaderFailClient = loader as ILoaderFailClient;
			if (iLoaderFailClient)
			{
				if (_loadingEffect.playing)
					_loadingEffect.stop();
				if (getTipContentHandler != null)
				{
					super.data = getTipContentHandler(iLoaderFailClient.contentWhenFail);
				}
				else
				{
					super.data = IToolTipHolder(iLoaderFailClient.contentWhenFail).toolTipShower;
				}
			}
		}

		private function onLoadComplete(loader:TCPLoader):void
		{
			if (_loadingEffect.playing)
				_loadingEffect.stop();
			var content:IToolTipHolder = IToolTipHolder(_tcpLoader.content);
			if (content)
			{
				if (getTipContentHandler != null)
				{
					super.data = getTipContentHandler(content);
				}
				else
				{
					super.data = content.toolTipShower;
				}
			}
			complete.dispatch(this);
		}

		private function onFailed(loader:TCPLoader):void
		{
			showFailContent(loader);
		}

		private function onTimeOut(loader:TCPLoader):void
		{
			var iLoaderFailClient:ILoaderFailClient = loader as ILoaderFailClient;
			if (iLoaderFailClient)
			{
				if (_loadingEffect.playing)
					_loadingEffect.stop();
				if (getTipContentHandler != null)
				{
					super.data = getTipContentHandler(iLoaderFailClient.contentWhenTimeOut);
				}
				else
				{
					super.data = IToolTipHolder(iLoaderFailClient.contentWhenTimeOut).toolTipShower;
				}
			}
		}

	}
}
