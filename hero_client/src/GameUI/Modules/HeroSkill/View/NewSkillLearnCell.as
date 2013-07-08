//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.HeroSkill.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.View.*;
    import Net.RequestSend.*;
    import OopsEngine.Graphics.*;

    public class NewSkillLearnCell extends NewSkillCell {

        private var _addPointMc:SimpleButton;
        private var _levelText:TextField;
        private var _format:TextFormat;

        public function NewSkillLearnCell(_arg1:int, _arg2:int, _arg3:int){
            init();
            initEvent();
            super(_arg1, _arg2, _arg3);
        }
        override protected function onLoabdComplete():void{
            super.onLoabdComplete();
            setOhterView();
            setData(_job, _layer);
        }
        private function checkSkillLevel():Boolean{
            var _local1:SkillInfo;
            var _local2:SkillInfo;
            if (((!((SkillManager.getIdSkillInfo((_skillInfo.Id + 1)) == null))) && (this.isLearn))){
                _local1 = SkillManager.getIdSkillInfo((_skillInfo.Id + 1));
            } else {
                _local1 = _skillInfo;
            };
            if (GameCommonData.Player.Role.Level >= _local1.NeedLevel){
                if (_local1.PreSkillId == 0){
                    return (true);
                };
                for each (_local2 in SkillManager.MyTotalSkillList) {
                    if (_local2.Id == _local1.PreSkillId){
                        return (true);
                    };
                };
            };
            return (false);
        }
        public function get AddPointMc():SimpleButton{
            return (_addPointMc);
        }
        private function initEvent():void{
            _addPointMc.addEventListener(MouseEvent.CLICK, onAddPoint);
        }
        private function onAddPoint(_arg1:MouseEvent):void{
            SpeciallyEffectController.getInstance().getAddPointEffect().gotoAndPlay(1);
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "addPointSound");
            this.addChildAt(SpeciallyEffectController.getInstance().getAddPointEffect(), 0);
            if (SkillManager.getMyIdSkillInfo(_skillInfo.Id) == null){
                if ((_skillInfo.Id % 10) == 1){
                    PlayerActionSend.AddSkillPoint((_skillInfo.Id - 1));
                    return;
                };
            };
            PlayerActionSend.AddSkillPoint(_skillInfo.Id);
        }
        private function init():void{
            _addPointMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("AddSkillPoint");
            _format = new TextFormat();
            _format.size = 13;
            _format.font = LanguageMgr.DEFAULT_FONT;
            _format.align = TextFormatAlign.CENTER;
            _levelText = new TextField();
            _levelText.textColor = 0xFFFFFF;
            _levelText.defaultTextFormat = _format;
            _levelText.filters = OopsEngine.Graphics.Font.Stroke();
            _levelText.mouseEnabled = false;
            _levelText.autoSize = TextFieldAutoSize.LEFT;
            _levelText.text = "0";
        }
        private function setOhterView():void{
            _addPointMc.x = ((icon.width - _addPointMc.width) + 7);
            _addPointMc.y = ((icon.height - _addPointMc.height) + 7);
            _levelText.x = 0;
            _levelText.y = (_addPointMc.y - 7);
            this.addChild(_levelText);
            this.addChild(_addPointMc);
        }
        override public function setData(_arg1:int, _arg2:int):void{
            var _local3:int;
            super.setData(_arg1, _arg2);
            if (_skillInfo == null){
                return;
            };
            if ((((_arg2 >= 1)) && ((_arg2 <= 3)))){
                _local3 = SkillManager.SkillCurrentPoint[(_arg2 - 1)];
            };
            _levelText.text = "0";
            if (checkSkillLevel() == true){
                if ((((_local3 > 0)) && ((((_skillInfo.IsTop == false)) || ((((this.isLearn == false)) && ((_skillInfo.IsOne == true)))))))){
                    _addPointMc.visible = true;
                } else {
                    _addPointMc.visible = false;
                };
            } else {
                _addPointMc.visible = false;
            };
            if (this.isLearn){
                _skillInfo.isLearn = true;
                _levelText.text = _skillInfo.Level.toString();
                if (icon != null){
                    icon.filters = null;
                };
                if ((parent is MovieClip)){
                    (parent as MovieClip).gotoAndStop(2);
                };
            } else {
                _skillInfo.isLearn = false;
                if (icon != null){
                    icon.filters = [ColorFilters.BlackGoundFilter];
                };
                if ((parent is MovieClip)){
                    (parent as MovieClip).gotoAndStop(1);
                };
            };
        }
        override protected function loadIcon():void{
            super.loadIcon();
            setOhterView();
        }

    }
}//package GameUI.Modules.HeroSkill.View 
