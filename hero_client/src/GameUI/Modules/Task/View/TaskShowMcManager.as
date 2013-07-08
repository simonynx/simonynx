//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import flash.display.*;
    import Manager.*;

    public class TaskShowMcManager {

        public static const TYPE_CANCOMPLETE:String = "TYPE_CANCOMPLETE";
        public static const TYPE_ACCEPTE:String = "TYPE_ACCEPTE";
        public static const TYPE_COMPLETE:String = "typeComplete";

        private static var _instance:TaskShowMcManager;

        private var showMc:MovieClip;

        public static function getInstance():TaskShowMcManager{
            if (!_instance){
                _instance = new (TaskShowMcManager)();
            };
            return (_instance);
        }

        public function show(_arg1:String):void{
            if (((showMc) && (showMc.parent))){
                showMc.parent.removeChild(showMc);
            };
            switch (_arg1){
                case TYPE_CANCOMPLETE:
                    showMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TaskCanCompleteShowMc");
                    break;
                case TYPE_ACCEPTE:
                    SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "taskAccSound");
                    showMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TaskAlAccShowMc");
                    break;
                case TYPE_COMPLETE:
                    SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "completeSound");
                    showMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TaskCompleteShowMc");
                    break;
            };
            showMc.play();
            showMc.x = int((GameCommonData.GameInstance.ScreenWidth / 2));
            showMc.y = 150;
            GameCommonData.GameInstance.GameUI.addChild(showMc);
        }

    }
}//package GameUI.Modules.Task.View 
