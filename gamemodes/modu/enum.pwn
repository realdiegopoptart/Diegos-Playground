
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
    pNormalSkin,
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

new Float:RandHos[5][3] = {
	{-10.4534, 149.3639, 999.0613},
	{265.7121,177.8508,1003.0234},
	{245.8876,148.6157,1003.0234},
	{239.0486,140.8305,1003.0234},
	{225.1446,141.5526,1003.0234}
};