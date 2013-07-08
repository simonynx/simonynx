//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Question.vo {

    public class QuestionVo {

        private var _questionId:int;
        private var _answerSelectsArr:Array;
        private var _startTime:Number;
        private var _title:String;
        private var _answer:int = -1;

        public function QuestionVo(){
            _answerSelectsArr = [];
            _startTime = new Date().time;
            super();
        }
        public function get questionId():int{
            return (_questionId);
        }
        public function set questionId(_arg1:int):void{
            _questionId = _arg1;
        }
        public function get answer():int{
            return (_answer);
        }
        public function get answerSelectsArr():Array{
            return (_answerSelectsArr);
        }
        public function get startTime():Number{
            return (_startTime);
        }
        public function set title(_arg1:String):void{
            _title = _arg1;
        }
        public function get title():String{
            return (_title);
        }
        public function set answer(_arg1:int):void{
            _answer = _arg1;
        }
        public function set startTime(_arg1:Number):void{
            _startTime = _arg1;
        }
        public function set answerSelectsArr(_arg1:Array):void{
            _answerSelectsArr = _arg1;
        }

    }
}//package GameUI.Modules.Question.vo 
