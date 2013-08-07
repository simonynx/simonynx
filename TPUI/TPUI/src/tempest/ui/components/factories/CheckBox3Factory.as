package tempest.ui.components.factories
{
	import tempest.ui.components.TCheckBox3;
	import tempest.ui.core.IProxyFactory;

	public class CheckBox3Factory implements IProxyFactory
	{
		private var _proxy:*;

		public function CheckBox3Factory()
		{
		}

		public function set proxy(value:*):void
		{
			_proxy = value;
		}

		public function newInstance():*
		{
			return new TCheckBox3(null, _proxy);
		}
	}
}
