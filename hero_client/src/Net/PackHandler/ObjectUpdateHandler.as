//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import OopsEngine.Utils.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.Modules.Task.Model.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import Render3D.*;
    import GameUI.Modules.Arena.Data.*;

    public class ObjectUpdateHandler extends GameAction {

        public static const UPDATETYPE_CREATE_YOURSELF:uint = 3;
        public static const UPDATETYPE_CREATE_OBJECT:uint = 2;
        public static const UPDATETYPE_OUT_OF_RANGE_OBJECTS:uint = 4;
        public static const UPDATETYPE_MOVEMENT:uint = 1;
        public static const UPDATETYPE_VALUES:uint = 0;

        private function MoveUpdateHandler(_arg1:NetPacket):void{
        }
        private function ReadParms(_arg1:Object, _arg2:int, _arg3:ByteArray):void{
            var _local6:Dictionary;
            var _local7:Dictionary;
            var _local4:uint = _arg3.readByte();
            var _local5:ByteArray = new ByteArray();
            _local5.endian = "littleEndian";
            _arg3.readBytes(_local5, 0, (_local4 * 4));
            if ((((((_arg2 == Protocol.TYPEID_CREATURE)) || ((_arg2 == Protocol.TYPEID_PLAYER)))) || (Protocol.TYPEID_PET))){
                _local6 = HOHOParms.GameRoleParms;
                _local7 = HOHOParms.GameRoleParmTypes;
            };
            var _local8:uint;
            while (_local8 < ((_local4 * 4) * 8)) {
                if ((_local5[(_local8 >> 3)] & (1 << (_local8 & 7))) != 0){
                    if (((!((_local6[_local8] == ""))) && (_arg1.hasOwnProperty(_local6[_local8])))){
                        switch (_local7[_local8]){
                            case "i":
                                _arg1[_local6[_local8]] = _arg3.readInt();
                                break;
                            case "u":
                                _arg1[_local6[_local8]] = _arg3.readUnsignedInt();
                                break;
                            case "f":
                                _arg1[_local6[_local8]] = _arg3.readFloat();
                                break;
                            default:
                                _arg3.readInt();
                        };
                    } else {
                        _arg3.readInt();
                    };
                };
                _local8++;
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            var _local4:uint;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint;
            while (_local3 < _local2) {
                _local4 = _arg1.readUnsignedByte();
                switch (_local4){
                    case UPDATETYPE_VALUES:
                        ValuesUpdateHandler(_arg1);
                        break;
                    case UPDATETYPE_MOVEMENT:
                        MoveUpdateHandler(_arg1);
                        break;
                    case UPDATETYPE_CREATE_OBJECT:
                        CreateUpdateHandler(_arg1);
                        break;
                    case UPDATETYPE_CREATE_YOURSELF:
                        CreateUpdateHandler(_arg1);
                        break;
                    case UPDATETYPE_OUT_OF_RANGE_OBJECTS:
                        RemoveUpdateHandler(_arg1);
                        break;
                };
                _local3++;
            };
        }
        private function CreateUpdateHandler(_arg1:NetPacket):void{
            var _local5:GameElementAnimal;
            var _local6:GameRole;
            var _local7:ModelOffset;
            var _local8:GameElementPlayer;
            var _local9:XML;
            var _local10:XML;
            var _local11:GameElementPet;
            var _local2:uint = _arg1.readByte();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            if (_local2 == Protocol.TYPEID_CREATURE){
                _local5 = null;
                _local6 = null;
                if (GameCommonData.SameSecnePlayerList[_local3]){
                    _local5 = GameCommonData.SameSecnePlayerList[_local3];
                    _local6 = _local5.Role;
                } else {
                    _local6 = new GameRole();
                    _local6.Id = _local3;
                    _local6.Type = GameRole.TYPE_ENEMY;
                };
                _local6.readNormalInfoPkg(_arg1);
                ReadParms(_local6, Protocol.TYPEID_CREATURE, _arg1);
                if ((((GameCommonData.ModuleCloseConfig[9] == 1)) && ((_local6.MonsterTypeID == 1180)))){
                    return;
                };
                if ((((GameCommonData.ModuleCloseConfig[8] == 1)) && ((_local6.MonsterTypeID == 1184)))){
                    return;
                };
                if (GameCommonData.ModuleCloseConfig[7] == 1){
                    _local7 = GameCommonData.ModelOffsetNpcEnemy[_local6.MonsterTypeID];
                    if (_local7 != null){
                        if (_local7.Title == LanguageMgr.GetTranslation("可抓捕")){
                            return;
                        };
                    };
                };
                if ((((GameCommonData.ModuleCloseConfig[2] == 1)) && ((_local6.MonsterTypeID == 1136)))){
                    return;
                };
                if (_local6.NpcFlags > 0){
                    if (_local6.NpcFlags == 4){
                        _local6.Type = GameRole.TYPE_COLLECT;
                        _local6.HP = _local6.MaxHp;
                    } else {
                        _local6.Type = GameRole.TYPE_NPC;
                    };
                    if (_local5 == null){
                        _local5 = new GameElementNPC(GameCommonData.GameInstance);
                    };
                    _local6.CurrentPlayer = _local5;
                    _local5.Role = _local6;
                } else {
                    if (_local5 == null){
                        _local5 = new GameElementEnemy(GameCommonData.GameInstance);
                    };
                    _local5.Role = _local6;
                    _local6.CurrentPlayer = _local5;
                };
                GameCommonData.Scene.configObject(_local5);
                if (((!((GameCommonData.Scene == null))) && ((GameCommonData.Scene.IsSceneLoaded == true)))){
                    GameCommonData.Scene.AddPlayer(_local5);
                    GameCommonData.SameSecnePlayerList[_local5.Role.Id] = _local5;
                    if (Render3DManager.getInstance().m_isinited){
                        _local5.visible = false;
                        Render3DManager.getInstance().AddAnimation(_local5.Role.Id, _local5);
                    };
                };
                UIFacade.GetInstance().upDateInfo(0, _local5.Role.Id);
                if (_local5.Role.idTeam == 0){
                    _local5.SetTeam(false);
                    _local5.SetTeamLeader(false);
                };
                if (_local5.Role.NpcFlags > 0){
                    TaskCommonData.setNpcState(_local5);
                };
            } else {
                if (_local2 == Protocol.TYPEID_PLAYER){
                    if (_local3 == GameCommonData.Player.Role.Id){
                        _local8 = GameCommonData.Player;
                        _local8.Role.clearAllParams();
                        _local8.Role.DynamicFlag = _local4;
                        _local8.Role.readNormalInfoPkg(_arg1);
                        ReadParms(_local8.Role, Protocol.TYPEID_PLAYER, _arg1);
                        GameCommonData.Scene.AddOwner();
                    } else {
                        if (GameCommonData.SameSecnePlayerList[_local3] != null){
                            _local8 = GameCommonData.SameSecnePlayerList[_local3];
                            _local8.Role.DynamicFlag = _local4;
                            _local8.Role.readNormalInfoPkg(_arg1);
                            ReadParms(_local8.Role, Protocol.TYPEID_PLAYER, _arg1);
                        } else {
                            _local8 = new GameElementPlayer(GameCommonData.GameInstance);
                            _local8.Role = new GameRole();
                            _local8.Role.CurrentPlayer = _local8;
                            _local8.Role.Id = _local3;
                            _local8.Role.Type = GameRole.TYPE_PLAYER;
                            _local8.Role.DynamicFlag = _local4;
                            _local8.Role.readNormalInfoPkg(_arg1);
                            ReadParms(_local8.Role, Protocol.TYPEID_PLAYER, _arg1);
                            GameCommonData.Scene.configObject(_local8);
                            if (((GameCommonData.Scene) && (GameCommonData.Scene.IsSceneLoaded))){
                                GameCommonData.Scene.AddPlayer(_local8);
                                GameCommonData.SameSecnePlayerList[_local8.Role.Id] = _local8;
                                if (_local8.Role.isStalling > 0){
                                    UIFacade.GetInstance().sendNotification(EventList.BEGINSTALL, _local8.Role.Id);
                                };
                            };
                            UIFacade.GetInstance().upDateInfo(0, _local8.Role.Id);
                            if (MapManager.IsInArena()){
                                if (ArenaInfo.KillOrBeKillList[_local3] == null){
                                    ArenaInfo.KillOrBeKillList[_local3] = new ArenaInfo();
                                };
                                ArenaInfo.KillOrBeKillList[_local3].name = _local8.Role.Name;
                                ArenaInfo.KillOrBeKillList[_local3].level = _local8.Role.Level;
                                ArenaInfo.KillOrBeKillList[_local3].jobName = _local8.Role.CurrentJobID;
                            };
                            (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy).setPlayerTeamIcon(_local8);
                        };
                    };
                } else {
                    if (_local2 == Protocol.TYPEID_PET){
                        if (GameCommonData.SameSecnePlayerList[_local3]){
                            _local11 = GameCommonData.SameSecnePlayerList[_local3];
                            _local6 = _local11.Role;
                        } else {
                            _local11 = new GameElementPet(GameCommonData.GameInstance);
                            _local6 = new GameRole();
                            _local6.Id = _local3;
                            _local6.Type = GameRole.TYPE_PET;
                        };
                        _local6.readNormalInfoPkg(_arg1);
                        ReadParms(_local6, Protocol.TYPEID_PET, _arg1);
                        _local11.Role = _local6;
                        _local11.Role.CurrentPlayer = _local11;
                        GameCommonData.Scene.configObject(_local11);
                        if (((GameCommonData.Scene) && (GameCommonData.Scene.IsSceneLoaded))){
                            GameCommonData.Scene.AddPlayer(_local11);
                            GameCommonData.SameSecnePlayerList[_local11.Role.Id] = _local11;
                        };
                    };
                };
            };
        }
        private function RemoveUpdateHandler(_arg1:NetPacket):void{
            var _local3:uint;
            var _local4:uint;
            var _local5:GameElementAnimal;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local6:uint;
            while (_local6 < _local2) {
                _local3 = _arg1.readByte();
                _local4 = _arg1.readUnsignedInt();
                if ((((((_local3 == Protocol.TYPEID_PLAYER)) || ((_local3 == Protocol.TYPEID_CREATURE)))) || ((_local3 == Protocol.TYPEID_PET)))){
                    if (GameCommonData.SameSecnePlayerList != null){
                        _local5 = GameCommonData.SameSecnePlayerList[_local4];
                        if (((_local5) && (_local5.handler))){
                            _local5.handler.Clear();
                        };
                        if (_local5){
                            if (_local5.Role.isStalling > 0){
                                _local5.Role.isStalling = 0;
                            };
                            GameCommonData.Scene.DeletePlayer(_local4);
                        };
                    };
                } else {
                    if (_local3 == Protocol.TYPEID_CONTAINER){
                        GameCommonData.Scene.DeletePackage(_local4);
                    };
                };
                _local6++;
            };
        }
        private function ValuesUpdateHandler(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readByte();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:Object = new Object();
            if (_local2 == Protocol.TYPEID_CREATURE){
                if (GameCommonData.SameSecnePlayerList[_local3] != null){
                    ReadParms(GameCommonData.SameSecnePlayerList[_local3].Role, Protocol.TYPEID_CREATURE, _arg1);
                } else {
                    ReadParms(_local4, Protocol.TYPEID_CREATURE, _arg1);
                    trace("确认原本的bug!请注意!");
                };
            } else {
                if (_local2 == Protocol.TYPEID_PLAYER){
                    if (_local3 == GameCommonData.Player.Role.Id){
                        ReadParms(GameCommonData.Player.Role, Protocol.TYPEID_PLAYER, _arg1);
                    } else {
                        if (GameCommonData.SameSecnePlayerList[_local3] != null){
                            ReadParms(GameCommonData.SameSecnePlayerList[_local3].Role, Protocol.TYPEID_PLAYER, _arg1);
                        } else {
                            ReadParms(_local4, Protocol.TYPEID_PLAYER, _arg1);
                            trace("确认原本的bug!请注意!");
                        };
                    };
                } else {
                    if (_local2 == Protocol.TYPEID_PET){
                        if (GameCommonData.SameSecnePlayerList[_local3] != null){
                            ReadParms(GameCommonData.SameSecnePlayerList[_local3].Role, Protocol.TYPEID_PET, _arg1);
                        } else {
                            ReadParms(_local4, Protocol.TYPEID_PET, _arg1);
                            trace("确认原本的bug!请注意!");
                        };
                    } else {
                        throw (new Error(("收到未知类型object的update：" + _local2.toString())));
                    };
                };
            };
            sendNotification(EventList.ALLROLEINFO_UPDATE, {
                id:_local3,
                type:1001
            });
        }

    }
}//package Net.PackHandler 
