#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#pragma newdecls required
#pragma semicolon 1


public Plugin myinfo =
{
	name = "Gamemode Menu",
	author = "oog | tf.oog.pw",
	description = "",
	version = "0.1.0",
	url = "https://github.com/Ooglely/tf-server-plugins"
};


public void OnPluginStart()
{
	RegAdminCmd("sm_gamemode", Command_GamemodeMenu, ADMFLAG_ROOT);
}

public int GamemodeHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
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
      			PrintToChat(param1, "%s", "Highlander option was chosen");
      			Display_HighlanderMenu(param1);
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

public int MapMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
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
      		
      		if (StrContains(selection, "koth_"))
      		{
      			ServerCommand("changelevel %s; exec oog_HL_scrim_koth", selection);
      		}
      		
      		if (StrContains(selection, "pl_"))
      		{
      			ServerCommand("changelevel %s; exec oog_HL_scrim_pl", selection);
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
	Menu menu = new Menu(MapMenuHandler, MENU_ACTIONS_ALL);
	menu.SetTitle("%s", "Menu Title", LANG_SERVER);
	menu.AddItem("koth_product_final", "koth_product");
	menu.AddItem("koth_ashville_final", "koth_ashville");
	menu.AddItem("pl_swiftwater_final1", "pl_swiftwater");
	menu.AddItem("pl_upward_f10", "pl_upward");
	menu.ExitButton = true;
	menu.Display(client, 20);
}