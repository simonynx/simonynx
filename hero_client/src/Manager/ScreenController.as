//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;

    public class ScreenController {

        public static var IsCanChangeScreen:Boolean = true;
        public static var NowScenePlayerCount:int = 0;

        public static function ShowPet():void{
            var _local1:String;
            var _local2:GameElementAnimal;
            for (_local1 in GameCommonData.SameSecnePlayerList) {
                _local2 = GameCommonData.SameSecnePlayerList[_local1];
                if (_local2.Role.Type == GameRole.TYPE_PLAYER){
                    if (((!(_local2.Role.isHidden)) && (_local2.Enabled))){
                        _local2.Visible = true;
                    };
                };
            };
        }
        public static function ScreenAll():void{
            var _local1:String;
            var _local2:GameElementAnimal;
            for (_local1 in GameCommonData.SameSecnePlayerList) {
                _local2 = GameCommonData.SameSecnePlayerList[_local1];
                if ((((_local2.Role.Type == GameRole.TYPE_PET)) || ((_local2.Role.Type == GameRole.TYPE_PLAYER)))){
                    if (!((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == _local2.Role.Id)))){
                        _local2.Visible = false;
                    };
                };
            };
        }
        public static function ScreenNone():void{
            var _local1:String;
            var _local2:GameElementAnimal;
            for (_local1 in GameCommonData.SameSecnePlayerList) {
                _local2 = GameCommonData.SameSecnePlayerList[_local1];
                if ((((_local2.Role.Type == GameRole.TYPE_PET)) || ((_local2.Role.Type == GameRole.TYPE_PLAYER)))){
                    if (((!(_local2.Role.isHidden)) && (_local2.Enabled))){
                        _local2.Visible = true;
                    };
                };
            };
        }
        public static function SetScreen():void{
            if (IsCanChangeScreen){
                IsCanChangeScreen = false;
                if (GameCommonData.Screen != 2){
                    GameCommonData.Screen = (GameCommonData.Screen + 1);
                } else {
                    GameCommonData.Screen = 0;
                };
                switch (GameCommonData.Screen){
                    case 0:
                        ScreenAll();
                        break;
                    case 1:
                        ShowPet();
                        break;
                    case 2:
                        ScreenNone();
                        break;
                };
                IsCanChangeScreen = true;
            };
        }

    }
}//package Manager 
