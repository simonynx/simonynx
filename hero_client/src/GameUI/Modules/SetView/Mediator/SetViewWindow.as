//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.SetView.Mediator {
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class SetViewWindow extends HFrame {

        public var page_0:MovieClip;
        public var refusedEffect:HCheckBox;
        private var bg:Sprite;
        public var page_1:MovieClip;
        public var refusedSelfBloodHcb:HCheckBox;
        public var musicSlide:HSlider;
        private var quickKeyHelpMc:Sprite;
        public var defaultBtn:HLabelButton;
        public var refusedPkHcb:HCheckBox;
        public var saveBtn:HLabelButton;
        public var shieldPlayerTitleHcb:HCheckBox;
        public var shieldGuildNameHcb:HCheckBox;
        public var musicHcb:HCheckBox;
        public var closeFun:Function;
        private var currentPage:int;
        public var soundSlide:HSlider;
        public var refusedOtherBloodHcb:HCheckBox;
        private var mainMc:Sprite;
        public var refusedBusinessHcb:HCheckBox;
        public var refusedTeamInvateHcb:HCheckBox;
        public var soundHcb:HCheckBox;

        public function SetViewWindow(){
            initView();
        }
        public function get page():int{
            return (currentPage);
        }
        private function initView():void{
            blackGound = false;
            bg = (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SettingViewAsset") as Sprite);
            titleText = LanguageMgr.GetTranslation("系统设置");
            centerTitle = true;
            mainMc = bg["mainMc"];
            quickKeyHelpMc = bg["quickKeyHelpMc"];
            page_0 = bg["page_0"];
            page_1 = bg["page_1"];
            bg["textpage_0"].mouseEnabled = false;
            bg["textpage_1"].mouseEnabled = false;
            defaultBtn = new HLabelButton();
            defaultBtn.label = LanguageMgr.GetTranslation("恢复默认");
            defaultBtn.x = 12;
            defaultBtn.y = 200;
            mainMc.addChild(defaultBtn);
            saveBtn = new HLabelButton();
            saveBtn.label = LanguageMgr.GetTranslation("保存设置");
            saveBtn.x = 95;
            saveBtn.y = 200;
            mainMc.addChild(saveBtn);
            musicHcb = new HCheckBox(LanguageMgr.GetTranslation("开启背景音乐"));
            musicHcb.fireAuto = true;
            musicHcb.x = 203;
            musicHcb.y = 59;
            mainMc.addChild(musicHcb);
            soundHcb = new HCheckBox(LanguageMgr.GetTranslation("开启游戏音效"));
            soundHcb.fireAuto = true;
            soundHcb.x = 203;
            soundHcb.y = 135;
            mainMc.addChild(soundHcb);
            refusedSelfBloodHcb = new HCheckBox(LanguageMgr.GetTranslation("屏蔽自己血条"));
            refusedSelfBloodHcb.fireAuto = true;
            refusedSelfBloodHcb.x = 18;
            refusedSelfBloodHcb.y = 40;
            mainMc.addChild(refusedSelfBloodHcb);
            refusedOtherBloodHcb = new HCheckBox(LanguageMgr.GetTranslation("屏蔽其它玩家血条"));
            refusedOtherBloodHcb.fireAuto = true;
            refusedOtherBloodHcb.x = 18;
            refusedOtherBloodHcb.y = 62;
            mainMc.addChild(refusedOtherBloodHcb);
            refusedTeamInvateHcb = new HCheckBox(LanguageMgr.GetTranslation("拒绝组队"));
            refusedTeamInvateHcb.fireAuto = true;
            refusedTeamInvateHcb.x = 18;
            refusedTeamInvateHcb.y = 84;
            mainMc.addChild(refusedTeamInvateHcb);
            refusedBusinessHcb = new HCheckBox(LanguageMgr.GetTranslation("拒绝交易"));
            refusedBusinessHcb.fireAuto = true;
            refusedBusinessHcb.x = 18;
            refusedBusinessHcb.y = 106;
            mainMc.addChild(refusedBusinessHcb);
            refusedPkHcb = new HCheckBox(LanguageMgr.GetTranslation("拒绝切磋"));
            refusedPkHcb.fireAuto = true;
            refusedPkHcb.x = 18;
            refusedPkHcb.y = 128;
            refusedEffect = new HCheckBox(LanguageMgr.GetTranslation("屏蔽战斗特效"));
            refusedEffect.fireAuto = true;
            refusedEffect.x = 18;
            refusedEffect.y = 128;
            mainMc.addChild(refusedEffect);
            shieldGuildNameHcb = new HCheckBox(LanguageMgr.GetTranslation("屏蔽公会名称"));
            shieldGuildNameHcb.fireAuto = true;
            shieldGuildNameHcb.x = 18;
            shieldGuildNameHcb.y = 150;
            mainMc.addChild(shieldGuildNameHcb);
            shieldPlayerTitleHcb = new HCheckBox(LanguageMgr.GetTranslation("屏蔽玩家称号"));
            shieldPlayerTitleHcb.fireAuto = true;
            shieldPlayerTitleHcb.x = 18;
            shieldPlayerTitleHcb.y = 172;
            mainMc.addChild(shieldPlayerTitleHcb);
            this.musicSlide = new HSlider();
            this.musicSlide.x = 223;
            this.musicSlide.y = 90;
            this.musicSlide.maximum = 100;
            mainMc.addChild(this.musicSlide);
            this.soundSlide = new HSlider();
            this.soundSlide.x = 223;
            this.soundSlide.y = 170;
            this.soundSlide.maximum = 100;
            mainMc.addChild(this.soundSlide);
            setSize(388, 290);
            bg.x = 4;
            bg.y = 35;
            addContent(bg);
        }
        public function set page(_arg1:int):void{
            if (_arg1 == 0){
                currentPage = 0;
                page_0.buttonMode = false;
                page_1.buttonMode = true;
                page_0.gotoAndStop(1);
                page_1.gotoAndStop(2);
                bg["textpage_0"].textColor = 16496146;
                bg["textpage_1"].textColor = 250597;
                mainMc.visible = true;
                quickKeyHelpMc.visible = false;
            } else {
                if (_arg1 == 1){
                    currentPage = 1;
                    page_0.buttonMode = true;
                    page_1.buttonMode = false;
                    page_0.gotoAndStop(2);
                    page_1.gotoAndStop(1);
                    bg["textpage_0"].textColor = 250597;
                    bg["textpage_1"].textColor = 16496146;
                    mainMc.visible = false;
                    quickKeyHelpMc.visible = true;
                };
            };
        }
        override public function close():void{
            super.close();
        }

    }
}//package GameUI.Modules.SetView.Mediator 
