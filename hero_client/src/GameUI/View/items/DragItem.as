//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.items {
    import flash.display.*;
    import OopsFramework.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import Utils.*;
    import OopsEngine.Graphics.*;

    public class DragItem extends Sprite {

        private const WIDTH:int = 100;
        private const TXTHEIGHT:int = 16;

        public var OwnerTime:uint;
        private var tf:TextField;
        private var _data:int;
        public var TileX;
        public var TileY;
        public var isMagicEquip:Boolean;
        private var mkDir:String = "smallIcon";
        public var isPicked;
        public var OwnerGUID:uint;
        private var _len:int;
        public var ID:int;
        private var _info:ItemTemplateInfo;
        private var temporaryIcon:Sprite;
        private var tip:Sprite;
        private var icon:Bitmap;

        public function DragItem(){
            init();
        }
        public function updateTime(_arg1:GameTime):void{
            var _local2:Number = (TimeManager.Instance.Now().time * 0.001);
            if (_local2 > OwnerTime){
                tf.text = info.Name;
                OwnerGUID = 0;
            };
        }
        public function hideTip():void{
            if (tip.parent){
                tip.parent.removeChild(tip);
            };
            if (temporaryIcon){
                if (temporaryIcon.parent){
                    this.removeChild(temporaryIcon);
                };
                temporaryIcon = null;
            };
            if (this.icon != null){
                if (this.icon.parent){
                    this.removeChild(icon);
                };
                if (icon.bitmapData != null){
                    icon.bitmapData.dispose();
                };
                this.icon = null;
            };
        }
        private function init():void{
            temporaryIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("McPackage");
            temporaryIcon.mouseEnabled = false;
            if (temporaryIcon){
                this.addChild(temporaryIcon);
            };
            tip = new Sprite();
            tip.mouseEnabled = false;
            tip.mouseChildren = false;
            tf = new TextField();
            tf.cacheAsBitmap = true;
            tf.filters = OopsEngine.Graphics.Font.Stroke(0);
            tf.selectable = false;
            tf.width = WIDTH;
            tf.height = TXTHEIGHT;
            tf.defaultTextFormat = UIUtils.getTextFormat(12, 0xFFFFFF, TextFormatAlign.LEFT);
            tip.addChild(tf);
        }
        public function get Data():int{
            return (_data);
        }
        private function onLoabdComplete():void{
            icon = ResourcesFactory.getInstance().getBitMapResourceByUrl((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + info.dropIconId) + ".png"));
            if (this.icon != null){
                if (temporaryIcon){
                    if (temporaryIcon.parent){
                        this.removeChild(temporaryIcon);
                    };
                    temporaryIcon = null;
                };
                this.addChild(icon);
            };
        }
        public function set Data(_arg1:int):void{
            _data = _arg1;
            info = UIConstData.ItemDic[_data];
            if (info){
                if (((!((OwnerGUID == 0))) && (!((OwnerGUID == GameCommonData.Player.Role.Id))))){
                    tf.htmlText = (((("<font color='" + "#FF0000") + "'>") + info.Name) + "</font>");
                } else {
                    tf.text = info.Name;
                };
                _len = info.Name.length;
            } else {
                tf.text = LanguageMgr.GetTranslation("未知物品");
                _len = 6;
            };
            loadIcon();
        }
        public function set info(_arg1:ItemTemplateInfo):void{
            _info = _arg1;
        }
        public function showTip():void{
            tip.y = (this.y - 20);
            tip.x = (this.x - (_len * 4));
            try {
                GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.addChild(tip);
            } catch(e:Error) {
                trace(GameCommonData.GameInstance.GameScene);
            };
        }
        public function get info():ItemTemplateInfo{
            return (_info);
        }
        private function loadIcon():void{
            ResourcesFactory.getInstance().getResource(((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + info.dropIconId) + ".png?v=") + GameConfigData.ItemIconVersion), onLoabdComplete);
        }

    }
}//package GameUI.View.items 
