//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ChangeLine.Data {

    public class ChgLineData {

        public static const SHOW_LINE_LIST:String = "SHOW_LINE_LIST";
        public static const CHG_LINE_FAIL:String = "CHG_LINE_FAIL";
        public static const ARENA_GO_LINE:String = "ARENA_GO_LINE";
        public static const CHG_LINE_GO:String = "CHG_LINE_GO";
        public static const ONE_KEY_HIDE:String = "ONE_KEY_HIDE";
        public static const PARTY_GO_LINE:String = "PARTY_GO_LINE";
        public static const CHG_LINE_SUC:String = "CHG_LINE_SUC";
        public static const SHOW_CHGLINE:String = "SHOW_CHGLINE";
        public static const UPDATA_SERVER:String = "UPDATA_SERVER";
        public static const CSB_GO_LINE:String = "CSB_GO_LINE";

        public static var flyLineId:int = 0;
        public static var maxServerPerson:uint = 1000;
        public static var chgLineInfo:String;
        public static var isCanChgLine:Boolean = true;
        public static var isChooseLine:Boolean = false;
        public static var isChgLine:Boolean = false;

        public static function getNameByIndex(_arg1:int):String{
            switch (_arg1){
                case 1:
                    return (LanguageMgr.GetTranslation("一线"));
                case 2:
                    return (LanguageMgr.GetTranslation("二线"));
                case 3:
                    return (LanguageMgr.GetTranslation("三线"));
                case 4:
                    return (LanguageMgr.GetTranslation("四线"));
                case 5:
                    return (LanguageMgr.GetTranslation("五线"));
                case 6:
                    return (LanguageMgr.GetTranslation("六线"));
                case 7:
                    return (LanguageMgr.GetTranslation("七线"));
                case 8:
                    return (LanguageMgr.GetTranslation("八线"));
                case 9:
                    return (LanguageMgr.GetTranslation("九线"));
                case 10:
                    return (LanguageMgr.GetTranslation("专线"));
                default:
                    return ("");
            };
        }

    }
}//package GameUI.Modules.ChangeLine.Data 
