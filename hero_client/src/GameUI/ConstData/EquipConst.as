//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.ConstData {
    import flash.display.*;

    public class EquipConst {

        public static const MONEY_COLOR:String = "#fea100";
        public static const TITLE_COLOR:String = "#BAF24F";

        public static function addStar(_arg1:int, _arg2:MovieClip):void{
            var _local5:MovieClip;
            while (_arg2.numChildren > 0) {
                _arg2.removeChildAt(0);
            };
            var _local3:int = Math.floor((_arg1 / 2));
            var _local4:int = (_arg1 % 2);
            var _local6:int;
            while (_local6 < _local3) {
                _local5 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Stars");
                _local5.x = (_local6 * 18);
                _arg2.addChild(_local5);
                _local6++;
            };
            if (_local4 == 1){
                _local5 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Stars");
                _local5.gotoAndStop(2);
                _local5.x = (_local3 * 18);
                _arg2.addChild(_local5);
            };
        }

    }
}//package GameUI.ConstData 
