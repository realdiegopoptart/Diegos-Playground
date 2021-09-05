public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_DEATH)
    {
        switch(listitem)
        {
            case 0:
            {
		        new s_loc = random(5);
                SendClientMessage(playerid, COLOR_LIME, "Respawning: {FFFFFF}Random Hospital");
                SetPlayerPos(playerid, RandHos[s_loc][0], RandHos[s_loc][1], RandHos[s_loc][2]);
            }
            case 1:
            {

            }
            case 2:
            {
                
            }
        }
    }
	return 1;
}