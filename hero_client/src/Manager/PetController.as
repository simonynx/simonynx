//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import OopsEngine.AI.PathFinder.*;

    public class PetController {

        public static var PetTimer:Number = 0;
        private static var _instance:PetController;

        public static function getInstance():PetController{
            if (!_instance){
                _instance = new (PetController)();
            };
            return (_instance);
        }
        public static function PetDistance():void{
            if (((((((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.HP > 0)))) && (!((GameCommonData.PetTargetAnimal == null))))) && ((GameCommonData.Player.Role.UsingPetAnimal.isWalk == false)))){
                if (!DistanceController.PetTargetDistance(9)){
                    GameCommonData.Player.Role.UsingPetAnimal.MoveSeek();
                };
            };
        }
        public static function SetPetSpeed(_arg1:GameElementAnimal, _arg2:int):void{
            if (_arg1.Role.UsingPetAnimal != null){
                _arg1.Role.UsingPetAnimal.SetMoveSpend(_arg2);
            };
        }

        public function ResetPetPos(_arg1:GameElementPet):void{
            var _local2:Point;
            _arg1.clearPath();
            if (_arg1.Role.MasterPlayer){
                _local2 = MapTileModel.GetTilePointToStage(_arg1.Role.MasterPlayer.Role.TileX, _arg1.Role.MasterPlayer.Role.TileY);
                _arg1.Role.TileX = (_arg1.Role.MasterPlayer.Role.TileX + 1);
                _arg1.Role.TileY = (_arg1.Role.MasterPlayer.Role.TileY + 1);
                _arg1.X = _local2.x;
                _arg1.Y = _local2.y;
                _arg1.Stop();
            };
        }
        public function ToMasterMove(_arg1:GameElementPet):void{
            var _local2:Point;
            var _local3:Array;
            var _local4:Array;
            var _local5:Point;
            var _local6:uint;
            var _local7:Number;
            var _local8:uint;
            var _local9:Number;
            var _local10:Point;
            if (_arg1.Role.MasterPlayer){
                _local2 = new Point(_arg1.Role.MasterPlayer.Role.TileX, _arg1.Role.MasterPlayer.Role.TileY);
                if (((((_arg1.PetMovePath) && (_arg1.Role.MasterPlayer.prepPoint))) && (!((((_arg1.Role.MasterPlayer.prepPoint.x == 0)) && ((_arg1.Role.MasterPlayer.prepPoint.y == 0))))))){
                    _local3 = _arg1.PetMovePath.concat();
                    _local4 = [];
                    _local6 = 0;
                    _local7 = Number.MAX_VALUE;
                    _local8 = 0;
                    while (_local6 < _local3.length) {
                        _local5 = _local3[(_local6 + 3)];
                        if (_local5 == null){
                            break;
                        };
                        _local9 = Math.pow((Math.sqrt((_local5.x - _local2.x)) + Math.sqrt((_local5.y - _local2.y))), 0.5);
                        if (_local9 < _local7){
                            _local7 = _local9;
                            _local8 = _local6;
                        };
                        _local6++;
                    };
                    _local3 = _local3.slice(_local8, (_local3.length - 1));
                    if (_local3.length > 0){
                        _arg1.Role.TileX = _local3[0].x;
                        _arg1.Role.TileY = _local3[0].y;
                        _local10 = MapTileModel.GetTilePointToStage(_local3[0].x, _local3[0].y);
                        _arg1.X = _local10.x;
                        _arg1.Y = _local10.y;
                        _arg1.Stop();
                        _arg1.MoveAStar(_local3);
                    };
                };
            };
        }
        public function MoveToMaster(_arg1:GameElementAnimal):void{
            if (((_arg1) && ((_arg1 is GameElementPet)))){
                (_arg1 as GameElementPet).MoveSeek();
            };
        }

    }
}//package Manager 
