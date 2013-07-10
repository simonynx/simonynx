package modules.main.business.battle.view.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import common.GameInstance;
	
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
			_bkImage.width = GameInstance.app.sceneContainer.width;
			_bkImage.height = GameInstance.app.sceneContainer.height;
		}
		
		public function setSize(width:int, height:int):void
		{
			_bkImage.width = width;
			_bkImage.height = height;
		}
	}
}
