//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.view {
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.BaseUI.*;

    public class PetReNameView extends HConfirmFrame {

        public var txtpetNewname:TextField;
        private var contentSprite:Sprite;

        public function PetReNameView(){
            initView();
            addEvent();
        }
        private function initView():void{
            setSize(208, 152);
            titleText = LanguageMgr.GetTranslation("宠物改名");
            centerTitle = true;
            blackGound = true;
            showCancel = true;
            x = 415;
            y = 153;
            contentSprite = new Sprite();
            var _local1:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("PetRenameViewAsset");
            contentSprite.addChild(_local1);
            txtpetNewname = _local1.txtpetNewname;
            txtpetNewname.maxChars = 6;
            txtpetNewname.text = "";
            okLabel = LanguageMgr.GetTranslation("改名");
            cancelLabel = LanguageMgr.GetTranslation("取消");
            contentSprite.x = 4;
            contentSprite.y = 31;
            addContent(contentSprite);
        }
        private function addEvent():void{
        }

    }
}//package GameUI.Modules.Pet.view 
