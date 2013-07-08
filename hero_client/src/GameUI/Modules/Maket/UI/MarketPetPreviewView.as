//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.UI {
    import flash.display.*;
    import OopsFramework.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import OopsEngine.AI.PathFinder.*;

    public class MarketPetPreviewView extends Sprite {

        private static const FrameRate:int = 8;

        private var gameScene:GameScene;
        private var timeId:int;
        private var previewLayer:GameSceneLayer;
        private var bgView:MovieClip;
        private var _info:ShopItemInfo;
        private var pet:GameElementPet;

        public function MarketPetPreviewView(){
            initView();
            addEvents();
        }
        public function set info(_arg1:ShopItemInfo):void{
            _info = _arg1;
            if (ItemConst.IsPet((_info as ItemTemplateInfo))){
                updateView();
            };
        }
        private function showAttack():void{
            trace("方向", pet.Role.Direction);
            pet.SetAction(GameElementSkins.ACTION_NEAR_ATTACK, pet.Role.Direction);
            pet.skins.FrameRate = FrameRate;
            var _local1:int;
            switch (pet.Role.Direction){
                case 1:
                    _local1 = 2;
                    break;
                case 2:
                    _local1 = 3;
                    break;
                case 3:
                    _local1 = 6;
                    break;
                case 4:
                    _local1 = 1;
                    break;
                case 5:
                    _local1 = 0;
                    break;
                case 6:
                    _local1 = 9;
                    break;
                case 7:
                    _local1 = 4;
                    break;
                case 8:
                    _local1 = 7;
                    break;
                case 9:
                    _local1 = 8;
                    break;
            };
            if (pet.Role.Direction > 9){
                _local1 = 0;
            };
            pet.Role.Direction = _local1;
            timeId = setTimeout(startShow, 2000);
        }
        private function onPetPreviewBGComplete():void{
            if (bgView != null){
                bgView.addChild(ResourcesFactory.getInstance().getBitMapResourceByUrl((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/petpreview.jpg")));
            };
        }
        public function setAttribute():void{
            bgView["att_0"].text = info.HpBonus;
            bgView["att_1"].text = info.MpBonus;
            bgView["att_2"].text = info.Attack;
            bgView["att_3"].text = info.Defence;
            bgView["att_4"].text = info.NormalHit;
            bgView["att_5"].text = info.NormalDodge;
            bgView["att_6"].text = (Number(info.CriticalRate).toFixed(1) + "%");
            bgView["att_7"].text = (Number(info.CriticalDamage).toFixed(1) + "%");
        }
        private function createPetAvatar():void{
            pet = new GameElementPet(GameCommonData.GameInstance);
            pet.SetParentScene(gameScene);
            var _local1:GameRole = new GameRole();
            _local1.Id = 0;
            _local1.Type = GameRole.TYPE_PET;
            _local1.MonsterTypeID = info.AdditionFields[0];
            _local1.CurrentPlayer = pet;
            _local1.Name = info.Name;
            _local1.HP = 1;
            _local1.MaxHp = 1;
            _local1.Direction = 1;
            pet.Role = _local1;
            GameCommonData.Scene.configObject(pet);
            pet.SetMoveSpend(2);
            pet.skins.staticFrameRate = FrameRate;
            pet.skins.FrameRate = FrameRate;
            previewLayer.Elements.Add(pet);
            pet.X = 95;
            pet.Y = 165;
            var _local2:Point = MapTileModel.GetTileStageToPoint((pet.X + pet.ExcursionX), (pet.Y + pet.ExcursionY));
            _local1.TileX = _local2.x;
            _local1.TileY = _local2.y;
            pet.HideName();
            pet.hideGuildName();
            pet.HideTitle();
            pet.setBloodViewVisble(false);
            pet.Skins.IsEffect(false);
            pet.Visible = true;
            pet.Enabled = true;
        }
        public function dispose():void{
            if (parent){
                parent.removeChild(this);
            };
            _info = null;
            if (previewLayer){
                previewLayer.Dispose();
                previewLayer = null;
            };
            if (gameScene){
                gameScene.Dispose();
                gameScene = null;
            };
            if (pet){
                pet.Dispose();
                pet = null;
            };
            clearTimeout(timeId);
        }
        public function get info():ShopItemInfo{
            return (_info);
        }
        private function initView():void{
            bgView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Market_PetPreviewViewAsset");
            addChild(bgView);
            ResourcesFactory.getInstance().getResource((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/petpreview.jpg"), onPetPreviewBGComplete);
            this.mouseEnabled = false;
            this.mouseChildren = false;
            previewLayer = new GameSceneLayer();
            previewLayer.name = "MarketPetPreviewLayer";
            addChild(previewLayer);
            gameScene = new GameScene(GameCommonData.GameInstance);
            gameScene.name = "MarketPetPreviewGameScene";
            var _local1:int;
            while (_local1 < 8) {
                bgView[("att_" + _local1)].mouseEnabled = false;
                bgView[("att_" + _local1)].text = "";
                _local1++;
            };
        }
        public function updateTime(_arg1:GameTime):void{
            if (previewLayer){
                previewLayer.Update(_arg1);
            };
        }
        private function startShow():void{
            pet.SetAction(GameElementSkins.ACTION_RUN, pet.Role.Direction);
            pet.skins.FrameRate = FrameRate;
            timeId = setTimeout(showAttack, 2000);
        }
        private function addEvents():void{
        }
        private function updateView():void{
            clearTimeout(timeId);
            previewLayer.ClearElement();
            createPetAvatar();
            setAttribute();
            startShow();
        }

    }
}//package GameUI.Modules.Maket.UI 
