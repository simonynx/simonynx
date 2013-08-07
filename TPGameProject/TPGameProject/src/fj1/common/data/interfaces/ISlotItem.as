package fj1.common.data.interfaces
{
	import tempest.ui.interfaces.ISlotData;

	public interface ISlotItem extends ICopyable, ICountable, IDataObject, ILockable, ISlotData
	{
		function canCombine(targetItem:ISlotItem):Boolean;
		function get max_stack():int;
		function getCmpValue(name:String):int;
		function get type():int;
		function get subtype():int;
	}
}
