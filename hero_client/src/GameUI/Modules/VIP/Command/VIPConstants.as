//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.VIP.Command {
    import flash.display.*;
    import flash.text.*;

    public class VIPConstants {

        public static const Color1:uint = 0xFFFF00;
        public static const Color2:uint = 0xFF00;
        public static const Color3:uint = 0xFF00FF;
        public static const MCSelect:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Selection");
        public static const MCSelect1:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Selection");

        public static var welcomeColor:uint = 0;
        public static var txfm:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.LEFT, null, null, null, 4);
        public static var filter:Array = [];
        public static var viprightscount:Array = [16, 12, 6];

    }
}//package GameUI.Modules.VIP.Command 
