package fj1.common.net.tcpLoader.base
{
	import fj1.common.net.GameClient;

	import flash.events.Event;

	import org.osflash.signals.Signal;

	import tempest.common.net.vo.TPacketIn;
	import tempest.common.net.vo.TPacketOut;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.events.DataEvent;

	public class TCPLoader
	{
		private var _signals:TCPLoaderSignal;
		private static var _nextId:int = 1;
		private var _loaderId:int;
		private var _completed:Boolean;
		private var _content:Object;
		private var _loading:Boolean;
		private var _failed:Boolean;
		private var _timeOutTimer:TimerData;

		public static const TIME_OUT_TIME:int = 5000; //加载超时时限

		public function get signals():TCPLoaderSignal
		{
			return _signals ||= new TCPLoaderSignal();
		}

		public function getGroup():int
		{
			return TCPLoaderGroup.DEFAULT;
		}

		public function get loaderId():int
		{
			return _loaderId;
		}

		public function get completed():Boolean
		{
			return _completed;
		}

		public function TCPLoader(loaderId:int = -1)
		{
			var loaderManager:TCPLoaderManager = TCPLoaderManager.getInstance(getGroup());
			if (loaderId == -1)
			{
				_loaderId = TCPLoaderGroup.getNextId(getGroup());
			}
			else
			{
				_loaderId = loaderId;
				if (loaderManager.get(_loaderId))
				{
					throw new Error("重复创建loader，请在创建前检查是否已有相同id的loader，调用TCPLoaderManager.get方法获取");
				}
			}
			loaderManager.add(this);
		}

		private function onTimerOut():void
		{
//			_loading = false;
			signals.timeOut.dispatch(this);
		}

		public function load():void
		{
			if (_loading)
				return;
			_loading = true;
			_timeOutTimer = TimerManager.createNormalTimer(TIME_OUT_TIME, 1, null, null, onTimerOut);
		}

		public function get loading():Boolean
		{
			return _loading;
		}

		public function get content():Object
		{
			return _content;
		}

		public function resiveData(packet:TPacketIn):void
		{
			_content = analysisResponse(packet);
			resiveData2(_content);
		}

		public function resiveData2(data:Object):void
		{
			_content = data;
			_completed = true;
			_loading = false;
			_timeOutTimer.stop();
			signals.complete.dispatch(this);
			var loaderManager:TCPLoaderManager = TCPLoaderManager.getInstance(getGroup());
			loaderManager.remove(this.loaderId);
		}

		public function setFailed():void
		{
			_completed = false;
			_loading = false;
			_failed = true;
			_timeOutTimer.stop();
			signals.failed.dispatch(this);
			var loaderManager:TCPLoaderManager = TCPLoaderManager.getInstance(getGroup());
			loaderManager.remove(this.loaderId);
		}

		public function get failed():Boolean
		{
			return _failed;
		}

		protected function analysisResponse(packet:TPacketIn):Object
		{
			return null;
		}
	}
}
import org.osflash.signals.ISignal;
import org.osflash.signals.PrioritySignal;
import org.osflash.signals.Signal;
import org.osflash.signals.utilities.SignalSet;

class TCPLoaderSignal extends SignalSet
{

	public function get complete():ISignal
	{
		return getSignal("complete", PrioritySignal);
	}

	public function get failed():PrioritySignal
	{
		return PrioritySignal(getSignal("failed", PrioritySignal));
	}

	public function get timeOut():ISignal
	{
		return getSignal("timeOut", Signal);
	}
}
