package fj1.modules.login.view
{
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.tcpLoader.NameCheckLoader;
	import fj1.common.res.ResPaths;
	import fj1.common.res.baseConfig.BaseConfigManager;
	import fj1.common.res.hero.ProfessionManager;
	import fj1.common.res.hero.vo.ProfessionRes;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.randomName.RandomNameManager;
	import fj1.common.staticdata.BaseConfigKeys;
	import fj1.common.staticdata.Profession;
	import fj1.common.staticdata.RegexConst;
	import fj1.manager.DirtyWordManager;
	import fj1.modules.login.net.LoginService;
	import fj1.modules.login.signals.LoginUISignals;
	import fj1.modules.login.view.ui.LoginUI;
	import fj1.modules.login.view.ui.components.RoleCreatePanel;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.common.mvc.base.Mediator;
	import tempest.common.rsl.vo.TRslVO;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TRadioButton;
	import tempest.utils.ListenerManager;
	import tempest.utils.StringUtil;

	public class LoginUI_RoleCreatePanelMediator extends Mediator
	{
		[Inject]
		public var roleCreatePanel:RoleCreatePanel;
		[Inject]
		public var loginUISignals:LoginUISignals;
		[Inject]
		public var loginService:LoginService;

		private var _listenerMgr:ListenerManager;

		private var _curFigure:int; //当前头像

		public function LoginUI_RoleCreatePanelMediator()
		{
			super();
			_listenerMgr = new ListenerManager();
		}

		override public function onRegister():void
		{
			GameInstance.app.stage.focus = roleCreatePanel.tInput_name.textField;
			_listenerMgr.addEventListener(roleCreatePanel.btn_create, MouseEvent.CLICK, onCreateBtnClick);
			_listenerMgr.addEventListener(roleCreatePanel.btn_randomName, MouseEvent.CLICK, onRandomNameHandler);
			_listenerMgr.addEventListener(roleCreatePanel, KeyboardEvent.KEY_DOWN, onKeyDowns);
			_listenerMgr.addEventListener(roleCreatePanel.roleList, Event.SELECT, onSelectRole);

			roleCreatePanel.mc_selectedRole.visible = false;
			roleCreatePanel.roleList.selectedIndex = 0;
		}

		override public function onRemove():void
		{
			_listenerMgr.removeAll();
		}

//		private function onBtClickHandler(event:MouseEvent):void
//		{
//			switch (event.currentTarget)
//			{
//				case roleCreatePanel.btn_checkName:
//					if (!checkName(StringUtil.trim(roleCreatePanel.tInput_name.text)))
//					{
//						return;
//					}
//					var loader:NameCheckLoader = new NameCheckLoader(roleCreatePanel.tInput_name.text);
//					loader.signals.complete.add(onCheckNameComplete);
//					loader.load(); //验证名称
//					break;
//				case roleCreatePanel.btn_create:
//					this.createRole();
//					break;
//			}
//		}

		private function onCreateBtnClick(event:MouseEvent):void
		{
			createRole();
		}

		private var usedNames:Object = {};

		/**
		 * 验证名称结果
		 * @param loader
		 *
		 */
		private function onCheckNameComplete(loader:NameCheckLoader):void
		{
			loader.signals.complete.remove(onCheckNameComplete);
			var result:int = loader.content as int;
			if (result == 0)
			{
				TAlert.Show(LanguageManager.translate(50297, "該姓名可以使用"));
					//				MessageManager.instance.addHintById_client(1731, "该昵称可以使用");
			}
			else
			{
				usedNames[loader.playerName] = true;
				TAlert.Show(LanguageManager.translate(50269, "这个名字已经存在了"));
					//				MessageManager.instance.addHintById_client(1730, "该昵称不可使用");
			}
		}


		private function createRole():void
		{
			var _charName:String = StringUtil.trim(roleCreatePanel.tInput_name.text)
			if (!checkName(_charName))
			{
				return;
			}
			loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45005, "正在创建角色..."));

			var cardIdStrs:Array = BaseConfigManager.getConfig(BaseConfigKeys.MAIN_CARD_IDS).split(",");
			var cardId:int = cardIdStrs[roleCreatePanel.roleList.selectedIndex] as int;

			loginService.sendCharacterCreateRequest(_charName, cardId);
		}

		private function onKeyDowns(event:KeyboardEvent):void
		{
			if (event.charCode == 13 || event.keyCode == 13)
			{
				this.createRole();
			}
		}

		//非法的玩家名称（角斗士、暗法师、月神使、魅舞者）
		private var invalidNames:Array = [Profession.getName(Profession.Avenger), Profession.getName(Profession.DarkMage),
			Profession.getName(Profession.Gladiator), Profession.getName(Profession.Luna)];

		private function checkName(name:String):Boolean
		{
			if (name.length == 0)
			{
				TAlertHelper.showDialog(1726, "人物姓名不能为空");
				return false;
			}
			var strByteLen:int = StringUtil.getStrByteLength(name);
			if (strByteLen < 4 || strByteLen > 14)
			{
				TAlertHelper.showDialog(1718, "角色名应该为2-7个汉字或4-14个字母!");
				return false;
			}
			else if (RegexConst.nameTest(name) || invalidNames.indexOf(name) != -1)
			{
				TAlertHelper.showDialog(1719, "人物姓名中含有非法字符");
				return false;
			}
			else if (DirtyWordManager.hasDirtyWord(name))
			{
				TAlertHelper.showDialog(1727, "人物姓名中含有敏感词");
				return false;
			}
			else if (usedNames[name])
			{
				TAlert.Show(LanguageManager.translate(50269, "这个名字已经存在了"));
				return false;
			}
			return true;
		}

		private function onSelectRole(event:Event):void
		{
			var index:int = roleCreatePanel.roleList.selectedIndex;
			if (index < 0)
			{
				roleCreatePanel.mc_selectedRole.visible = false;
			}
			else
			{
				roleCreatePanel.mc_selectedRole.visible = true;
				roleCreatePanel.mc_selectedRole.gotoAndStop(index + 1);
			}
		}

		//随机取名
		private function onRandomNameHandler(event:MouseEvent):void
		{
			getRandomName();
		}

		//*****************************随机名字*******************************
		private var _firstname:String; //名字
		private var _lastname:String; //姓
		private var _sex:int; //性别
		private var _boyNameArr:Array; //男名字数组
		private var _girlNameArr:Array; //女名字数组
		private var _lastnameArr:Array; //姓数组

		private function getRandomName():void
		{
			_boyNameArr = RandomNameManager.getNameArr("firstname_boy");
			_girlNameArr = RandomNameManager.getNameArr("firstname_girl");
			_lastnameArr = RandomNameManager.getNameArr("lastname");
			if (_boyNameArr == [] || _girlNameArr == [] || _lastnameArr == [])
				return;
			_lastname = _lastnameArr[Math.floor(Math.random() * _lastnameArr.length)];
			if (_sex == Profession.SEX_BOY)
				_firstname = _boyNameArr[Math.floor(Math.random() * _boyNameArr.length)];
			else
				_firstname = _girlNameArr[Math.floor(Math.random() * _girlNameArr.length)];
			roleCreatePanel.tInput_name.text = _lastname + "·" + _firstname;
		}
	}
}
