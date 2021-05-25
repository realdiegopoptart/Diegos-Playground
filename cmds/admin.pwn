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
        SendAdminMessage(COLOR_PUNISH, "AdmCmd: %s (%d) has teleported to %s (%d)", GetPlayerNameEx(playerid),playerid, GetPlayerNameEx(playerb), playerb);
    }

    return 1;
}
