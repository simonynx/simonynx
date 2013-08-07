package fj1.common.res.guide
{
	import fj1.common.GameInstance;
	import fj1.common.helper.StringFormatHelper;
	import fj1.common.helper.TrackHelper;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.guide.vo.GuideConfig;
	import fj1.common.res.guide.vo.GuideTaskConfig;
	import fj1.common.staticdata.GuideConst;
	import fj1.modules.guide.helper.GuideHelper;
	import fj1.modules.task.model.vo.TaskData;
	import flash.utils.ByteArray;
	import tempest.utils.HtmlUtil;
	import tempest.utils.XMLAnalyser;

	public class GuideResManager
	{
		/**
		 * 引导配置容器
		 * 结构：
		 * _configArray[taskType][taskId][stageId]
		 */
		private static var _configArray:Array;
		private static var _taskConfigArray:Array;

		public static function load(data:*):Boolean
		{
			var list:Array = [];
			list = ResManagerHelper.getList(list, GuideConfig, data);
			if (list)
			{
				_configArray = [];
				_configArray[GuideConst.TASK_TYPE_UNKOWN] = [];
				_configArray[GuideConst.TASK_TYPE_RESIVEABLE] = [];
				_configArray[GuideConst.TASK_TYPE_RESIVED_COMPLETE] = [];
				_configArray[GuideConst.TASK_TYPE_RESIVED_UNCOMPLETE] = [];
				for each (var config:GuideConfig in list)
				{
					var taskConfigArray:Array = _configArray[config.taskType] as Array; //获取或创建一级数组
					if (!taskConfigArray)
					{
						taskConfigArray = [];
						_configArray[config.taskType] = taskConfigArray;
					}
					var stageArray:Array = taskConfigArray[config.taskId] as Array; //获取或创建二级数组
					if (!stageArray)
					{
						stageArray = [];
						taskConfigArray[config.taskId] = stageArray;
					}
					stageArray[config.step] = config;
					if (config.description)
					{
						config.description = config.description.replace(/\\n/g, "\n"); //替换换行符
						if (config.html)
						{
							config.descriptionResloved = config.description ? StringFormatHelper.getHTMLStr(config.description) : "";
						}
						else
						{
							config.descriptionResloved = config.description ? config.description : "";
						}
					}
					if (config.description2)
					{
						config.description2 = config.description2.replace(/\\n/g, "\n"); //替换换行符
						if (config.html)
						{
							config.description2Resloved = config.description2 ? StringFormatHelper.getHTMLStr(config.description2) : "";
						}
						else
						{
							config.description2Resloved = config.description2 ? config.description2 : "";
						}
					}
				}
				return true;
			}
			return false;
		}

		public static function get guideTaskConfigList():Array
		{
			return _taskConfigArray;
		}

		/**
		 * 获取引导任务配置
		 * @param taskId
		 * @return
		 *
		 */
		public static function getGuideTaskConfig(taskId:int, taskType:int):GuideTaskConfig
		{
			for each (var taskConfig:GuideTaskConfig in _taskConfigArray)
			{
				if (taskConfig.taskId == taskId && taskConfig.taskType == taskType)
				{
					return taskConfig;
				}
			}
			return null;
//			return _taskConfigArray[taskId];
		}

		/**
		 *
		 * @param xml
		 *
		 */
		public static function loadTaskConfig(data:*):Boolean
		{
			_taskConfigArray = [];
			_taskConfigArray = ResManagerHelper.getList(_taskConfigArray, GuideTaskConfig, data);
			return _taskConfigArray.length ? true : false;
		}

		/**
		 * 获取指定任务类型和任务ID的GuideStage配置列表
		 * @param taskType
		 * @param taskId
		 * @return
		 *
		 */
		public static function getStageConfigArray(taskType:int, taskId:int):Array
		{
			return _configArray[taskType][taskId];
		}

		/**
		 * 获取指定任务类型和任务ID和actionId的GuideStage配置
		 * @param taskType
		 * @param taskId
		 * @param actionId
		 * @return
		 *
		 */
		public static function getStageConfig(taskType:int, taskId:int, actionId:int):GuideConfig
		{
			var _stageArray:Array = _configArray[taskType][taskId];
			for each (var guideConfig:GuideConfig in _stageArray)
			{
				if (guideConfig.actionId == actionId)
				{
					return guideConfig;
				}
			}
			return null;
		}

		public static function get guideConfigArray():Array
		{
			return _configArray;
		}
	}
}
