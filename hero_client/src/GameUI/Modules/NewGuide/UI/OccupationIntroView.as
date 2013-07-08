//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.UI {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.View.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class OccupationIntroView extends HFrame {

        private const DARK:String = "dark";
        private const LIGHT:String = "light";

        public var OccuList:Dictionary;
        private var content:MovieClip;
        private var _getJobBtn:HLabelButton;

        public function OccupationIntroView(_arg1:MovieClip=null, _arg2:Number=0, _arg3:Number=0){
            initView();
        }
        public function mouseOver(_arg1:MouseEvent):void{
            setLight((_arg1.currentTarget as MovieClip));
        }
        public function mouseClick(_arg1:MovieClip):void{
            var _local2:MovieClip;
            var _local3 = 1;
            while (_local3 < 6) {
                _local2 = (OccuList[_local3] as MovieClip);
                _local2.click = false;
                setLight(_local2, false);
                _local3++;
            };
            setLight(_arg1);
            _arg1.click = true;
        }
        public function reset():void{
            var _local1:String;
            for (_local1 in OccuList) {
                setLight(OccuList[_local1], false);
                OccuList[_local1].click = false;
            };
        }
        public function mouseOut(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            if (_local2.click){
                return;
            };
            setLight(_local2, false);
        }
        public function set introTxt(_arg1:String):void{
            if (_arg1 == null){
                return;
            };
            content.txt.htmlText = _arg1;
        }
        public function get randomBtn():SimpleButton{
            return ((content["randomBtn"] as SimpleButton));
        }
        public function setLight(_arg1:MovieClip, _arg2:Boolean=true):void{
            _arg1[DARK].visible = !(_arg2);
            _arg1[LIGHT].alpha = (_arg2) ? 1 : 0;
        }
        private function initView():void{
            var _local1:MovieClip;
            var _local2:String;
            var _local3:Bitmap;
            var _local4:int;
            centerTitle = true;
            blackGound = false;
            titleText = LanguageMgr.GetTranslation("职业介绍");
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("OccupationIntroView");
            OccuList = new Dictionary();
            _local4 = 1;
            while (_local4 < 6) {
                _local1 = (content[("occu_" + _local4)] as MovieClip);
                _local1.mouseChildren = false;
                setLight(_local1, false);
                _local1.click = false;
                OccuList[_local4] = _local1;
                _local2 = String(((_local4 * 1000) + GameCommonData.Player.Role.Sex));
                ResourcesFactory.getInstance().getResource((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/OccupationIntro/") + _local2) + ".swf"), onLoabdComplete);
                _local4++;
            };
            content.x = -4;
            content.y = 22;
            content.txt.text = "";
            addContent(content);
            _getJobBtn = new HLabelButton();
            _getJobBtn.label = (LanguageMgr.GetTranslation("成为") + LanguageMgr.JobNameList[1]);
            _getJobBtn.x = 545;
            _getJobBtn.y = 393;
            content.addChild(_getJobBtn);
            setSize(675, 460);
        }
        private function onLoabdComplete():void{
            var _local1:MovieClip;
            var _local2:MovieClip;
            var _local3:String;
            var _local4 = 1;
            while (_local4 < 6) {
                _local1 = (OccuList[_local4] as MovieClip);
                _local3 = String(((_local4 * 1000) + GameCommonData.Player.Role.Sex));
                _local2 = ResourcesFactory.getInstance().getswfResourceByUrl((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/OccupationIntro/") + _local3) + ".swf"));
                if (_local2){
                    _local1["container"].addChild(_local2);
                };
                _local4++;
            };
        }
        public function get getJobBtn():HLabelButton{
            return (_getJobBtn);
        }
        public function set getJobBtnLabel(_arg1:int):void{
            _getJobBtn.label = (LanguageMgr.GetTranslation("成为") + LanguageMgr.JobNameList[_arg1]);
        }

    }
}//package GameUI.Modules.NewGuide.UI 
