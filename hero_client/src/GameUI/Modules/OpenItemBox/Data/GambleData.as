//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.OpenItemBox.Data {
    import GameUI.ConstData.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class GambleData {

        public static const PAGECOUNT:uint = 50;
        public static const labelNames:Array = ["远古废墟", "勇士墓穴"];
        public static const TOTALPAGE:uint = 8;
        public static const moneyList:Array = [[11, 105, 500], [26, 0xFF, 1250], [100, 400, 3000]];

        public static var selfHistroyList:Array = [];
        public static var gambleDepotList:Array = [];
        public static var globalHistroyList:Array = [];
        public static var currGambleList:Array;
        public static var DepotCount:uint = 0;

        public static function getRecordList(_arg1:uint):Array{
            var _local4:String;
            var _local5:Object;
            var _local6:ItemTemplateInfo;
            var _local7:Array;
            var _local2:int;
            var _local3:Array = [];
            if (_arg1 == 0){
                _local7 = selfHistroyList;
            } else {
                _local7 = globalHistroyList;
            };
            _local2 = (_local7.length - 1);
            while (_local2 >= 0) {
                _local5 = _local7[_local2];
                _local6 = UIConstData.ItemDic[_local5.itemId];
                if (_local6){
                    if (_arg1 == 0){
                        _local4 = LanguageMgr.GetTranslation("你在x中寻宝发现了y", getColorText(labelNames[_local5.level], "#FD7902"), getColorText((("[" + _local6.Name) + "]"), IntroConst.EquipColorStr[_local6.Color]));
                    } else {
                        _local4 = LanguageMgr.GetTranslation("x在y中寻宝发现了z", getLinkColorText(_local5.playerName, "#00FF00", String(((_local5.playerName + "_") + _local5.playerId))), getColorText(labelNames[_local5.level], "#FD7902"), getLinkColorText((("[" + _local6.Name) + "]"), IntroConst.EquipColorStr[_local6.Color], String(_local6.TemplateID)));
                    };
                    _local3.push(_local4);
                };
                _local2--;
            };
            return (_local3);
        }
        public static function getLinkColorText(_arg1:String, _arg2:String, _arg3:String):String{
            return ((((((("<font color=\"" + _arg2) + "\"><a href=\"event:") + _arg3) + "\">") + _arg1) + "</a></font>"));
        }
        public static function getColorText(_arg1:String, _arg2:String):String{
            return ((((("<font color='" + _arg2) + "'>") + _arg1) + "</font>"));
        }

    }
}//package GameUI.Modules.OpenItemBox.Data 
