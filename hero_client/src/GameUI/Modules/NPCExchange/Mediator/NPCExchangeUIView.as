//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCExchange.Mediator {
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class NPCExchangeUIView extends HFrame {

        private var contentSprite:Sprite;
        public var content:MovieClip;
        public var btnExchange:HLabelButton;

        public function NPCExchangeUIView(_arg1:String){
            initView(_arg1);
        }
        private function initView(_arg1:String):void{
            centerTitle = true;
            blackGound = false;
            titleActive = true;
            titleText = _arg1;
            x = (UIConstData.DefaultPos1.x + 84);
            y = UIConstData.DefaultPos1.y;
            contentSprite = new Sprite();
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("NPCExchange");
            content.x = 10;
            content.y = 32;
            contentSprite.addChild(content);
            setSize(250, 416);
            btnExchange = new HLabelButton();
            btnExchange.label = LanguageMgr.GetTranslation("兑换");
            btnExchange.name = "btnExchange";
            btnExchange.x = 185;
            btnExchange.y = 378;
            contentSprite.addChild(btnExchange);
            addContent(contentSprite);
        }

    }
}//package GameUI.Modules.NPCExchange.Mediator 
