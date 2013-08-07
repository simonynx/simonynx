package fj1.modules.loading.controller
{
	import flash.events.Event;
	
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import fj1.common.config.CustomConfig;
	import fj1.common.res.ResPaths;
	import fj1.common.res.card.CardTemplateManager;
	import fj1.common.res.chat.ChatSmileyConfigManager;
	import fj1.common.res.hero.ProfessionManager;
	import fj1.common.res.hint.HintResManager;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.layoutDesign.LayoutDesignManager;
	import fj1.common.res.map.MapResManager;
	import fj1.common.res.monster.MonsterResManager;
	import fj1.common.res.npc.NpcResManager;
	import fj1.common.res.randomName.RandomNameManager;
	import fj1.common.res.skill.MagicTemplateMannage;
	import fj1.common.res.skill.SkillTemplateManager;
	import fj1.common.res.sound.SoundManager;
	import fj1.common.res.window.WindowSkinMannager;
	import fj1.common.staticdata.HintConst;
	import fj1.modules.loading.model.vo.XMLLoadInfo;
	import fj1.modules.loading.signals.LoadSignals;
	import fj1.modules.loading.signals.LoadViewSignals;
	
	import shell.AppUIMananger;
	import shell.AppUINames;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Command;
	import tempest.common.rsl.RslManager;
	import tempest.engine.graphics.animation.Animation;
	import tempest.utils.Fun;
	import tempest.utils.XMLAnalyser;
	
	import tpe.manager.FilePathManager;

	public class LoadResCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(LoadResCommand);
		[Inject]
		public var viewSignals:LoadViewSignals;
		[Inject]
		public var signals:LoadSignals;

		public function LoadResCommand()
		{
			super();
		}

		public override function execute():void
		{
			RslManager.init();
			AppUIMananger.show(AppUINames.MAIN_LOADER);
			loadUILib();
		}

		private function loadUILib():void
		{
			RslManager.add(ResPaths.getUIPath("Resource.swf"), {type: RslManager.TYPE_LIB});
			RslManager.add(ResPaths.getUIPath("Role.swf"), {type: RslManager.TYPE_LIB});
			RslManager.add(ResPaths.getUIPath("secondPWD.swf"), {type: RslManager.TYPE_LIB});
			RslManager.add(ResPaths.getUIPath("ui.swf"), {type: RslManager.TYPE_LIB});
			RslManager.add(ResPaths.getUIPath("Cursor.swf"), {type: RslManager.TYPE_LIB});
			RslManager.add(ResPaths.getUIPath("expression.swf"), {type: RslManager.TYPE_LIB});
			RslManager.add(ResPaths.getUIPath("HUD.swf"), {type: RslManager.TYPE_LIB});
			RslManager.add(ResPaths.getUIPath("battlehud.swf"), {type: RslManager.TYPE_LIB});
			var onComplete:Function = function(e:Event):void
			{
				//进度0.5
				Fun.stopMC(RslManager.getContent(ResPaths.getUIPath("Resource.swf")));
				Fun.stopMC(RslManager.getContent(ResPaths.getUIPath("Role.swf")));
				Fun.stopMC(RslManager.getContent(ResPaths.getUIPath("secondPWD.swf")));
				Fun.stopMC(RslManager.getContent(ResPaths.getUIPath("ui.swf")));
				Fun.stopMC(RslManager.getContent(ResPaths.getUIPath("Cursor.swf")));
				Fun.stopMC(RslManager.getContent(ResPaths.getUIPath("expression.swf")));
				Fun.stopMC(RslManager.getContent(ResPaths.getUIPath("HUD.swf")));
				Fun.stopMC(RslManager.getContent(ResPaths.getUIPath("battlehud.swf")));

				loadXMLConfig();
			};
			var onProgress:Function = function(e:BulkProgressEvent):void
			{
				viewSignals.loadProgress.dispatch(0.5 * e.ratioLoaded, e.ratioLoaded);
			};
			var onError:Function = function(e:Event):void
			{
				log.error("loadUILib() error: " + e.toString());
			};
			RslManager.start(onComplete, onProgress, onError);
		}

		private function loadXMLConfig():void
		{
			RslManager.add(ResPaths.getXMLListPath(CustomConfig.instance.locale));
			var onComplete:Function = function(e:Event):void
			{
				//进度0.6

				//解析xml加载列表
				var xml:XML = XML(RslManager.getContent(ResPaths.getXMLListPath(CustomConfig.instance.locale)));
				var list:Array = XMLAnalyser.getParseList(xml, XMLLoadInfo);
				loadXMLList(list);
			};
			var onProgress:Function = function(e:BulkProgressEvent):void
			{
				viewSignals.loadProgress.dispatch(0.5 + 0.1 * e.ratioLoaded, e.ratioLoaded);
			};
			var onError:Function = function(e:Event):void
			{
				log.error("loadXMLConfig() error");
			};
			RslManager.start(onComplete, onProgress, onError);
		}

		private function loadXMLList(list:Array):void
		{
			var onComplete:Function = function(e:Event):void
			{
				//进度1

				analysisXML();
			};
			var onProgress:Function = function(e:BulkProgressEvent):void
			{
				viewSignals.loadProgress.dispatch(0.6 + 0.4 * e.ratioLoaded, e.ratioLoaded);
			};
			var onError:Function = function(e:Event):void
			{
				log.error("loadXMLList() error");
			};
			list.forEach(function(item:XMLLoadInfo, index:int, arr:Array):void
			{
				RslManager.add(FilePathManager.getPath(item.file), {id: item.id, type: "binary"});
			});
			RslManager.start(onComplete, onProgress, onError, 3);
		}

		private function analysisXML():void
		{
//			_loader.clear();
//			var languageconfig:XML = XML(RslMananger.getContent("languageconfig"));
			//音效配置
			SoundManager.instrance.load(RslManager.getContent("soundconfig"));
			//语言配置文件
			 LanguageManager.load(RslManager.getContent("languageconfig"));
			//提示配置
		   	HintResManager.getInstance(HintConst.CONFIG_CLIENT).load(RslManager.getContent("hintconfigclient"));
			HintResManager.getInstance(HintConst.CONFIG_SERVER).load(RslManager.getContent("hintserverconfig"));
			HintResManager.getInstance(HintConst.CONFIG_SERVER_SCRIPT).load(RslManager.getContent("hintconfigscript"));
			//职业配置
			ProfessionManager.load(RslManager.getContent("professionconfig"));
			//
			MapResManager.initMapList(RslManager.getContent("maps2")); //地图配置
			MapResManager.initTransportList(RslManager.getContent("transports2")); //传送点列表
			MapResManager.initTransportTempl(RslManager.getContent("transporttemplate")); //传送点模板
			Animation.loadConfig(RslManager.getContent("animationconfig")); //动画配置
			NpcResManager.initNpcList(RslManager.getContent("npcs2")); //NpcRes配置
			NpcResManager.initNpcTempl(RslManager.getContent("npctemplate")); //NpcTempl配置
			MonsterResManager.initMonsterTeml(RslManager.getContent("monstertemplate"));
			//布局
			LayoutDesignManager.initXML(RslManager.getContent("layoutdesignfig"));
			//物品配置
			ItemTemplateManager.instance.loadItem(RslManager.getContent("itemconfig"));
			//物品效果
			ItemTemplateManager.instance.loadItemEffect(RslManager.getContent("itemeffectconfig"));
			//表情配置
			ChatSmileyConfigManager.load(RslManager.getContent("smileysfig"));
			//窗口皮肤配置
			WindowSkinMannager.instance.loadWindowSkinRes(RslManager.getContent("windowskin"));
			//技能配置
			SkillTemplateManager.instance.load(RslManager.getContent("skillconfig"));
			//魔法配置
			MagicTemplateMannage.instrance.load(RslManager.getContent("magicconfig"));
			//武将配置
			CardTemplateManager.loadTemplate(RslManager.getContent("cardTemplate"));
			CardTemplateManager.loadLevelTemplate(RslManager.getContent("cardLevelTemplate"));
			CardTemplateManager.loadStarLevelTemplate(RslManager.getContent("cardStarLevelTemplate"));
			//随机名字
			RandomNameManager.initRandomNameXML(RslManager.getContent("random_namefig"));
			signals.loadResComplete.dispatch();
		}
	}
}
