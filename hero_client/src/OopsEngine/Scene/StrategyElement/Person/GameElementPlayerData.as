//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsEngine.Scene.StrategyElement.*;

    public class GameElementPlayerData extends GameElementData {

        public function GameElementPlayerData(){
            this.action[GameElementSkins.ACTION_STATIC] = ["51-55", "56-60", "61-65", "66-70", "71-75"];
            this.action[GameElementSkins.ACTION_NEAR_ATTACK] = ["1-10", "11-20", "21-30", "31-40", "41-50"];
            this.action[GameElementSkins.ACTION_DEAD] = ["116-119", "120-123", "124-127", "128-131", "132-135"];
            this.action[GameElementSkins.ACTION_RUN] = ["76-83", "84-91", "92-99", "100-107", "108-115"];
            this.action[GameElementSkins.ACTION_MEDITATION] = ["136-136", "137-137", "138-138", "139-139", "140-140"];
        }
    }
}//package OopsEngine.Scene.StrategyElement.Person 
