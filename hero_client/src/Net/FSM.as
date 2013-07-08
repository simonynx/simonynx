//Created by Action Script Viewer - http://www.buraks.com/asv
package Net {

    public class FSM {

        private var _state:int;
        private var _multiper:int;
        private var _adder:int;

        public function FSM(_arg1:int, _arg2:int){
            setup(_arg1, _arg2);
        }
        public function reset():void{
            _state = 0;
        }
        public function updateState():int{
            _state = ((~(_state) + _adder) * _multiper);
            _state = (_state ^ (_state >> 16));
            return (_state);
        }
        public function getState():int{
            return (_state);
        }
        public function setup(_arg1:int, _arg2:int):void{
            _adder = _arg1;
            _multiper = _arg2;
            updateState();
        }

    }
}//package Net 
