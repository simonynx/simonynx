package tempest.ui.components.factories
{
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.core.IProxyFactory;
	import tempest.ui.components.TCheckBox;
	
	public class CheckBoxFactory implements IProxyFactory
	{
		private var _proxy:*;
		public var text:String;
		public var model:int;
		public function CheckBoxFactory(text:String, model:int)
		{
			this.text = text;
			this.model = model;
		}
		
		public function set proxy(value:*):void
		{
			_proxy = value;
		}
		
		public function newInstance():*
		{
			return new TCheckBox(null, _proxy, text, model);
		}
	}
}