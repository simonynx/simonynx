package tempest.ui.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	
	public class TArrayCollection extends TListCollectionView
	{
		public function TArrayCollection(source:Array = null)
		{		
			super();
			
			if(!source)
				source = [];
				
			this.source = source;
		}
		
		public function get source():Array
		{
			if (_list && (_list is TArrayList))
			{
				return TArrayList(_list).source;
			}
			return null;
		}
		
		public function set source(s:Array):void
		{
			list = new TArrayList(s);
		}
		
		public function enableEvents():void
		{
			if (_list && (_list is TArrayList))
			{
				TArrayList(_list).enableEvents();
			}
		}
		
		public function disableEvents():void
		{
			if (_list && (_list is TArrayList))
			{
				TArrayList(_list).disableEvents();
			}
		}
	}
}