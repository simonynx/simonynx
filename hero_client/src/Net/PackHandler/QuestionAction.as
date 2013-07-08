//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import Net.*;
    import GameUI.Modules.Question.model.*;
    import GameUI.Modules.Question.vo.*;

    public class QuestionAction extends GameAction {

        private static var _instance:QuestionAction;

        public function QuestionAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():QuestionAction{
            if (_instance == null){
                _instance = new (QuestionAction)();
            };
            return (_instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_QUESTION_START:
                    Ready(_arg1);
                    break;
                case Protocol.SMSG_CURRENT_QUESTION:
                    Next(_arg1);
                    break;
                case Protocol.SMSG_QUESTION_SPECIAL:
                    useSpecialResult(_arg1);
                    break;
                case Protocol.SMSG_RESULT_AND_LIST:
                    ResultAndRanklist(_arg1);
                    break;
                case Protocol.SMSG_CURRENT_SCORE:
                    ScoreChangeHandler(_arg1);
                    break;
                case Protocol.SMSG_GET_CURRENT_QUESTION:
                    GetMyQuestinfo(_arg1);
                    break;
            };
        }
        private function Next(_arg1:NetPacket):void{
            var _local2:QuestionVo = new QuestionVo();
            _local2.questionId = _arg1.readByte();
            _local2.startTime = _arg1.readUnsignedInt();
            _local2.title = _arg1.ReadString();
            _local2.answerSelectsArr[0] = _arg1.ReadString();
            _local2.answerSelectsArr[1] = _arg1.ReadString();
            _local2.answerSelectsArr[2] = _arg1.ReadString();
            _local2.answerSelectsArr[3] = _arg1.ReadString();
            facade.sendNotification(QuestionEvents.QUESTION_NEXT, _local2);
        }
        private function ResultAndRanklist(_arg1:NetPacket):void{
            var _local6:uint;
            var _local7:String;
            var _local8:uint;
            var _local2:uint = _arg1.readByte();
            var _local3:uint = _arg1.readByte();
            var _local4:uint = _arg1.readByte();
            QuestionConstData.rankLists = [];
            var _local5:uint;
            while (_local5 < _local4) {
                _local6 = _arg1.readUnsignedInt();
                _local7 = _arg1.ReadString();
                _local8 = _arg1.readUnsignedInt();
                QuestionConstData.rankLists.unshift({
                    playerId:_local6,
                    name:_local7,
                    score:_local8
                });
                _local5++;
            };
            QuestionConstData.rankLists.sortOn("score", (Array.NUMERIC | Array.DESCENDING));
            facade.sendNotification(QuestionEvents.QUESTION_RESULT, {
                questIdx:_local2,
                answer:(_local3 - 1)
            });
            facade.sendNotification(QuestionEvents.QUESTION_UPDATERANKLIST);
        }
        private function ScoreChangeHandler(_arg1:NetPacket):void{
            QuestionConstData.currentScore = _arg1.readUnsignedInt();
        }
        private function Ready(_arg1:NetPacket):void{
            facade.sendNotification(QuestionEvents.QUESTION_REDAY);
        }
        private function GetMyQuestinfo(_arg1:NetPacket):void{
            var _local3:uint;
            var _local2:QuestionVo = new QuestionVo();
            _local2.questionId = _arg1.readByte();
            if (_local2.questionId >= 1){
                _local2.startTime = _arg1.readUnsignedInt();
                QuestionConstData.currentScore = _arg1.readUnsignedInt();
                _local3 = QuestionConstData.currentScore;
                QuestionConstData.useDoubleCnt = _arg1.readUnsignedInt();
                QuestionConstData.useBribeCnt = _arg1.readUnsignedInt();
                _local2.title = _arg1.ReadString();
                _local2.answerSelectsArr[0] = _arg1.ReadString();
                _local2.answerSelectsArr[1] = _arg1.ReadString();
                _local2.answerSelectsArr[2] = _arg1.ReadString();
                _local2.answerSelectsArr[3] = _arg1.ReadString();
                QuestionConstData.currentQuestion = _local2;
                facade.sendNotification(QuestionEvents.QUESTION_NEXT, _local2);
            } else {
                if (_local2.questionId == 0){
                    facade.sendNotification(QuestionEvents.QUESTION_REDAY);
                };
            };
        }
        private function useSpecialResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readByte();
            var _local3:int = _arg1.readByte();
            facade.sendNotification(QuestionEvents.QUESTION_USESPECIAL_RESULT, _local3);
        }

    }
}//package Net.PackHandler 
