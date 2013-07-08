//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GuildFight.View {
    import flash.display.*;
    import flash.text.*;

    public class GuildFightItem extends Sprite {

        public static var itemFormat:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 16711257, false, null, null, null, null, TextFormatAlign.CENTER);

        public var guilder:String;
        public var guildname:String;
        private var back:MovieClip;
        public var roleid:uint;
        public var list:uint;

        public function GuildFightItem(){
            back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("guildfightitem");
            super();
            init();
        }
        private function init():void{
            var _local1:Bitmap;
            back.list.defaultTextFormat = itemFormat;
            back.guildname.defaultTextFormat = itemFormat;
            back.guilder.defaultTextFormat = itemFormat;
            this.addChild(back);
            _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("RankLine");
            _local1.width = 380;
            _local1.y = 20;
            this.addChild(_local1);
        }
        public function show():void{
            back.list.text = list.toString();
            back.guildname.text = guildname;
            back.guilder.text = guilder;
        }

    }
}//package GameUI.Modules.GuildFight.View 
