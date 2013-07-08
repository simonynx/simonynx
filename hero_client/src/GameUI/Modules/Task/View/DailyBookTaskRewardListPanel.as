//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import flash.display.*;
    import flash.text.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;

    public class DailyBookTaskRewardListPanel extends HFrame {

        private var tf:TextField;
        private var bg:Sprite;
        private var bgBack:Sprite;

        public function DailyBookTaskRewardListPanel(){
            initView();
        }
        private function updateData():void{
            var _local6:Array;
            var _local7:int;
            var _local1 = "";
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[TaskCommonData.CurrentDialyBookTaskId];
            var _local3:Array = [1, 1.5, 2, 2.3, 2.5];
            var _local4:int;
            var _local5:int = TaskCommonData.dailyBOokQualityColor.length;
            while (_local4 < _local5) {
                _local6 = TaskCommonData.dailyBOokQualityColor[_local4];
                _local7 = (_local2.OriExp * _local3[_local4]);
                _local1 = (_local1 + (((((("<font color='#" + _local6[1].toString(16)) + "'>") + _local6[0]) + "：") + _local7) + "</font><br>"));
                _local4++;
            };
            tf.htmlText = _local1;
        }
        private function initView():void{
            setSize(212, 165);
            titleText = "奖励";
            centerTitle = true;
            blackGound = false;
            bg = new Sprite();
            addContent(bg);
            bgBack = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassBySprite("BlueBack2");
            bgBack.width = 204;
            bgBack.height = 130;
            bgBack.x = 4;
            bgBack.y = 31;
            bg.addChild(bgBack);
            tf = UIUtils.createTextField(180, 110);
            tf.x = 25;
            tf.y = 45;
            var _local1:TextFormat = tf.defaultTextFormat;
            _local1.leading = 8;
            tf.defaultTextFormat = _local1;
            tf.multiline = true;
            bg.addChild(tf);
        }
        override public function show():void{
            if (parent){
                close();
            } else {
                updateData();
                super.show();
            };
        }

    }
}//package GameUI.Modules.Task.View 
