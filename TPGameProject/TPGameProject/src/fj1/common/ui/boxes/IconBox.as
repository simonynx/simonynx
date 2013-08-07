package fj1.common.ui.boxes
{
	import assets.ResLib;

	import fj1.common.res.ResPaths;
	import fj1.common.staticdata.IconSizeType;
	import fj1.common.staticdata.ItemQuality;
	import fj1.common.ui.animation.AnimationFrameController;
	import fj1.common.ui.animation.IAnimationFrameController;
	import fj1.common.ui.animation.BitmapAnimation;
	import fj1.common.ui.animation.QualityAniResMananger;

	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	import tempest.common.rsl.TRslManager;
	import tempest.core.IPoolClient;
	import tempest.ui.collections.TMutexGroup;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TImage;
	import tempest.ui.interfaces.IIcon;

	public class IconBox extends TComponent implements IPoolClient
	{
		private var _img:TImage;
		protected var _mc_color:MovieClip;
		protected var _bg:MovieClip;
		protected var _sizeType:int = -1;
		private var _resName:String;

		private var _qualityAnimGroup:TMutexGroup; //品质边框动画组
		private var _qualityFireGroup:TMutexGroup; //品质火焰动画组

		public function IconBox(proxy:*, resName:String = null)
		{
			if (!proxy)
			{
				proxy = TRslManager.getInstance(resName);
			}
			super(null, proxy);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.sizeType = IconSizeType.ICON36;
		}

		override protected function addChildren():void
		{
			var imgBk:Sprite = new Sprite();
			imgBk.graphics.drawRect(0, 0, _proxy.width, _proxy.height);
			_img = new TImage(null, imgBk);
			this.addChild(_img);
			if (_proxy.hasOwnProperty("mc_imgCover"))
			{
				_proxy.mc_imgCover.mouseEnabled = false;
			}
			if (_proxy.hasOwnProperty("mc_color") && _proxy.mc_color != null)
			{
				_mc_color = _proxy.mc_color;
			}
			if (_mc_color)
			{
				_mc_color.mouseEnabled = _mc_color.mouseChildren = false;
				_mc_color.stop();
				this.addChild(_mc_color);
				//品质动画初始化
				initQualityAnim();
				initQualityFire();
			}
			if (_proxy.hasOwnProperty("bg") && _proxy.bg != null)
			{
				_bg = _proxy.bg;
				_bg.mouseEnabled = _bg.mouseChildren = false;
			}
			if (_proxy.hasOwnProperty("lbl_amount"))
			{
				_proxy.lbl_amount.text = "";
			}
		}


		/*****************************品质动画初始化*****************************/

		/**
		 * 初始化品质边框动画
		 *
		 */
		private function initQualityAnim():void
		{
			_qualityAnimGroup = new TMutexGroup(this);
			_qualityAnimGroup.add(createQualityAnim(ResLib.QUALITY_EFFECT_PURPLE));
			_qualityAnimGroup.add(createQualityAnim(ResLib.QUALITY_EFFECT_YELLOW));
			_qualityAnimGroup.add(createQualityAnim(ResLib.QUALITY_EFFECT_RED));
		}

		private function createQualityAnim(id:String):BitmapAnimation
		{
			var resMgr:QualityAniResMananger = QualityAniResMananger.getInstance();
			var qualityAnim:BitmapAnimation = new BitmapAnimation(resMgr.getRes(id), resMgr.frameCtrl);
			qualityAnim.scaleX = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
			qualityAnim.scaleY = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
			qualityAnim.blendMode = BlendMode.ADD;
			qualityAnim.x = (_sizeType == IconSizeType.ICON36) ? _mc_color.x - 1 : _mc_color.x - 2;
			qualityAnim.y = (_sizeType == IconSizeType.ICON36) ? _mc_color.y - 1 : _mc_color.y - 2;
			qualityAnim.addEventListener(Event.ADDED_TO_STAGE, onQualityAnimAdd);
			qualityAnim.addEventListener(Event.REMOVED_FROM_STAGE, onQualityAnimRemove);
			return qualityAnim;
		}

		private function onQualityAnimAdd(event:Event):void
		{
			var ani:BitmapAnimation = event.currentTarget as BitmapAnimation;
			ani.play();
		}

		private function onQualityAnimRemove(event:Event):void
		{
			var ani:BitmapAnimation = event.currentTarget as BitmapAnimation;
			ani.stop();
		}

		/**
		 * 初始化品质火焰动画
		 *
		 */
		private function initQualityFire():void
		{
			_qualityFireGroup = new TMutexGroup(this);
			_qualityFireGroup.add(createQualityFire(ResLib.QUALITY_FIRE_YELLOW));
			_qualityFireGroup.add(createQualityFire(ResLib.QUALITY_FIRE_RED));
		}

		private function createQualityFire(id:String):BitmapAnimation
		{
			var resMgr:QualityAniResMananger = QualityAniResMananger.getInstance();
			var fire:BitmapAnimation = new BitmapAnimation(resMgr.getRes(id), resMgr.frameCtrl);
			fire.scaleX = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
			fire.scaleY = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
			fire.blendMode = BlendMode.ADD;
			fire.x = (_sizeType == IconSizeType.ICON36) ? _mc_color.x - 1 : _mc_color.x - 2;
			fire.y = (_sizeType == IconSizeType.ICON36) ? _mc_color.y - 1 : _mc_color.y - 2;
			fire.addEventListener(Event.ADDED_TO_STAGE, onQualityFireAdd);
			fire.addEventListener(Event.REMOVED_FROM_STAGE, onQualityFireRemove);
			return fire;
		}

		private function onQualityFireAdd(event:Event):void
		{
			var ani:BitmapAnimation = event.currentTarget as BitmapAnimation;
			ani.play();
		}

		private function onQualityFireRemove(event:Event):void
		{
			var ani:BitmapAnimation = event.currentTarget as BitmapAnimation;
			ani.stop();
		}

		/*************************************************************************/

		override public function set data(value:Object):void
		{
			super.data = value;
			setImageData(value);
			setQuality(value as IIcon ? IIcon(value).quality : 0);
		}

		/**
		 * 设置_dragImage图片数据
		 * @param value
		 *
		 */
		private function setImageData(value:Object):void
		{
			super.data = value;
			_img.data = value;
			if (value != null)
			{
				var icon:IIcon = value as IIcon;
				if (icon != null)
				{
					_img.setSource(icon.getIconUrl(_sizeType));
				}
				else
				{
					_img.setSource(null);
				}
			}
			else
			{
				_img.setSource(null);
			}
		}

		private function setQuality(quality:int):void
		{
			_mc_color.gotoAndStop(quality);
			//切换到对应品质的品质动画
			updateQualityAni(quality);
			updateQualityFire(quality);
		}


		/**
		 * 切换品质边框动画
		 *
		 */
		private function updateQualityAni(quality:int):void
		{
			var index:int = qualityToAniIndex(quality);
			if (_qualityAnimGroup.currentIndex == index)
			{
				return;
			}
			_qualityAnimGroup.currentIndex = index;
		}

		private function qualityToAniIndex(quality:int):int
		{
			switch (quality)
			{
				case ItemQuality.QUALITY_3:
					return 0;
				case ItemQuality.QUALITY_4:
					return 1;
				case ItemQuality.QUALITY_5:
					return 2;
				default:
					return -1;
			}
		}

		/**
		 * 切换品质火焰动画
		 *
		 */
		private function updateQualityFire(quality:int):void
		{
			var index:int = qualityToFireIndex(quality);
			if (_qualityFireGroup.currentIndex == index)
			{
				return;
			}
			_qualityFireGroup.currentIndex = index;
		}

		private function qualityToFireIndex(quality:int):int
		{
			switch (quality)
			{
				case ItemQuality.QUALITY_4:
					return 0;
				case ItemQuality.QUALITY_5:
					return 1;
				default:
					return -1;
			}
		}

		public function set sizeType(value:int):void
		{
			if (_sizeType == value)
			{
				return;
			}
			_sizeType = value;
			//改变品质光效大小
			if (_mc_color)
			{
				var list:Vector.<DisplayObject> = _qualityAnimGroup.objList.concat(_qualityFireGroup.objList);
				for each (var ani:BitmapAnimation in list)
				{
					ani.scaleX = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
					ani.scaleY = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
					ani.x = (_sizeType == IconSizeType.ICON36) ? _mc_color.x - 1 : _mc_color.x - 2;
					ani.y = (_sizeType == IconSizeType.ICON36) ? _mc_color.y - 1 : _mc_color.y - 2;
				}
			}
		}

		public function reset(args:Array):void
		{

		}

		override protected function implementSize(width:Number, height:Number):void
		{
			this.$width = width;
			this.$height = height;
		}

		private function onRemovedFromStage(event:Event):void
		{
			this.data = null;
		}
	}
}
