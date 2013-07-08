//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.interfaces {

    public interface IController {

        function registerCommand(_arg1:String, _arg2:Class):void;
        function hasCommand(_arg1:String):Boolean;
        function executeCommand(_arg1:INotification):void;
        function removeCommand(_arg1:String):void;

    }
}//package org.puremvc.as3.multicore.interfaces 
