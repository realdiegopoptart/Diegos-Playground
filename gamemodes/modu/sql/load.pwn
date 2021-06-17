forward LoadPlayer(playerid);
public LoadPlayer(playerid)
{
	cache_get_value_name_int(0, "acc_id", PlayerInfo[playerid][pID]);
	cache_get_value_name(0, "acc_username", PlayerInfo[playerid][pUsername]);
	cache_get_value_name(0, "acc_password", PlayerInfo[playerid][pPassword]);
	cache_get_value_name_int(0, "chatmode", PlayerInfo[playerid][pChatmode]);
	cache_get_value_name_int(0, "cash", PlayerInfo[playerid][pCash]);
	cache_get_value_name_int(0, "kills", PlayerInfo[playerid][pKills]);
	cache_get_value_name_int(0, "bank", PlayerInfo[playerid][pBank]);
	cache_get_value_name_int(0, "skin", PlayerInfo[playerid][pSkin]);
	cache_get_value_name_int(0, "jobtype", PlayerInfo[playerid][pJob]);
	cache_get_value_name_int(0, "wanted", PlayerInfo[playerid][pWanted]);
	cache_get_value_name_int(0, "level", PlayerInfo[playerid][pLevel]);
	cache_get_value_name_int(0, "admin", PlayerInfo[playerid][pAdmin]);
	cache_get_value_name_float(0, "pos_x", PlayerInfo[playerid][pPos_x]);
	cache_get_value_name_float(0, "pos_y", PlayerInfo[playerid][pPos_y]);
	cache_get_value_name_float(0, "pos_z", PlayerInfo[playerid][pPos_z]);

	PlayerInfo[playerid][pLogged] = 1;
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]);

	SendClientMessageToAllEx(COLOR_GRAY, "* %s (%d) has logged in.", GetPlayerNameEx(playerid), playerid);
	SendClientMessageEx(playerid, COLOR_GREEN, "You successfully logged in, %s.", GetPlayerNameEx(playerid)); //INTRO DEFULT

	SetPlayerWantedLevel(playerid, PlayerInfo[playerid][pWanted]);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
	GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);

	SetTimerEx("UnfreezeTimer", 3000, false, "i", playerid);
	SetTimerEx("SavePlayerPos", 7500, false, "i", playerid);


	SetCameraBehindPlayer(playerid);
	return 1;
}

forward RegisterPlayer(playerid);
public RegisterPlayer(playerid)
{
	PlayerInfo[playerid][pID] = cache_insert_id();
	printf("A new account with the id of %d has been registered!", PlayerInfo[playerid][pID]); // You can remove this if you want, I just used it to debug.
    SendClientMessageToAllEx(0xFD0000FF, "Chip: {FFFFFF}Hey Guys! {FD0000}%s (%d) {FFFFFF}joined for the first time! Wish them a good stay!", GetPlayerNameEx(playerid), playerid);
	PlayerInfo[playerid][pLogged] = 1;
	SetPlayerInterior(playerid, 0);
	SetPlayerSkin(playerid, 26);
	SetPlayerPos(playerid, 1743.0848, -1946.4824, 13.5591);
	SetCameraBehindPlayer(playerid);
	return 1;
}

forward UnloadPlayer(playerid);
public UnloadPlayer(playerid)
{
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pLevel] = 0;
    PlayerInfo[playerid][pWanted] = 0;
    PlayerInfo[playerid][pPos_x] = 0;
    PlayerInfo[playerid][pPos_y] = 0;
    PlayerInfo[playerid][pPos_z] = 0;
    PlayerInfo[playerid][pJob] = 0;
    PlayerInfo[playerid][pKills] = 0;
    PlayerInfo[playerid][pCash] = 0;
    PlayerInfo[playerid][pBank] = 0;
    PlayerInfo[playerid][pKicked] = 0;
    PlayerInfo[playerid][pLogged] = 0;
    PlayerInfo[playerid][pSkin] = 0;
    PlayerInfo[playerid][pNormalSkin] = 0;
    PlayerInfo[playerid][pChatmode] = 0;
    PlayerInfo[playerid][pAduty] = 0;
    PlayerInfo[playerid][pKnocked] = 0;
	return 1;
}