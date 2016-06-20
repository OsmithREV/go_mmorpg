
enableDebugMode(true);

addEvent("onRespawn", function()
{
	setHealth(2000);
	setMaxHealth(2000);
	setStrength(150);
	setDexterity(150);
	setMaxMana(4000);
	setMana(4000);
	
	setWeaponSkill(1, 100);
	setWeaponSkill(2, 100);
	setWeaponSkill(3, 100);
	setWeaponSkill(4, 100);
	
	equipMeleeWeapon("ITMW_SCHWERT5");
	equipArmor("ITAR_PAL_H");
	
	giveItem("ITRW_ARROW", 1000);
	giveItem("ITRW_BOLT", 1000);
	giveItem("ITRW_BOW_M_04", 1000);
	giveItem("ITRW_CROSSBOW_H_01", 1000);
	giveItem("ITSC_ICEWAVE", 100);
	giveItem("ITPO_HEALTH_01", 100);
	giveItem("ITAM_PROT_POINT_01", 100);
	giveItem("ITRI_PROT_FIRE_02", 100);
	giveItem("ITBE_ADDON_STR_10", 100);
	
	setPosition(40070, 3849 , -2356);
});

addEvent("onCommand", function(cmd, params)
{
	switch (cmd)
	{
		case "time":
			local result = sscanf("dd", params);
			if (result)
			{
				addMessage(0, 255, 0,"Set time to " + result[0] + ":" + result[1]);
				setTime(result[0], result[1]);
			}
			else
				addMessage(0, 255, 0,"Type: /time hour min");
				
			return 1;
		
		case "hpbar":
			local result = sscanf("dddd", params);
			if (result)
			{
				addMessage(0, 255, 0, "Update hp bar.");
				setBarPosition(HEALTH_BAR, result[0], result[1]);
				setBarSize(HEALTH_BAR, result[2], result[3]);
			}
			else
				addMessage(0, 255, 0,"Type: /hpbar x y width height");
			
			return 1;
	}
});

function onDamage()
{
	return 1;
}