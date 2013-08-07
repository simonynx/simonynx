package fj1.manager
{
	import assets.UIHudLib;
	import fj1.common.GameInstance;
	import fj1.common.helper.IconContainerHelper;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.messageBox.model.vo.MessageInfo;
	import fj1.modules.messageBox.view.components.MessagePanel;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.TPUGlobals;

	public class FloatIconManager
	{
		private static var _instance:FloatIconManager;
		private var _configArray:Array = [
			{kind: MessageInfo.MESSAGE_KIND_FRIEND, simbol: UIHudLib.UI_GAME_GUI_FRIEND},
			{kind: MessageInfo.MESSAGE_KIND_TEAM, simbol: UIHudLib.UI_GAME_GUI_TEAM},
			{kind: MessageInfo.MESSAGE_KIND_TRADE, simbol: UIHudLib.UI_GAME_GUI_TRADE},
			{kind: MessageInfo.MESSAGE_KIND_GUILD, simbol: UIHudLib.UI_GAME_GUI_GUILD}
			];
		public static const NAME_FRIEND:String = "MessageBoxFriend";
		public static const NAME_TEAM:String = "MessageBoxTeam";
		public static const NAME_TRADE:String = "MessageBoxTrade";
		public static const NAME_GUILD:String = "MessageBoxGuild";

		public static function get instance():FloatIconManager
		{
			if (!_instance)
				new FloatIconManager();
			return _instance;
		}

		public function FloatIconManager()
		{
			if (_instance)
				throw new Error("该类只能存在一个实例");
			_instance = this;
		}

		public function createIcon(kind:int, name:String):void
		{
			for each (var config:Object in _configArray)
			{
				if (kind == config.kind)
				{
//					var icon:MovieClip = _iconArray[kind] as MovieClip;
					var icon:MovieClip;
//					if (!icon)
//					{
					icon = TRslManager.getInstance(config.simbol);
					icon.name = name;
					icon.buttonMode = true;
					showIcon(icon);
//						_iconArray[kind] = icon;
					icon.addEventListener(MouseEvent.CLICK, onClick);
//					icon.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					icon.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
					icon.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//					}
				}
			}
		}

		private function onEnterFrame(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			myImgArea.setIconPos();
		}

		private function onRemovedFromStage(event:Event):void
		{
			event.target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			myImgArea.setIconPos();
		}

		private function onAddedToStage(event:Event):void
		{
			myImgArea.setIconPos();
		}
		public var myImgArea:IconContainerHelper = new IconContainerHelper({horizontalCenter: 0, top: 150});
		public var iconArr:Array = [];

		public function showIcon(displayObj:DisplayObject):void
		{
			myImgArea.setChild(displayObj);
			iconArr.push(displayObj);
			GameInstance.app.mainUI.addMessagePanel(myImgArea);
		}

		private function onClick(event:MouseEvent):void
		{
			TWindowManager.instance.showPopup2(null, MessagePanel.NAME, false, false, TWindowManager.MODEL_USE_OLD, null, null, event.currentTarget.name);
		}
	}
}
