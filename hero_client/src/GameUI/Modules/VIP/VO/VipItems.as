//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.VIP.VO {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Chat.Mediator.*;
    import GameUI.Modules.VIP.Command.*;

    public class VipItems extends Sprite {

        public var roleName:String = "";
        public var level:String = "";
        public var sex:String = "";
        public var guid:uint = 0;
        public var vipType:uint = 0;
        private var content:MovieClip;
        public var job:String = "";
        public var guildName:String = "";

        public function VipItems(){
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("vipinfos");
        }
        private function onMouseOver(_arg1:MouseEvent):void{
            VIPConstants.MCSelect.stop();
            VIPConstants.MCSelect.nextFrame();
            VIPConstants.MCSelect.x = -5;
            VIPConstants.MCSelect.y = 3;
            VIPConstants.MCSelect.width = 528;
            VIPConstants.MCSelect.height = 26;
            this.addChild(VIPConstants.MCSelect);
        }
        private function addEvents():void{
            this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseOut);
            this.addEventListener(MouseEvent.CLICK, onMouseClick);
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            if (VIPConstants.MCSelect.parent){
                VIPConstants.MCSelect.parent.removeChild(VIPConstants.MCSelect);
            };
        }
        public function init():void{
            var _local1:Bitmap;
            content.rolename.y = (content.rolename.y + 8);
            content.sex.y = (content.sex.y + 8);
            content.job.y = (content.job.y + 8);
            content.level.y = (content.level.y + 8);
            content.guild.y = (content.guild.y + 8);
            content.rolename.x = (content.rolename.x - 8);
            content.sex.x = (content.sex.x - 8);
            content.job.x = (content.job.x - 8);
            content.level.x = (content.level.x - 8);
            content.guild.x = (content.guild.x - 8);
            content.rolename.text = roleName;
            content.sex.text = ((int(sex) == 0)) ? LanguageMgr.GetTranslation("male") : LanguageMgr.GetTranslation("female");
            content.job.text = GameCommonData.RolesListDic[job];
            content.level.text = level;
            if (guildName == ""){
                guildName = "----";
            };
            content.guild.text = guildName;
            _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("RankLine");
            _local1.x = (_local1.x - 4);
            _local1.width = 526;
            _local1.y = 31;
            this.addChild(_local1);
            this.addChild(content);
            addEvents();
            content.rolename.textColor = VIPConstants[("Color" + vipType)];
            content.sex.textColor = VIPConstants[("Color" + vipType)];
            content.job.textColor = VIPConstants[("Color" + vipType)];
            content.level.textColor = VIPConstants[("Color" + vipType)];
            content.guild.textColor = VIPConstants[("Color" + vipType)];
        }
        private function onMouseClick(_arg1:MouseEvent):void{
            VIPConstants.MCSelect1.stop();
            VIPConstants.MCSelect1.nextFrame();
            VIPConstants.MCSelect1.x = -5;
            VIPConstants.MCSelect1.y = 3;
            VIPConstants.MCSelect1.width = 528;
            VIPConstants.MCSelect1.height = 26;
            this.addChild(VIPConstants.MCSelect1);
            var _local2:QuickSelectMediator = new QuickSelectMediator();
            UIFacade.GetInstance().registerMediator(_local2);
            UIFacade.GetInstance().sendNotification(ChatEvents.SHOWQUICKOPERATOR, {
                name:_arg1.currentTarget["roleName"],
                sendId:this.guid,
                model:[LanguageMgr.GetTranslation("查看信息"), LanguageMgr.GetTranslation("加为好友"), LanguageMgr.GetTranslation("设为私聊"), LanguageMgr.GetTranslation("复制姓名")]
            });
        }

    }
}//package GameUI.Modules.VIP.VO 
