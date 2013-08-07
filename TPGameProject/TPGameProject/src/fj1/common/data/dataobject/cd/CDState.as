package fj1.common.data.dataobject.cd
{
	import fj1.common.events.CDEvent;
	import fj1.manager.MessageManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.sampler.getSize;
	import flash.utils.Timer;

	import mx.events.PropertyChangeEvent;

	import tempest.common.logging.*;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.utils.StringUtil;

	[Event(name = "propertyChange", type = "mx.events.PropertyChangeEvent")]
	[Event(name = "start", type = "fj1.common.events.CDEvent")]
	/**
	 * CD状态，控制单个CD的开始和自动结束
	 * @author linxun
	 *
	 */
	public class CDState implements IEventDispatcher
	{
		private var _templateId:int;
		private var _group:CDGroup;
		private var _cdGroupType:int;
		[Bindable]
		public var cdRatio:Number = 0;
		/**
		 *总CD时间
		 */
		public var totalCDTimes:Number;
		private var _cdTimer:TimerData;
		private var _startCDDate:Number;
		private var _endCDDate:Number;
		private var _eventDispatcher:EventDispatcher;
		private static const log:ILogger = TLog.getLogger(CDState);
		/**
		 * 优先级CD列表
		 */
		private var _cdList:Vector.<PriorityCDData>;

		public function CDState(templateId:int, group:CDGroup, cdGroupType:int)
		{
			_templateId = templateId;
			_group = group;
			_cdGroupType = cdGroupType;
			_eventDispatcher = new EventDispatcher(this);
			_cdList = new Vector.<PriorityCDData>();
		}

		/**
		 * 开始冷却
		 * @param freezeTime
		 *
		 */
		public function startCD(freezeTime:Number, priority:int = 3, eventEnable:Boolean = true):void
		{
			startCD2(freezeTime, freezeTime, priority, eventEnable);
		}

		/**
		 * 开始冷却
		 * @param freezeTime
		 *
		 */
		public function startCD2(lastTime:Number, totalTime:Number, priority:int = 3, eventEnable:Boolean = true):void
		{
			totalCDTimes = totalTime;
			if (lastTime > totalTime)
			{
				log.error("CD初始化错误，剩余时间：" + lastTime + "大于总时间：" + totalTime + ", templateId = " + _templateId);
				CONFIG::debugging
				{
					MessageManager.instance.addErrorHint("CD初始化错误，剩余时间：" + lastTime + "大于总时间：" + totalTime + ", templateId = " + _templateId);
				}
				lastTime = totalTime;
					//throw new Error("CD初始化错误，剩余时间："+ lastTime + "大于总时间："+ totalTime);
			}
			if (!_cdTimer)
			{
				_cdTimer = TimerManager.createNormalTimer(50, 0, onFreezeTimer, null, null, null, false);
			}
			//创建该权限的CD数据对象，放入列表中（或重新设置）
			var nowDate:Number = new Date().getTime();
			var newCD:PriorityCDData = getPriorityCDData(priority);
			if (newCD)
			{
				newCD.reset(nowDate, lastTime, totalTime);
			}
			else
			{
				newCD = new PriorityCDData(priority, nowDate, lastTime, totalTime);
				_cdList.push(newCD);
			}
			if (_cdList.length == 1)
			{
				_cdTimer.start();
//				_firstStartDate = new Date().getTime();
				cdRatio = 0;
				_baseLastPercent = 1;
				if (eventEnable)
				{
					if(hasEventListener(CDEvent.CDSTART_EVENT))
					{
						dispatchEvent(new CDEvent(CDEvent.CDSTART_EVENT));
					}
				}
			}
			else
			{
				var maxLastTimeCD:PriorityCDData = getMaxLastTimeCD(nowDate);
				if (newCD == maxLastTimeCD)
				{
					//新设置的CD是当前CD中剩余时间最长的
					_baseLastPercent = 1 - cdRatio; //记录当前百分比
				}
			}
		}

		private function getMaxLastTimeCD(nowDate:Number):PriorityCDData
		{
			var maxLastTimeElement:PriorityCDData = null;
			for (var i:int = 0; i < _cdList.length; i++)
			{
				var element:PriorityCDData = _cdList[i];
				if (!maxLastTimeElement || maxLastTimeElement.getLastTime(nowDate) < element.getLastTime(nowDate))
				{
					maxLastTimeElement = element;
				}
			}
			return maxLastTimeElement;
		}

		/**
		 * 获取当前优先级的冷却CD状态
		 * @param cdPriority
		 * @return
		 *
		 */
		private function getPriorityCDData(cdPriority:int):PriorityCDData
		{
			for (var i:int = 0; i < _cdList.length; i++)
			{
				var element:PriorityCDData = _cdList[i];
				if (element.cdPriority == cdPriority)
				{
					return element;
				}
			}
			return null;
		}

		/**
		 * 停止CD
		 * @param eventEnable
		 *
		 */
		public function stopCD(priority:int, eventEnable:Boolean = true):void
		{
			startCD(0, priority, eventEnable);
		}
		private var _baseLastPercent:Number = 1; //当前剩余cd百分比的基础值（当前cd百分比基于该值计算）

		private function onFreezeTimer():void
		{
			var nowDate:Number = new Date().getTime();
			//删除已经完成的冷却
			for (var i:int = 0; i < _cdList.length; i++)
			{
				var element:PriorityCDData = _cdList[i];
				if (element.isComplete(nowDate))
				{
					_cdList.splice(i, 1);
					i--;
				}
			}
			if (_cdList.length == 0)
			{
				//不存在有效的CD，停止Timer
				_cdTimer.stop();
				cdRatio = 1;
				_baseLastPercent = 0;
//				_firstStartDate = 0;
				if(hasEventListener(CDEvent.CDEND_EVENT))
				{
					dispatchEvent(new CDEvent(CDEvent.CDEND_EVENT));
				}
			}
			else
			{
				//获取当前剩余时间最长的CD进行显示
				var maxLastTimeCD:PriorityCDData = getMaxLastTimeCD(nowDate);
				cdRatio = maxLastTimeCD.getRatio(nowDate) * _baseLastPercent + (1 - _baseLastPercent);
			}
		}

		/**
		 * 是否在CD中
		 * @return
		 *
		 */
		public function inCD():Boolean
		{
			return _cdList && _cdList.length > 0;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}

		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}

		/**
		 *获取冷却剩余时间
		 * @return
		 *
		 */
		public function get lastCDTimes():Number
		{
			return totalCDTimes * (1 - cdRatio) * .001;
		}

		public function get templateId():int
		{
			return _templateId;
		}

		public function get groupId():int
		{
			return _group ? _group.groupId : -1;
		}

		public function get cdGroupType():int
		{
			return _cdGroupType;
		}
	}
}

class PriorityCDData
{
	public var cdPriority:int;
	public var startCDDate:Number;
	public var endCDDate:Number;

	public function PriorityCDData(cdPriority:int, nowDate:Number, lastTime:Number, totalTime:Number)
	{
		this.cdPriority = cdPriority;
		reset(nowDate, lastTime, totalTime);
	}

	public function reset(nowDate:Number, lastTime:Number, totalTime:Number):void
	{
		this.startCDDate = nowDate - (totalTime - lastTime);
		this.endCDDate = nowDate + lastTime;
	}

	public function getRatio(nowDate:Number):Number
	{
		return (nowDate - startCDDate) / (endCDDate - startCDDate);
	}

	public function getTotalTime():Number
	{
		return endCDDate - startCDDate;
	}

	public function getLastTime(nowDate:Number):Number
	{
		var lastTime:Number = endCDDate - nowDate;
		return lastTime > 0 ? lastTime : 0;
	}

	public function isComplete(nowDate:Number):Boolean
	{
		return nowDate >= endCDDate;
	}
}
