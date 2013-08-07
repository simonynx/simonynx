package fj1.common.flytext
{
	import fj1.common.res.lan.LanguageManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	import fj1.common.core.IFlyText;
	import tempest.core.IPoolClient;
	import tempest.engine.tools.ScenePool;
	import fj1.common.ui.TImageText;
	import fj1.common.ui.font.TImageFont;
	import fj1.common.ui.font.TImageFontManager;
	import fj1.common.staticdata.TImageFontNames;

	public class TFlyableImageText extends TImageText implements IFlyText, IPoolClient
	{
		private var _scale:Number;
		protected var _direction:int;

		/**
		 *
		 * @param fontName 字体名称
		 * @param leading 空格对应的宽度
		 * @param space 空格对应的宽度
		 * @param scale 初始缩放倍数
		 */
		public function TFlyableImageText(valueEffect:int, value:Number, colorStr:String = TImageFontNames.YELLOW, leading:int = 0, space:int = 30, s:Number = 0.6)
		{
			var __font:TImageFont = TImageFontManager.instance.getFont(colorStr);
			super(__font, leading, space);
			scale = 1;
			setText(valueEffect, value);
		}

		public override function reset(args:Array):void
		{
			var __font:TImageFont = TImageFontManager.instance.getFont(args[2]);
			super.reset([__font, args[3], args[4]]);
			scale = 1;
			setText(args[0], args[1]);
		}

		public override function dispose():void
		{
			super.dispose();
			this.alpha = 1;
			scale = 1;
			if (this.parent != null)
				this.parent.removeChild(this);
		}

		/**
		 * 设置文本
		 * @param value
		 *
		 */
		public function setText(valueEffect:int, value:int = 0):void
		{
			switch (valueEffect)
			{
				case ValueEffects.None:
					text = LanguageManager.translate(6019, "躲闪");
					direction = 3;
					break;
				case ValueEffects.Decrease:
					text = "-" + value;
					direction = 1;
					break;
				case ValueEffects.Double:
					text = LanguageManager.translate(6020, "暴击-" + value);
					direction = 1;
					scale = 1;
					break;
				case ValueEffects.Increase:
					text = "+" + value;
					direction = 1;
					break;
				case ValueEffects.MultiIncrease:
					text = "+" + value;
					direction = 1;
					break;
				case ValueEffects.Failure:
					text = LanguageManager.translate(6019, "躲闪");
					direction = 3;
					break;
			}
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction = value;
		}

		public function set scale(value:Number):void
		{
			if (_scale != value)
				this.scaleX = scaleY = _scale = value;
		}

		public function get scale():Number
		{
			return _scale;
		}

		/**
		 *创建池对象
		 * @param leading
		 * @param space
		 * @param scale
		 * @return
		 *
		 */
		public static function creatTImageText(valueEffect:int, value:Number, colorStr:String = TImageFontNames.YELLOW, leading:int = 0, space:int = 30, s:Number = 0.6):TFlyableImageText
		{
			return (ScenePool.tImageTextPool.createObj(TFlyableImageText, valueEffect, value, colorStr, leading, space, s) as TFlyableImageText);
		}

		/**
		 *回收
		 * @param flyableText
		 *
		 */
		public static function recycleTImageText(tImageText:IPoolClient):void
		{
			ScenePool.tImageTextPool.disposeObj(tImageText);
		}
	}
}
