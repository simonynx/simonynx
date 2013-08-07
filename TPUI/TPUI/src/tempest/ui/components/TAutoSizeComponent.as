package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventPhase;
	
	import tempest.ui.events.TComponentEvent;

	/**
	 * 可以根据子级自动伸缩的组件
	 * 子级控件大小变化时必须抛出RESIZE事件
	 * @author linxun
	 * 
	 */	
	public class TAutoSizeComponent extends TComponent
	{
		protected var _proxyAsBackGround:Boolean;
		
		public function TAutoSizeComponent(constraints:Object=null, _proxy:*=null, proxyAsBackGround:Boolean = true)
		{
			_proxyAsBackGround = proxyAsBackGround;
			super(constraints, _proxy);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			child.addEventListener(Event.RESIZE, onResize);
			child.addEventListener(Event.REMOVED, onRemoved);
			child.addEventListener(TComponentEvent.MOVE, onMove);
			var ret:DisplayObject = super.addChildAt(child, index);
			measureChildren(_proxyAsBackGround);
			return ret;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			child.addEventListener(Event.RESIZE, onResize);
			child.addEventListener(Event.REMOVED, onRemoved);
			child.addEventListener(TComponentEvent.MOVE, onMove);
			var ret:DisplayObject = super.addChild(child);
			measureChildren(_proxyAsBackGround);
			return ret;
		}
		
		private function onResize(event:Event):void
		{
			measureChildren(_proxyAsBackGround);
			if(hasEventListener(Event.RESIZE))
			{
				dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		private function onRemoved(event:Event):void
		{
			if(event.eventPhase != EventPhase.AT_TARGET)
			{
				return;
			}
			measureChildren(_proxyAsBackGround);
			with(event.currentTarget)
			{
				removeEventListener(Event.RESIZE, onResize);
				removeEventListener(Event.REMOVED, onRemoved);
				removeEventListener(TComponentEvent.MOVE, onMove);
			}
		}
		
		private function onMove(event:Event):void
		{
			measureChildren(_proxyAsBackGround);
		}
	}
}