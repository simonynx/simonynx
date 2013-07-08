//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import OopsFramework.Debug.*;

	/**
	 *URL信息 
	 * @author wengliqiang
	 * 
	 */	
    public class SmartURL {

        public var port:int;
        public var path:String;
        public var queryObject:Object;
        public var host:String;
        public var queryLength:int = 0;
        public var url:String;
        public var protocol:String;
        public var queryString:String;

        public function SmartURL(_arg1:String){
            var _local2:String;
            var _local3:String;
            var _local4:String;
            super();
            this.url = _arg1;
            var _local5:RegExp = /((?P<protocol>[a-zA-Z]+: \/\/)   (?P<host>[^:\/]*) (:(?P<port>\d+))?)?  (?P<path>[^?]*)? ((?P<query>.*))? /x;
            var _local6:* = _local5.exec(_arg1);
            if (_local6){
                protocol = (Boolean(_local6.protocol)) ? _local6.protocol : "http://";
                protocol = protocol.substr(0, protocol.indexOf("://"));
                host = ((_local6.host) || (null));
                port = (_local6.port) ? int(_local6.port) : 80;
                path = _local6.path;
                queryString = _local6.query;
                if (queryString){
                    queryObject = {};
                    queryString = queryString.substr(1);
                    for each (_local4 in queryString.split("&")) {
                        _local3 = _local4.split("=")[0];
                        _local2 = _local4.split("=")[1];
                        queryObject[_local3] = _local2;
                        queryLength++;
                    };
                };
            } else {
                Logger.Print(this, "没有配置到数据");
            };
        }
        public function toString():String{
            return (((((((((((("网址 :" + url) + ", 协议: ") + protocol) + ", 端口: ") + port) + ", 主机头: ") + host) + ", 路径: ") + path) + ". 查询字符串: ") + queryString));
        }

    }
}//package OopsFramework.Content.Loading 
