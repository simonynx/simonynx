package fj1.modules.battle.view.components
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import fj1.common.GameInstance;
	
	import tempest.common.graphics.TBitmap;
	import tempest.ui.components.TImage;

	public class BackGroundImage extends Sprite
	{
//		private var _bkImage:TImage;
		private var _bkImage:TBitmap;
		private var _smallImage:TImage;

		public function BackGroundImage(width:Number, height:Number)
		{
//			this.addChild(createShape(width, height, 0x000000));
			_smallImage = new TImage();
			_smallImage.setSize(this.width, this.height);
			this.addChild(_smallImage);
//			_bkImage = new TImage();
			_bkImage = new TBitmap();
			_bkImage.smoothing = true;
//			_bkImage.setSize(this.width, this.height);
			this.addChild(_bkImage);
		}

		private function createShape(width:Number, height:Number, color:uint):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			return shape;
		}

		public function load(bkImgPath:String, smallImagePath:String):void
		{
//			_bkImage.setSource(bkImgPath);
			_bkImage.load(bkImgPath);
			_bkImage.addEventListener(Event.COMPLETE, onComplete);
			_smallImage.setSource(smallImagePath);
		}
		
		private function onComplete(event:Event):void
		{
			_bkImage.removeEventListener(Event.COMPLETE, onComplete);
			invalidateSize();
		}
		
		public function invalidateSize():void
		{
			this.x = (GameInstance.app.sceneContainer.width - _bkImage.width) / 2;
			this.y = (GameInstance.app.sceneContainer.height - _bkImage.height) / 2;
		}
	}
}
