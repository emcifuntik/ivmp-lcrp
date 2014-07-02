/*
	* Scoreboard 2.0 script (client)
	* IV:MP RC3
	* Author: CrackHD
*/

local guiScoreboard = {};
const ACTIVATION_KEY = "b"; // Key to activate the scoreboard.

// Triggered on script load
function onScriptInit()
{
	// Create window for scoreboard
	guiScoreboard.window <- GUIWindow();
	guiScoreboard.window.setVisible(false);
	local screen = guiGetScreenSize();
	guiScoreboard.window.setSize(600.0, 400.0, false);
	guiScoreboard.window.setPosition(screen[0]/2 - 300, screen[1]/2 -200, false); // center screen
	guiScoreboard.window.setText("Players on server");

	// Create scoreboard list:
	guiScoreboard.list <- GUIMultiColumnList();
	guiScoreboard.list.setParent(guiScoreboard.window.getName());
	guiScoreboard.list.setSize(600.0, 400.0, false);
	
	// Add columns:
	guiScoreboard.list.setProperty("ColumnHeader", "text:ID width:{0.1,0} id:0");
	guiScoreboard.list.setProperty("ColumnHeader", "text:Name width:{0.49,0} id:1 ");
	guiScoreboard.list.setProperty("ColumnHeader", "text:Ping width:{0.1,0} id:2");
	guiScoreboard.list.setProperty("ColumnHeader", "text:Reputation width:{0.1,0} id:3");
	
	// Start update timer (tick):
	if(guiScoreboard.window.getVisible != null) // DEV
	timer(onTick, 1000, -1);
}
addEvent("scriptInit", onScriptInit);

// Triggered on script unload
function onScriptExit()
{
	// Delete gui...
	guiScoreboard.window.setVisible(false);
}
addEvent("scriptExit", onScriptExit);

// Triggered when a player disconnected from server (triggered by server's indicators.nut!)
function onPlayerDisconnect(playerid, reason)
{
	// Remove his row from scoreboard table
	local row = ensurePlayerRow(playerid);
	guiScoreboard.list.removeRow(row);
}
addEvent("playerDisconnectEx", onPlayerDisconnect);

// Triggered when player clicks a row in a list
/*function onRowClick(guiName, rowNumber)
{
	// Ensure it is scoreboard list
	if(guiName == guiScoreboard.list.getName())
	{
		// TODO: Do something..
	}
}
addEvent("rowClick", onRowClick);*/

// Triggered when player press a key
function onKeyPress(key, state)
{
	// Show/hide our window
	if(key == ACTIVATION_KEY)
	{
		local bActive = (state == "down");		
		
		guiScoreboard.window.setVisible(bActive);
		//guiToggleCursor(bActive);
		//togglePlayerControls(localplayerid, !bActive); on Server - TODO
		
		if(bActive) onTick();
	}
}
addEvent("keyPress", onKeyPress);

// Our tick event (timer)
function onTick()
{
	if(guiScoreboard.window.getVisible() == false) return;
	for(local i = 0; i < MAX_PLAYERS; i++) if(isPlayerConnected(i)) updatePlayerRow(i);
}

function updatePlayerRow(playerid)
{
	local row = ensurePlayerRow(playerid);
	guiScoreboard.list.setItem(playerid.tostring(), 0, row);
	guiScoreboard.list.setItem(getPlayerName(playerid), 1, row);
	guiScoreboard.list.setItem(getPlayerPing(playerid).tostring(), 2, row);
	guiScoreboard.list.setItem("0", 3, row);
}

// Make sure row for player exists, and return its row ID
function ensurePlayerRow(playerid)
{
	local insert_at = 0;
	for(local i = 0; i < MAX_PLAYERS; i++)
	{
		local id = guiScoreboard.list.getItem(i, 0);
		if(id == false || id.tointeger() > playerid)
		{
			insert_at = i;
			break;
		}
		else if(id.tointeger() == playerid) return i;
	}
	
	return guiScoreboard.list.addRow(insert_at);
}

