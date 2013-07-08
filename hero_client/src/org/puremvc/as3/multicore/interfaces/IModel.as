//Created by Action Script Viewer - http://www.buraks.com/asv
package org.puremvc.as3.multicore.interfaces {

    public interface IModel {

        function removeProxy(_arg1:String):IProxy;
        function retrieveProxy(_arg1:String):IProxy;
        function registerProxy(_arg1:IProxy):void;
        function hasProxy(_arg1:String):Boolean;

    }
}//package org.puremvc.as3.multicore.interfaces 
