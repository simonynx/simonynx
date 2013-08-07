package org.osflash.signals.natives.base
{
	import flash.display.Loader;
	import org.osflash.signals.natives.sets.LoaderInfoSignalSet;
	
	public class SignalLoader extends Loader
	{
		private var _signals:LoaderInfoSignalSet
		public function get signals():LoaderInfoSignalSet
		{
			return _signals ||= new LoaderInfoSignalSet(this.contentLoaderInfo);
		}
	}
}