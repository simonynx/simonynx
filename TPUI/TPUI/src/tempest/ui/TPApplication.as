package tempest.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import tempest.manager.KeyboardManager;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TImage;
	import tempest.ui.components.TLayoutContainer;
	import tempest.utils.Fun;

	public class TPApplication extends TLayoutContainer
	{
		private var _application:TLayoutContainer;
		private var _popupLayer:TLayoutContainer;

		public function TPApplication(minWidth:Number = 0, minHeight:Number = 0, maxWidth:Number = 10000, maxHeight:Number = 10000)
		{
			_minWidth = minWidth;
			_minHeight = minHeight;
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			super();
			if (TPUGlobals.app != null)
				throw new Error("只能存在一个TPAPP实例");
			TPUGlobals.app = this;
			if (stage)
				this.onAddedToStage(null);
			else
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function get application():TLayoutContainer
		{
			return _application;
		}

		public function get popupLayer():TLayoutContainer
		{
			return _popupLayer;
		}

		final override protected function addChildren():void
		{
			_application = new TLayoutContainer({left: 0, right: 0, top: 0, bottom: 0});
			this.addChild(_application);
			_popupLayer = new TLayoutContainer({left: 0, right: 0, top: 0, bottom: 0});
			_popupLayer.mouseEnabled = false;
			this.addChild(_popupLayer);
		}

		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			TPUGlobals.stage = this.stage;
			if (stage.stageWidth == 0 && stage.stageHeight == 0)
				stage.addEventListener(Event.RESIZE, initStageSize);
			else
				initStageSize(null);
		}

		private function initStageSize(event:Event):void
		{
			if (stage.stageWidth > 0 || stage.stageHeight > 0)
			{
				if (event)
					stage.removeEventListener(Event.RESIZE, initStageSize);
				//设置stage属性
				stage.stageFocusRect = false; //指定对象在具有焦点时是否显示加亮的边框。
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.quality = StageQuality.HIGH;
				stage.showDefaultContextMenu = false;
				//注册管理器
				this.initmanagers();
				//初始化应用
				this.initApp();
				stage.addEventListener(Event.RESIZE, onStageResizeHandler, false, 0, true);
				onStageResizeHandler(null);
			}
		}

		private function initmanagers():void
		{
			KeyboardManager.init(this.stage);
			TToolTipManager.instance.initialize(this); //提示管理器
			PopupManager.instance.register(_application, _popupLayer); //注册弹窗管理器
			CursorManager.instance.register(this); //注册光标管理器
		}

		private function onStageResizeHandler(event:Event):void
		{
			this.setSize(Math.max(stage.stageWidth, _minWidth), Math.max(stage.stageHeight, _minHeight));
		}

		protected function initApp():void
		{
		}

		public function get totalChildrenNum():int
		{
			return Fun.getNumChildren(this);
		}
	}
}
