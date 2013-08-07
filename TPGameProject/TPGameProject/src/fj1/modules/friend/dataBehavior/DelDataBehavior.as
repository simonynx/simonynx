package fj1.modules.friend.dataBehavior
{
	import fj1.modules.friend.interfaces.IDelDataBehavior;
	import fj1.modules.friend.interfaces.IEntity;

	import tempest.ui.collections.TArrayCollection;

	public class DelDataBehavior implements IDelDataBehavior
	{
		public function DelDataBehavior()
		{
		}

		public function delData(data:TArrayCollection, value:* = null):void
		{
			var info:*;
			for each (info in data)
			{
				if (int(value) == info.id)
				{
					data.removeItem(info);
					return;
				}
			}
		}
	}
}
