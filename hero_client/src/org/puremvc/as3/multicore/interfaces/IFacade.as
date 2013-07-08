//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.interfaces {

    public interface IFacade extends INotifier {

        function removeCommand(_arg1:String):void;
        function registerCommand(_arg1:String, _arg2:Class):void;
        function removeProxy(_arg1:String):IProxy;
        function registerProxy(_arg1:IProxy):void;
        function hasMediator(_arg1:String):Boolean;
        function retrieveMediator(_arg1:String):IMediator;
        function hasCommand(_arg1:String):Boolean;
        function retrieveProxy(_arg1:String):IProxy;
        function notifyObservers(_arg1:INotification):void;
        function registerMediator(_arg1:IMediator):void;
        function removeMediator(_arg1:String):IMediator;
        function hasProxy(_arg1:String):Boolean;

    }
}//package org.puremvc.as3.multicore.interfaces 
