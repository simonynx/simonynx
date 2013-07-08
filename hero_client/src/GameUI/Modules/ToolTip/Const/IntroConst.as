//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ToolTip.Const {
    import flash.utils.*;
    import flash.text.*;

    public class IntroConst {

        public static const COLOR:uint = 15321759;
        public static const SHOWPARALLEL:String = "showparallel";
        public static const RunePrefixValue:Array = [[1, 1, 3, 1, 1, 1, 0, 0, 0, 0], [3, 2, 9, 3, 2, 2, 2, 3, 0, 0], [9, 4, 27, 9, 4, 4, 8, 9, 1, 1], [27, 8, 81, 27, 8, 8, 32, 27, 2, 2]];
        public static const EquipHoleType:Array = ["", "攻击", "防御", "命中", "躲闪", "暴击伤害", "暴击率", "生命", "魔法", "契约"];
        public static const RunePrefix:Array = ["", "每一击造成的伤害增加", "防御力增加", "生命力增加", "全抗性增加", "攻击力增加", "暴击伤害增加", "击杀怪后魔法值回复", "击杀怪后生命力回复", "技能命中增加", "技能躲闪增加"];
        public static const TreasureExp:Array = [0, 2, 14, 28, 44, 88, 117, 234, 469, 938, 1877, 3754, 7509, 15018, 30037, 60074, 120149, 240298, 360448, 480597];
        public static const TreasurePropRatio:Array = [0, 1.8, 4.21495, 6.87846, 9.67568, 12.5563, 15.494, 18.473, 21.4835, 24.5187, 27.5737, 30.6451, 33.7303, 36.827, 39.9338, 43.0493, 46.1724, 49.3023, 52.4382, 55.5795];
        public static const RunePropValue:Array = [[3, 6, 9, 15, 24, 42, 66, 111], [1, 2, 3, 5, 8, 14, 22, 37], [4, 6, 9, 14, 20, 30, 46, 68], [3, 5, 7, 10, 15, 23, 34, 51], [1, 2, 3, 4, 5, 6, 7, 8], [30, 42, 59, 82, 115, 161, 225, 316], [10, 20, 30, 60, 100, 190, 340, 610], [8, 16, 24, 48, 80, 152, 272, 488]];
        public static const EquipColors:Array = [14610175, 3446576, 26367, 9569000, 16478724];
        public static const itemColors:Array = ["#deeeff", "#349730", "#1f58c3", "#0098FF", "#7a3fe9", "#FF6532"];
        public static const HUN_YIN_COLOR:String = "#6532FF";
        public static const EquipHolePrefix:Array = ["", "狂怒", "强固", "贪婪", "年轮", "蛮力", "审判", "真理", "希望", "自由", "避世"];
        public static const MarketColors:Array = [14610175, 0xFF00, 52479, 0xCC00FF, 16750899];
        public static const EquipColorStr:Array = ["#deeeff", "#349730", "#0066ff", "#9202E8", "#fb7204"];

        public static var ItemInfo:Dictionary = new Dictionary();
        public static var GlobalLevel:int = -1;
        public static var GlobalBind:uint = 0;
        public static var GlobalTreasureLife:Array = new Array(8);
        public static var ShowBind:Boolean = true;

        public static function fontTf(_arg1:uint=16, _arg2:String="", _arg3:String="STKaiti"):TextFormat{
            if (!_arg2){
                _arg2 = TextFormatAlign.LEFT;
            };
            var _local4:TextFormat = new TextFormat();
            _local4.size = _arg1;
            _local4.font = _arg3;
            _local4.align = _arg2;
            return (_local4);
        }

    }
}//package GameUI.Modules.ToolTip.Const 
