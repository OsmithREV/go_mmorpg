
enableDebugMode(true);

// ANTICHEAT PARAMS

local ac_health = false;
local ac_mana = false;
local ac_max_health = false;
local ac_max_mana = false;
local ac_strength = false;
local ac_dexterity = false;
local ac_oh = false;
local ac_th = false;
local ac_bow = false;
local ac_cbow = false;
local ac_level = false;
local ac_items = false;

local ac_last_hp = 0;
local ac_last_mp = 0;
local ac_last_max_health = 0;
local ac_last_max_mana = 0;
local ac_last_strength = 0;
local ac_last_dexterity = 0;
local ac_last_oh = 0;
local ac_last_th = 0;
local ac_last_bow = 0;
local ac_last_cbow = 0;
local ac_last_level = 0;

// PROFILE INFORMATION

local profile_cheater = false; // Является ли игрок читером

//

addEvent("onRespawn", function()
{
	
});

addEvent("onCommand", function(cmd, params)
{
	
});

function onDamage()
{
	return 1;
}

// ANTICHEAT

addEvent("onRender",function()
{
	if (getHealth() != ac_last_health && ac_health == false)
	{
		profile_cheater = true;
	}
	else if (getHealth() != ac_last_health && ac_health == true)
	{
		ac_last_health = getHealth();
		ac_health = false;
	};
	if (getMana() != ac_last_mana && ac_mana == false)
	{
		profile_cheater = true;
	}
	else if (getMana() != ac_last_mana && ac_mana == true)
	{
		ac_last_mana = getMana();
		ac_mana = false;
	};
	if (getMaxHealth() != ac_last_max_health && ac_max_health == false)
	{
		profile_cheater = true;
	}
	else if (getMaxHealth() != ac_last_max_health && ac_max_health == true)
	{
		ac_last_max_health = getMaxHealth();
		ac_max_health = false;
	};
	if (getMaxMana() != ac_last_max_mana && ac_max_mana == false)
	{
		profile_cheater = true;
	}
	else if (getMaxMana() != ac_last_max_mana && ac_max_mana == true)
	{
		ac_last_max_mana = getMaxMana();
		ac_max_mana = false;
	};
	if (getStrength() != ac_last_strength && ac_strength == false)
	{
		profile_cheater = true;
	}
	else if (getStrength() != ac_last_strength && ac_strength == true)
	{
		ac_last_strength = getStrength();
		ac_strength = false;
	};
	if (getDexterity() != ac_last_dexterity && ac_dexterity == false)
	{
		profile_cheater = true;
	}
	else if (getDexterity() != ac_last_dexterity && ac_dexterity == true)
	{
		ac_last_dexterity = getDexterity();
		ac_dexterity = false;
	};
	if (getWeaponSkill(1) != ac_last_oh && ac_oh == false)
	{
		profile_cheater = true;
	}
	else if (getWeaponSkill(1) != ac_last_oh && ac_oh == true)
	{
		ac_last_oh = getWeaponSkill(1);
		ac_oh = false;
	};
	if (getWeaponSkill(2) != ac_last_th && ac_th == false)
	{
		profile_cheater = true;
	}
	else if (getWeaponSkill(2) != ac_last_th && ac_th == true)
	{
		ac_last_th = getWeaponSkill(2);
		ac_th = false;
	};
	if (getWeaponSkill(3) != ac_last_bow && ac_bow == false)
	{
		profile_cheater = true;
	}
	else if (getWeaponSkill(3) != ac_last_bow && ac_bow == true)
	{
		ac_last_bow = getWeaponSkill(3);
		ac_bow = false;
	};
	if (getWeaponSkill(4) != ac_last_cbow && ac_cbow == false)
	{
		profile_cheater = true;
	}
	else if (getWeaponSkill(4) != ac_last_cbow && ac_cbow == true)
	{
		ac_last_cbow = getWeaponSkill(4);
		ac_cbow = false;
	};
	if (getLevel() != ac_last_level && ac_level == false)
	{
		profile_cheater = true;
	}
	else if (getLevel() != ac_last_level && ac_level == true)
	{
		ac_last_level = getLevel();
		ac_level = false;
	};
});

function AC_setHealth(health)
{
	ac_health = true;
	setHealth(health);
}

function AC_setMana(mana)
{
	ac_mana = true;
	setMana(mana);
}

function AC_setMaxHealth(health)
{
	ac_max_health = true;
	setMaxHealth(health);
}

function AC_setMaxMana(mana)
{
	ac_max_mana = true;
	setMaxMana(mana);
}

function AC_setStrength(str)
{
	ac_strength = true;
	setStrength(str);
}

function AC_setDexterity(dex)
{
	ac_dexterity = true;
	setDexterity(dex);
}

function AC_setWeaponSkill(num,arg)
{
	if (num == 1)
	{
		ac_oh = true;
	}
	else if (num == 2)
	{
		ac_th = true;
	}
	else if (num == 3)
	{
		ac_bow = true;
	}
	else if (num == 4)
	{
		ac_cbow = true;
	}
	setWeaponSkill(num,arg);
}

function AC_setLevel(lvl)
{
	ac_level = true;
	setLevel(lvl);
}