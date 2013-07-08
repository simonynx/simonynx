//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ToolTip.Mediator.UI {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Skill.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import flash.filters.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.*;

    public class SkillItemTip implements IToolTip {

        private const LINE_HEIGHT:int = 12;
        private const TIP_WIDTH:int = 160;

        private var _container:Sprite;
        private var _buffInfo:GameSkillBuff;
        private var _guildSkillInfo:GuildSkillInfo;
        private var titleNum:int;
        private var format1:TextFormat;
        private var format2:TextFormat;
        private var format3:TextFormat;
        private var format4:TextFormat;
        private var _skillInfo:SkillInfo;
        private var tip_top:MovieClip;
        private var isShowBuff:Boolean;
        private var isShowGuildSkill:Boolean;
        private var isShowSkill:Boolean;
        private var tip_bottom:MovieClip;
        private var lines:uint;
        private var tipContent:MovieClip;
        private var defaultFilters:Array;

        public function SkillItemTip(_arg1:Sprite, _arg2){
            _container = _arg1;
            if ((_arg2 is GameSkillBuff)){
                _buffInfo = _arg2;
                isShowBuff = true;
            } else {
                if ((_arg2 is GuildSkillInfo)){
                    _guildSkillInfo = _arg2;
                    isShowGuildSkill = true;
                } else {
                    if ((_arg2 is SkillInfo)){
                        _skillInfo = _arg2;
                        isShowSkill = true;
                    };
                };
            };
            format1 = new TextFormat();
            format1.size = 14;
            format1.font = LanguageMgr.DEFAULT_FONT;
            format2 = new TextFormat();
            format2.size = 13;
            format2.font = LanguageMgr.DEFAULT_FONT;
            format3 = new TextFormat();
            format3.size = 15;
            format3.font = LanguageMgr.DEFAULT_FONT;
            format4 = new TextFormat();
            format4.size = 16;
            format4.font = LanguageMgr.DEFAULT_FONT;
            var _local3:GlowFilter = new GlowFilter(0, 1, 2, 2, 16);
            defaultFilters = new Array();
            defaultFilters.push(_local3);
            tipContent = new MovieClip();
            lines = 0;
        }
        private function setBuffTip():void{
            addTF(tipContent, format4, 15185931, false, _buffInfo.BuffName);
            addTF(tipContent, format2, 0xFFFFFF, true, _buffInfo.BuffEffect, 0, 30);
        }
        private function setSkillTip():void{
            var _local1:Boolean;
            var _local2:Boolean;
            var _local3:int;
            if (_skillInfo.Level < (_skillInfo.MaxLevel - 1)){
                _local2 = true;
            };
            if (SkillManager.getMyIdSkillInfo(_skillInfo.Id)){
                _local1 = true;
            };
            addTF(tipContent, format4, 15185931, false, _skillInfo.Name);
            addTF(tipContent, format1, 0xFFFF, false, ((_skillInfo.Type)==2) ? LanguageMgr.GetTranslation("被动") : LanguageMgr.GetTranslation("主动"), 100, 10);
            if (_skillInfo.Job < 6){
                if (_local1){
                    if (_local2){
                        addTF(tipContent, format2, 16315658, false, ((_skillInfo.Level + "/") + (_skillInfo.MaxLevel - 1)), 0, 30);
                        addTF(tipContent, format2, 0xFFFFFF, true, _skillInfo.description, 0, 45);
                        addTF(tipContent, format2, 10789343, false, LanguageMgr.GetTranslation("下一等级"), 0, 55);
                        addTF(tipContent, format2, 0xFF0000, false, ((LanguageMgr.GetTranslation("所需等级") + ":") + GameCommonData.SkillList[(_skillInfo.Id + 1)].NeedLevel), 0, 70);
                        _local3 = GameCommonData.SkillList[(_skillInfo.Id + 1)].PreSkillId;
                        if (_local3 > 0){
                            addTF(tipContent, format2, 0xFF0000, false, ((((((LanguageMgr.GetTranslation("需要学会") + ":") + GameCommonData.SkillList[_local3].Name) + "[") + GameCommonData.SkillList[_local3].Level) + LanguageMgr.GetTranslation("级")) + "]"), 0, 85);
                            addTF(tipContent, format2, 0xFFFFFF, true, GameCommonData.SkillList[(_skillInfo.Id + 1)].description, 0, 100);
                        } else {
                            addTF(tipContent, format2, 0xFFFFFF, true, GameCommonData.SkillList[(_skillInfo.Id + 1)].description, 0, 85);
                        };
                    } else {
                        addTF(tipContent, format2, 16315658, false, ((_skillInfo.Level + "/") + (_skillInfo.MaxLevel - 1)), 0, 30);
                        addTF(tipContent, format2, 0xFFFFFF, true, _skillInfo.description, 0, 45);
                    };
                } else {
                    addTF(tipContent, format2, 16315658, false, (("0" + "/") + (_skillInfo.MaxLevel - 1)), 0, 30);
                    addTF(tipContent, format2, 10789343, false, LanguageMgr.GetTranslation("下一等级"), 0, 45);
                    addTF(tipContent, format2, 0xFF0000, false, ((LanguageMgr.GetTranslation("所需等级") + ":") + _skillInfo.NeedLevel), 0, 60);
                    _local3 = GameCommonData.SkillList[_skillInfo.Id].PreSkillId;
                    if (_local3 > 0){
                        addTF(tipContent, format2, 0xFF0000, false, ((((((LanguageMgr.GetTranslation("需要学会") + ":") + GameCommonData.SkillList[_local3].Name) + "[") + GameCommonData.SkillList[_local3].Level) + LanguageMgr.GetTranslation("级")) + "]"), 0, 75);
                        addTF(tipContent, format2, 0xFFFFFF, true, GameCommonData.SkillList[_skillInfo.Id].description, 0, 90);
                    } else {
                        addTF(tipContent, format2, 0xFFFFFF, true, _skillInfo.description, 0, 75);
                    };
                };
            };
            if (_skillInfo.Job == 6){
                if (_local2){
                    addTF(tipContent, format2, 16315658, false, ((_skillInfo.Level + "/") + (_skillInfo.MaxLevel - 1)), 0, 30);
                    addTF(tipContent, format2, 0xFFFFFF, true, _skillInfo.description, 0, 45);
                    addTF(tipContent, format2, 10789343, false, LanguageMgr.GetTranslation("下一等级"), 0, 55);
                    addTF(tipContent, format2, 0xFFFFFF, true, GameCommonData.SkillList[(_skillInfo.Id + 1)].description, 0, 70);
                } else {
                    addTF(tipContent, format2, 16315658, false, ((_skillInfo.Level + "/") + (_skillInfo.MaxLevel - 1)), 0, 30);
                    addTF(tipContent, format2, 0xFFFFFF, true, _skillInfo.description, 0, 45);
                };
            };
            if (_skillInfo.Job == 8){
                if (_local2){
                    addTF(tipContent, format2, 16315658, false, ((_skillInfo.Level + "/") + _skillInfo.MaxLevel), 0, 30);
                    addTF(tipContent, format2, 0xFFFFFF, true, _skillInfo.description, 0, 45);
                    addTF(tipContent, format2, 10789343, false, LanguageMgr.GetTranslation("下一等级"), 0, 55);
                    addTF(tipContent, format2, 0xFFFFFF, true, GameCommonData.SkillList[(_skillInfo.Id + 1)].description, 0, 70);
                } else {
                    addTF(tipContent, format2, 16315658, false, ((_skillInfo.Level + "/") + _skillInfo.MaxLevel), 0, 30);
                    addTF(tipContent, format2, 0xFFFFFF, true, _skillInfo.description, 0, 45);
                };
            };
            if ((((_skillInfo.Job == 9)) || ((_skillInfo.Job == 11)))){
                addTF(tipContent, format2, 16315658, false, ((_skillInfo.Level + "/") + _skillInfo.MaxLevel), 0, 30);
                addTF(tipContent, format2, 0xFFFFFF, true, _skillInfo.description, 0, 45);
            };
        }
        public function GetType():String{
            return ("SkillItemTip");
        }
        public function BackWidth():Number{
            return (0);
        }
        public function Show():void{
            var _local1:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToolTip");
            _container.addChild(_local1);
            _local1.width = TIP_WIDTH;
            if (isShowBuff){
                setBuffTip();
            } else {
                if (isShowSkill){
                    setSkillTip();
                } else {
                    if (isShowGuildSkill){
                        setGuildSkillTip();
                    };
                };
            };
            _local1.height = (((lines * LINE_HEIGHT) + (titleNum * 9)) + 58);
            upDatePos();
            _container.addChild(tipContent);
        }
        private function upDatePos():void{
            var _local1:DisplayObject;
            var _local2:* = 0;
            var _local3:Number = 0;
            while (_local2 < _container.numChildren) {
                _local1 = _container.getChildAt(_local2);
                _local1.y = int(_local3);
                _local3 = (_local3 + _local1.height);
                _local2++;
            };
        }
        public function Remove():void{
            var _local1:int = (_container.numChildren - 1);
            while (_local1 >= 0) {
                _container.removeChildAt(_local1);
                _local1--;
            };
            _container = null;
        }
        private function addTF(_arg1:Sprite, _arg2:TextFormat, _arg3:uint, _arg4:Boolean, _arg5:String, _arg6:uint=0, _arg7:uint=8):void{
            var _local8:TextField;
            _local8 = new TextField();
            _local8.width = 150;
            _local8.wordWrap = true;
            _local8.multiline = true;
            _local8.autoSize = TextFieldAutoSize.LEFT;
            _local8.text = _arg5;
            _local8.textColor = _arg3;
            _local8.setTextFormat(_arg2);
            _local8.cacheAsBitmap = true;
            _local8.x = (8 + _arg6);
            _local8.y = (_arg7 + (lines * LINE_HEIGHT));
            _local8.filters = defaultFilters;
            _arg1.addChild(_local8);
            titleNum++;
            if (_arg4){
                lines = (lines + _local8.numLines);
            };
        }
        private function setGuildSkillTip():void{
            addTF(tipContent, format2, 15185931, true, _guildSkillInfo.Name, 0, 10);
            addTF(tipContent, format2, 15185931, true, ((LanguageMgr.GetTranslation("当前等级") + "):") + _guildSkillInfo.Level), 0, 30);
            addTF(tipContent, format2, 0xFFFFFF, true, ((LanguageMgr.GetTranslation("效果") + ":") + _guildSkillInfo.description), 0, 40);
            var _local1:GuildSkillInfo = GuildSkillManager.getInstance().getNextGuildSkill(_guildSkillInfo.Id);
            if (_local1){
                addTF(tipContent, format2, 15185931, true, LanguageMgr.GetTranslation("下一等级需要"), 0, 60);
                addTF(tipContent, format2, 0xFFFFFF, true, ((LanguageMgr.GetTranslation("公会等级") + ":") + _local1.NeedLevel), 0, 70);
                addTF(tipContent, format2, 0xFFFFFF, true, ((LanguageMgr.GetTranslation("建设值") + ":") + _local1.NeedOffer), 0, 80);
                addTF(tipContent, format2, 0xFFFFFF, true, ((LanguageMgr.GetTranslation("效果") + ":") + _local1.description), 0, 90);
            };
        }
        public function Update(_arg1:Object):void{
        }

    }
}//package GameUI.Modules.ToolTip.Mediator.UI 
