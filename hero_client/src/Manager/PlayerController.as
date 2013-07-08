//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import OopsEngine.Graphics.Animation.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.View.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import OopsEngine.AI.PathFinder.*;
    import OopsFramework.Audio.*;
    import GameUI.Modules.Transcript.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.AutoPlay.command.*;

    public class PlayerController {

        public static const STATIC_AUTOMEDIATION_TIME:int = 60000;

        public static var mediationTimerid:int = -1;
        public static var IsChangeAutomatism:Boolean = false;
        public static var mediaLastRefreshTime:int;

        public static function RefreshMediState():void{
            clearTimeout(PlayerController.mediationTimerid);
            if (GameCommonData.Player.Role.CurrentJobID == 0){
                return;
            };
            if (!MapManager.IsCanMediationMap()){
                return;
            };
            if (GameCommonData.Player.Role.HP == 0){
                return;
            };
            PlayerController.mediationTimerid = setTimeout(BeginMediation, PlayerController.STATIC_AUTOMEDIATION_TIME);
        }
        public static function BeginAutomatism():void{
            GameCommonData.IsAddAttack = true;
            TargetController.TargetAutomatismID = 0;
            if (GameCommonData.AutomatismPoint == null){
                GameCommonData.AutomatismPoint = new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
            };
            GameCommonData.Player.IsAutomatism = true;
            AutoFbManager.IsAutoFbing = false;
            GameCommonData.Player.Automatism = UpdateAutomatism;
            var _local1:Date = new Date();
            GameCommonData.AutomatismTime = _local1.time;
            AutomatismController.FindPickItem();
            DestinationCursor.getInstance().hide();
        }
        public static function UsePlayerSkill(_arg1:SkillInfo, _arg2:GameElementAnimal, _arg3:Point):void{
            var _local4:GameRole;
            if (((((!((GameCommonData.Player.Role.CanUseSkill == true))) && (!((_arg1.JobLevel == 2))))) && (!((_arg1.Index == 7))))){
                UIFacade.UIFacadeInstance.ShowHint(LanguageMgr.GetTranslation("中状态后无法使用技能"));
                return;
            };
            if ((((_arg1 == null)) || ((_arg2 == null)))){
                return;
            };
            if (GameSkillMode.IsGrabSkill(_arg1)){
                UIFacade.GetInstance().sendNotification(PlayerInfoComList.CAPTURE_PET, _arg2);
            } else {
                if (GameSkillMode.IsToSelfSkill(_arg1)){
                    _local4 = GameCommonData.Player.Role;
                    CombatController.ReserveSkillToSelf(_arg1.Id, _local4.Id, _local4.TileX, _local4.TileY, 0, 0);
                } else {
                    if (_arg3 != null){
                        if (GameSkillMode.IsShowRect(_arg1.SkillType)){
                            CombatController.ReserveSkillAttack(_arg1.Id, GameCommonData.Player.Role.Id, 0, 0, _arg3.x, _arg3.y);
                            GameCommonData.RectSkillID = 0;
                            GameCommonData.RectSkillPos = null;
                            SpeciallyEffectController.getInstance().ClearFloorEffect();
                        };
                    } else {
                        CombatController.ReserveSkillAttack(_arg1.Id, _arg2.Role.Id, _arg2.Role.TileX, _arg2.Role.TileY, 0, 0);
                    };
                };
            };
        }
        public static function onUpdateSkillEffect(_arg1:GameElementAnimal):void{
            if (((!((_arg1.handler == null))) && ((_arg1.handler is PlayerSkillHandler)))){
                _arg1.handler.Run();
            };
        }
        public static function UpdateAutomatism():void{
            var _local1:Date = new Date();
            var _local2:int = (_local1.time - GameCommonData.AutomatismTime);
            if ((((_local2 > 6000)) || ((((TargetController.TargetAutomatismID == 0)) && ((_local2 > 2000)))))){
                if (GameCommonData.TargetAnimal != null){
                    GameCommonData.TargetAnimal.IsSelect(false);
                    GameCommonData.TargetAnimal = null;
                };
                if (!GameCommonData.AutomatismPoint){
                    GameCommonData.AutomatismPoint = new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
                };
                if (!AutomatismController.IsPicking){
                    GameCommonData.AutomatismTime = _local1.time;
                    if (DistanceController.PlayerAutomatism(12, new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY))){
                        Automatism();
                    } else {
                        ClearAutomatism();
                    };
                } else {
                    if (_local2 > 12000){
                        AutomatismController.IsPicking = false;
                    };
                };
            };
        }
        public static function ClearAutomatism():void{
            var _local1:GameElementAnimal;
            if (GameCommonData.AutomatismPoint == null){
                GameCommonData.AutomatismPoint = new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
            };
            if (MapManager.IsInFuben()){
                _local1 = PlayerController.FindNearestAnimalByType(90);
                if (_local1){
                    GameCommonData.TargetAnimal = _local1;
                    trace(("采集宝箱:" + _local1));
                    GameCommonData.Scene.HelloNPC(_local1);
                    return;
                };
            };
            if (((!(AutoFbManager.instance().isComplete)) && (AutoFbManager.instance().isOpen))){
                EndAutomatism();
                if (!AutoFbManager.instance().isEnd()){
                    AutoFbManager.instance().beginAutoPlay(1);
                };
            } else {
                if (((((MapManager.IsInTower()) && (TowerInfo.Info))) && (((!((TowerInfo.HoleX == -1))) && (!((TowerInfo.HoleY == -1))))))){
                    GameCommonData.Scene.MapPlayerTitleMove(new Point(TowerInfo.HoleX, TowerInfo.HoleY));
                } else {
                    if (!GameCommonData.Player.Role.IsMediation){
                        GameCommonData.Scene.MapPlayerTitleMove(GameCommonData.AutomatismPoint);
                    };
                };
            };
        }
        public static function SetFollowTargetAnimal():void{
            GameCommonData.Scene.MapPlayerTitleMove(new Point(GameCommonData.TargetAnimal.Role.TileX, GameCommonData.TargetAnimal.Role.TileY), 2);
            GameCommonData.IsFollow = true;
        }
        public static function onActionPlayFrame(_arg1:AnimationEventArgs):void{
            var _local4:GameAudioResource;
            var _local2:GameElementAnimal = (_arg1.Sender as GameElementAnimal);
            var _local3 = 5;
            if ((((_arg1.CurrentClipName.indexOf(GameElementSkins.ACTION_NEAR_ATTACK) >= 0)) && ((_arg1.CurrentClipFrameIndex == 1)))){
                if (_local2.Role.Type == GameRole.TYPE_OWNER){
                    SoundManager.getInstance().playLoadSound(GameConfigData.GameSkillAudio, _local2.Role.CurrentJobID.toString());
                } else {
                    if (_local2.Role.Type == GameRole.TYPE_PLAYER){
                        SoundManager.getInstance().playLoadSound(GameConfigData.GameSkillAudio, _local2.Role.CurrentJobID.toString());
                    };
                };
            };
            if ((((_local2.Role.Type == GameRole.TYPE_ENEMY)) || ((_local2.Role.Type == GameRole.TYPE_PET)))){
                _local3 = 3;
            };
            if ((((_arg1.CurrentClipName.indexOf(GameElementSkins.ACTION_NEAR_ATTACK) >= 0)) && ((_arg1.CurrentClipFrameIndex == _local3)))){
                if (((!((_local2.handler == null))) && ((_local2.handler is PlayerSkillHandler)))){
                    _local2.handler.Run();
                };
            };
        }
        public static function onActionPlayComplete(_arg1:GameElementAnimal):void{
            var _local2:int;
            var _local3:GameElementAnimal = _arg1;
            if (_local3.Role.ActionState == GameElementSkins.ACTION_DEAD){
                if (_local3.Role.HP == 0){
                    _local3.Dispose();
                    GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.addChild(_local3);
                };
            };
        }
        public static function UseSkill(_arg1:SkillInfo):void{
            var _local2:SkillInfo;
            if (_arg1.TypeID == SkillManager.SKILLID_Mediation){
                PlayerController.BeginMediation(!(GameCommonData.Player.Role.IsMediation));
                return;
            };
            var _local3:Date = new Date();
            AutomatismController.AutomatismCoolTime = _local3.time;
            _local2 = _arg1;
            if (GameCommonData.Player.IsRushing == true){
                return;
            };
            GameCommonData.IsAddAttack = true;
            if (_local2 != null){
                if (GameCommonData.Rect != null){
                    SpeciallyEffectController.getInstance().ClearFloorEffect();
                };
                if (GameSkillMode.IsShowRect(_local2.SkillType)){
                    SpeciallyEffectController.getInstance().GetFloorEffect(_local2.SkillArea);
                    GameCommonData.RectSkillID = _local2.Id;
                } else {
                    if (((((!((GameCommonData.Player.handler == null))) && (!((GameCommonData.Player.handler.skillInfo == null))))) && ((GameSkillMode.IsCommon(GameCommonData.Player.handler.skillInfo.SkillMode) == false)))){
                    } else {
                        PlayerUseSkill(_local2);
                    };
                };
            };
        }
        public static function PlayerUseSkill(_arg1:SkillInfo, _arg2:Point=null):void{
            var _local3:GameElementAnimal;
            if (GameSkillMode.IsCommon(_arg1.Id)){
                GameCommonData.Scene.Attack(GameCommonData.TargetAnimal);
                return;
            };
            if (GameCommonData.TargetAnimal == null){
                _local3 = GameCommonData.Player;
            } else {
                _local3 = GameCommonData.TargetAnimal;
            };
            if (_arg1 != null){
                if (GameSkillMode.IsToSelfSkill(_arg1)){
                    UsePlayerSkill(_arg1, _local3, null);
                    return;
                };
                if ((((((_local3 == GameCommonData.Player)) && ((_arg2 == null)))) && (!((_arg1.SkillType == SkillInfo.EFF_TARGET_SINGLE_TARGET))))){
                    GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("没有可攻击目标"),
                        color:0xFFFF00
                    });
                    return;
                };
                if (_arg2 == null){
                    GameCommonData.Scene.Attack(_local3, _arg1.Id);
                } else {
                    UsePlayerSkill(_arg1, _local3, _arg2);
                };
            };
        }
        public static function EndAutomatism():void{
            clearTimeout(AutomatismController.ClearNum);
            AutoFbManager.instance().stopAutoPlay();
            TargetController.TargetAutomatismID = 0;
            GameCommonData.Player.IsAutomatism = false;
            GameCommonData.AutomatismPoint = null;
            GameCommonData.TargetAnimal = null;
            AutomatismController.IsPicking = false;
            GameCommonData.Player.Automatism = null;
            TargetController.TaskMonsterIdList = new Dictionary();
            UIFacade.UIFacadeInstance.sendNotification(AutoPlayEventList.CANCEL_AUTOPLAY_EVENT);
        }
        public static function BeginMediation(_arg1:Boolean=true):void{
            if (GameCommonData.Player.Role.IsMediation == _arg1){
                return;
            };
            if (((_arg1) && ((GameCommonData.Player.Role.CurrentJobID == 0)))){
                MessageTip.popup(LanguageMgr.GetTranslation("冥想错误提示1"));
            };
            if (!MapManager.IsCanMediationMap()){
                MessageTip.popup(LanguageMgr.GetTranslation("冥想错误提示2"));
                return;
            };
            if (GameCommonData.Player.Role.HP == 0){
                return;
            };
            if (_arg1){
                GameCommonData.Player.Stop();
                if (GameCommonData.Player.Role.UsingPetAnimal){
                    GameCommonData.Player.Role.UsingPetAnimal.Stop();
                };
            };
            PlayerActionSend.BeginMediation(_arg1);
        }
        public static function Automatism():void{
            GameCommonData.Player.Role.DefaultSkill = 0;
            TargetController.GetTarget();
        }
        public static function IsUseSkill(_arg1:GameElementAnimal, _arg2:GameElementAnimal, _arg3:SkillInfo=null):Boolean{
            var _local4:Boolean;
            var _local5:* = 1;
            if (_arg3 != null){
                _local5 = GameSkillMode.TargetState(_arg3);
            };
            switch (_local5){
                case 1:
                    if (_arg2 != null){
                        if (((!((_arg2.Role.ActionState == GameElementSkins.ACTION_DEAD))) && ((_arg2.Role.HP > 0)))){
                            if (_arg2.Role.Type == GameRole.TYPE_ENEMY){
                                _local4 = true;
                            } else {
                                if (_arg2.Role.Type == GameRole.TYPE_PLAYER){
                                    _local4 = true;
                                } else {
                                    if (_arg2.Role.Type == GameRole.TYPE_PET){
                                        if (_arg1.Role.UsingPetAnimal == null){
                                            _local4 = true;
                                        } else {
                                            if (_arg1.Role.UsingPetAnimal.Role.Id != _arg2.Role.Id){
                                                _local4 = true;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                    break;
                case 2:
                    _local4 = true;
                    break;
                case 3:
                    _local4 = true;
                    break;
            };
            if (_arg2 == GameCommonData.DuelAnimal){
                _local4 = true;
            };
            if (_arg2.Role.ArenaTeamId == -1){
                _local4 = false;
            } else {
                if (((!((GameCommonData.Player.Role.ArenaTeamId == 0))) && (!((_arg2.Role.ArenaTeamId == 0))))){
                    if (GameCommonData.Player.Role.ArenaTeamId != _arg2.Role.ArenaTeamId){
                        _local4 = true;
                    };
                } else {
                    if (_arg2.Role.Title == LanguageMgr.GetTranslation("可抓捕")){
                        if (((_arg3) && ((_arg3.TypeID == 9002)))){
                            _local4 = true;
                        } else {
                            _local4 = false;
                        };
                    };
                };
            };
            return (_local4);
        }
        public static function GetPlayer(_arg1:uint):GameElementAnimal{
            var _local2:GameElementAnimal;
            if (((!((GameCommonData.Player == null))) && ((_arg1 == GameCommonData.Player.Role.Id)))){
                _local2 = GameCommonData.Player;
            } else {
                if (((!((GameCommonData.SameSecnePlayerList == null))) && (!((GameCommonData.SameSecnePlayerList[_arg1] == null))))){
                    _local2 = GameCommonData.SameSecnePlayerList[_arg1];
                };
            };
            return (_local2);
        }
        public static function FindNearestAnimalByType(_arg1:uint):GameElementAnimal{
            var _local2:uint;
            var _local5:String;
            var _local6:GameElementAnimal;
            var _local3:int = int.MAX_VALUE;
            var _local4:int;
            for (_local5 in GameCommonData.SameSecnePlayerList) {
                _local6 = (GameCommonData.SameSecnePlayerList[_local5] as GameElementAnimal);
                if (_local6.Role.MonsterTypeID == _arg1){
                    if ((((_local6.Role.Type == GameRole.TYPE_ENEMY)) && ((_local6.Role.HP <= 0)))){
                    } else {
                        _local4 = MapTileModel.Distance(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY, _local6.Role.TileX, _local6.Role.TileY);
                        if (_local4 < _local3){
                            _local3 = _local4;
                            _local2 = _local6.Role.Id;
                        };
                    };
                };
            };
            return (GameCommonData.SameSecnePlayerList[_local2]);
        }
        public static function onMoveStep(_arg1:GameElementAnimal):void{
            UIFacade.UIFacadeInstance.updateSmallMap({
                type:2,
                id:_arg1.Role.Id
            });
        }

    }
}//package Manager 
