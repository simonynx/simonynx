package fj1.common.ui.pools
{
	import fj1.common.ui.boxes.IconBox;
	import tempest.common.pool.Pool;

	public class IconBoxPool extends Pool
	{
		private var _resName:String;
		private var _sizeType:int;

		public function IconBoxPool(resName:String, sizeType:int)
		{
			super("BaseDataBoxPool");
			_resName = resName;
			_sizeType = sizeType;
		}

		public function create():IconBox
		{
			var iconBox:IconBox = IconBox(this.createObj(IconBox, null, _resName));
			iconBox.sizeType = _sizeType;
			return iconBox;
		}
	}
}
