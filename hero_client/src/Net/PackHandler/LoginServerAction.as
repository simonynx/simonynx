//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;
    import flash.net.*;
    import GameUI.Modules.Pk.Data.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import flash.system.*;

    public class LoginServerAction extends GameAction {

        private static var _instance:LoginServerAction;

        private var timeOutId:uint;

        public function LoginServerAction(){
            super(true);
            if (_instance){
                throw (new Error("loginServerAction is Instance"));
            };
        }
        public static function getInstance():LoginServerAction{
            if (!_instance){
                _instance = new (LoginServerAction)();
            };
            return (_instance);
        }

        private function confirm():void{
            var _local1:URLRequest = new URLRequest(GameConfigData.LoginUrl);
            navigateToURL(_local1);
        }
        private function changeLineResult(_arg1:NetPacket):void{
            trace("切换线路失败");
            var _local2:uint = _arg1.readUnsignedInt();
            if (_local2 != 0){
                MessageTip.popup(LanguageMgr.GetTranslation("目标线路暂时无法使用"));
                UIFacade.GetInstance().sendNotification(ChgLineData.CHG_LINE_FAIL);
            } else {
                if (GameCommonData.Scene.loadCircle != null){
                    GameCommonData.GameInstance.GameUI.removeChild(GameCommonData.Scene.loadCircle);
                    GameCommonData.Scene.loadCircle = null;
                };
                UIFacade.UIFacadeInstance.closeOpenPanel();
                revertSomeData();
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_LOGIN_ACCSERVER:
                    loginAccServer(_arg1);
                    break;
                case Protocol.SMSG_AUTH_RESPONSE:
                    loginGameServer(_arg1);
                    break;
                case Protocol.SMSG_SELECTLINERESULT:
                    changeLineResult(_arg1);
                    break;
                case Protocol.SMSG_LINELIST:
                    getLineList(_arg1);
                    break;
                case Protocol.SMSG_PONG:
                    getPingTime(_arg1);
                    break;
            };
        }
        private function getPingTime(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            GameNet.PING_DALAY = ((getTimer() - _local2) / 2);
            GameNet.S_CURRENT_TIME = _arg1.readUnsignedInt();
            var _local3:Date = new Date(GameNet.S_CURRENT_TIME);
            TimeManager.Instance.UpdateServerTime(GameNet.S_CURRENT_TIME);
        }
        private function connetGameServe():void{
            clearTimeout(timeOutId);
            Security.loadPolicyFile((("xmlsocket://" + GameConfigData.GameSocketIP) + ":843"));
            if (GameCommonData.Tiao){
                //GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("正在连接游戏服务器");
            };
            GameCommonData.GameNets = new GameNet(GameConfigData.GameSocketIP, GameConfigData.GameSocketPort);
        }
        private function revertSomeData():void{
            GameCommonData.Player.Role.DotBuff = new Array();
            GameCommonData.Player.Role.PlusBuff = new Array();
            UIFacade.GetInstance().changeBuffStatus(8, 0);
            PkData.PkStateList = [true, true, false];
            sendNotification(PkEvent.RESET_PK);
            sendNotification(TranscriptEvent.CLOSE_TRANSCRIPT_VIEW);
            GameCommonData.Player.Role.FightState = 0;
            ChgLineData.isChgLine = true;
            GameCommonData.isReceive1052 = false;
            GameCommonData.IsConnectAcc = false;
            GameCommonData.isReceiveAcc = false;
            GameCommonData.isSend = true;
            GameCommonData.IsChangeOnline = true;
            GameCommonData.Scene.ResetMoveState();
            GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
            if (GameCommonData.Player.Role.UsingPetAnimal != null){
                GameCommonData.Scene.PetResetMoveState();
                GameCommonData.Player.Role.UsingPetAnimal.SetAction(GameElementSkins.ACTION_STATIC);
            };
        }
        private function loginAccServer(_arg1:NetPacket):void{
            var _local6:URLRequest;
            var _local2:int = _arg1.readUnsignedInt();
            if (_local2 != 0){
                if (_local2 == 1){
                    _local6 = new URLRequest(GameConfigData.LoginUrl);
                    navigateToURL(_local6, "_self");
                    trace("密码错误");
                } else {
                    if (_local2 == 2){
                        if (GameCommonData.Tiao){
                            //GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("帐号错误,重新登录.....");
                        };
                        trace("帐号错误");
                    } else {
                        if (_local2 == 3){
                            if (GameCommonData.Tiao){
                               // GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("版本错误,请清空IE缓存.....");
                            };
                            trace("版本错误");
                        } else {
                            if (_local2 == 4){
                                if (GameCommonData.Tiao){
                                    //GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("IP被禁止,请联系GM.....");
                                };
                                trace("IP被禁止");
                            } else {
                                if (GameCommonData.Tiao){
                                   // GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("末知错误.....");
                                };
                                trace("末知错误");
                            };
                        };
                    };
                };
                return;
            };
            var _local3:int = _arg1.readUnsignedInt();
            var _local4:String = _arg1.ReadString();
            var _local5:String = _arg1.ReadString();
            trace(((((("login accserver success:id:" + _local3) + ",key:") + _local4) + ",gateipport:") + _local5));
            GameConfigData.GameSocketIP = _local5.split(":")[0];
            GameConfigData.GameSocketPort = uint(_local5.split(":")[1]);
            GameCommonData.GServerInfo.idAccount = _local3;
            GameCommonData.GServerInfo.dwData = _local4;
            GameCommonData.IsConnectAcc = true;
            GameCommonData.isReceiveAcc = true;
            GameCommonData.AccNets.Close();
            GameCommonData.AccNets = null;
            timeOutId = setTimeout(connetGameServe, 500);
        }
        private function loginGameServer(_arg1:NetPacket):void{
            UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                comfrim:confirm,
                cancel:null,
                info:LanguageMgr.GetTranslation("验证实效请重新登录")
            });
            var _local2:uint = _arg1.readByte();
            if (_local2 == 19){
                trace("IP被封");
                if (GameCommonData.Tiao){
                   // GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("IP被禁止,请联系GM");
                };
            };
            if (_local2 == 13){
                trace("验证失败");
                if (GameCommonData.Tiao){
                   // GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("验证码时效，请重新登录");
                };
            };
            if (_local2 == 20){
                if (GameCommonData.Tiao){
                   // GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("版本过期，请清空IE缓存");
                };
                trace("版本过期");
            };
        }
        private function getLineList(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:int;
            var _local2:int = _arg1.readUnsignedInt();
            GameCommonData.GameServerArr = [];
            var _local5:int;
            while (_local5 < _local2) {
                _local3 = _arg1.readUnsignedInt();
                _local4 = _arg1.readUnsignedInt();
                GameCommonData.GameServerArr[_local5] = [_local3, _local4];
                _local5++;
            };
            if (ChgLineData.isChooseLine){
                facade.sendNotification(ChgLineData.CHG_LINE_GO);
            };
            facade.sendNotification(ChgLineData.UPDATA_SERVER);
        }

    }
}//package Net.PackHandler 
