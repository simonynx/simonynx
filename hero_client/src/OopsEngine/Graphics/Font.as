//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Graphics {
    import flash.filters.*;

    public class Font {

        public static var AttackFaceFilter:Array = [new GlowFilter(0, 1, 2, 2, 2, 1), new DropShadowFilter(3, 45, 0, 1, 2, 2, 1)];

        public static function Stroke(_arg1:uint=0):Array{
            var _local2:GlowFilter = new GlowFilter(_arg1, 1, 2, 2, 12);
            var _local3:Array = new Array();
            _local3.push(_local2);
            return (_local3);
        }
        public static function ObjectFilter():Array{
            var _local1:GlowFilter = new GlowFilter(10092543, 1, 10, 10, 3, 1, false, false);
            var _local2:Array = new Array(_local1);
            return (_local2);
        }

    }
}//package OopsEngine.Graphics 
