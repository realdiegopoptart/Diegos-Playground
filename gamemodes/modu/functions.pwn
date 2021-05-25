forward CheckPlayer(playerid);
public CheckPlayer(playerid)
{
	new rows, string[150];
	cache_get_row_count(rows);
	TogglePlayerControllable(playerid, false);
	SetPlayerCamera(playerid);
	SetPlayerColor(playerid, 0xFFFFFFFF);
	SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][pSkin], 485.4370, -14.0601, 1000.6797, 268.1323, 0, 0, 0, 0, 0, 0);
	SetPlayerInterior(playerid, 17);
	WantedTag[playerid] = CreateDynamic3DTextLabel("Loading nametag...", 0xFFFFFFFF, 0.0, 0.0, 0.5, 23, .attachedplayer = playerid, .testlos = 1);
	SetPlayerCameraPos(playerid, 487.6031, -10.0267, 1003.1234);
	SetPlayerCameraLookAt(playerid, 487.6129, -9.0282, 1003.0244);
	
    new welmsg[16];
	switch(random(4))
	{
	    case 0: welmsg = "Hello";
		case 1: welmsg = "Wuddup";
		case 2: welmsg = "Hey";
        case 3: welmsg = "Hiya";
	}
    
	if(rows) // If row exists 
	{
		cache_get_value_name(0, "acc_password", PlayerInfo[playerid][pPassword], 129); // Load the player's password
		cache_get_value_name_int(0, "acc_id", PlayerInfo[playerid][pID]); // Load the player's ID.

		format(string, sizeof(string), "{FFFFFF}%s, {47d95f}%s{FFFFFF} You are already registered in our server.\nSimply type your password below in order to login.", welmsg, GetPlayerNameEx(playerid));
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Exit");
	}
	else // If there are no rows, we need to show the register dialog!
	{	
		format(string, sizeof(string), "{FFFFFF}%s, {47d95f}%s{FFFFFF} Welcome to Phazer Cops n' Robbers.\nSimply type a password below in order to register.", welmsg, GetPlayerNameEx(playerid));
		Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", string, "Register", "Exit");
	}
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
	if(!PlayerInfo[playerid][pKicked])
	{
	    PlayerInfo[playerid][pKicked] = 1;
	    SetTimerEx("KickPlayer", 200, false, "i", playerid);
	}
	else
	{
	    PlayerInfo[playerid][pKicked] = 0;
	    Kick(playerid);
	}
}

forward UnfreezeTimer(playerid);
public UnfreezeTimer(playerid)
{
	TogglePlayerControllable(playerid, 1);
    return 1;
}

forward SetPlayerCamera(playerid);
public SetPlayerCamera(playerid)
{
	SetPlayerInterior(playerid, 17);
	SetPlayerCameraPos(playerid, 487.6031, -10.0267, 1003.1234);
	SetPlayerCameraLookAt(playerid, 487.6129, -9.0282, 1003.0244);
	return 1;
}

CMD:test(playerid, params)
{
	SendClientMessageEx(playerid, -1, "Admin Level: %i", PlayerInfo[playerid][pAdmin]);
	return 1;
}

forward UpdateWantedTag();
public UpdateWantedTag()
{
    foreach(new i : Player)
    {
        if(IsPlayerConnected(i))
        {
			new nametag[180];
            format(nametag, sizeof(nametag), "%s", GetPlayerWantedLevelForTag(i));
            UpdateDynamic3DTextLabelText(WantedTag[i], 0xFFFFFFFF, nametag);
        }
    }
}

forward SavePlayerPos(playerid);
public SavePlayerPos(playerid)
{
	if(PlayerInfo[playerid][pLogged])
	{
		GetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]);
		mysql_format(Database, query, sizeof(query), "UPDATE users SET pos_x = %f WHERE acc_id = %i", PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pID]);
		mysql_tquery(Database, query);// X
		mysql_format(Database, query, sizeof(query), "UPDATE users SET pos_y = %f WHERE acc_id = %i", PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pID]);
		mysql_tquery(Database, query);// Y
		mysql_format(Database, query, sizeof(query), "UPDATE users SET pos_z = %f WHERE acc_id = %i", PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pID]);
		mysql_tquery(Database, query);// Z
		SetTimerEx("SavePlayerPos", 6500, false, "i", playerid);
	}
	return 1;
}