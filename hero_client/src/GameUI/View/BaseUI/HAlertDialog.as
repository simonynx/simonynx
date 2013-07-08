//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.events.*;
    import flash.utils.*;

    public class HAlertDialog extends HConfirmFrame {

        public static var OK_LABEL:String = "确定";
        protected static var okBackFun:Function;

        protected var closeCallBackFunc:Function;

        public function HAlertDialog(_arg1:String, _arg2:String, _arg3:Boolean=true, _arg4:Function=null, _arg5:String=null, _arg6:Function=null){
            var _local7:* = _arg2;
            titleText = _arg1;
            centerTitle = true;
            okLabel = (_arg5) ? _arg5 : OK_LABEL;
            okBackFun = _arg4;
            okFunction = okCallBack;
            closeCallBackFunc = _arg6;
            var _local8:* = new ByteArray();
            _local8.writeUTF(_local7);
            while (_local8.length < 20) {
                _local7 = ((" " + _local7) + " ");
                _local8 = new ByteArray();
                _local8.writeUTF(_local7);
            };
            if (_local7.indexOf("\\n") != -1){
                _contentTextField.width = 360;
                _contentTextField.wordWrap = true;
                _contentTextField.htmlText = (_local7.substring(0, _local7.indexOf("\\n")) + _local7.substring((_local7.indexOf("\\n") + 2), _local7.length));
            } else {
                _contentTextField.htmlText = _local7;
            };
            alphaGound = _arg3;
            showCancel = false;
            blackGound = false;
            setSize((_contentTextField.width + 100), (_contentTextField.height + 110));
            center();
        }
        public static function show(_arg1:String, _arg2:String, _arg3:Boolean=true, _arg4:Function=null, _arg5:Boolean=true, _arg6:String=null, _arg7:Function=null):HAlertDialog{
            var _local8:HAlertDialog = new HAlertDialog(_arg1, _arg2, _arg3, _arg4, _arg6, _arg7);
            _local8.centerFrame();
            GameCommonData.GameInstance.GameUI.addChild(_local8);
            return (_local8);
        }

        protected function okCallBack(){
            if (okBackFun != null){
                okBackFun();
            } else {
                dispose();
            };
        }
        override protected function __closeClick(_arg1:MouseEvent):void{
            dispose();
            if (closeCallBackFunc != null){
                closeCallBackFunc();
            };
        }

    }
}//package GameUI.View.BaseUI 
