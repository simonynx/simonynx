package fj1.modules.friend.dataBehavior
{
	import fj1.modules.friend.interfaces.IDelDataBehavior;
	import fj1.modules.friend.interfaces.IEntity;

	import tempest.ui.collections.TArrayCollection;

	public class DelAllDataBehavior implements IDelDataBehavior
	{
		public function DelAllDataBehavior()
		{
		}

		public function delData(data:TArrayCollection, value:* = null):void
		{
			if (data)
				data.removeAll();
		}
	}
}
