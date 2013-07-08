//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.interfaces {

    public interface IMediator extends INotifier {

        function listNotificationInterests():Array;
        function onRegister():void;
        function handleNotification(_arg1:INotification):void;
        function getMediatorName():String;
        function setViewComponent(_arg1:Object):void;
        function getViewComponent():Object;
        function onRemove():void;

    }
}//package org.puremvc.as3.multicore.interfaces 
