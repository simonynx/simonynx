package tempest.engine
{
	import flash.events.Event;

	/**
	 * 场景渲染器
	 * @author wushangkun
	 */
	public class SceneRender
	{
		private var _scene:TScene;
		private var _isRendering:Boolean=false;
		public static var nowTime:uint=new Date().getTime(); //getTimer();
		private var _lastTime:uint=0;

		public function SceneRender(scene:TScene)
		{
			_scene=scene;
		}

		/**
		 * 开始渲染
		 * @param refresh
		 */
		public function startRender(updateNow:Boolean=false):void
		{
			if (updateNow)
				this.render();
			if (!_isRendering)
			{
				_scene.container.addEventListener(Event.ENTER_FRAME, render);
				this._isRendering=true;
			}
		}

		/**
		 * 停止渲染
		 * @param refresh
		 */
		public function stopRender():void
		{
			if (_isRendering)
			{
				_lastTime=0;
				_scene.container.removeEventListener(Event.ENTER_FRAME, render);
				this._isRendering=false;
			}
		}

		/**
		 * 渲染
		 * @param e
		 */
		protected function render(e:Event=null):void
		{
			nowTime=new Date().getTime(); //getTimer();
			var diff:uint=0;
			if (_lastTime != 0)
			{
				diff=nowTime - _lastTime;
			}
			_lastTime=nowTime;
			var sc:SceneCharacter=null;
			var characters:Array=_scene.charList;
			for each (sc in characters)
			{
				//移动
				sc.runWalk();
					//阴影
			}
			this._scene.sceneCamera.run();
			this._scene.mapLayer.run(diff);
			this._scene.spaceLayer.run(diff);
			//角色渲染
		}
	}
}
