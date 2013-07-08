//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Model {

    public class QuestType {

        public static const MAIN:int = 1;
        public static const LOOP:int = 4;
        public static const ACTIVE:int = 5;
        public static const SIDE:int = 2;
        public static const DAILY:int = 3;

        public static function GetTypeName(_arg1:int):String{
            switch (_arg1){
                case 1:
                    return (LanguageMgr.GetTranslation("主线任务"));
                case 2:
                    return (LanguageMgr.GetTranslation("支线任务"));
                case 3:
                    return (LanguageMgr.GetTranslation("日常任务"));
                case 4:
                    return (LanguageMgr.GetTranslation("职业任务"));
                case 5:
                    return (LanguageMgr.GetTranslation("活动任务"));
            };
            return (LanguageMgr.GetTranslation("末知类型"));
        }

    }
}//package GameUI.Modules.Task.Model 
