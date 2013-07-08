//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GuildFight.View {
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.BaseUI.*;

    public class GuildFightHelpView extends HFrame {

        private var contentTF:TextField;

        public function GuildFightHelpView(){
            initView();
        }
        private function initView():void{
            var _local1:MovieClip;
            setSize(550, 300);
            titleText = LanguageMgr.GetTranslation("城战规则说明");
            centerTitle = true;
            _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GuildFightHelpAsset");
            _local1.x = 10;
            _local1.y = 30;
            addContent(_local1);
        }

    }
}//package GameUI.Modules.GuildFight.View 
