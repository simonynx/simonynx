package tempest.ui
{
	import flash.utils.Dictionary;

	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	public class ChangeWatcherManager
	{
		private var watcherDataArray:Array;

		public function ChangeWatcherManager()
		{
			watcherDataArray = [];
		}

		private var _createAlways:Boolean = false;

		/**
		 * 当绑定控件重复时，是否总是创建新的changeWhtcher
		 * @param value
		 *
		 */
		public function set createAlways(value:Boolean):void
		{
			_createAlways = value;
		}

		/**
		 * 功能同BindingUtils.bindProperty，产生的changeWhtcher会被缓存
		 * @param site
		 * @param prop
		 * @param host
		 * @param chain
		 * @param commitOnly
		 * @param useWeakReference
		 *
		 */
		public function bindProperty(
			site:Object, prop:String,
			host:Object, chain:Object,
			defaultValue:Object = null,
			commitOnly:Boolean = false,
			useWeakReference:Boolean = false):void
		{
			var changeWhtcher:ChangeWatcher = _createAlways ? null : getWatcher(site, prop, null);
			if (changeWhtcher)
			{
				changeWhtcher.reset(host);
				site[prop] = changeWhtcher.getValue();

			}
			else
			{
				changeWhtcher = BindingUtils.bindProperty(site, prop, host, chain, commitOnly, useWeakReference);
				watcherDataArray.push(new SingleWatcherData(site, prop, null, changeWhtcher));
			}
		}

		/**
		 * （私有）在缓存中查找 ChangeWatcher
		 * @param site
		 * @param prop
		 * @param setter
		 * @return
		 *
		 */
		private function getWatcher(site:Object, prop:String, setter:Function):ChangeWatcher
		{
			for (var i:int = 0; i < watcherDataArray.length; i++)
			{
				var element:SingleWatcherData = watcherDataArray[i] as SingleWatcherData;
				if ((element.site && element.site == site && element.prop == prop) || (element.setter != null && element.setter == setter))
				{
					return element.watcher;
				}
			}
			return null;
		}

		/**
		 *
		 * @param site
		 * @param prop
		 * @param setter
		 * @return
		 *
		 */
		private function removeWatcher(site:Object, prop:String, setter:Function):ChangeWatcher
		{
			for (var i:int = 0; i < watcherDataArray.length; i++)
			{
				var element:SingleWatcherData = watcherDataArray[i] as SingleWatcherData;
				if ((element.site && element.site == site && element.prop == prop) || (element.setter != null && element.setter == setter))
				{
					watcherDataArray.splice(i, 1);
					return element.watcher;
				}
			}
			return null;
		}

		/**
		 * 功能同BindingUtils.bindSetter，产生的changeWhtcher会被缓存
		 * @param setter
		 * @param host
		 * @param chain
		 * @param commitOnly
		 * @param useWeakReference
		 *
		 */
		public function bindSetter(setter:Function, host:Object,
			chain:Object,
			defaultValue:Object = null,
			commitOnly:Boolean = false,
			useWeakReference:Boolean = false):void
		{
			var changeWhtcher:ChangeWatcher = _createAlways ? null : getWatcher(null, null, setter);
			if (changeWhtcher)
			{
				changeWhtcher.reset(host);
				setter(changeWhtcher.getValue());
			}
			else
			{
				changeWhtcher = BindingUtils.bindSetter(setter, host, chain, commitOnly, useWeakReference);
				watcherDataArray.push(new SingleWatcherData(null, null, setter, changeWhtcher));
			}
		}

		/**
		 * 解绑所有changeWhtcher
		 *
		 */
		public function unWatchAll():void
		{
			for each (var watcherData:SingleWatcherData in watcherDataArray)
			{
				watcherData.watcher.unwatch();
			}
			if (_createAlways)
			{
				watcherDataArray = [];
			}
		}

		/**
		 * 解绑 setter
		 * @param setter
		 *
		 */
		public function unWatchSetter(setter:Function):void
		{
			var changeWhtcher:ChangeWatcher = _createAlways ? removeWatcher(null, null, setter) : getWatcher(null, null, setter);
			if (changeWhtcher)
				changeWhtcher.unwatch();
		}

		/**
		 * 解绑属性
		 * @param site
		 * @param prop
		 *
		 */
		public function unWatchProperty(site:Object, prop:String):void
		{
			var changeWhtcher:ChangeWatcher = _createAlways ? removeWatcher(site, prop, null) : getWatcher(site, prop, null);
			if (changeWhtcher)
				changeWhtcher.unwatch();
		}
	}
}
import mx.binding.utils.ChangeWatcher;

class SingleWatcherData
{
	public function SingleWatcherData(site:Object, prop:String, setter:Function, watcher:ChangeWatcher)
	{
		this.site = site;
		this.prop = prop;
		this.setter = setter;
		this.watcher = watcher;
	}
	public var site:Object;
	public var prop:String;
	public var setter:Function;
	public var watcher:ChangeWatcher;
}
