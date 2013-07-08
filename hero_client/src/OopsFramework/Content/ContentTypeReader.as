//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content {
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import OopsFramework.Debug.*;
    import flash.media.*;
    import OopsFramework.Exception.*;

	/**
	 *获取各种类型对象的存放器
	 * @author wengliqiang
	 * 
	 */	
    public class ContentTypeReader {

        private var referenceCount:uint = 0;
        public var Content:*;
        public var Name:String;

        public function GetXML():XML{
            return (XML(Content));
        }
        public function GetText():String{
            return (String(Content));
        }
        public function GetBitmap():Bitmap{
            return (Bitmap(Content.content));
        }
        public function GetClassByMovieClip(_arg1:String):MovieClip{
            var _local2:Class = (GetClass(_arg1) as Class);
            return (MovieClip(new (_local2)()));
        }
        public function GetMovieClip():MovieClip{
            return (MovieClip(Content.content));
        }
        public function GetDisplayObject():DisplayObject{
            return (DisplayObject(Content.content));
        }
        public function GetClassByFont(_arg1:String):Font{
            var _local2:Class = (GetClass(_arg1) as Class);
            return (Font(new (_local2)()));
        }
        public function GetClassByBitmapData(_arg1:String):BitmapData{
            var _local2:Class = (GetClass(_arg1) as Class);
            return ((new _local2(0, 0) as BitmapData));
        }
        public function GetSprite():Sprite{
            return (Sprite(Content.content));
        }
        public function GetClass(_arg1:String):Class{
            if (Content.applicationDomain.hasDefinition(_arg1)){
                return ((Content.applicationDomain.getDefinition(_arg1) as Class));
            };
            Logger.Error(this, "GetClass", ((("\"" + _arg1) + "\"") + ExceptionResources.ResourcesClassIsNull));
            throw (new Error(((("\"" + _arg1) + "\"") + ExceptionResources.ResourcesClassIsNull)));
        }
        public function get ReferenceCount():uint{
            return (referenceCount);
        }
        public function GetClassByFlashComponent(_arg1:String):Sprite{
            var _local2:Class = (GetClass(_arg1) as Class);
            return (Sprite(new (_local2)()));
        }
        public function GetClassByBitmap(_arg1:String):Bitmap{
            return (new Bitmap(this.GetClassByBitmapData(_arg1)));
        }
        public function GetByteArray():ByteArray{
            return (ByteArray(Content));
        }
        public function GetClassByButton(_arg1:String):SimpleButton{
            var _local2:Class = (GetClass(_arg1) as Class);
            return (SimpleButton(new (_local2)()));
        }
        public function GetClassBySound(_arg1:String):Sound{
            var _local2:Class = (GetClass(_arg1) as Class);
            return (Sound(new (_local2)()));
        }
        public function GetSound():Sound{
            return (Sound(Content));
        }
        public function GetClassBySprite(_arg1:String):Sprite{
            var _local2:Class = (GetClass(_arg1) as Class);
            return (Sprite(new (_local2)()));
        }

    }
}//package OopsFramework.Content 
