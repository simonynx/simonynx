package fj1.modules.mainUI.hintAreas
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	import tempest.ui.components.TComponent;

	public class SceneNameEffectPanel extends TComponent
	{
		private var _nameContainer:MovieClip;
		private var _effect:MovieClip;
		private var _dispObj:DisplayObject;

		public function SceneNameEffectPanel(constraints:Object = null, proxy:* = null)
		{
			super(constraints, proxy);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_nameContainer = _proxy.mc_mapname;
			_effect = _proxy;
			_effect.gotoAndStop(_effect.totalFrames);
			this.visible = false;
		}

		public function addDisplayObject(displayObj:DisplayObject):void
		{
			if (_dispObj)
			{
				_nameContainer.removeChild(_dispObj);
				_dispObj = null;
				this.visible = false;
			}
			if (displayObj)
			{
				this.visible = true;
				var thisRef:SceneNameEffectPanel = this;
				_effect.addFrameScript(_effect.totalFrames - 1, function():void
				{
					_effect.addFrameScript(_effect.totalFrames - 1, null);
					_effect.stop();
					_nameContainer.removeChild(_dispObj);
					_dispObj = null;
					thisRef.visible = false;
				});
				_effect.gotoAndPlay(1);
				_dispObj = displayObj;
				_nameContainer.addChild(_dispObj);
				_dispObj.x = -_dispObj.width * 0.5;
				_dispObj.y = -_dispObj.height * 0.5;
			}
		}
	}
}
