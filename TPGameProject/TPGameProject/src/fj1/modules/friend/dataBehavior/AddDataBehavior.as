package fj1.modules.friend.dataBehavior
{
	import fj1.modules.friend.interfaces.IAddDataBehavior;
	import fj1.modules.friend.interfaces.IEntity;

	import tempest.ui.collections.TArrayCollection;

	public class AddDataBehavior implements IAddDataBehavior
	{
		public function AddDataBehavior()
		{
		}

		public function addData(data:TArrayCollection, value:* = null):void
		{
			var info:*;
			for each (info in data)
			{
				if (value.id == info.id)
					return;
			}
			data.addItem(value);
		}
	}
}
