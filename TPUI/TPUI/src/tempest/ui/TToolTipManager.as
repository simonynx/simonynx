package tempest.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;

	import tempest.TickCounter;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.tips.TToolTip;
	import tempest.ui.events.TComponentEvent;
	import tempest.ui.events.TToolTipEvent;

	public class TToolTipManager
	{
		private static var _instance:TToolTipManager = null;
		private var name_toolTip_map:Dictionary = new Dictionary();
		private var _showingToolTip:TToolTip;

		private static const SHOW_TIP_DELAY:int = 66; //TIP显示延时

		public function TToolTipManager()
		{
			if (_instance != null)
				throw(new Error("该类不能重复实例化"));
			_instance = this;
		}
		private var _container:DisplayObjectContainer;

		public function initialize(container:DisplayObjectContainer):void
		{
			_container = container;
		}

		public static function get instance():TToolTipManager
		{
			if (_instance == null)
				new TToolTipManager();
			return _instance;
		}

		public function registerToolTip(name:String, toolTip:TToolTip):void
		{
			name_toolTip_map[name] = toolTip;
		}

		public function getToolTipInstance(name:String):TToolTip
		{
			var toolTip:TToolTip = name_toolTip_map[name] as TToolTip;
			if (!toolTip)
			{
				throw new Error("找不到TToolTip 类型：" + name);
			}
			return toolTip;
		}

		/**
		 * 默认TComponent调用
		 * 在TComponent上显示Tip
		 * 将调用TComponent.getTipData()获取Tip显示数据
		 * @param toolTip
		 * @param target
		 *
		 */
		public function showTComponentTip(toolTip:TToolTip, target:TComponent):void
		{
			var tipData:Object = target.getTipData();
			if (tipData)
			{
				showTip(toolTip, target, tipData);
			}
		}

		private var _delayTimer:TimerData;

		/**
		 * 显示Tip
		 * @param toolTip tip实例
		 * @param target tip显示的目标控件
		 * @param data tip显示数据
		 * @param showParams 其他额外参数
		 *
		 */
		public function showTip(toolTip:TToolTip, target:DisplayObject, data:Object, showParams:Object = null):void
		{
			if (_delayTimer)
			{
				_delayTimer.dispose();
				_delayTimer = null;
			}
			_delayTimer = TimerManager.createNormalTimer(SHOW_TIP_DELAY, 1, null, null, function():void
			{
				showTipInternal(toolTip, target, data, showParams);
			});
		}

		/**
		 * 隐藏TIP
		 *
		 */
		public function hideTip(e:Event = null):void
		{
			if (_delayTimer)
			{
				_delayTimer.dispose();
				_delayTimer = null;
			}
			hideTipInternal(e);
		}

		/**
		 * 显示Tip
		 * @param toolTip tip实例
		 * @param target tip显示的目标控件
		 * @param data tip显示数据
		 * @param showParams 其他额外参数
		 *
		 */
		private function showTipInternal(toolTip:TToolTip, target:DisplayObject, data:Object, showParams:Object = null):void
		{
			if (!data)
			{
				return;
			}

			if (_showingToolTip && _showingToolTip == toolTip)
			{
				if (_showingToolTip.mouseFollow)
				{
					validateTipPos(_showingToolTip, _showingToolTip.mouseFollow);
				}
				_showingToolTip.shower = target;
				_showingToolTip.showParams = showParams;
				_showingToolTip.data = data;
			}
			else
			{
				if (_showingToolTip)
				{
					hideTip();
				}

				_showingToolTip = toolTip;

				if (_showingToolTip)
				{
					_showingToolTip.shower = target;
					_showingToolTip.showParams = showParams;
					_showingToolTip.data = data;
					_showingToolTip.addEventListener("ShowerHide", onShowerHide); //监听tipShower的移除事件，tipShower被移除时隐藏Tip
					_showingToolTip.addEventListener(Event.RESIZE, onTipResize); //Tip大小改变时重新布局
					if (!_container.stage.contains(_showingToolTip))
					{
						_container.stage.addChild(_showingToolTip);
					}
					//设置Tip显示位置
					validateTipPos(_showingToolTip, _showingToolTip.mouseFollow);
					_container.stage.addEventListener(MouseEvent.MOUSE_DOWN, hideTip);
				}
			}
		}

		/**
		 *
		 * @param tipName
		 * @param target
		 * @param data
		 * @param showParams
		 *
		 */
		public function showTip2(tipName:String, target:DisplayObject, data:Object, showParams:Object = null):TToolTip
		{
			var tip:TToolTip = getToolTipInstance(tipName);
			showTip(tip, target, data, showParams);
			return tip;
		}

		private function validateTipPos(tip:TToolTip, mouseFollow:Boolean):void
		{
			if (tip.mouseFollow || mouseFollow)
			{
				validatePos3(tip, tip.shower);
			}
			else
			{
				if (tip.shower)
					validatePos2(tip);
				else
					validatePos(tip);
			}
		}

		private function onTipResize(event:Event):void
		{
			var tip:TToolTip = event.currentTarget as TToolTip;
			if (tip)
				validateTipPos(tip, false);
		}

		/**
		 * tipShower被移除时隐藏Tip
		 * @param event
		 *
		 */
		private function onShowerHide(event:Event):void
		{
			hideTip();
		}

		private function hideTipInternal(e:Event = null):void
		{
			if (!(e == null))
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
			}
			if (_showingToolTip)
			{
				_showingToolTip.removeEventListener(Event.RESIZE, onTipResize);
				if (_showingToolTip.parent)
				{
					_showingToolTip.parent.removeChild(_showingToolTip);
				}
				_showingToolTip = null;
			}
		}

		/**
		 * 固定位置模式
		 *
		 */
		private function validatePos(toolTip:TToolTip):void
		{
			toolTip.x = Math.min(_container.mouseX + 10, _container.width - toolTip.width - 4);
			toolTip.y = Math.min(_container.mouseY + 10, _container.height - toolTip.height - 4);
		}

		/**
		 * 根据边界调整Tip位置
		 *
		 */
		private function validatePos2(toolTip:TToolTip):void
		{
			//取绝对位置
			var posToStage:Point = toolTip.shower.localToGlobal(new Point(0, 0));
			if (posToStage.x + toolTip.shower.width < _container.width - toolTip.width - 10)
			{
				toolTip.x = posToStage.x + toolTip.shower.width;
			}
			else
			{
				//宽度超出右边
				toolTip.x = posToStage.x - toolTip.width;
				if (toolTip.x < 0)
				{
					//调整后位置太左，还原原位置
//					toolTip.x = posToStage.x + toolTip.shower.width;
					//改成固定位置模式
					validatePos(toolTip);
					return;
				}
				else
				{
					toolTip.dispatchEvent(new TToolTipEvent(TToolTipEvent.POS_FIX_TO_LEFT)); //通知Tip位置被调整
				}
			}
			if (posToStage.y + toolTip.yOffset < _container.height - toolTip.height - 10)
			{
				toolTip.y = posToStage.y + toolTip.yOffset;
			}
			else
			{
				toolTip.y = posToStage.y - toolTip.height;
				if (toolTip.y < 0)
				{
					//调整后位置太上，还原原位置
//					toolTip.y = posToStage.y + toolTip.yOffset;
					//改成固定位置模式
					validatePos(toolTip);
					return;
				}
				else
				{
					toolTip.dispatchEvent(new TToolTipEvent(TToolTipEvent.POS_FIX_TO_UP)); //通知Tip位置被调整
				}
			}
		}

		/**
		 * 鼠标跟随模式
		 *
		 */
		public function validatePos3(toolTip:TToolTip, target:DisplayObject):void
		{
			//取绝对位置
			var posToStage:Point = target.localToGlobal(new Point(target.mouseX, target.mouseY));
			toolTip.x = posToStage.x + toolTip.xOffset;
			toolTip.y = posToStage.y + toolTip.yOffset;
			if (toolTip.x >= _container.width - toolTip.width - 10)
			{
				toolTip.x = posToStage.x - toolTip.width;
				toolTip.dispatchEvent(new TToolTipEvent(TToolTipEvent.POS_FIX_TO_LEFT));
			}
			if (toolTip.y >= _container.height - toolTip.height - 10)
			{
				toolTip.y = posToStage.y - toolTip.height;
				toolTip.dispatchEvent(new TToolTipEvent(TToolTipEvent.POS_FIX_TO_UP));
			}

		}
	}
}
