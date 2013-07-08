//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene {
    import OopsEngine.Skill.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;

    public class Handler {

        public var IsSmoothMoving:Boolean = false;
        public var TimeID:int = 0;
        public var floor:int = 0;
        public var Process:int = 1;
        public var Next:Handler;
        public var Animal:GameElementAnimal;
        public var skillInfo:SkillInfo;
        public var SkillEffectList:Array;
        public var TargerPoint:Point;
        public var gameSkillBuff:GameSkillBuff;

        public function Handler(_arg1:GameElementAnimal, _arg2:Handler, _arg3:Array, _arg4:SkillInfo, _arg5:GameSkillBuff, _arg6:int, _arg7:Point, _arg8:int=1):void{
            SkillEffectList = new Array();
            TargerPoint = new Point(0, 0);
            super();
            skillInfo = _arg4;
            Animal = _arg1;
            Process = _arg8;
            Next = _arg2;
            TargerPoint = _arg7;
            SkillEffectList = _arg3;
            TimeID = _arg6;
            gameSkillBuff = _arg5;
        }
        public static function FindEndHendler(_arg1:Handler, _arg2:Handler):void{
            if (_arg1.Next != null){
                FindEndHendler(_arg1.Next, _arg2);
            } else {
                _arg1.Next = _arg2;
            };
        }

        public function GetNext(_arg1:Handler):void{
            floor = (floor + 1);
            if (_arg1.Next != null){
                GetNext(_arg1.Next);
            };
        }
        public function Run():void{
        }
        public function get Floor():int{
            floor = 0;
            if (this.Next != null){
                GetNext(this.Next);
            };
            return (floor);
        }
        public function Clear():void{
            NextHendler();
            if (this.Animal.handler != null){
                this.Animal.handler.Clear();
            };
        }
        public function NextHendler():void{
            Animal.handler = Next;
        }

    }
}//package OopsEngine.Scene 
