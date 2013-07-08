//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HTree {
    import flash.events.*;
    import flash.utils.*;
    import GameUI.Modules.Entrust.Data.*;

    public class HTreeGroupStruct {

        public var des:String = "未分类";
        public var isExpand:Boolean;
        public var textSize:int = 12;
        public var desColor:uint = 0xFFFFFF;
        public var menuIds:Array;
        public var type:uint;
        public var menuDic:Dictionary;

        public function HTreeGroupStruct(_arg1:Dictionary, _arg2:Boolean, _arg3:uint, _arg4:uint=0xFFFFFF, _arg5:uint=1){
            this.type = _arg3;
            textSize = 12;
            if (_arg5 == 1){
                this.isExpand = _arg2;
                this.des = LanguageMgr.GetTranslation(("自寻路目标类型" + this.type));
            } else {
                if (_arg5 == 2){
                    this.isExpand = false;
                    this.des = EntrustData.entrustArr[this.type];
                    this.textSize = 14;
                };
            };
            this.desColor = _arg4;
            this.menuDic = _arg1;
        }
    }
}//package GameUI.View.HTree 
