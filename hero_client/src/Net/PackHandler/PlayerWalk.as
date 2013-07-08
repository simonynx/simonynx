//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Net.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import OopsEngine.AI.PathFinder.*;
    import Render3D.*;
    import Vo.*;

    public class PlayerWalk extends GameAction {

        public static const TYPE_ENEMY:int = 1;
        public static const TYPE_PLAYER:int = 0;
        public static const MODE_RUN:int = 3;
        public static const MODE_MOVE:int = 2;
        public static const WALKMODE_RAND:int = 1;

        private static var instance:PlayerWalk;

        public function PlayerWalk(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():PlayerWalk{
            if (instance == null){
                instance = new (PlayerWalk)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            var _local2:WalkDataVo;
            var _local3:GameElementAnimal;
            var _local4:int;
            var _local5:int;
            var _local6:Point;
            var _local7:Point;
            var _local8:int = _arg1.readUnsignedInt();
            var _local9:int;
			trace("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
            while (_local9++ < _local8) {
                _local2 = new WalkDataVo();
                _local2.RoleID = _arg1.readUnsignedInt();
                _local2.UsPoxX = _arg1.readUnsignedShort();
                _local2.UsPoxY = _arg1.readUnsignedShort();
                _local2.UcMode = _arg1.readUnsignedByte();
				trace("@!@!@!@!@!@!@!@!@");
				trace("Walk ",_local2.RoleID,_local2.UsPoxX,_local2.UsPoxY,_local2.UcMode);
				
                if (((!((GameCommonData.NoMovePlayerId == 0))) && ((GameCommonData.NoMovePlayerId == _local2.RoleID)))){
                    GameCommonData.NoMovePlayerId = 0;
                    return;
                };
                if (((((!((GameCommonData.Scene == null))) && ((GameCommonData.Scene.IsSceneLoaded == true)))) && (!((GameCommonData.SameSecnePlayerList == null))))){
                    if (GameCommonData.SameSecnePlayerList[_local2.RoleID] == null){
                        return;
                    };
                    _local3 = GameCommonData.SameSecnePlayerList[_local2.RoleID];
                    if ((((_local3 == GameCommonData.TargetAnimal)) && (GameCommonData.IsFollow))){
                        _local5 = MapTileModel.Distance(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY, _local3.Role.TileX, _local3.Role.TileY);
                        if ((((_local5 > 1)) && ((_local5 < 7)))){
                            GameCommonData.Scene.MapPlayerTitleMove(new Point(_local3.Role.TileX, _local3.Role.TileY));
                        } else {
                            if (_local5 > 7){
                                GameCommonData.IsFollow = false;
                            };
                        };
                    };
                    _local4 = MapTileModel.Distance(_local2.UsPoxX, _local2.UsPoxY, _local3.Role.TileX, _local3.Role.TileY);
                    if (_local4 < 5){
                        if (((((!((_local3.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))) && (!((_local3.Role.ActionState == GameElementSkins.ACTION_DEAD))))) && (!((_local2.RoleID == GameCommonData.Player.Role.Id))))){
                            switch (_local2.UcMode){
                                case WALKMODE_RAND:
                                    _local3.SetMoveSpend(2);
                                    break;
                                case MODE_MOVE:
                                    _local3.SetMoveSpend(4);
                                    break;
                                case MODE_RUN:
                                    _local3.SetMoveSpend(8);
                                    break;
                            };
                            if (((_local3.Visible) || (Render3DManager.getInstance().m_isinited))){
                                if ((_local3 is GameElementPlayer)){
                                    if ((_local3 as GameElementPlayer).IsRushing != true){
                                        _local3.MoveTile(new Point(_local2.UsPoxX, _local2.UsPoxY));
                                        _local3.Role.TileX = _local2.UsPoxX;
                                        _local3.Role.TileY = _local2.UsPoxY;
                                    };
                                } else {
                                    _local3.MoveTile(new Point(_local2.UsPoxX, _local2.UsPoxY));
                                    _local3.Role.TileX = _local2.UsPoxX;
                                    _local3.Role.TileY = _local2.UsPoxY;
                                };
                            } else {
                                _local6 = MapTileModel.GetTilePointToStage(_local2.UsPoxX, _local2.UsPoxY);
                                _local3.Role.TileX = _local2.UsPoxX;
                                _local3.Role.TileY = _local2.UsPoxY;
                                _local3.X = _local6.x;
                                _local3.Y = _local6.y;
                            };
                        };
                    } else {
                        if (!(_local3 is GameElementPet)){
                            _local7 = MapTileModel.GetTilePointToStage(_local2.UsPoxX, _local2.UsPoxY);
                            _local3.Role.TileX = _local2.UsPoxX;
                            _local3.Role.TileY = _local2.UsPoxY;
                            _local3.X = _local7.x;
                            _local3.Y = _local7.y;
                        };
                    };
                };
            };
        }

    }
}//package Net.PackHandler 
