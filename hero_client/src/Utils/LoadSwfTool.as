//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.events.*;
    import flash.display.*;
    import OopsFramework.Content.Loading.*;
    import GameUI.View.Components.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

	/**
	 *加载SWF工具类 
	 * @author wengliqiang
	 * 
	 */	
    public class LoadSwfTool {

        public var sendShow:Function;
        private var imageItem:LoadingItem;
        public var loadInfo:LoaderInfo;
        public var ComplateLoaded:Boolean;
        private var showLoading:Boolean;

        public function LoadSwfTool(_arg1:String, _arg2:Boolean=true){
            showLoading = _arg2;
            imageItem = new SwfItem((GameCommonData.GameInstance.Content.RootDirectory + _arg1), BulkLoader.TYPE_MOVIECLIP, _arg1);
            imageItem.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
            imageItem.addEventListener(Event.COMPLETE, onPicComplete);
            imageItem.load();
        }
        private function onPicComplete(_arg1:Event):void{
            imageItem = null;
            ComplateLoaded = true;
            if (showLoading){
                showLoading = false;
                LoadingView.getInstance().removeLoading();
            };
            var _local2:Object = (_arg1.target as Object);
            var _local3:MovieClip = (_local2.content.content as MovieClip);
            loadInfo = _local2.content;
            _local2.destroy();
            _local2.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
            _local2.removeEventListener(Event.COMPLETE, onPicComplete);
            if (sendShow != null){
                sendShow(_local3);
            };
            _local3 = null;
        }
        public function GetClassByMovieClip(_arg1:String):MovieClip{
            var _local2:Class;
            if (((loadInfo) && (loadInfo.applicationDomain.hasDefinition(_arg1)))){
                _local2 = (loadInfo.applicationDomain.getDefinition(_arg1) as Class);
                return (MovieClip(new (_local2)()));
            };
            return (null);
        }
        private function onProgressHandler(_arg1:Event):void{
            if (showLoading){
                LoadingView.getInstance().showLoading();
            };
        }

    }
}//package Utils 
