//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Unity.Data.*;
    import OopsEngine.AI.PathFinder.*;
    import Utils.*;
    import GameUI.Modules.Pk.Data.*;
    import GameUI.Modules.AutoPlay.Data.*;

    public class TargetController {

        public static const TargetExtent:int = 10;

        public static var SelectedPlayerList:Dictionary = new Dictionary();
        public static var IsTargetEnemy:Boolean = false;
        private static var autoTime:int;
        public static var TaskMonsterIdList:Dictionary = new Dictionary();
        public static var TargetAutomatismID:int = 0;

        private static function isNotInFB():Boolean{
            if (AutoFbManager.instance().isOpen){
                return (false);
            };
            return (true);
        }
        public static function CompareEnemyDis(_arg1:GameElementAnimal, _arg2:GameElementAnimal):int{
            return (((_arg1.PlayerGap > _arg2.PlayerGap)) ? 1 : -1);
        }
        public static function ConfirmTarget(_arg1:GameElementAnimal, _arg2:int, _arg3:Point=null, _arg4:Boolean=true):void{
            var _local5:SkillInfo;
            if (_arg3 == null){
                _arg3 = new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
            };
            if (((IsEnemy(_arg1)) && ((_arg1.Role.HP > 0)))){
                if ((MapTileModel.Distance(_arg3.x, _arg3.y, _arg1.Role.TileX, _arg1.Role.TileY) <= _arg2)){
                    if (((GameCommonData.Player.IsAutomatism) && (_arg4))){
                        if (((!((GameCommonData.AutomatismPoint == null))) && (!(DistanceController.PlayerAutomatism(11, new Point(_arg1.Role.TileX, _arg1.Role.TileY)))))){
                            return;
                        };
                        if (!GameCommonData.Scene.gameScenePlay.Map.IsPass(_arg1.Role.TileX, _arg1.Role.TileY)){
                            _local5 = SkillManager.GetDefaultSkill(GameCommonData.Player);
                            if (!DistanceController.PlayerTargetAnimalDistance(_arg1, (_local5.Distance - 1))){
                                return;
                            };
                        };
                    };
                    if (GameCommonData.TargetAnimal != null){
                        GameCommonData.TargetAnimal.IsSelect(false);
                        GameCommonData.TargetAnimal = null;
                    };
                    GameCommonData.TargetAnimal = _arg1;
                    trace("选择好了怪物");
                    autoTime = getTimer();
                    if (AutoFbManager.IsAutoFbing){
                        IsTargetEnemy = true;
                        GameCommonData.Scene.PlayerStop();
                        PlayerController.BeginAutomatism();
                        return;
                    };
                    GameCommonData.TargetAnimal.IsSelect(true);
                    UIFacade.UIFacadeInstance.selectPlayer();
                    if (GameCommonData.Player.IsAutomatism){
                        TargetAutomatismID = _arg1.Role.Id;
                        trace("进入攻击");
                        GameCommonData.Scene.Attack(GameCommonData.TargetAnimal);
                    };
                    IsTargetEnemy = true;
                };
            };
        }
        public static function getTaskMonsterList():void{
            var _local1:TaskInfoStruct;
            var _local2:QuestCondition;
            var _local3:GameElementAnimal;
            var _local4:Array;
            TaskMonsterIdList = null;
            TaskMonsterIdList = new Dictionary();
            for each (_local1 in GameCommonData.CurrentTaskList) {
                for each (_local2 in _local1.Conditions) {
                    if (_local2.description != ""){
                        _local4 = TaskCommonData.getQuestEventData(_local2.description);
                        if (((_local4) && (_local4[4]))){
                            TaskMonsterIdList[_local4[4]] = true;
                        };
                    };
                };
            };
        }
        public static function IsEnemy(_arg1:GameElementAnimal):Boolean{
            var _local2:int;
            var _local3:int;
            if (_arg1.Role.Type == GameRole.TYPE_ENEMY){
                if (_arg1.Role.Title == LanguageMgr.GetTranslation("可抓捕")){
                    return (false);
                };
                if (_arg1.Role.ArenaTeamId == -1){
                    return (false);
                };
                if (_arg1.Role.ArenaTeamId == 0){
                    return (true);
                };
                if (_arg1.Role.ArenaTeamId != GameCommonData.Player.Role.ArenaTeamId){
                    return (true);
                };
            } else {
                if (_arg1.Role.Type == GameRole.TYPE_PLAYER){
                    _local2 = GameCommonData.Player.Role.ArenaTeamId;
                    _local3 = _arg1.Role.ArenaTeamId;
                    if (((((!((_local2 == _local3))) && (!((_local2 == 0))))) && (!((_local3 == 0))))){
                        return (true);
                    };
                };
            };
            return (false);
        }
        public static function IsSafeArea():Boolean{
            if (GameCommonData.GameInstance.GameScene.GetGameScene.MapId == "****"){
                return (true);
            };
            return (false);
        }
        public static function GetTarget(_arg1:Boolean=true):void{
            var _local2:*;
            var _local3:GameElementAnimal;
            IsTargetEnemy = false;
            var _local4:Date = new Date();
            if (!IsTargetEnemy){
                GetTargetDistance(2);
            };
            if (!IsTargetEnemy){
                if (_arg1){
                    trace("寻找不到");
                    if (((GameCommonData.Player.IsAutomatism) || (AutoFbManager.IsAutoFbing))){
                        PlayerController.ClearAutomatism();
                        trace("清除挂机");
                    };
                };
            };
        }
        public static function IsTaskMonster(_arg1:int):Boolean{
            if (TaskMonsterIdList[_arg1] == true){
                return (true);
            };
            return (false);
        }
        public static function IsAttack(_arg1:GameElementAnimal):Boolean{
            var _local2:Boolean;
            if (GameCommonData.DuelAnimal == _arg1){
                return (true);
            };
            if (_arg1.Role.ArenaTeamId == -1){
                return (false);
            };
            if (((!((GameCommonData.Player.Role.ArenaTeamId == 0))) && (!((_arg1.Role.ArenaTeamId == 0))))){
                if (GameCommonData.Player.Role.ArenaTeamId != _arg1.Role.ArenaTeamId){
                    return (true);
                };
            } else {
                if (_arg1.Role.Title == "可抓捕"){
                    return (false);
                };
            };
            if (!IsSafeArea()){
                switch (_arg1.Role.Type){
                    case GameRole.TYPE_ENEMY:
                        _local2 = true;
                        break;
                    case GameRole.TYPE_PLAYER:
                        if (_arg1.Role.Level < 30){
                            return (false);
                        };
                        if ((((GameCommonData.Player.Role.idTeam == _arg1.Role.idTeam)) && (!((GameCommonData.Player.Role.idTeam == 0))))){
                            return (false);
                        };
                        if (GameCommonData.GuildBattle_IsStarting){
                            if (_arg1.Role.unityId == GameCommonData.Player.Role.unityId){
                                return (false);
                            };
                            if (_arg1.Role.unityId == UnityConstData.GuildBattle_TargetGuildID){
                                if (GameCommonData.Player.Role.Level < 30){
                                    return (false);
                                };
                                return (true);
                            };
                        };
                        if (PkData.PkStateList[0] == true){
                            if ((((_arg1.Role.unityId == GameCommonData.Player.Role.unityId)) && (!((GameCommonData.Player.Role.unityId == 0))))){
                                return (false);
                            };
                        };
                        if (PkData.PkStateList[1] == true){
                            if (_arg1.Role.PkTime == 0){
                                return (false);
                            };
                        };
                        if (PkData.PkStateList[2] == true){
                            if (_arg1.Role.PkTime > 0){
                                return (false);
                            };
                        };
                        _local2 = true;
                        break;
                    case GameRole.TYPE_PET:
                        if (((!((GameCommonData.Player.Role.UsingPetAnimal == _arg1))) && (_arg1.Role.MasterPlayer))){
                            if (_arg1.Role.MasterPlayer.Role.Level < 30){
                                return (false);
                            };
                            _local2 = true;
                            if ((((_arg1.Role.MasterPlayer.Role.idTeam == GameCommonData.Player.Role.idTeam)) && (!((GameCommonData.Player.Role.idTeam == 0))))){
                                return (false);
                            };
                            if (PkData.PkStateList[0] == true){
                                if ((((_arg1.Role.MasterPlayer.Role.unityId == GameCommonData.Player.Role.unityId)) && (!((GameCommonData.Player.Role.unityId == 0))))){
                                    return (false);
                                };
                            };
                            if (PkData.PkStateList[1] == true){
                                if (_arg1.Role.MasterPlayer.Role.PkTime == 0){
                                    return (false);
                                };
                            };
                            if (PkData.PkStateList[2] == true){
                                if (_arg1.Role.MasterPlayer.Role.PkTime > 0){
                                    return (false);
                                };
                            };
                            if (GameCommonData.GuildBattle_IsStarting){
                                if (_arg1.Role.MasterPlayer.Role.unityId == GameCommonData.Player.Role.unityId){
                                    return (false);
                                };
                                if (_arg1.Role.MasterPlayer.Role.unityId == UnityConstData.GuildBattle_TargetGuildID){
                                    if (GameCommonData.Player.Role.Level < 30){
                                        return (false);
                                    };
                                    return (true);
                                };
                            };
                        };
                        break;
                };
            };
            return (_local2);
        }
        public static function SetTarget(_arg1:GameElementAnimal):void{
            if (GameCommonData.TargetAnimal != _arg1){
                if (_arg1 == null){
                    GameCommonData.TargetAnimal = _arg1;
                    return;
                };
                if (GameCommonData.TargetAnimal != null){
                    GameCommonData.TargetAnimal.IsSelect(false);
                };
                GameCommonData.TargetAnimal = _arg1;
                GameCommonData.TargetAnimal.IsSelect(true);
            };
        }
        public static function IsUseSkill(_arg1:GameElementAnimal, _arg2:GameElementAnimal):Boolean{
            var _local3:Boolean;
            var _local4:Boolean;
            if (((!((_arg1.Role.UsingPetAnimal == null))) && ((_arg1.Role.UsingPetAnimal.Role.Id == _arg2.Role.Id)))){
                _local4 = true;
            };
            if (!_local4){
                if (((!((_arg1.Role.idTeam == _arg2.Role.idTeam))) || ((_arg1.Role.idTeam == 0)))){
                    if (_arg2.Role.ActionState != GameElementSkins.ACTION_DEAD){
                        if ((((_arg2.Role.Type == GameRole.TYPE_PLAYER)) || ((_arg2.Role.Type == GameRole.TYPE_ENEMY)))){
                            _local3 = true;
                        };
                    };
                };
            };
            return (_local3);
        }
        public static function GetPetTarget():GameElementAnimal{
            var _local1:GameElementAnimal;
            if (GameCommonData.PetTargetAnimal != null){
                if (PlayerController.IsUseSkill(GameCommonData.Player, GameCommonData.PetTargetAnimal)){
                    _local1 = GameCommonData.PetTargetAnimal;
                };
            };
            if (GameCommonData.AttackAnimal != null){
                if (IsUseSkill(GameCommonData.Player, GameCommonData.AttackAnimal)){
                    _local1 = GameCommonData.AttackAnimal;
                };
            };
            return (_local1);
        }
        public static function GetTargetDistance(_arg1:int=10):Boolean{
            var i:* = 0;
            var len:* = 0;
            var enemy:* = null;
            var enemyList:* = null;
            var str:* = undefined;
            var extent:int = _arg1;
            IsTargetEnemy = false;
            enemyList = [];
            for (str in GameCommonData.SameSecnePlayerList) {
                enemy = GameCommonData.SameSecnePlayerList[str];
                enemy.PlayerGap = MapTileModel.Distance(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY, enemy.Role.TileX, enemy.Role.TileY);
                if (((IsEnemy(enemy)) && ((enemy.Role.HP > 0)))){
                    enemyList[enemyList.length] = enemy;
                };
            };
            enemyList.sort(CompareEnemyDis);
            len = enemyList.length;
            if (MapManager.IsInArena()){
                var findEnemyInArena:* = function ():Boolean{
                    i = 0;
                    while (i < len) {
                        enemy = (enemyList[i] as GameElementAnimal);
                        if (SelectedPlayerList[enemy] != null){
                        } else {
                            ConfirmTarget(enemy, TargetExtent);
                            if (IsTargetEnemy){
                                SelectedPlayerList[enemy] = enemy;
                                return (true);
                            };
                        };
                        i++;
                    };
                    return (false);
                };
                if (findEnemyInArena()){
                    return (true);
                };
                if (UIUtils.getDictionaryLength(SelectedPlayerList) > 0){
                    for (str in SelectedPlayerList) {
                        delete SelectedPlayerList[str];
                    };
                    SelectedPlayerList = new Dictionary();
                    if (findEnemyInArena()){
                        return (true);
                    };
                };
                return (false);
            };
            if (AutoFbManager.IsAutoFbing){
                i = 0;
                while (i < len) {
                    enemy = enemyList[i];
                    ConfirmTarget(enemy, extent);
                    if (IsTargetEnemy){
                        return (true);
                    };
                    i = (i + 1);
                };
                return (false);
            };
            if (GameCommonData.TargetAnimal){
                ConfirmTarget(GameCommonData.TargetAnimal, 7);
                if (IsTargetEnemy){
                    return (true);
                };
            };
            if (((AutoPlayData.AttackTask) && (isNotInFB()))){
                i = 0;
                while (i < len) {
                    enemy = enemyList[i];
                    if (IsTaskMonster(enemy.Role.MonsterTypeID)){
                        ConfirmTarget(enemy, TargetExtent);
                        if (IsTargetEnemy){
                            return (true);
                        };
                    };
                    i = (i + 1);
                };
            };
            i = 0;
            while (i < len) {
                enemy = enemyList[i];
                ConfirmTarget(enemy, TargetExtent);
                if (IsTargetEnemy){
                    return (true);
                };
                i = (i + 1);
            };
            if (!isNotInFB()){
                i = 0;
                while (i < len) {
                    enemy = enemyList[i];
                    ConfirmTarget(enemy, 6, AutoFbManager.instance().FBRobotPoint, false);
                    if (IsTargetEnemy){
                        return (true);
                    };
                    i = (i + 1);
                };
            };
            return (false);
        }

    }
}//package Manager 
