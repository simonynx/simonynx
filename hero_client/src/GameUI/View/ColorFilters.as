//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View {
    import flash.filters.*;

    public class ColorFilters {

        public static const GREEN_STRONG_HTML:String = "#00C957";
        public static const GREEN_HTML:String = "#00ff00";
        public static const WHITE:int = 0xFFFFFF;
        public static const PURPLE50_HTML:String = "#da70d6";
        public static const BlUE50:int = 8900331;
        public static const YELLOW_HTML:String = "#ffff00";
        public static const ORANGE_HTML:String = "#ff9912";
        public static const WHITE_HTML:String = "#ffffff";
        public static const BlUE50_HTML:String = "#87ceeb";
        public static const ORANGE_RED_HTML:String = "#ff4500";
        public static const ORANGE:int = 16750866;
        public static const SKY_BLUE_HTML:String = "#00ffff";
        public static const RED_HTML:String = "#ff0000";
        public static const PURPLE:int = 14315734;
        public static const BlUE20:int = 11591910;
        public static const PURPLE_HTML:String = "#9933fa";
        public static const BlUE20_HTML:String = "#b0e0e6";
        public static const PURPLE50:int = 10040314;
        public static const SKY_BLUE:int = 0xFFFF;
        public static const BLUE:int = 2003199;
        public static const GREEN:int = 0xFF00;
        public static const GOLD:int = 0xFFD700;
        public static const ORANGE_RED:int = 0xFF4500;
        public static const RED:int = 0xFF0000;
        public static const GREEN_STRONG:int = 51543;
        public static const YELLOW:int = 0xFFFF00;
        public static const BLUE_HTML:String = "#1e90ff";
        public static const GOLD_HTML:String = "#ffd700";

        private static var gLum:Number = 0.7169;
        private static var blackGoundMatrix:Array = [0.35, 0, 0, 0, 25.525, 0, 0.35, 0, 0, 25.525, 0, 0, 0.35, 0, 25.525, 0, 0, 0, 1, 0];
        private static var rLum:Number = 0.2225;
        private static var bLum:Number = 0.0606;
        private static var redMatrix:Array = [1, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 1, 0];
        private static var blackFilter:ColorMatrixFilter;
        private static var redFilter:ColorMatrixFilter;
        private static var bwMatrix:Array = [rLum, gLum, bLum, 0, 0, rLum, gLum, bLum, 0, 0, rLum, gLum, bLum, 0, 0, 0, 0, 0, 1, 0];
        private static var filter:ColorMatrixFilter;

        public static function get BlackGoundFilter():ColorMatrixFilter{
            if (!blackFilter){
                blackFilter = new ColorMatrixFilter(blackGoundMatrix);
            };
            return (blackFilter);
        }
        public static function get BWFilter():ColorMatrixFilter{
            if (!filter){
                filter = new ColorMatrixFilter(bwMatrix);
            };
            return (filter);
        }
        public static function WeaponLightFilterA(_arg1:int):GlowFilter{
            var _local2:GlowFilter;
            var _local3:int;
            if ((((((((_arg1 == 4)) || ((_arg1 == 7)))) || ((_arg1 == 10)))) || ((_arg1 == 13)))){
                _local3 = 4;
            } else {
                if ((((((((_arg1 == 5)) || ((_arg1 == 8)))) || ((_arg1 == 11)))) || ((_arg1 == 14)))){
                    _local3 = 8;
                } else {
                    if ((((((((_arg1 == 6)) || ((_arg1 == 9)))) || ((_arg1 == 12)))) || ((_arg1 == 15)))){
                        _local3 = 16;
                    };
                };
            };
            if ((((_arg1 >= 4)) && ((_arg1 <= 6)))){
                _local2 = new GlowFilter(0xFF00, 1, _local3, _local3, 3, 1, false, false);
            } else {
                if ((((_arg1 >= 7)) && ((_arg1 <= 9)))){
                    _local2 = new GlowFilter(0xFF, 1, _local3, _local3, 3, 1, false, false);
                } else {
                    if ((((_arg1 >= 10)) && ((_arg1 <= 12)))){
                        _local2 = new GlowFilter(0xFF00FF, 1, _local3, _local3, 3, 1, false, false);
                    } else {
                        if ((((_arg1 >= 13)) && ((_arg1 <= 15)))){
                            _local2 = new GlowFilter(0xFF0000, 1, _local3, _local3, 3, 1, false, false);
                        };
                    };
                };
            };
            return (_local2);
        }
        public static function WeaponLightFilterB(_arg1:int):GlowFilter{
            var _local2:GlowFilter;
            var _local3:int;
            if (_arg1 == 4){
                _local3 = 0xFF9C00;
            };
            if (_arg1 == 5){
                _local3 = 0xFF9C00;
            };
            if (_arg1 == 6){
                _local3 = 0xFF9C00;
            };
            if (_arg1 == 7){
                _local3 = 16728964;
            };
            if (_arg1 == 8){
                _local3 = 16728964;
            };
            if (_arg1 == 9){
                _local3 = 16728964;
            };
            if (_arg1 == 10){
                _local3 = 0xFFFF;
            };
            if (_arg1 == 11){
                _local3 = 0xFFFF;
            };
            if (_arg1 == 12){
                _local3 = 0xFFFF;
            };
            if (_arg1 == 13){
                _local3 = 0xFFFF;
            };
            if (_arg1 == 14){
                _local3 = 0xFFFF;
            };
            if (_arg1 == 15){
                _local3 = 0xFFFF;
            };
            _local2 = new GlowFilter(_local3, 1, 4, 4, 3, 1, false, false);
            return (_local2);
        }
        public static function get RedFilter():ColorMatrixFilter{
            if (!redFilter){
                redFilter = new ColorMatrixFilter(redMatrix);
            };
            return (redFilter);
        }

    }
}//package GameUI.View 
