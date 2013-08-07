package fj1.manager
{
	import fj1.common.res.ResPaths;
	import fj1.common.staticdata.StatusType;
	import fj1.common.vo.character.BaseCharacter;

	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.avatar.AvatarPartType;
	import tempest.engine.graphics.avatar.vo.AvatarPartData;

	public class AvatarManager
	{
		public static function updateAvatar(sc:SceneCharacter, extCloth:Boolean = false, mount:Boolean = false, cloth:Boolean = false, weapon:Boolean = false, wing:Boolean = false):void
		{
			var $sc:SceneCharacter = sc;
			var $data:BaseCharacter = sc.data as BaseCharacter;
			if (extCloth)
			{
				cloth = true;
				if ($data.getExtCloth() > 0)
				{
					//存在变身形象id（包括变身卡），屏蔽坐骑和武器显示
					$sc.removeAvatarPartByType(AvatarPartType.WEAPON);
					$sc.removeAvatarPartByType(AvatarPartType.MOUNT);
					$sc.removeAvatarPartByType(AvatarPartType.WING);
				}
				else
				{
					mount = true;
					weapon = true;
					wing = true;
				}
			}
			if (cloth || mount)
			{
				var clothId:int = $data.getBodyModelId(true);
				var state:int = $sc.isOnMount ? StatusType.MOUNT : StatusType.STAND;
				if ($data.getExtCloth() > 0)
				{
					state = StatusType.STAND;
				}
				$sc.addAvatarPart(new AvatarPartData(AvatarPartType.CLOTH, ResPaths.getCharacterPath(clothId, state)));
			}
			if ($data.getExtCloth() > 0)
			{
				return;
			}
			if (mount)
			{
				if ($sc.isOnMount)
				{
					$sc.addAvatarPart(new AvatarPartData(AvatarPartType.MOUNT, ResPaths.getMountPath($data.mountModelId)));
				}
				else
				{
					$sc.removeAvatarPartByType(AvatarPartType.MOUNT);
				}
			}
			if (mount || weapon)
			{
				var weaponModelId:int = $data.getWeaponModelId(); //获取武器模型id，将优先使用时装武器
				if (weaponModelId > 0)
				{
					$sc.addAvatarPart(new AvatarPartData(AvatarPartType.WEAPON, ResPaths.getWeaponPath(weaponModelId, $sc.isOnMount ? StatusType.MOUNT : StatusType.STAND)));
				}
				else
				{
					$sc.removeAvatarPartByType(AvatarPartType.WEAPON);
				}
			}
			if (mount || wing)
			{
				if ($data.wingModelId)
				{
					$sc.addAvatarPart(new AvatarPartData(AvatarPartType.WING, ResPaths.getWingPath($data.wingModelId, $sc.isOnMount ? StatusType.MOUNT : StatusType.STAND)));
				}
				else
				{
					$sc.removeAvatarPartByType(AvatarPartType.WING);
				}
			}
		}
	}
}
