
enum PlayerData
{
	pID,
    pUsername[32],
	pPassword[129],
	pWhenmade[90],
	pAdmin,
	pLevel,
    pWanted,
    Float:pPos_x,
    Float:pPos_y,
    Float:pPos_z,
    pJob,
    pKills,
    pCash,
    pBank,
    pKicked,
    pLogged,
    pSkin,
    pChatmode,
    pAduty,
    pKnocked
};
new PlayerInfo[MAX_PLAYERS][PlayerData];

new
	MySQL: Database, 
	PlayerIP[MAX_PLAYERS][17]	
;

new query[1024];
new Text3D:WantedTag[MAX_PLAYERS];

enum
{
	DIALOG_NONE = 1,
	DIALOG_DEATH
}