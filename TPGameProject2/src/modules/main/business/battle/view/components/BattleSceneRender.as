package modules.main.business.battle.view.components
{
	import flash.events.Event;
	
	import modules.main.business.battle.view.components.element.BattleElement;
	
	public class BattleSceneRender
	{
		private var _scene:BattleScene;
		private var _isRendering:Boolean=false;
		public static var nowTime:uint=new Date().getTime(); //getTimer();
		private var _lastTime:uint=0;
		
		public function BattleSceneRender(scene:BattleScene)
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
				this.onRender();
			if (!_isRendering)
			{
				_scene.container.addEventListener(Event.ENTER_FRAME, onRender);
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
				_scene.container.removeEventListener(Event.ENTER_FRAME, onRender);
				this._isRendering=false;
			}
		}
		
		/**
		 * 渲染
		 * @param e
		 */
		protected function onRender(e:Event=null):void
		{
			nowTime=new Date().getTime(); //getTimer();
			var diff:uint=0;
			if (_lastTime != 0)
			{
				diff=nowTime - _lastTime;
			}
			_lastTime=nowTime;
			
			for each (var ele:BattleElement in _scene.elementLayer.elements)
			{
				ele.update(diff);
			}
		}
	}
}