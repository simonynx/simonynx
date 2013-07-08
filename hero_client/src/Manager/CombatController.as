//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Net.RequestSend.*;

    public class CombatController {

        public var INTERACT_ATTACK:int = 2;
        public var INTERACT_SHOOT:int = 21;

        public static function Skill(_arg1:DisplayObject, _arg2:String):void{
            if (((MapManager.IsInArena()) || (MapManager.IsInGVG()))){
                return;
            };
            Prompt(_arg1, _arg2, "CombatPrompt_UP_Skill");
        }
        public static function Deblock():void{
            SkillManager.UseSkillLock = false;
        }
        public static function ReserveAttack(_arg1:GameElementAnimal):void{
            PlayerActionSend.SendAttack(_arg1.Role.Id);
        }
        public static function Prompt(_arg1:DisplayObject, _arg2:String, _arg3:String):void{
            var _local4:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(_arg3);
            if (_arg2 != ""){
                _local4.Container.txtPrompt.text = _arg2;
            };
            if (_arg1){
                _local4.x = (_arg1.x - 10);
                _local4.y = _arg1.y;
                if (((GameCommonData.GameInstance.GameScene.GetGameScene) && (GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer))){
                    GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.addChild(_local4);
                };
            };
        }
        public static function ReserveSkillToSelf(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:int, _arg6:int):void{
            if (!SkillManager.UseSkillLock){
                PlayerActionSend.SendSkill(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6);
                SkillManager.UseSkillLock = true;
                setTimeout(Deblock, 500);
            };
        }
        public static function ReserveSkillAttack(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:int, _arg6:int):void{
            if (!SkillManager.UseSkillLock){
                PlayerActionSend.SendSkill(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6);
                SkillManager.UseSkillLock = true;
                setTimeout(Deblock, 500);
            };
        }
        public static function SuckPrompt(_arg1:DisplayObject):void{
            Prompt(_arg1, "吸收", "CombatPrompt_Left_Evasion");
        }

    }
}//package Manager 
