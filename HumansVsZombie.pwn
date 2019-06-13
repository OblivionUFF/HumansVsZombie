/*
     Humans Vs Zombies Minigame by Sia
	 Minigame Last Tested: Few months back
*/

#include <a_samp>
#include <streamer>
#include <foreach>
#include <zcmd>

#define Humans  1
#define Zombies 2
#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_RED 			0xFF0000FF
#define WHITE_E 	"{FFFFFF}"
#define RED_E 		"{FF0000}"
#define ZVH_DIALOG 1002


new PlayerTeam[MAX_PLAYERS],InHVZ[MAX_PLAYERS] = 0;

public OnFilterScriptInit()
{
	printf("Humans Vs Zombies Minigame by Sia - Loaded");
    LoadObjects();
	return 1;
}

public OnFilterScriptExit()
{
    printf("Humans Vs Zombies Minigame by Sia - unloaded");
	return 1;
}


public OnPlayerConnect(playerid)
{
    InHVZ[playerid]= 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(InHVZ[playerid])
	{
		SetPlayerWeather(playerid, 12);
		SetPlayerTime(playerid, 1, 0);
		SetPlayerTeam(playerid, 255);
		PlayerTeam[playerid] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		InHVZ[playerid] = false;
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(InHVZ[playerid])
	{
        GameTextForPlayer(playerid, "~w~You have turned to ~r~Zombies Team~w~!", 4000, 4);
		if(PlayerTeam[playerid] == Zombies)
	    {
	        InHVZ[playerid] = true;
	        SetPlayerTime(playerid, 24, 0);
	        SetPlayerWeather(playerid, 9);
			SetPlayerColor(playerid, 0xFF0000FF);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 9, 1);
			switch(random(8)) 
			{
	            case 0: SetPlayerSkin(playerid, 162);
	            case 1: SetPlayerSkin(playerid, 32);
	            case 2: SetPlayerSkin(playerid, 132);
	            case 3: SetPlayerSkin(playerid, 134);
	            case 4: SetPlayerSkin(playerid, 159);
	            case 5: SetPlayerSkin(playerid, 160);
	            case 6: SetPlayerSkin(playerid, 137);
	            case 7: SetPlayerSkin(playerid, 95);
	        }
			switch(random(2))
			{
				case 0: SetPlayerPos(playerid, -2256.4050, 1629.1204, 2.2075+4);
				case 1: SetPlayerPos(playerid, -2257.7004, 1632.3083, 2.2075+4);
			}
		}
	    else if(PlayerTeam[playerid] == Humans)
		{
	        InHVZ[playerid] = true;
	        GameTextForPlayer(playerid, "~w~You have turned to ~r~Humans Team~w~!", 4000, 4);
			SetPlayerColor(playerid, 0x004BFFFF);
			ResetPlayerWeapons(playerid);
			SetPlayerTime(playerid, 24, 0);
	        SetPlayerWeather(playerid, 9);
			GivePlayerWeapon(playerid,17, 1000);
		    GivePlayerWeapon(playerid, 25, 2200);
		    GivePlayerWeapon(playerid, 31, 3000);
		    GivePlayerWeapon(playerid, 34, 2000);
		    GivePlayerWeapon(playerid, 44, 6000);
		    switch(random(5)) 
			{
		     	case 0: SetPlayerSkin(playerid,23); // hat boy
			    case 1: SetPlayerSkin(playerid,186); // business man
			    case 2: SetPlayerSkin(playerid,211); // girl
			    case 3: SetPlayerSkin(playerid,170); // Red Shirt guy
			    case 4: SetPlayerSkin(playerid,202); // Red Shirt guy
			}
			switch(random(2))
			{
				case 0: SetPlayerPos(playerid,-2060.1492, 1908.2874, 7.1715+4);
				case 1: SetPlayerPos(playerid, -2052.6924, 1907.6487, 7.1715+4);
			}
		}
		SetPlayerHealth(playerid, 100);
		SetPlayerVirtualWorld(playerid, 6);
		return true;
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if(InHVZ[playerid])
	{
	    if(PlayerTeam[playerid] == Humans)
	    {
            InHVZ[playerid] = true;
        	PlayerTeam[playerid] = Zombies;
			SetPlayerTeam(playerid, PlayerTeam[playerid]);
		}
		else if(PlayerTeam[playerid] == Zombies)
		{
            InHVZ[playerid] = true;
		    PlayerTeam[playerid] = Humans;
			SetPlayerTeam(playerid, PlayerTeam[playerid]);
		}
	}
	return 1;
}

CMD:hvz(playerid)
{
	if(InHVZ[playerid]) return SendClientMessage(playerid, COLOR_RED,"You are already in the Humans vs Zombies minigame");
	new line[200];
	format(line, 200, ""RED_E"Zombies Team\n{004BFF}Humans Team");
    ShowPlayerDialog(playerid, ZVH_DIALOG, DIALOG_STYLE_LIST, "Choose your team", line, "Play", "Exit");
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_FIRE && InHVZ[playerid])
	{
	    if(PlayerTeam[playerid] == Zombies)
	    {
		   if(GetPlayerWeapon(playerid) == 0)
		   {
		        new humanvictim = GetClosestPlayers(playerid);
		        if(PlayerTeam[humanvictim] == Humans)
		        {
			            GivePlayerMoney(playerid, 8000);
			            SetPlayerScore(playerid, GetPlayerScore(playerid)+10);
		    			new ytstr[300];
						format(ytstr, sizeof(ytstr), "http://convertmp3.io/fetch/?video=https://youtu.be/cvbfY5QSyvg");
						PlayAudioStreamForPlayer(humanvictim, ytstr);
			            GameTextForPlayer(humanvictim, "~r~~h~~h~Infected", 1600, 3);
			            ApplyAnimation(humanvictim, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0); // Dieing of Crack
			            SetTimerEx("INFECION", 3000, 0, "i", humanvictim);
		        }
	        }
		}
	}
	return 1;
}

forward INFECION(playerid);
public INFECION(playerid)
{
	ClearAnimations(playerid);
	PlayerTeam[playerid] = Zombies;
	SetPlayerTeam(playerid, PlayerTeam[playerid]);
	GameTextForPlayer(playerid, "~w~You have turned to ~r~Zombies Team~w~!", 4000, 4);
	SetPlayerColor(playerid, 0xFF0000FF);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 9, 1);
	switch(random(8)) //Sets the specific player's skin to eight random skins
	{
        case 0: SetPlayerSkin(playerid, 162);
        case 1: SetPlayerSkin(playerid, 32);
        case 2: SetPlayerSkin(playerid, 132);
        case 3: SetPlayerSkin(playerid, 134);
        case 4: SetPlayerSkin(playerid, 159);
        case 5: SetPlayerSkin(playerid, 160);
        case 6: SetPlayerSkin(playerid, 137);
        case 7: SetPlayerSkin(playerid, 95);
    }
    SetPlayerTime(playerid, 24, 0);
	SetPlayerWeather(playerid, 9);
    switch(random(2))
	{
		case 0: SetPlayerPos(playerid, -2256.4050, 1629.1204, 2.2075+4);
		case 1: SetPlayerPos(playerid, -2257.7004, 1632.3083, 2.2075+4);
	}
	SetPlayerHealth(playerid, 100);
	SetPlayerVirtualWorld(playerid, 6);
}

forward GetClosestPlayers(playerid);
public GetClosestPlayers(playerid){
	new player , Float:x, Float:y, Float:z;
	player = -1;
	GetPlayerPos(playerid, x, y, z);
	foreach(new i : Player)
	{
		if(i != playerid)
		{
			if(IsPlayerInRangeOfPoint(i, 2.0, x, y, z))
			{
				player = i;
			}
		}
	}
	return player;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == ZVH_DIALOG)
	{
	    if(response)
		{
			if(!InHVZ[playerid])
			{
				SetPVarInt(playerid, "Color", GetPlayerColor(playerid));
				SetPVarInt(playerid, "Skin", GetPlayerSkin(playerid));
			}
			if(listitem == 0) 
		    {
                InHVZ[playerid] = true;
				PlayerTeam[playerid] = Zombies;
		    	GameTextForPlayer(playerid, "~w~You have joined the ~r~Zombies Team~w~!", 4000, 4);
				SetPlayerColor(playerid, 0xFF0000FF);
				ResetPlayerWeapons(playerid);
				SetPlayerTime(playerid, 24, 0);
	            SetPlayerWeather(playerid, 9);
				SetPlayerTeam(playerid, PlayerTeam[playerid]);
				GivePlayerWeapon(playerid, 9, 1);
				switch(random(8)) //Sets the specific player's skin to eight random skins
				{
		            case 0: SetPlayerSkin(playerid, 162);
		            case 1: SetPlayerSkin(playerid, 32);
		            case 2: SetPlayerSkin(playerid, 132);
		            case 3: SetPlayerSkin(playerid, 134);
		            case 4: SetPlayerSkin(playerid, 159);
		            case 5: SetPlayerSkin(playerid, 160);
		            case 6: SetPlayerSkin(playerid, 137);
		            case 7: SetPlayerSkin(playerid, 95);
		        }
				switch(random(2))
				{
					case 0: SetPlayerPos(playerid, -2256.4050, 1629.1204, 2.2075+4);
					case 1: SetPlayerPos(playerid, -2257.7004, 1632.3083, 2.2075+4);
				}

				SetPlayerHealth(playerid, 100);
				SetPlayerVirtualWorld(playerid, 6);
			}
		    else if(listitem == 1) 
			{
                InHVZ[playerid] = true;
				GameTextForPlayer(playerid, "~w~You have joined the ~b~Humans Team~w~!", 4000, 4);
				SetPlayerColor(playerid, 0x004BFFFF);
				PlayerTeam[playerid] = Humans;
				ResetPlayerWeapons(playerid);
				SetPlayerTeam(playerid, PlayerTeam[playerid]);
				GivePlayerWeapon(playerid,17, 1000);
			    GivePlayerWeapon(playerid, 25, 2200);
			    GivePlayerWeapon(playerid, 31, 3000);
			    GivePlayerWeapon(playerid, 34, 2000);
			    GivePlayerWeapon(playerid, 44, 6000);
			    SetPlayerTime(playerid, 24, 0);
	            SetPlayerWeather(playerid, 9);
			    switch(random(5)) //Sets the specific player's skin to 5 random skins
				{
			     	case 0: SetPlayerSkin(playerid,23); // hat boy
				    case 1: SetPlayerSkin(playerid,186); // business man
				    case 2: SetPlayerSkin(playerid,211); // girl
				    case 3: SetPlayerSkin(playerid,170); // Red Shirt guy
				    case 4: SetPlayerSkin(playerid,202); // Red Shirt guy
				}
			    switch(random(2))
				{
					case 0: SetPlayerPos(playerid,-2060.1492, 1908.2874, 7.1715+4);
					case 1: SetPlayerPos(playerid, -2052.6924, 1907.6487, 7.1715+4);
				}
				SetPlayerHealth(playerid, 100);
				SetPlayerVirtualWorld(playerid, 6);
			}
		}
	}
	return 0;
}

CMD:exithvz(playerid)
{
	if(!InHVZ[playerid]) return SendClientMessage(playerid, COLOR_RED,"You need to be in the Humans vs Zombies minigame to use this command!");
	SetPlayerSkin(playerid, GetPVarInt(playerid, "Skin"));
	SetPlayerColor(playerid, GetPVarInt(playerid, "Color"));
	SetPlayerWeather(playerid, 23);
	SetPlayerTime(playerid, 1, 0);

	PlayerTeam[playerid] = 0;
	SetPlayerTeam(playerid, 255);
	SetPlayerVirtualWorld(playerid, 0);
	InHVZ[playerid] = false;
	ResetPlayerWeapons(playerid);
	SpawnPlayer(playerid);
    return 1;
}


public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(InHVZ[playerid] && strfind(cmdtext,"exithvz",true) == -1)
	{
		SendClientMessage(playerid,0xFF0000FF, "ERROR: {FFFFFF}You can not use any command here, type /exithvz to unblock them.");
		return 0;
	}
	return 1;
}


LoadObjects()
{
	CreateDynamicObject(12814, -2135.38525, 1865.83716, 0.98790,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2158.45557, 1882.18262, -0.19748,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2223.71802, 1799.05920, 0.90930,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2125.69873, 1863.18359, -0.16872,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2174.19824, 1891.22852, -0.16872,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2136.89966, 1874.16895, -0.16690,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2127.93677, 1868.78137, -0.16968,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2138.14673, 1886.18835, -0.17541,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2138.14673, 1886.18835, -0.17541,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2148.20581, 1783.93799, 0.89660,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2130.35229, 1872.77100, -0.10719,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -3153.02295, 2446.17505, -0.62096,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2188.71509, 1783.90930, 0.76499,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2224.50732, 1711.73157, 0.76499,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.17236, 1876.66650, -0.12500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.31592, 1844.71094, -0.11990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.31592, 1844.71094, -0.11990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9255, -2258.03345, 1718.60266, 0.83857,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2356.63428, 1768.31592, -0.12083,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6066, -2208.59106, 1699.41895, -0.12083,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(14537, -2158.88184, 1743.25818, 2.70500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19495, -2224.64014, 1700.50928, 6.01420,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(10398, -2128.96362, 33333.78906, 86.69690,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2194.05908, 1820.46570, 1.04560,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2251.15259, 1911.04761, -0.07668,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9087, -2067.95288, 1802.44055, 0.30700,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(12814, -2194.16211, 1865.48096, 0.99130,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2164.78198, 1865.61035, 0.98790,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2158.45557, 1882.18262, -0.19748,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2219.92920, 1750.42627, 0.86930,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2125.69922, 1863.22363, -0.16872,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2174.35840, 1887.87976, -0.16872,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2136.89966, 1874.16895, -0.16690,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2127.93677, 1868.78137, -0.16968,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2138.14673, 1886.18835, -0.17541,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2136.45728, 1888.88513, -0.17541,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2147.67285, 1744.38135, 0.90500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2130.37183, 1872.76636, -0.10719,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -3153.02295, 2446.17505, -0.62096,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2185.19434, 1744.41211, 0.90500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2224.36963, 1711.82422, 0.76499,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.15747, 1876.56787, -0.12500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.34155, 1844.65662, -0.11990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2166.08569, 1845.72485, -0.11990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9255, -2257.91406, 1628.04114, 0.29860,   0.00000, 0.00000, 76.00000);
	CreateDynamicObject(12814, -2357.87524, 1768.66125, -0.12083,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6066, -2252.71973, 1667.64160, 3.10080,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(14537, -2114.67163, 1795.08228, 2.70500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19495, -2229.92505, 1621.73267, 6.01420,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(10398, -2128.96362, 33333.78906, 86.69690,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2221.48901, 1848.80176, 0.91130,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2147.77173, 1822.60193, 1.00560,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2244.41479, 1908.64099, -0.07668,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9087, -2069.37280, 1765.17749, 0.77670,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2148.06885, 1815.76990, 0.95130,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19530, -2189.75562, 1671.58655, 0.77680,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19530, -2154.89600, 1684.55237, -0.06157,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19530, -2176.13452, 1646.95947, -0.04593,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19531, -2065.00684, 1787.30505, 0.86510,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2128.03735, 1651.67505, 0.74890,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2128.28369, 1709.02429, 0.78890,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2128.96118, 1683.19092, 0.74234,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2119.66699, 1654.62524, -0.04920,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2128.82007, 1623.45203, 0.63200,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19532, -2114.55469, 1874.05347, 0.98820,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(2641, -2104.28394, 2214.59375, -0.08205,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(2641, -2104.28394, 2214.59375, -0.08205,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(2641, -2218.70825, 1632.84143, 1.39470,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(10770, -2209.62671, 1632.25342, 3.98180,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(7326, -2125.90918, 1790.95679, 1.11000,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(7326, -2146.85083, 1747.06421, 1.11000,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(17576, -2106.91528, 1871.48608, 5.10550,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3844, -2183.83545, 1884.62097, 5.84230,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18239, -2229.49438, 1869.78186, 0.74760,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(16327, -2187.51782, 1870.30933, 1.02400,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(16326, -2213.59937, 1865.90161, 1.73500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3845, -2202.61011, 1800.89978, 6.03050,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3821, -2201.96851, 1814.99866, 6.89320,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12951, -2201.13232, 1827.99072, 0.89380,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(14738, -2204.69263, 1870.72205, 3.89950,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3640, -2228.33447, 1850.00916, 4.80250,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3843, -2230.49194, 1834.86145, 8.01980,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(3759, -2232.50049, 1817.96570, 4.79940,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3820, -2230.20093, 1797.31873, 7.39050,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(5520, -2230.09473, 1780.54041, 5.87700,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(9310, -2228.70972, 1755.51953, 6.20540,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3653, -2227.25439, 1730.46826, 6.34510,   0.00000, 0.00000, 185.00000);
	CreateDynamicObject(3762, -2191.43115, 1712.42712, 4.46390,   0.00000, 0.00000, -4.00000);
	CreateDynamicObject(10439, -2199.40186, 1778.69287, 4.12370,   -0.02000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3385, -2135.10181, 1768.18054, 1.91230,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18657, -2205.66260, 1881.27014, 1.47128,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2088.36890, 1850.10156, 3.10620,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2164.60425, 1854.81262, 2.49700,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(10398, -1974.58118, 1767.01990, 29.24700,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(9090, -2028.07690, 1869.24329, -25.04430,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19588, -1973.36731, 1751.47717, 5.20740,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19588, -2258.92969, 1688.70435, 1.04380,   0.00000, 0.00000, 193.00000);
	CreateDynamicObject(19531, -1998.65906, 1784.89307, 0.67172,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19531, -2000.84717, 1664.25464, 0.49466,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19531, -2124.30273, 1663.54688, 0.74090,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(714, -2025.17566, 1865.45093, 2.48230,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18271, -2114.65063, 1672.30359, 20.82830,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18271, -2117.20654, 1691.46436, 10.76570,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(818, -2122.61597, 1720.43408, 5.59340,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(5773, -2185.15649, 1636.80444, -1.88010,   0.00000, 0.00000, 180.00000, 6);
	CreateDynamicObject(2745, -2136.01050, 1772.41406, 1.44980,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(4563, -1974.73425, 1640.55811, 86.55250,   0.00000, 0.00000, -84.00000);
	CreateDynamicObject(19076, -2135.71631, 1769.51880, 0.78740,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(8131, -2134.96313, 1732.85278, 11.52110,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(11674, -2164.71729, 1885.25024, 1.18270,   0.00000, 0.00000, 40.00000, 6);
	CreateDynamicObject(9272, -2140.74121, 1884.94165, 7.33810,   0.00000, 0.00000, -91.00000);
	CreateDynamicObject(9324, -2093.08472, 1712.31055, 5.88720,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(18261, -12777.28809, 1518.91675, 484.55606,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18261, -2086.38672, 1684.74805, 1.51160,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(8675, -2093.52295, 1621.88477, 9.64010,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(7617, -2100.00781, 1655.63733, 1.71800,   0.00000, 0.00000, -91.00000);
	CreateDynamicObject(3676, -2132.36597, 1619.20447, 6.24590,   0.00000, 0.00000, 84.00000);
	CreateDynamicObject(6257, -2139.82227, 1817.87561, 8.13896,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3684, -2173.64941, 1828.52283, 3.89410,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(16781, -2167.15283, 1801.85303, 0.99920,   0.00000, 0.00000, 87.00000);
	CreateDynamicObject(10999, -2169.31177, 1775.29419, 1.25020,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(6088, -2146.08936, 1685.83838, 3.96380,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(4825, -1992.51416, 1784.93213, -1.66930,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(14537, -2186.77783, 1680.73120, 2.43730,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(14537, -2218.19702, 1663.82117, 2.51100,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(14537, -2239.93164, 1695.27173, 2.63820,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6285, -2048.08521, 1678.17810, 6.48300,   0.00000, 0.00000, 182.00000);
	CreateDynamicObject(8068, -2072.42627, 1867.64453, 8.33480,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3488, -1991.43359, 1869.99573, 9.19830,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(11674, -2091.11914, 1832.49939, 1.68740,   0.00000, 0.00000, 36.00000);
	CreateDynamicObject(16781, -2061.20313, 1823.91357, 0.99990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2087.25684, 1807.24255, 1.25360,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2096.74023, 1773.74695, 1.76880,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2165.54907, 1837.15088, 0.97831,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2120.07837, 1791.25269, 10.47780,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2161.04932, 1739.89758, 10.35850,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19530, -2193.24365, 1673.39758, 0.65479,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18648, -2066.34961, 1824.42505, 6.61642,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18648, -2092.12646, 1797.86633, 0.83639,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19128, -2072.94507, 1784.77893, 0.83639,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3385, -2218.59912, 1682.06689, 0.85193,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(16006, -2102.46265, 1763.24072, 0.21700,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(7929, -2195.70752, 1741.29333, 7.52560,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3385, -2148.59131, 1711.10059, 0.82823,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3385, -2219.70532, 1661.42712, 1.72000,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2158.23462, 1736.19141, 1.63130,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2112.12695, 1788.42627, 1.72310,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2266.53027, 1686.68262, 1.23150,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2135.92285, 1859.86145, 1.57970,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2226.95190, 1691.51770, 0.69995,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2084.58350, 1768.21899, 1.19790,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2167.35742, 1857.49487, 1.24210,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2170.74780, 1855.36499, 0.97753,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2170.74780, 1855.36499, 0.97753,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2214.95459, 1741.36292, 1.97680,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2196.09619, 1854.04724, 0.97680,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2217.54883, 1777.14551, 1.98170,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2086.51489, 1803.47021, 1.98170,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2219.64258, 1819.48877, 1.98170,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2215.19800, 1845.66431, 1.98170,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2004.02271, 1797.03760, 1.78190,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2002.72717, 1773.63635, 1.57560,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19187, -2193.54028, 1769.38013, 4.67020,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19187, -2193.54028, 1769.38013, 4.35016,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(2253, -2193.54028, 1769.38013, 4.35016,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1395, -2100.12793, 1851.14709, 31.23210,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(8981, -2053992.00000, 1957.44067, 120.09140,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6257, -2054.06055, 1712.68921, 7.67490,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2135.38525, 1865.83716, 0.98790,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2158.45557, 1882.18262, -0.19748,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2223.71802, 1799.05920, 0.90930,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2125.69873, 1863.18359, -0.16872,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2174.19824, 1891.22852, -0.16872,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2136.89966, 1874.16895, -0.16690,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2127.93677, 1868.78137, -0.16968,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2138.14673, 1886.18835, -0.17541,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2138.14673, 1886.18835, -0.17541,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2148.20581, 1783.93799, 0.89660,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2130.35229, 1872.77100, -0.10719,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -3153.02295, 2446.17505, -0.62096,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2188.71509, 1783.90930, 0.76499,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2224.50732, 1711.73157, 0.76499,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.17236, 1876.66650, -0.12500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.31592, 1844.71094, -0.11990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.31592, 1844.71094, -0.11990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9255, -2258.03345, 1718.60266, 0.83857,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2356.63428, 1768.31592, -0.12083,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6066, -2208.59106, 1699.41895, -0.12083,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(14537, -2025.39771, 1716.13867, 2.58500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19495, -2224.64014, 1700.50928, 6.01420,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(10398, -2128.96362, 33333.78906, 86.69690,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2194.05908, 1820.46570, 1.04560,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2251.15259, 1911.04761, -0.07668,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9087, -2067.96411, 1802.42395, 0.76700,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(12814, -2194.16211, 1865.48096, 0.99130,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2164.78198, 1865.61035, 0.98790,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2158.45557, 1882.18262, -0.19748,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2219.92920, 1750.42627, 0.86930,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2125.69922, 1863.22363, -0.16872,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2174.35840, 1887.87976, -0.16872,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2136.89966, 1874.16895, -0.16690,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2127.93677, 1868.78137, -0.16968,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2138.14673, 1886.18835, -0.17541,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2136.45728, 1888.88513, -0.17541,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2147.67285, 1744.38135, 0.90500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2130.37183, 1872.76636, -0.10719,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -3153.02295, 2446.17505, -0.62096,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2185.19434, 1744.41211, 0.90500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2224.36963, 1711.82422, 0.76499,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.15747, 1876.56787, -0.12500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2167.34155, 1844.65662, -0.11990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2166.08569, 1845.72485, -0.11990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2357.87524, 1768.66125, -0.12083,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6066, -2252.71973, 1667.64160, 3.10080,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(14537, -2114.73413, 1930.32983, 2.70500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19495, -2229.92505, 1621.73267, 6.01420,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(10398, -2128.96362, 33333.78906, 86.69690,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2221.48901, 1848.80176, 0.91130,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2147.77173, 1822.60193, 1.00560,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6959, -2244.41479, 1908.64099, -0.07668,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9087, -2069.37671, 1765.20557, 0.69670,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2148.06885, 1815.76990, 0.95130,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19530, -2189.75562, 1671.58655, 0.77680,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19530, -2154.89600, 1684.55237, -0.06157,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19530, -2176.13452, 1646.95947, -0.04593,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19531, -2066.01440, 1788.04138, 0.86510,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2128.03735, 1651.67505, 0.74890,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2128.28369, 1709.02429, 0.78890,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2128.96118, 1683.19092, 0.74234,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2119.66699, 1654.62524, -0.04920,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19549, -2128.82007, 1623.45203, 0.63200,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19532, -2114.82764, 1875.20740, 0.98820,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(2641, -2104.28394, 2214.59375, -0.08205,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(2641, -2104.28394, 2214.59375, -0.08205,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(2641, -2218.70825, 1632.84143, 1.39470,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(10770, -2209.62671, 1632.25342, 3.98180,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(7326, -2125.88062, 1790.89075, 1.11000,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(7326, -2146.83447, 1747.05286, 1.11000,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(17576, -2106.91528, 1871.48608, 5.10550,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3844, -2183.83545, 1884.62097, 5.84230,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18239, -2229.49438, 1869.78186, 0.74760,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(16327, -2187.51782, 1870.30933, 1.02400,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(16326, -2213.59937, 1865.90161, 1.73500,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3845, -2202.61011, 1800.89978, 6.03050,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3821, -2201.96851, 1814.99866, 6.89320,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12951, -2201.13232, 1827.99072, 0.89380,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(14738, -2204.69263, 1870.72205, 3.89950,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3843, -2230.49194, 1834.86145, 8.01980,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(3759, -2232.50049, 1817.96570, 4.79940,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3820, -2230.20093, 1797.31873, 7.39050,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(5520, -2230.09473, 1780.54041, 5.87700,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3762, -2165.97485, 1709.10938, 4.56390,   0.00000, 0.00000, -4.00000);
	CreateDynamicObject(3385, -2135.10181, 1768.18054, 1.91230,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2088.36890, 1850.10156, 3.10620,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2164.60425, 1854.81262, 2.49700,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(10398, -1974.58118, 1767.01990, 29.24700,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(9090, -2028.07690, 1869.24329, -25.04430,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19588, -1973.36731, 1751.47717, 5.20740,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19588, -2258.92969, 1688.70435, 1.04380,   0.00000, 0.00000, 193.00000);
	CreateDynamicObject(19531, -1998.65906, 1784.89307, 0.67172,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19531, -2000.84717, 1664.25464, 0.49466,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19531, -2124.30273, 1663.54688, 0.74090,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(714, -2025.17566, 1865.45093, 2.48230,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18271, -2067.66479, 1772.90454, 10.82830,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(818, -2122.61597, 1720.43408, 5.59340,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(5773, -2185.15649, 1636.80444, -1.88010,   0.00000, 0.00000, 180.00000, 6);
	CreateDynamicObject(2745, -2136.01050, 1772.41406, 1.44980,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(4550, -2041.70337, 1625.36816, 81.03460,   0.00000, 0.00000, 47.00000);
	CreateDynamicObject(19076, -2135.71631, 1769.51880, 0.78740,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(8131, -2044.40869, 1747.03076, 11.38110,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(11674, -2164.71729, 1885.25024, 1.18270,   0.00000, 0.00000, 40.00000, 6);
	CreateDynamicObject(9272, -2140.74121, 1884.94165, 7.33810,   0.00000, 0.00000, -91.00000);
	CreateDynamicObject(9324, -2093.08472, 1712.31055, 5.88720,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(18261, -12777.28809, 1518.91675, 484.55606,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18261, -2086.38672, 1684.74805, 1.51160,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(8675, -2093.52295, 1621.88477, 9.64010,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(7617, -2100.00781, 1655.63733, 1.71800,   0.00000, 0.00000, -91.00000);
	CreateDynamicObject(3676, -2132.36597, 1619.20447, 6.24590,   0.00000, 0.00000, 84.00000);
	CreateDynamicObject(6257, -2139.82227, 1817.87561, 8.13896,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3684, -2173.64941, 1828.52283, 3.89410,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(16781, -2167.15283, 1801.85303, 0.99920,   0.00000, 0.00000, 87.00000);
	CreateDynamicObject(10999, -2169.31177, 1775.29419, 1.25020,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(6088, -2146.08936, 1685.83838, 3.96380,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(4825, -1992.51416, 1784.93213, -1.66930,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(14537, -2218.19702, 1663.82117, 2.51100,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6285, -2048.08521, 1678.17810, 6.48300,   0.00000, 0.00000, 182.00000);
	CreateDynamicObject(8068, -2072.42627, 1867.64453, 8.33480,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(3488, -1991.43359, 1869.99573, 9.19830,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(11674, -2091.11914, 1832.49939, 1.68740,   0.00000, 0.00000, 36.00000);
	CreateDynamicObject(16781, -2061.20313, 1823.91357, 0.99990,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2087.25684, 1807.24255, 1.25360,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2096.74023, 1773.74695, 1.76880,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2165.54907, 1837.15088, 0.97831,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2120.07837, 1791.25269, 10.47780,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19152, -2161.04932, 1739.89758, 10.35850,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19530, -2193.24365, 1673.39758, 0.65479,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18648, -2066.34961, 1824.42505, 6.61642,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18648, -2092.12646, 1797.86633, 0.83639,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19128, -2072.94507, 1784.77893, 0.83639,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3385, -2218.59912, 1682.06689, 0.85193,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(16006, -2102.46265, 1763.24072, 0.21700,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(7929, -2095.20215, 1739.84534, 7.66560,   0.00000, 0.00000, -91.00000);
	CreateDynamicObject(3385, -2148.59131, 1711.10059, 0.82823,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3385, -2219.70532, 1661.42712, 1.72000,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2158.23462, 1736.19141, 1.63130,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2112.12695, 1788.42627, 1.72310,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2266.53027, 1686.68262, 1.23150,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2135.92285, 1859.86145, 1.57970,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2226.95190, 1691.51770, 0.69995,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2084.58350, 1768.21899, 1.19790,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2167.35742, 1857.49487, 1.24210,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2170.74780, 1855.36499, 0.97753,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(12814, -2170.74780, 1855.36499, 0.97753,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2214.95459, 1741.36292, 1.97680,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2196.09619, 1854.04724, 0.97680,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2217.54883, 1777.14551, 1.98170,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2086.51489, 1803.47021, 1.98170,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2219.64258, 1819.48877, 1.98170,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2215.19800, 1845.66431, 1.98170,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2004.02271, 1797.03760, 1.78190,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1232, -2002.72717, 1773.63635, 1.57560,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19187, -2193.54028, 1769.38013, 4.67020,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(19187, -2193.54028, 1769.38013, 4.35016,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(2253, -2193.54028, 1769.38013, 4.35016,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(1395, -2100.12793, 1851.14709, 31.23210,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(8981, -2053992.00000, 1957.44067, 120.09140,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(6257, -2054.06055, 1712.68921, 7.67490,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18271, -2068.57837, 1756.08215, 3.50262,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18271, -2185.79126, 1684.28589, 3.50262,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18271, -2227.58008, 1668.59900, 8.77522,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(18271, -2178.85449, 1856.74451, 16.83640,   -4.00000, 0.00000, 113.00000);
	CreateDynamicObject(18271, -2148.00635, 1868.20422, 15.51220,   -4.00000, 0.00000, -244.00000);
	CreateDynamicObject(3437, -2132.04956, 1875.28772, 27.58647,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3437, -2132.04956, 1875.28772, 28.18650,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(3440, -2128.86816, 2064.62622, 55.82951,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9683, -2262.60034, 1534.08252, -19.78620,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9683, -2262.61572, 1418.19348, -19.78620,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9587, -2262.97632, 1595.50574, 1.27969,   0.00000, 0.00000, 0.00000, 6);
	CreateDynamicObject(9587, -2261.01709, 1596.18628, 9.50960,   0.00000, 0.00000, 0.00000, 6);
}
