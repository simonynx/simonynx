//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GameTarget.View {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;
    import GameUI.Modules.GameTarget.Command.*;

    public class TargetView extends HFrame {

        private var currentSelectDay:int = -1;
        private var award:Array;
        private var dis:TextField;
        private var help:TextField;
        private var day:Array;
        public var btnArray:Array;
        private var backPicContainer:Sprite;
        private var normalcolor:uint = 16777129;
        private var faceContainer:Sprite;
        private var back:Sprite;
        private var begin:TextField;
        private var getAward:HLabelButton;
        private var select1:Sprite;
        private var select2:Sprite;
        private var limit:TextField;

        public function TargetView(){
            award = [];
            btnArray = [];
            day = ["第一天", "第二天", "第三天", "第四天", "第五天", "第六天", "第七天", "第八天", "第九天", "第十天"];
            super();
            fuckView();
        }
        public function getAwardsUI():Array{
            var _local1:Array = [];
            var _local2:int;
            while (_local2 < faceContainer.numChildren) {
                _local1.push(faceContainer.getChildAt(_local2));
                _local2++;
            };
            return (_local1);
        }
        private function fuckView():void{
            titleText = LanguageMgr.GetTranslation("英雄目标");
            centerTitle = true;
            showClose = true;
            blackGound = false;
            back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TPanelBack");
            this.addChild(back);
            back.x = 7;
            back.y = 30;
            initBtnEvents();
            backPicContainer = back["targetback"]["backPicContainer"];
            UIUtils.initBackPicContainer(backPicContainer, "targetBack");
            select1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TPanelSelect");
            select2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TPanelSelect");
            select1.mouseChildren = false;
            select1.mouseEnabled = false;
            select2.mouseChildren = false;
            select2.mouseEnabled = false;
            dis = new TextField();
            dis.defaultTextFormat = TargetConstants.txfm;
            begin = new TextField();
            begin.defaultTextFormat = TargetConstants.txfm;
            limit = new TextField();
            limit.defaultTextFormat = TargetConstants.txfm;
            this.addChild(dis);
            this.addChild(begin);
            this.addChild(limit);
            dis.x = 280;
            dis.y = 71;
            dis.width = 270;
            dis.multiline = true;
            dis.selectable = false;
            begin.x = 280;
            begin.y = 120;
            begin.width = 270;
            begin.multiline = true;
            begin.selectable = false;
            limit.x = 280;
            limit.y = 168;
            limit.width = 270;
            limit.multiline = true;
            limit.selectable = false;
            faceContainer = new Sprite();
            faceContainer.x = 267;
            faceContainer.y = 221;
            this.addChild(faceContainer);
            getAward = new HLabelButton();
            getAward.label = LanguageMgr.GetTranslation("领取奖励");
            getAward.x = 507;
            getAward.y = 356;
            this.addChild(getAward);
            getAward.enable = false;
            help = back["help"];
            setSize(590, 390);
        }
        public function get awardBtn():HLabelButton{
            return (getAward);
        }
        public function UpdateAllDiscribe(_arg1:String, _arg2:String, _arg3:String, _arg4:String):void{
            dis.text = _arg1;
            var _local5:Array = _arg2.split("||");
            if (_local5.length > 1){
                begin.htmlText = (((("<P ALIGN='LEFT'><FONT FACE='宋体' SIZE='12' COLOR='#FEFE59' LETTERSPACING='0' KERNING='0'>" + _local5[0]) + ";<FONT FACE='宋体' SIZE='12' COLOR='#ff0000' LETTERSPACING='0' KERNING='0'>") + _local5[1]) + "</FONT></P>");
            } else {
                begin.text = _arg2;
                begin.setTextFormat(TargetConstants.txfm);
            };
            limit.text = _arg3;
            help.text = _arg4;
            dis.setTextFormat(TargetConstants.txfm);
            limit.setTextFormat(TargetConstants.txfm);
        }
        private function onClick(_arg1:MouseEvent):void{
            select2.x = -5;
            select2.y = -4;
            _arg1.currentTarget.addChild(select2);
            currentSelectDay = _arg1.currentTarget.name.split("_")[1];
        }
        private function onOver(_arg1:MouseEvent):void{
            select1.x = -5;
            select1.y = -4;
            _arg1.currentTarget.addChild(select1);
        }
        public function updateAwards(_arg1:Array):void{
            var _local4:Sprite;
            var _local5:*;
            var _local6:FaceItem;
            var _local2:Array = [];
            faceContainer.name = "fuckyou";
            while (faceContainer.numChildren > 0) {
                faceContainer.removeChildAt(0);
            };
            var _local3:int;
            while (_local3 < _arg1.length) {
                _local4 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local5 = UIConstData.ItemDic[_arg1[_local3].awardID];
                _local6 = new FaceItem(_local5.img, _local4, "bagIcon", 1, _arg1[_local3].num);
                _local6.Num = _arg1[_local3].num;
                _local6.mouseChildren = false;
                _local6.mouseEnabled = false;
                _local4.x = (_local3 * 40);
                _local4.addChild(_local6);
                faceContainer.addChild(_local4);
                _local4.name = ("target_" + _arg1[_local3].awardID);
                _local2.push(_local4);
                _local3++;
            };
        }
        private function initBtnEvents():void{
            var _local2:MovieClip;
            var _local3:TextFormat;
            var _local1:int;
            while (_local1 < 10) {
                _local2 = back[("tbtn_" + _local1)];
                _local2["Tday"].text = LanguageMgr.GetTranslation(("第x天" + _local1));
                _local3 = _local2["Tday"].getTextFormat();
                _local3.bold = true;
                _local2["Tday"].setTextFormat(_local3);
                btnArray.push(_local2);
                _local2.addEventListener(MouseEvent.MOUSE_OVER, onOver);
                _local2.addEventListener(MouseEvent.MOUSE_OUT, onOut);
                _local2.addEventListener(MouseEvent.CLICK, onClick);
                _local1++;
            };
        }
        private function onOut(_arg1:MouseEvent):void{
            if (((select1) && (select1.parent))){
                select1.parent.removeChild(select1);
            };
        }
        public function updateBtnStatus(_arg1:uint, _arg2:int):void{
            switch (_arg1){
                case 0:
                    getAward.enable = false;
                    back[("tbtn_" + _arg2)]["Tstate"].text = LanguageMgr.GetTranslation("未开启");
                    back[("tbtn_" + _arg2)]["Tstate"].textColor = 0xFF0000;
                    break;
                case 1:
                    getAward.enable = false;
                    back[("tbtn_" + _arg2)]["Tstate"].text = LanguageMgr.GetTranslation("进行中");
                    back[("tbtn_" + _arg2)].filters = [];
                    back[("tbtn_" + _arg2)]["Tstate"].textColor = normalcolor;
                    break;
                case 2:
                    getAward.enable = false;
                    back[("tbtn_" + _arg2)]["Tstate"].text = LanguageMgr.GetTranslation("已过期");
                    back[("tbtn_" + _arg2)].filters = [];
                    back[("tbtn_" + _arg2)]["Tstate"].textColor = normalcolor;
                    break;
                case 3:
                    getAward.enable = true;
                    back[("tbtn_" + _arg2)]["Tstate"].text = LanguageMgr.GetTranslation("已完成");
                    back[("tbtn_" + _arg2)].filters = [];
                    back[("tbtn_" + _arg2)]["Tstate"].textColor = normalcolor;
                    break;
                case 4:
                    getAward.enable = false;
                    back[("tbtn_" + _arg2)]["Tstate"].text = LanguageMgr.GetTranslation("已领取");
                    back[("tbtn_" + _arg2)].filters = [];
                    back[("tbtn_" + _arg2)]["Tstate"].textColor = normalcolor;
                    break;
            };
        }
        public function get CurrentRank():int{
            return (currentSelectDay);
        }

    }
}//package GameUI.Modules.GameTarget.View 
