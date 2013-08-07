package fj1.modules.scene.controller
{
	import br.com.stimuli.loading.BulkProgressEvent;
	import fj1.common.GameInstance;
	import fj1.common.res.ResPaths;
	import fj1.common.res.map.MapResManager;
	import fj1.common.res.map.vo.MapRes;
	import fj1.common.staticdata.StatusType;
	import fj1.modules.scene.model.SceneModel;
	import fj1.modules.scene.net.SceneService;
	import fj1.modules.scene.signals.SceneLoadingUISignals;
	import fj1.modules.scene.signals.SceneSignals;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import tempest.common.mvc.base.Command;
	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.avatar.AvatarPartType;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;
	import tempest.manager.KeyboardManager;
	import tpe.Input;

	public class SwitchSceneCommand extends Command
	{
		[Inject]
		public var loadingUISignals:SceneLoadingUISignals;
		[Inject]
		public var sceneSignals:SceneSignals;
		[Inject]
		public var model:SceneModel;
		[Inject]
		public var sceneService:SceneService;

		public function SwitchSceneCommand()
		{
			super();
		}

		override public function getHandle():Function
		{
			return changeScene;
		}

		private function changeScene(mapId:int):void
		{
			var mapRes:MapRes = MapResManager.getMapRes(mapId);
			if (!mapRes)
			{
				return;
			}
			loadingUISignals.show.dispatch(true); //显示加载界面
			GameInstance.scene.enterScene(mapRes.name, mapId, mapRes.resId, onCompleteHandler, onProgress);
		}

		private function onProgress(e:ProgressEvent):void
		{
			loadingUISignals.loadProgress.dispatch(100 * e.bytesLoaded / e.bytesTotal);
		}

		/**
		 * 加载完成处理
		 *
		 */
		private function onCompleteHandler():void
		{
			loadingUISignals.show.dispatch(false); //隐藏加载界面
			initScene(); //初始化场景
			//添加场景对象
			model.loadTransport();
			model.loadNpc();
//			model.loadMagicWard(); //10
//			model.loadEarthEffect(); //1
			//
			sceneService.sendEnterWorldRequest();
			sceneSignals.switchSceneComplete.dispatch();
		}

		/**
		 * 初始化场景
		 */
		private function initScene():void
		{
			Input.enable();
			KeyboardManager.enable();
			//初始化主角
			var hero:SceneCharacter = GameInstance.mainChar;
			hero.avatar.addAvatarPart(new AvatarPartData(AvatarPartType.CLOTH, ResPaths.getCharacterPath(110011, StatusType.STAND)));
			hero.avatar.addAvatarPart(new AvatarPartData(AvatarPartType.WEAPON, ResPaths.getWeaponPath(200011, StatusType.STAND)));
//			hero.tile = new Point(40, 68);
			GameInstance.app.sceneContainer.addEventListener(Event.RESIZE, resizeScene);
			this.resizeScene(null);
		}

		private function resizeScene(e:Event):void
		{
			GameInstance.scene.resize(Math.ceil(GameInstance.app.sceneContainer.width), Math.ceil(GameInstance.app.sceneContainer.height));
		}
	}
}
