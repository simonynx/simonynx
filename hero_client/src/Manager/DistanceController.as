//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import OopsEngine.AI.PathFinder.*;

    public class DistanceController {

        public static function PlayerTarAnimalRealyDistance(_arg1:GameElementAnimal, _arg2:int):Boolean{
            var _local3:Point = MapTileModel.GetTileStageToPoint(GameCommonData.Player.GameX, GameCommonData.Player.GameY);
            var _local4:Point = new Point(_arg1.Role.TileX, _arg1.Role.TileY);
            return (Distance(_local3, _local4, _arg2));
        }
        public static function AnimalTargetDistance(_arg1:GameElementAnimal, _arg2:Point, _arg3:int):Boolean{
            var _local4:Point = new Point(_arg1.Role.TileX, _arg1.Role.TileY);
            return (Distance(_local4, _arg2, _arg3));
        }
        public static function PlayerTargetAnimalDistance(_arg1:GameElementAnimal, _arg2:int):Boolean{
            var _local3:Point = new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
            var _local4:Point = new Point(_arg1.Role.TileX, _arg1.Role.TileY);
            return (Distance(_local3, _local4, _arg2));
        }
        public static function PetChangeTargetDistance(_arg1:int):Boolean{
            var _local2:Point;
            var _local3:Point;
            if (((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && (!((GameCommonData.TargetAnimal == null))))){
                _local2 = new Point(GameCommonData.Player.Role.UsingPetAnimal.Role.TileX, GameCommonData.Player.Role.UsingPetAnimal.Role.TileY);
                _local3 = new Point(GameCommonData.TargetAnimal.Role.TileX, GameCommonData.TargetAnimal.Role.TileY);
                return (Distance(_local2, _local3, _arg1));
            };
            return (false);
        }
        public static function PetTargetDistance(_arg1:int):Boolean{
            var _local2:Point = new Point(GameCommonData.Player.Role.UsingPetAnimal.Role.TileX, GameCommonData.Player.Role.UsingPetAnimal.Role.TileY);
            var _local3:Point = new Point(GameCommonData.PetTargetAnimal.Role.TileX, GameCommonData.PetTargetAnimal.Role.TileY);
            return (Distance(_local2, _local3, _arg1));
        }
        public static function PlayerAutomatism(_arg1:int, _arg2:Point):Boolean{
            return (Distance(GameCommonData.AutomatismPoint, _arg2, _arg1));
        }
        public static function PlayerPetDistance(_arg1:int):Boolean{
            var _local2:Point = new Point(GameCommonData.Player.Role.UsingPetAnimal.Role.TileX, GameCommonData.Player.Role.UsingPetAnimal.Role.TileY);
            var _local3:Point = new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
            return (Distance(_local2, _local3, _arg1));
        }
        public static function PixelDistance(_arg1:GameElementAnimal, _arg2:int, _arg3:int):Boolean{
            var _local4:Point = new Point(GameCommonData.Player.GameX, GameCommonData.Player.GameY);
            var _local5:Point = MapTileModel.GetTilePointToStage(_arg1.Role.TileX, _arg1.Role.TileY);
            if (Math.abs((_local4.x - _local5.x)) < _arg2){
                if (Math.abs((_local4.y - _local5.y)) < _arg3){
                    return (true);
                };
            };
            return (false);
        }
        public static function Distance(_arg1:Point, _arg2:Point, _arg3:int):Boolean{
            var _local4:int = MapTileModel.Distance(_arg1.x, _arg1.y, _arg2.x, _arg2.y);
            if (_local4 <= _arg3){
                return (true);
            };
            return (false);
        }
        public static function TwoAnimalDistance(_arg1:GameElementAnimal, _arg2:GameElementAnimal, _arg3:int):Boolean{
            var _local4:Point = new Point(_arg1.Role.TileX, _arg1.Role.TileY);
            var _local5:Point = new Point(_arg2.Role.TileX, _arg2.Role.TileY);
            return (Distance(_local4, _local5, _arg3));
        }

    }
}//package Manager 
