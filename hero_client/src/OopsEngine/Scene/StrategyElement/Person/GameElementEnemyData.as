//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsEngine.Scene.StrategyElement.*;

    public class GameElementEnemyData extends GameElementData {

        public function GameElementEnemyData(_arg1:int=0){
            if (_arg1 == 0){
                this.action[GameElementSkins.ACTION_STATIC] = ["26-29", "30-33", "34-37", "38-41", "42-45"];
                this.action[GameElementSkins.ACTION_NEAR_ATTACK] = ["1-5", "6-10", "11-15", "16-20", "21-25"];
                this.action[GameElementSkins.ACTION_DEAD] = ["76-76", "77-77", "77-77", "77-77", "78-78"];
                this.action[GameElementSkins.ACTION_RUN] = ["46-51", "52-57", "58-63", "64-69", "70-75"];
            } else {
                if (_arg1 == 1){
                    this.action[GameElementSkins.ACTION_STATIC] = ["36-40", "46-50", "51-55", "41-45", "56-60"];
                    this.action[GameElementSkins.ACTION_NEAR_ATTACK] = ["1-7", "8-14", "15-21", "22-28", "29-35"];
                    this.action[GameElementSkins.ACTION_DEAD] = ["96-99", "100-103", "100-103", "100-103", "104-107"];
                    this.action[GameElementSkins.ACTION_RUN] = ["61-67", "68-74", "75-81", "82-88", "89-95"];
                };
            };
        }
    }
}//package OopsEngine.Scene.StrategyElement.Person 
