package fj1.common.data.interfaces
{

	/**
	 * 被存储对象接口，实现该接口的类必须带有[Bindable]num 属性
	 * @author linxun
	 *
	 */
	public interface IStoredObject extends IUseable, ICountable, ICopyable
	{
		function discardObj(check:Boolean = true):void
		function sendToChat():void
	}
}
