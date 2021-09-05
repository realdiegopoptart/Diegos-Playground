public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	switch(success)
	{
		case 0:
		{
			SendClientMessage(playerid, COLOR_ERROR, "This command does not exist. Please refer to ''/help'' or ''/ask''");
	        return 1;
		}
	}
	return 1;
}

CMD:chatmode(playerid, params[])
{
	if(!strcmp(params, "public", true))
	{
	mysql_format(Database, querystr, sizeof(querystr), "UPDATE users SET chatmode = 0 WHERE acc_id = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(Database, querystr);
    PlayerInfo[playerid][pChatmode] = 0;
    SendClientMessage(playerid, COLOR_ERROR, "Your chatmode has been set to public");
	}
	else if(!strcmp(params, "local", true))
	{
	mysql_format(Database, querystr, sizeof(querystr), "UPDATE users SET chatmode = 1 WHERE acc_id = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(Database, querystr);
    PlayerInfo[playerid][pChatmode] = 1;
    SendClientMessage(playerid, COLOR_ERROR, "Your chatmode has been set to local");
	}
/*	else if(!strcmp(params, "gmx", true))
	{
        TextDrawHideForAll(gmxtd);
        SendClientMessageToAll(color_red,"[Restart]{FFFFFF}: The server restart has been canceled");
        KillTimer(GmxTimer);
        new string[82];
		format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has stopped the GMX!", ReturnName(playerid),playerid);
		SendAdminMessage(color_banned,string);
	}*/
    else
    {
       SendClientMessage(playerid, COLOR_ERROR, "Correct usage: /chatmode [public | local]");
    }
	return 1;
}

CMD:admins(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIME, "Online Administrators:");
    for(new i; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pAdmin] >= 1)
				{			
				new astatus[64];
				if(PlayerInfo[i][pAduty] == 1)
				{
					astatus = "{FD0000}Administrating";
				}
				else if(PlayerInfo[i][pAduty] == 0)
				{
					astatus = "{FFFFFF}Playing";
				}
			 	if(PlayerAFK[i] == true)
				{
					astatus = "{FFCC00}Paused";
				}
                new string[500];
				format(string, sizeof(string), "* %s: %s (%d), Status: %s", GetStaffRank(i), GetPlayerNameEx(i), i, astatus);
				SendClientMessage(playerid, COLOR_WHITE, string);
				}
            }
        }
    return 1;
}

CMD:stats(playerid, params[])
{
	new string1[450];
	new string2[450];
	new string3[450];
	new string4[450];
	new string5[450];
//	new string6[350];
//	new string7[350];
    format(string1, sizeof(string1), "{FFFFFF}Basic\n{456492}Name: {FFFFFF}%s\n", GetPlayerNameEx(playerid));
    format(string2, sizeof(string2), "%s{456492}Level: {FFFFFF}%i\n{456492}Job: {FFFFFF}%s\n", string1, PlayerInfo[playerid][pLevel], GetJobName(playerid));
    format(string3, sizeof(string3), "%s{456492}Wanted: {FFFFFF}%i/6\n{456492}Money: {FFFFFF}$%i\n", string2, PlayerInfo[playerid][pWanted], PlayerInfo[playerid][pCash]);
    format(string4, sizeof(string4), "%s{FFFFFF}\nPositions\n{456492}Staff: {FFFFFF}%s\n", string3, GetStaffRank(playerid));
    format(string5, sizeof(string5), "%s{FFFFFF}\nNetwork\n{456492}Packetloss: {FFFFFF}%.2f\n{456492}Connected: {FFFFFF}%i minute(s){FFFFFF}", string4, NetStats_PacketLossPercent(playerid), NetStats_GetConnectedTime(playerid) / 60000);
//	format(string6, sizeof(string6), "%s{FFFFFF}Location UI%s\n", string5, lui);
//	format(string7, sizeof(string7), "%s{FFFFFF}Hitmarker%s\n", string6, hits);
	ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Statistics", string5, "Close", "");
	return 1;
}

CMD:p(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "Correct usage: /p [text]");
	}

	SendClientMessageToAllEx(0xFFFFFFFF, "{%06x}%s (%d){FFFFFF}: %s", GetPlayerColor(playerid) >>> 8, GetPlayerNameEx(playerid), playerid, params);
	return 1;
}

CMD:ask(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "Correct usage: /ask [text]");
	}

	if(PlayerInfo[playerid][pAdmin] > 1)
	{
		SendClientMessageToAllEx(COLOR_PURPLE, "[Ask] %s %s (%d){FFFFFF}: %s", GetStaffRankShort(playerid), GetPlayerNameEx(playerid), playerid, params);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_PURPLE, "[Ask] %s (%d){FFFFFF}: %s", GetPlayerNameEx(playerid), playerid, params);
	}
	return 1;
}

CMD:thawme(playerid, params[])
{
	SetCameraBehindPlayer(playerid);
	SendClientMessage(playerid, -1, "You have been thawed");
}