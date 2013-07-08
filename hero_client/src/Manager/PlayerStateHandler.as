//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.View.*;
    import OopsEngine.AI.PathFinder.*;

    public class PlayerStateHandler extends Handler {

        var m_isclear:Boolean;

        public function PlayerStateHandler(_arg1:GameElementAnimal, _arg2:Handler, _arg3:Array, _arg4:SkillInfo, _arg5:GameSkillBuff, _arg6:int, _arg7:Point=null, _arg8:int=1):void{
            super(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8);
        }
        private function autoPlayHandler(_arg1:GameElementAnimal):void{
            if (((GameCommonData.Player.IsAutomatism) || (AutoFbManager.IsAutoFbing))){
                if ((((((this.Animal == GameCommonData.Player)) || ((this.Animal == GameCommonData.Player.Role.UsingPetAnimal)))) || ((TargetController.TargetAutomatismID == _arg1.Role.Id)))){
                    TargetController.TargetAutomatismID = 0;
                    clearTimeout(AutomatismController.ClearNum);
                    AutomatismController.ClearNum = setTimeout(AutomatismController.FindPickItem, 300);
                };
            };
        }
        public function ChangeState():void{
            var _local1:GameSkillEffect;
            for each (_local1 in this.SkillEffectList) {
                ShowAttackPrompt(_local1);
            };
            SkillEffectList = [];
            super.NextHendler();
            if (Animal.handler != null){
                Animal.handler.Run();
            };
        }
        public function ShowAttackPrompt(_arg1:GameSkillEffect):void{
            var _local2:int;
            var _local3:Point;
            var _local4:Point;
            switch (_arg1.TargerState){
                case SkillInfo.TARGET_DEAD:
                    if (!_arg1.TargerPlayer){
                        return;
                    };
                    if (_arg1.TargerPlayer.isDispose){
                        trace((((("the targetPlayer is dispose:" + _arg1.TargerPlayer.Role.Name) + "(") + _arg1.TargerPlayer.Role.Id) + ")"));
                        autoPlayHandler(_arg1.TargerPlayer);
                        return;
                    };
                    UIFacade.UIFacadeInstance.upDateInfo(6);
                    _arg1.TargerPlayer.Stop();
                    _arg1.TargerPlayer.SetAction(GameElementSkins.ACTION_DEAD);
                    if ((((this.Animal == GameCommonData.Player)) && ((Math.random() > 0.5)))){
                        SpeciallyEffectController.getInstance().screen_shake();
                        if (!((skillInfo) && (GameSkillMode.IsShowRect(skillInfo.SkillType)))){
                            _local2 = Animal.Role.Direction;
                            _local3 = MapTileModel.GetTileStageToPoint(_arg1.TargerPlayer.x, _arg1.TargerPlayer.y);
                            _local4 = MapTileModel.GetNextPos(_local3.x, _local3.y, _local2, 4);
                            SpeciallyEffectController.getInstance().hitBack(_arg1.TargerPlayer, _local4, 600, null);
                        };
                    };
                    if (((((!((this.Animal == _arg1.TargerPlayer))) && (!((_arg1.TargerPlayer.handler == null))))) && (!((_arg1.TargerPlayer.handler == this))))){
                        _arg1.TargerPlayer.handler.Clear();
                    };
                    if (_arg1.TargerPlayer.Role.Id == GameCommonData.Player.Role.Id){
                        MessageTip.show((this.Animal.Role.Name + LanguageMgr.GetTranslation("将你杀害了")));
                        UIFacade.UIFacadeInstance.showRelive();
                        if (GameCommonData.Player.IsAutomatism){
                            AutoFbManager.instance().stopAutoPlay();
                            PlayerController.EndAutomatism();
                        };
                    };
                    trace("杀死敌人,继续挂机");
                    autoPlayHandler(_arg1.TargerPlayer);
                    if (((!((GameCommonData.PetTargetAnimal == null))) && ((GameCommonData.PetTargetAnimal.Role.Id == _arg1.TargerPlayer.Role.Id)))){
                        GameCommonData.Player.Role.UsingPetAnimal.isWalk = true;
                        if (!DistanceController.PlayerPetDistance(3)){
                            GameCommonData.Player.Role.UsingPetAnimal.MoveSeek();
                        };
                    };
                    SpeciallyEffectController.getInstance().SetDeadEffect(_arg1.TargerPlayer);
                    break;
            };
        }
        override public function Run():void{
            switch (this.Process){
                case 1:
                    ChangeState();
                    break;
            };
        }
        override public function Clear():void{
            var _local1:GameSkillEffect;
            if (m_isclear){
                trace("重复调用Clear()");
                return;
            };
            m_isclear = true;
            for each (_local1 in this.SkillEffectList) {
                ShowAttackPrompt(_local1);
            };
            SkillEffectList = [];
            m_isclear = false;
            super.Clear();
        }

    }
}//package Manager 
