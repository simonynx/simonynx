//Created by Action Script Viewer - http://www.buraks.com/asv
package Net {
    import flash.utils.*;
    import flash.net.*;

	/**
	 *服务器返回的包数据类 
	 * @author wengliqiang
	 * 
	 */	
    public class NetPacket extends ByteArray {

        private var _encrypted:uint;
        public var m_compressed:Boolean;
        private var m_opcode:int;
        private var m_remaining:uint;
        private var m_offset:uint;
        private var _send_fsm:FSM;
        private var _receive_fsm:FSM;
        private var m_localbuffer:ByteArray;
        private var m_length:uint;

        public function NetPacket(_arg1:uint=0){
            _encrypted = _arg1;
            m_opcode = -1;
            m_length = 0;
            m_remaining = 0;
            this.endian = "littleEndian";
            m_localbuffer = new ByteArray();
            m_localbuffer.endian = "littleEndian";
            if (_encrypted == 2){
                _send_fsm = new FSM(2059198199, 1501);
                _receive_fsm = new FSM(2059198199, 1501);
            };
        }
        public function get opcode():int{
            return (m_opcode);
        }
        public function get len():uint{
            return (this.m_length);
        }
        public function set opcode(_arg1){
            m_opcode = _arg1;
        }
        public function ReadPacket(_arg1:Socket){
            var _local2:int;
            var _local3:int;
            if (m_remaining == 0){
                this.length = 0;
                if (_arg1.bytesAvailable >= 4){
                    if (_encrypted == 2){
                        _local2 = _receive_fsm.getState();
                        _local3 = 0;
                        _local2 = ((_local2 & (0xFF << 16)) >> 16);
                        m_localbuffer.length = 0;
                        _arg1.readBytes(m_localbuffer, 0, 4);
                        _local3 = 0;
                        while (_local3 < m_localbuffer.length) {
                            m_localbuffer[_local3] = (m_localbuffer[_local3] ^ _local2);
                            _local3++;
                        };
                        m_localbuffer.position = 0;
                        m_length = m_localbuffer.readUnsignedShort();
                        m_opcode = m_localbuffer.readUnsignedShort();
                        m_remaining = m_length;
                        m_offset = 0;
                    } else {
                        m_length = _arg1.readUnsignedShort();
                        m_opcode = _arg1.readUnsignedShort();
                        m_remaining = m_length;
                        m_offset = 0;
                    };
                    if (m_remaining > 31078){
                        throw (new Error(((("收到的数据包大于1m，不应该出现.大小:" + m_remaining.toString()) + "类型:") + m_opcode.toString())));
                    };
                    if (m_remaining == 0){
                        if (_encrypted == 2){
                            _receive_fsm.updateState();
                        };
                        return (true);
                    };
                };
            };
            if (m_remaining > 0){
                if (_arg1.bytesAvailable < m_remaining){
                    m_remaining = (m_remaining - _arg1.bytesAvailable);
                    _arg1.readBytes(this, m_offset, _arg1.bytesAvailable);
                    m_offset = this.bytesAvailable;
                    return (false);
                };
                _arg1.readBytes(this, m_offset, m_remaining);
                m_remaining = 0;
                if (_encrypted == 2){
                    _receive_fsm.updateState();
                };
                return (true);
            };
        }
        public function get packlen():int{
            return (m_length);
        }
        public function ReadString():String{
            var _local1:* = 0;
            var _local2:* = this.position;
            while (_local2 < this.length) {
                if (this[_local2] == 0){
                    _local1 = ((_local2 - this.position) + 1);
                    break;
                };
                _local2++;
            };
            if (_local1 > 0){
                return (this.readMultiByte(_local1, "cn-gb"));
            };
            return ("");
        }
        public function readDate():Date{
            return (new Date(readShort(), (readByte() - 1), readByte(), readByte(), readByte(), readByte()));
        }
        public function WriteString(_arg1:String){
            this.writeMultiByte(_arg1, "cn-gb");
            this.writeByte(0);
        }
        public function Flush(_arg1:Socket){
            var _local3:int;
            var _local4:int;
            var _local2:Socket = _arg1;
            if (_encrypted == 2){
                m_localbuffer.length = 0;
                m_localbuffer.writeShort(this.length);
                m_localbuffer.writeShort(m_opcode);
                _local3 = _send_fsm.getState();
                _local4 = 0;
                while (_local4 < m_localbuffer.length) {
                    _local2.writeByte((m_localbuffer[_local4] ^ ((_local3 & (0xFF << 16)) >> 16)));
                    _local4++;
                };
                _local4 = 0;
                while (_local4 < this.length) {
                    _local2.writeByte((this[_local4] ^ ((_local3 & (0xFF << 16)) >> 16)));
                    _local4++;
                };
                _send_fsm.updateState();
            } else {
                _local2.endian = "littleEndian";
                _local2.writeShort(this.length);
                _local2.writeShort(m_opcode);
                _local2.writeBytes(this);
            };
            _local2.flush();
            this.length = 0;
        }

    }
}//package Net 
