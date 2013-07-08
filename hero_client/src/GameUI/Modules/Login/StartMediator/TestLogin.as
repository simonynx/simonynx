//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Login.StartMediator {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import Net.*;
    import Utils.*;
    import flash.system.*;

    public class TestLogin {

        public static var test_txt:TextField = new TextField();
        private static var txtAccmoute_label:TextField;
        private static var txtLogin_label:TextField;
        private static var txtAccmoute:TextField;
        private static var btnLogin:Sprite;
        private static var Password_label:TextField;
        private static var Password:TextField;

        private static function loginHandler(_arg1:MouseEvent):void{
            if (GameCommonData.isReceiveAcc){
                return;
            };
            GameCommonData.Accmoute = txtAccmoute.text;
            GameCommonData.Password = MD5.hash(Password.text);
            Security.loadPolicyFile((("xmlsocket://" + GameConfigData.AccSocketIP) + ":843"));
            GameCommonData.AccNets = new AccNet(GameConfigData.AccSocketIP, GameConfigData.AccSocketPort);
        }
        public static function removeLogin():void{
            if (((txtAccmoute_label) && (GameCommonData.GameInstance.GameUI.contains(txtAccmoute_label)))){
                GameCommonData.GameInstance.GameUI.removeChild(txtAccmoute_label);
            };
            if (((Password_label) && (GameCommonData.GameInstance.GameUI.contains(Password_label)))){
                GameCommonData.GameInstance.GameUI.removeChild(Password_label);
            };
            if (((Password_label) && (GameCommonData.GameInstance.GameUI.contains(txtLogin_label)))){
                GameCommonData.GameInstance.GameUI.removeChild(txtLogin_label);
            };
            if (((btnLogin) && (GameCommonData.GameInstance.GameUI.contains(btnLogin)))){
                GameCommonData.GameInstance.GameUI.removeChild(btnLogin);
            };
            if (((txtAccmoute) && (GameCommonData.GameInstance.GameUI.contains(txtAccmoute)))){
                GameCommonData.GameInstance.GameUI.removeChild(txtAccmoute);
            };
            if (((Password) && (GameCommonData.GameInstance.GameUI.contains(Password)))){
                GameCommonData.GameInstance.GameUI.removeChild(Password);
            };
        }
        public static function login():void{
            txtAccmoute = new TextField();
            Password = new TextField();
            btnLogin = new Sprite();
            txtAccmoute.text = GameCommonData.LoginName;
            Password.text = GameCommonData.LoginPassword;
            txtAccmoute.borderColor = 0;
            txtAccmoute.background = true;
            txtAccmoute.width = 100;
            txtAccmoute.height = 20;
            txtAccmoute.x = 450;
            txtAccmoute.y = 220;
            txtAccmoute.type = TextFieldType.INPUT;
            Password.borderColor = 0;
            Password.background = true;
            Password.x = 450;
            Password.y = 250;
            Password.width = 100;
            Password.height = 20;
            Password.type = TextFieldType.INPUT;
            btnLogin.graphics.beginFill(0, 1);
            btnLogin.graphics.moveTo(70, 80);
            btnLogin.graphics.lineTo(70, 105);
            btnLogin.graphics.lineTo(120, 105);
            btnLogin.graphics.lineTo(120, 80);
            btnLogin.graphics.lineTo(70, 80);
            btnLogin.x = 400;
            btnLogin.y = 200;
            GameCommonData.GameInstance.GameUI.addChild(btnLogin);
            GameCommonData.GameInstance.GameUI.addChild(txtAccmoute);
            GameCommonData.GameInstance.GameUI.addChild(Password);
            btnLogin.mouseEnabled = true;
            btnLogin.buttonMode = true;
            btnLogin.addEventListener(MouseEvent.CLICK, loginHandler);
            txtAccmoute_label = new TextField();
            Password_label = new TextField();
            txtLogin_label = new TextField();
            txtAccmoute_label.text = LanguageMgr.GetTranslation("账号");
            Password_label.text = LanguageMgr.GetTranslation("密码");
            txtLogin_label.text = LanguageMgr.GetTranslation("登录");
            txtAccmoute_label.mouseEnabled = false;
            Password_label.mouseEnabled = false;
            txtLogin_label.mouseEnabled = false;
            txtLogin_label.textColor = 0xFFFFFF;
            txtAccmoute_label.x = 400;
            txtAccmoute_label.y = 220;
            Password_label.x = 400;
            Password_label.y = 250;
            txtLogin_label.x = 480;
            txtLogin_label.y = 285;
            GameCommonData.GameInstance.GameUI.addChild(txtAccmoute_label);
            GameCommonData.GameInstance.GameUI.addChild(Password_label);
            GameCommonData.GameInstance.GameUI.addChild(txtLogin_label);
            GameCommonData.GameInstance.GameUI.setChildIndex(txtLogin_label, (GameCommonData.GameInstance.GameUI.numChildren - 1));
            test_txt.x = 480;
            test_txt.y = 320;
            test_txt.autoSize = TextFieldAutoSize.LEFT;
            GameCommonData.GameInstance.GameUI.addChild(test_txt);
        }

    }
}//package GameUI.Modules.Login.StartMediator 
