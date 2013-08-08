package br.com.stimuli.loading
{
	import br.com.stimuli.loading.loadingtypes.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.*;
	import tempest.common.logging.*;

	[Event(name = "progress", type = "br.com.stimuli.loading.BulkProgressEvent")];
	[Event(name = "complete", type = "br.com.stimuli.loading.BulkProgressEvent")];
	[Event(name = "error", type = "events.ErrorEvent")];
	/**
	 *   多项目和多格式加载管理类
	   var bulkLoader : BulkLoader = new BulkLoader("main loading");
	   // 添加一个要加载的物体
	   bulkLoader.add("my_xml_file.xml");
	   bulkLoader.add("main.swf");
	   // 通过URL加载
	   var backgroundURL : URLRequest = new URLRequest("background.jpg");
	   bulkLoader.add(backgroundURL);

	   // 加载完成事件!
	   bulkLoader.addEventListener(BulkLoader.COMPLETE, onCompleteHandler);
	   // 加载事件:
	   bulkLoader.addEventListener(BulkLoader.PROGRESS, _onProgressHandler);

	   // 开始加载所有物品
	   bulkLoader.start();

	   function _onProgressHandler(evt : ProgressEvent) : void{
	   trace("Loaded" , evt.bytesLoaded," of ",  evt.bytesTotal);
	   }

	   function onCompleteHandler(evt : ProgressEvent) : void{
	   trace("All items are loaded and ready to consume");
	   // 获取主影片剪辑:
	   var mainMovie : MovieClip = bulkLoader.getMovieClip("main.swf");
	   // Get the xml object:
	   var mXML : XML = bulkLoader.getXML("my_xml_file.xml");
	   // grab the bitmap for the background image by a string:
	   var myBitmap : Bitmap = bulkLoader.getBitmap("background.jpg");
	   // grab the bitmap for the background image using the url request object:
	   var myBitmap : Bitmap = bulkLoader.getBitmap(backgroundURL);
	   }

	   // In any other class you can access those assets without having to pass around references to the bulkLoader instance.
	   // In another class  you get get a reference to the "main loading" bulkLoader:
	   var mainLoader : BulkLoader = BulkLoader.getLoader("main loading");
	   // now grab the xml:
	   var mXML : XML = mainLoader.getXML("my_xml_file.xml");
	   // or shorter:
	   var mXML : XML = BulkLoader.getLoader("main loading").getXML("my_xml_file.xml");
	 *    </listing>
	 *   @langversion ActionScript 3.0
	 *   @playerversion Flash 9.0
	 *
	 *   @author Arthur Debert
	 *   @since  15.09.2007
	 */
	public class BulkLoader extends EventDispatcher
	{
		private var log:ILogger;
		/**
		 * 版本 用于调试
		 **/
		public static const VERSION:String = "$Id: BulkLoader.as 321 2010-04-10 19:11:05Z debert $";
		/**
		 * 二进制字节流
		 */
		public static const TYPE_BINARY:String = "binary";
		/**
		 * 图形
		 */
		public static const TYPE_IMAGE:String = "image";
		/**
		 * 影片剪切
		 */
		public static const TYPE_MOVIECLIP:String = "movieclip";
		/**
		 * 声音
		 */
		public static const TYPE_SOUND:String = "sound";
		/**
		 * 文本
		 */
		public static const TYPE_TEXT:String = "text";
		/**
		 * XML
		 */
		public static const TYPE_XML:String = "xml";
		/**
		 * 影片
		 */
		public static const TYPE_VIDEO:String = "video";
		/**
		 *获取相关类型
		 */
		public static const AVAILABLE_TYPES:Array = [TYPE_VIDEO, TYPE_XML, TYPE_TEXT, TYPE_SOUND, TYPE_MOVIECLIP, TYPE_IMAGE, TYPE_BINARY];
		/**
		 * 所有支持的扩展名集合
		 * 有效类型: swf, jpg, jpeg, gif, png. */
		public static var AVAILABLE_EXTENSIONS:Array = ["swf", "jpg", "jpeg", "gif", "png", "flv", "mp3", "xml", "txt", "js"];
		/**
		 * 加载图片自动使用的后缀
		 * 有效类型: swf, jpg, jpeg, gif, png, image.
		 */
		public static var IMAGE_EXTENSIONS:Array = ["jpg", "jpeg", "gif", "png"];
		/**
		 *加载影片剪辑自动使用的后缀
		 */
		public static var MOVIECLIP_EXTENSIONS:Array = ['swf'];
		/**
		 * 加载文本自动使用的后缀
		 * 有效类型: txt, js, xml, php, asp .
		 */
		public static var TEXT_EXTENSIONS:Array = ["txt", "js", "php", "asp", "py"];
		/**
		 * 加载影片自动使用的后缀
		 * 有效类型: flv, f4v, f4p.
		 */
		public static var VIDEO_EXTENSIONS:Array = ["flv", "f4v", "f4p", "mp4"];
		/**
		 * 加载声音自动使用的后缀
		 * List of file extensions that will be automagically treated as sound for loading.
		 *  Availabe types: mp3, f4a, f4b.
		 */
		public static var SOUND_EXTENSIONS:Array = ["mp3", "f4a", "f4b"];
		/**
		 *加载XML自动使用的后缀
		 * @default
		 */
		public static var XML_EXTENSIONS:Array = ["xml"];
		/** @private */
		private static var _customTypesExtensions:Object;
		/**
		 * 进度事件
		 *   The name of the event
		 *   @eventType progress
		 */
		public static const PROGRESS:String = "progress";
		/**
		 * 完成事件
		 *   @eventType complete
		 */
		public static const COMPLETE:String = "complete";
		/**
		 *   The name of the event
		 *   @eventType httpStatus
		 */
		public static const HTTP_STATUS:String = "httpStatus";
		/**
		 * 错误事件
		 *   @eventType error
		 */
		public static const ERROR:String = "error";
		/**
		 *  安全错误事件
		 *   @eventType securityError
		 */
		public static const SECURITY_ERROR:String = "securityError";
		/**
		 * 打开事件
		 *   The name of the event
		 *   @eventType error
		 */
		public static const OPEN:String = "open";
		/**
		 * 可以开始播放事件
		 *   The name of the event
		 *   @eventType error
		 */
		public static const CAN_BEGIN_PLAYING:String = "canBeginPlaying";
		/**
		 *检查策略文件
		 * @default
		 */
		public static const CHECK_POLICY_FILE:String = "checkPolicyFile";
		/**
		 * 防止缓存
		 * If <code>true</code> a random query (or post data parameter) will be added to prevent caching. Checked when adding a new item to load.
		 * @see #add()
		 */
		public static const PREVENT_CACHING:String = "preventCache";
		/**
		 *  An array of RequestHeader objects to be used when contructing the <code>URLRequest</code> object. If the <code>url</code> parameter is passed as a <code>URLRequest</code> object it will be ignored. Checked when adding a new item to load.
		 * @see #add()
		 */
		public static const HEADERS:String = "headers";
		/**
		 *  An object definig the loading context for this load operario. If this item is of <code>TYPE_SOUND</code>, a <code>SoundLoaderContext</code> is expected. If it's a <code>TYPE_IMAGE</code> a LoaderContext should be passed. Checked when adding a new item to load.
		 * @see #add()
		 */
		public static const CONTEXT:String = "context";
		/** A <code>String</code> to be used to identify an item to load, can be used in any method that fetches content (as the key parameters), stops, removes and resume items. Checked when adding a new item to load.
		 * @see #add()
		 * @see #getContent()
		 * @see #pause()
		 * @see #resume()
		 * @see #removeItem()
		 */
		public static const ID:String = "id";
		public static const PRIORITY:String = "priority";
		public static const MAX_TRIES:String = "maxTries";
		public static const WEIGHT:String = "weight";
		public static const PAUSED_AT_START:String = "pausedAtStart";
		public static const GENERAL_AVAILABLE_PROPS:Array = [WEIGHT, MAX_TRIES, HEADERS, ID, PRIORITY, PREVENT_CACHING, "type"];
		protected var _name:String;
		protected var _id:int;
		protected static var _instancesCreated:int = 0;
		protected var _items:Array = [];
		protected var _contents:Dictionary = new Dictionary(true);
		protected static var _allLoaders:Object = {};
		protected var _additionIndex:int = 0;
		public static const DEFAULT_NUM_CONNECTIONS:int = 12;
		protected var _numConnections:int = DEFAULT_NUM_CONNECTIONS;
		public var maxConnectionsPerHost:int = 2;
		private var _connections:Object;
		private var _loadedRatio:Number = 0;
		/** @private */
		private var _itemsTotal:int = 0;
		/**  @private        */
		private var _itemsLoaded:int = 0;
		/** @private
		 */
		private var _totalWeight:int = 0;
		/** @private
		 */
		private var _bytesTotal:int = 0;
		/** @private
		 */
		private var _bytesTotalCurrent:int = 0;
		/** @private
		 */
		private var _bytesLoaded:int = 0;
		/** @private
		 */
		private var _percentLoaded:Number = 0;
		/** @private
		 */
		private var _weightPercent:Number;
		/**The average latency (in miliseconds) for the entire loading.*/
		public var avgLatency:Number;
		/**The average speed (in kb/s) for the entire loading.*/
		public var speedAvg:Number;
		/** @private
		 */
		private var _speedTotal:Number;
		/** @private
		 */
		private var _startTime:int;
		/** @private
		 */
		private var _endTIme:int;
		/** @private
		 */
		private var _lastSpeedCheck:int;
		/** @private
		 */
		private var _lastBytesCheck:int;
		/** @private */
		private var _speed:Number;
		/**Time in seconds for the whole loading. Only available after everything is laoded*/
		public var totalTime:Number;
		/** @private */
		protected var _allowsAutoIDFromFileName:Boolean = false;
		/** @private */
		private var _isRunning:Boolean;
		/** @private */
		private var _isFinished:Boolean;
		/** @private */
		private var _isPaused:Boolean = true;
		/** @private */
		private var _stringSubstitutions:Object;
		/** @private */
		private static var _typeClasses:Object = {image: ImageItem, movieclip: ImageItem, xml: XMLItem, video: VideoItem, sound: SoundItem, text: URLItem, binary: BinaryItem};

		/** Creates a new BulkLoader object identifiable by the <code>name</code> parameter. The <code>name</code> parameter must be unique, else an Error will be thrown.
		 *
		 *   @param name  A name that can be used later to reference this loader in a static context. If null, bulkloader will generate a unique name.
		 *   @param  numConnections The number of maximum simultaneous connections to be open.
		 *   @param  logLevel At which level should traces be outputed. By default only errors will be traced.
		 *
		 *   @see #numConnections
		 *   @see #log()
		 */
		public function BulkLoader(name:String = null, numConnections:int = BulkLoader.DEFAULT_NUM_CONNECTIONS, logLevel:int = TLog.LEVEL_ERROR)
		{
			if (!name)
			{
				name = getUniqueName();
			}
			if (Boolean(_allLoaders[name]))
			{
				__debug_print_loaders();
				throw new Error("BulkLoader with name'" + name + "' has already been created.");
			}
			else if (!name)
			{
				throw new Error("Cannot create a BulkLoader instance without a name");
			}
			_allLoaders[name] = this;
			if (numConnections > 0)
			{
				this._numConnections = numConnections;
			}
			log = TLog.getLogger("br.com.stimuli.loading.BulkLoader", logLevel);
			_name = name;
			_instancesCreated++;
			_id = _instancesCreated;
			_additionIndex = 0;
			// we create a mock event listener for errors, else Unhandled errors will bubble and display an stack trace to the end user:
			addEventListener(BulkLoader.ERROR, _swallowError, false, 1, true);
		}

		/**
		 * 创建一个具有唯一名称的BulkLoader实例
		 *  Creates a BulkLoader instance with an unique name. This is useful for situations where you might be creating
		 *   many BulkLoader instances and it gets tricky to garantee that no other instance is using that name.
		 *   @param  numConnections 开放的同时连接的最大数 	默认为DEFAULT_NUM_CONNECTIONS=12
		 *   @param  logLevel 输入的日志等级 默认为DEFAULT_LOG_LEVEL=LOG_ERRORS=4
		 *   @return 返回一个BulkLoader实例
		 */
		public static function createUniqueNamedLoader(numConnections:int = BulkLoader.DEFAULT_NUM_CONNECTIONS, logLevel:int = TLog.LEVEL_ERROR):BulkLoader
		{
			return new BulkLoader(BulkLoader.getUniqueName(), numConnections, logLevel);
		}

		/**
		 * 获取唯一名称
		 * @return
		 */
		public static function getUniqueName():String
		{
			return "BulkLoader-" + _instancesCreated;
		}

		/**
		 * 根据名字获取一个BulkLoader实例
		 * Fetched a <code>BulkLoader</code> object created with the <code>name</code> parameter.
		 *   This is usefull if you must access loades assets from another scope, without having to pass direct references to this loader.
		 *   @param  name The name of the loader to be fetched.
		 *   @return The BulkLoader instance that was registred with that name. Returns null if none is found.
		 */
		public static function getLoader(name:String):BulkLoader
		{
			return BulkLoader._allLoaders[name] as BulkLoader;
		}

		/**
		 * 获取或创建加载器
		 * @param name
		 * @return
		 */
		public static function getOrCreateLoader(name:String = null, numConnections:int = BulkLoader.DEFAULT_NUM_CONNECTIONS, logLevel:int = TLog.LEVEL_ERROR):BulkLoader
		{
			var _loader:BulkLoader = getLoader(name);
			return (_loader == null) ? new BulkLoader(name, numConnections, logLevel) : _loader;
		}

		/**
		 * BulkLoader中是否包含键
		 * @param key
		 * @param atLoader
		 * @return
		 */
		public static function _hasItemInBulkLoader(key:*, atLoader:BulkLoader):Boolean
		{
			var item:LoadingItem = atLoader.get(key);
			if (item && item._isLoaded)
			{
				return true;
			}
			return false;
		}

		/**
		 * BulkLoader中是否包含该对象
		 * Checks if there is <b>loaded</b> item in this <code>BulkLoader</code>.
		 * @param    The url (as a <code>String</code> or a <code>URLRequest</code> object)or an id (as a <code>String</code>) by which the item is identifiable.
		 * @param    是否搜索所有的BulkLoader  False只搜索当前BulkLoader  默认为True
		 * @return   True if a loader has a <b>loaded</b> item stored.
		 */
		public function hasItem(key:*, searchAll:Boolean = true):Boolean
		{
			var loaders:*;
			if (searchAll)
			{
				loaders = _allLoaders;
			}
			else
			{
				loaders = [this];
			}
			for each (var l:BulkLoader in loaders)
			{
				if (_hasItemInBulkLoader(key, l))
					return true;
			}
			return false;
		}

		/**
		 * 检查哪个BulkLoader包含该对象
		 * Checks which <code>BulkLoader</code> has an item by the given key.
		 * @param    The url (as a <code>String</code> or a <code>URLRequest</code> object)or an id (as a <code>String</code>) by which the item is identifiable.
		 * @return   The <code>BulkLoader</code> instance that has the given key or <code>null</code> if no key if found in any loader.
		 */
		public static function whichLoaderHasItem(key:*):BulkLoader
		{
			for each (var l:BulkLoader in _allLoaders)
			{
				if (BulkLoader._hasItemInBulkLoader(key, l))
					return l;
			}
			return null;
		}

		/**
		 * 添加一个要被加载的资源
		 * Adds a new assets to be loaded. The <code>BulkLoader</code> object will manage diferent assets type. If the right type cannot be infered from the url termination (e.g. the url ends with ".swf") the BulkLoader will relly on the <code>type</code> property of the <code>props</code> parameter. If both are set, the <code>type</code>  property of the props object will overrite the one defined in the <code>url</code>. In case none is specified and the url won't hint at it, the type <code>TYPE_TEXT</code> will be used.
		 *
		 *   @param url String OR URLRequest A <code>String</code> or a <code>URLRequest</code> instance.
		 *   @param props An object specifing extra data for this loader. The following properties are supported:<p/>
		 *   <table>
		 *       <th>Property name</th>
		 *       <th>Class constant</th>
		 *       <th>Data type</th>
		 *       <th>Description</th>
		 *       <tr>
		 *           <td>preventCache</td>
		 *           <td><a href="#PREVENT_CACHING">PREVENT_CACHING</a></td>
		 *           <td><code>Boolean</code></td>
		 *           <td>If <code>true</code> a random query string will be added to the url (or a post param in case of post reuquest).</td>
		 *       </tr>
		 *       <tr>
		 *           <td>id</td>
		 *           <td><a href="#ID">ID</a></td>
		 *           <td><code>String</code></td>
		 *           <td>A string to identify this item. This id can be used in any method that uses the <code>key</code> parameter, such as <code>pause, removeItem, resume, getContent, getBitmap, getBitmapData, getXML, getMovieClip and getText</code>.</td>
		 *       </tr>
		 *       <tr>
		 *           <td>priority</td>
		 *           <td><a href="#PRIORITY">PRIORITY</a></td>
		 *           <td><code>int</code></td>
		 *           <td>An <code>int</code> used to order which items till be downloaded first. Items with a higher priority will download first. For items with the same priority they will be loaded in the same order they've been added.</td>
		 *       </tr>
		 *       <tr>
		 *           <td>maxTries</td>
		 *           <td><a href="#MAX_TRIES">MAX_TRIES</a></td>
		 *           <td><code>int</code></td>
		 *           <td>The number of retries in case the lading fails, defaults to 3.</td>
		 *       </tr>
		 *       <tr>
		 *           <td>weight</td>
		 *           <td><a href="#WEIGHT">WEIGHT</a></td>
		 *           <td><code>int</code></td>
		 *           <td>A number that sets an arbitrary relative size for this item. See #weightPercent.</td>
		 *       </tr>
		 *       <tr>
		 *           <td>headers</td>
		 *           <td><a href="#HEADERS">HEADERS</a></td>
		 *           <td><code>Array</code></td>
		 *           <td>An array of <code>RequestHeader</code> objects to be used when constructing the URL. If the <code>url</code> parameter is passed as a string, <code>BulkLoader</code> will use these request headers to construct the url.</td>
		 *       </tr>
		 *       <tr>
		 *           <td>context</td>
		 *           <td><a href="#CONTEXT">CONTEXT</a></td>
		 *           <td><code>LoaderContext or SoundLoaderContext</code></td>
		 *           <td>An object definig the loading context for this load operario. If this item is of <code>TYPE_SOUND</code>, a <code>SoundLoaderContext</code> is expected. If it's a <code>TYPE_IMAGE</code> a LoaderContext should be passed.</td>
		 *       </tr>
		 *       <tr>
		 *           <td>pausedAtStart</td>
		 *           <td><a href="#PAUSED_AT_START">PAUSED_AT_START</a></td>
		 *           <td><code>Boolean</code></td>
		 *           <td>If true, the nestream will be paused when loading has begun.</td>
		 *       </tr>
		 *   </table>
		 *   You can use string substitutions (variable expandsion).
		 *   @example Retriving contents:<listing v="3.0">
		   import br.stimuli.loaded.BulkLoader;
		   var bulkLoader : BulkLoader = new BulkLoader("main");
		   // simple item:
		   bulkLoader.add("config.xml");
		   // use an id that can be retirved latterL
		   bulkLoader.add("background.jpg", {id:"bg"});
		   // or use a static var to have auto-complete and static checks on your ide:
		   bulkLoader.add("background.jpg", {BulkLoader.ID:"bg"});
		   // loads the languages.xml file first and parses before all items are done:
		   public function parseLanguages() : void{
		   var theLangXML : XML = bulkLoader.getXML("langs");
		   // do something wih the xml:
		   doSomething(theLangXML);
		   }
		   bulkLoader.add("languages.xml", {priority:10, onComplete:parseLanguages, id:"langs"});
		   // Start the loading operation with only 3 simultaneous connections:
		   bulkLoader.start(3)
		   </listing>
		 *    @see #stringSubstitutions
		 *
		 */
		public function add(url:*, props:Object = null):LoadingItem
		{
			if (!_name)
			{
				throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
			}
			if (!url || !String(url))
			{
				throw new Error("[BulkLoader] Cannot add an item with a null url");
			}
			props = props || {};
			if (url is String)
			{
				url = new URLRequest(BulkLoader.substituteURLString(url, _stringSubstitutions));
				if (props[HEADERS])
				{
					url.requestHeaders = props[HEADERS];
				}
			}
			else if (!url is URLRequest)
			{
				throw new Error("[BulkLoader] cannot add object with bad type for url:'" + url.url);
			}
			var item:LoadingItem = get(props[ID]);
			// have already loaded this?
			if (item)
			{
				log.debug("Add received an already added id: " + props[ID] + ", not adding a new item");
				return item;
			}
			var type:String;
			if (props["type"])
			{
				type = props["type"].toLowerCase();
				// does this type exist?
				if (AVAILABLE_TYPES.indexOf(type) == -1)
				{
					log.warn("add received an unknown type:" + type + " and will cast it to text");
				}
			}
			if (!type)
			{
				type = guessType(url.url);
			}
			_additionIndex++;
			item = new _typeClasses[type](url, type, _instancesCreated + "_" + String(_additionIndex));
			if (!props["id"] && _allowsAutoIDFromFileName)
			{
				props["id"] = getFileName(url.url);
				log.debug("Adding automatic id from file name for item:" + item + "( id= " + props["id"] + " )");
			}
			var errors:Array = item._parseOptions(props);
			for each (var error:String in errors)
			{
				log.warn(error);
			}
			log.debug("Added", item);
			// properties from the props argument
			item._addedTime = getTimer();
			item._additionIndex = _additionIndex;
			// add a lower priority than default, else the event for all items complete will fire before
			// individual listerners attached to the item
			item.addEventListener(Event.COMPLETE, _onItemComplete, false, int.MIN_VALUE, true);
			// need an extra event listener to increment items loaded, because this must happen
			// **before** the item's normal event, or else client code will get a dummy value for it
			item.addEventListener(Event.COMPLETE, _incrementItemsLoaded, false, int.MAX_VALUE, true);
			item.addEventListener(ERROR, _onItemError, false, 0, true);
			item.addEventListener(Event.OPEN, _onItemStarted, false, 0, true);
			item.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, 0, true);
			_items.push(item);
			_itemsTotal += 1;
			_totalWeight += item.weight;
			sortItemsByPriority();
			_isFinished = false;
			if (!_isPaused)
			{
				_loadNext();
			}
			return item;
		}

		/**
		 * 开始加载
		 * Start loading all items added previously
		 *   @param  withConnections  指定同时加载的最大数  默认-1 [optional]The maximum number of connections to make at the same time. If specified, will override the parameter passed (if any) to the constructor.
		 *   @see #numConnections
		 *   @see #see #BulkLoader()
		 */
		public function start(withConnections:int = -1):void
		{
			if (withConnections > 0)
			{
				_numConnections = withConnections;
			}
			if (_connections)
			{
				_loadNext();
				return;
			}
			_startTime = getTimer();
			_connections = {};
			_loadNext();
			_isRunning = true;
			_lastBytesCheck = 0;
			_lastSpeedCheck = getTimer();
			_isPaused = false;
		}

		/**
		 * 重新加载指定对象
		 * Forces the item specified by key to be reloaded right away. This will stop any open connection as needed.
		 *   @param key The url request, url as a string or a id  from which the asset was created.
		 *   @return <code>True</code> if an item with that key is found, <code>false</code> otherwise.
		 */
		public function reload(key:*):Boolean
		{
			var item:LoadingItem = get(key);
			if (!item)
			{
				return false;
			}
			_removeFromItems(item);
			_removeFromConnections(item);
			item.stop();
			item.cleanListeners();
			item.status = null;
			_isFinished = false;
			item._addedTime = getTimer();
			item._additionIndex = _additionIndex++;
			item.addEventListener(Event.COMPLETE, _onItemComplete, false, int.MIN_VALUE, true);
			item.addEventListener(Event.COMPLETE, _incrementItemsLoaded, false, int.MAX_VALUE, true);
			item.addEventListener(ERROR, _onItemError, false, 0, true);
			item.addEventListener(Event.OPEN, _onItemStarted, false, 0, true);
			item.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, 0, true);
			_items.push(item);
			_itemsTotal += 1;
			_totalWeight += item.weight;
			sortItemsByPriority();
			_isFinished = false;
			loadNow(item);
			return true;
		}

		/**
		 * 立即加载文件
		 * Forces the item specified by key to be loaded right away. This will stop any open connection as needed.
		 *   If needed, the connection to be closed will be the one with the lower priority. In case of a tie, the one
		 *   that has more bytes to complete will be removed. The item to load now will be automatically be set the highest priority value in this BulkLoader instance.
		 *   @param key The url request, url as a string or a id  from which the asset was created.
		 *   @return <code>True</code> if an item with that key is found, <code>false</code> otherwise.
		 */
		public function loadNow(key:*):Boolean
		{
			var item:LoadingItem = get(key);
			if (!item)
			{
				return false;
			}
			if (!_connections)
			{
				_connections = {};
			}
			// is this item already loaded or loading?
			if (item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STARTED)
			{
				return true;
			}
			// do we need to remove an item from the open connections?
			if (_getNumConnections() >= numConnections || _getNumConnectionsForItem(item) >= maxConnectionsPerHost)
			{
				//which item should we remove?
				var itemToRemove:LoadingItem = _getLeastUrgentOpenedItem();
				pause(itemToRemove);
				_removeFromConnections(itemToRemove);
				itemToRemove.status = null;
			}
			// update the item's piority so that subsequent calls to loadNow don't close a
			// connection we've just started to load
			item._priority = highestPriority;
			_loadNext(item);
			return true;
		}

		/** @private
		 *   Figures out which item to remove from open connections, comparation is done by priority
		 *   and then by bytes remaining
		 */
		private function _getLeastUrgentOpenedItem():LoadingItem
		{
			// TODO: make sure we remove from the righ hostname
			var itemsToLoad:Array = _getAllConnections();
			itemsToLoad.sortOn(["priority", "bytesRemaining", "_additionIndex"], [Array.NUMERIC, Array.DESCENDING, Array.NUMERIC, Array.NUMERIC])
			var toRemove:LoadingItem = LoadingItem(itemsToLoad[0]);
			return toRemove;
		}

		/**
		 * 注册一种新的文件类型
		 * Register a new file extension to be loaded as a given type. This is used both in the guessing of types from the url and affects how loading is done for each type.
		 *   If you are adding an extension to be of a type you are creating, you must pass the <code>withClass</code> parameter, which should be a class that extends LoadingItem.
		 *   @param  extension   扩展名 The file extension to be used (can include the dot or not)
		 *   @param  atType      这个扩展名关联哪种类型 Which type this extension will be associated with.
		 *   @param  withClass   类 For new types (not new extensions) wich class that extends LoadingItem should be used to mange this item.
		 *   @see #TYPE_IMAGE
		 *   @see #TYPE_VIDEO
		 *   @see #TYPE_SOUND
		 *   @see #TYPE_TEXT
		 *   @see #TYPE_XML
		 *   @see #TYPE_MOVIECLIP
		 *   @see #LoadingItem
		 *
		 *   @return A <code>Boolean</code> indicating if the new extension was registered.
		 */
		public static function registerNewType(extension:String, atType:String, withClass:Class = null):Boolean
		{
			// Normalize extension
			if (extension.charAt(0) == ".")
				extension = extension.substring(1);
			if (!_customTypesExtensions)
				_customTypesExtensions = {};
			atType = atType.toLowerCase();
			// Is this a new type?
			if (AVAILABLE_TYPES.indexOf(atType) == -1)
			{
				// new type: we need a class for that:
				if (!Boolean(withClass))
				{
					throw new Error("[BulkLoader]: When adding a new type and extension, you must determine which class to use");
				}
				// add that class to the available classes
				_typeClasses[atType] = withClass;
				if (!_customTypesExtensions[atType])
				{
					_customTypesExtensions[atType] = [];
					AVAILABLE_TYPES.push(atType);
				}
				_customTypesExtensions[atType].push(extension);
				return true;
			}
			else
			{
				// do have this exension registred for this type?
				if (_customTypesExtensions[atType])
					_customTypesExtensions[atType].push(extension);
			}
			var extensions:Array;
			var options:Object = {};
			options[TYPE_IMAGE] = IMAGE_EXTENSIONS;
			options[TYPE_MOVIECLIP] = MOVIECLIP_EXTENSIONS;
			options[TYPE_VIDEO] = VIDEO_EXTENSIONS;
			options[TYPE_SOUND] = SOUND_EXTENSIONS;
			options[TYPE_TEXT] = TEXT_EXTENSIONS;
			options[TYPE_XML] = XML_EXTENSIONS;
			extensions = options[atType];
			if (extensions && extensions.indexOf(extension) == -1)
			{
				extensions.push(extension);
				return true;
			}
			return false;
		}

		/**
		 *
		 * @return
		 */
		private function _getNextItemToLoad():LoadingItem
		{
			// check for "stale items"
			_getAllConnections().forEach(function(i:LoadingItem, ... rest):void
			{
				if (i.status == LoadingItem.STATUS_ERROR && i.numTries >= i.maxTries)
				{
					_removeFromConnections(i);
				}
			});
			for each (var checkItem:LoadingItem in _items)
			{
				if (!checkItem._isLoading && checkItem.status != LoadingItem.STATUS_STOPPED && _canOpenConnectioForItem(checkItem))
				{
					return checkItem;
				}
			}
			return null;
		}

		// if toLoad is specified it will take precedence over whoever is queued cut line
		/** @private */
		private function _loadNext(toLoad:LoadingItem = null):Boolean
		{
			if (_isFinished)
			{
				return false;
			}
			if (!_connections)
			{
				_connections = {};
			}
			var next:Boolean = false;
			toLoad = toLoad || _getNextItemToLoad();
			if (toLoad)
			{
				next = true;
				_isRunning = true;
				// need to check again, as _loadNext might have been called with an item to be loaded forcefully.
				if (_canOpenConnectioForItem(toLoad))
				{
					var connectionsForItem:Array = _getConnectionsForHostName(toLoad.hostName);
					connectionsForItem.push(toLoad);
					toLoad.load();
					//trace("begun loading", toLoad.url.url);//, _getNumConnectionsForItem(toLoad) + "/" + maxConnectionsPerHost, _getNumConnections() + "/" + numConnections);
					log.info("Will load item:" + toLoad);
				}
				// if we've got any more connections to open, load the next item
				if (_getNextItemToLoad())
				{
					_loadNext();
				}
			}
			return next;
		}

		/** @private */
		private function _onItemComplete(evt:Event):void
		{
			var item:LoadingItem = evt.target as LoadingItem;
			_removeFromConnections(item);
			log.info("Loaded " + item);
			log.debug("Items to load" + getNotLoadedItems());
			item.cleanListeners();
			_contents[item.url.url] = item.content;
			var next:Boolean = _loadNext();
			var allDone:Boolean = _isAllDoneP();
			if (allDone)
			{
				_onAllLoaded();
			}
			evt.stopPropagation();
		}

		/** @private
		 */
		private function _incrementItemsLoaded(evt:Event):void
		{
			_itemsLoaded++;
		}

		/** @private */
		private function _updateStats():void
		{
			avgLatency = 0;
			speedAvg = 0;
			var totalLatency:Number = 0;
			var totalBytes:int = 0;
			_speedTotal = 0;
			var num:Number = 0;
			for each (var item:LoadingItem in _items)
			{
				if (item._isLoaded && item.status != LoadingItem.STATUS_ERROR)
				{
					totalLatency += item.latency;
					totalBytes += item.bytesTotal;
					num++;
				}
			}
			_speedTotal = (totalBytes / 1024) / totalTime;
			avgLatency = totalLatency / num;
			speedAvg = _speedTotal / num;
		}

		/** @private */
		private function _removeFromItems(item:LoadingItem):Boolean
		{
			var removeIndex:int = _items.indexOf(item);
			if (removeIndex > -1)
			{
				_items.splice(removeIndex, 1);
			}
			else
			{
				return false;
			}
			if (item._isLoaded)
			{
				_itemsLoaded--;
			}
			_itemsTotal--;
			_totalWeight -= item.weight;
			log.debug("Removing " + item);
			item.removeEventListener(Event.COMPLETE, _onItemComplete, false)
			item.removeEventListener(Event.COMPLETE, _incrementItemsLoaded, false)
			item.removeEventListener(ERROR, _onItemError, false);
			item.removeEventListener(Event.OPEN, _onItemStarted, false);
			item.removeEventListener(ProgressEvent.PROGRESS, _onProgress, false);
			return true;
		}

		/** @private */
		private function _removeFromConnections(item:*):Boolean
		{
			if (!_connections || _getNumConnectionsForItem(item) == 0)
				return false;
			var connectionsForHost:Array = _getConnectionsForHostName(item.hostName);
			(item);
			var removeIndex:int = connectionsForHost.indexOf(item);
			if (removeIndex > -1)
			{
				connectionsForHost.splice(removeIndex, 1);
				return true;
			}
			return false;
		}

		/**
		 *
		 * @param hostname
		 * @return
		 */
		private function _getNumConnectionsForHostname(hostname:String):int
		{
			var conns:Array = _getConnectionsForHostName(hostname);
			if (!conns)
			{
				return 0;
			}
			return conns.length;
		}

		/** @private */
		private function _getNumConnectionsForItem(item:LoadingItem):int
		{
			var conns:Array = _getConnectionsForHostName(item.hostName);
			(item);
			if (!conns)
			{
				return 0;
			}
			return conns.length;
		}

		/** @private */
		private function _getAllConnections():Array
		{
			var conns:Array = [];
			for (var hostname:String in _connections)
			{
				conns = conns.concat(_connections[hostname]);
			}
			return conns;
		}

		/** @private **/
		private function _getNumConnections():int
		{
			var connections:int = 0;
			for (var hostname:String in _connections)
			{
				connections += _connections[hostname].length;
			}
			return connections;
		}

		/**
		 *
		 * @param hostname
		 * @return
		 */
		private function _getConnectionsForHostName(hostname:String):Array
		{
			if (_connections[hostname] == null)
			{
				_connections[hostname] = [];
			}
			return _connections[hostname];
		}

		/**
		 *
		 * @param item
		 * @return
		 */
		private function _canOpenConnectioForItem(item:LoadingItem):Boolean
		{
			if (_getNumConnections() >= numConnections)
				return false;
			if (_getNumConnectionsForItem(item) >= maxConnectionsPerHost)
				return false;
			return true;
		}

		/** @private */
		private function _onItemError(evt:ErrorEvent):void
		{
			var item:LoadingItem = evt.target as LoadingItem;
			_removeFromConnections(item);
			log.error("After " + item.numTries + " I am giving up on " + item.url.url);
			log.error("Error loading" + item + evt.text);
			_loadNext();
			//evt.stopPropagation();
			//evt.currentTarget = item;
			dispatchEvent(evt);
		}

		/** @private */
		private function _onItemStarted(evt:Event):void
		{
			var item:LoadingItem = evt.target as LoadingItem;
			log.info("Started loading" + item);
			dispatchEvent(evt);
		}

		/** @private */
		private function _onProgress(evt:Event = null):void
		{
			// TODO: check these values are correct! tough _onProgress
			var e:BulkProgressEvent = getProgressForItems(_items);
			// update values:
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			_weightPercent = e.weightPercent;
			_percentLoaded = e.percentLoaded;
			_bytesTotalCurrent = e.bytesTotalCurrent;
			_loadedRatio = e.ratioLoaded;
			dispatchEvent(e);
		}

		/**
		 * 计算指定文件进度
		 * Calculates the progress for a specific set of items.
		 *   @param keys An <code>Array</code> containing keys (ids or urls) or <code>LoadingItem</code> objects to measure progress of.
		 *   @return A <code>BulkProgressEvent</code> object with the current progress status.
		 *   @see BulkProgressEvent
		 */
		public function getProgressForItems(keys:Array):BulkProgressEvent
		{
			_bytesLoaded = _bytesTotal = _bytesTotalCurrent = 0;
			var localWeightPercent:Number = 0;
			var localWeightTotal:int = 0;
			var itemsStarted:int = 0;
			var localWeightLoaded:Number = 0;
			var localItemsTotal:int = 0;
			var localItemsLoaded:int = 0;
			var localBytesLoaded:int = 0;
			var localBytesTotal:int = 0;
			var localBytesTotalCurrent:int = 0;
			var item:LoadingItem;
			var theseItems:Array = [];
			for each (var key:* in keys)
			{
				item = get(key);
				if (!item)
					continue;
				localItemsTotal++;
				localWeightTotal += item.weight;
				if (item.status == LoadingItem.STATUS_STARTED || item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STOPPED)
				{
					localBytesLoaded += item._bytesLoaded;
					localBytesTotalCurrent += item._bytesTotal;
					if (item._bytesTotal > 0)
					{
						localWeightLoaded += (item._bytesLoaded / item._bytesTotal) * item.weight;
					}
					if (item.status == LoadingItem.STATUS_FINISHED)
					{
						localItemsLoaded++;
					}
					itemsStarted++;
				}
			}
			// only set bytes total if all items have begun loading
			if (itemsStarted != localItemsTotal)
			{
				localBytesTotal = Number.POSITIVE_INFINITY;
			}
			else
			{
				localBytesTotal = localBytesTotalCurrent;
			}
			localWeightPercent = localWeightLoaded / localWeightTotal;
			if (localWeightTotal == 0)
				localWeightPercent = 0;
			var e:BulkProgressEvent = new BulkProgressEvent(PROGRESS);
			e.setInfo(localBytesLoaded, localBytesTotal, localBytesTotal, localItemsLoaded, localItemsTotal, localWeightPercent);
			return e;
		}

		/**
		 * 获取当前连接数
		 * The number of simultaneous connections to use. This is per <code>BulkLoader</code> instance.
		 *   @return The number of connections used.
		 *   @see #start()
		 */
		public function get numConnections():int
		{
			return _numConnections;
		}

		/**
		 * Returns an object where the urls are the keys(as strings) and the loaded contents are the value for that key.
		 *  Each value is typed as * an the client must check for the right typing.
		 *   @return An object hashed by urls, where values are the downloaded content type of each url. The user mut cast as apropriate.
		 */
		public function get contents():Object
		{
			return _contents;
		}

		/**
		 * Returns a copy of all <code>LoadingItem</code> in this intance. This function makes a copy to avoid
		 *   users messing with _items (removing items and so forth). Those can be done through functions in BulkLoader.
		 *   @return A array that is a shallow copy of all items in the BulkLoader.
		 */
		public function get items():Array
		{
			return _items.slice();
		}

		/**
		 * 获取加载器名字
		 * The name by which this loader instance can be identified.
		 * This property is used so you can get a reference to this instance from other classes in your code without having to save and pass it yourself, throught the static method BulkLoader.getLoader(name) .<p/>
		 * Each name should be unique, as instantiating a BulkLoader with a name already taken will throw an error.
		 * @see #getLoaders()
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * 获取所有文件加载比率
		 *   The ratio (0->1) of items to load / items total.
		 *   This number is always reliable.
		 **/
		public function get loadedRatio():Number
		{
			return _loadedRatio;
		}

		/**
		 * 获取所有加载的文件个数
		 * Total number of items to load.*/
		public function get itemsTotal():int
		{
			return items.length;
		}

		/**
		 * 加载完成的文件个数
		 *   Number of items alrealdy loaded.
		 *   Failed or canceled items are not taken into consideration
		 */
		public function get itemsLoaded():int
		{
			return _itemsLoaded;
		}

		/**
		 *设置加载完成文件个数
		 * @param value
		 */
		public function set itemsLoaded(value:int):void
		{
			_itemsLoaded = value;
		}

		/**
		 * 获取所有加载项目的权重总和
		 * The sum of weights in all items to load.
		 *   Each item's weight default to 1
		 */
		public function get totalWeight():int
		{
			return _totalWeight;
		}

		/**
		 * 获取加载的字节总数
		 * The total bytes to load.
		 *   If the number of items to load is larger than the number of simultaneous connections, bytesTotal will be 0 untill all connections are opened and the number of bytes for all items is known.
		 *   @see #bytesTotalCurrent
		 */
		public function get bytesTotal():int
		{
			return _bytesTotal;
		}

		/**
		 * 获取每个文件加载的字节总数
		 * The sum of all bytesLoaded for each item.
		 */
		public function get bytesLoaded():int
		{
			return _bytesLoaded;
		}

		/**
		 * 获取现在已经加载的字节总数
		 *  The sum of all bytes loaded so far.
		 *  If itemsTotal is less than the number of connections, this will be the same as bytesTotal. Else, bytesTotalCurrent will be available as each loading is started.
		 *   @see #bytesTotal
		 */
		public function get bytesTotalCurrent():int
		{
			return _bytesTotalCurrent;
		}

		/**
		 * 获取当前加载字节的百分比
		 * The percentage (0->1) of bytes loaded.
		 *   Until all connections are opened  this number is not reliable . If you are downloading more items than the number of simultaneous connections, use loadedRatio or weightPercent instead.
		 *   @see #loadedRatio
		 *   @see #weightPercent
		 */
		public function get percentLoaded():Number
		{
			return _percentLoaded;
		}

		/**
		 *  The weighted percent of items loaded(0->1).
		 *   This always returns a reliable value.
		 */
		public function get weightPercent():Number
		{
			return _weightPercent;
		}

		/**
		 * 获取是否正在加载
		 * A boolean indicating if the instace has started and has not finished loading all items
		 */
		public function get isRunning():Boolean
		{
			return _isRunning;
		}

		/**
		 *获取是否加载完成
		 * @return
		 */
		public function get isFinished():Boolean
		{
			return _isFinished;
		}

		/**
		 * 获取最高优先级
		 * Returns the highest priority for all items in this BulkLoader instance. This will check all items,
		 *   including cancelled items and already downloaded items.
		 */
		public function get highestPriority():int
		{
			var highest:int = int.MIN_VALUE;
			for each (var item:LoadingItem in _items)
			{
				if (item.priority > highest)
					highest = item.priority;
			}
			return highest;
		}

		/**
		 * 获取是否根据文件名字自动生成ID
		 * Determines if an autmatic id created from the file name. If true, when adding and item and NOT specifing an "id" props
		 *   for its properties, an id with the file name will be created altomatically.
		 *   @example Automatic id:<listing v="3.0">
		 *   bulkLoader.allowsAutoIDFromFileName = false;
		 *   var item : LoadingItem = bulkLoader.add("background.jpg")
		 *   trace(item.id) //  outputs: null
		 *   // now if allowsAutoIDFromFileName is set to true:
		 *   bulkLoader.allowsAutoIDFromFileName = true;
		 *   var item : LoadingItem = bulkLoader.add("background.jpg")
		 *   trace(item.id) //  outputs: background
		 *   // if you pass an id on the props, it will take precedence over auto created ids:
		 *   bulkLoader.allowsAutoIDFromFileName = id;
		 *   var item : LoadingItem = bulkLoader.add("background.jpg", {id:"small-bg"})
		 *   trace(item.id) //  outputs: small-bg
		 *   </listing>
		 */
		public function get allowsAutoIDFromFileName():Boolean
		{
			return _allowsAutoIDFromFileName;
		}

		/**
		 *设置是否根据文件名字自动生成ID
		 * @param value
		 */
		public function set allowsAutoIDFromFileName(value:Boolean):void
		{
			_allowsAutoIDFromFileName = value;
		}

		/**
		 * 返回没有完全加载的文件列表
		 *  Returns items that haven't been fully loaded.
		 *   @return An array with all LoadingItems not fully loaded.
		 */
		public function getNotLoadedItems():Array
		{
			return _items.filter(function(i:LoadingItem, ... rest):Boolean
			{
				return i.status != LoadingItem.STATUS_FINISHED;
			});
		}

		/**
		 * 获取速度 Kbps
		 *Returns the speed in kilobytes / second for all loadings
		 * @return
		 */
		public function get speed():Number
		{
			// TODO: test get speed
			var timeElapsed:int = getTimer() - _lastSpeedCheck;
			var bytesDelta:int = (bytesLoaded - _lastBytesCheck) / 1024;
			var speed:int = bytesDelta / (timeElapsed / 1000);
			_lastSpeedCheck = timeElapsed;
			_lastBytesCheck = bytesLoaded;
			return speed;
		}

		/**
		 * 获取bulkLoader ID
		 * The id of this bulkLoader instance
		 */
		public function get id():int
		{
			return _id;
		}

		/**
		 * 使用别名
		 * The object, used as a hashed to substitute variables specified on the url used in <code>add</code>.
		 *   Allows to keep common part of urls on one spot only. If later the server path changes, you can
		 *   change only the stringSubstitutions object to update all items.
		 *   This has to be set before the <code>add</code> calls are made, or else strings won't be expanded.
		 *   @example Variable sustitution:<listing v="3.0">
		 *   // All webservices will be at a common path:
		 *   bulkLoader.stringSubstitutions = {
		 *       "web_services": "http://somesite.com/webservices"
		 *   }
		 *   bulkLoader.add("{web_services}/getTime");
		 *   // this will be expanded to http://somesite.com/webservices/getTime
		 *
		 *   </listing>
		 *   The format expected is {var_name} , where var_name is composed of alphanumeric characters and the underscore. Other characters (., *, [, ], etc) won't work, as they'll clash with the regex used in matching.
		 *   @see #add
		 */
		public function get stringSubstitutions():Object
		{
			return _stringSubstitutions;
		}

		/**
		 *使用别名
		 * @param value
		 */
		public function set stringSubstitutions(value:Object):void
		{
			_stringSubstitutions = value;
		}

		/**
		 * 改变文件的优先级
		 * Updates the priority of item identified by key with a new value, the queue will be re resorted right away.
		 *   Changing priorities will not stop currently opened connections.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded.
		 *   @param new The priority to assign to the item.
		 *   @return The <code>true</code> if an item with that key was found, <code>false</code> othersiwe.
		 */
		public function changeItemPriority(key:String, newPriority:int):Boolean
		{
			var item:LoadingItem = get(key);
			if (!item)
			{
				return false;
			}
			item._priority = newPriority;
			sortItemsByPriority();
			return true;
		}

		/**
		 * 根据优先级排序
		 *  Updates the priority queue
		 */
		public function sortItemsByPriority():void
		{
			// addedTime might not be precise, if subsequent add() calls are whithin getTimer precision
			// range, so we use _additionIndex
			_items.sortOn(["priority", "_additionIndex"], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC]);
		}

		/* ============================================================================== */
		/* = Acessing content functions                                                 = */
		/* ============================================================================== */
		/** @private Helper functions to get loaded content. All helpers will be casted to the specific types. If a cast fails it will throw an error.
		 *
		 */
		private function _getContentAsType(key:*, type:Class, clearMemory:Boolean = false):*
		{
			if (!_name)
			{
				throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
			}
			var item:LoadingItem = get(key);
			if (!item)
			{
				return null;
			}
			try
			{
				if (item._isLoaded || item.isStreamable() && item.status == LoadingItem.STATUS_STARTED)
				{
					var res:* = item.content as type;
					if (res == null)
					{
						throw new Error("bad cast");
					}
					if (clearMemory)
					{
						remove(key);
						// this needs to try to load a next item, because this might get called inside a
						// complete handler and if it's on the last item on the open connections, it might stale
						if (!_isPaused)
						{
							_loadNext();
						}
					}
					return res;
				}
			}
			catch (e:Error)
			{
				log.error("Failed to get content with url: '" + key + "'as type:" + type);
			}
			return null;
		}

		/**
		 * 获取未知类型资源内容
		 * Returns an untyped object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded.
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url
		 */
		public function getContent(key:String, clearMemory:Boolean = false):*
		{
			return _getContentAsType(key, Object, clearMemory);
		}

		/**
		 * 获取XML资源
		 * Returns an XML object with the downloaded asset for the given key.
		 *   @param  key          String OR URLRequest     The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a XML object. Returns null if the cast fails.
		 */
		public function getXML(key:*, clearMemory:Boolean = false):XML
		{
			return XML(_getContentAsType(key, XML, clearMemory));
		}

		/**
		 * 获取文本资源
		 * Returns a String object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a String object. Returns null if the cast fails.
		 */
		public function getText(key:*, clearMemory:Boolean = false):String
		{
			return String(_getContentAsType(key, String, clearMemory));
		}

		/**
		 * 获取声音资源
		 * Returns a Sound object with the downloaded asset for the given key.
		 *   @param  key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param  clearMemory  Boolean    If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a Sound object. Returns null if the cast fails.
		 */
		public function getSound(key:*, clearMemory:Boolean = false):Sound
		{
			return Sound(_getContentAsType(key, Sound, clearMemory));
		}

		/**
		 * 获取位图资源
		 * Returns a Bitmap object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a Bitmap object. Returns null if the cast fails.
		 */
		public function getBitmap(key:String, clearMemory:Boolean = false):Bitmap
		{
			return Bitmap(_getContentAsType(key, Bitmap, clearMemory));
		}

		/**
		 * 获取可视对象资源
		 * Returns a Loader object with the downloaded asset for the given key.
		 * Had to pick this ugly name since <code>getLoader</code> is currently used for getting a BulkLoader instance.
		 * This is useful if you are loading images but do not have a crossdomain to grant you permissions. In this case, while you
		 * will still find restrictions to how you can use that loaded asset (no BitmapData for it, for example), you still can use it as content.
		 *
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a Loader object. Returns null if the cast fails.
		 */
		public function getDisplayObjectLoader(key:String, clearMemory:Boolean = false):Loader
		{
			if (!_name)
			{
				throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
			}
			var item:ImageItem = get(key) as ImageItem;
			if (!item)
			{
				return null;
			}
			try
			{
				var res:Loader = item.loader as Loader;
				if (!res)
				{
					throw new Error("bad cast");
				}
				if (clearMemory)
				{
					remove(key);
					// this needs to try to load a next item, because this might get called inside a
					// complete handler and if it's on the last item on the open connections, it might stale
					if (!_isPaused)
					{
						_loadNext();
					}
				}
				return res;
			}
			catch (e:Error)
			{
				log.error("Failed to get content with url: '" + key + "'as type: Loader");
			}
			return null;
		}

		/**
		 * 获取影片剪辑资源
		 * Returns a <code>MovieClip</code> object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a MovieClip object. Returns null if the cast fails.
		 */
		public function getMovieClip(key:String, clearMemory:Boolean = false):MovieClip
		{
			return MovieClip(_getContentAsType(key, MovieClip, clearMemory));
		}

		/**
		 * 获取Sprite资源
		 * Returns a <code>Sprite</code> object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a Sprite object. Returns null if the cast fails.
		 */
		public function getSprite(key:String, clearMemory:Boolean = false):Sprite
		{
			return Sprite(_getContentAsType(key, Sprite, clearMemory));
		}

		/**
		 * 获取AVM1影片资源
		 *  Returns a <code>AVM1Movie</code> object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a AVM1Movie object. Returns null if the cast fails.
		 */
		public function getAVM1Movie(key:String, clearMemory:Boolean = false):AVM1Movie
		{
			return AVM1Movie(_getContentAsType(key, AVM1Movie, clearMemory));
		}

		/**
		 * 获取流媒体资源
		 * Returns a <code>NetStream</code> object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a NetStream object. Returns null if the cast fails.
		 */
		public function getNetStream(key:String, clearMemory:Boolean = false):NetStream
		{
			return NetStream(_getContentAsType(key, NetStream, clearMemory));
		}

		/**
		 * 获取流媒体元数据资源
		 * Returns a <code>Object</code> with meta data information for a given <code>NetStream</code> key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The meta data object downloaded with this NetStream. Returns null if the given key does not resolve to a NetStream.
		 */
		public function getNetStreamMetaData(key:String, clearMemory:Boolean = false):Object
		{
			var netStream:NetStream = getNetStream(key, clearMemory);
			return (Boolean(netStream) ? (get(key) as Object).metaData : null);
		}

		/**
		 * 获取位图数据资源
		 * Returns an BitmapData object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails. Does not clone the original bitmap data from the bitmap asset.
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a BitmapData object. Returns null if the cast fails.
		 */
		public function getBitmapData(key:*, clearMemory:Boolean = false):BitmapData
		{
			try
			{
				return getBitmap(key, clearMemory).bitmapData;
			}
			catch (e:Error)
			{
				log.error("Failed to get bitmapData with url:" + key);
			}
			return null;
		}

		/**
		 * 获取字节集资源
		 * Returns an ByteArray object with the downloaded asset for the given key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the cast fails.
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @return The content retrived from that url casted to a ByteArray object. Returns null if the cast fails.
		 */
		public function getBinary(key:*, clearMemory:Boolean = false):ByteArray
		{
			return ByteArray(_getContentAsType(key, ByteArray, clearMemory));
		}

		/**
		 * 获取序列化数据资源
		 * Returns a object decoded from a string, by a given encoding function.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded. Returns null if the encoding fails
		 *   @param clearMemory If this <code>BulkProgressEvent</code> instance should clear all references to the content of this asset.
		 *   @param encodingFunction A <code>Function</code> object to be passed the string and be encoded into an object.
		 *   @return The content retrived from that url encoded by encodingFunction
		 */
		public function getSerializedData(key:*, clearMemory:Boolean = false, encodingFunction:Function = null):*
		{
			try
			{
				var raw:* = _getContentAsType(key, Object, clearMemory);
				var parsed:* = encodingFunction.apply(null, [raw]);
				return parsed;
			}
			catch (e:Error)
			{
				log.error("Failed to parse key:", key, "with encodingFunction:" + encodingFunction);
			}
			return null;
		}

		/**
		 * 获取HttpStatus
		 * Gets a class definition from a fully qualified path. Note that this will only work if you've loaded the swf with the same LoaderContext of the other swf
		   (using "context" prop on "add"). Else you should use <code><imageItem>.getClassByName</code> instead.
		   @param className The fully qualified class name as a string.
		   @return The <code>Class</code> object with that name or null of not found.
		 */
		//        public function getClassByName(className : String) : Class{
		//            try{
		//                return getDefinitionByName(className) as Class;
		//            }catch(e : Error){
		//
		//            }
		//            return null;
		//        }
		/** Gets the http status code for the loading item identified by key.
		 *   @param key The url request, url as a string or a id  from which the asset was loaded.
		 *   @return The Http status as an integer. If no item is found returns -1. If the http status cannot be determined but the item was found, returns 0.
		 */
		public function getHttpStatus(key:*):int
		{
			var item:LoadingItem = get(key);
			if (item)
			{
				return item.httpStatus;
			}
			return -1;
		}

		/** @private  */
		private function _isAllDoneP():Boolean
		{
			return _items.every(function(item:LoadingItem, ... rest):Boolean
			{
				return item._isLoaded;
			});
		}

		/** @private  */
		private function _onAllLoaded():void
		{
			if (_isFinished)
			{
				return;
			}
			var eComplete:BulkProgressEvent = new BulkProgressEvent(COMPLETE);
			eComplete.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, _itemsLoaded, itemsTotal, weightPercent);
			var eProgress:BulkProgressEvent = new BulkProgressEvent(PROGRESS);
			eProgress.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, _itemsLoaded, itemsTotal, weightPercent);
			_isRunning = false;
			_endTIme = getTimer();
			totalTime = BulkLoader.truncateNumber((_endTIme - _startTime) / 1000);
			_updateStats();
			_connections = {};
			getStats();
			_isFinished = true;
			log.info("Finished all");
			dispatchEvent(eProgress);
			dispatchEvent(eComplete);
		}

		/**
		 * 获取进度信息
		 * If the <code>logLevel</code> if lower that <code>LOG_ERRORS</code>(3). Outputs a host of statistics about the loading operation
		 *   @return A formated string with loading statistics.
		 *   @see #LOG_ERRORS
		 *   @see #logLevel
		 */
		public function getStats():String
		{
			var stats:Array = [];
			stats.push("\n************************************");
			stats.push("All items loaded(" + itemsTotal + ")");
			stats.push("Total time(s):       " + totalTime);
			stats.push("Average latency(s):  " + truncateNumber(avgLatency));
			stats.push("Average speed(kb/s): " + truncateNumber(speedAvg));
			stats.push("Median speed(kb/s):  " + truncateNumber(_speedTotal));
			stats.push("KiloBytes total:     " + truncateNumber(bytesTotal / 1024));
			var itemsInfo:Array = _items.map(function(item:LoadingItem, ... rest):String
			{
				return "\t" + item.getStats();
			});
			stats.push(itemsInfo.join("\n"))
			stats.push("************************************");
			var statsString:String = stats.join("\n");
			log.debug(statsString);
			return statsString;
		}

		/**
		 * 根据KEY获取一个加载的对象
		 * Used  to fetch an item with a given key. The returned <code>LoadingItem</code> can be used to attach event listeners for the individual items (<code>Event.COMPLETE, ProgressEvent.PROGRESS, Event.START</code>).
		 *   @param key A url (as a string or urlrequest) or an id to fetch
		 *   @return The corresponding <code>LoadingItem</code> or null if one isn't found.
		 */
		public function get(key:*):LoadingItem
		{
			if (!key)
				return null;
			if (key is LoadingItem)
				return key;
			for each (var item:LoadingItem in _items)
			{
				if (item._id == key || item._parsedURL.rawString == key || item.url == key || (key is URLRequest && item.url.url == key.url))
				{
					return item;
				}
			}
			return null;
		}

		/**
		 * 根据KEY移出一个资源
		 * This will delete this item from memory. It's content will be inaccessible after that.
		 *   @param key A url (as a string or urlrequest) or an id to fetch
		 *   @param internalCall If <code>remove</code> has been called internally. End user code should ignore this.
		 *   @return <code>True</code> if an item with that key has been removed, and <code>false</code> othersiwe.
		 *   */
		public function remove(key:*, internalCall:Boolean = false):Boolean
		{
			try
			{
				var item:LoadingItem = get(key);
				if (!item)
				{
					return false;
				}
				_removeFromItems(item);
				_removeFromConnections(item);
				item.destroy();
				delete _contents[item.url.url];
				// this has to be checked, else a removeAll will trigger events for completion
				if (internalCall)
				{
					return true;
				}
				item = null;
				// checks is removing this item we are done?
				_onProgress();
				var allDone:Boolean = _isAllDoneP();
				if (allDone)
				{
					_onAllLoaded();
				}
				return true;
			}
			catch (e:Error)
			{
				log.error("Error while removing item from key:" + key, e.getStackTrace());
			}
			return false;
		}

		/**
		 * 删除所有加载的对象
		 * Deletes all loading and loaded objects. This will stop all connections and delete from the cache all of it's items (no content will be accessible if <code>removeAll</code> is executed).
		 */
		public function removeAll():void
		{
			for each (var item:LoadingItem in _items.slice())
			{
				remove(item, true);
			}
			_items = [];
			_connections = {};
			_contents = new Dictionary(true);
			_percentLoaded = _weightPercent = _loadedRatio = 0;
		}

		/**
		 * 删除该加载器
		 * Removes this instance from the static Register of instances. After a clear method has been called for a given instance, nothing else should work
		 */
		public function clear():void
		{
			removeAll();
			delete _allLoaders[name];
			_name = null;
		}

		/**
		 * 删除所有加载器
		 * Deletes all content from all instances of <code>BulkLoader</code> class. This will stop any pending loading operations as well as free memory.
		 *   @see #removeAll()
		 */
		public static function removeAllLoaders():void
		{
			for each (var atLoader:BulkLoader in _allLoaders)
			{
				atLoader.removeAll();
				atLoader.clear();
				atLoader = null;
			}
			_allLoaders = {};
		}

		/**
		 * 移出所有停止的项目
		 * Removes all items that have been stopped.
		 *   After removing, it will try to restart loading if there are still items to load.
		 *   @ return <code>True</code> if any items have been removed, <code>false</code> otherwise.
		 */
		public function removePausedItems():Boolean
		{
			var stoppedLoads:Array = _items.filter(function(item:LoadingItem, ... rest):Boolean
			{
				return (item.status == LoadingItem.STATUS_STOPPED);
			});
			stoppedLoads.forEach(function(item:LoadingItem, ... rest):void
			{
				remove(item);
			});
			_loadNext();
			return stoppedLoads.length > 0;
		}

		/**
		 * 移出所有未加载成功的项目
		 *  Removes all items that have not succesfully loaded.
		 *   After removing, it will try to restart loading if there are still items to load.
		 *   @ return In any items have been removed.
		 */
		public function removeFailedItems():int
		{
			var numCleared:int = 0;
			var badItems:Array = _items.filter(function(item:LoadingItem, ... rest):Boolean
			{
				return (item.status == LoadingItem.STATUS_ERROR);
			});
			numCleared = badItems.length;
			badItems.forEach(function(item:LoadingItem, ... rest):void
			{
				remove(item);
			});
			_loadNext();
			return numCleared;
		}

		/**
		 * 获取发生错误的项目
		 * Get all items that have an error (either IOError or SecurityError).
		 * @ return An array with the LoadingItem objects that have failed.
		 */
		public function getFailedItems():Array
		{
			return _items.filter(function(item:LoadingItem, ... rest):Boolean
			{
				return (item.status == LoadingItem.STATUS_ERROR);
			});
		}

		/**
		 * 停止一个正在加载的项目
		 * Stop loading the item identified by <code>key</code>. This will not remove the item from the <code>BulkLoader</code>. Note that progress notification will jump around, as the stopped item will still count as something to load, but it's byte count will be 0.
		 * @param key The key (url as a string, url as a <code>URLRequest</code> or an id as a <code>String</code>).
		 * @param loadsNext If it should start loading the next item.
		 * @return A <code>Boolean</code> indicating if the object has been stopped.
		 */
		public function pause(key:*, loadsNext:Boolean = false):Boolean
		{
			var item:LoadingItem = get(key);
			if (!item)
			{
				return false;
			}
			if (item.status != LoadingItem.STATUS_FINISHED)
			{
				item.stop();
			}
			log.info("STOPPED ITEM:" + item)
			var result:Boolean = _removeFromConnections(item);
			if (loadsNext)
			{
				_loadNext();
			}
			return result;
		}

		/**
		 * 停止所有正在加载的项目
		 *  Stops loading all items of this <code>BulkLoader</code> instance. This does not clear or remove items from the qeue.
		 */
		public function pauseAll():void
		{
			for each (var item:LoadingItem in _items)
			{
				pause(item);
			}
			_isRunning = false;
			_isPaused = true;
			log.info("Stopping all items");
		}

		/**
		 * 停止所有加载器
		 * Stops loading all items from all <code>BulkLoader</code> instances.
		 *   @see #stopAllItems()
		 *   @see #stopItem()
		 */
		public static function pauseAllLoaders():void
		{
			for each (var atLoader:BulkLoader in _allLoaders)
			{
				atLoader.pauseAll();
			}
		}

		/**
		 * 恢复一个暂停加载的项目
		 * Resumes loading of the item. Depending on the environment the player is running, resumed items will be able to use partialy downloaded content.
		 *   @param  key The url request, url as a string or a id  from which the asset was loaded.
		 *   @return If a item with that key has resumed loading.
		 */
		public function resume(key:*):Boolean
		{
			var item:LoadingItem = key is LoadingItem ? key : get(key);
			_isPaused = false;
			if (item && item.status == LoadingItem.STATUS_STOPPED)
			{
				item.status = null;
				_loadNext();
				return true;
			}
			return false;
		}

		/**
		 * 恢复所有暂停 的操作
		 * Resumes all loading operations that were stopped.
		 *   @return <code>True</code> if any item was stopped and resumed, false otherwise
		 */
		public function resumeAll():Boolean
		{
			log.debug("Resuming all items");
			var affected:Boolean = false;
			_items.forEach(function(item:LoadingItem, ... rest):void
			{
				if (item.status == LoadingItem.STATUS_STOPPED)
				{
					resume(item);
					affected = true;
				}
			});
			_loadNext();
			return affected;
		}

		/** @private
		 *   Utility function to truncate a number to the given number of decimal places.
		 *   @description
		 *   Number is truncated using the <code>Math.round</code> function.
		 *
		 *   @param  The number to truncate
		 *   @param  The number of decimals place to preserve.
		 *   @return The truncated number.
		 */
		public static function truncateNumber(raw:Number, decimals:int = 2):Number
		{
			var power:int = Math.pow(10, decimals);
			return Math.round(raw * (power)) / power;
		}

		/**
		 *   Returns a string identifing this loaded instace.
		 */
		override public function toString():String
		{
			return "[BulkLoader] name:" + name + ", itemsTotal: " + itemsTotal + ", itemsLoaded: " + _itemsLoaded;
		}

		/** @private
		 *  Simply tries to guess the type from the file extension. Will remove query strings on urls.
		 *  If no extension is found, will default to type "text" and will trace a warning (must have LOG_WARNINGS or lower set).
		 */
		protected static function guessType(urlAsString:String):String
		{
			// no type is given, try to guess from the url
			var searchString:String = urlAsString.indexOf("?") > -1 ? urlAsString.substring(0, urlAsString.indexOf("?")) : urlAsString;
			// split on "/" as an url can have a dot as part of a directory name
			var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));
			;
			var extension:String = finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
			var type:String;
			if (!Boolean(extension))
			{
				extension = BulkLoader.TYPE_TEXT;
			}
			if (extension == BulkLoader.TYPE_IMAGE || BulkLoader.IMAGE_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_IMAGE;
			}
			else if (extension == BulkLoader.TYPE_SOUND || BulkLoader.SOUND_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_SOUND;
			}
			else if (extension == BulkLoader.TYPE_VIDEO || BulkLoader.VIDEO_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_VIDEO;
			}
			else if (extension == BulkLoader.TYPE_XML || BulkLoader.XML_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_XML;
			}
			else if (extension == BulkLoader.TYPE_MOVIECLIP || BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_MOVIECLIP;
			}
			else
			{
				// is this on a new extension?
				for (var checkType:String in _customTypesExtensions)
				{
					for each (var checkExt:String in _customTypesExtensions[checkType])
					{
						if (checkExt == extension)
						{
							type = checkType;
							break;
						}
						if (type)
							break;
					}
				}
				if (!type)
					type = BulkLoader.TYPE_TEXT;
			}
			return type;
		}

		/** @private  */
		private static function substituteURLString(raw:String, substitutions:Object):String
		{
			if (!substitutions)
				return raw;
			var subRegex:RegExp = /(?P<var_name>\{\s*[^\}]*\})/g;
			var result:Object = subRegex.exec(raw);
			var var_name:String = result ? result.var_name : null;
			var matches:Array = [];
			var numRuns:int = 0;
			while (Boolean(result) && Boolean(result.var_name))
			{
				if (result.var_name)
				{
					var_name = result.var_name;
					var_name = var_name.replace("{", "");
					var_name = var_name.replace("}", "");
					var_name = var_name.replace(/\s*/g, "");
				}
				matches.push({start: result.index, end: result.index + result.var_name.length, changeTo: substitutions[var_name]});
				// be paranoid so we don't hang the player if the matching goes cockos
				numRuns++;
				if (numRuns > 400)
				{
					break;
				}
				result = subRegex.exec(raw);
				var_name = result ? result.var_name : null;
			}
			;
			if (matches.length == 0)
			{
				return raw;
			}
			;
			var buffer:Array = [];
			var lastMatch:Object, match:Object;
			// beggininf os string, if it doesn't start with a substitition
			var previous:String = raw.substr(0, matches[0].start);
			var subs:String;
			for each (match in matches)
			{
				// finds out the previous string part and the next substitition
				if (lastMatch)
				{
					previous = raw.substring(lastMatch.end, match.start);
				}
				buffer.push(previous);
				buffer.push(match.changeTo);
				lastMatch = match;
			}
			// buffer the tail of the string: text after the last substitution
			buffer.push(raw.substring(match.end));
			return buffer.join("");
		}

		/** @private  */
		private static function getFileName(text:String, allowExtension:Boolean = false):String
		{
			if (text.lastIndexOf("/") == text.length - 1)
			{
				return getFileName(text.substring(0, text.length - 1));
			}
			var startAt:int = text.lastIndexOf("/") + 1;
			//if (startAt == -1) startAt = 0;
			var croppedString:String = text.substring(startAt);
			var lastIndex:int = allowExtension ? croppedString.length : croppedString.indexOf(".");
			if (lastIndex == -1)
			{
				if (croppedString.indexOf("?") > -1)
				{
					lastIndex = croppedString.indexOf("?");
				}
				else
				{
					lastIndex = croppedString.length;
				}
			}
			var finalPath:String = croppedString.substring(0, lastIndex);
			return finalPath;
		}

		/** @private
		   This is here only to assure that non hadled errors won't bubble up.
		 */
		private function _swallowError(e:Event):void
		{
		}

		/** @private  */
		private static function __debug_print_loaders():void
		{
			var theNames:Array = []
			for each (var instNames:String in BulkLoader._allLoaders)
			{
				theNames.push(instNames);
			}
			theNames.sort();
			trace("BulkLoader", "All loaders");
			theNames.forEach(function(item:*, ... rest):void
			{
				trace("BulkLoader", "\t", item)
			})
			trace("BulkLoader", "===========");
		}

		/** @private  */
		private static function __debug_print_num_loaders():void
		{
			var num:int = 0;
			for each (var instNames:String in BulkLoader._allLoaders)
			{
				num++;
			}
			trace("BulkLoader", "BulkLoader has ", num, "instances");
		}

		/** @private  */
		private static function __debug_printStackTrace():void
		{
			try
			{
				throw new Error("stack trace");
			}
			catch (e:Error)
			{
				trace("BulkLoader", e.getStackTrace());
			}
		}
	}
}