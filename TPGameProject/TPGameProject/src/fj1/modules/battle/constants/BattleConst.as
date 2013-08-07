package fj1.modules.battle.constants
{
	public class BattleConst
	{
		public static const BATTLE_SCENE_WIDTH:int = 1440;
		public static const BATTLE_SCENE_HEIGHT:int = 800;

		public static const BATTLE_GRID_WIDTH:int = 2;
		public static const BATTLE_GRID_HEIGHT:int = 3;
		
		public static const ACTION_NORMAL:int = 1; //普通攻击动作序列
		public static const ACTION_SKILL:int = 2; //技能攻击动作序列
		
		//战斗阵营（左/右）
		public static const LEFT:int = 0;
		public static const RIGHT:int = 1;
		/**
		 * 战斗渲染速度 
		 */		
		public static const BATTLE_RENDER_SPEED:int = 6;
		/**
		 * 战斗渲染默认速度 
		 */		
		public static const BATTLE_RENDER_DEFAULTSPEED:int = 1;
	}
}
