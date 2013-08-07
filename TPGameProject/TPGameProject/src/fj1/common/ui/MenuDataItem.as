package fj1.common.ui
{
	import fj1.common.staticdata.MenuOperationType;

	public class MenuDataItem
	{
		private var _operateType:int;
		
		public function MenuDataItem(operateType:int)
		{
			_operateType = operateType;
		}
		
		public function get operateType():int
		{
			return _operateType;
		}
		
		public function get name():String
		{
			return MenuOperationType.getOperationTypeName(this._operateType);
		}
	}
}