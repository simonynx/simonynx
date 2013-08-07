package fj1.modules.friend.dataBehavior
{
	import fj1.modules.friend.interfaces.IEntity;
	import fj1.modules.friend.interfaces.IInDataBehavior;
	import tempest.ui.collections.TArrayCollection;

	public class InDataBehavior implements IInDataBehavior
	{
		public function InDataBehavior()
		{
		}

		public function isInData(data:TArrayCollection, id:int):*
		{
			var info:*;
			for each (info in data)
			{
				if (id == info.id)
					return info;
			}
			return null;
		}
	}
}
