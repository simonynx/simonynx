//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Equipment.mediator {
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class EquipView extends HFrame {

        public var content:MovieClip;
        public var btn_commit:HLabelButton;
        public var contentSprite:Sprite;

        public function EquipView(_arg1:int, _arg2:int, _arg3:String, _arg4:String, _arg5:MovieClip=null){
            centerTitle = true;
            titleText = LanguageMgr.GetTranslation("铸 造");
            blackGound = false;
            showClose = true;
            x = _arg1;
            y = _arg2;
            contentSprite = new Sprite();
            if (_arg5 != null){
                content = _arg5;
            } else {
                content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(_arg4);
            };
            content.x = 10;
            content.y = 40;
            contentSprite.addChild(content);
            setSize(580, 376);
            btn_commit = new HLabelButton();
            btn_commit.name = "btn_commit";
            btn_commit.textField.mouseEnabled = false;
            btn_commit.label = _arg3;
            btn_commit.x = 155;
            btn_commit.y = 228;
            contentSprite.addChild(btn_commit);
            addContent(contentSprite);
        }
        public function setView():void{
        }

    }
}//package GameUI.Modules.Equipment.mediator 
