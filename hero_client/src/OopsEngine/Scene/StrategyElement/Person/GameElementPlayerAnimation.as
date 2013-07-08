//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsEngine.Scene.StrategyElement.*;
    import OopsEngine.Graphics.Animation.*;

    public class GameElementPlayerAnimation extends AnimationPlayer {

        public function GameElementPlayerAnimation(_arg1:int=-1){
            super(_arg1);
        }
        override public function StartClip(_arg1:String, _arg2:int=0):void{
            if (_arg1.indexOf(GameElementSkins.ACTION_DEAD) > -1){
                this.playMaxCount = SINGLE;
            } else {
                this.playMaxCount = LOOP;
            };
            super.StartClip(_arg1, _arg2);
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
