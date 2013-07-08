//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import GameUI.View.HButton.*;
    import GameUI.Modules.TreasureChests.View.*;

    public class BtnManager {

        public static var convoyBtn:HBaseButton;
        public static var CSBBtn:HBaseButton;
        public static var treasureChest:TreasureChest;
        public static var petRaceBtn:HBaseButton;
        public static var arenaBtn:HBaseButton;
        public static var partyBtn:HBaseButton;
        private static var btns:Array;
        public static var yxdhsBtn:HBaseButton;
        public static var questionBtn:HBaseButton;
        public static var guildFightBtn:HBaseButton;

        public static function set Visible(_arg1:Boolean):void{
            if (treasureChest){
                treasureChest.visible = _arg1;
            };
            var _local2:int;
            while (_local2 < btns.length) {
                if (btns[_local2]){
                    btns[_local2].visible = _arg1;
                };
                _local2++;
            };
        }
        public static function RankBtnPos():void{
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            btns = [CSBBtn, partyBtn, arenaBtn, questionBtn, guildFightBtn, convoyBtn, yxdhsBtn];
            var _local1:Array = btns;
            _local2 = (GameCommonData.GameInstance.ScreenWidth - 220);
            _local3 = 121;
            if (((treasureChest) && (treasureChest.parent))){
                treasureChest.x = (_local2 + (treasureChest.width / 2));
                treasureChest.y = _local3;
                _local2 = (_local2 - treasureChest.width);
            };
            while (_local4 < _local1.length) {
                if (_local1[_local4]){
                    _local1[_local4].x = (_local2 - (_local5 * 45));
                    _local1[_local4].y = (_local3 - 10);
                    _local5++;
                };
                _local4++;
            };
        }

    }
}//package Manager 
