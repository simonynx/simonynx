package tempest.engine.graphics.animation.vo
{
	import flash.geom.Point;

	public class AnimationEntity
	{
		public var id:int;
		public var centerX:Number;
		public var centerY:Number;
		public var frameTotal:int;
		public var interval:int;
		public var kind:int;
		public var name:String;
		public var scale_x:Number = 1;
		public var scale_y:Number = 1;
		public var blend_mode:int = 0;
		public var body_width:int = 0;

		public function AnimationEntity()
		{
		}
	}
}
