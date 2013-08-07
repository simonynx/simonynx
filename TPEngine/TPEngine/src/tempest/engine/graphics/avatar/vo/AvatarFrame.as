package tempest.engine.graphics.avatar.vo
{

	public class AvatarFrame
	{
		public var totalFrames:int;
		public var interval:int;
		public var keyFrame:int;
		public var faceCount:int;

		public function AvatarFrame(totalFrames:int, interval:int, keyFrame:int, faceCount:int)
		{
			this.totalFrames = totalFrames;
			this.interval = interval;
			this.keyFrame = keyFrame;
			this.faceCount = faceCount;
		}

		public function clone():AvatarFrame
		{
			return new AvatarFrame(totalFrames, interval, keyFrame, faceCount);
		}
	}
}
