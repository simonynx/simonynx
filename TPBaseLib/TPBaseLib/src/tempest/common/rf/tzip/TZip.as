package tempest.common.rf.tzip
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.IDataOutput;

	/**
	 *
	 * @author 吴尚坤
	 */
	public class TZip
	{
		private static const ZIP_INFO_LEN:uint = 30; //包信息长度
		private static const ZIP_FLAG:String = "TPPAK"; //包标志位
		protected var _totalLen:uint = 0;
		public var encryptMode:uint = 0; //加密模式
		protected var _filesCount:int = 0; //文件数量
		public var fileNameOffset:uint = 0; //文件头偏移
		public var fileNameLen:uint = 0; //文件头长度
		public var fileOffset:uint = 0; //文件偏移
		public var fileLen:uint = 0; //文件长度
		private var _filesList:Array; //文件列表
		private var _filesName:Dictionary; //文件列表
		private var _globalEndian:String = Endian.BIG_ENDIAN;

		/***********************************************************属性************************************************************************/
		public function get fileList():Array
		{
			return _filesList;
		}

		public function get totalLen():uint
		{
			return _totalLen;
		}

		/**
		 * 文件数量
		 * @return
		 */
		public function get filesCount():uint
		{
			return _filesList ? _filesList.length : 0;
		}

		/***********************************************************打包************************************************************************/
		public function serialize(stream:IDataOutput, compress:Boolean = false):void
		{
			if (stream != null && _filesList.length > 0)
			{
				stream.endian = _globalEndian;
				var _fileNameData:ByteArray = new ByteArray();
				var _fileData:ByteArray = new ByteArray();
				var _lastEntity:TFile = null;
				for (var i:int = 0; i < _filesList.length; i++)
				{
					var _entity:TFile = _filesList[i] as TFile;
					if (i == 0)
						_entity.offset = 0;
					else
						_entity.offset = _lastEntity.offset + _lastEntity.len;
					_fileData.writeBytes(_entity.content);
					_fileNameData.writeUTF(_entity.name);
					_fileNameData.writeUnsignedInt(_entity.len);
					_fileNameData.writeUnsignedInt(_entity.offset);
					_lastEntity = _entity;
				}
				fileNameOffset = ZIP_INFO_LEN;
				fileNameLen = _fileNameData.length;
				fileOffset = fileNameOffset + fileNameLen;
				fileLen = _fileData.length;
				_totalLen = ZIP_INFO_LEN + fileNameLen + fileLen;
				var _by:ByteArray = new ByteArray();
				_by.writeBytes(serialPakInfo());
				_by.writeBytes(_fileNameData);
				_by.writeBytes(_fileData);
				if (compress)
					_by.compress();
				stream.writeBytes(_by);
			}
		}

		public function addFile(name:String, content:ByteArray):void
		{
			if (!_filesList)
				_filesList = [];
			if (!_filesName)
				_filesName = new Dictionary();
			var _entity:TFile = new TFile();
			_entity.name = name;
			_entity.len = content.length;
			_entity.content = content;
			this._filesList.push(_entity);
			_filesCount++;
		}

		public function delFile(name:String):Boolean
		{
			for (var i:int = 0; i != _filesList.length; ++i)
			{
				if (TFile(_filesList[i]).name == name)
				{
					_filesList.splice(i, 1);
					_filesCount--;
					return true;
				}
			}
			return false;
		}

		protected function serialPakInfo():ByteArray
		{
			var _by:ByteArray = new ByteArray();
			_by.length = ZIP_INFO_LEN;
			_by.writeUTFBytes(ZIP_FLAG); //5字节
			_by.writeUnsignedInt(_totalLen); //4字节
			_by.writeByte(encryptMode); //1字节
			_by.writeUnsignedInt(_filesCount); //4字节
			_by.writeUnsignedInt(fileNameOffset); //4字节
			_by.writeUnsignedInt(fileNameLen); //4字节
			_by.writeUnsignedInt(fileOffset); //4字节
			_by.writeUnsignedInt(fileLen); //4字节
			return _by;
		}

		/***********************************************************解包************************************************************************/
		public function getFileByName(fileName:String, clear:Boolean = false):TFile
		{
			for (var i:int = 0; i < _filesList.length; i++)
			{
				if (_filesList[i].name == fileName)
				{
					var _file:TFile = _filesList[i] as TFile;
					if (clear)
					{
						_filesList.splice(i, 1);
						_filesCount--;
					}
					return _file;
				}
			}
			return null;
		}

		/**
		 * 加载包字节集
		 * @param bytes 字节集
		 * @param compress 是否压缩
		 * @return
		 */
		public function loadBytes(bytes:ByteArray, compress:Boolean = true):Boolean
		{
			try
			{
				_filesList = [];
				_filesName = new Dictionary();
				bytes.position = 0;
				bytes.endian = _globalEndian;
				if (compress)
					bytes.uncompress();
				if (!parse(bytes))
					return false;
			}
			catch (e:Error)
			{
				trace("错误的包", 0); //未压缩
				return false;
			}
			return true;
		}

		/**
		 * 解析包
		 * @param bytes
		 * @return
		 */
		protected function parse(bytes:ByteArray):Boolean
		{
			if (parseZipInfo(bytes) == false)
			{
				trace("错误的包", 1); //未压缩
				return false;
			}
			//解析文件信息
			if (this.parseFilesInfo(bytes) == false)
			{
				trace("错误的包", 2); //未压缩
				return false;
			}
			//解析文件
			if (this.parseFiles(bytes) == false)
			{
				trace("错误的包", 3); //文件读取错误
				return false;
			}
			return true;
		}

		/**
		 * 解析压缩包信息
		 * @param _data
		 * @return
		 */
		private function parseZipInfo(_data:ByteArray):Boolean
		{
			//判断最小长度
			if (_data.length < ZIP_INFO_LEN)
			{
				trace("错误的包", 101); //小于包信息大小
				return false;
			}
			//判断标志位
			if (_data.readUTFBytes(5) != ZIP_FLAG)
			{
				trace("错误的包", 102); //标志位错误
				return false;
			}
			//判断数据长度
			_totalLen = _data.readUnsignedInt();
			if (_totalLen != _data.length)
			{
				trace("错误的包", 103); //数据长度错误
				return false;
			}
			//判断加密模式
			this.encryptMode = _data.readUnsignedByte();
			//读取文件数量
			this._filesCount = _data.readUnsignedInt();
			//读取文件名偏移
			this.fileNameOffset = _data.readUnsignedInt();
			//读取文件名长度
			this.fileNameLen = _data.readUnsignedInt();
			//读取文件偏移
			this.fileOffset = _data.readUnsignedInt();
			//读取文件长度
			this._totalLen = _data.readUnsignedInt();
			return true;
		}

		/**
		 * 解析文件信息
		 * @param _data
		 * @return
		 */
		private function parseFilesInfo(bytes:ByteArray):Boolean
		{
			bytes.position = fileNameOffset;
			var _end:uint = fileNameOffset + fileNameLen;
			var _count:uint = 0;
			while (bytes.position < _end)
			{
				var _file:TFile = new TFile();
				_file.name = bytes.readUTF();
				_file.len = bytes.readUnsignedInt();
				_file.offset = bytes.readUnsignedInt();
				_filesList.push(_file);
//				_filesName[_file.name] = _file;
				++_count;
			}
			if (_count == _filesCount)
				return true;
			else
			{
				trace("错误的包", 201); //未压缩
				return false;
			}
		}

		/**
		 * 解析文件
		 * @param _data
		 * @return
		 */
		private function parseFiles(bytes:ByteArray):Boolean
		{
			for (var i:int = 0; i < _filesCount; i++)
			{
				var _file:TFile = _filesList[i] as TFile;
				bytes.position = fileOffset + _file.offset;
				_file.content = new ByteArray();
				bytes.readBytes(_file.content, 0, _file.len);
			}
			return true;
		}
	}
}
