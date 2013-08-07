package fj1.common.res.guide.vo
{

	public class GuideTaskConfig
	{
		public var taskId:int;
		public var taskType:int;
		public var endScript:String = "";
		public var endScriptDone:Boolean = false;
		public var autoResiveEnabled:Boolean = false;
		public var autoDeliveEnabled:Boolean = false;
		public var autoDoTaskEnabled:Boolean = false;
		public var deliveWithTaskInfo:Boolean = true; //交付任务时是否优先显示任务内容
		public var continueTask:Boolean = true; //引导执行结束后是否继续任务

		public function GuideTaskConfig()
		{
		}
	}
}
