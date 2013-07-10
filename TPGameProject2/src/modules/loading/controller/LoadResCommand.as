package modules.loading.controller
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import common.CustomConfig;
	import common.RslMananger;
	import common.constants.ResPath;
	import common.res.map.MapResManager;
	import common.res.npc.NpcResManager;

	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import modules.loading.model.vo.XMLLoadInfo;
	import modules.loading.signals.LoadSignals;
	import modules.loading.signals.LoadViewSignals;

	import org.osflash.signals.Signal;

	import shell.AppUIMananger;
	import shell.AppUINames;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Command;
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
			AppUIMananger.show(AppUINames.MAIN_LOADER);

			loadUILib();
		}

		private function loadUILib():void
		{
//			RslMananger.add(ResPath.getUIPath("ui.swf"));
			RslMananger.add(ResPath.getUIPath("Resource.swf"));

			var onComplete:Function = function(e:Event):void
			{
				//进度0.5
//				Fun.stopMC(RslMananger.getContent(ResPath.getUIPath("ui.swf")));
				Fun.stopMC(RslMananger.getContent(ResPath.getUIPath("Resource.swf")));


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

			RslMananger.start(onComplete, onProgress, onError);
		}

		private function loadXMLConfig():void
		{
			RslMananger.add(ResPath.getXMLListPath(CustomConfig.locale));

			var onComplete:Function = function(e:Event):void
			{
				//进度0.6

				//解析xml加载列表
				var xml:XML = XML(RslMananger.getContent(ResPath.getXMLListPath(CustomConfig.locale)));
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

			RslMananger.start(onComplete, onProgress, onError);
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
				RslMananger.add(FilePathManager.getPath(item.file), {id: item.id, type: "binary"});
			});
			RslMananger.start(onComplete, onProgress, onError, 3);
		}

		private function analysisXML():void
		{
//			_loader.clear();
//			var languageconfig:XML = XML(RslMananger.getContent("languageconfig"));
			MapResManager.initMapList(RslMananger.getContent("maps2"));
			Animation.loadConfig(RslMananger.getContent("animationconfig"));
			NpcResManager.initNpcList(RslMananger.getContent("npcs2"));
			NpcResManager.initNpcTempl(RslMananger.getContent("npctemplate"));
			signals.loadResComplete.dispatch();
		}
	}
}
