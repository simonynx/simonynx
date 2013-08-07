package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.items.SpellBookData;
	import fj1.common.helper.TrackHelper;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.spell.vo.SkillInfo;
	import fj1.common.staticdata.ColorConst;
	import fj1.common.staticdata.Profession;
	import fj1.common.staticdata.WindowGroupType;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.WindowGroupManager;
	import fj1.manager.CharactersIconManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SkillDataManager;
	import fj1.modules.messageBox.model.vo.MessageInfo;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.components.TButton;
	import tempest.utils.HtmlUtil;

	public class SkillBookLearnDialog extends BaseWindow
	{
		public static var NAME:String = "SkillBookLearn";
		private var _btn_submit:TButton;
		private var _btn_cancel:TButton;
		private var _bookID:uint;
		private var _skillInfo:SkillInfo = null;
		private var _watch:ChangeWatcherManager = new ChangeWatcherManager();

		public function SkillBookLearnDialog()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_SKILLINFO_LEARN), NAME);
			_btn_submit = new TButton(null, _proxy.btn_submit, LanguageManager.translate(4014, "立即学习"), onLeran);
			_btn_cancel = new TButton(null, _proxy.btn_cancel, LanguageManager.translate(100009, "取消"), onClose);
			_proxy.txt_professions.text = "";
			_proxy.txt_levelReq.text = "";
			_proxy.txt_moneyReq.text = "";
			_proxy.txt_beliefReq.text = "";
		}

		public function get btn_submit():TButton
		{
			return _btn_submit;
		}

		public function get bookID():uint
		{
			return _bookID;
		}

		public function set bookID(value:uint):void
		{
			_bookID = value;
			_skillInfo = SkillDataManager.instance.getSkillInfoByItemID(bookID);
			if (_skillInfo)
			{
				_proxy.txt_professions.text = Profession.getName(_skillInfo.need_profession);
				_watch.bindSetter(levelChange, GameInstance.mainCharData, "level");
				_watch.bindSetter(moneyChange, GameInstance.mainCharData, "money");
				_watch.bindSetter(beliefChange, GameInstance.mainCharData, "belief");
			}
		}

		/**
		 * 点击关闭按钮处理
		 * @param event
		 *
		 */
		protected override function onClose(event:MouseEvent):void
		{
			_watch.unWatchAll();
			closeWindow();
		}

		private function levelChange(value:int):void
		{
			if (_skillInfo)
			{
				_proxy.txt_levelReq.htmlText = ((value >= _skillInfo.need_level) ? _skillInfo.need_level.toString() : HtmlUtil.color(ColorConst.red, _skillInfo.need_level.toString())); //消耗等级
			}
		}

		private function moneyChange(value:int):void
		{
			if (_skillInfo)
			{
				_proxy.txt_moneyReq.htmlText = ((value >= _skillInfo.consume_money) ? _skillInfo.consume_money.toString() : HtmlUtil.color(ColorConst.red, _skillInfo.consume_money.toString())); //消耗金钱
			}
		}

		private function beliefChange(value:int):void
		{
			if (_skillInfo)
			{
				_proxy.txt_beliefReq.htmlText = ((value >= _skillInfo.consume_belief) ? _skillInfo.consume_belief.toString() : HtmlUtil.color(ColorConst.red, _skillInfo.consume_belief.toString())); //消耗信仰力
			}
		}

		private function onLeran(e:MouseEvent):void
		{
			if (SkillDataManager.instance.learnSkillByItemID(bookID))
			{
				MessageManager.instance.addHintById_client(108, "打开技能面板查看学习的技能");
				this.closeWindow();
			}
			else
			{
				MessageManager.instance.addHintById_client(405, "学习该技能条件不够！");
			}
		}
	}
}
