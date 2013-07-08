//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.interfaces {

    public interface IView {

        function notifyObservers(_arg1:INotification):void;
        function registerMediator(_arg1:IMediator):void;
        function removeMediator(_arg1:String):IMediator;
        function registerObserver(_arg1:String, _arg2:IObserver):void;
        function removeObserver(_arg1:String, _arg2:Object):void;
        function hasMediator(_arg1:String):Boolean;
        function retrieveMediator(_arg1:String):IMediator;

    }
}//package org.puremvc.as3.multicore.interfaces 
