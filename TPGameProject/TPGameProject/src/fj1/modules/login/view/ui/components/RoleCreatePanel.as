package fj1.modules.login.view.ui.components
{
	import assets.UIRoleLib;

	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.net.tcpLoader.NameCheckLoader;
	import fj1.common.res.ResPaths;
	import fj1.common.res.hero.ProfessionManager;
	import fj1.common.res.hero.vo.ProfessionRes;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.npc.NpcResManager;
	import fj1.common.res.randomName.RandomNameManager;
	import fj1.common.staticdata.Profession;
	import fj1.common.staticdata.RegexConst;
	import fj1.common.ui.TInputText;
	import fj1.manager.DirtyWordManager;
	import fj1.manager.MessageManager;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import mx.events.FlexEvent;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.TPEngine;
	import tempest.common.rsl.RslManager;
	import tempest.common.rsl.TRslManager;
	import tempest.common.rsl.vo.TRslType;
	import tempest.common.rsl.vo.TRslVO;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.collections.TFixedLayoutItemHolder;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TGroup;
	import tempest.ui.components.TImage;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TRadioButton;
	import tempest.utils.StringUtil;

	public final class RoleCreatePanel extends TComponent
	{
		public var btn_create:TButton;
		public var btn_randomName:TButton;
		public var tInput_name:TInputText;
		public var mc_selectedRole:MovieClip;

		public var roleList:TFixedLayoutItemHolder;

		/////////////////////////////////////////

		public function RoleCreatePanel()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, RslManager.getDefinition(UIRoleLib.UI_CHARACATER_CREATE));
		}

		override protected function addChildren():void
		{
			btn_create = new TButton(null, _proxy.btn_create);
			btn_randomName = new TButton(null, _proxy.btn_randomName);
			mc_selectedRole = _proxy.mc_selectedRole;
			_proxy.txt_name.text = "";
			tInput_name = new TInputText(null, null, _proxy.txt_name, "");
			tInput_name.restrict = RegexConst.NameRegExp.source;
			tInput_name.addEventListener(Event.CHANGE, function(e:Event):void
			{
				tInput_name.text = StringUtil.toDBC(tInput_name.text);
			});
			tInput_name.byteLimitModel(14);

			roleList = new TFixedLayoutItemHolder(_proxy, TListItemRender, "item");
			//-----------------------
//			txt_name.restrict = RegexUtil.Chinese+RegexUtil.Letter+RegexUtil.Number;
		}
	}
}
