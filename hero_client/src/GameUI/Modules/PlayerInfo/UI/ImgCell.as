//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.UI {
    import flash.display.*;
    import OopsEngine.Skill.*;
    import GameUI.View.*;
    import GameUI.View.Components.*;

    public class ImgCell extends UISprite {

        private var iconUrl:int;
        private var icon:Bitmap;
        private var _info:GameSkillBuff;

        public function ImgCell(_arg1:GameSkillBuff, _arg2:Boolean=false){
            this.width = 16;
            this.height = 16;
            this.cacheAsBitmap = true;
            _info = _arg1;
            if (_arg2){
                this.graphics.clear();
                this.graphics.lineStyle(1, 0xFF0000, 1);
                this.graphics.moveTo(-1, -1);
                this.graphics.lineTo(16, -1);
                this.graphics.lineTo(16, 16);
                this.graphics.lineTo(-1, 16);
                this.graphics.lineTo(-1, -1);
                this.graphics.endFill();
            };
            this.iconUrl = _info.TypeID;
            this.name = ("buffIcon_" + _info.BuffID);
            this.mouseEnabled = true;
            init();
        }
        private function init():void{
            ResourcesFactory.getInstance().getResource(((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/BuffIcon/") + iconUrl) + ".png?v=") + GameConfigData.SkillVersion), loadComplete);
        }
        public function get info():GameSkillBuff{
            return (_info);
        }
        private function loadComplete():void{
            this.icon = ResourcesFactory.getInstance().getBitMapResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/BuffIcon/") + iconUrl) + ".png"));
            if (this.icon == null){
                this.icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("NoResource");
            };
            this.icon.scaleX = 0.5;
            this.icon.scaleY = 0.5;
            this.addChild(this.icon);
        }

    }
}//package GameUI.Modules.PlayerInfo.UI 
