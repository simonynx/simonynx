//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import Net.*;
    import GameUI.View.*;
    import GameUI.Modules.Verification.Proxy.*;
    import GameUI.Modules.Verification.Data.*;

    public class VerificationAction extends GameAction {

        private static const TIME_WARNNING_3:int = 3;
        private static const TIME_WARNNING_4:int = 4;
        private static const VERI_ERROR_NONE:int = 0;
        private static const TIME_WARNNING_NONE:int = 0;
        private static const VERI_ERROR_NOTPASS:int = 1;
        private static const VERI_ERROR_NUM:int = 2;
        private static const VERI_ERROR_VERIFIED:int = 3;
        private static const TIME_WARNNING_1:int = 1;
        private static const TIME_WARNNING_2:int = 2;

        private static var instance:VerificationAction;

        public function VerificationAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():VerificationAction{
            if (instance == null){
                instance = new (VerificationAction)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_IDENTIFICATION:
                    IdentityResult(_arg1);
                    break;
                case Protocol.SMSG_TIME_LIMIT_NOTICE:
                    TimeLimitNotice(_arg1);
                    break;
                case Protocol.SMSG_GAME_STATE:
                    GameState(_arg1);
                    break;
            };
        }
        private function IdentityResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            switch (_local2){
                case VERI_ERROR_NONE:
                    MessageTip.show(LanguageMgr.GetTranslation("验证通过"));
                    VerificationData.HasVerify = true;
                    facade.sendNotification(VerificationEvent.CLOSE_VERIFICATION_VIEW2);
                    break;
                case VERI_ERROR_NOTPASS:
                    facade.sendNotification(VerificationEvent.VERIFICATION_NOTPASS);
                    facade.sendNotification(VerificationEvent.CLOSE_VERIFICATION_VIEW2);
                    break;
                case VERI_ERROR_NUM:
                    MessageTip.show(LanguageMgr.GetTranslation("身份证号码错误重填"));
                    break;
                case VERI_ERROR_VERIFIED:
                    MessageTip.show(LanguageMgr.GetTranslation("已经验证过"));
                    facade.sendNotification(VerificationEvent.CLOSE_VERIFICATION_VIEW2);
                    break;
            };
        }
        private function TimeLimitNotice(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readByte();
            VerificationData.TimeLimitFlag = _local2;
            facade.sendNotification(VerificationEvent.SHOW_VERIFICATION_VIEW3, {type:_local2});
        }
        private function GameState(_arg1:NetPacket):void{
            VerificationData.VerificationType = _arg1.readUnsignedInt();
            trace("国家", VerificationData.VerificationType);
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            VerificationData.PlayTime = _local3;
            switch (_local2){
                case TIME_WARNNING_1:
                    VerificationData.TimeLimitFlag = VerificationData.TIME_LIMIT_2_HOUR;
                    break;
                case TIME_WARNNING_2:
                    VerificationData.TimeLimitFlag = VerificationData.TIME_LIMIT_1_HOUR;
                    break;
                case TIME_WARNNING_3:
                    VerificationData.TimeLimitFlag = VerificationData.TIME_LIMIT_5_MIN;
                    break;
                case TIME_WARNNING_4:
                    VerificationData.TimeLimitFlag = VerificationData.TIME_LIMIT_NOTIMELEFT;
                    break;
            };
            if (!VerificationData.HasVerify){
                if (_local2 > 0){
                    facade.sendNotification(VerificationEvent.SHOW_VERIFICATION_VIEW3, {type:VerificationData.TimeLimitFlag});
                    facade.sendNotification(VerificationEvent.VERIFICATION_STATE);
                };
            };
        }

    }
}//package Net.PackHandler 
