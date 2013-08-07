package tempest.ui.components
{

	public class TGroup
	{
		private var _radioButtonArray:Array = [];

		private var _selectedButton:TRadioButton;

		public function TGroup()
		{
		}

		public function addRadioButton(bt:TRadioButton):void
		{
			_radioButtonArray.push(bt);
		}

		internal function updateGroupButton(_bt:TRadioButton):void
		{
			_selectedButton = _bt;
			for each (var bt:TRadioButton in _radioButtonArray)
			{
				if (bt != _bt)
				{
					if (bt.selected)
					{
						bt.unSelect();
					}
				}
			}
		}

		/**
		 * 获取该组中选中的按钮
		 * @return
		 *
		 */
		public function get selectedButton():TRadioButton
		{
			return _selectedButton;
		}

		/**
		 * 获取radioButton列表，不可增删列表中控件
		 * @return
		 *
		 */
		public function get radioButtonArray():Array
		{
			return _radioButtonArray;
		}
	}
}
