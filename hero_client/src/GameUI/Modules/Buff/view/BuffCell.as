//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Buff.view {
    import flash.display.*;
    import OopsEngine.Skill.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.items.*;
    import OopsEngine.Graphics.Font;

    public class BuffCell extends Sprite {

        private var buffTime:int;
        private var buffInfo:GameSkillBuff;
        private var buffEndTime:int;
        private var _buffType:int;
        private var buffId:int;
        private var item:BuffItem;
        private var timeTextFiled:TextField;

        public function BuffCell(_arg1:GameSkillBuff){
            _buffType = _arg1.TypeID;
            buffId = _arg1.BuffID;
            buffTime = _arg1.BuffTime;
            buffEndTime = (getTimer() + (buffTime * 1000));
            buffInfo = _arg1;
            init();
        }
        public function set theBuffTime(_arg1:int):void{
            buffTime = _arg1;
            buffEndTime = (getTimer() + (buffTime * 1000));
        }
        public function get buff():GameSkillBuff{
            return (buffInfo);
        }
        public function get buffType():int{
            return (_buffType);
        }
        private function init():void{
            item = new BuffItem(_buffType.toString(), null, "BuffIcon");
            item.name = ("buffIcon_" + buffId);
            item.mouseEnabled = true;
            this.addChild(item);
            timeTextFiled = new TextField();
            timeTextFiled.filters = OopsEngine.Graphics.Font.Stroke();
            timeTextFiled.textColor = 0xFFFFFF;
            timeTextFiled.autoSize = TextFieldAutoSize.LEFT;
            timeTextFiled.mouseEnabled = false;
            this.addChild(timeTextFiled);
            timeTextFiled.y = 35;
            timeTextFiled.x = 2;
            buffTime++;
            updateTime();
        }
        public function get theBuffTime():int{
            return (buffTime);
        }
        public function updateTime():void{
            buffTime = ((buffEndTime - getTimer()) * 0.001);
            buffTime = ((buffTime >= 0)) ? buffTime : 0;
            var _local1:int = (buffTime / 3600);
            var _local2:int = ((buffTime % 3600) / 60);
            var _local3:int = (buffTime % 60);
            var _local4 = "";
            if (_local1 > 0){
                _local4 = (("0" + _local1) + ":");
            };
            if (_local2 < 10){
                _local4 = (_local4 + ("0" + _local2));
            } else {
                _local4 = (_local4 + _local2.toString());
            };
            if (_local3 < 10){
                _local4 = (_local4 + (":0" + _local3));
            } else {
                _local4 = (_local4 + (":" + _local3));
            };
            timeTextFiled.text = _local4;
        }

    }
}//package GameUI.Modules.Buff.view 
