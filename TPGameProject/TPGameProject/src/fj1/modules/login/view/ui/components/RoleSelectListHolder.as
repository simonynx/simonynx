package fj1.modules.login.view.ui.components
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.plugins.CurrentFramePlugin;

	import fj1.common.ui.effects.MovieClipCirclePlayEffect;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.core.IFactory;

	import tempest.ui.collections.TFixedLayoutItemHolder;
	import tempest.ui.components.TListItemRenderProxy;
	import tempest.ui.core.IProxyFactory;
	import tempest.ui.events.ListEvent;

	public class RoleSelectListHolder extends TFixedLayoutItemHolder
	{
		[ArrayElementType("Number")]
		private const _indexToFrame:Array = [1, 6, 11, 16, 21];
		private var _effectPlayer:MovieClipCirclePlayEffect;

		public function RoleSelectListHolder(itemProxyContainer:DisplayObjectContainer, listItemRenderClass:* = null, itemName:String = null, items:Array = null,
			disableDropDownChange:Boolean = true, itemRenderCreateHandler:Function = null)
		{
			super(itemProxyContainer, listItemRenderClass, itemName, items, disableDropDownChange, itemRenderCreateHandler);
			_effectPlayer = new MovieClipCirclePlayEffect(MovieClip(itemProxyContainer), onEffectComplete);
		}

		override protected function onSelect(event:Event):void
		{
			var tlistItem:TListItemRenderProxy = TListItemRenderProxy(event.currentTarget);

			_effectPlayer.data = tlistItem.index;
			_effectPlayer.play(_indexToFrame[tlistItem.index]);
		}

		private function onEffectComplete(effect:MovieClipCirclePlayEffect):void
		{
			super.selectedIndex = int(effect.data);
		}

		override public function set selectedIndex(value:int):void
		{
			_effectPlayer.data = value;
			_effectPlayer.play(_indexToFrame[value]);
		}

		public function set selectedIndexNow(value:int):void
		{
			_effectPlayer.stop(_indexToFrame[value]);
			super.selectedIndex = value;
		}
	}
}
