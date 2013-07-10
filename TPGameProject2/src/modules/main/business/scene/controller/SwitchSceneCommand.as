package modules.main.business.scene.controller
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import common.GameInstance;
	import common.constants.ResPath;
	import common.res.map.MapResManager;
	import common.res.map.vo.MapRes;
	
	import modules.main.business.scene.constants.StatusType;
	import modules.main.business.scene.model.SceneModel;
	import modules.main.business.scene.signals.SceneLoadingUISignals;
	import modules.main.business.scene.signals.SceneSignals;
	
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.initializers.ScaleImageInit;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	import tempest.common.mvc.base.Command;
	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.avatar.AvatarPartType;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;
	
	import tpe.Input;

	public class SwitchSceneCommand extends Command
	{
		[Inject]
		public var loadingUISignals:SceneLoadingUISignals;

		[Inject]
		public var sceneSignals:SceneSignals;

		[Inject]
		public var model:SceneModel;

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
//			model.loadTransport(); //20
			model.loadNpc(); //308
//			model.loadMagicWard(); //10
//			model.loadEarthEffect(); //1
			//
			sceneSignals.switchSceneComplete.dispatch();
		}

		/**
		 * 初始化场景
		 */
		private function initScene():void
		{
			Input.enable();

			//初始化主角
			var hero:SceneCharacter = GameInstance.mainChar;
			hero.avatar.addAvatarPart(new AvatarPartData(AvatarPartType.CLOTH, ResPath.getCharacterPath(110011, StatusType.STAND)));
			hero.avatar.addAvatarPart(new AvatarPartData(AvatarPartType.WEAPON, ResPath.getWeaponPath(200011, StatusType.STAND)));
			hero.tile = new Point(40, 68);
			GameInstance.app.sceneContainer.addEventListener(Event.RESIZE, resizeScene);
			this.resizeScene(null);
		}
		
		private function weather(width:int, height:int):void
		{
			while(GameInstance.app.uiContainer.numChildren>0)
			{
				GameInstance.app.uiContainer.removeChildAt(0);
			}
	
			var emitter:Emitter2D = new Emitter2D();
			emitter.counter = new Steady( 50 );
			var imgClass:ImageClass = new ImageClass( RadialDot, [3] );
			emitter.addInitializer( imgClass );
			var zone:LineZone = new LineZone( new Point( -5, -5 ), new Point(width, -5 ) );
			var position:Position = new Position( zone );
			emitter.addInitializer( position );
			var zone2:PointZone = new PointZone( new Point( 0, 65 ) );
			var velocity:Velocity = new Velocity( zone2 );
			emitter.addInitializer( velocity );
			var scaleImage:ScaleImageInit = new ScaleImageInit( 0.75, 2 );
			emitter.addInitializer( scaleImage );
			
			var drift:RandomDrift = new RandomDrift( 15, 15 );
			emitter.addAction( drift );
			emitter.addAction(new Move());
			var dzone:RectangleZone = new RectangleZone( -10, -10, width, height);
			var deathZone:DeathZone = new DeathZone( dzone, true );
			emitter.addAction(deathZone);
			
			var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
			GameInstance.app.uiContainer.addChild( renderer );
			renderer.addEmitter( emitter );
			
			emitter.start();
			emitter.runAhead( 10 );
		}

		private function resizeScene(e:Event):void
		{
//			weather(Math.ceil(GameInstance.app.sceneContainer.width), Math.ceil(GameInstance.app.sceneContainer.height));
			GameInstance.scene.resize(Math.ceil(GameInstance.app.sceneContainer.width), Math.ceil(GameInstance.app.sceneContainer.height));
		}
	}
}
