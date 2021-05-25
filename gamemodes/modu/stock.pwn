GetPlayerNameEx(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if(!response) 
		return Kick(playerid);
	new password[129];
	WP_Hash(password, 129, inputtext);
	if(!strcmp(password, PlayerInfo[playerid][pPassword])) 
	{ // If it matches
		mysql_format(Database, query, sizeof(query), "SELECT * FROM `users` WHERE `acc_username` = '%e' LIMIT 0, 1", GetPlayerNameEx(playerid));
		mysql_tquery(Database, query, "LoadPlayer", "i", playerid);
	}
	else 
	{
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FF0000}Wrong Password!\n{FFFFFF}Type your correct password below to continue and sign in to your account", "Login", "Exit");
	}
	return 1;
}
Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Kick(playerid);
	if(strlen(inputtext) < 3) return Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "{FF0000}Short Password!\n{FFFFFF}Type a 3+ characters password if you want to register and play on this server", "Register", "Exit");
	//If the password is less than 3 characters, show them a dialog telling them to input a 3+ characters password
	WP_Hash(PlayerInfo[playerid][pPassword], 129, inputtext); // Hash the password the player has wrote to the register dialog using Whirlpool.
	mysql_format(Database, query, sizeof(query), "INSERT INTO `users` (`acc_username`, `acc_password`, `acc_created`) VALUES ('%e', '%e', '%e')", GetPlayerNameEx(playerid), PlayerInfo[playerid][pPassword], PlayerInfo[playerid][pWhenmade]);
	// Insert player's information into the MySQL database so we can load it later.
	mysql_tquery(Database, query, "RegisterPlayer", "i", playerid); // We'll call this as soon as the player successfully registers.
	return 1;
}

SendClientMessageEx(playerid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while(--args >= 3)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 	text
		#emit PUSH.C 	192
		#emit PUSH.C 	str
		#emit PUSH.S	8
		#emit SYSREQ.C 	format
		#emit LCTRL 	5
		#emit SCTRL 	4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}

IsPlayerInRangeOfPlayer(playerid, targetid, Float:radius)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);

	if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z) && GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid))
	{
	    return 1;
	}

	return 0;
}

SendProximityMessage(playerid, Float:radius, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 4)
	{
	    foreach(new i : Player)
		{
	        if(IsPlayerInRangeOfPlayer(i, playerid, radius))
	        {
	            SendClientMessage(i, color, text);
			}
		}
	}
	else
	{
		while(--args >= 4)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri    8
		#emit CONST.alt     4
		#emit SUB
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
		{
	        if(IsPlayerInRangeOfPlayer(i, playerid, radius))
	        {
	            SendClientMessage(i, color, str);
			}
		}

		#emit RETN
	}
	return 1;
}

SendAdminMessage(color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] > 0)
	        {
	    		SendClientMessage(i, color, text);
			}
		}

		//print(text);
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] > 0)
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		//print(str);

		#emit RETN
	}
	return 1;
}

SendClientMessageToAllEx(color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged])
	        {
	    		SendClientMessage(i, color, text);
			}
		}

		//print(text);
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged])
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		//print(str);

		#emit RETN
	}
	return 1;
}

GetPlayerWantedLevelForTag(playerid)
{
	new string[108];

	switch(PlayerInfo[playerid][pWanted])
	{
		case 0: string = "{FFFFFF}Not Wanted\n{FFFFFF}Wanted Level: 0";
		case 1: string = "{D9BB4E}Ticketable\n{FFFFFF}Wanted Level: 1";
		case 2: string = "{F0C400}Wanted\n{FFFFFF}Wanted Level: 2";
		case 3: string = "{FFB700}Notorious\n{FFFFFF}Wanted Level: 3";
		case 4: string = "{FFA600}Mastermind\n{FFFFFF}Wanted Level: 4";
		case 5: string = "{FF5E00}high stakes\n{FFFFFF}Wanted Level: 5";
		case 6: string = "{FF0000}MOST WANTED!\n{FFFFFF}Wanted Level: 6";
	}
	return string;
}

GetStaffRank(playerid)
{
	new string[24];

	switch(PlayerInfo[playerid][pAdmin])
	{
	    case 0: string = "Player";
	    case 1: string = "Moderator";
	    case 2: string = "Junior Admin";
	    case 3: string = "Senior Admin";
	    case 4: string = "Server Manager";
		case 5: string = "Community Council";
	}

	return string;
}

GetJobName(playerid)
{
	new string[32];

	switch(PlayerInfo[playerid][pJob])
	{
	    case 0: string = "Civilian";
	    case 1: string = "SAPD Officer";
	    case 2: string = "Medic";
	    case 3: string = "Fireman";
	    case 4: string = "Mechanic";
		case 5: string = "Stripper";
	}

	return string;
}

TeleportToCoords(playerid, Float:ux, Float:uy, Float:uz, Float:angle, interiorid, worldid)
{
    {
        SetPlayerPos(playerid, ux, uy, uz);
        SetPlayerFacingAngle(playerid, angle);
        SetPlayerInterior(playerid, interiorid);
        SetPlayerVirtualWorld(playerid, worldid);
        SetCameraBehindPlayer(playerid);
    }
}

TeleportToPlayer(playerid, playerb)
{
    new
        Float:ux,
        Float:uy,
        Float:uz,
        Float:ua;

    GetPlayerPos(playerb, ux, uy, uz);
    GetPlayerFacingAngle(playerb, ua);

    TeleportToCoords(playerid, ux + 1, uy + 1, uz, ua, GetPlayerInterior(playerb), GetPlayerVirtualWorld(playerb));
}