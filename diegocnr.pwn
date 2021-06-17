/*
Diego's COPS AND ROBBERS - Started on 5/21/2021 11:25 PM
*/

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <izcmd>
#include <streamer>
#include <easyDialog>
#include <mSelection>
#include <foreach>
#include <afk>
// ------Modular-----

#include "./modu/defines.pwn"
#include "./modu/enum.pwn"
#include "./modu/stock.pwn"
#include "./modu/functions.pwn"
#include "./modu/sql/load.pwn"
#include "./modu/cmds/dialog.pwn"
#include "./modu/cmds/player.pwn"
#include "./modu/cmds/admin.pwn"

// -----End of Modular------

#define MYSQL_HOSTNAME		"localhost"
#define MYSQL_USERNAME		"root"
#define MYSQL_PASSWORD		""
#define MYSQL_DATABASE		"phazercnr"

main()
{
	print("\n----------------------------------");
	print(" Diego's CNR | Version V1.0.0");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true); // it automatically reconnects when loosing connection to mysql server
	Database = mysql_connect(MYSQL_HOSTNAME, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE, option_id); // AUTO_RECONNECT is enabled for this connection handle only
	if (Database == MYSQL_INVALID_HANDLE || mysql_errno(Database) != 0)
	{
		print("[!] MySQL Server connection has failed [!]");
		SendRconCommand("exit");
		return 1;
	}

	//Timers
	SetTimer("UpdateWantedTag", 1500, true);
	SetTimer("GetPlayerPosEx", 10000, true);

	SetGameModeText("realdiegopoptart V1.0.0 (CNR/RPG)");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(PlayerInfo[playerid][pKnocked] == 1)
	{
		ShowPlayerDialog(playerid, DIALOG_DEATH, DIALOG_STYLE_LIST, "Choose your spawn", "Random Hospital\nLocation\nJob Spot\n", "Select", "button2[]");
		PlayerInfo[playerid][pKnocked] = 0;
	}
	else if(PlayerInfo[playerid][pLogged] == 0)
	{
	 	TogglePlayerSpectating(playerid, true);
		SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][pSkin], 485.4370, -14.0601, 1000.6797, 268.1323, 0, 0, 0, 0, 0, 0);
     	TogglePlayerSpectating(playerid, false);
		SetPlayerCamera(playerid);
 	}

	return 0;
}

public OnPlayerConnect(playerid)
{
	GetPlayerIp(playerid, PlayerIP[playerid], 16);
	//SetPlayerColor(playerid, PlayerColors[playerid % sizeof PlayerColors]); // here incase
	mysql_format(Database, query, sizeof(query), "SELECT `acc_password`, `acc_id` FROM `users` WHERE `acc_username` = '%e' LIMIT 0, 1", GetPlayerNameEx(playerid));
	mysql_tquery(Database, query, "CheckPlayer", "i", playerid);
	UnloadPlayer(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	GetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]);

	mysql_format(Database, query, sizeof(query), "UPDATE `users` SET `pos_x`= %f, `pos_y`= %f, `pos_z`= %f WHERE `acc_id`= %d", PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pID]);
	mysql_tquery(Database, query);

    if(IsValidDynamic3DTextLabel(WantedTag[playerid]))
            DestroyDynamic3DTextLabel(WantedTag[playerid]);

	PlayerInfo[playerid][pLogged] = 0;

	if(PlayerInfo[playerid][pAdmin] >= 1)
	{
		switch(reason)
		{
			case 0: SendAdminMessage(COLOR_GRAY, "* [Staff] %s (%d) has left the server (crashed).", GetPlayerNameEx(playerid), playerid);
			case 1: SendAdminMessage(COLOR_GRAY, "* [Staff] %s (%d) has left the server (disconnected).", GetPlayerNameEx(playerid), playerid);
			case 2: SendAdminMessage(COLOR_GRAY, "* [Staff] %s (%d) has left the server (kicked).", GetPlayerNameEx(playerid), playerid);
		}
	}
	else
	{
		switch(reason)
		{
			case 0: SendClientMessageToAllEx(COLOR_GRAY, "* %s (%d) has left the server (crashed).", GetPlayerNameEx(playerid), playerid);
			case 1: SendClientMessageToAllEx(COLOR_GRAY, "* %s (%d) has left the server (disconnected).", GetPlayerNameEx(playerid), playerid);
			case 2: SendClientMessageToAllEx(COLOR_GRAY, "* %s (%d) has left the server (kicked).", GetPlayerNameEx(playerid), playerid);
		}
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//if(PlayerInfo[playerid][pLogged] && PlayerInfo[playerid][pKnocked] == 0)
	//{
	//	ShowPlayerDialog(playerid, DIALOG_DEATH, DIALOG_STYLE_LIST, "Choose your spawn", "Random Hospital\nLocation\nJob Spot\n", "Select", "button2[]");
	//}
	if(PlayerInfo[playerid][pKnocked] == 1)
	{
	    SetPlayerHealth(playerid, 100.0);
	    SetPlayerArmour(playerid, 0.0);
        ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
        GameTextForPlayer(playerid, "~r~Knocked~n~~w~~n~/accept death", 10000, 3);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	PlayerInfo[playerid][pKnocked] = 1;
	SendClientMessageEx(killerid, COLOR_GREEN, "You have been suspected for {FFFFFF}Murder");
	IncreaseWantedLevel(killerid);

	mysql_format(Database, query, sizeof(query), "UPDATE users SET wanted = %i WHERE acc_id = %i", PlayerInfo[killerid][pWanted], PlayerInfo[killerid][pID]);
	mysql_tquery(Database, query);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(PlayerInfo[playerid][pLogged] == 0)
	{
		SendClientMessage(playerid, COLOR_ERROR, "You are not logged in.");
	}
	if(PlayerInfo[playerid][pChatmode] == 0)
	{
		SendClientMessageToAllEx(0xFFFFFFFF, "{%06x}%s (%d){FFFFFF}: %s", GetPlayerColor(playerid) >>> 8, GetPlayerNameEx(playerid), playerid, text);
	}
	if(PlayerInfo[playerid][pChatmode] == 1)
	{
		SendProximityMessage(playerid, 20.0, COLOR_LOCAL, "%s says: %s", GetPlayerNameEx(playerid), text);
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
//	ShowPlayerDialog(playerid, DIALOG_DEATH, DIALOG_STYLE_LIST, "Choose your spawn", "Random Hospital\nLocation\nJob Spot\n", "Select", "button2[]");
//	PlayerInfo[playerid][pKnocked] = 0;
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	cmd_stats(playerid, "");
	return 1;
}
