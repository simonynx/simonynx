package tempest.ui.components.factories
{
	import tempest.ui.core.IProxyFactory;
	import tempest.ui.components.TGroup;
	import tempest.ui.components.TRadioButton;
	
	public class RadioButtonFactory implements IProxyFactory
	{
		private var _proxy:*;
		public var text:String;
		public var model:int;
		public var group:TGroup;
		
		public function RadioButtonFactory(text:String, model:int, group:TGroup)
		{
			this.text = text;
			this.model = model;
			this.group = group;
		}
		
		public function set proxy(value:*):void
		{
			_proxy = value;
		}
		
		public function newInstance():*
		{
			return new TRadioButton(group, null, _proxy, text, model);
		}
	}
}