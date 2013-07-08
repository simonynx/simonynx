//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsFramework.*;
    import OopsEngine.Scene.StrategyElement.*;

    public class GameElementNPC extends GameElementAnimal {

        public function GameElementNPC(_arg1:Game){
            super(_arg1, new GameElementNPCSkin(this));
        }
        override public function RemoveSkin(_arg1:String):void{
            this.skins.RemovePersonSkin(_arg1);
        }
        override public function SetSkin(_arg1:String, _arg2:String):void{
            switch (_arg1){
                case GameElementSkins.EQUIP_PERSON:
                    GameElementNPCSkin(this.skins).ChangePerson(true);
                    break;
            };
        }
        override public function Dispose():void{
            this.SetMissionPrompt(0);
            super.Dispose();
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
