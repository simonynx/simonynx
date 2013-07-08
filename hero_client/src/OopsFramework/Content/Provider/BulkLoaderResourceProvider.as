//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Provider {
    import OopsFramework.*;
    import OopsFramework.Content.*;
    import OopsFramework.Content.Loading.*;

	/**
	 *大容量数据源 
	 * @author wengliqiang
	 * 
	 */	
    public class BulkLoaderResourceProvider extends ResourceProvider {

        private var itemsTotal:uint = 0;
        private var itemsLoaded:uint = 0;
        public var LoadCompleteOne:Function = null;
        private var itemsErrored:uint = 0;
        private var download:BulkLoader = null;

		/**
		 * 
		 * @param _arg1 最大连接数
		 * @param _arg2 游戏对象
		 * 
		 */		
        public function BulkLoaderResourceProvider(_arg1:int=1, _arg2:Game=null){
            super(_arg2);
            download = new BulkLoader(_arg1);
            download.CustomTypesExtensions["mpt"] = BulkLoader.TYPE_BINARY;
            download.addEventListener(BulkProgressEvent.OPEN, onOpen);
            download.addEventListener(BulkProgressEvent.PROGRESS, onBulkProgress);
            download.addEventListener(BulkProgressEvent.COMPLETE, onBulkComplete);
            download.addEventListener(BulkProgressEvent.ERROR, onBulkError);
        }
        override public function Load():void{
            if (this.download.ItemsTotal > 0){
                this.download.Load();
                super.Load();
            } else {
                if (LoadComplete != null){
                    LoadComplete();
                };
            };
        }
        protected function onOpen(_arg1:BulkProgressEvent):void{
        }
        protected function onBulkProgress(_arg1:BulkProgressEvent):void{
        }
        protected function onBulkComplete(_arg1:BulkProgressEvent):void{
            var _local2:ContentTypeReader = new ContentTypeReader();
            _local2.Name = _arg1.Item.name;
            _local2.Content = _arg1.Item.content;
            addResource(_local2);
            if (LoadCompleteOne != null){
                LoadCompleteOne(_local2);
            };
            BulkCompleteAll(_arg1);
        }
        private function BulkCompleteAll(_arg1:BulkProgressEvent):void{
            itemsLoaded = _arg1.ItemsLoaded;
            itemsTotal = _arg1.ItemsTotal;
            if (itemsTotal == (itemsLoaded + itemsErrored)){
                Download.removeEventListener(BulkProgressEvent.OPEN, onOpen);
                Download.removeEventListener(BulkProgressEvent.PROGRESS, onBulkProgress);
                Download.removeEventListener(BulkProgressEvent.COMPLETE, onBulkComplete);
                Download.removeEventListener(BulkProgressEvent.ERROR, onBulkError);
                this.isLoaded = true;
                onBulkCompleteAll();
            };
        }
        public function get Download():BulkLoader{
            return (this.download);
        }
        protected function onBulkError(_arg1:BulkProgressEvent):void{
            itemsErrored++;
            BulkCompleteAll(_arg1);
            trace("onBulkError,load....出错");
        }
        protected function onBulkCompleteAll():void{
            this.Download.Dispose();
            if (LoadComplete != null){
                LoadComplete();
            };
        }
        public function dispose():void{
            if (Download){
                Download.removeEventListener(BulkProgressEvent.OPEN, onOpen);
                Download.removeEventListener(BulkProgressEvent.PROGRESS, onBulkProgress);
                Download.removeEventListener(BulkProgressEvent.COMPLETE, onBulkComplete);
                Download.removeEventListener(BulkProgressEvent.ERROR, onBulkError);
                Download.Dispose();
                download = null;
            };
        }

    }
}//package OopsFramework.Content.Provider 
