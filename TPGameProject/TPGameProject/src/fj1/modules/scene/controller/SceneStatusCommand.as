package fj1.modules.scene.controller
{
	import assets.ResLib;
	import fj1.common.GameInstance;
	import tempest.common.mvc.base.Command;
	import tempest.engine.signals.SceneAction_Status;
	import tempest.engine.staticdata.Status;

	public class SceneStatusCommand extends Command
	{
		override public function getHandle():Function
		{
			return this.onSceneStatus;
		}

		private function onSceneStatus(action:String, status:int):void
		{
			switch (action)
			{
				case SceneAction_Status.CHANGE:
					if (status == Status.DEAD)
					{
						GameInstance.scene.hideMouseChar();
//						GameInstance.signal.mainChar.autoMoving.dispatch(false);
					}
//					if (status != Status.WALK && status != Status.INJURE)
//					{
//						GameInstance.signal.mainChar.autoMoving.dispatch(false);
//					}
					break;
			}
		}
	}
}
