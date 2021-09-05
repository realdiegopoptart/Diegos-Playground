CMD:goto(playerid, params[])
{
    new playerb;

    if(PlayerInfo[playerid][pAdmin] < 1)
    return 0;

    if(sscanf(params, "u", playerb))
    {
        SendClientMessage(playerid, COLOR_ERROR, "/goto [playerid/name]");
        return 1;
    }
    else
    {
        if(!IsPlayerConnected(playerb))
        {
            return SendClientMessage(playerid, COLOR_ERROR, "[Admin]{FFFFFF}: That player is not online");
        }
        TeleportToPlayer(playerid, playerb);
        SendAdminMessage(COLOR_PUNISH, "AdmCmd: %s (%d) has teleported to %s (%d)", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(playerb), playerb);
    }

    return 1;
}

CMD:gotospawn(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
    return 0;

    SetPlayerPos(playerid, 1743.0848, -1946.4824, 13.5591);
    SendAdminMessage(COLOR_PUNISH, "AdmCmd: %s (%d) has teleported to spawn", GetPlayerNameEx(playerid), playerid);
    return 1;
}

CMD:makeadmin(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5) 
    return 0;

    new playerb, adminlvl;

	if(sscanf(params, "ui", playerb, adminlvl)) return SendClientMessage(playerid, COLOR_ERROR, "Correct usage: /makeadmin [playerid/name] [level 0-5]");
    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, COLOR_ERROR,"Error: Player hasn't connected to the server yet.");

    if(adminlvl < 0 || adminlvl > 5) return SendClientMessage(playerid, COLOR_ERROR, "Correct usage: incorrect admin level");
        
    SendClientMessageEx(playerid, COLOR_PUNISH, "You have set %s's admin rank to %s", GetPlayerNameEx(playerb), GetStaffRank(adminlvl));
    SendClientMessageEx(playerb, COLOR_PUNISH, "You have just been made a %s by %s", GetStaffRank(adminlvl), GetPlayerNameEx(playerid));

    PlayerInfo[playerb][pAdmin] = adminlvl;
    mysql_format(Database, querystr, sizeof(querystr), "UPDATE `users` SET `admin` = '%i' WHERE `acc_id` = '%i'", adminlvl, PlayerInfo[playerb][pID]);
    mysql_tquery(Database, querystr);

    return 1;
}
