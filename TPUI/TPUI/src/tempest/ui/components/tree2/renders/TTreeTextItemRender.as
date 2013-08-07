package tempest.ui.components.tree2.renders
{

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.tree2.IIndentSetter;
	import tempest.ui.components.tree2.TTree2;
	import tempest.ui.components.tree2.data.TTreeNode;

	/**
	 * 树形不可展开节点
	 * @author linxun
	 *
	 */
	public class TTreeTextItemRender extends TListItemRender implements IIndentSetter
	{
		protected var _textField:TextField;
		private var _ttree:TTree2;

		public function TTreeTextItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
			_textField = _proxy.text as TextField;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			if (!data)
			{
				return;
			}
			var text:String = (value as TTreeNode).text;
			_textField.text = text ? text : "";
		}

		private function get ttree():TTree2
		{
			if (!_ttree)
			{
				var parentView:DisplayObject = this.parent;
				while (parentView)
				{
					if (parentView is TTree2)
					{
						_ttree = parentView as TTree2;
						break;
					}
					parentView = parentView.parent;
				}
			}
			return _ttree;
		}

		/**
		 * 设置缩进
		 * @param value
		 *
		 */
		public function set indentX(value:Number):void
		{
			_textField.x = value;
			_textField.width = this.width - value;
		}

		override protected function onClick(event:MouseEvent):void
		{
			if (!selected)
			{
				if (data is TTreeNode && !(TTreeNode(data).selectEnabled))
				{
					ttree.setSelectInternal(null);
				}
				else
				{
					ttree.setSelectInternal(this.data);
					setSelect();
				}
			}
//			super.onHeadClick(event);
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			if(_bkMovieClip)
			{
				_bkMovieClip.width = _width;
			}
			_textField.width = _width;
		}
	}
}
