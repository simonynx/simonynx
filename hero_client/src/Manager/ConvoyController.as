//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import OopsEngine.Scene.StrategyElement.Person.*;

    public class ConvoyController {

        private static const ConvoyQualityColor = [0, 14610175, 3446576, 26367, 9569000, 0xFF6600];
        public static const CONVOY_SPEED:int = 2;

        public static function removeConvoyCar(_arg1:GameElementAnimal):Boolean{
            if ((((_arg1.Role.Type == GameRole.TYPE_PLAYER)) || ((_arg1.Role.Type == GameRole.TYPE_OWNER)))){
                if (_arg1.Role.ConvoyCarAnimal){
                    _arg1.Role.ConvoyCarAnimal.Dispose();
                    _arg1.Role.ConvoyCarAnimal = null;
                    _arg1.SetMoveSpend(5);
                    if (_arg1.Role.UsingPetAnimal){
                        _arg1.Role.UsingPetAnimal.SetMoveSpend(5);
                    };
                };
            };
            return (true);
        }
        public static function addConvoyCar(_arg1:GameElementAnimal):GameElementConvoycar{
            removeConvoyCar(_arg1);
            var _local2:GameElementConvoycar = new GameElementConvoycar(GameCommonData.GameInstance);
            _local2.Role = new GameRole();
            _local2.Role.HP = 1;
            _local2.Role.Name = (_arg1.Role.Name + "的货物");
            _local2.Role.NameColor = ConvoyQualityColor[_arg1.Role.ConvoyFlag];
            _local2.Role.MonsterTypeID = 634;
            _local2.Role.CurrentPlayer = _local2;
            _local2.Role.Type = GameRole.TYPE_CONVOYCAR;
            GameCommonData.Scene.configObject(_local2);
            _local2.Role.TileX = (_arg1.Role.TileX + 1);
            _local2.Role.TileY = (_arg1.Role.TileY + 1);
            _local2.Role.MasterPlayer = (_arg1 as GameElementPlayer);
            _arg1.Role.ConvoyCarAnimal = _local2;
            GameCommonData.Scene.AddPlayer(_local2);
            _arg1.SetMoveSpend(CONVOY_SPEED);
            _local2.SetMoveSpend(CONVOY_SPEED);
            if (_arg1.Role.UsingPetAnimal){
                _arg1.Role.UsingPetAnimal.SetMoveSpend(CONVOY_SPEED);
            };
            return (_local2);
        }
        public static function setMoveSpeed(_arg1:GameElementAnimal):void{
            switch (_arg1.Role.Type){
                case GameRole.TYPE_PLAYER:
                case GameRole.TYPE_OWNER:
                    if ((((_arg1.Role.ConvoyFlag > 0)) && (_arg1.Role.ConvoyCarAnimal))){
                        _arg1.SetMoveSpend(CONVOY_SPEED);
                        _arg1.Role.ConvoyCarAnimal.SetMoveSpend(CONVOY_SPEED);
                        if (_arg1.Role.UsingPetAnimal){
                            _arg1.Role.UsingPetAnimal.SetMoveSpend(CONVOY_SPEED);
                        };
                    };
                    break;
                case GameRole.TYPE_PET:
                    if (((_arg1.Role.MasterPlayer) && ((_arg1.Role.MasterPlayer.Role.ConvoyFlag > 0)))){
                        _arg1.SetMoveSpend(CONVOY_SPEED);
                    };
                    break;
            };
        }

    }
}//package Manager 
