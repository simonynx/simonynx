//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Graphics.Tagger {
    import flash.display.*;
    import flash.text.*;
    import flash.filters.*;
    import OopsEngine.Pool.*;
    import OopsEngine.Graphics.Font;

    public class AttackFace extends Sprite implements IPoolClass {

        private static const FOUNT_OFFSET:int = 15;
        public static const CHANGE_EXP:String = "ae.cExp";
        public static const MAX_AP:String = "ae.mAp";
        public static const DEFAULT_FOUNT_COLOR_GREEN:int = 0xFF00;
        public static const DINGSHEN_VALUE:String = "dingshen_value";
        public static const DINGSHEN_COLOR:int = 5093237;
        public static const MEIHUO_COLOR:int = 15625681;
        public static const MAX_ADX:String = "ae.mAdx";
        public static const ATTACK_LOSE_FROM_PET:String = "ae.aLoseHitFromMount";
        public static const DEFAULT_FOUNT_COLOR_BLUE:int = 2003199;
        public static const MEIHUO_VALUE:String = "meihuo_value";
        public static const DEFAULT_FOUNT_COLOR_WHITE:int = 0xFFFFFF;
        public static const MAX_MDX:String = "ae.mMdx";
        public static const ATTACK_PET_CRIT:String = "ae.aCritPetHit";
        public static const OTHERS_TASK_ACCEPT:String = "ae.oTaskAccept";
        public static const DEFAULT_FOUNT_COLOR_ORANGE:int = 0xFF8A00;
        public static const DEFAULT_FOUNT_SIZE_4:int = 18;
        public static const OTHERS_ZHAN_JI:String = "ae.OTHERS_ZHAN_JI";
        public static const MAX_CP:String = "ae.mCp";
        public static const DEFAULT_FOUNT_SIZE_5:int = 19;
        public static const OTHERS_DUEL:String = "ae.oDuel";
        public static const XURUO_VALUE:String = "xuruo_value";
        public static const MAX_DP:String = "ae.mDp";
        public static const XURUO_COLOR:int = 5159862;
        public static const OHTER_GREEN:int = 0x96FF00;
        public static const DEFAULT_FOUNT_COLOR_YELLOW:int = 0xFFFF00;
        public static const MAX_MP:String = "ae.mMp";
        public static const MAX_EV:String = "ae.mEv";
        public static const CHANGE_MP:String = "ae.cMp";
        public static const ATTACK_MISS:String = "ae.aMiss";
        public static const OTHERS_AUTO_AFK:String = "ae.oAutoAfk";
        private static const DEFAULT_FOUNT_SIZE:int = 16;
        public static const CHANGE_HP_OTHER_FROM_PET:String = "ae.cHpOtherFromMount";
        public static const DEFAULT_FOUNT_COLOR_RED1:int = 0xCC0000;
        public static const CHANGE_HP_OTHER:String = "ae.cHpOther";
        public static const ATTACK_LOSE:String = "ae.aLose";
        public static const OTHERS_LEVEL_UP:String = "ae.oLevelUp";
        public static const DEFAULT_FOUNT_SIZE_15:int = 29;
        public static const ATTACK_ZHIMING:String = "ae.aZhiming";
        public static const DEFAULT_FOUNT_SIZE_18:int = 32;
        public static const DEFAULT_FOUNT_SIZE_14:int = 28;
        public static const DEFAULT_FOUNT_SIZE_16:int = 30;
        public static const DEFAULT_FOUNT_COLOR_RED2:int = 0x990000;
        public static const ATTACK_RESIST:String = "ae.aJumpMiss";
        public static const OTHERS_LIANZHAN:String = "ae.OTHERS_LIANZHAN";
        private static const filterArr:Array = [new GlowFilter(0x484848, 0.5, 4, 4, 8, BitmapFilterQuality.LOW)];
        public static const DEFAULT_FOUNT_COLOR_RED:int = 0xFF0000;
        public static const XUANYUN_COLOR:int = 16569754;
        public static const OTHERS_RELIVE_COUNTDOWN = "ae.OTHERS_RELIVE_COUNTDOWN";
        public static const DEFAULT_FOUNT_SIZE_20:int = 34;
        public static const DEFAULT_FOUNT_COLOR_PURPLE:int = 10040314;
        public static const DEFAULT_FOUNT_SIZE_22:int = 36;
        public static const DEFAULT_FOUNT_SIZE_24:int = 37;
        public static const DEFAULT_FOUNT_SIZE_26:int = 40;
        public static const CHANGE_GP:String = "ae.cGp";
        public static const XUANYUN_VALUE:String = "xuanyun_value";
        public static const MAX_PP:String = "ae.mPp";
        public static const HUNSHUI_COLOR:int = 16771983;
        public static const ATTACK_CRITICALHIT_RATE:String = "ae.aCriticalHitRate";
        public static const MAX_HP:String = "ae.mHp";
        public static const MAX_MINGZHONG:String = "ae.mMingZhong";
        public static const CHANGE_PP:String = "ae.cPp";
        public static const OTHERS_TASK_HANDIN:String = "ae.oTaskHandIn";
        public static const HUNSHUI_VALUE:String = "hunshui_value";
        public static const CHANGE_ENERGY:String = "ae.cEnergy";
        public static const CHANGE_PRESTIGE:String = "ae.cPrestige";
        public static const CHANGE_HP_RECOVER:String = "ae.cHpRecover";
        public static const ATTACK_CRITICALHIT:String = "ae.aCriticalHit";
        public static const CHANGE_HP:String = "ae.cHp";

        private var _type:String = "";
        private var _text:String = "";
        private var _dir:int = 4;
        private var _fontSize:uint = 16;
        private var _value:Number = 0;
        private var _fontColor:uint = 0;
        private var tf:TextField;

        public function AttackFace(_arg1:String="", _arg2:Number=0, _arg3:String="", _arg4:uint=0, _arg5:uint=0){
            this.tf = new TextField();
            this.tf.autoSize = TextFormatAlign.LEFT;
            this.tf.mouseEnabled = false;
            this.tf.filters = OopsEngine.Graphics.Font.AttackFaceFilter;
            this.tf.cacheAsBitmap = true;
            this.reSet([_arg1, _arg2, _arg3, _arg4, _arg5]);
        }
        public static function recycleAttackFace(_arg1:AttackFace):void{
            ScenePool.attackFacePool.disposeObj(_arg1);
        }
        public static function createAttackFace(_arg1:String="", _arg2:Number=0, _arg3:String="", _arg4:uint=0, _arg5:uint=0):AttackFace{
            return ((ScenePool.attackFacePool.createObj(AttackFace, _arg1, _arg2, _arg3, _arg4, _arg5) as AttackFace));
        }

        public function get dir():int{
            return (this._dir);
        }
        public function reSet(_arg1:Array):void{
            this._type = _arg1[0];
            this._value = _arg1[1];
            var _local2:String = _arg1[2];
            var _local3:uint = _arg1[3];
            var _local4:uint = _arg1[4];
            switch (this._type){
                case ATTACK_CRITICALHIT:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("暴击") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("暴击") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_RED;
                    break;
                case ATTACK_PET_CRIT:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("暴击") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("暴击") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_15;
                    this._fontColor = DEFAULT_FOUNT_COLOR_RED;
                    break;
                case ATTACK_ZHIMING:
                    _value = int(_value);
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("暴击伤害") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("暴击伤害") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_15;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    break;
                case ATTACK_MISS:
                    this._text = LanguageMgr.GetTranslation("躲闪");
                    this._fontSize = DEFAULT_FOUNT_SIZE_18;
                    this._fontColor = DEFAULT_FOUNT_COLOR_BLUE;
                    this._dir = 2;
                    break;
                case CHANGE_HP_RECOVER:
                    this._text = ("+" + this._value);
                    this._fontSize = DEFAULT_FOUNT_SIZE_18;
                    this._fontColor = OHTER_GREEN;
                    break;
                case ATTACK_LOSE:
                    this._text = LanguageMgr.GetTranslation("丢失");
                    this._fontSize = DEFAULT_FOUNT_SIZE_18;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    this._dir = 6;
                    break;
                case ATTACK_LOSE_FROM_PET:
                    this._text = LanguageMgr.GetTranslation("丢失");
                    this._fontSize = DEFAULT_FOUNT_SIZE_15;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    this._dir = 6;
                    break;
                case ATTACK_RESIST:
                    this._text = LanguageMgr.GetTranslation("抵抗");
                    this._fontSize = DEFAULT_FOUNT_SIZE_18;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    this._dir = 2;
                    break;
                case CHANGE_HP:
                    if (this._value > 0){
                        this._text = ("+ " + this._value);
                    } else {
                        this._text = String(this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_RED;
                    break;
                case CHANGE_HP_OTHER:
                    if (this._value > 0){
                        this._text = ("+ " + this._value);
                    } else {
                        this._text = String(this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_WHITE;
                    break;
                case CHANGE_HP_OTHER_FROM_PET:
                    if (this._value > 0){
                        this._text = ("+ " + this._value);
                    } else {
                        this._text = String(this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_5;
                    this._fontColor = DEFAULT_FOUNT_COLOR_WHITE;
                    this._dir = 3;
                    break;
                case CHANGE_MP:
                    if (this._value > 0){
                        this._text = ("+ " + this._value);
                    } else {
                        this._text = String(this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_14;
                    this._fontColor = DEFAULT_FOUNT_COLOR_BLUE;
                    break;
                case CHANGE_PP:
                    if (this._value > 0){
                        this._text = ("+ " + this._value);
                    } else {
                        this._text = String(this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_14;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case CHANGE_GP:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("魔法") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("魔法") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_PURPLE;
                    break;
                case CHANGE_EXP:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("经验") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("经验") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case CHANGE_PRESTIGE:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("战场声望") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("战场声望") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_PURPLE;
                    break;
                case CHANGE_ENERGY:
                    if (this._value > 0){
                        this._text = ("+ " + this._value);
                    } else {
                        this._text = String(this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_5;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    break;
                case MAX_HP:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("生命") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("生命") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = OHTER_GREEN;
                    break;
                case MAX_MP:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("魔法") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("魔法") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_BLUE;
                    break;
                case MAX_PP:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("体力") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("体力") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case MAX_AP:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("攻击") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("攻击") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_RED;
                    break;
                case MAX_DP:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("防御") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("防御") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case MEIHUO_VALUE:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("魅惑") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("魅惑") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = MEIHUO_COLOR;
                    break;
                case XUANYUN_VALUE:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("眩晕") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("眩晕") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = XUANYUN_COLOR;
                    break;
                case HUNSHUI_VALUE:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("昏睡") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("昏睡") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = HUNSHUI_COLOR;
                    break;
                case DINGSHEN_VALUE:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("定身") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("定身") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DINGSHEN_COLOR;
                    break;
                case XURUO_VALUE:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("虚弱") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("虚弱") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = XURUO_COLOR;
                    break;
                case MAX_CP:
                    _value = (int((_value * 100)) / 100);
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("暴击率") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("暴击率") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_RED;
                    break;
                case MAX_EV:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("躲闪") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("躲闪") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    break;
                case MAX_MINGZHONG:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("命中") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("命中") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    break;
                case MAX_ADX:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("攻速") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("攻速") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    break;
                case MAX_MDX:
                    if (this._value > 0){
                        this._text = ((LanguageMgr.GetTranslation("移速") + " +") + this._value);
                    } else {
                        this._text = ((LanguageMgr.GetTranslation("移速") + " ") + this._value);
                    };
                    this._fontSize = DEFAULT_FOUNT_SIZE_16;
                    this._fontColor = DEFAULT_FOUNT_COLOR_GREEN;
                    break;
                case OTHERS_LEVEL_UP:
                    this._text = (LanguageMgr.GetTranslation("升级") + "！");
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case OTHERS_DUEL:
                    this._text = (LanguageMgr.GetTranslation("切磋倒计时") + this._value);
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case OTHERS_AUTO_AFK:
                    this._text = (LanguageMgr.GetTranslation("挂机中") + "...");
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case OTHERS_TASK_ACCEPT:
                    this._text = LanguageMgr.GetTranslation("接受任务");
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case OTHERS_TASK_HANDIN:
                    this._text = LanguageMgr.GetTranslation("完成任务");
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case OTHERS_ZHAN_JI:
                    this._text = LanguageMgr.GetTranslation("斩击");
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case OTHERS_LIANZHAN:
                    this._text = (LanguageMgr.GetTranslation("连斩") + "+1");
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
                case OTHERS_RELIVE_COUNTDOWN:
                    this._text = ((LanguageMgr.GetTranslation("复活倒计时") + ":") + this._value);
                    this._fontSize = DEFAULT_FOUNT_SIZE_20;
                    this._fontColor = DEFAULT_FOUNT_COLOR_YELLOW;
                    break;
            };
            if (_local2 != ""){
                this._text = _local2;
            };
            if (_local3 != 0){
                this._fontSize = _local3;
            };
            if (_local4 != 0){
                this._fontColor = _local4;
            };
            if (this._text != ""){
                this.tf.text = this._text;
                this.tf.setTextFormat(new TextFormat("楷体_GB2312", this._fontSize, this._fontColor));
                this.tf.x = (-(this.tf.width) / 2);
                this.tf.y = (-(this.tf.height) / 2);
                if (this.tf.parent != this){
                    this.addChild(this.tf);
                };
            } else {
                this.tf.text = "";
            };
        }
        public function dispose():void{
            this._type = "";
            this._value = 0;
            this._text = "";
            this._fontSize = DEFAULT_FOUNT_SIZE;
            this._fontColor = 0;
            this._dir = 4;
        }

    }
}//package OopsEngine.Graphics.Tagger 
