//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import OopsFramework.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import OopsEngine.Utils.*;
    import OopsEngine.AI.PathFinder.*;
    import OopsEngine.Pool.*;

    public class GameElementEnemy extends GameElementAnimal implements IPoolClass {

        public function GameElementEnemy(_arg1:Game){
            super(_arg1, new GameElementEnemySkin(this));
        }
        override public function Move(_arg1:Point, _arg2:int=0):void{
            var _local3:Point;
            if (!(((this.GameX == _arg1.x)) && ((this.GameY == _arg1.y)))){
                if (((!((this.Role.ActionState == GameElementSkins.ACTION_DEAD))) && (!((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))))){
                    _local3 = _arg1.add(new Point(-(this.excursionX), -(this.excursionY)));
                    if (this.smoothMove.IsMoving){
                        this.smoothMove.AddPath(_local3);
                    } else {
                        this.smoothMove.Move([_local3]);
                    };
                    this.Role.Direction = Vector2.DirectionByTan(this.GameX, this.GameY, _arg1.x, _arg1.y);
                    this.SetAction(GameElementSkins.ACTION_RUN, this.Role.Direction);
                };
            };
        }
        override protected function onMoveNode(_arg1:int):Boolean{
            super.onMoveNode(_arg1);
            var _local2:Boolean;
            if (((!((this.Role.ActionState == GameElementSkins.ACTION_DEAD))) && (!((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))))){
                this.Role.Direction = _arg1;
                this.SetAction(GameElementSkins.ACTION_RUN, this.Role.Direction);
            };
            return (_local2);
        }
        override public function reSet(_arg1:Array):void{
            ispooled = true;
            _isDispose = false;
            skins.reSet();
        }
        public function dispose():void{
            personTitle.text = "dispose";
            personGuildName.text = "dispose";
            personName.text = "dispose";
            _isDispose = true;
            skins.dispose();
        }
        override public function RemoveSkin(_arg1:String):void{
            this.skins.RemovePersonSkin(_arg1);
        }
        override protected function onMoveComplete():void{
            super.onMoveComplete();
            if (((!((this.Role.ActionState == GameElementSkins.ACTION_DEAD))) && (!((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))))){
                this.smoothMove.IsMoving = false;
                this.SetAction(GameElementSkins.ACTION_STATIC);
            };
        }
        override public function SetSkin(_arg1:String, _arg2:String):void{
            switch (_arg1){
                case GameElementSkins.EQUIP_PERSON:
                    GameElementEnemySkin(this.skins).ChangePerson(true);
                    break;
            };
        }
        override public function MoveTile(_arg1:Point, _arg2:int=0):void{
            if (((!((this.Role.ActionState == GameElementSkins.ACTION_DEAD))) && (!((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))))){
                this.Move(MapTileModel.GetTilePointToStage(_arg1.x, _arg1.y));
            };
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
