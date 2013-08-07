package fj1.modules.login.controller
{
	import fj1.common.GameConfig;
	import fj1.common.GameInstance;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.AnimationConst;
	import fj1.modules.login.model.vo.RoleInfo;
	import fj1.modules.main.MainFacade;
	import fj1.modules.scene.signals.SceneSignals;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import tempest.common.logging.*;
	import tempest.common.mvc.TFacade;
	import tempest.common.mvc.base.Command;
	import tempest.manager.AudioManager;
	import tempest.ui.PopupManager;
	import tempest.ui.components.TAlert;

	public class SelectRole_SuccessCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(SelectRole_SuccessCommand);

		override public function execute():void
		{
			this.facade.showdown();
			MainFacade.instance.startup();
			//UI初始化
//			GameInstance.ui.init(); //54mb
			/////////////////////////////////////////////////////////////////////////////////////////////////////
//			PopupManager.instance.register(GameInstance.scene.container, GameInstance.ui.mainUI.panelContainer); //变更弹窗层
			GameInstance.app.sceneContainer.addChild(GameInstance.scene.container); //添加场景层
//			GameInstance.app.sceneContainer.addEventListener(Event.RESIZE, resizeScene);
//			this.resizeScene(null);
			GameInstance.app.uiContainer.addChild(GameInstance.app.mainUI);
//			GameInstance.app.uiContainer.addChild(GameInstance.ui.movieUI);
//			GameInstance.ui.movieUI.hide();
			//
			GameInstance.scene.mouseCharId = AnimationConst.Ani_MouseClick;
			var entity:RoleInfo = GameConfig.selectRole;
			GameInstance.mainCharData.name = entity.name;
			GameInstance.mainCharData.level = entity.level;
//			GameInstance.mainCharData.professions = entity.profession;
			GameInstance.mainChar.tile_x = entity.posX;
			GameInstance.mainChar.tile_y = entity.posY;
			log.info("初始坐标 x:{0}, y{1}", entity.posX, entity.posY);
			GameInstance.mainCharData.bodyModelId = entity.equip;
//			SkillDataManager.instance.init(); //为英雄从技能模板中选取自己职业的技能
//			SceneModel.tips = LanguageManager.translate(100138).split(",");
			//////////////////////////////////////////////////////////////////
			AudioManager.removeAllSounds();
			GameInstance.signal.sceneSignals.switchScene.dispatch(entity.mapId); //进入场景
			//////////////////////////////////////////////////////////////////////////////
		}

		private function starupFacade(facade:TFacade):void
		{
//			try
//			{
			var t0:int;
			var t1:int;
			t0 = getTimer();
			facade.startup();
			t1 = getTimer() - t0;
			if (t1 > 10)
			{
				log.warn("[{0}] startup cost:{1}ms", getQualifiedClassName(facade), t1);
			}
//			}
//			catch (e:Error)
//			{
//				TAlert.Show(e.message, "Facade failed to start!");
//			}
		}

//		private function resizeScene(e:Event):void
//		{
//			GameInstance.scene.resize(Math.ceil(GameInstance.app.sceneContainer.width), Math.ceil(GameInstance.app.sceneContainer.height));
//		}
	}
}
