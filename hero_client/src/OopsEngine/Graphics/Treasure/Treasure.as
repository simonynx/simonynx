//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Graphics.Treasure {
    import flash.display.*;
    import OopsEngine.Skill.*;
    import OopsFramework.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;

    public class Treasure extends Sprite {

        private var MasterPlayer:GameElementAnimal;
        private var radiusY:int = 60;
        private var radiusX:int = 90;
        private var effect:SkillAnimation;
        private var EndPoint:Point;
        private var mc:MovieClip;
        private var IsLoop:Boolean;
        private var path:String = "";
        private var treasureSkillCnt:int;
        private var treasureId:int;
        private var offsetPoint:Point;
        private var treasureSkillLevel:int;
        private var angle:int;
        private var Can4EffectItemArr:Array;
        private var CanShowAfterimgItemArr:Array;
        private var timeCnt:uint = 0;
        private var velocity:Point;
        private var setOffpointCnt:int = 0;
        private var IsBacking:Boolean;

        public function Treasure(_arg1:GameElementAnimal, _arg2:int){
            velocity = new Point();
            EndPoint = new Point();
            CanShowAfterimgItemArr = [20700006, 20700007, 20700008, 20700009];
            Can4EffectItemArr = [20700006, 20700007, 20700008, 20700009];
            super();
            this.MasterPlayer = _arg1;
            this.treasureId = int((_arg2 / 100));
            this.treasureSkillCnt = int((int((_arg2 % 100)) / 10));
            this.treasureSkillLevel = int((_arg2 % 10));
            init();
        }
        private function stop(_arg1:GameTime):void{
            if (IsLoop){
            } else {
                if (!IsBacking){
                    IsBacking = true;
                    if (this.x > offsetPoint.x){
                        EndPoint = Focus_Right;
                    } else {
                        EndPoint = Focus_Left;
                    };
                    velocity.x = ((EndPoint.x - this.x) / (30 / 2));
                    velocity.y = ((EndPoint.y - this.y) / (30 / 2));
                    this.x = (this.x + velocity.x);
                    this.y = (this.y + velocity.y);
                    if ((((Math.abs((this.x - EndPoint.x)) <= 1)) && ((Math.abs((this.y - EndPoint.y)) <= 1)))){
                        this.x = EndPoint.x;
                        this.y = EndPoint.y;
                        IsBacking = false;
                        IsLoop = true;
                        if (this.x > offsetPoint.x){
                            angle = 0;
                        } else {
                            angle = 180;
                        };
                    };
                };
            };
        }
        private function init():void{
            this.mouseEnabled = false;
            this.mouseChildren = false;
            var _local1:* = ((String(this.treasureId) + "_") + treasureSkillLevel);
            if (((((!((Can4EffectItemArr.indexOf(treasureId) == -1))) && ((treasureSkillLevel >= 3)))) && ((treasureSkillCnt >= 4)))){
                _local1 = (String(this.treasureId) + "_4");
            };
            TreasureController.getInstance().GetEffectRes(_local1, onLoaderComplete);
        }
        private function createAfterimage():void{
            if ((((this.width == 0)) || ((this.height == 0)))){
                return;
            };
            SpeciallyEffectController.getInstance().createAfterimg(this.effect);
        }
        private function getPos(_arg1:Number):Point{
            _arg1 = ((_arg1 * Math.PI) / 180);
            return (new Point((radiusX * Math.cos(_arg1)), (radiusY * Math.sin(_arg1))).add(offsetPoint));
        }
        public function dispose():void{
            TreasureController.getInstance().RemoveComFun(((String(this.treasureId) + "_") + treasureSkillLevel), onLoaderComplete);
            if (this.parent){
                this.parent.removeChild(this);
            };
            MasterPlayer = null;
            if (((effect) && (effect.parent))){
                effect.parent.removeChild(effect);
            };
            SkillAnimation.recycleSkillAnimation(effect);
            effect = null;
        }
        private function loop():void{
            angle = (angle + 2);
            EndPoint = getPos(angle);
            velocity.x = ((EndPoint.x - this.x) / 30);
            velocity.y = ((EndPoint.y - this.y) / 30);
            this.x = (this.x + velocity.x);
            this.y = (this.y + velocity.y);
            if (y < 30){
                MasterPlayer.addChildAt(this, 0);
            } else {
                MasterPlayer.addChildAt(this, (MasterPlayer.numChildren - 1));
            };
        }
        private function onLoaderComplete(_arg1:MovieClip):void{
            effect = GetAnimation(_arg1);
            addChild(effect);
            effect.isLoop = true;
            effect.StartClip("jn", 0, 12);
            setOffsetPoint();
        }
        private function get Focus_Right():Point{
            return (new Point(Math.pow(((radiusX * radiusX) - (radiusY * radiusY)), 0.5), 0).add(offsetPoint));
        }
        private function move(_arg1:GameTime):void{
            switch (MasterPlayer.Role.Direction){
                case 1:
                    angle = 135;
                    break;
                case 2:
                    angle = 90;
                    break;
                case 3:
                    angle = 45;
                    break;
                case 4:
                    angle = 180;
                    break;
                case 6:
                    angle = 0;
                    break;
                case 7:
                    angle = -135;
                    break;
                case 8:
                    angle = -90;
                    break;
                case 9:
                    angle = -45;
                    break;
            };
            angle = (angle - 180);
            EndPoint = getPos(angle);
            if (y < offsetPoint.y){
                MasterPlayer.addChildAt(this, 0);
            } else {
                MasterPlayer.addChildAt(this, (MasterPlayer.numChildren - 1));
            };
            velocity.x = ((EndPoint.x - this.x) / 30);
            velocity.y = ((EndPoint.y - this.y) / 30);
            this.x = (this.x + velocity.x);
            this.y = (this.y + velocity.y);
            if ((timeCnt % 4) == 0){
                if (CanShowAfterimgItemArr.indexOf(treasureId) != -1){
                    createAfterimage();
                };
                timeCnt = 0;
            };
            timeCnt++;
        }
        private function get Focus_Left():Point{
            return (new Point(-(Math.pow(((radiusX * radiusX) - (radiusY * radiusY)), 0.5)), 0).add(offsetPoint));
        }
        public function Update(_arg1:GameTime):void{
            if (offsetPoint == null){
                if (setOffpointCnt < 10){
                    setOffsetPoint();
                    setOffpointCnt++;
                };
                return;
            };
            if (MasterPlayer.IsMoving){
                move(_arg1);
                IsLoop = false;
            } else {
                IsBacking = false;
                stop(_arg1);
            };
            if (effect){
                effect.Update(_arg1);
            };
        }
        public function GetAnimation(_arg1:MovieClip):SkillAnimation{
            var geed:* = null;
            var EffectPath:* = null;
            var EffectName:* = null;
            var start:* = 0;
            var mc:* = _arg1;
            mc = mc;
            var animationSkill:* = SkillAnimation.createSkillAnimation();
            animationSkill.IsPool = true;
            EffectPath = mc.name;
            EffectName = mc.name;
            if (mc != null){
                try {
                    if (geed == null){
                        start = getTimer();
                        trace(("开始分析: " + EffectPath));
                        geed = new GameSkillData(animationSkill);
                        geed.Analyze(mc);
                        trace((((("加载到" + EffectPath) + "并分析完,用了") + (getTimer() - start)) + "时间"));
                    } else {
                        geed.SetAnimationData(animationSkill);
                    };
                } catch(e:Error) {
                    throw (new Error(((("EffectName  " + EffectName) + "   EffectPath ") + EffectPath)));
                };
            };
            return (animationSkill);
        }
        private function setOffsetPoint():void{
            if (((MasterPlayer) && (MasterPlayer.PersonName))){
                offsetPoint = new Point((MasterPlayer.PersonName.x + (MasterPlayer.PersonName.width / 2)), 38);
                this.x = offsetPoint.x;
                this.y = (offsetPoint.y - radiusY);
            };
        }

    }
}//package OopsEngine.Graphics.Treasure 
