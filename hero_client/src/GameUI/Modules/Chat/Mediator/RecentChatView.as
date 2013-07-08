//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.Mediator {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class RecentChatView extends HFrame {

        private static const textformat:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFF00, null, null, null, null, null, TextFormatAlign.CENTER);

        public var content:MovieClip;
        private var contentSprite:Sprite;

        public function RecentChatView(){
            initView();
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("最近联系人");
            centerTitle = true;
            blackGound = false;
            showClose = true;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RecentContact");
            content.x = 20;
            content.y = 40;
            contentSprite.addChild(content);
            setSize((249 + 40), (53 + 50));
            content["txtInputName"] = new TextField();
            content["txtInputName"].type = TextFieldType.INPUT;
            content["txtInputName"].defaultTextFormat = textformat;
            content["txtInputName"].x = 59;
            content["txtInputName"].y = 2;
            content["txtInputName"].width = 100;
            content["txtInputName"].height = 16;
            content["txtInputName"].maxChars = 8;
            content.addChild(content["txtInputName"]);
            var _local1:HLabelButton = new HLabelButton();
            _local1.label = LanguageMgr.GetTranslation("最近联系人");
            _local1.x = 171;
            _local1.y = 0;
            _local1.name = "_btnRecent";
            content.addChild(_local1);
            var _local2:HLabelButton = new HLabelButton();
            _local2.label = LanguageMgr.GetTranslation("确定");
            _local2.x = 70;
            _local2.y = 30;
            _local2.name = "_btnInputSure";
            content.addChild(_local2);
            var _local3:HLabelButton = new HLabelButton();
            _local3.label = LanguageMgr.GetTranslation("取消");
            _local3.name = "_btnInputCancel";
            _local3.x = 140;
            _local3.y = 30;
            content.addChild(_local3);
            x = ((GameCommonData.GameInstance.ScreenWidth / 2) - (content.width / 2));
            y = ((GameCommonData.GameInstance.ScreenHeight / 2) - (content.height / 2));
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Chat.Mediator 
