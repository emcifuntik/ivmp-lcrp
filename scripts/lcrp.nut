/*
* Date: 05.07.2013
* Time: 11:06
* Author: funtik
* Filename: lcrp-oop.nut
*/

const MAX_CARS = 1000;
const MAX_PLAYERS = 48;
const MAX_PLAYER_NAME = 16;
const ERROR = 1;
const ALERT = 2;
const ADVICE = 3;
local MySQL = { };
/*
MySQL.Host <- "localhost";
MySQL.User <- "root";
MySQL.Password <- "1232356";
MySQL.Database <- "ivmp";
*/
MySQL.Host <- "localhost";
MySQL.User <- "root";
MySQL.Password <- "1232356";
MySQL.Database <- "ivmp";
MySQL.Handler <- 0;
//#Определения цветов#//
local Color = { };
Color.White <- 0xFFFFFFFF;
Color.Black <- 0x000000AA;
Color.Red <- 0xFF0000AA;
Color.Gray <- 0x808080AA;
Color.Blue <- 0x0000FFFF;
Color.Yellow <- 0xFFFF00FF;
Color.LightBlue <- 0x00FFFFFF;
Color.Pink <- 0xFF00FFFF;
Color.Orange <- 0xFF8000FF;
Color.Green <- 0x00FF00FF;
//#Система создания домов#//
local HouseName = array(MAX_PLAYERS, "");
local HouseEnX = array(MAX_PLAYERS, 0.0);
local HouseEnY = array(MAX_PLAYERS, 0.0);
local HouseEnZ = array(MAX_PLAYERS, 0.0);
local HouseExX = array(MAX_PLAYERS, 0.0);
local HouseExY = array(MAX_PLAYERS, 0.0);
local HouseExZ = array(MAX_PLAYERS, 0.0);
local HousePrice = array(MAX_PLAYERS, 0);
//#Система создания бизов#//
local BizName = array(MAX_PLAYERS, "");
local BizEnX = array(MAX_PLAYERS, 0.0);
local BizEnY = array(MAX_PLAYERS, 0.0);
local BizEnZ = array(MAX_PLAYERS, 0.0);
local BizExX = array(MAX_PLAYERS, 0.0);
local BizExY = array(MAX_PLAYERS, 0.0);
local BizExZ = array(MAX_PLAYERS, 0.0);
local BizPrice = array(MAX_PLAYERS, 0);

local skins = [
0,4,5,6,7,8,9,10,11,12,
13,14,15,16,17,18,19,20,21,22,23,24,25,
26,27,28,29,30,31,32,33,34,35,36,37,38,
39,40,41,42,43,44,45,46,47,48,49,58,59,
60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,
81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,
101,102,103,104,105,106,107,108,110,116,117,119,120,
122,125,126,131,132,138,139,141,142,143,144,145,146,
147,149,153,154,155,157,158,159,161,163,164,165,170,
171,175,176,177,178,185,186,187,189,192,193,194,198,199,200,
204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,
219,220,221,222,223,224,225,226,227,229,230,231,232,233,234,
235,237,238,239,240,241,242,243,244,245,246,247,248,249,250,
251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,
266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,
281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,
296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,
311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,
326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,
341,342,343,344,345
];    
//#Стритрейсеры#//
local driftTime = array(MAX_PLAYERS,0);
local driftN = array(MAX_PLAYERS, 0);
local driftMoney = array(MAX_PLAYERS, 0);
//#Оружие#//
local wName = array(11, "");
wName = [ "Grenade" , "Molotov" , "Pistol" , "Combat Pistol" , "Pump Shotgun" , "Combat Shotgun" , "Micro SMG" , "SMG" , "AK 47" , "M4A1" , "Combat Sniper" , "Sniper Rifle" ];
//#Данные об игроке#//
local Player = array(MAX_PLAYERS, null);
local PlayerInfo = { };
const INVALID_PLAYER_ID = -1;
//#Данные для запроса Y N#//
local Request = { };
const FACTION_INVITE = 1;
const FACTION_GIVERANK = 2; //новое
const LICENSE = 3;//новое
//#Система автовладения#//
local Car = { };
local VehicleData = array(MAX_CARS, -1);
local car;
local CarSpawn = { };
CarSpawn[0] <- { };//14.136469, 856.919495, 12.856108, 0.297302, 359.913330, 269.565491
CarSpawn[0].x <- 14.136469;
CarSpawn[0].y <- 856.919495;
CarSpawn[0].z <- 12.856108;
CarSpawn[0].ax <- 0.0;
CarSpawn[0].ay <- 0.0;
CarSpawn[0].az <- 270.0;
CarSpawn[1] <- { };//12.854918, 866.244507, 12.811810, 1.939819, 359.829956, 269.695923
CarSpawn[1].x <- 12.854918;
CarSpawn[1].y <- 866.244507;
CarSpawn[1].z <- 12.811810;
CarSpawn[1].ax <- 0.0;
CarSpawn[1].ay <- 0.0;
CarSpawn[1].az <- 270.0;
CarSpawn[2] <- { };//13.178232, 877.263672, 12.847946, 359.881226, 0.092651, 271.443298
CarSpawn[2].x <- 13.178232;
CarSpawn[2].y <- 877.263672;
CarSpawn[2].z <- 12.847946;
CarSpawn[2].ax <- 0.0;
CarSpawn[2].ay <- 0.0;
CarSpawn[2].az <- 270.0
local CarBuyCP;
//#Скины фракций#//
local Skins = [
	[ 0 ],
	[ 173, 174, 136, 133 ],
	[ 134, 201, 190 ],
	[ 137, 170 ],
	[ 127, 128, 109, 118, 184, 195 ],
	[ 84, 85, 104, 125, 168, 217 ],
	[ 92, 93, 94, 95, 96, 97, 98, 99 ],
	[ 10, 90, 91, 121, 143, 186 ],
	[ 139, 7, 17, 261, 281, 341 ],
	[ 205, 265, 290, 294 ],
	[ 299, 303, 260, 250, 222 ],
	[ 62, 63, 64, 65, 86, 87 ],
	[ 88, 89, 204, 309, 310, 311 ],
	[ 79, 80, 81, 82, 83 ],
	[ 70, 71, 72, 73, 74, 208 ]
];
			
//#Ежечасный таймер#//
local Timer;
//#Переменная класса домов#//
local Houses;
//#Переменная класса бизов#//
local Biz;
//#Фракции#//
local factionName = array(16, "");//новое
factionName = [ "Гражданский", "US Army", "Police Department", "Ambulance", "Fire Department", "Justice Ministry", "Department of Education", "Department of Homeland Security", "Department of the Interior", "La Cosa Nostra", "Yakuza", "Triad", "Crips", "MS-13", "Jamaican Posse", "Bikers" ]; //новое
//#Переменные игрока#//
local SkinChoose = array(MAX_PLAYERS, false);
local CurrSkin = array(MAX_PLAYERS, 0);//текущий скин при перемотке
//#Инициализация мода#//
function onScriptInit()
{	
    log("Liberty City RolePlay by Funtik");
	log("Загружено моделей персонажей: "+skins.len());
    MysqlConnection(true);
	CreateBlips();
	Houses = houses(MySQL.Handler);
	Biz = biz(MySQL.Handler);
	Houses.Load();
	log("Дома загружены");
    Biz.Load();
	log("Бизнесы загружены");
	loadCars();
	log("Личный транспорт загружен");
    local Date = date();
    for(local i = 0; i < 123; i++) loadClientResource("Car"+i+".jpg");
	log("Изображения транспорта загружены");
	Timer = timer(oneHourTimer, 60*60*100, -1);
	timer(onSecondTimer, 1000, -1);
    timer(onDriftTimer, 500, -1);
    log("Start time: "+Date["hour"]+":"+Date["min"]+":"+Date["sec"]);
    setTime(Date["hour"], Date["min"]);
    setMinuteDuration(60000);
    setDayOfWeek(Date["wday"]);
	setWeather(random(1,9));
	log("Настройки погоды, времени и даты установлены.");
	CarBuyCP = createCheckpoint ( 6, 80.416382, 801.363831, 14.0, 60.416382, 700.363831, -1400.0, 0.25);
    return true;
}
addEvent("scriptInit", onScriptInit);

function onScriptExit()
{
    saveCars();
	Houses.Save();
	Biz.Save();
	for(local i = 0; i < MAX_PLAYERS; ++i) if(isPlayerConnected(i)) Player[i].Disconnect();
    return true;
}
addEvent("scriptExit", onScriptExit);

function onPlayerAuth(playerID, playerName, playerIP, playerSerial, bHasModdedGameFiles)
{
	log("Игрок " + playerName + "[HID: " + playerSerial + ", IP : " + playerIP + "] авторизируется на сервере.");
	if(bHasModdedGameFiles) 
	{
		log("Игрок " + playerName + "[HID: " + playerSerial + ", IP : " + playerIP + "] не прошёл авторизацию. Причина: Игровые файлы модифицированы.");
		kickPlayer(playerID);
	}
	return 1;
}
addEvent("playerAuth", onPlayerAuth);

//#Подключение игрока, обнуление переменных после предыдущего игрока#//
function onPlayerConnect( playerid, name)
{
	setPlayerSpawnLocation(playerid, -1076.912231, -432.198792, 1.971985, 186.684204);
	Player[playerid] = player(playerid, MySQL.Handler);
	Request[playerid] <- { };
	Request[playerid].ReqType <- 0;
	Request[playerid].Params <- 0;
	Request[playerid].SecondFace <- -1;
	SkinChoose[playerid] = false;
    log("Player '" + name + "' connected to the server!");	
    return true;
}
addEvent("playerConnect", onPlayerConnect);

function onPlayerJoin ( playerid )
{
	Player[playerid].Join();
    return true;
}
addEvent("playerJoin", onPlayerJoin);

function onPlayerDisconnect ( playerid, reason )
{
	Player[playerid].Disconnect(reason);
	Player[playerid] = null;
	return true;
}
addEvent("playerDisconnect", onPlayerDisconnect);

function onPlayerRegister ( playerid, password )
{
	Player[playerid].Register(password);
	return true;
}
addEvent("playerRegister", onPlayerRegister);

function onPlayerLogin ( playerid, password )
{
	Player[playerid].Login(password);
	return true;
}
addEvent("playerLogin", onPlayerLogin);

function onYesnoRequest( playerid, yn )
{
	if(Request[playerid].ReqType != 0)
	{
		switch(Request[playerid].ReqType)
		{
			case FACTION_INVITE:
				if(yn)
				{
					Player[playerid].Info.Faction.Number = Request[playerid].Params;
					Player[playerid].Info.Faction.Rank = 1;
					Player[playerid].Info.Faction.Skill = 0;
					msg(Request[playerid].SecondFace, ALERT, getPlayerName(playerid)+" принял ваше предложение на вступление во фракцию.");
					msg(playerid, ALERT, "Вы стали членом фракции "+factionName[Player[playerid].Info.Faction.Number]);
					msg(playerid, ADVICE, "Чтобы выбрать подходящий скин используйте стрелки (<-, ->).");
					msg(playerid, ADVICE, "Чтобы окончить выбор нажмите 'Пробел'.");
					SkinChoose[playerid] <- true;
					Request[playerid].ReqType = 0;
					Request[playerid].Params = 0;
					Request[playerid].SecondFace = 0;
					return true;
				}
				else
				{
					msg(Request[playerid].SecondFace, ALERT, getPlayerName(playerid)+" отказался от вашего предложения на вступлению во фракцию.");
					Request[playerid].ReqType = 0;
					Request[playerid].Params = 0;
					Request[playerid].SecondFace = 0;
					return true;
				}
			break;
			case FACTION_GIVERANK: //новое
                if(yn)
                {
                    Player[playerid].Info.Faction.Rank = Request[playerid].Params;
                    msg(Request[playerid].SecondFace, ALERT, getPlayerName(playerid)+" принял ваше предложение на повышение ранга.");
                    msg(playerid, ALERT, "Вас повысили до " + Request[playerid].Params);
                }
                else
                {
                    msg(Request[playerid].SecondFace, ALERT, getPlayerName(playerid)+" отказался от вашего предложения на повышение ранга.");
                    Request[playerid].ReqType = 0;
                    Request[playerid].Params = 0;
                    Request[playerid].SecondFace = 0;
                }
            break;
			case LICENSE://новое
			{
				if(yn)
				{
					switch(Request[playerid].Params)
					{
						case "car":
							
							Player[playerid].License.Car = 1;
							givePlayerMoney(playerid,-1000);
							msg(playerid,ALERT,"Вы приняли предложение");
							msg(Request[playerid].SecondFace,ALERT,"Игрок принял предложение");
							Request[playerid].ReqType = 0;
							Request[playerid].Params = 0;
							Request[playerid].SecondFace = 0;
							break;
						case "fly":
							Player[playerid].License.Fly = 1;
							givePlayerMoney(playerid,-15000);
							msg(playerid,ALERT,"Вы приняли предложение");
							msg(Request[playerid].SecondFace,ALERT,"Игрок принял предложение");
							Request[playerid].ReqType = 0;
							Request[playerid].Params = 0;
							Request[playerid].SecondFace = 0;
							break;
						case "water":
							Player[playerid].License.Water = 1;
							givePlayerMoney(playerid,-5000);
							msg(playerid,ALERT,"Вы приняли предложение");
							msg(Request[playerid].SecondFace,ALERT,"Игрок принял предложение");
							Request[playerid].ReqType = 0;
							Request[playerid].Params = 0;
							Request[playerid].SecondFace = 0;
							break;
						case "motorcycle":
							Player[playerid].License.Motorcycle = 1;
							givePlayerMoney(playerid,-5000);
							msg(playerid,ALERT,"Вы приняли предложение");
							msg(Request[playerid].SecondFace,ALERT,"Игрок принял предложение");
							Request[playerid].ReqType = 0;
							Request[playerid].Params = 0;
							Request[playerid].SecondFace = 0;
							break;
					}
				}
				else
				{
					msg(playerid,ERROR,"Вы отказались от предложенной сделки");
					msg(Request[playerid].SecondFace,ERROR,"Игрок отказался от предложенной сделки");
					Request[playerid].ReqType = 0;
					Request[playerid].Params = 0;
					Request[playerid].SecondFace = 0;
					return true;
				}
			}
			break;
		}			
	}
}
addEvent("yesnoRequest", onYesnoRequest);
//#PlayerSpawn#//
function onPlayerSpawn( playerid )
{
	Player[playerid].Spawn();
	return true;
}
addEvent("playerSpawn", onPlayerSpawn);

function onPlayerChangeState( playerid, oldstate, newstate )
{
    return true;
}
addEvent("playerChangeState", onPlayerChangeState);

function onPlayerChangePadState( playerid )
{
    return true;
}
addEvent("playerChangePadState", onPlayerChangePadState);
function onVehicleEntryRequest(playerid, vehicleid, seatid)
{
	if(seatid == 0)
	{
		switch(modelVehicle(getVehicleModel(vehicleid)))
		{
			case "car":
				if(Player[playerid].License.Car == 0 || Player[playerid].License.Car > 1)
				{
					msg(playerid, ALERT, "Вы не имеете лицензию на это транспортное средство");
					return false;
				}
				break;
			case "motorcycle":
				if(Player[playerid].License.Motorcycle == 0 || Player[playerid].License.Motorcycle > 1)
				{
					msg(playerid, ALERT, "Вы не имеете лицензию на это транспортное средство");
					return false;
				}
				break;
			case "fly":
				if(Player[playerid].License.Fly == 0 || Player[playerid].License.Fly > 1)
				{
					msg(playerid, ALERT, "Вы не имеете лицензию на это транспортное средство");
					return false;
				}
				break;
			case "water":
				if(Player[playerid].License.Water == 0 || Player[playerid].License.Water > 1)
				{
					msg(playerid, ALERT, "Вы не имеете лицензию на это транспортное средство");
					return false;
				}
				break;
		}
	}
	return 1;
}
addEvent("vehicleEntryRequest", onVehicleEntryRequest);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////Commands///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
function onPlayerCommand(playerid, command)
{
	local cmd = split(command, " ");
	local giveplayerid;
	switch(cmd[0])
	{
		case "/help":
			sendPlayerMessage(playerid, "Помощь по командам сервера", colorGreen);
			break;
		case "/restart":
			reloadScript("lcrp.nut");
			sendPlayerMessage(playerid, "Server restarting...", colorYellow);
			break;
		case "/weap":
			if(Player[playerid].Info.Admin < 5)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 3)
			{
				msg(playerid, ADVICE, "/weap [ID Оружия (1-18)] [Количество патронов (1-999)]");
				return true;
			}
			if(!isNumeric(cmd[1]))
			{
				msg(playerid, ADVICE, "/weap [ID Оружия [FF0000AA](1-18)[AAAAAAAA]] [Количество патронов (1-999)]");
				return true;
			}
			if(!isNumeric(cmd[2]))
			{
				msg(playerid, ADVICE, "/weap [ID Оружия (1-18)] [Количество патронов [FF0000AA](1-999)[AAAAAAAA]]");
				return true;
			}
			local weapon = cmd[1].tointeger();
			if(weapon < 1 || weapon > 18)
			{
				msg(playerid, ADVICE, "/weap [ID Оружия [FF0000AA](1-18)[AAAAAAAA]] [Количество патронов (1-999)]");
				return true;
			}
			local ammo = cmd[2].tointeger();
			if(ammo < 1 || ammo > 999)
			{
				msg(playerid, ADVICE, "/weap [ID Оружия (1-18)] [Количество патронов [FF0000AA](1-999)[AAAAAAAA]]");
				return true;
			}
			givePlayerWeapon(playerid, weapon, ammo);
			break;
		case "/goto":
			if(Player[playerid].Info.Admin < 3)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 2)
			{
				msg(playerid, ADVICE, "/goto [ID Игрока или часть имени (A-Z,a-z | 1-32)]");
				return true;
			}
			giveplayerid = returnUser(cmd[1]);
			if(giveplayerid == -1)
			{
				msg(playerid, ERROR, "Игрока в данный момент нет онлайн и/или вы используете неверное имя/ID.");
				return true;
			}
			local pos = getPlayerCoordinates(giveplayerid);
			setPlayerCoordinates(playerid, pos[0], pos[1], pos[2]);
			break;
		//#Команды администрации#//
		case "/heal":
			if(Player[playerid].Info.Admin < 5)
			{
				haveNoPermissions(playerid);
				return true;
			}
			setPlayerHealth(playerid, 100);
			setPlayerArmour(playerid, 100);
			break;	
		case "/makeadmin":
			if(Player[playerid].Info.Admin < 5)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 3)
			{
				msg(playerid, ADVICE, "/makeadmin [ID Игрока или часть имени (A-Z,a-z | 1-32)] [Уровень администратора (0-5)]");
				return true;
			}
			giveplayerid = returnUser(cmd[1]);
			if(giveplayerid == -1)
			{
				msg(playerid, ERROR, "Игрока в данный момент нет онлайн и/или вы используете неверное имя/ID.");
				return true;
			}
			if(!isNumeric(cmd[2].tointeger()))
			{
				msg(playerid, ADVICE, "/makeadmin [ID Игрока или часть имени (A-Z,a-z | 1-32)] [Уровень администратора [FF0000FF](0-5)[AAAAAAAA]]");
				return true;
			}
			local level = cmd[2].tointeger();
			if(level < 0 || level > 5)
			{
				msg(playerid, ADVICE, "/makeadmin [ID Игрока или часть имени (A-Z,a-z | 1-32)] [Уровень администратора [FF0000FF](0-5)[AAAAAAAA]]");
				return true;
			}
			Player[giveplayerid].Info.Admin = level;
			msg(giveplayerid, ALERT, ((level == 0) ? (getPlayerName(playerid) + " снял вас с должности администратора.") : (getPlayerName(playerid) + " назначил вас на пост администратора "+level+"-го уровня.")));
			msg(playerid, ALERT, "Уровень администрирования игрока "+getPlayerName(giveplayerid)+" успешно изменён.");
			break;
		case "/ban":
			if(Player[playerid].Info.Admin < 5)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 3)
			{
				msg(playerid, ADVICE, "/ban [ID Игрока или часть имени (A-Z,a-z | 1-32)] [Количество дней (1-65535)] [Причина (А-Я,а-я,A-Z,a-z | 0-9)]");
				return true;
			}
			giveplayerid = returnUser(cmd[1]);
			if(giveplayerid == -1)
			{
				msg(playerid, ERROR, "Игрока в данный момент нет онлайн и/или вы используете неверное имя/ID.");
				return true;
			}
			if(!isNumeric(cmd[2].tointeger()))
			{
				msg(playerid, ADVICE, "/ban [ID Игрока или часть имени (A-Z,a-z | 1-32)] [Количество дней [FF0000FF](1-65535)[AAAAAAAA]] [Причина (А-Я,а-я,A-Z,a-z | 0-9)]");
				return true;
			}
			local days = cmd[2].tointeger();
			if(days < 1 || days > 65535)
			{
				msg(playerid, ADVICE, "/ban [ID Игрока или часть имени (A-Z,a-z | 1-32)] [Количество дней [FF0000FF](1-65535)[AAAAAAAA]] [Причина (А-Я,а-я,A-Z,a-z | 0-9)]");
				return true;
			}
			local reason = command.slice(cmd[0].len() + cmd[1].len() + cmd[2].len() + 3);
			msg(giveplayerid, ALERT, "Ваш аккаунт был заблокирован администратором "+getPlayerName(playerid)+" на "+days+" дней. Причина: "+reason);
			sendMessageToAdmin("Аккаунт "+getPlayerName(giveplayerid)+" был заблокирован на "+days+" дней. Причина: "+reason, 1);
			Player[giveplayerid].Ban(days);
			break;
		case "/unban":
			if(Player[playerid].Info.Admin < 5)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 2)
			{
				msg(playerid, ADVICE, "/unban [Имя игрока (A-Z,a-z,_)]");
				return true;
			}
			local name = mysql_escape_string(MySQL.Handler, cmd[1]);
			local result = mysql_query(MySQL.Handler, "UPDATE `users` SET `Banned`='0' WHERE `Name`='"+name+"' AND `Banned`<>'0' LIMIT 1;");
			local num = mysql_affected_rows(MySQL.Handler);
			if(num != 0) sendMessageToAdmins("Аккаунт игрока "+name+" был разблокирован.", 3);
			else msg(playerid, ERROR, "Аккаунт "+name+" не найден или не забанен.", 1);
			break;
		case "/makeleader":
			if(Player[playerid].Info.Admin < 5)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 3)
			{
				msg(playerid, ADVICE, "/makeleader [ID Игрока или часть имени (A-Z,a-z | 1-32)] [ID Фракции (0-14)]");
				return true;
			}
			giveplayerid = returnUser(cmd[1]);
			if(giveplayerid == -1)
			{
				msg(playerid, ERROR, "Игрока в данный момент нет онлайн и/или вы используете неверное имя/ID.");
				return true;
			}
			if(!isNumeric(cmd[2].tointeger()))
			{
				msg(playerid, ADVICE, "/makeleader [ID Игрока или часть имени (A-Z,a-z | 1-32)] [ID Фракции [FF0000FF](0-14)[AAAAAAAA]]");
				return true;
			}
			local faction = cmd[2].tointeger();
			if(faction < 0 || faction > 14)
			{
				msg(playerid, ADVICE, "/makeleader [ID Игрока или часть имени (A-Z,a-z | 1-32)] [ID Фракции [FF0000FF](0-14)[AAAAAAAA]]");
				return true;
			}
			else if(faction == 0)
			{
				Player[giveplayerid].Info.Faction.Number = 0;
				Player[giveplayerid].Info.Faction.Rank = 0;
				Player[giveplayerid].Info.Faction.Skill = 0;
				msg(giveplayerid, ALERT, "Вы были лишены лидерства над фракцией.");
				return true;
			}
			else
			{
				Player[giveplayerid].Info.Faction.Number = cmd[2].tointeger();
				Player[giveplayerid].Info.Faction.Rank = 12;
				Player[giveplayerid].Info.Faction.Skill = 0;
				msg(giveplayerid, ALERT, "Вам было передано лидерство над фракцией "+factionName[faction]+".");
				return true;
			}
			break;
		case "/invite":
			if(Player[playerid].Info.Faction.Rank < 11)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 2)
			{
				msg(playerid, ADVICE, "/invite [ID Игрока или часть имени (A-Z,a-z | 1-32)]");
				return true;
			}
			giveplayerid = returnUser(cmd[1]);
			if(giveplayerid == INVALID_PLAYER_ID)
			{
				msg(playerid, ERROR, "Игрока в данный момент нет онлайн и/или вы используете неверное имя/ID.");
				return true;
			}
			if(giveplayerid == playerid)
			{
				msg(playerid, ERROR, "Вы не можете принять во фракцию самого себя.");
				return true;
			}
			if(Player[giveplayerid].Info.Faction.Number != 0)
			{
				msg(playerid, ERROR, "Игрок уже является членом фракции.");
				return true;
			}
			if(Player[giveplayerid].Info.Job.Number != 0)
			{
				msg(playerid, ERROR, "У игрока есть работа.");
				return true;
			}
			Request[giveplayerid].ReqType = FACTION_INVITE;
			Request[giveplayerid].Params = Player[playerid].Info.Faction.Number;
			Request[giveplayerid].SecondFace = playerid;
			msg(giveplayerid, ALERT, getPlayerName(playerid)+" приглашает вас вступить во фракцию "+factionName[Player[playerid].Info.Faction.Number]+". Для вступления нажмите Y. N - отказ.");
			return true;
			break;
		case "/giverank": //новое
			if(Player[playerid].Info.Faction.Rank < 11)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 3)
			{
				msg(playerid, ADVICE, "/giverank [ID Игрока или часть имени (A-Z,a-z | 1-32)] [Ранг игрока]");
				return true;
			}
			giveplayerid = returnUser(cmd[1]);
			if(giveplayerid == INVALID_PLAYER_ID)
			{
				msg(playerid, ERROR, "Игрока в данный момент нет онлайн и/или вы используете неверное имя/ID.");
				return true;
			}
			if(giveplayerid == playerid)
			{
				msg(playerid, ERROR, "Вы не можете повысить самого себя.");
				return true;
			}
			if(Player[playerid].Info.Faction.Rank < Player[giveplayerid].Info.Faction.Rank)
			{
				msg(playerid, ERROR, "Вы не имеете право изменять ранг персонажу, чей ранг выше вашего.");
				return true;
			}
			if(Player[giveplayerid].Info.Faction.Rank <= cmd[2])
			{
				Request[giveplayerid].ReqType = FACTION_GIVERANK;
				Request[giveplayerid].Params = cmd[2];
				Request[giveplayerid].SecondFace = playerid;
			}
			else
			{
				Player[giveplayerid].Info.Faction.Rank = cmd[2];
				msg(giveplayerid, ALERT, getPlayerName(playerid) + " понизил вас до " + cmd[2] + " ранга.");
			}
			msg(giveplayerid, ALERT, getPlayerName(playerid) + " предлагает вам повышение до" + cmd[2] + " ранга. Для принятия нажмите Y. N - отказ.");
			return true;
			break;
		case "/exclude": //новое
			if(Player[playerid].Info.Faction.Rank < 11)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() != 2)
			{
				msg(playerid, ADVICE, "/exclude [ID Игрока или часть имени (A-Z,a-z | 1-32)]");
				return true;
			}
			giveplayerid = returnUser(cmd[1]);
			if(giveplayerid == INVALID_PLAYER_ID)
			{
				msg(playerid, ERROR, "Игрока в данный момент нет онлайн и/или вы используете неверное имя/ID.");
				return true;
			}
			if(giveplayerid == playerid)
			{
				msg(playerid, ERROR, "Вы не можете исключить самого себя.");
				return true;
			}
			if(Player[giveplayerid].Info.Faction.Number == 0)
			{
				msg(playerid, ERROR, "Игрок не состоит в какой либо организации.");
				return true;
			}
			if(Player[giveplayerid].Info.Faction.Number != Player[playerid].Info.Faction.Number)
			{
				msg(playerid, ERROR, "Игрок находится не под вашим руководством");
				return true;
			}
			if(Player[giveplayerid].Info.Faction.Rank > Player[playerid].Info.Faction.Rank)
			{
				msg(playerid, ERROR, "Этот игрок выше вас по званию");
				return true;
			}
			Player[giveplayerid].Info.Faction.Number = 0;
			msg(giveplayerid, ALERT, getPlayerName(playerid) + " исключил вас из организации.");
			msg(playerid, ALERT, "Вы исключили " + getPlayerName(giveplayerid) + "-а из своей организации.");
			return true;
			break;
		case "/veh":
			if(Player[playerid].Info.Admin < 3)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() == 2)
			{
				if(!isNumeric(cmd[1]))
				{
					msg(playerid, ADVICE, "/veh [ID Авто [FF0000FF](0-123)[AAAAAAAA]]");
					return true;
				}
				local model = cmd[1].tointeger();
				if(model < 0 || model > 123)
				{
					msg(playerid, ADVICE, "/veh [ID Авто [FF0000FF](0-123)[AAAAAAAA]]");
					return true;
				}
				local pos;
				if(isPlayerInAnyVehicle(playerid)) pos = getVehicleCoordinates(getPlayerVehicleId(playerid));
				else pos = getPlayerCoordinates(playerid);
				local heading = getPlayerHeading(playerid);
				local veh = createVehicle(model, pos[0], pos[1], pos[2], 0.0, 0.0, heading, 1, 1, 1, 1);
				if(veh != INVALID_VEHICLE_ID)
				{
					warpPlayerIntoVehicle(playerid, veh);
					msg(playerid, ALERT, getVehicleName(model) + " был(а) создана на вашей позиции.");
				}
			}
			else if(cmd.len() == 6)
			{
				if(!isNumeric(cmd[1]))
				{
					msg(playerid, ADVICE, "/veh [ID Авто [FF0000FF](0-123)[AAAAAAAA]] {[Цвет 1(0-137)] [Цвет 2(0-137)] [Цвет 3(0-137)] [Цвет 4(0-137)]}");
					return true;
				}
				local model = cmd[1].tointeger();
				if(model < 0 || model > 123)
				{
					msg(playerid, ADVICE, "/veh [ID Авто [FF0000FF](0-123)[AAAAAAAA]] {[Цвет 1(0-137)] [Цвет 2(0-137)] [Цвет 3(0-137)] [Цвет 4(0-137)]}");
					return true;
				}
				if(!isNumeric(cmd[2]))
				{
					msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1[FF0000FF](0-137)[AAAAAAAA]] [Цвет 2(0-137)] [Цвет 3(0-137)] [Цвет 4(0-137)]}");
					return true;
				}
				local color1 = cmd[2].tointeger();
				if(color1 < 0 || color1 > 123)
				{
					msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1[FF0000FF](0-137)[AAAAAAAA]] [Цвет 2(0-137)] [Цвет 3(0-137)] [Цвет 4(0-137)]}");
					return true;
				}
				if(!isNumeric(cmd[3]))
				{
					msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1(0-137)] [Цвет 2[FF0000FF](0-137)[AAAAAAAA]] [Цвет 3(0-137)] [Цвет 4(0-137)]}");
					return true;
				}
				local color2 = cmd[2].tointeger();
				if(color2 < 0 || color2 > 123)
				{
					msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1(0-137)] [Цвет 2[FF0000FF](0-137)[AAAAAAAA]] [Цвет 3(0-137)] [Цвет 4(0-137)]}");
					return true;
				}
				if(!isNumeric(cmd[4]))
				{
					msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1(0-137)] [Цвет 2(0-137)] [Цвет 3[FF0000FF](0-137)[AAAAAAAA]] [Цвет 4(0-137)]}");
					return true;
				}
				local color3 = cmd[2].tointeger();
				if(color3 < 0 || color3 > 123)
				{
					msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1(0-137)] [Цвет 2(0-137)] [Цвет 3[FF0000FF](0-137)[AAAAAAAA]] [Цвет 4(0-137)]}");
					return true;
				}
				if(!isNumeric(cmd[5]))
				{
					msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1(0-137)] [Цвет 2(0-137)] [Цвет 3(0-137)] [Цвет 4[FF0000FF](0-137)[AAAAAAAA]]}");
					return true;
				}
				local color4 = cmd[2].tointeger();
				if(color4 < 0 || color4 > 123)
				{
					msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1(0-137)] [Цвет 2(0-137)] [Цвет 3(0-137)] [Цвет 4[FF0000FF](0-137)[AAAAAAAA]]}");
					return true;
				}
				local pos;
				if(isPlayerInAnyVehicle(playerid))
					pos = getVehicleCoordinates(getPlayerVehicleId(playerid));
				else
					pos = getPlayerCoordinates(playerid);
				local heading = getPlayerHeading(playerid);
				local veh = createVehicle(model, pos[0], pos[1], pos[2], 0.0, 0.0, heading, cmd[2].tointeger(),cmd[3].tointeger(),cmd[4].tointeger(),cmd[5].tointeger());
				if(veh != INVALID_VEHICLE_ID)
				{
					//warpPlayerIntoVehicle(playerid, veh);
					msg(playerid, ALERT, getVehicleName(model) + " был(а) создана на вашей позиции (ID " + veh + ").");
				}
			}
			else 
			{
				msg(playerid, ADVICE, "/veh [ID Авто (0-123)] {[Цвет 1(0-137)] [Цвет 2(0-137)] [Цвет 3(0-137)] [Цвет 4(0-137)]}");
				return true;
			}
			break;
		case "/house":
			if(cmd.len() < 2)
			{
				msg(playerid, ADVICE, "/house [Действие (new|enter|exit|price|name|finish)]");
				return true;
			}
			switch(cmd[1])
			{
				case "new":
					HouseName[playerid] = "";
					HouseEnX[playerid] = 0.0;
					HouseEnY[playerid] = 0.0;
					HouseEnZ[playerid] = 0.0;
					HouseExX[playerid] = 0.0;
					HouseExY[playerid] = 0.0;
					HouseExZ[playerid] = 0.0;
					HousePrice[playerid] = 0;
					msg(playerid, ALERT, "Данные о создании дома очищены.");
					break;
				case "enter":
					local coords = getPlayerCoordinates(playerid);
					HouseEnX[playerid] = coords[0];
					HouseEnY[playerid] = coords[1];
					HouseEnZ[playerid] = coords[2];
					msg(playerid, ALERT, "Координаты входа в дом сохранены.");
					break;
				case "exit":
					local coords = getPlayerCoordinates(playerid);
					HouseExX[playerid] = coords[0];
					HouseExY[playerid] = coords[1];
					HouseExZ[playerid] = coords[2];
					msg(playerid, ALERT, "Координаты выхода в дом сохранены.");
					break;
				case "price":
					if(cmd.len() != 3)
					{
						msg(playerid, ADVICE, "/house price [Цена дома (1-3000000)$]");
						return 1;
					}
					if(!isNumeric(cmd[2]))
					{
						msg(playerid, ADVICE, "/house price [Цена дома [FF0000FF](1-3000000)$[AAAAAAAA]]");
						return 1;
					}
					if(cmd[2].tointeger() < 1 || cmd[2].tointeger() > 3000000)
					{
						msg(playerid, ADVICE, "/house price [Цена дома [FF0000FF](1-3000000)$[AAAAAAAA]]");
						return 1;
					}
					HousePrice[playerid] = cmd[2].tointeger();
					msg(playerid, ALERT, "Цена дома сохранена.");
					break;
				case "name":
					if(cmd.len() < 3)
					{
						msg(playerid, ADVICE, "/house name [Имя дома (A-Z, a-z, А-Я, а-я, 0-9, _)]");
						return 1;
					}
					HouseName[playerid] = command.slice(cmd[0].len() + 1 + cmd[1].len() + 1);
					msg(playerid, ALERT, "Название дома сохранено.");
					break;
				case "finish":
					log(HouseName[playerid]+"  "+HouseEnX[playerid].tostring()+"  "+HouseEnY[playerid].tostring()+"  "+HouseEnZ[playerid].tostring()+"  "+HouseExX[playerid].tostring()+"  "+HouseExY[playerid].tostring()+"  "+HouseExZ[playerid].tostring()+"  "+HousePrice[playerid].tostring());
					Houses.CreateNew(HouseName[playerid], HouseEnX[playerid], HouseEnY[playerid], HouseEnZ[playerid], HouseExX[playerid], HouseExY[playerid], HouseExZ[playerid], HousePrice[playerid]);
					msg(playerid, ALERT, "Дом был успешно создан.");
					break;
				default:
					msg(playerid, ERROR, "Неверный параметр.");
					break;
			}
			break;
		case "/biz"://TODO: Проверка данных и подсказки
			local pos = getPlayerCoordinates(playerid);
			Biz.CreateNew(cmd[1], cmd[2], pos[0], pos[1], pos[2], cmd[3]);
			break;
		case "/givelicense"://TODO: Сделать проверку вводимых данных
			if(cmd.len() != 3)
			{
				msg(playerid, ADVICE, "/givelicense [ID Игрока или часть имени (A-Z,a-z | 1-32)] [Наименование лицензии]");
				msg(playerid, ADVICE, "Доступные лицензии: c(ar), m(otorcycle), f(ly), w(ater).");
				return false;
			}
			giveplayerid = returnUser(cmd[1]);
			if(giveplayerid == INVALID_PLAYER_ID)
			{
				msg(playerid, ERROR, "Игрока в данный момент нет онлайн и/или вы используете неверное имя/ID.");
				return false;
			}
			local pos = getPlayerCoordinates(playerid);
			local pos1 = getPlayerCoordinates(giveplayerid);
			if(!isPointInCircle(pos[0],pos[1],pos1[0],pos[1],5.0))
			{
				msg(playerid, ERROR, "Этот игрок не рядом с вами");
				return false;
			}
			if(Player[playerid].Info.Admin < 5 && Player[playerid].Info.Faction.Number != 6)
			{
				haveNoPermissions(playerid);
				return true;
			}
			switch(cmd[2])
			{
				case "car":
				case "c":
					if(Player[giveplayerid].License.Car < 2)
					{
						Request[giveplayerid].ReqType = LICENSE;
						Request[giveplayerid].Params = "car";
						Request[giveplayerid].SecondFace = playerid;
						msg(giveplayerid, ALERT, getPlayerName(playerid)+" предложил сделать вам лицензию на авто за сумму в размере 1000$ Для принятия нажмите Y. N - отказ.");
						msg(playerid,ALERT,"Вы предложили сделать лицензию на авто за 1000$");
					}
					else
					{
						msg(playerid,ERROR,"Игрок имеет уже лицензию на авто");
						return false;
					}
					break;
				case "motorcycle":
				case "m":
					if(Player[giveplayerid].License.Motorcycle < 2)
					{
						Request[giveplayerid].ReqType = LICENSE;
						Request[giveplayerid].Params = "motorcycle";
						Request[giveplayerid].SecondFace = playerid;
						msg(giveplayerid, ALERT, getPlayerName(playerid)+" предложил сделать вам лицензию на мотоциклы за сумму в размере 10000$ Для принятия нажмите Y. N - отказ.");
						msg(playerid,ALERT,"Вы предложили сделать лицензию на мотоциклы за 10000$");
					}
					else
					{
						msg(playerid,ERROR,"Игрок имеет уже лицензию на мотоциклы");
						return false;
					}
					break
				case "fly":
				case "f":
					if(Player[giveplayerid].License.Fly < 2)
					{
						Request[giveplayerid].ReqType = LICENSE;
						Request[giveplayerid].Params = "fly";
						Request[giveplayerid].SecondFace = playerid;
						msg(giveplayerid, ALERT, getPlayerName(playerid)+" предложил сделать вам лицензию на вертолёты за сумму в размере 15000$ Для принятия нажмите Y. N - отказ.");
						msg(playerid,ALERT,"Вы предложили сделать лицензию на мотоциклы за 15000$");
					}
					else
					{
						msg(playerid,ERROR,"Игрок имеет уже лицензию на вертолёты");
						return false;
					}
					break;
				case "water":
				case "w":
					if(Player[giveplayerid].License.Motorcycle < 2)
					{
						Request[giveplayerid].ReqType = LICENSE_Water;
						Request[giveplayerid].Params = "water";
						Request[giveplayerid].SecondFace = playerid;
						msg(giveplayerid, ALERT, getPlayerName(playerid)+" предложил сделать вам лицензию на водный транспорт за сумму в размере 5000$ Для принятия нажмите Y. N - отказ.");
						msg(playerid,ALERT,"Вы предложили сделать лицензию на водный транспорт за 5000$");
					}
					else
					{
						msg(playerid,ERROR,"Игрок имеет уже лицензию на водный транспорт");
						return false;
					}
					break;
				default:
					msg(playerid, ADVICE, "Доступные лицензии: c(ar), m(otorcycle), f(ly), w(ater).");
					return false;
			}
			break;
		case "/setplayerpos"://новое
			if(Player[playerid].Info.Admin < 5)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() < 4)
			{
				msg(playerid, ADVICE, "/setplayerpos [Позиция X] [Позиция Y] [Позиция Z] ([Интерьер] ([Измерение]))");
				return false;
			}
			//TODO: Сделать проверку вводимых данных
			Player[playerid].SetCoordinates(cmd[1].tofloat(), cmd[2].tofloat(), cmd[3].tofloat());
			if(cmd.len() >= 5) Player[playerid].SetInterior(cmd[4].tointeger());
			if(cmd.len() >= 6) Player[playerid].SetDimension(cmd[5].tointeger());
			break;
		case "/clothes":
			triggerClientEvent(playerid, "openSkinShop", getPlayerClothes(playerid));//TODO: Доделать магазин одежды.
			break;
		case "/skin":
			if(Player[playerid].Info.Admin < 3)
			{
				haveNoPermissions(playerid);
				return true;
			}
			if(cmd.len() < 2)
			{
				msg(playerid, ADVICE, "/skin ID [ID Игрока]");
				return true;
			}
			if(!isNumeric(cmd[1]))
			{
				msg(playerid, ERROR, "Идентификатор должен быть числом");
				return true;
			}
			if(cmd.len() == 2) setPlayerModel(playerid, cmd[1].tointeger());
			else
			{
				giveplayerid = returnUser(cmd[2]);
				if(giveplayerid == INVALID_PLAYER_ID)
				{
					msg(playerid, ERROR, "Этот игрок не всети");
					return false;
				}
				setPlayerModel(cmd[2].tointeger(), cmd[1].tointeger());
			}
			break;
		default:
			msg(playerid, ERROR, "Такой команды не существует, либо вы не имеете привилегий на её использование.");
			break;
	}
}
addEvent("playerCommand", onPlayerCommand);
//#Игрок написал что-то в чат#//
function onPlayerText( playerid, text )
{
	local message = split(text, " ");
    switch(text[0])
	{
		case "#":                     //новое
			radio(playerid, message[1]);
			break;
		case "!":
			break;
		case "@":
			break;
	}
    return 1;
}
addEvent("playerText", onPlayerText);
//#playerDeath#//
function onPlayerDeath(playerid, killerid, weaponid, killervehicle)
{
	Player[playerid].Death();
	return true;
}
addEvent("playerDeath", onPlayerDeath);

function onVehicleDeath(vehicleid)
{
	if(isOwnVehicle(vehicleid))
	{
		deleteVehicle(vehicleid);
		deleteCar(VehicleData[vehicleid].OwnID);
		VehicleData[vehicleid] = -1;
	}
	return true;
}
addEvent("vehicleDeath", onVehicleDeath);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////enter-exit-CheckPoint/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
function onPlayerEnterCheckpoint(playerid, checkpointId)
{
	switch(checkpointId)
	{
		case CarBuyCP:
			triggerClientEvent(playerid, "showCarBuy", true);
			freezePlayer(playerid, true);
			break;
	}
}
addEvent("playerEnterCheckpoint", onPlayerEnterCheckpoint);

function onPlayerLeaveCheckpoint(playerid, checkpointId)
{
}
addEvent("playerLeaveCheckpoint", onPlayerLeaveCheckpoint);

function buyCar(playerid, modelid, color1, color2, color3, color4)
{
	local spawnpos = array(6, 0.0);
	if(modelid <= 111)
	{
		local rnd = random(0,2);
		spawnpos[0] = CarSpawn[rnd].x;
		spawnpos[1] = CarSpawn[rnd].y;
		spawnpos[2] = CarSpawn[rnd].z;
		spawnpos[3] = CarSpawn[rnd].ax;
		spawnpos[4] = CarSpawn[rnd].ay;
		spawnpos[5] = CarSpawn[rnd].az;
	}
	else if(modelid >= 112 && modelid <= 115)
	{
		spawnpos[0] = 79.018669;
		spawnpos[1] = 862.333496;
		spawnpos[2] = 15.226456;
		spawnpos[3] = 0.0;
		spawnpos[4] = 0.0;
		spawnpos[5] = 180.0;
	}
	else
	{
		spawnpos[0] = 221.398590;
		spawnpos[1] = 847.353271;
		spawnpos[2] = 1.023958;
		spawnpos[3] = 0.0;
		spawnpos[4] = 0.0;
		spawnpos[5] = 0.0;
	}
    mysql_query(MySQL.Handler, "INSERT INTO `cars` (`carID`) VALUES (NULL);");
    local carid = mysql_insert_id(MySQL.Handler);
	Car[carid] <- { };
    Car[carid].CarID <- createVehicle(modelid, spawnpos[0], spawnpos[1], spawnpos[2], spawnpos[3], spawnpos[4], spawnpos[5], color1, color2 , color3, color4);
    if(carid == -1) return false;
	VehicleData[Car[carid].CarID] = carid;
    Car[carid].CarModel <- modelid;
    Car[carid].CarColor1 <- color1;
    Car[carid].CarColor2 <- color2;
    Car[carid].CarColor3 <- color3;
    Car[carid].CarColor4 <- color4;
	log(Car[carid].CarColor1.tostring()+" "+Car[carid].CarColor2.tostring()+" "+Car[carid].CarColor3.tostring()+" "+Car[carid].CarColor4.tostring());
    local pos = getVehicleCoordinates(Car[carid].CarID);
    Car[carid].CarPosX <- pos[0];
    Car[carid].CarPosY <- pos[1];
    Car[carid].CarPosZ <- pos[2];
    local rot = getVehicleRotation(Car[carid].CarID);
    Car[carid].CarAngleX <- rot[0];
    Car[carid].CarAngleY <- rot[1];
    Car[carid].CarAngleZ <- rot[2];
    Car[carid].CarDirtLevel <- getVehicleDirtLevel(Car[carid].CarID);
    Car[carid].CarHealth <- getVehicleHealth(Car[carid].CarID);
    Car[carid].CarLocked <- getVehicleLocked(Car[carid].CarID);
    Car[carid].CarParked <- 0;
    Car[carid].CarVariation <- getVehicleVariation(Car[carid].CarID);
    Car[carid].CarSirenState <- getVehicleSirenState(Car[carid].CarID);
    Car[carid].CarEngineState <- getVehicleEngineState(Car[carid].CarID);
    Car[carid].CarLights <- getVehicleLights(Car[carid].CarID);
    Car[carid].CarTaxiLights <- getVehicleTaxiLights(Car[carid].CarID);
    mysql_query(MySQL.Handler, "UPDATE cars SET Model='"+Car[carid].CarModel+"', Color1='"+Car[carid].CarColor1+"', Color2='"+Car[carid].CarColor2+"', Color3='"+Car[carid].CarColor3+"', Color4='"+Car[carid].CarColor4+"', x='"+Car[carid].CarPosX+"', y='"+Car[carid].CarPosY+"', z='"+Car[carid].CarPosZ+"', ax='"+Car[carid].CarAngleX+"', ay='"+Car[carid].CarAngleY+"', az='"+Car[carid].CarAngleZ+"',DirtLevel='"+Car[carid].CarDirtLevel+"', Health='"+Car[carid].CarHealth+"', Locked='"+Car[carid].CarLocked+"', Variation='"+Car[carid].CarVariation+"', SirenState='"+Car[carid].CarSirenState+"', EngineState='"+Car[carid].CarEngineState+"', Lights='"+Car[carid].CarLights+"', TaxiLights='"+Car[carid].CarTaxiLights+"' WHERE carID='"+carid+"';");
    //log(mysql_error(MySQL.Handler));
    log("Car [ID:"+carid+"] created!");
    return;
}
addEvent("buyCar", buyCar);

function saveCars()
{
    for(local c = 0; c < MAX_CARS; c++)
    {
        if(VehicleData[c] != -1)
        {
        	local carid = VehicleData[c];
            Car[carid].CarModel = getVehicleModel(Car[carid].CarID);
            local color = getVehicleColor(Car[carid].CarID);
            Car[carid].CarColor1 = color[0];
            Car[carid].CarColor2 = color[1];
            Car[carid].CarColor3 = color[2];
            Car[carid].CarColor4 = color[3];
            local pos = getVehicleCoordinates(Car[carid].CarID);
            Car[carid].CarPosX = pos[0];
            Car[carid].CarPosY = pos[1];
            Car[carid].CarPosZ = pos[2];
            local rot = getVehicleRotation(Car[carid].CarID);
            Car[carid].CarAngleX = rot[0];
            Car[carid].CarAngleY = rot[1];
            Car[carid].CarAngleZ = rot[2];
            Car[carid].CarDirtLevel = getVehicleDirtLevel(Car[carid].CarID);
            Car[carid].CarHealth = getVehicleHealth(Car[carid].CarID);
            Car[carid].CarLocked = getVehicleLocked(Car[carid].CarID);
            Car[carid].CarVariation = getVehicleVariation(Car[carid].CarID);
            Car[carid].CarSirenState = getVehicleSirenState(Car[carid].CarID);
            Car[carid].CarEngineState = getVehicleEngineState(Car[carid].CarID);
            Car[carid].CarLights = getVehicleLights(Car[carid].CarID);
            Car[carid].CarTaxiLights = getVehicleTaxiLights(Car[carid].CarID); 
            mysql_query(MySQL.Handler, "UPDATE cars SET Model='"+Car[carid].CarModel+"', Color1='"+Car[carid].CarColor1+"', Color2='"+Car[carid].CarColor2+"', Color3='"+Car[carid].CarColor3+"', Color4='"+Car[carid].CarColor4+"', x='"+Car[carid].CarPosX+"', y='"+Car[carid].CarPosY+"', z='"+Car[carid].CarPosZ+"', ax='"+Car[carid].CarAngleX+"', ay='"+Car[carid].CarAngleY+"', az='"+Car[carid].CarAngleZ+"',DirtLevel='"+Car[carid].CarDirtLevel+"', Health='"+Car[carid].CarHealth+"', Locked='"+Car[carid].CarLocked+"', Variation='"+Car[carid].CarVariation+"', SirenState='"+Car[carid].CarSirenState+"', EngineState='"+Car[carid].CarEngineState+"', Lights='"+Car[carid].CarLights+"', TaxiLights='"+Car[carid].CarTaxiLights+"' WHERE carID='"+c+"';");
        }
    }
    return true;
}
        
function loadCars()
{
    local result = mysql_query(MySQL.Handler, "SELECT * FROM cars");
    local arr;
    local carid;
    while(arr = mysql_fetch_assoc(result))
    {
    	carid = arr["carID"];
		Car[carid] <- { };
        Car[carid].CarModel <- arr["Model"];
        Car[carid].CarColor1 <- arr["Color1"];
        Car[carid].CarColor2 <- arr["Color2"];
        Car[carid].CarColor3 <- arr["Color3"];
        Car[carid].CarColor4 <- arr["Color4"];
        Car[carid].CarPosX <- arr["x"];
        Car[carid].CarPosY <- arr["y"];
        Car[carid].CarPosZ <- arr["z"];
        Car[carid].CarAngleX <- arr["ax"];
        Car[carid].CarAngleY <- arr["ay"];
        Car[carid].CarAngleZ <- arr["az"];
        Car[carid].CarID <- createVehicle(Car[carid].CarModel, Car[carid].CarPosX, Car[carid].CarPosY, Car[carid].CarPosZ, Car[carid].CarAngleX, Car[carid].CarAngleY, Car[carid].CarAngleZ, Car[carid].CarColor1, Car[carid].CarColor2, Car[carid].CarColor3, Car[carid].CarColor4);
        VehicleData[Car[carid].CarID] = carid;
        Car[carid].CarDirtLevel <- arr["DirtLevel"];
        setVehicleDirtLevel(Car[carid].CarID, Car[carid].CarDirtLevel);
        Car[carid].CarHealth <- arr["Health"];
        setVehicleHealth(Car[carid].CarID, Car[carid].CarHealth);
        Car[carid].CarLocked <- arr["Locked"];
        setVehicleLocked(Car[carid].CarID, Car[carid].CarLocked);
        Car[carid].CarVariation <- arr["Variation"];
        setVehicleVariation(Car[carid].CarID, Car[carid].CarVariation);
        Car[carid].CarSirenState <- arr["SirenState"];
        setVehicleSirenState(Car[carid].CarID, (Car[carid].CarSirenState == 1) ? true : false);
        Car[carid].CarEngineState <- arr["EngineState"];
        setVehicleEngineState(Car[carid].CarID, (Car[carid].CarEngineState == 1) ? true : false);
        Car[carid].CarLights <- arr["Lights"];
        setVehicleLights(Car[carid].CarID, (Car[carid].CarLights == 1) ? true : false);
        Car[carid].CarTaxiLights <- arr["TaxiLights"];
        setVehicleTaxiLights(Car[carid].CarID, (Car[carid].CarTaxiLights == 1) ? true : false);
    }
    mysql_free_result(result);
    return true;
}

function deleteCar(carid)
{
	local result = mysql_query(MySQL.Handler, "DELETE FROM `cars` WHERE `carID`='"+carid+"' LIMIT 1;");
	return (mysql_affected_rows(MySQL.Handler) == 1) ? true : false;
}

function isPlayerNearVehicle(playerid, vehicleid, radius = 3.0)
{
    local playerPos = getPlayerCoordinates(playerid);
    local vehiclePos = getVehicleCoordinates(vehicleid);
    return isPointInBall(playerPos[0], playerPos[1], playerPos[2], vehiclePos[0], vehiclePos[1], vehiclePos[2], radius);
}

function radio(playerid, message)//новое
{
	
	local rank = Player[playerid].Info.Faction.Number;
	local fracColor = "[FFFFFFFF]";//TODO: Цвета фракций
	for(local i = 0; i < MAX_PLAYERS; i++)
	{
		if(Player[playerid].Info.Faction.Number == Player[i].Info.Faction.Number) sendPlayerMessage(i, getPlayerName(playerid) + " передаёт по рации: " + fracColor + message, 0xFFFFFFFF, true);
	}
	return true;
}

function modelVehicle(model)//новое
{
	if(model < 105) return "car"; 
	else if(model < 112 && model >= 105 && model != 106) return "motorcycle"; 
	else if(model >= 112 && model <= 115) return "fly"; 
	else if(model > 115) return "water"; 
	else return false;
}

function isNumeric(string)
{
    try
    {
        string.tointeger()
    }
    catch(string)
    {
        return false;
    }
    return true;
}

function isOwnVehicle(vehicleid)
{
	if(VehicleData[vehicleid] == -1) return false;
	return true;
}

function freezePlayer(playerid, toggle)
{
	togglePlayerControls(playerid, !toggle);
	togglePlayerHud(playerid, !toggle);
	togglePlayerRadar(playerid, !toggle);
	return true;
}
addEvent("freezeMe",freezePlayer);

function onToggleEngine(playerid, vehicleid, turn)
{
	setVehicleEngineState(vehicleid, turn);
	return true;
}
addEvent("toggleEngine", onToggleEngine);

function onToggleLights(playerid, vehicleid)
{
	setVehicleLights(vehicleid, !getVehicleLights(vehicleid));
	return true;
}
addEvent("toggleLights", onToggleLights);

function onToggleLocked(playerid, vehicleid, toggle)
{
	if(toggle == 1) setVehicleLocked(vehicleid, 0);
	else setVehicleLocked(vehicleid, 1);
	return true;
}
addEvent("toggleLocked", onToggleLocked);

function onIndicators(playerid, turn)
{
	local vehicleid = getPlayerVehicleId(playerid);
	if(isPlayerInAnyVehicle(playerid) && getPlayerSeatId(playerid) == 0)
	{
		switch(turn)
		{
			case 0:
				setVehicleIndicators(vehicleid, false, false, false, false);
				break;
			case 1:
				setVehicleIndicators(vehicleid, true, false, true, false);
				break;
			case 2:
				setVehicleIndicators(vehicleid, false, true, false, true);
				break;
		}
	}
}
addEvent("indicators", onIndicators);

function onSkinChoose(playerid, temp)
{
	if(SkinChoose[playerid])
	{
		switch(temp)
		{
			case 1:
				if(CurrSkin[playerid] == (Skins[Player[playerid].Info.Faction.Number].len()-1)) CurrSkin[playerid] = 0;
				else CurrSkin[playerid]++;
				setPlayerModel(playerid, Skins[Player[playerid].Info.Faction.Number][CurrSkin[playerid]]);
				break;
			case 2:
				if(CurrSkin[playerid] == 0) CurrSkin[playerid] = (Skins[Player[playerid].Info.Faction.Number].len()-1);
				else CurrSkin[playerid]--;
				setPlayerModel(playerid, Skins[Player[playerid].Info.Faction.Number][CurrSkin[playerid]]);
				break;
			case 3:
				SkinChoose[playerid] = false;
				msg(playerid, ALERT, "Поздравляем с выбором модели игрока.");
				break;
		}
	}
}
addEvent("skinChoose", onSkinChoose);

function onEnterHouse(playerid)
{
	if(getPlayerDimension(playerid) > 100)
	{
		local dim = getPlayerDimension(playerid);
		setPlayerDimension(playerid, 0);
		setPlayerCoordinates(playerid, Houses.Info[dim-100].Enter.X, Houses.Info[dim-100].Enter.Y, Houses.Info[dim-100].Enter.Z);
		log(playerid.tostring()+" try to exit house "+(dim-100).tostring());
	}
	else
	{
		local arr;
		local coords = getPlayerCoordinates(playerid);
		local result = mysql_query(MySQL.Handler, "SELECT * FROM `houses`");
		while(arr = mysql_fetch_assoc(result))
		{
			local houseid = arr["ID"];
			if(isPointInBall( Houses.Info[houseid].Enter.X, Houses.Info[houseid].Enter.Y, Houses.Info[houseid].Enter.Z, coords[0], coords[1], coords[2], 1.0))
			{
				setPlayerDimension(playerid, houseid + 100);
				setPlayerCoordinates(playerid, Houses.Info[houseid].Exit.X, Houses.Info[houseid].Exit.Y, Houses.Info[houseid].Exit.Z);
				log(playerid.tostring()+" try to enter house "+houseid.tostring());
			}
		}
		mysql_free_result(result);
	}
	return true;
}
addEvent("enterHouse", onEnterHouse);

function onChangePlayerClothes(playerid, part, cloth)
{
	setPlayerClothes(playerid, part, cloth);
}
addEvent("changeMyClothes", onChangePlayerClothes);

function oneHourTimer()
{
	setWeather(random(1,9));
	return true;
}

function onSecondTimer()
{
    for(local i = 0; i < MAX_PLAYERS; i++)
    {
        if(driftN[i] != 0)
        {
            if(driftTime[i] != 3) driftTime[i]++; 
			else 
            {
                driftMoney[i] = driftN[i]/50;
                driftN[i] = 0;
                Player[i].GiveMoney(i,driftMoney[i]);
                driftMoney[i] = 0;
                driftTime[i] = 0;
            }
        }
    }
}

function onDriftTimer()
{
    for(local i = 0; i < MAX_PLAYERS; i++)
    {
        if(getPlayerSeatId(i) == 0)
        {
            local vehid = getPlayerVehicleId(i);
			if(getVehicleModel(vehid) < 107)
			{
				local angle = getVehicleDriftAngle(vehid);
				if(angle > 25)
				{
					driftTime[i] = 0;
					driftN[i]+=angle;
					displayPlayerText(i, 0.3, 0.9, "~g~Drift points: "+driftN[i], 500);
				}
			}
        }
    }
}

function CreateBlips()
{
	createBlip(79, 53.714977, 807.232361, 14.772794, true);
}

function MysqlConnection(status)
{
	if(status)
	{
		MySQL.Handler = mysql_connect(MySQL.Host, MySQL.User, MySQL.Password, MySQL.Database);
		if(mysql_ping(MySQL.Handler)) log("[MySQL]: Connected.");
		mysql_query(MySQL.Handler, "CREATE TABLE IF NOT EXISTS `cars` ("+
		  "`carID` int(11) unsigned NOT NULL AUTO_INCREMENT,"+
		  "`Model` int(4) NOT NULL,"+
		  "`Color1` int(4) NOT NULL,"+
		  "`Color2` int(4) NOT NULL,"+
		  "`Color3` int(4) NOT NULL,"+
		  "`Color4` int(4) NOT NULL,"+
		  "`ax` float NOT NULL,"+
		  "`ay` float NOT NULL,"+
		  "`az` float NOT NULL,"+
		  "`x` float NOT NULL,"+
		  "`y` float NOT NULL,"+
		  "`z` float NOT NULL,"+
		  "`SirenState` varchar(8) NOT NULL,"+
		  "`Lights` varchar(8) NOT NULL,"+
		  "`Variation` int(8) NOT NULL,"+
		  "`TaxiLights` varchar(8) NOT NULL,"+
		  "`Locked` int(8) NOT NULL,"+
		  "`EngineState` varchar(8) NOT NULL,"+
		  "`Health` int(5) NOT NULL,"+
		  "`DirtLevel` float NOT NULL,"+
		  "PRIMARY KEY (`carID`)"+
		") ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;");
		mysql_query(MySQL.Handler, "CREATE TABLE IF NOT EXISTS `users` ("+
		  "`SQLId` int(12) NOT NULL AUTO_INCREMENT,"+
		  "`Name` varchar(32) NOT NULL,"+
		  "`Password` varchar(64) NOT NULL,"+
		  "`Level` int(2) NOT NULL DEFAULT '1',"+
		  "`Admin` int(2) NOT NULL DEFAULT '0',"+
		  "`Banned` int(16) NOT NULL DEFAULT '0',"+
		  "`Money` int(16) NOT NULL DEFAULT '5000',"+
		  "`Bank` int(16) NOT NULL DEFAULT '0',"+
		  "`Health` int(4) NOT NULL DEFAULT '100',"+
		  "`Armour` int(4) NOT NULL DEFAULT '0',"+
		  "`Model` int(4) NOT NULL DEFAULT '0',"+
		  "`Dimension` int(8) NOT NULL DEFAULT '0',"+
		  "`Clothes_Head` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Upper` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Lower` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Special1` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Hand` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Feet` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Jacket` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Hair` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Special2` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Unknown` int(4) NOT NULL DEFAULT '0',"+
		  "`Clothes_Face` int(4) NOT NULL DEFAULT '0',"+
		  "`Interior` int(8) NOT NULL DEFAULT '0',"+
		  "`Heading` float NOT NULL DEFAULT '0',"+
		  "`Coordinates_x` float NOT NULL DEFAULT '0',"+
		  "`Coordinates_y` float NOT NULL DEFAULT '0',"+
		  "`Coordinates_z` float NOT NULL DEFAULT '0',"+
		  "`WantedLevel` int(8) NOT NULL DEFAULT '0',"+
		  "`Faction_Number` int(4) NOT NULL DEFAULT '0',"+
		  "`Faction_Rank` int(2) NOT NULL DEFAULT '0',"+
		  "`Faction_Skill` int(4) NOT NULL DEFAULT '0',"+
		  "`Job_Number` int(2) NOT NULL DEFAULT '0',"+
		  "`Job_Skill` int(4) NOT NULL DEFAULT '0',"+
		  "`Needs_Sleep` int(4) NOT NULL DEFAULT '0',"+
		  "`Needs_Eat` int(4) NOT NULL DEFAULT '0',"+
		  "`Needs_Piss` int(4) NOT NULL DEFAULT '0',"+
		  "`Needs_Communicate` int(4) NOT NULL DEFAULT '0',"+
		  "`Prestige` int(16) NOT NULL DEFAULT '0',"+
		  "`Mobile` int(16) NOT NULL DEFAULT '0',"+
		  "`LCar` int(1) NOT NULL DEFAULT '0',"+
		  "`LFly` int(1) NOT NULL DEFAULT '0',"+
		  "`LWater` int(1) NOT NULL DEFAULT '0',"+
		  "`LMotorcycle` int(1) NOT NULL DEFAULT '0',"+
		  "PRIMARY KEY (`SQLId`)"+
		") ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;");
		mysql_query( MySQL.Handler, "CREATE TABLE IF NOT EXISTS `houses` ("+
		  "`ID` int(9) NOT NULL AUTO_INCREMENT,"+
		  "`Name` varchar(64) COLLATE utf8_bin NOT NULL,"+
		  "`Owner` int(16) NOT NULL,"+
		  "`Enter_x` float NOT NULL,"+
		  "`Enter_y` float NOT NULL,"+
		  "`Enter_z` float NOT NULL,"+
		  "`Exit_x` float NOT NULL,"+
		  "`Exit_y` float NOT NULL,"+
		  "`Exit_z` float NOT NULL,"+
		  "`BuyPrice` int(16) NOT NULL,"+
		  "PRIMARY KEY (`ID`)"+
		") ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;");
		mysql_query( MySQL.Handler, "CREATE TABLE IF NOT EXISTS `biz` ("+ 
		  "`ID` int(9) NOT NULL AUTO_INCREMENT,"+
		  "`Name` varchar(64) COLLATE utf8_bin NOT NULL,"+
		  "`Type` int(2) COLLATE utf8_bin NOT NULL,"+
		  "`Enter_x` float NOT NULL,"+
		  "`Enter_y` float NOT NULL,"+
		  "`Enter_z` float NOT NULL,"+
		  "`CashMoneyGang` int(2) NOT NULL,"+
		  "`Money` int(10) NOT NULL,"+
		  "`Material` int(5) NOT NULL,"+
		  "`Owner` varchar(64) COLLATE utf8_bin NOT NULL,"+
		  "`BuyPrice` int(16) NOT NULL,"+
		  "`Prices` varchar(64) COLLATE utf8_bin NOT NULL,"+
		  "PRIMARY KEY (`ID`)"+
		") ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;");
		log("[MySQL]: Table created.");
		return true;
	}
	else
	{
		mysql_close(MySQL.Handler);
		log("[MySQL]: Disconnected.");
		return true;
	}
}

function haveNoPermissions(playerid)
{
	sendPlayerMessage(playerid, "Такой команды не существует, либо вы не имеете привилегий на её использование.");
	return true;
}

function msg(playerid, msgtype, text)
{
	switch(msgtype)
	{
		case ERROR:
			sendPlayerMessage(playerid, "[FFFFFFFF]Ошибка: [AA0000FF]"+text, 0xFFFFFFFF, true);
			break;
		case ALERT:
			sendPlayerMessage(playerid, "[FFFFFFFF]Уведомление: [00FF00FF]"+text, 0xFFFFFFFF, true);
			break;
		case ADVICE:
			sendPlayerMessage(playerid, "[FFFFFFFF]Подсказка: [AAAAAAAA]"+text, 0xFFFFFFFF, true);
			break;
	}
	return true;
}

function sendMessageToAdmins(text, level)
{
	for(local i = 0; i < MAX_PLAYERS; i++)
	{
		if(isPlayerConnected(i))
		{
			if(Player[i].Info.Temp.IsLogged)
			{
				if(Player[i].Info.Admin >= level)
				{
					sendPlayerMessage(i, "[FFFFFFFF]Чат администрации: [AAFF00FF]"+text, 0xFFFFFFFF, true);
				}
			}
		}
	}
}

function random(min = 0, max = RAND_MAX)
{
	srand(getTickCount() * rand());
	return (rand() % ((max + 1) - min)) + min;
}

function returnUser(string, playerid = INVALID_PLAYER_ID)
{
	if(isNumeric(string))
	{
		if(!isPlayerConnected(string.tointeger()))
		{
			if(playerid != INVALID_PLAYER_ID) log("Invalid playerID (" + string + ").");
			return INVALID_PLAYER_ID;
		}
		return string.tointeger();
	}
	local targetid = INVALID_PLAYER_ID;
	string = string.tolower();
	foreach(i,name in getPlayers())
	{
		name = name.tolower();
		if(name.len() < string.len()) // i.e. If string is "Adam_G", will skip players named "Adam", but not players name "Adam_Green", "Adam_Gee", etc..
		continue;
		local idx = name.find(string); // Find the search string in the players name
		if(idx != null) // match
		{
			if(targetid == INVALID_PLAYER_ID)
			{
				targetid = i;
			}
			else
			{
				if(playerid != INVALID_PLAYER_ID) log("Multiple matches found for name \"" + string + "\".");
				return INVALID_PLAYER_ID; // multiple matches
			}
		}
	}
	if(playerid != INVALID_PLAYER_ID && targetid == INVALID_PLAYER_ID) log("No matches found for name \"" + string + "\".");
	return targetid;
}

function getVehicleDriftAngle(vehicleid) {
    local rot = getVehicleRotation(vehicleid)[2];
    local vel = getVehicleVelocity(vehicleid);
    local speed = sqrt(vel[0]*vel[0]+vel[1]*vel[1]+vel[2]*vel[2]);
    local angle = abs(atan2(vel[0], vel[1]) * (180 / PI));
    if(rot > 180) rot = 360 - rot;
    if(speed.tointeger() == 0) return 0;
    return abs(angle - rot);
}



//#Классы#//
/*
* Date: 05.07.2013
* Time: 11:06
* Author: funtik
* Filename: player.class.nut
*/

class player
{
	playerid = 0;
	rows = -1;
	name = null;
	Info = { };
	License = { };
	mysqlhandler = null;
	firstspawn = false;
	died = false;
	//#Стартовые параметры игрока после регистрации#//
	StartParams = { };
	constructor(id, handler)
	{
		mysqlhandler = handler;
		playerid = id;
		Info.Temp <- { };
		Info.Temp.IsLogged <- false;
		Info.Level <- 0;
		Info.Admin <- 0;
		Info.Money <- 0;
		Info.Bank <- 0;
		Info.Drunk <- 0;
		Info.Health <- 0;
		Info.Armour <- 0;
		Info.Model <- 0;
		Info.Dimension <- 0;
		Info.Clothes <- { };
		Info.Clothes.Head <- 0;//Head
		Info.Clothes.Upper <- 0;//Upper body (e.g. shirts)
		Info.Clothes.Lower <- 0;//Lower body (e.g. pants, skirts)
		Info.Clothes.Special1 <- 0;//Special 1
		Info.Clothes.Hand <- 0;//Hand
		Info.Clothes.Feet <- 0;//Feet (e.g. shoes)
		Info.Clothes.Jacket <- 0;//Jacket
		Info.Clothes.Hair <- 0;//Hair
		Info.Clothes.Special2 <- 0;//Special 2
		Info.Clothes.Unknown <- 0;//?
		Info.Clothes.Face <- 0;//Face
		Info.Interior <- 0;
		Info.Heading <- 0.0;
		Info.Coordinates <- { };
		Info.Coordinates.x <- 0.0;
		Info.Coordinates.y <- 0.0;
		Info.Coordinates.z <- 0.0;
		Info.WantedLevel <- 0;
		Info.Faction <- { };
		Info.Faction.Number <- 0;
		Info.Faction.Rank <- 0;
		Info.Faction.Skill <- 0;
		Info.Job <- { };
		Info.Job.Number <- 0;
		Info.Job.Skill <- 0;
		Info.Needs <- { };
		Info.Needs.Sleep <- 0;
		Info.Needs.Eat <- 0;
		Info.Needs.Piss <- 0;
		Info.Needs.Communicate <- 0;
		Info.Prestige <- 0;
		Info.Mobile <- 0;
		License.Car <- 0;
		License.Fly <- 0;
		License.Water <- 0;
		License.Motorcycle <- 0;
		StartParams.Level <- 1;
		StartParams.Money <- 5000;
		StartParams.Heading <- 0.0;
		StartParams.Pos <- { };
		StartParams.Pos.X <- 0.0;
		StartParams.Pos.Y <- 0.0;
		StartParams.Pos.Z <- 0.0;
	}
	
	function Join()
	{
		name = getPlayerName(playerid);
		sendMessageToAll("[FF0000FF]" + name + " [00FF0000]присоединился к серверу!", 0xFFFFFFFF, true);
		local result = mysql_query(mysqlhandler, "SELECT * FROM `users` WHERE `Name`='"+mysql_escape_string(mysqlhandler, name)+"' LIMIT 1;");
		log(mysql_error(mysqlhandler));
		rows = mysql_affected_rows(mysqlhandler);
		setPlayerSpawnLocation(playerid, -166.373550, 599.350464, 14.714460, 0.096535);
		blockPlayerDropWeaponsAtDeath(playerid, false);
		mysql_free_result(result);
		return true;
	}
	
	function Disconnect(reason)
	{
		if(Info.Temp.IsLogged == true) Logout();
		sendMessageToAdmins("Игрок "+getPlayerName(playerid)+" отключился от сервера, причина: "+((reason == 0) ? "Вышел" : "Вылетел"), 1);
		return true;
	}
	
	function Register(password)
	{
		if(password.len() > 7)
		{
			local escaped_password = mysql_escape_string(mysqlhandler, password);
			local escaped_username = mysql_escape_string(mysqlhandler, getPlayerName(playerid));
			mysql_query(mysqlhandler, "INSERT INTO `users` (`SQLId`, `Name`, `Password`, `Level`, `Money`, `Coordinates_x`, `Coordinates_y`, `Coordinates_z`, `Heading`) VALUES (NULL, '"+escaped_username+"', '"+escaped_password+"', '"+StartParams.Level+"', '"+StartParams.Money+"', '"+StartParams.Pos.X+"', '"+StartParams.Pos.Y+"', '"+StartParams.Pos.Z+"', '"+StartParams.Heading+"');");
			Info.SQLId <- mysql_insert_id(mysqlhandler);
			Info.Temp.IsLogged = true;
			triggerClientEvent(playerid, "getRequest", true);
			setPlayerCoordinates(playerid, -166.373550, 599.350464, 14.714460);
			setPlayerHeading(playerid, 0.0);
			setCameraBehindPlayer(playerid);
			return true;
		}
		else
		{
			msg(playerid, ERROR, "Пароль должен содержать только строчные и прописные латинские буквы, цифры, спецсимволы. Минимум 8 символов");
			return true;
		}
	}
	
	function Login(password)
	{
		local escaped_password = mysql_escape_string(mysqlhandler, password);
		local escaped_username = mysql_escape_string(mysqlhandler, getPlayerName(playerid));
		local result = mysql_query(mysqlhandler, "SELECT * FROM `users` WHERE `Password`='"+escaped_password+"' AND `Name`='"+escaped_username+"' LIMIT 1;");
		if(mysql_affected_rows(mysqlhandler) == 1)
		{
			local row = mysql_fetch_assoc(result);
			Info.SQLId <- row["SQLId"];
			Info.Level <- row["Level"];
			Info.Admin <- row["Admin"];
			Info.Money <- row["Money"];
			Info.Bank <- row["Bank"];
			//Info.Drunk <- 0;
			Info.Health <- row["Health"];
			Info.Armour <- row["Armour"];
			Info.Model <- row["Model"];
			Info.Dimension <- row["Dimension"];
			Info.Clothes <- { };
			Info.Clothes.Head <- row["Clothes_Head"];//Head
			Info.Clothes.Upper <- row["Clothes_Upper"];//Upper body (e.g. shirts)
			Info.Clothes.Lower <- row["Clothes_Lower"];//Lower body (e.g. pants, skirts)
			Info.Clothes.Special1 <- row["Clothes_Special1"];//Special 1
			Info.Clothes.Hand <- row["Clothes_Hand"];//Hand
			Info.Clothes.Feet <- row["Clothes_Feet"];//Feet (e.g. shoes)
			Info.Clothes.Jacket <- row["Clothes_Jacket"];//Jacket
			Info.Clothes.Hair <- row["Clothes_Hair"];//Hair
			Info.Clothes.Special2 <- row["Clothes_Special2"];//Special 2
			Info.Clothes.Unknown <- row["Clothes_Unknown"];//?
			Info.Clothes.Face <- row["Clothes_Face"];//Face
			Info.Interior <- row["Interior"];
			Info.Heading <- row["Heading"].tofloat();
			Info.Coordinates <- { };
			Info.Coordinates.x <- row["Coordinates_x"].tofloat();
			Info.Coordinates.y <- row["Coordinates_y"].tofloat();
			Info.Coordinates.z <- row["Coordinates_z"].tofloat();
			Info.WantedLevel <- row["WantedLevel"];
			Info.Faction <- { };
			Info.Faction.Number <- row["Faction_Number"];
			Info.Faction.Rank <- row["Faction_Rank"];
			Info.Faction.Skill <- row["Faction_Skill"];
			Info.Job <- { };
			Info.Job.Number <- row["Job_Number"];
			Info.Job.Skill <- row["Job_Skill"];
			Info.Needs <- { };
			Info.Needs.Sleep <- row["Needs_Sleep"];
			Info.Needs.Eat <- row["Needs_Eat"];
			Info.Needs.Piss <- row["Needs_Piss"];
			Info.Needs.Communicate <- row["Needs_Communicate"];
			Info.Prestige <- row["Prestige"];
			Info.Mobile <- row["Mobile"];
			License.Car <- row["LCar"];
			License.Fly <- row["LFly"];
			License.Water <- row["LWater"];
			License.Motorcycle <- row["LMotorcycle"];
			Info.Temp <- { };
			Info.Temp.IsLogged <- true;
			triggerClientEvent(playerid, "getRequest", true);
			sendPlayerMessage(playerid, "Вы успешно вошли в систему. [0000FFFF]Все ваши данные были загружены.", 0x00FF00FF, true);
			setPlayerHealth(playerid, Info.Health);
			setPlayerArmour(playerid, Info.Armour);
			setPlayerModel(playerid, Info.Model);
			setPlayerDimension(playerid, Info.Dimension);
			setPlayerClothes(playerid, 0, Info.Clothes.Head);
			setPlayerClothes(playerid, 1, Info.Clothes.Upper);
			setPlayerClothes(playerid, 2, Info.Clothes.Lower);
			setPlayerClothes(playerid, 3, Info.Clothes.Special1);
			setPlayerClothes(playerid, 4, Info.Clothes.Hand);
			setPlayerClothes(playerid, 5, Info.Clothes.Feet);
			setPlayerClothes(playerid, 6, Info.Clothes.Jacket);
			setPlayerClothes(playerid, 7, Info.Clothes.Hair);
			setPlayerClothes(playerid, 8, Info.Clothes.Special2);
			setPlayerClothes(playerid, 9 Info.Clothes.Unknown);
			setPlayerClothes(playerid, 10, Info.Clothes.Face);
			setPlayerHeading(playerid, Info.Heading.tofloat());
			setPlayerCoordinates(playerid, Info.Coordinates.x.tofloat(), Info.Coordinates.y.tofloat(), Info.Coordinates.z.tofloat());
			setPlayerWantedLevel(playerid, Info.WantedLevel);
			setCameraBehindPlayer(playerid);
			mysql_free_result(result);
			return true;
		}
		else 
		{
			mysql_free_result(result);
			triggerClientEvent(playerid, "getRequest", false);
			sendPlayerMessage(playerid, "Ошибка входа. [0000FFFF]Пользователя с таким сочетанием логина и пароля не существует.", 0x00FF00FF, true);
			return false;
		}
	}
	
	function Logout()
	{
		Info.Health = GetHealth();
		Info.Armour = GetArmour();
		Info.Model = GetModel();
		Info.Dimension = GetDimension();
		local Clothes = GetClothes();
		Info.Clothes.Head = Clothes[0];//Head
		Info.Clothes.Upper = Clothes[1];//Upper body (e.g. shirts)
		Info.Clothes.Lower = Clothes[2];//Lower body (e.g. pants, skirts)
		Info.Clothes.Special1 = Clothes[3];//Special 1
		Info.Clothes.Hand = Clothes[4];//Hand
		Info.Clothes.Feet = Clothes[5];//Feet (e.g. shoes)
		Info.Clothes.Jacket = Clothes[6];//Jacket
		Info.Clothes.Hair = Clothes[7];//Hair
		Info.Clothes.Special2 = Clothes[8];//Special 2
		Info.Clothes.Unknown = Clothes[9];//?
		Info.Clothes.Face = Clothes[10];//Face
		//Info.Interior = GetInterior();
		Info.Heading = GetHeading();
		local Coordinates = GetCoordinates();
		Info.Coordinates.x = Coordinates[0];
		Info.Coordinates.y = Coordinates[1];
		Info.Coordinates.z = Coordinates[2];
		local result = mysql_query(mysqlhandler, "UPDATE `users` SET `Level`='"+Info.Level+"', `Admin`='"+Info.Admin+"', `Money`='"+Info.Money+"', `Bank`='"+Info.Bank+"', `Health`='"+Info.Health+"', `Armour`='"+Info.Armour+"', `Model`='"+Info.Model+"', `Dimension`='"+Info.Dimension+"',"+
		"`Clothes_Head`='"+Info.Clothes.Head+"', `Clothes_Upper`='"+Info.Clothes.Upper+"', `Clothes_Lower`='"+Info.Clothes.Lower+"', `Clothes_Special1`='"+Info.Clothes.Special1+"', `Clothes_Hand`='"+Info.Clothes.Hand+"', `Clothes_Feet`='"+Info.Clothes.Feet+"', `Clothes_Jacket`='"+Info.Clothes.Jacket+"', "+
		"`Clothes_Hair`='"+Info.Clothes.Hair+"', `Clothes_Special2`='"+Info.Clothes.Special2+"', `Clothes_Unknown`='"+Info.Clothes.Unknown+"', `Clothes_Face`='"+Info.Clothes.Face+"', `Interior`='"+Info.Interior+"', `Heading`='"+Info.Heading+"', `Coordinates_x`='"+Info.Coordinates.x+"', `Coordinates_y`='"+Info.Coordinates.y+"', `Coordinates_z`='"+Info.Coordinates.z+"',"+
		"`WantedLevel`='"+Info.WantedLevel+"', `Faction_Number`='"+Info.Faction.Number+"', `Faction_Rank`='"+Info.Faction.Rank+"', `Faction_Skill`='"+Info.Faction.Skill+"', `Job_Number`='"+Info.Job.Number+"', `Job_Skill`='"+Info.Job.Skill+"', `Needs_Sleep`='"+Info.Needs.Sleep+"', `Needs_Eat`='"+Info.Needs.Eat+"',"+
		"`Needs_Piss`='"+Info.Needs.Piss+"', `Needs_Communicate`='"+Info.Needs.Communicate+"', `Prestige`='"+Info.Prestige+"', `LCar`='"+License.Car+"', `LFly`='"+License.Fly+"', `LWater`='"+License.Water+"', `LMotorcycle`='"+License.Motorcycle+"' WHERE `Name`='"+getPlayerName(playerid)+"' LIMIT 1;");
		return true;
	}
	
	function Spawn()
	{
		if(!firstspawn)
		{
			if(rows == 1) triggerClientEvent(playerid, "getRegisterInfo", 0);
			else triggerClientEvent(playerid, "getRegisterInfo", 1);
			setPlayerCameraPos(playerid, -593.514526, -590.455505, 122.936066);
			setPlayerCameraLookAt(playerid, -608.250122, -744.111877, 20.703838);
			firstspawn = true; 
		}
		if(died)
		{
			setPlayerCoordinates(playerid, -166.373550, 599.350464, 14.714460);
			setPlayerHeading(playerid, 0.0);
		}
		else
		{
			setPlayerMoney(playerid, Info.Money);
			setPlayerCoordinates(playerid, Info.Coordinates.x.tofloat(), Info.Coordinates.y.tofloat(), Info.Coordinates.z.tofloat());
			setPlayerHeading(playerid, Info.Heading.tofloat());
		}
		return true;
	}
	
	function Death()
	{
		died = true;
	}
	
	function SpawnOnJob()
	{
	}
	
	function Ban(days)
	{
		mysql_query(mysqlhandler, "UPDATE `users` SET `Banned`=(UNIX_TIMESTAMP()+60*60*24*"+days+") WHERE `SQLId`='"+Info.SQLId+"' LIMIT 1;");
		kickPlayer(playerid, true);
	}
	
	function SetHealth(health)
	{
		Info.Health = health;
		return setPlayerHealth(playerid, health);
	}
	
	function GetHealth()
	{
		return getPlayerHealth(playerid);
	}
	
	function SetArmour(armour)
	{
		Info.Armour = armour;
		return setPlayerArmour(playerid, armour);
	}
	
	function GetArmour()
	{
		return getPlayerArmour(playerid);
	}
	
	function SetModel(model)
	{
		Info.Model = model;
		return setPlayerModel(playerid, model);
	}
	
	function GetModel()
	{
		return getPlayerModel(playerid);
	}
	
	function SetDimension(dimension)
	{
		Info.Dimension = dimension;
		return setPlayerDimension(dimension);
	}
	
	function GetDimension()
	{
		return getPlayerDimension(playerid);
	}
	
	function SetClothes(type, cloth)
	{
		return setPlayerClothes(playerid, type, cloth);
	}
	
	function GetClothes()
	{
		return getPlayerClothes(playerid);
	}
	
	/*function SetInterior(interior)
	{
		Info.Interior = interior;
		return setPlayerInterior(interior);
	}
	
	function GetInterior()
	{
		return getPlayerInterior(playerid);
	}*/
	
	function SetHeading(heading)
	{
		Info.Heading = heading;
		return setPlayerHeading(heading);
	}
	
	function GetHeading()
	{
		return getPlayerHeading(playerid);
	}
	
	function SetCoordinates(x, y, z)
	{
		Info.Coordinates.x = x;
		Info.Coordinates.y = y;
		Info.Coordinates.z = z;
		return setPlayerCoordinates(playerid, x, y, z);
	}
	
	function GetCoordinates()
	{
		return getPlayerCoordinates(playerid);
	}
	
	function SetWantedLevel(level)
	{
		Info.WantedLevel = level;
		return setPlayerWantedLevel(level);
	}
	
	function GetWantedLevel()
	{
		return Info.WantedLevel;
	}
	
	function GiveMoney(money)
	{
		givePlayerMoney(playerid, money);
		Info.Money += money;
	}
	
	function GetMoney()
	{
		return Info.Money;
	}
}
log("Player class loaded.");

/*
* @date: 05.07.2013
* @time: 11:06
* @author: funtik
* @class: houses.class.nut
*/

class houses
{
	Info = { };
	mysqlhandler = null;
	constructor(handler)
	{
		mysqlhandler = handler;
	}
	
	function CreateNew(name, enter_x, enter_y, enter_z, exit_x, exit_y, exit_z, buyprice)
	{
		mysql_query(mysqlhandler, "INSERT INTO `houses` (`ID`, `Name`, `Owner`, `Enter_x`, `Enter_y`, `Enter_z`, `Exit_x`, `Exit_y`, `Exit_z`, `BuyPrice`) VALUES (NULL, '"+name+"', 0,'"+enter_x+"', '"+enter_y+"', '"+enter_z+"', '"+exit_x+"', '"+exit_y+"', '"+exit_z+"', '"+buyprice+"');");
		log(mysql_error(mysqlhandler));
		local houseid = mysql_insert_id(mysqlhandler);
		Info[houseid] <- { };
		Info[houseid].Name <- name;
		Info[houseid].Owner <- 0;
		Info[houseid].Enter <- { };
		Info[houseid].Enter.X <- enter_x;
		Info[houseid].Enter.Y <- enter_y;
		Info[houseid].Enter.Z <- enter_z;
		Info[houseid].Exit <- { };
		Info[houseid].Exit.X <- exit_x;
		Info[houseid].Exit.Y <- exit_y;
		Info[houseid].Exit.Z <- exit_z;
		Info[houseid].BuyPrice <- buyprice;
		Info[houseid].Text3D <- create3DLabel("[0000FFFF]Номер дома: [00FFFFFF]#"+houseid.tostring()+"\n[0000FFFF]Описание: [00FFFFFF]"+Info[houseid].Name.tostring()+"\n[0000FFFF]Цена: [00FFFFFF]"+Info[houseid].BuyPrice.tostring()+"[00FF00FF]$", Info[houseid].Enter.X, Info[houseid].Enter.Y, Info[houseid].Enter.Z, 0xFFFFFFFF, true, 10.0);
		return true;
	}
	
	function Load()
	{
		local arr;
		local result = mysql_query(mysqlhandler, "SELECT * FROM `houses`");
		while(arr = mysql_fetch_assoc(result))
		{
			local houseid = arr["ID"];
			Info[houseid] <- { };
			Info[houseid].Name <- arr["Name"];
			Info[houseid].Owner <- arr["Owner"];
			Info[houseid].Enter <- { };
			Info[houseid].Enter.X <- arr["Enter_x"];
			Info[houseid].Enter.Y <- arr["Enter_y"];
			Info[houseid].Enter.Z <- arr["Enter_z"];
			Info[houseid].Exit <- { };
			Info[houseid].Exit.X <- arr["Exit_x"];
			Info[houseid].Exit.Y <- arr["Exit_y"];
			Info[houseid].Exit.Z <- arr["Exit_z"];
			Info[houseid].BuyPrice <- arr["BuyPrice"];
			Info[houseid].Text3D <- create3DLabel("[0000FFFF]Номер дома: [00FFFFFF]#"+houseid.tostring()+"\n[0000FFFF]Описание: [00FFFFFF]"+Info[houseid].Name.tostring()+"\n[0000FFFF]Цена: [00FFFFFF]"+Info[houseid].BuyPrice.tostring()+"[00FF00FF]$", Info[houseid].Enter.X, Info[houseid].Enter.Y, Info[houseid].Enter.Z, 0xFFFFFFFF, true, 10.0);
		}
		mysql_free_result(result);
		return true;
	}
	
	function Save()
	{
		local arr;
		local result = mysql_query(mysqlhandler, "SELECT * FROM `houses`");
		while(arr = mysql_fetch_assoc(result))
		{
			local houseid = arr["ID"];
			mysql_query(mysqlhandler, "UPDATE `houses` SET `Owner`='"+Info[houseid].Owner+"' WHERE `ID`='"+houseid+"';");
		}
		mysql_free_result(result);
		return true;
	}
}
log("Houses class loaded.");

class biz //новое
{
	Info = { };
	mysqlhandler = null;
	constructor(handler)
	{
		mysqlhandler = handler;
	}
	
	function CreateNew(name, typed, enter_x, enter_y, enter_z, buyprice)
	{
		mysql_query(mysqlhandler, "INSERT INTO `biz` (`ID`, `Name`, `Type`, `Enter_x`, `Enter_y`, `Enter_z`, `CashMoneyGang`, `Money`, `Material`, `Owner`, `BuyPrice`, `Price1`,`Price2`,`Price3`,`Price4`,`Price5`,`Price6`,`Price7`) VALUES (NULL, '"+name+"', '"+typed+"', '"+enter_x+"', '"+enter_y+"', '"+enter_z+"', 0, 500, None,'"+buyprice+"', 0, 0, 0, 0, 0, 0, 0);");
		log(mysql_error(mysqlhandler));
		local bizid = mysql_insert_id(mysqlhandler);
		Info[bizid] <- { };
		Info[bizid].Name <- name;
		Info[bizid].Owner <- 0;
		Info[bizid].Typed <- typed;
		Info[bizid].CashMoneyGang <- 0;
		Info[bizid].Money <- 0;
		Info[bizid].Material <- 0;
		Info[bizid].Enter <- { };
		Info[bizid].Enter.X <- enter_x;
		Info[bizid].Enter.Y <- enter_y;
		Info[bizid].Enter.Z <- enter_z;
		Info[bizid].BuyPrice <- buyprice;
		Info[bizid].Prices <- "";
		Info[bizid].Text3D <- create3DLabel("[0000FFFF]Номер бизнеса: [00FFFFFF]#"+bizid.tostring()+"\n[0000FFFF]Описание: [00FFFFFF]"+Info[bizid].Name.tostring()+"\n[0000FFFF]Цена: [00FFFFFF]"+Info[bizid].BuyPrice.tostring()+"[00FF00FF]$", Info[bizid].Enter.X, Info[bizid].Enter.Y, Info[bizid].Enter.Z, 0xFFFFFFFF, true, 10.0);
		return true;
	}
	
	function Load()
	{
		local arr;
		local result = mysql_query(mysqlhandler, "SELECT * FROM `biz`");
		while(arr = mysql_fetch_assoc(result))
		{
			local bizid = arr["ID"];
			Info[bizid] <- { };
			Info[bizid].Name <- arr["Name"];
			Info[bizid].Typed <- arr["Type"];
			Info[bizid].Enter <- { };
			Info[bizid].Enter.X <- arr["Enter_x"];
			Info[bizid].Enter.Y <- arr["Enter_y"];
			Info[bizid].Enter.Z <- arr["Enter_z"];
			Info[bizid].CashMoneyGang <- arr["CashMoneyGang"];
			Info[bizid].Money <- arr["Money"];
			Info[bizid].Material <- arr["Material"];
			Info[bizid].Owner <- arr["Owner"];
			Info[bizid].BuyPrice <- arr["BuyPrice"];
			Info[bizid].Prices <- arr["Prices"];
			Info[bizid].Text3D <- create3DLabel("[0000FFFF]Номер бизнеса: [00FFFFFF]#"+bizid.tostring()+"\n[0000FFFF]Описание: [00FFFFFF]"+Info[bizid].Name.tostring()+"\n[0000FFFF]Цена: [00FFFFFF]"+Info[bizid].BuyPrice.tostring()+"[00FF00FF]$", Info[bizid].Enter.X, Info[bizid].Enter.Y, Info[bizid].Enter.Z, 0xFFFFFFFF, true, 10.0);
		}
		mysql_free_result(result);
		return true;
	}
	
	function Save()
	{
		local arr;
		local result = mysql_query(mysqlhandler, "SELECT * FROM `biz`");
		while(arr = mysql_fetch_assoc(result))
		{
			local bizid = arr["ID"];
			mysql_query(mysqlhandler, "UPDATE `biz` SET `Owner`='"+Info[bizid].Owner+"', `Money`='"+Info[bizid].Money+"', `CashMoneyGang`='"+Info[bizid].CashMoneyGang+"' WHERE `ID`='"+houseid+"';");
		}
		mysql_free_result(result);
		return true;
	}
}
log("Biz class loaded.");
