//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsEngine.Scene.StrategyElement.*;

    public class GameElementPlayerMountData extends GameElementData {

        public function GameElementPlayerMountData(){
            this.action[GameElementSkins.ACTION_MOUNT_STATIC] = ["1-5", "6-10", "11-15", "16-20", "21-25"];
            this.action[GameElementSkins.ACTION_MOUNT_RUN] = ["26-33", "34-41", "42-49", "50-57", "58-65"];
        }
    }
}//package OopsEngine.Scene.StrategyElement.Person 
