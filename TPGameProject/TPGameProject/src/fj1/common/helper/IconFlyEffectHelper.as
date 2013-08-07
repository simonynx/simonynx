package fj1.common.helper
{
	import assets.ResLib;
	import assets.UISkinLib;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import fj1.common.data.dataobject.DataObject;
	import fj1.common.staticdata.IconSizeType;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.common.ui.boxes.BaseDataBox2;
	import fj1.common.ui.boxes.IconBox;
	import fj1.common.ui.pools.IconBoxPool;
	import fj1.common.ui.pools.IconBoxPoolManager;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import tempest.common.rsl.TRslManager;
	import tempest.core.IPoolClient;
	import tempest.ui.PopupManager;
	import tempest.ui.core.ITListItemRender;
	import tempest.ui.effects.BaseEffect;
	import tempest.ui.events.EffectEvent;

	public class IconFlyEffectHelper
	{
		public static function play(data:DataObject, target:DisplayObject, duration:Number, startPos:Point, widthTo:Number, heightTo:Number, alphaTo:Number, onEffectComplete:Function = null):void
		{
			var iconBox:IconBox = new IconBox(TRslManager.getInstance(UISkinLib.itemMoveBoxSkin)); //IconBox(IconBoxPoolManager.getPool(IconSizeType.ICON36.toString()).create());
			iconBox.sizeType = IconSizeType.ICON36;
			iconBox.data = data;
			PopupManager.instance.showPopup(null, iconBox, false, startPos);
			var targetGlobalPos:Point = target.localToGlobal(new Point());
			GTweener.to(iconBox, duration, {x: targetGlobalPos.x, y: targetGlobalPos.y, width: widthTo, height: heightTo, alpha: alphaTo}, {useFrames: true}).onComplete = function(gTween:GTween):void
			{
				PopupManager.instance.removePopup(gTween.target as DisplayObject);
//				IconBoxPoolManager.getPool(IconSizeType.ICON36.toString()).removeObj(IPoolClient(gTween.target));
				if (onEffectComplete != null)
				{
					onEffectComplete(target);
				}
			};
		}
//		/**
//		 * 学习技能后飘到快捷栏的效果
//		 * @param data 技能数据
//		 * @param target 目标
//		 * @param startPos 开始位置
//		 * @param duration 速度
//		 * @param widthTo 宽
//		 * @param heightTo 高
//		 * @param alphaTo 透明度
//		 *
//		 */
//		public static function skillEffext(data:DataObject, target:DisplayObject, startPos:Point, duration:Number = 50, widthTo:Number = 36, heightTo:Number = 36, alphaTo:Number = 1):void
//		{
//			var iconBox:IconBox = new IconBox(TRslManager.getInstance(UISkinLib.itemMoveBoxSkin)); // IconBox(IconBoxPoolManager.getPool(IconSizeType.ICON36.toString()).create());
//			iconBox.sizeType = IconSizeType.ICON36;
//			iconBox.data = data;
//			PopupManager.instance.showPopup(null, iconBox, false, startPos);
//			var targetGlobalPos:Point = target.localToGlobal(new Point());
//			GTweener.to(iconBox, duration, {x: targetGlobalPos.x, y: targetGlobalPos.y, width: widthTo, height: heightTo, alpha: alphaTo}, {useFrames: true}).onComplete = function(gTween:GTween):void
//			{
//				PopupManager.instance.removePopup(gTween.target as DisplayObject);
////				IconBoxPoolManager.getPool(IconSizeType.ICON36.toString()).removeObj(IPoolClient(gTween.target));
//				var listItemRender:ITListItemRender = ITListItemRender(target);
//				ShortCutHelper.setShortCut(listItemRender.index, data);
//				//特效
//				var _identifySuccEffect:MovieClip = TRslManager.getInstance(ResLib.UI_EFFECT_SCENE_JIANDING_BUTTON);
//				_identifySuccEffect.blendMode = BlendMode.ADD;
//				_identifySuccEffect.x = (target.width - _identifySuccEffect.width) / 2;
//				_identifySuccEffect.y = (target.height - _identifySuccEffect.height) / 2;
//				SpecialEffectManager.addEffetToProxy(target as DisplayObjectContainer, _identifySuccEffect, 1);
//			};
//		}
	}
}
