//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Map.SenceMap {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class SceneMapView extends HFrame {

        private var contentSprite:Sprite;
        public var btnTran:HLabelButton;
        public var content:MovieClip;

        public function SceneMapView(){
            initView();
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("地   图");
            centerTitle = true;
            blackGound = false;
            showClose = true;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SenceMapContainer");
            content.x = 4;
            content.y = 28;
            contentSprite.addChild(content);
            content.bg_back0.width = 561;
            content.bg_back0.height = 454;
            content.bg_back1.x = 559;
            content.bg_back1.height = 454;
            setSize(720, 510);
            btnTran = new HLabelButton();
            btnTran.label = LanguageMgr.GetTranslation("空格传送");
            btnTran.name = "btnTran";
            btnTran.x = 620;
            btnTran.y = 30;
            btnTran.width = 52;
            btnTran.height = 22;
            var _local1:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("fx");
            btnTran.addIcon(_local1);
            contentSprite.addChild(btnTran);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.Map.SenceMap 
