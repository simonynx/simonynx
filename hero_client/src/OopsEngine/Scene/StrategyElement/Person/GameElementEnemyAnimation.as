//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsEngine.Scene.StrategyElement.*;
    import OopsEngine.Graphics.Animation.*;
    import OopsEngine.Pool.*;

    public class GameElementEnemyAnimation extends AnimationPlayer implements IPoolClass {

        public function GameElementEnemyAnimation(_arg1:int=-1){
            super(_arg1);
        }
        public static function recycleGameElementEnemy(_arg1:GameElementEnemyAnimation):void{
            ScenePool.gameElementEnemyAnimationPool.disposeObj(_arg1);
        }
        public static function createGameElementEnemy():GameElementEnemyAnimation{
            return ((ScenePool.gameElementEnemyAnimationPool.createObj(GameElementEnemyAnimation) as GameElementEnemyAnimation));
        }

        public function reSet(_arg1:Array):void{
            isPlaying = false;
            playCount = 0;
            this.x = 0;
            this.y = 0;
            playMaxCount = -1;
            clipName = "";
        }
        override public function StartClip(_arg1:String, _arg2:int=0):void{
            if (_arg1.indexOf(GameElementSkins.ACTION_DEAD) > -1){
                this.playMaxCount = SINGLE;
            } else {
                this.playMaxCount = LOOP;
            };
            super.StartClip(_arg1, _arg2);
        }
        override public function dispose():void{
            Clips = null;
            Frames = null;
            bitmapData = null;
            PlayComplete = null;
            PlayFrame = null;
            playAnimationClip = null;
            playCount = 0;
            MaxHeight = 0;
            MaxWidth = 0;
            offsetX = 370;
            offsetY = 200;
            clipName = "";
            this.x = 0;
            this.y = 0;
            this.scaleX = (scaleY = 1);
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
