package fj1.modules.chat.view.components
{
	import assets.UIHudLib;
	import com.gskinner.motion.GTweener;
	import com.riaidea.text.RichTextField;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.layoutDesign.LayoutDesignManager;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.LayoutDesignConst;
	import fj1.common.ui.TDragBar;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.chat.model.vo.ChannelListItemData;
	import fj1.modules.chat.view.TextInputHistoryLogger;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import tempest.TPEngine;
	import tempest.common.rsl.RslManager;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.TPUGlobals;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TCheckBox;
	import tempest.ui.components.TCombobox;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDefaultCombobox;
	import tempest.ui.components.TLayoutContainer;
	import tempest.ui.components.textFields.TRichTextField;
	import tempest.ui.effects.MenuEffect;

	/**
	 *聊天主窗口
	 */
	public final class MainChatPanel extends TLayoutContainer
	{
		public static const NAME:String = "MainChatPanel";
		/**
		 * 当前聊天窗口的聊天记录
		 */
//		public var currChatArray:Array = [];
		//输入框
		public var rtf_input:TRichTextField;
		public var btn_send:TButton;
		public var btn_face:TButton;
		public var btn_horn:TButton; //号角按钮
		public var inputLogger:TextInputHistoryLogger;
		//设置聊天显示状态按钮
		public var cbox_showMain:TCheckBox;
		//
		private var _inputArea:TLayoutContainer;
		private var _inputBK:TComponent;
		private var _maxInputWidth:Number; //最大输入区域宽度
		private var _inputTxtRightPadding:Number; //输入框到右边的边距
		public var chatPanel:ChatPanel;
		public var hornPanel:HornPanel;
		//频道选择列表
		public var _btn_change_CH:TCombobox;
		public var smileylistPanel:SmileyListPanel;
		//大小变化拖动组件
//		private var _horizonDragbar:TDragBar;
//		private var _verticalDragbar:TDragBar;
		private var _cornerDragbar:TDragBar;
		private var _originMinHeight:Number;
		//
		public var txtFormat:TextFormat = new TextFormat("Courier New", 12, UIStyle.NORMAL_TEXT, false, false, false);
		private static const FRAME_MC_CHAT_VISIBLE:int = 1;
		private static const FRAME_MC_CHAT_UN_VISIBLE:int = 2;
		//
		public var _isFocusInChat:Boolean = false;

		//-------------------------------------------------------------------------------
		public function MainChatPanel()
		{
			super(LayoutDesignManager.getConstraintsByID(LayoutDesignConst.PANEL_MAINCHAT), RslManager.getInstance(UIHudLib.UI_GAME_GUI_MAINCHAT));
			chatPanel.bgAlpha = 0;
//			_hornPanel.bgAlphgetMenuDataa = 0;
			_cornerDragbar.alpha = 0;
			//缩放参数
			childAutoTopEnabled = true;
			_originMinHeight = this.height;
			_minWidth = chatPanel.width;
			_minHeight = this.height;
			_maxHeight = this.height * 3;
			_maxInputWidth = _inputArea.width * 1.5;
		}

		override protected function addChildren():void
		{
			//输入部分控件
			initInputControls();
			//聊天主框
			hornPanel = new HornPanel({left: 0, top: 0}, _proxy.mc_horn);
			this.addChild(hornPanel);
			chatPanel = new ChatPanel(null, _proxy.mc_chatMain);
			chatPanel.constraints = {left: 0, top: hornPanel.height - 40, bottom: _inputArea.height};
			this.addChild(chatPanel);
			//拖动条
			initDragbar();
			//消息主框
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}

		private function initInputControls():void
		{
			_inputArea = new TLayoutContainer({left: 0, bottom: 0}, _proxy.mc_inputArea);
			_inputBK = new TComponent({left: 0, right: 0}, _proxy.mc_inputArea.mc_inputBk);
			_inputArea.addChild(_inputBK);
			//输入框
			initChatInput();
			_inputArea.addChild(rtf_input);
			//发送按钮
			btn_send = new TButton(null, _proxy.mc_inputArea.btn_send);
			btn_send.constraints = {right: _inputArea.width - btn_send.x - btn_send.width};
			btn_send.toolTipString = LanguageManager.translate(12014, "点击后发送聊天框内的信息");
			_inputArea.addChild(btn_send);
			//表情显示按钮
			btn_face = new TButton(null, _proxy.mc_inputArea.btn_face);
			btn_face.constraints = {right: _inputArea.width - btn_face.x - btn_face.width};
			btn_face.toolTipString = LanguageManager.translate(12018, "点击选择表情");
			_inputArea.addChild(btn_face);
			//号角铵钮
			btn_horn = new TButton(null, _proxy.mc_inputArea.btn_horn, null, onHornClickHandler);
			btn_horn.constraints = {right: _inputArea.width - btn_horn.x - btn_horn.width};
			_inputArea.addChild(btn_horn);
			//表情选择面板
			smileylistPanel = new SmileyListPanel(btn_face);
			//设置聊天显示状态按钮
			cbox_showMain = new TCheckBox(null, _proxy.mc_inputArea.mc_showMain, "", MovieClipResModel.MODEL_FRAME_2);
			cbox_showMain.constraints = {right: 0};
			cbox_showMain.addEventListener(Event.CHANGE, onSwitchChatVisible);
			cbox_showMain.toolTipString = LanguageManager.translate(12016, "点击后隐藏或显示聊天频道信息显示区");
			_inputArea.addChild(cbox_showMain);
			//频道选择菜单
			_btn_change_CH = new TDefaultCombobox(null, _proxy.mc_inputArea.btn_changeCH, null, null, ChannelItemRender, null);
			_btn_change_CH.constraints = {left: _btn_change_CH.x};
			_btn_change_CH.direct = MenuEffect.DERECT_UP;
			_btn_change_CH.items = [new ChannelListItemData(ChatConst.CHANNEL_TEAM),
				new ChannelListItemData(ChatConst.CHANNEL_PRIVATE),
				new ChannelListItemData(ChatConst.CHANNEL_ROUND),
				new ChannelListItemData(ChatConst.CHANNEL_GUILD),
				new ChannelListItemData(ChatConst.CHANNEL_WORLD),
				new ChannelListItemData(ChatConst.CHANNEL_BATTLELAND)
//				new ChannelListItemData(ChatConst.CHANNEL_HORN),
				];
			_btn_change_CH.selectedIndex = 2;
			_inputArea.addChild(_btn_change_CH);
			this.addChild(_inputArea);
		}

		private function initChatInput():void
		{
			rtf_input = new TRichTextField();
			rtf_input.x = _proxy.mc_inputArea.mc_msg.x
			rtf_input.y = _proxy.mc_inputArea.mc_msg.y
			rtf_input.setSize(_proxy.mc_inputArea.mc_msg.width, _proxy.mc_inputArea.mc_msg.height);
			rtf_input.type = RichTextField.INPUT;
			rtf_input.textfield.multiline = false;
			rtf_input.textfield.wordWrap = false;
			rtf_input.textfield.maxChars = ChatConst.MAX_INPUT_LEN;
			rtf_input.defaultTextFormat = txtFormat;
			rtf_input.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			rtf_input.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			inputLogger = new TextInputHistoryLogger(rtf_input, txtFormat);
			_inputTxtRightPadding = _inputArea.width - rtf_input.x - rtf_input.width;
		}

		/**
		 * 初始化拖动条
		 *
		 */
		private function initDragbar():void
		{
//			_horizonDragbar = new TDragBar({left: 0, right: 0, top: _hornPanel.height + 1}, createRectSprite(this.width, 5), this);
//			_horizonDragbar.autoTopPriority = 1;
//			_horizonDragbar.dragingSignal.add(onHorizonDrag);
//			_horizonDragbar.stopDragSignal.add(onDragComplete);
//			_verticalDragbar = new TDragBar({right: 0, top: 0, bottom: 0}, createRectSprite(5, this.height), this);
//			_verticalDragbar.autoTopPriority = 1;
//			_verticalDragbar.dragingSignal.add(onVerticalDrag);
//			_verticalDragbar.stopDragSignal.add(onDragComplete);
			_cornerDragbar = new TDragBar(null, _proxy.mc_corner, chatPanel, false);
			_cornerDragbar.constraints = {right: -_cornerDragbar.width * 0.5, top: -_cornerDragbar.height * 0.5};
			_cornerDragbar.mouseChildren = false;
			_cornerDragbar.useHandCursor = _cornerDragbar.buttonMode = true;
			_cornerDragbar.autoTopPriority = 1;
			_cornerDragbar.dragingSignal.add(onCornerDrag);
			_cornerDragbar.stopDragSignal.add(onDragComplete);
			chatPanel.addChild(_cornerDragbar);
		}

		private function createRectSprite(width:Number, height:Number):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000, 0);
			sp.graphics.drawRect(0, 0, width, height);
			sp.graphics.endFill();
			return sp;
		}

		override protected function implementSize(width:Number, height:Number):void
		{
			super.implementSize(width, height);
			rtf_input.setSize(width - rtf_input.x - btn_send.width - (this.width - btn_send.x - btn_send.width), rtf_input.height);
		}

		/**
		 * 纵向拖动处理
		 * @param mouseX
		 * @param mouseY
		 *
		 */
		private function onHorizonDrag(mouseX:Number, mouseY:Number):void
		{
			var newHeight:Number = -mouseY + this.height; //+ hornPanel.height;
			if (newHeight < _minHeight)
			{
				newHeight = _minHeight;
			}
			this.height = newHeight;
			this.invalidatePosition();
		}

		/**
		 * 横向拖动处理
		 * @param mouseX
		 * @param mouseY
		 *
		 */
		private function onVerticalDrag(mouseX:Number, mouseY:Number):void
		{
			if (mouseX < _minWidth)
			{
				mouseX = _minWidth;
			}
//			this.width = mouseX;
			chatPanel.width = mouseX;
			if (mouseX > _maxInputWidth)
			{
				_inputArea.width = _maxInputWidth;
			}
			else
			{
				_inputArea.width = mouseX;
			}
			rtf_input.setSize(_inputArea.width - rtf_input.x - _inputTxtRightPadding, rtf_input.height);
		}

		/**
		 * 右上角拖动处理
		 * @param mouseX
		 * @param mouseY
		 *
		 */
		private function onCornerDrag(mouseX:Number, mouseY:Number):void
		{
			onHorizonDrag(mouseX, mouseY);
			onVerticalDrag(mouseX, mouseY);
		}

		private function onDragComplete(dragBar:TDragBar):void
		{
			if (!this.hitTestPoint(TPUGlobals.stage.mouseX, TPUGlobals.stage.mouseY))
			{
				tweenHide();
			}
		}

		private function tweenHide():void
		{
			GTweener.to(_cornerDragbar, 0.2, {alpha: 0});
			GTweener.to(chatPanel, 0.2, {bgAlpha: 0});
		}

		private function tweenShow():void
		{
			GTweener.to(_cornerDragbar, 0.5, {alpha: 1});
			GTweener.to(chatPanel, 0.5, {bgAlpha: 1});
		}

		private function onFocusIn(event:FocusEvent):void
		{
			_isFocusInChat = true;
//			GTweener.to(this,0.5,{inputbgAlpha:1});
		}

		private function onFocusOut(event:FocusEvent):void
		{
			if (rtf_input.text.length == 0 && !this.hitTestPoint(TPEngine.stage.mouseX, TPEngine.stage.mouseY))
			{
//				GTweener.to(this,0.2,{inputbgAlpha:0});
			}
			_isFocusInChat = false;
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		//自动隐藏
		private function onMouseOver(event:MouseEvent):void
		{
			tweenShow();
		}

		private function onMouseOut(event:MouseEvent):void
		{
			if (_cornerDragbar.draging)
			{
				return;
			}
			tweenHide();
		}

		/**
		 *弹出号角输入框
		 * @param evt
		 *
		 */
		private function onHornClickHandler(evt:MouseEvent):void
		{
			TWindowManager.instance.showPopup2(null, HornInputPanel.NAME, false, false, TWindowManager.MODEL_REMOVE_OR_ADD);
		}

		/**
		 * 设置文本框光标位置
		 * @param index
		 *
		 */
		public function setTextFieldSelection(index:int):void
		{
			this.addEventListener(Event.ENTER_FRAME, function(event:Event):void
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				rtf_input.textfield.setSelection(index, index); //光标设置到目标位置
			});
		}

		/**
		 * 获取 channelId 对应的Combobox数据项
		 * @param channelId
		 * @return
		 *
		 */
		public function getMenuData(channelId:int):ChannelListItemData
		{
			for (var i:int = 0; i < _btn_change_CH.items.length; i++)
			{
				var element:ChannelListItemData = _btn_change_CH.items[i] as ChannelListItemData;
				if (element.channelId == channelId)
				{
					return element;
				}
			}
			return null;
		}

		private function onSwitchChatVisible(event:Event):void
		{
			if (cbox_showMain.selected)
			{
				//选中时合起
				this.removeChild(chatPanel);
				//msgFrame下移_inputArea
//				_hornPanel.y = _inputArea.y - _hornPanel.height;
				this._minHeight = hornPanel.height + _inputArea.height;
				this.height = hornPanel.height + _inputArea.height;
				this.invalidatePosition();
				_cornerDragbar.visible = false;
			}
			else
			{
				//未选中时展开
				this._minHeight = _originMinHeight;
				this.height = hornPanel.height - 40 + chatPanel.height + _inputArea.height;
				this.addChild(chatPanel);
				//msgFrame上移
//				_hornPanel.y = _chatPanel.y - _hornPanel.height;
//				_inputArea.y = _chatPanel.y + _chatPanel.height;
				this.invalidatePosition();
				_cornerDragbar.visible = true;
			}
		}

		/**
		 * 设置焦点到聊天框
		 *
		 */
		public function setChatFocus():void
		{
			if (stage && stage.focus != rtf_input.textfield)
			{
				stage.focus = rtf_input.textfield;
			}
			_isFocusInChat = true;
//			inputbgAlpha = 1;
		}

//		/**
//		 * 设置焦点到场景
//		 *
//		 */
//		public function setFocusToScreen():void
//		{
//			TPEngine.stage.focus = TPEngine.stage;
////			inputbgAlpha = 0;
//		}
		public function set inputbgAlpha(value:Number):void
		{
			cbox_showMain.alpha = value;
			_btn_change_CH.alpha = value;
			btn_send.alpha = value;
			_proxy.mc_inputArea.alpha = value;
			rtf_input.alpha = value;
		}

		public function get inputbgAlpha():Number
		{
			return _proxy.mc_inputArea.alpha;
		}
//		override public function invalidateSize(changed:Boolean = false):void
//		{
//
//		}
	}
}
import fj1.common.staticdata.ChatConst;
import fj1.modules.chat.model.vo.ChannelListItemData;
import flash.display.DisplayObjectContainer;
import tempest.ui.components.MenuListItemRender;

class ChannelItemRender extends MenuListItemRender
{
	public function ChannelItemRender(_proxy:*, data:Object)
	{
		super(_proxy, data);
		nameProperty = null;
	}

	override public function set data(value:Object):void
	{
		super.data = value;
		var id:int = ChannelListItemData(value).channelId;
		_text.text = ChatConst.getChannelName(id) + ChatConst.getShortCutStrByChannelId(id);
		this.measureChildren();
	}
}
