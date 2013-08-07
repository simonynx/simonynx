package tempest.ui.helper
{
	public class SimpleBindUtil
	{
		public static function bindProperty(
			site:Object, prop:String,
			host:Object, chain:String,
			useWeakReference:Boolean = false):SimpleChangeWatcher
		{
//			var w:SimpleChangeWatcher = new SimpleChangeWatcher(host, chain,  function(event:*):void
//			{
//				site[prop] = w.getValue();
//			}, useWeakReference);
			var w:SimpleChangeWatcher = new SimpleChangeWatcher(host, chain, null, site, prop, useWeakReference);
			site[prop] = w.getValue();
			
			return w;
		}
		
		public static function bindSetter(setter:Function, host:Object,
										  chain:String,
										  useWeakReference:Boolean = false):SimpleChangeWatcher
		{
//			var w:SimpleChangeWatcher = new SimpleChangeWatcher(host, chain,  function(event:*):void
//			{
//				setter(w.getValue());
//			}, useWeakReference);
			var w:SimpleChangeWatcher = new SimpleChangeWatcher(host, chain, setter, null, null, useWeakReference);
			w.handler(w.getValue());
			
			return w;
		}
	}
}