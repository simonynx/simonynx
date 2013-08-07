package fj1.common.ui.boxes
{
	import tempest.common.rsl.TRslManager;

	public class BaseDataBox2 extends BaseDataBox
	{
		public function BaseDataBox2(skinName:String)
		{
			super(TRslManager.getInstance(skinName));
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.enableLockState = false;
			this.enableCD = false;
			this.enablePlayerBindableBinding = false;
		}
	}
}