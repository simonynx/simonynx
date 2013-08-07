package tempest.ui.helper
{
	import flash.events.Event;
	
	import mx.core.EventPriority;
	import mx.events.PropertyChangeEvent;

	public class SimpleChangeWatcher
	{
		private var host:Object;
		private var chain:String;
		public var handler:Function;
		public var useWeakReference:Boolean;
	
		public var site:Object; 
		public var prop:String;
		
		
		public function SimpleChangeWatcher(host:Object, chain:String, handler:Function, site:Object, prop:String, useWeakReference:Boolean)
		{
			this.chain = chain;
			this.handler = handler;
			this.useWeakReference = useWeakReference;
			reset(host);
			
			this.site = site;
			this.prop = prop;
		}
		
		public function reset(newHost:Object):void
		{
			var p:String;
			
			if (host != null)
			{
				host.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, wrapHandler);
			}
			
			host = newHost;
			
			if (host != null)
			{
				host.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, wrapHandler, false, EventPriority.BINDING, useWeakReference);
			}
		}

		private function wrapHandler(event:PropertyChangeEvent):void
		{
			if (event.property == chain)
			{
//				handler(event);
				if(handler != null)
				{
					handler(getValue());
				}
				else
				{
					site[prop] = getValue();
				}
			}
		}
		
		public function getValue():Object
		{
			return host ?  host[chain] : null;
		}
		
		public function unwatch():void
		{
			reset(null);
		}
	}
}