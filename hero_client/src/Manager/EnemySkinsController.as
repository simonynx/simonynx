//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsEngine.Scene.StrategyElement.*;

    public class EnemySkinsController {

        public static function SetSkinPersonData(_arg1:int, _arg2:GameElementAnimal):void{
            GameCommonData.Scene.configObject(_arg2);
            _arg2.SetMoveSpend(5);
            _arg2.SetSkin(GameElementSkins.EQUIP_PERSON, "");
        }
        public static function SetSkin(_arg1:int, _arg2:int, _arg3:GameElementAnimal):void{
            _arg3.RemoveSkin(GameElementSkins.EQUIP_PERSON);
            if ((((_arg1 == 38)) && ((_arg2 == 40)))){
                SpeciallyEffectController.getInstance().EggBreak(_arg3);
            };
            SetSkinPersonData(_arg2, _arg3);
        }

    }
}//package Manager 
