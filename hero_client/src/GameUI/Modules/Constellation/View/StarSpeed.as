//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Constellation.View {
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class StarSpeed extends HFrame {

        public var frameArr:Array;
        public var btnArr:Array;
        private var content:Sprite;

        public function StarSpeed(){
            frameArr = [];
            btnArr = [];
            super();
            fuck();
        }
        private function fuck():void{
            var _local1:int;
            var _local2:HLabelButton;
            this.titleText = LanguageMgr.GetTranslation("守护加速");
            this.centerTitle = true;
            this.blackGound = false;
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("starspeed");
            content.x = 8;
            content.y = 32;
            this.addChild(content);
            _local1 = 0;
            while (_local1 < 6) {
                frameArr.push(content[("frame" + _local1)]);
                _local2 = new HLabelButton();
                _local2.label = LanguageMgr.GetTranslation("使用");
                btnArr.push(_local2);
                _local2.x = 388;
                _local2.y = (52 + (56 * _local1));
                this.addChild(_local2);
                _local2.name = ("btn_" + _local1);
                _local1++;
            };
            btnArr[0].label = LanguageMgr.GetTranslation("完成");
            this.setSize(462, 375);
        }

    }
}//package GameUI.Modules.Constellation.View 
