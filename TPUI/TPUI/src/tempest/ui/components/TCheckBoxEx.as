package tempest.ui.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.core.IFactory;

	import tempest.ui.UIStyle;
	import tempest.ui.core.IProxyFactory;

	public class TCheckBoxEx extends TComponent
	{
		private var _mc_base:MovieClip;
		private var _selectedState:Sprite;
		private var _unSelectedState:Sprite;
		//
		private var _selected:Boolean;

		public function TCheckBoxEx(constraints:Object = null, _proxy:* = null, selectedRenderFactory:IProxyFactory = null, unSelectedRenderFactory:IProxyFactory = null)
		{
			super(constraints, _proxy);
			unSelectedRenderFactory.proxy = _proxy.mc_disable;
			_unSelectedState = unSelectedRenderFactory.newInstance();
			selectedRenderFactory.proxy = _proxy.mc_enable;
			_selectedState = selectedRenderFactory.newInstance();
			_selectedState.visible = false;
			_unSelectedState.visible = true;
//			if (_mc_base)
//				_mc_base.addFrameScript(0, onFrame, 1, onFrame);
//			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function get currentState():Sprite
		{
			if (_selected)
			{
				return _selectedState;
			}
			else
			{
				return _unSelectedState;
			}
		}

		public function get selectedState():Sprite
		{
			return _selectedState;
		}

		public function get unSelectedState():Sprite
		{
			return _unSelectedState;
		}

//		protected function onFrame():void
//		{
//			var proxy:* = _mc_base.getChildAt(0);
//			while (proxy is TComponent)
//			{
//				proxy.parent.removeChildAt(0);
//				proxy = _mc_base.getChildAt(0);
//			}
//			switch (_mc_base.currentFrame)
//			{
//				case 1: //未激活
//					TComponent(_unSelectedState).proxy = proxy;
//					break;
//				case 2:
//					TComponent(_selectedState).proxy = proxy;
//					break;
//			}
//		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
//		protected function onClick(event:MouseEvent):void
//		{
//			selected = !selected;
//		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function set selected(value:Boolean):void
		{
			if (_selected == value)
			{
				return;
			}
			if (_selected = value)
			{
				_selectedState.visible = true;
				_unSelectedState.visible = false;
			}
			else
			{
				_selectedState.visible = false;
				_unSelectedState.visible = true;
			}

			dispatchEvent(new Event(Event.CHANGE));
			invalidate();
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		override public function set enabled(value:Boolean):void
		{
			if (super.enabled == value)
			{
				return;
			}
			super.enabled = value;
			if (!super.enabled)
			{
//				this.setFilter(UIStyle.disableFilter);
				this.mouseEnabled = this.mouseChildren = false;
			}
			else
			{
//				this.removeFilters();
				this.mouseEnabled = this.mouseChildren = true;
			}
		}

		override public function set mouseEnabled(enabled:Boolean):void
		{
			super.mouseEnabled = enabled;
		}
	}
}
