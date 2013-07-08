//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import com.greensock.*;
    import OopsEngine.Graphics.Tagger.*;

    public class FightMessageController {

        private static var xyDis:Number = (((xDis + yDis) / 2) * Math.cos((Math.PI / 4)));
        private static var YDis:Number = 20;
        private static var xDis:Number = 100;
        private static var duration:Number = 1.2;
        private static var yDis:Number = 70;

        public static function showAttackFace(_arg1:GameElementAnimal, _arg2:String="", _arg31:Number=0, _arg4:String="", _arg51:uint=0, _arg61:uint=0):void{
            var attackFace:* = undefined;
            var _arg1:* = _arg1;
            var _arg2:String = _arg2;
            var _arg3:int = _arg31;
            var _arg4:String = _arg4;
            var _arg5:int = _arg51;
            var _arg6:int = _arg61;
            attackFace = null;
            var onComplete:* = null;
            var animal:* = _arg1;
            var $attackType:* = _arg2;
            var $attackValue:* = _arg3;
            var $selfText:* = _arg4;
            var $selfFontSize:* = _arg5;
            var $selfFontColor:* = _arg6;
            onComplete = function ():void{
                if (attackFace.parent){
                    attackFace.parent.removeChild(attackFace);
                };
                AttackFace.recycleAttackFace(attackFace);
            };
            attackFace = AttackFace.createAttackFace($attackType, $attackValue, $selfText, $selfFontSize, $selfFontColor);
            var from:* = new Point(60, YDis);
            var to:* = from.clone();
            var dir:* = attackFace.dir;
            if (dir == 2){
                to.x = (from.x - xDis);
            } else {
                if (dir == 3){
                    to.x = (from.x - xyDis);
                    to.y = (from.y - xyDis);
                } else {
                    if (dir == 6){
                        to.x = (from.x + xDis);
                    } else {
                        to.y = (from.y - yDis);
                    };
                };
            };
            attackFace.x = from.x;
            attackFace.y = from.y;
            if (animal.showContainer){
                animal.showContainer.addChild(attackFace);
            };
            TweenLite.to(attackFace, duration, {
                x:to.x,
                y:to.y,
                onComplete:onComplete,
                ease:myEaseOut
            });
        }
        private static function myEaseOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number=6):Number{
            _arg1 = ((_arg1 / _arg4) - 1);
            return (((_arg3 * (((_arg1 * _arg1) * (((_arg5 + 1) * _arg1) + _arg5)) + 1)) + _arg2));
        }

    }
}//package Manager 
