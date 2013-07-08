//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.interfaces {

    public interface IObserver {

        function compareNotifyContext(_arg1:Object):Boolean;
        function setNotifyContext(_arg1:Object):void;
        function setNotifyMethod(_arg1:Function):void;
        function notifyObserver(_arg1:INotification):void;

    }
}//package org.puremvc.as3.multicore.interfaces 
