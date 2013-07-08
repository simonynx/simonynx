//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Mediator {
    import flash.display.*;
    import GameUI.View.BaseUI.*;

    public class ContactListView extends HFrame {

        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function ContactListView(){
            initView();
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("聊天对象");
            centerTitle = true;
            blackGound = false;
            showClose = true;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ContactList");
            content.x = 7;
            content.y = 32;
            contentSprite.addChild(content);
            setSize((content.width + 8), (content.height + 36));
            x = (((GameCommonData.GameInstance.ScreenWidth / 2) - (content.width / 2)) + 220);
            y = (((GameCommonData.GameInstance.ScreenHeight / 2) - (content.height / 2)) + 72);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Chat.Mediator 
