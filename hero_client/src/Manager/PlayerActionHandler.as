//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsEngine.Skill.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import OopsEngine.Utils.*;
    import OopsEngine.Scene.StrategyElement.Person.*;

    public class PlayerActionHandler extends Handler {

        public function PlayerActionHandler(_arg1:GameElementAnimal, _arg2:Handler, _arg3:Array, _arg4:SkillInfo, _arg5:GameSkillBuff, _arg6:int, _arg7:Point=null, _arg8:int=1){
            super(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8);
        }
        override public function Run():void{
            switch (this.Process){
                case 1:
                    PlayerAction();
                    break;
            };
            super.Run();
        }
        override public function Clear():void{
            super.Clear();
        }
        public function PlayerAction():void{
            var _local1:int;
            var _local2:GameElementPet;
            if (this.Animal.isDispose){
                return;
            };
            if (!this.TargerPoint){
                return;
            };
            if (((GameSkillMode.IsNoChangeDir(this.skillInfo.SkillMode)) && (Animal.Role.IsTurn))){
                if (!(((this.Animal.GameX == this.TargerPoint.x)) && ((this.Animal.GameY == this.TargerPoint.y)))){
                    _local1 = Vector2.DirectionByTan(this.Animal.GameX, this.Animal.GameY, this.TargerPoint.x, this.TargerPoint.y);
                    this.Animal.SetDirection(_local1);
                };
            };
            super.NextHendler();
            this.Animal.SetAction(GameElementSkins.ACTION_NEAR_ATTACK);
            if (GameSkillMode.IsShowSkillName(skillInfo.Id)){
                CombatController.Skill(this.Animal, skillInfo.Name);
            };
        }

    }
}//package Manager 
