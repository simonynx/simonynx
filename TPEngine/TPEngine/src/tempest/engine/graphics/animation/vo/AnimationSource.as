package tempest.engine.graphics.animation.vo
{
	import tempest.core.IDisposable;
	import tempest.engine.graphics.TPBitmap;

	public class AnimationSource implements IDisposable
	{
		private var bitmaps:Array = [];
		private var _key:String;
		private var _refCount:int = 0;

		public function get key():String
		{
			return _key;
		}

		public function AnimationSource(key:String)
		{
			_key = key;
		}

		public function add(id:int, bm:TPBitmap):void
		{
			bitmaps[id] = bm;
		}

		public function get(frame:int):TPBitmap
		{
			return bitmaps[frame];
		}

		public function allocate():AnimationSource
		{
			_refCount++;
			return this;
		}

		public function release():void
		{
			_refCount--;
		}

		public function dispose():void
		{
			var bitmap:TPBitmap;
			for each (bitmap in bitmaps)
			{
				bitmap.dispose();
			}
		}
	}
}
