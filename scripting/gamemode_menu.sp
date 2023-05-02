#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#include <ripext>
#pragma semicolon 1

ConVar gm_config;
ConVar gm_config_name;
ConVar gm_generate_password;
ConVar gm_cvPassword;
char runner_steam_id[20] = "";
char runner_discord_id[30] = "";

public Plugin myinfo = 
{
	name = "Gamemode Menu", 
	author = "oog | tf.oog.pw", 
	description = "", 
	version = "1.1.2", 
	url = "https://github.com/Ooglely/tf-server-plugins"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_gamemode", Command_GamemodeMenu, ADMFLAG_ROOT);
	RegAdminCmd("sm_connect", Command_Connect, ADMFLAG_ROOT);
	
	gm_config = CreateConVar("gm_config", "0", "Enable config execute or not");
	gm_config_name = CreateConVar("gm_config_name", "oog_mge", "Name of config to exec on map start");
	gm_generate_password = CreateConVar("gm_generate_password", "0", "Generate a new password on map startup");
}

public void OnMapStart()
{
	if (gm_config.IntValue == 1)
	{
		char[] map_config = new char[32];
		gm_config_name.GetString(map_config, 32);
		ServerCommand("exec %s", map_config);
		gm_config.SetInt(0);
	}
	
	if (gm_generate_password.IntValue == 1)
	{
		char[] password = new char[16];
		GeneratePassword(password);
		ServerCommand("sv_password %s", password);
		SendConnectDM(password);
		gm_generate_password.SetInt(0);
	}
}

public int GamemodeHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Display:
		{
			Panel panel = view_as<Panel>(param2);
			panel.SetTitle("Select Gamemode");
		}
		
		case MenuAction_Select:
		{
			char selection[32];
			menu.GetItem(param2, selection, sizeof(selection));
			
			if (StrEqual(selection, "Highlander"))
			{
				Display_HighlanderMenu(param1);
			}
			else if (StrEqual(selection, "Sixes"))
			{
				Display_SixesMenu(param1);
			}
			else if (StrEqual(selection, "Ultiduo"))
			{
				Display_UltiduoMenu(param1);
			}
			else if (StrEqual(selection, "MGE"))
			{
				gm_generate_password.SetInt(0, false, false);
				gm_config.SetInt(1, false, false);
				ServerCommand("exec oog_mge");
				ServerCommand("changelevel mge_chillypunch_final4_fix2");
				gm_config_name.SetString("oog_mge");
			}
		}
		
		case MenuAction_End:
		{
			delete menu;
		}
		
		case MenuAction_DrawItem:
		{
			int style;
			char info[32];
			menu.GetItem(param2, info, sizeof(info), style);
			
			return style;
		}
		
		case MenuAction_DisplayItem:
		{
			char info[32];
			menu.GetItem(param2, info, sizeof(info));
		}
	}
	return 0;
}

public int HLMapMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Display:
		{
			Panel panel = view_as<Panel>(param2);
			panel.SetTitle("Select Map");
		}
		
		case MenuAction_Select:
		{
			char selection[32];
			menu.GetItem(param2, selection, sizeof(selection));
			
			char currentMap[60];
			
			GetCurrentMap(currentMap, sizeof(currentMap));
			
			if (StrContains(currentMap, "mge_") != -1)
			{
				gm_generate_password.SetInt(1, false, false);
				SaveClientSteamID(param1);
				KickClient(param1, "Connect should be DM'd to you on Discord");
				ServerCommand("kickall \"Server switching to a scrim setup. Ask the person running the scrim for the new connect\"");
			}
			else
			{
				gm_generate_password.SetInt(0, false, false);
			}
			
			if (StrContains(selection, "koth_") != -1)
			{
				ServerCommand("exec oog_HL_scrim_koth");
				ServerCommand("exec rgl_HL_koth_bo5");
				gm_config.SetInt(1, false, false);
				gm_config_name.SetString("rgl_HL_koth_bo5");
				ServerCommand("changelevel %s", selection);
			}
			else
			{
				ServerCommand("exec oog_HL_scrim_pl");
				ServerCommand("exec rgl_HL_stopwatch");
				gm_config.SetInt(1, false, false);
				gm_config_name.SetString("rgl_HL_stopwatch");
				ServerCommand("changelevel %s", selection);
			}
		}
		
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

public int SixesMapMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Display:
		{
			Panel panel = view_as<Panel>(param2);
			panel.SetTitle("Select Map");
		}
		
		case MenuAction_Select:
		{
			char selection[32];
			menu.GetItem(param2, selection, sizeof(selection));
			
			char currentMap[60];
			
			GetCurrentMap(currentMap, sizeof(currentMap));
			
			if (StrContains(currentMap, "mge_") != -1)
			{
				gm_generate_password.SetInt(1, false, false);
				SaveClientSteamID(param1);
				KickClient(param1, "Connect should be DM'd to you on Discord");
				ServerCommand("kickall \"Server switching to a scrim setup. Ask the person running the scrim for the new connect\"");
			}
			else
			{
				gm_generate_password.SetInt(0, false, false);
			}
			
			if (StrContains(selection, "koth_") != -1)
			{
				ServerCommand("exec oog_6s_scrim_koth");
				ServerCommand("exec rgl_6s_koth_bo5");
				gm_config.SetInt(1, false, false);
				gm_config_name.SetString("rgl_6s_koth_bo5");
				ServerCommand("changelevel %s", selection);
			}
			else
			{
				ServerCommand("exec oog_6s_scrim_5cp");
				ServerCommand("exec rgl_6s_5cp_scrim");
				gm_config.SetInt(1, false, false);
				gm_config_name.SetString("rgl_6s_5cp_scrim");
				ServerCommand("changelevel %s", selection);
			}
		}
		
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

public int UltiduoMapMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Display:
		{
			Panel panel = view_as<Panel>(param2);
			panel.SetTitle("Select Map");
		}
		
		case MenuAction_Select:
		{
			char selection[32];
			menu.GetItem(param2, selection, sizeof(selection));
			
			char currentMap[60];
			GetCurrentMap(currentMap, sizeof(currentMap));
			
			if (StrContains(currentMap, "mge_") != -1)
			{
				gm_generate_password.SetInt(1, false, false);
				SaveClientSteamID(param1);
				KickClient(param1, "Connect should be DM'd to you on Discord");
				ServerCommand("kickall \"Server switching to a scrim setup. Ask the person running the scrim for the new connect\"");
			}
			else
			{
				gm_generate_password.SetInt(0, false, false);
			}
			
			ServerCommand("exec oog_UD");
			ServerCommand("exec ugc_UD_ultiduo");
			gm_config.SetString("ugc_UD_ultiduo");
			ServerCommand("changelevel %s", selection);
		}
		
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

public Action Command_GamemodeMenu(int client, int args)
{
	Menu menu = new Menu(GamemodeHandler, MENU_ACTIONS_ALL);
	menu.SetTitle("%s", "Menu Title", LANG_SERVER);
	menu.AddItem("Highlander", "Highlander");
	menu.AddItem("Sixes", "Sixes");
	menu.AddItem("Ultiduo", "Ultiduo");
	menu.AddItem("MGE", "MGE");
	menu.ExitButton = true;
	menu.Display(client, 20);
	
	return Plugin_Handled;
}

void Display_HighlanderMenu(int client)
{
	Menu menu = new Menu(HLMapMenuHandler, MENU_ACTIONS_ALL);
	menu.SetTitle("%s", "Menu Title", LANG_SERVER);
	
	AddMapsToMenu(menu, "addons/sourcemod/configs/gamemode-menu/highlander_maps.txt");
	
	menu.ExitButton = true;
	menu.Display(client, 20);
}

void Display_SixesMenu(int client)
{
	Menu menu = new Menu(SixesMapMenuHandler, MENU_ACTIONS_ALL);
	menu.SetTitle("%s", "Menu Title", LANG_SERVER);
	
	AddMapsToMenu(menu, "addons/sourcemod/configs/gamemode-menu/sixes_maps.txt");
	
	menu.ExitButton = true;
	menu.Display(client, 20);
}

void Display_UltiduoMenu(int client)
{
	Menu menu = new Menu(UltiduoMapMenuHandler, MENU_ACTIONS_ALL);
	menu.SetTitle("%s", "Menu Title", LANG_SERVER);
	
	AddMapsToMenu(menu, "addons/sourcemod/configs/gamemode-menu/ultiduo_maps.txt");
	
	menu.ExitButton = true;
	menu.Display(client, 20);
}

public Action Command_Connect(int client, int args)
{	
	char[] server_password = new char[16];
	gm_cvPassword = FindConVar("sv_password");
	gm_cvPassword.GetString(server_password, 16);
	PrintToChat(client, "%s", "Connect for the current server:");
	PrintToChat(client, "connect ip.oog.pw; password %s", server_password);
	
	char[] map_config = new char[32];
	gm_config.GetString(map_config, 32);
	PrintToChat(client, "Config is: %s", map_config);

	return Plugin_Handled;
}

public char GeneratePassword(char[] pass)
{
	char choices[] = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	for (new i = 0; i < 16; i++)
	{
		pass[i] = choices[GetRandomInt(0, 61)];
	}
	PrintToServer("Password generated: %s", pass);

	return pass[16];
}

public SaveClientSteamID(int client)
{
	GetClientAuthId(client, AuthId_SteamID64, runner_steam_id, 20, true);
	PrintToServer("Runner Steam ID saved: %s", runner_steam_id);
}

static void SendConnectDM(char[] password)
{
	char db_error[255];
	Database db = SQL_Connect("gamemode-menu", false, db_error, sizeof(db_error));
	if (db == null)
	{
		PrintToServer("Could not connect: %s", db_error);
	}
	else
	{
		PrintToServer("Successful database connection");
	}
	
	char query_command[512];
	Format(query_command, sizeof(query_command), "SELECT discordID FROM admins WHERE steamID = '%s'", runner_steam_id);
	
	DBResultSet query = SQL_Query(db, query_command);
	if (query == null)
	{
		char q_error[255];
		SQL_GetError(db, q_error, sizeof(q_error));
		PrintToServer("Failed to query (error: %s)", q_error);
	}
	else if (query.RowCount == 0)
	{
		PrintToServer("Failed to query: 0 rows");
	}
	else
	{
		while (SQL_FetchRow(query))
		{
			PrintToServer("Fetched row");
			query.FetchString(0, runner_discord_id, sizeof(runner_discord_id));
			PrintToServer("Name \"%s\" was found.", runner_discord_id);
			
			JSONObject ServerDM = new JSONObject();
			
			ServerDM.SetString("discordID", runner_discord_id);
			
			PrintToServer("Server password is currently: %s", password);
			
			char connect_command[255];
			Format(connect_command, sizeof(connect_command), "connect ip.oog.pw; password %s", password);
			ServerDM.SetString("connectCommand", connect_command);
			
			HTTPRequest connectPost = new HTTPRequest("https://api.oog.pw/api/send_connect");
			connectPost.Post(ServerDM, ConnectSent);
			
			delete ServerDM;
		}
		
		delete query;
	}
}

static void ConnectSent(HTTPResponse response, any value)
{
	PrintToServer("Sent request to bot: %s", runner_discord_id);
}

void AddMapsToMenu(Menu menu, char[] map_list_file)
{
	File file = OpenFile(map_list_file, "rt");
	
	char mapname[255];
	while (!file.EndOfFile() && file.ReadLine(mapname, sizeof(mapname)))
	{
		if (mapname[0] == ';' || !IsCharAlpha(mapname[0]))
		{
			continue;
		}
		
		int len = strlen(mapname);
		for (int i = 0; i < len; i++)
		{
			if (IsCharSpace(mapname[i]))
			{
				mapname[i] = '\0';
				break;
			}
		}
		
		if (!IsMapValid(mapname))
		{
			continue;
		}
		
		menu.AddItem(mapname, mapname);
	}
	
	file.Close();
}