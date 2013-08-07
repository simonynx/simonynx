package fj1.modules.battle.command
{
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import fj1.common.GameInstance;
	import fj1.modules.battle.constants.BattleCamp;
	import fj1.modules.battle.model.BattleModel;
	import fj1.modules.battle.model.vo.BattleInfo;
	import fj1.modules.battle.model.vo.BattlePlayerInfo;
	import fj1.modules.battle.model.vo.RoundInfo;
	
	import tempest.common.mvc.base.Command;

	public class BattleStartCommand extends Command
	{
		[Inject]
		public var battleModel:BattleModel;

		public function BattleStartCommand()
		{
			super();
		}

		override public function execute():void
		{
			if (GameInstance.battleScene.container.parent)
			{
				return;
			}

			GameInstance.scene.sceneRender.stopRender();
			GameInstance.scene.enabled = false;
			GameInstance.app.mainUI.visible = false;
			GameInstance.scene.container.visible = false;
			GameInstance.app.sceneContainer.addChild(GameInstance.battleScene.container);
			GameInstance.app.sceneContainer.addChild(GameInstance.battleScene.battleUI);

			var battleInfo:BattleInfo = getTestInfo(); //DEBUG 战斗测试数据
			GameInstance.battleScene.enterScene(battleInfo); //进入场景
			var snapShot:Bitmap =  getSnapshot(GameInstance.scene.container).bitmap;
			GameInstance.app.sceneContainer.addChild(snapShot);
			var centerX:Number = GameInstance.app.sceneContainer.width/2;
			var centerY:Number = GameInstance.app.sceneContainer.height /2;
			GTweener.to( snapShot, 0.5, {x:centerX, y:centerY, rotationX:0, rotationY:0, rotation:360, scaleX: 0, scaleY:0/*, alpha:0*/}, {ease:Sine.easeInOut, onComplete: function():void
			{
				if(snapShot.parent)
				{
					snapShot.parent.removeChild(snapShot);
				}
				battleModel.startQueue(battleInfo.roundInfoArr);
				GTweener.removeTweens(snapShot);
			}});
		}
		
		private function getSnapshot(target:DisplayObject):Object
		{
			var bounds:Rectangle = target.getBounds(target);
			var width:int = Math.ceil(bounds.width);
			var height:int = Math.ceil(bounds.height);
			return {width: width, height: height, x: target.x + bounds.x, y: target.y + bounds.y, bitmap: catchBitmap(target, bounds)};
		}
		
		private function catchBitmap(target:DisplayObject, bounds:Rectangle):Bitmap
		{
			var matrix:Matrix = new Matrix();
			matrix.tx -= bounds.x;
			matrix.ty -= bounds.y;
			var width:int = Math.ceil(bounds.width);
			var height:int = Math.ceil(bounds.height);
			var bitmap:Bitmap = new Bitmap(new BitmapData(width, height, true, 0x00FFFFFF));
			bitmap.bitmapData.draw(target, matrix);
			bitmap.x = target.x + bounds.x;
			bitmap.y = target.y + bounds.y;
			return bitmap;
		}

		private function getTestInfo():BattleInfo
		{
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//debug
			var battleInfo:BattleInfo = new BattleInfo();
			battleInfo.id = 1;
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(1, BattleCamp.LEFT, 0, 0, "player1", 140061));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(2, BattleCamp.LEFT, 1, 0, "player2", 140062));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(3, BattleCamp.LEFT, 0, 1, "player3", 120084));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(4, BattleCamp.LEFT, 1, 1, "player4", 140063));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(5, BattleCamp.LEFT, 0, 2, "player5", 140071));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(6, BattleCamp.LEFT, 1, 2, "player6", 140072));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(7, BattleCamp.RIGHT, 0, 0, "player7", 120086));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(8, BattleCamp.RIGHT, 1, 0, "player8", 140073));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(9, BattleCamp.RIGHT, 0, 1, "player9", 110011));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(10, BattleCamp.RIGHT, 1, 1, "player10", 110011));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(11, BattleCamp.RIGHT, 0, 2, "player11", 110011));
			battleInfo.playerInfoArr.push(new BattlePlayerInfo(12, BattleCamp.RIGHT, 1, 2, "player12", 110011));
			var roundInfo:RoundInfo = new RoundInfo();
			roundInfo.id = 1;
			roundInfo.actionType = 1;
			roundInfo.castId = 1;
			roundInfo.skillId = 102201;
			roundInfo.targetArr = [11, 12];
			roundInfo.damageArr = [11, 12];
			roundInfo.hurtFlagArr = [12, 8];
			battleInfo.roundInfoArr.push(roundInfo);
			var roundInfo2:RoundInfo = new RoundInfo();
			roundInfo2.id = 2;
			roundInfo2.actionType = 1;
			roundInfo2.castId = 7;
			roundInfo2.skillId = 101303;
			roundInfo2.targetArr = [1, 2, 3, 4, 5, 6];
			roundInfo2.damageArr = [1, 2];
			roundInfo2.hurtFlagArr = [5, 6];
			battleInfo.roundInfoArr.push(roundInfo2);
			var roundInfo3:RoundInfo = new RoundInfo();
			roundInfo3.id = 3;
			roundInfo3.actionType = 2;
			roundInfo3.castId = 3;
			roundInfo3.skillId = 103201;
			roundInfo3.targetArr = [9, 10];
			roundInfo3.damageArr = [10, 11];
			roundInfo3.hurtFlagArr = [12, 8];
			battleInfo.roundInfoArr.push(roundInfo3);

			return battleInfo;
		}

	}
}
