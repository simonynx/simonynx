//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Pool {
    import Manager.*;

    public class ScenePool {

        public static var attackFacePool:Pool = PoolManager.creatPool("attackFacePool", 200);
        public static var bmdPool:BitmapdataPool = new BitmapdataPool("bmd", 200);
        public static var gameElementEnemyAnimationPool:Pool = PoolManager.creatPool("gameElementEnemyAnimation", 100);
        public static var gameElementEnemyPool:Pool = PoolManager.creatPool("gameElementEnemy", 100);
        public static var skillAnimationPool:Pool = PoolManager.creatPool("skillAnimationPool", 200);

    }
}//package OopsEngine.Pool 
