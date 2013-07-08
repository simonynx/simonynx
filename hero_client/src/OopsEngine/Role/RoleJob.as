//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Role {
    import GameUI.Modules.ScreenMessage.View.*;
    import OopsEngine.Graphics.Tagger.*;

    public class RoleJob {

        private var _WeakResistance:uint;
        private var _CharmResistance:uint;
        private var _SleepResistance:uint;
        private var _FightPower:uint;
        public var Job:uint;
        public var SkillHit:uint;
        public var SkillDodge:uint;
        private var _FixedBodyResistance:uint;
        private var _Hit:uint;
        private var _Dodge:uint;
        public var AttackMin:uint;
        private var _CritRate:Number = 0;
        private var _AttackMax:uint;
        private var _Crit:Number = 0;
        private var _Defense:uint;
        public var Attack:uint;
        private var _VertigoResistance:uint;

        public function get CritRate():Number{
            return (_CritRate);
        }
        public function get Crit():Number{
            return (_Crit);
        }
        public function get Defense():uint{
            return (_Defense);
        }
        public function set CharmResistance(_arg1:uint):void{
            var _local2:int;
            if (_CharmResistance != _arg1){
                _local2 = (_arg1 - _CharmResistance);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.MEIHUO_VALUE, _local2);
                };
                _CharmResistance = _arg1;
            };
        }
        public function get Dodge():uint{
            return (_Dodge);
        }
        public function set AttackMax(_arg1:uint):void{
            var _local2:int;
            if (_AttackMax != _arg1){
                _local2 = (_arg1 - _AttackMax);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.MAX_AP, _local2);
                };
                _AttackMax = _arg1;
            };
        }
        public function set Defense(_arg1:uint):void{
            var _local2:int;
            if (_Defense != _arg1){
                _local2 = (_arg1 - _Defense);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.MAX_DP, _local2);
                };
                _Defense = _arg1;
            };
        }
        public function set SleepResistance(_arg1:uint):void{
            var _local2:int;
            if (_SleepResistance != _arg1){
                _local2 = (_arg1 - _SleepResistance);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.HUNSHUI_VALUE, _local2);
                };
                _SleepResistance = _arg1;
            };
        }
        public function get CharmResistance():uint{
            return (_CharmResistance);
        }
        public function get AttackMax():uint{
            return (_AttackMax);
        }
        public function set FixedBodyResistance(_arg1:uint):void{
            var _local2:int;
            if (_FixedBodyResistance != _arg1){
                _local2 = (_arg1 - _FixedBodyResistance);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.DINGSHEN_VALUE, _local2);
                };
                _FixedBodyResistance = _arg1;
            };
        }
        public function get SleepResistance():uint{
            return (_SleepResistance);
        }
        public function set WeakResistance(_arg1:uint):void{
            var _local2:int;
            if (_WeakResistance != _arg1){
                _local2 = (_arg1 - _WeakResistance);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.XURUO_VALUE, _local2);
                };
                _WeakResistance = _arg1;
            };
        }
        public function set Hit(_arg1:uint):void{
            var _local2:int;
            if (_Hit != _arg1){
                _local2 = (_arg1 - _Hit);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.MAX_MINGZHONG, _local2);
                };
                _Hit = _arg1;
            };
        }
        public function set FightPower(_arg1:uint):void{
            if (_FightPower != _arg1){
                _FightPower = _arg1;
            };
        }
        public function set Dodge(_arg1:uint):void{
            var _local2:int;
            if (_Dodge != _arg1){
                _local2 = (_arg1 - _Dodge);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.MAX_EV, _local2);
                };
                _Dodge = _arg1;
            };
        }
        public function get WeakResistance():uint{
            return (_WeakResistance);
        }
        public function set VertigoResistance(_arg1:uint):void{
            var _local2:int;
            if (_VertigoResistance != _arg1){
                _local2 = (_arg1 - _VertigoResistance);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.XUANYUN_VALUE, _local2);
                };
                _VertigoResistance = _arg1;
            };
        }
        public function get Hit():uint{
            return (_Hit);
        }
        public function set Crit(_arg1:Number):void{
            var _local2:Number;
            if (_Crit != _arg1){
                _local2 = ((_arg1 - _Crit) * 100);
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.ATTACK_ZHIMING, _local2);
                };
                _Crit = _arg1;
            };
        }
        public function get FightPower():uint{
            return (_FightPower);
        }
        public function get FixedBodyResistance():uint{
            return (_FixedBodyResistance);
        }
        public function get VertigoResistance():uint{
            return (_VertigoResistance);
        }
        public function set CritRate(_arg1:Number):void{
            var _local2:Number;
            if (_CritRate != _arg1){
                _local2 = ((_arg1 * 100) - (_CritRate * 100));
                if ((((GameCommonData.Player.Role.MainJob == this)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.MAX_CP, _local2);
                };
                _CritRate = _arg1;
            };
        }

    }
}//package OopsEngine.Role 
