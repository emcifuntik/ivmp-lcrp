/*
* Date: 05.07.2013
* Time: 11:06
* Author: funtik
* Filename: client.nut
*/

local cWeight = array(123, 0);
local cCost = array(123, 0);
local cAngle = array(123, 0);
local cSpeed = array(123, 0);
local cAcceleration = array(123, 0.0);
local cTransmission = array(123, "");
local carModel=0;
local last = 0;
local contr = false;
local nm;
local screen = guiGetScreenSize();
local isRegister = 0;
local waitingTurn = 0;
local doneTurn = 0;
local Clothes = array(11, 0);
local ClothChange = array(11, 0);
//local cManufacter = ["Dundreary", "Unknown", "Brute", "Bravado", "Vapid", "HVY", "Dinka", "Vapid", "Brute", "Albany", "Declasse", 
/* CarBuyGUI */
local CarBuyGUI = { };
local CarIMG = array(123, null);
CarBuyGUI.window <- GUIWindow();
CarBuyGUI.window.setText("Car buying");
CarBuyGUI.window.setVisible(false);
CarBuyGUI.window.setSize(500.0, 500.0, false);
CarBuyGUI.window.setPosition((screen[0]/2)-250, (screen[1]/2)-250, false);
CarBuyGUI.object <- array(25, null);
CarBuyGUI.object[0] = GUIButton();
CarBuyGUI.object[0].setText("<");
CarBuyGUI.object[0].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[0].setVisible(true);
CarBuyGUI.object[0].setSize(30.0, 30.0, false);
CarBuyGUI.object[0].setPosition(0.0, 0.0, false);
CarBuyGUI.object[1] = GUIButton();
CarBuyGUI.object[1].setText(">");
CarBuyGUI.object[1].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[1].setVisible(true);
CarBuyGUI.object[1].setSize(30.0, 30.0, false);
CarBuyGUI.object[1].setPosition(447.0, 0.0, false);
CarBuyGUI.object[3] = GUIText();
CarBuyGUI.object[3].setText("ID: 0");
CarBuyGUI.object[3].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[3].setVisible(true);
CarBuyGUI.object[3].setSize(100.0, 15.0, false);
CarBuyGUI.object[3].setPosition(36.5, 0.0, false);
CarBuyGUI.object[4] = GUIText();
CarBuyGUI.object[4].setText("Model: Admiral");
CarBuyGUI.object[4].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[4].setVisible(true);
CarBuyGUI.object[4].setSize(150.0, 15.0, false);
CarBuyGUI.object[4].setPosition(36.5, 15.0, false);
CarBuyGUI.object[5] = GUIEditBox();
CarBuyGUI.object[5].setText("");
CarBuyGUI.object[5].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[5].setVisible(true);
CarBuyGUI.object[5].setSize(90.0, 21.0, false);
CarBuyGUI.object[5].setPosition(303.0, 5.0, false);
CarBuyGUI.object[6] = GUIButton();
CarBuyGUI.object[6].setText("GO");
CarBuyGUI.object[6].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[6].setVisible(true);
CarBuyGUI.object[6].setSize(40.0, 21.0, false);
CarBuyGUI.object[6].setPosition(398.0, 5.0, false);
CarBuyGUI.object[7] = GUIText();
CarBuyGUI.object[7].setText("Manufacturer: Bravado");
CarBuyGUI.object[7].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[7].setVisible(true);
CarBuyGUI.object[7].setSize(250.0, 15.0, false);
CarBuyGUI.object[7].setPosition(33.5, 182.0, false);
CarBuyGUI.object[8] = GUIText();
CarBuyGUI.object[8].setText("Weight: 1500 kg");
CarBuyGUI.object[8].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[8].setVisible(true);
CarBuyGUI.object[8].setSize(250.0, 15.0, false);
CarBuyGUI.object[8].setPosition(33.5, 197.0, false);
CarBuyGUI.object[9] = GUIText();
CarBuyGUI.object[9].setText("Cost: $80000");
CarBuyGUI.object[9].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[9].setVisible(true);
CarBuyGUI.object[9].setSize(250.0, 15.0, false);
CarBuyGUI.object[9].setPosition(33.5, 212.0, false);
CarBuyGUI.object[10] = GUIText();
CarBuyGUI.object[10].setText("Turn angle: 35°");
CarBuyGUI.object[10].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[10].setVisible(true);
CarBuyGUI.object[10].setSize(250.0, 15.0, false);
CarBuyGUI.object[10].setPosition(33.5, 227.0, false);
CarBuyGUI.object[11] = GUIText();
CarBuyGUI.object[11].setText("Max speed: 339 km/h");
CarBuyGUI.object[11].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[11].setVisible(true);
CarBuyGUI.object[11].setSize(250.0, 15.0, false);
CarBuyGUI.object[11].setPosition(33.5, 242.0, false);
CarBuyGUI.object[12] = GUIText();
CarBuyGUI.object[12].setText("Acceleration: 4.3 sec.");
CarBuyGUI.object[12].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[12].setVisible(true);
CarBuyGUI.object[12].setSize(250.0, 15.0, false);
CarBuyGUI.object[12].setPosition(33.5, 257.0, false);
CarBuyGUI.object[13] = GUIText();
CarBuyGUI.object[13].setText("Transmission: RWD");
CarBuyGUI.object[13].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[13].setVisible(true);
CarBuyGUI.object[13].setSize(250.0, 15.0, false);
CarBuyGUI.object[13].setPosition(33.5, 272.0, false);
CarBuyGUI.object[14] = GUIText();
CarBuyGUI.object[14].setText("Color 1:");
CarBuyGUI.object[14].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[14].setVisible(true);
CarBuyGUI.object[14].setSize(50.0, 15.0, false);
CarBuyGUI.object[14].setPosition(33.5, 292.0, false);
CarBuyGUI.object[15] = GUIText();
CarBuyGUI.object[15].setText("Color 2:");
CarBuyGUI.object[15].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[15].setVisible(true);
CarBuyGUI.object[15].setSize(50.0, 15.0, false);
CarBuyGUI.object[15].setPosition(33.5, 322.0, false);
CarBuyGUI.object[16] = GUIEditBox();
CarBuyGUI.object[16].setText("");
CarBuyGUI.object[16].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[16].setVisible(true);
CarBuyGUI.object[16].setSize(42.0, 21.0, false);
CarBuyGUI.object[16].setPosition(87.0, 292.0, false);
CarBuyGUI.object[17] = GUIEditBox();
CarBuyGUI.object[17].setText("");
CarBuyGUI.object[17].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[17].setVisible(true);
CarBuyGUI.object[17].setSize(42.0, 21.0, false);
CarBuyGUI.object[17].setPosition(87.0, 322.0, false);
CarBuyGUI.object[18] = GUIText();
CarBuyGUI.object[18].setText("Color 3:");
CarBuyGUI.object[18].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[18].setVisible(true);
CarBuyGUI.object[18].setSize(50.0, 15.0, false);
CarBuyGUI.object[18].setPosition(139.5, 292.0, false);
CarBuyGUI.object[19] = GUIText();
CarBuyGUI.object[19].setText("Color 4:");
CarBuyGUI.object[19].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[19].setVisible(true);
CarBuyGUI.object[19].setSize(50.0, 15.0, false);
CarBuyGUI.object[19].setPosition(139.5, 322.0, false);
CarBuyGUI.object[20] = GUIEditBox();
CarBuyGUI.object[20].setText("");
CarBuyGUI.object[20].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[20].setVisible(true);
CarBuyGUI.object[20].setSize(42.0, 21.0, false);
CarBuyGUI.object[20].setPosition(193.0, 292.0, false);
CarBuyGUI.object[21] = GUIEditBox();
CarBuyGUI.object[21].setText("");
CarBuyGUI.object[21].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[21].setVisible(true);
CarBuyGUI.object[21].setSize(42.0, 21.0, false);
CarBuyGUI.object[21].setPosition(193.0, 322.0, false);
CarBuyGUI.object[22] = GUIButton();
CarBuyGUI.object[22].setText("OK");
CarBuyGUI.object[22].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[22].setVisible(true);
CarBuyGUI.object[22].setSize(70.0, 25.0, false);
CarBuyGUI.object[22].setPosition(366.0, 292.0, false);
CarBuyGUI.object[23] = GUIButton();
CarBuyGUI.object[23].setText("Cancel");
CarBuyGUI.object[23].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[23].setVisible(true);
CarBuyGUI.object[23].setSize(70.0, 25.0, false);
CarBuyGUI.object[23].setPosition(366.0, 325.0, false);
CarBuyGUI.object[24] = GUIImage("Colors.png");
CarBuyGUI.object[24].setParent(CarBuyGUI.window.getName());
CarBuyGUI.object[24].setVisible(true);
CarBuyGUI.object[24].setSize(400.0, 110.0, false);
CarBuyGUI.object[24].setPosition(39.0, 354.0, false);
for(local i = 0; i < 123; i++)
{
	if(i != 69)
	{
		CarIMG[i] = GUIImage("Car"+i+".jpg");
		CarIMG[i].setParent(CarBuyGUI.window.getName());
		CarIMG[i].setVisible(false);
		CarIMG[i].setSize(400.0, 150.0, false);
		CarIMG[i].setPosition(40.0, 34.0, false);
	}
}
CarIMG[0].setVisible(true);
/* API: */
CarBuyGUI.visible <- false;
CarBuyGUI.allowClose <- true;

/* LoginRegisterGUI */
local LoginRegisterGUI = {};
LoginRegisterGUI.window <- GUIWindow();
LoginRegisterGUI.window.setText("Вход в аккаунт");
LoginRegisterGUI.window.setSize(412.0, 210.0, false);
LoginRegisterGUI.window.setPosition(396.0, 330.0, false);
LoginRegisterGUI.window.setVisible(false);
LoginRegisterGUI.object <- array(13, null);
LoginRegisterGUI.object[0] = GUIText();
LoginRegisterGUI.object[0].setText("Добро пожаловать на сервер CFour.biz Liberty City RolePlay");
LoginRegisterGUI.object[0].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[0].setSize(400.0, 20.0, false);
LoginRegisterGUI.object[0].setPosition(21.5, 0.0, false);
LoginRegisterGUI.object[1] = GUIText();
LoginRegisterGUI.object[1].setText("Пожалуйста пройдите авторизацию или регистрацией перед");
LoginRegisterGUI.object[1].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[1].setSize(500.0, 20.0, false);
LoginRegisterGUI.object[1].setPosition(2.5, 13.0, false);
LoginRegisterGUI.object[2] = GUIText();
LoginRegisterGUI.object[2].setText("тем, как играть на нашем сервере.");
LoginRegisterGUI.object[2].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[2].setSize(200.0, 20.0, false);
LoginRegisterGUI.object[2].setPosition(2.5, 25.0, false);
LoginRegisterGUI.object[3] = GUIEditBox();
LoginRegisterGUI.object[3].setText(getPlayerName(getLocalPlayer()));
LoginRegisterGUI.object[3].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[3].setSize(150.0, 21.0, false);
LoginRegisterGUI.object[3].setPosition(188.0, 57.0, false);
LoginRegisterGUI.object[3].setProperty("Enabled", "false");
LoginRegisterGUI.object[4] = GUIText();
LoginRegisterGUI.object[4].setText("Имя пользователя");
LoginRegisterGUI.object[4].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[4].setSize(120.0, 20.0, false);
LoginRegisterGUI.object[4].setPosition(27.5, 50.0, false);
LoginRegisterGUI.object[5] = GUIEditBox();
LoginRegisterGUI.object[5].setText("");
LoginRegisterGUI.object[5].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[5].setSize(150.0, 21.0, false);
LoginRegisterGUI.object[5].setPosition(188.0, 82.0, false);
LoginRegisterGUI.object[5].setProperty("MaskText", "true");
LoginRegisterGUI.object[6] = GUIText();
LoginRegisterGUI.object[6].setText("Пароль");
LoginRegisterGUI.object[6].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[6].setSize(100.0, 20.0, false);
LoginRegisterGUI.object[6].setPosition(27.5, 75.0, false);
LoginRegisterGUI.object[7] = GUIButton();
LoginRegisterGUI.object[7].setText("");
LoginRegisterGUI.object[7].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[7].setSize(90.0, 28.0, false);
LoginRegisterGUI.object[7].setPosition(248.0, 107.0, false);
LoginRegisterGUI.object[8] = GUICheckBox();
LoginRegisterGUI.object[8].setProperty("Text", "Запомнить меня");
LoginRegisterGUI.object[8].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[8].setSize(150.0, 20.0, false);
LoginRegisterGUI.object[8].setPosition(34.0, 112.0, false);
LoginRegisterGUI.object[8].setProperty("TextColour", "0xFFFFFFFF");
LoginRegisterGUI.object[9] = GUIButton();
LoginRegisterGUI.object[9].setText("Правила");
LoginRegisterGUI.object[9].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[9].setSize(90.0, 28.0, false);
LoginRegisterGUI.object[9].setPosition(0.0, 143.0, false);
LoginRegisterGUI.object[10] = GUIButton();
LoginRegisterGUI.object[10].setText("F.A.Q");
LoginRegisterGUI.object[10].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[10].setSize(90.0, 28.0, false);
LoginRegisterGUI.object[10].setPosition(102.0, 143.0, false);
LoginRegisterGUI.object[11] = GUIButton();
LoginRegisterGUI.object[11].setText("Новое");
LoginRegisterGUI.object[11].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[11].setSize(90.0, 28.0, false);
LoginRegisterGUI.object[11].setPosition(204.0, 143.0, false);
LoginRegisterGUI.object[12] = GUIButton();
LoginRegisterGUI.object[12].setText("Новичку");
LoginRegisterGUI.object[12].setParent(LoginRegisterGUI.window.getName());
LoginRegisterGUI.object[12].setSize(90.0, 28.0, false);
LoginRegisterGUI.object[12].setPosition(306.0, 143.0, false);
LoginRegisterGUI.visible <- false;
LoginRegisterGUI.allowClose <- true;
LoginRegisterGUI.toggle <- function() { LoginRegisterGUI.visible = !LoginRegisterGUI.visible; LoginRegisterGUI.window.setVisible(LoginRegisterGUI.visible); guiToggleCursor(LoginRegisterGUI.visible); }
/* GUIBuyClothes */
local GUIBuyClothes = {};
GUIBuyClothes.window <- GUIWindow();
GUIBuyClothes.window.setText("Покупка одежды");
GUIBuyClothes.window.setVisible(false);
GUIBuyClothes.window.setSize(240.0, 320.0, false);
GUIBuyClothes.window.setPosition((screen[0]/2)-120, (screen[1]/2)-160, false);
GUIBuyClothes.object <- array(29, null);
GUIBuyClothes.object[0] = GUIText();
GUIBuyClothes.object[0].setText("Магазин одежды.");
GUIBuyClothes.object[0].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[0].setVisible(true);
GUIBuyClothes.object[0].setSize(200.0, 15.0, false);
GUIBuyClothes.object[0].setPosition(51.5, 1.0, false);
GUIBuyClothes.object[1] = GUIButton();
GUIBuyClothes.object[1].setText("<");
GUIBuyClothes.object[1].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[1].setVisible(true);
GUIBuyClothes.object[1].setSize(28.0, 28.0, false);
GUIBuyClothes.object[1].setPosition(135.0, 32.0, false);
GUIBuyClothes.object[2] = GUIButton();
GUIBuyClothes.object[2].setText(">");
GUIBuyClothes.object[2].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[2].setVisible(true);
GUIBuyClothes.object[2].setSize(28.0, 28.0, false);
GUIBuyClothes.object[2].setPosition(164.0, 32.0, false);
GUIBuyClothes.object[3] = GUIButton();
GUIBuyClothes.object[3].setText("X");
GUIBuyClothes.object[3].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[3].setVisible(true);
GUIBuyClothes.object[3].setSize(28.0, 28.0, false);
GUIBuyClothes.object[3].setPosition(193.0, 32.0, false);
GUIBuyClothes.object[4] = GUIText();
GUIBuyClothes.object[4].setText("Голова");
GUIBuyClothes.object[4].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[4].setVisible(true);
GUIBuyClothes.object[4].setSize(100.0, 15.0, false);
GUIBuyClothes.object[4].setPosition(9.5, 29.0, false);
GUIBuyClothes.object[5] = GUIButton();
GUIBuyClothes.object[5].setText("<");
GUIBuyClothes.object[5].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[5].setVisible(true);
GUIBuyClothes.object[5].setSize(28.0, 28.0, false);
GUIBuyClothes.object[5].setPosition(135.0, 63.0, false);
GUIBuyClothes.object[6] = GUIButton();
GUIBuyClothes.object[6].setText(">");
GUIBuyClothes.object[6].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[6].setVisible(true);
GUIBuyClothes.object[6].setSize(28.0, 28.0, false);
GUIBuyClothes.object[6].setPosition(164.0, 63.0, false);
GUIBuyClothes.object[7] = GUIButton();
GUIBuyClothes.object[7].setText("X");
GUIBuyClothes.object[7].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[7].setVisible(true);
GUIBuyClothes.object[7].setSize(28.0, 28.0, false);
GUIBuyClothes.object[7].setPosition(193.0, 63.0, false);
GUIBuyClothes.object[8] = GUIText();
GUIBuyClothes.object[8].setText("Торс");
GUIBuyClothes.object[8].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[8].setVisible(true);
GUIBuyClothes.object[8].setSize(100.0, 15.0, false);
GUIBuyClothes.object[8].setPosition(9.5, 59.0, false);
GUIBuyClothes.object[9] = GUIButton();
GUIBuyClothes.object[9].setText("<");
GUIBuyClothes.object[9].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[9].setVisible(true);
GUIBuyClothes.object[9].setSize(28.0, 28.0, false);
GUIBuyClothes.object[9].setPosition(135.0, 94.0, false);
GUIBuyClothes.object[10] = GUIButton();
GUIBuyClothes.object[10].setText(">");
GUIBuyClothes.object[10].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[10].setVisible(true);
GUIBuyClothes.object[10].setSize(28.0, 28.0, false);
GUIBuyClothes.object[10].setPosition(164.0, 94.0, false);
GUIBuyClothes.object[11] = GUIButton();
GUIBuyClothes.object[11].setText("X");
GUIBuyClothes.object[11].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[11].setVisible(true);
GUIBuyClothes.object[11].setSize(28.0, 28.0, false);
GUIBuyClothes.object[11].setPosition(193.0, 94.0, false);
GUIBuyClothes.object[12] = GUIText();
GUIBuyClothes.object[12].setText("Ноги");
GUIBuyClothes.object[12].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[12].setVisible(true);
GUIBuyClothes.object[12].setSize(100.0, 15.0, false);
GUIBuyClothes.object[12].setPosition(10.5, 92.0, false);
GUIBuyClothes.object[13] = GUIButton();
GUIBuyClothes.object[13].setText("<");
GUIBuyClothes.object[13].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[13].setVisible(true);
GUIBuyClothes.object[13].setSize(28.0, 28.0, false);
GUIBuyClothes.object[13].setPosition(135.0, 125.0, false);
GUIBuyClothes.object[14] = GUIButton();
GUIBuyClothes.object[14].setText(">");
GUIBuyClothes.object[14].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[14].setVisible(true);
GUIBuyClothes.object[14].setSize(28.0, 28.0, false);
GUIBuyClothes.object[14].setPosition(164.0, 125.0, false);
GUIBuyClothes.object[15] = GUIButton();
GUIBuyClothes.object[15].setText("X");
GUIBuyClothes.object[15].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[15].setVisible(true);
GUIBuyClothes.object[15].setSize(28.0, 28.0, false);
GUIBuyClothes.object[15].setPosition(193.0, 125.0, false);
GUIBuyClothes.object[16] = GUIText();
GUIBuyClothes.object[16].setText("Ступни");
GUIBuyClothes.object[16].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[16].setVisible(true);
GUIBuyClothes.object[16].setSize(100.0, 15.0, false);
GUIBuyClothes.object[16].setPosition(9.5, 121.0, false);
GUIBuyClothes.object[17] = GUIButton();
GUIBuyClothes.object[17].setText("<");
GUIBuyClothes.object[17].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[17].setVisible(true);
GUIBuyClothes.object[17].setSize(28.0, 28.0, false);
GUIBuyClothes.object[17].setPosition(135.0, 156.0, false);
GUIBuyClothes.object[18] = GUIButton();
GUIBuyClothes.object[18].setText(">");
GUIBuyClothes.object[18].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[18].setVisible(true);
GUIBuyClothes.object[18].setSize(28.0, 28.0, false);
GUIBuyClothes.object[18].setPosition(164.0, 156.0, false);
GUIBuyClothes.object[19] = GUIButton();
GUIBuyClothes.object[19].setText("X");
GUIBuyClothes.object[19].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[19].setVisible(true);
GUIBuyClothes.object[19].setSize(28.0, 28.0, false);
GUIBuyClothes.object[19].setPosition(193.0, 156.0, false);
GUIBuyClothes.object[20] = GUIText();
GUIBuyClothes.object[20].setText("Куртка");
GUIBuyClothes.object[20].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[20].setVisible(true);
GUIBuyClothes.object[20].setSize(100.0, 15.0, false);
GUIBuyClothes.object[20].setPosition(9.5, 153.0, false);
GUIBuyClothes.object[21] = GUIButton();
GUIBuyClothes.object[21].setText("<");
GUIBuyClothes.object[21].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[21].setVisible(true);
GUIBuyClothes.object[21].setSize(28.0, 28.0, false);
GUIBuyClothes.object[21].setPosition(135.0, 187.0, false);
GUIBuyClothes.object[22] = GUIButton();
GUIBuyClothes.object[22].setText(">");
GUIBuyClothes.object[22].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[22].setVisible(true);
GUIBuyClothes.object[22].setSize(28.0, 28.0, false);
GUIBuyClothes.object[22].setPosition(164.0, 187.0, false);
GUIBuyClothes.object[23] = GUIButton();
GUIBuyClothes.object[23].setText("X");
GUIBuyClothes.object[23].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[23].setVisible(true);
GUIBuyClothes.object[23].setSize(28.0, 28.0, false);
GUIBuyClothes.object[23].setPosition(193.0, 187.0, false);
GUIBuyClothes.object[24] = GUIText();
GUIBuyClothes.object[24].setText("Волосы");
GUIBuyClothes.object[24].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[24].setVisible(true);
GUIBuyClothes.object[24].setSize(100.0, 15.0, false);
GUIBuyClothes.object[24].setPosition(9.5, 182.0, false);
GUIBuyClothes.object[25] = GUIText();
GUIBuyClothes.object[25].setText("Цена: 120$");
GUIBuyClothes.object[25].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[25].setVisible(true);
GUIBuyClothes.object[25].setSize(100.0, 15.0, false);
GUIBuyClothes.object[25].setPosition(7.5, 209.0, false);
GUIBuyClothes.object[26] = GUIText();
GUIBuyClothes.object[26].setText("Итого к оплате: 399$");
GUIBuyClothes.object[26].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[26].setVisible(true);
GUIBuyClothes.object[26].setSize(200.0, 15.0, false);
GUIBuyClothes.object[26].setPosition(7.5, 224.0, false);
GUIBuyClothes.object[27] = GUIButton();
GUIBuyClothes.object[27].setText("Купить");
GUIBuyClothes.object[27].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[27].setVisible(true);
GUIBuyClothes.object[27].setSize(70.0, 28.0, false);
GUIBuyClothes.object[27].setPosition(13.0, 248.0, false);
GUIBuyClothes.object[28] = GUIButton();
GUIBuyClothes.object[28].setText("Отменить");
GUIBuyClothes.object[28].setParent(GUIBuyClothes.window.getName());
GUIBuyClothes.object[28].setVisible(true);
GUIBuyClothes.object[28].setSize(90.0, 28.0, false);
GUIBuyClothes.object[28].setPosition(87.0, 248.0, false);
GUIBuyClothes.visible <- false;
GUIBuyClothes.allowClose <- true;

function onPlayerSpawn( playerid )
{
    setPlayerDoorLockState (getLocalPlayer(), "cj_mision_door_1", -126.0, 1500.0, 22.0, true, 0.0 );
    return true;
}
addEvent("playerSpawn", onPlayerSpawn);

function onShowCarBuy(show)
{
	CarBuyGUI.window.setVisible(show); 
	guiToggleCursor(show);
}
addEvent("showCarBuy", onShowCarBuy);

function onKeyPress(button, state) 
{
	if(state == "down")
	{
		switch(button)
		{
			case "y":
				triggerServerEvent("yesnoRequest", true);
				break;
			case "n":
				triggerServerEvent("yesnoRequest", false);
				break;
			case "o":
				if(isVehicleValid(getPlayerVehicleId(getLocalPlayer()))) triggerServerEvent("toggleEngine", getPlayerVehicleId(getLocalPlayer()), !getVehicleEngineState(getPlayerVehicleId(getLocalPlayer())));
				break;
			case "h":
				if(isVehicleValid(getPlayerVehicleId(getLocalPlayer()))) triggerServerEvent("toggleLights", getPlayerVehicleId(getLocalPlayer()));
				else triggerServerEvent("enterHouse");
				break;
			case "l":
				if(isVehicleValid(getPlayerVehicleId(getLocalPlayer()))) triggerServerEvent("toggleLocked", getPlayerVehicleId(getLocalPlayer()), getVehicleLocked(getPlayerVehicleId(getLocalPlayer())));
				break;
			case "q":
				if(isVehicleValid(getPlayerVehicleId(getLocalPlayer())))
				{
					if(waitingTurn > 0)
					{
						triggerServerEvent("indicators", 0);
						waitingTurn = 0;
					}
					else
					{
						triggerServerEvent("indicators", 1);
						waitingTurn = 1;
						doneTurn = 0;
					}
				}
				break;
			case "e":
				if(isVehicleValid(getPlayerVehicleId(getLocalPlayer())))
				{
					if(waitingTurn > 0)
					{
						triggerServerEvent("indicators", 0);
						waitingTurn = 0;
					}
					else
					{
						triggerServerEvent("indicators", 2);
						waitingTurn = 2;
						doneTurn = 0;
					}
				}
				break;
			case "z":
				setPlayerDoorLockState(getLocalPlayer(),"cj_bank_door_L",-28.0, -463.0, 16.0, true, 0.0);
				break;
			case "x":
				setPlayerDoorLockState(getLocalPlayer(),"cj_bank_door_L",-28.0, -463.0, 16.0, false, 0.0);
				break;
			case "arrow_right":
				triggerServerEvent("skinChoose", 1);
				break;
			case "arrow_left":
				triggerServerEvent("skinChoose", 2);
				break;
			case "enter":
				triggerServerEvent("skinChoose", 3);
				break;
		}
	}
	return 1;
}
addEvent("keyPress", onKeyPress);

function onGetRegisterInfo(action)
{
	if(action == 1) isRegister = true;
	else isRegister = false;
	LoginRegisterGUI.object[7].setText((isRegister) ? ("Регистрация") : ("Войти"));
	LoginRegisterGUI.window.setVisible(true); 
	guiToggleCursor(true);
	return 1;
}
addEvent("getRegisterInfo", onGetRegisterInfo);

function onGetRequest(request)
{
	if(request)
	{
		LoginRegisterGUI.window.setVisible(false); 
		guiToggleCursor(false);
	}
	return 1;
}
addEvent("getRequest", onGetRequest);

function onWindowClose(windowName)
{
	if(windowName == CarBuyGUI.window.getName()) 
	{
		triggerServerEvent("freezeMe", false);
		CarBuyGUI.window.setVisible(false); 
		guiToggleCursor(false);
	}
	else if(windowName == GUIBuyClothes.window.getName()) 
	{
		triggerServerEvent("freezeMe", false);
		GUIBuyClothes.window.setVisible(false); 
		guiToggleCursor(false);
	}
}
addEvent("windowClose",onWindowClose);

addEvent("buttonClick",
    function(buttonName, bState)
    {
        if(buttonName == CarBuyGUI.object[0].getName())
        {
			if(carModel == 0) carModel = 123;
			else carModel--;
			CarBuyGUI.object[4].setText("Model: "+getVehicleName(carModel)+"");
			CarBuyGUI.object[3].setText("ID: "+carModel+"");
			CarIMG[last].setVisible(false);
			CarIMG[carModel].setVisible(true);
			last = carModel;
        }
        else if(buttonName == CarBuyGUI.object[1].getName())
        {
			if(carModel == 123) carModel = 0;
			else carModel++;
			CarBuyGUI.object[4].setText("Model: "+getVehicleName(carModel)+"");
			CarBuyGUI.object[3].setText("ID: "+carModel+"");
			CarIMG[last].setVisible(false);
			CarIMG[carModel].setVisible(true);
			last = carModel;
        }
        else if(buttonName == CarBuyGUI.object[6].getName())
        {
        	local model = CarBuyGUI.object[5].getText().tointeger();
			if(model < 0 || model > 123) {}
			else carModel=model;
			CarBuyGUI.object[4].setText("Model: "+getVehicleName(carModel)+"");
			CarBuyGUI.object[3].setText("ID: "+carModel+"");
			CarIMG[last].setVisible(false);
			CarIMG[carModel].setVisible(true);
			last = carModel;
        }
        else if(buttonName == CarBuyGUI.object[22].getName())
        {
			if(CarBuyGUI.object[16].getText().tointeger() < 0 || CarBuyGUI.object[16].getText().tointeger() > 136) addChatMessage("Ошибка: [FF0000AA]Неверный цвет (0-136).", 0xFFFFFFFF, true);
			else if(CarBuyGUI.object[17].getText().tointeger() < 0 || CarBuyGUI.object[16].getText().tointeger() > 136) addChatMessage("Ошибка: [FF0000AA]Неверный цвет (0-136).", 0xFFFFFFFF, true);
			else if(CarBuyGUI.object[20].getText().tointeger() < 0 || CarBuyGUI.object[16].getText().tointeger() > 136) addChatMessage("Ошибка: [FF0000AA]Неверный цвет (0-136).", 0xFFFFFFFF, true);
			else if(CarBuyGUI.object[21].getText().tointeger() < 0 || CarBuyGUI.object[16].getText().tointeger() > 136) addChatMessage("Ошибка: [FF0000AA]Неверный цвет (0-136).", 0xFFFFFFFF, true);
        	else 
			{
				triggerServerEvent("buyCar", carModel, CarBuyGUI.object[16].getText().tointeger(),  CarBuyGUI.object[17].getText().tointeger(), CarBuyGUI.object[20].getText().tointeger(), CarBuyGUI.object[21].getText().tointeger());
				CarBuyGUI.window.setVisible(false); 
				guiToggleCursor(false);
				CarBuyGUI.object[16].setText("");
				CarBuyGUI.object[17].setText("");
				CarBuyGUI.object[20].setText("");
				CarBuyGUI.object[21].setText("");
				triggerServerEvent("freezeMe", false);
			}
        }
        else if(buttonName == CarBuyGUI.object[23].getName())
        {
        	CarBuyGUI.window.setVisible(false); 
			guiToggleCursor(false);
			triggerServerEvent("freezeMe", false);
        }
		else if(buttonName == LoginRegisterGUI.object[7].getName())
		{
			if(isRegister) triggerServerEvent("playerRegister", LoginRegisterGUI.object[5].getText());
			else triggerServerEvent("playerLogin", LoginRegisterGUI.object[5].getText());
		}
		for(local i = 0; i < 6; i++)
		{
			if(buttonName == GUIBuyClothes.object[1+(i*4)].getName())
			{
				if(i <= 2)
				{
					if(ClothChange[i] == 0) ClothChange[i] = 30;
					else ClothChange[i]--;
					triggerServerEvent("changeMyClothes", i, ClothChange[i]);
					addChatMessage("OnBuy: "+i+". < Buttonname: "+buttonName+". ClothChange[i]: "+ClothChange[i]);
				}
				else
				{
					if(ClothChange[i+2] == 0) ClothChange[i+2] = 30;
					else ClothChange[i+2]--;
					triggerServerEvent("changeMyClothes", i+2, ClothChange[i+2]);
					addChatMessage("OnBuy: "+i+". < Buttonname: "+buttonName+". ClothChange[i+2]: "+ClothChange[i+2]);
				}
			}
			else if(buttonName == GUIBuyClothes.object[2+(i*4)].getName())
			{
				if(i <= 2)
				{
					if(ClothChange[i] == 30) ClothChange[i] = 0;
					else ClothChange[i]++;
					triggerServerEvent("changeMyClothes", i, ClothChange[i]);
					addChatMessage("OnBuy: "+i+". > Buttonname: "+buttonName+". ClothChange[i]: "+ClothChange[i]);
				}
				else
				{
					if(ClothChange[i+2] == 30) ClothChange[i+2] = 0;
					else ClothChange[i+2]++;
					triggerServerEvent("changeMyClothes", i+2, ClothChange[i+2]);
					addChatMessage("OnBuy: "+i+". > Buttonname: "+buttonName+". ClothChange[i+2]: "+ClothChange[i+2]);
				}
			}
			else if(buttonName == GUIBuyClothes.object[3+(i*4)].getName())
			{
				if(i <= 2)
				{
					ClothChange[i] = Clothes[i];
					triggerServerEvent("changeMyClothes", i, Clothes[i]);
					addChatMessage("OnBuy: "+i+". X Buttonname: "+buttonName+". ClothChange[i]: "+ClothChange[i]);
				}
				else
				{
					ClothChange[i+2] = Clothes[i+2];
					triggerServerEvent("changeMyClothes", i+2, Clothes[i+2]);
					addChatMessage("OnBuy: "+i+". X Buttonname: "+buttonName+". ClothChange[i+2]: "+ClothChange[i+2]);
				}
			}
		}
    });
    
local speedBck = GUIImage("dt-1.png");
local fueldata = 0;
speedBck.setPosition(screen[0]-318, screen[1]-268, false);
speedBck.setVisible(false);
speedBck.setSize(229.0, 229.0, false);
 
local speedPin = GUIImage("st-1.png");
speedPin.setPosition(screen[0]-318, screen[1]-268, false);
speedPin.setVisible(false);
speedPin.setSize(229.0, 229.0, false);
   
addEvent("updatefueldata", function(data) {
 fueldata = data;
}); 
     
function getVehicleSpeed()
{
	local vehid = getPlayerVehicleId(getLocalPlayer()).tointeger()
	if(isVehicleValid(vehid)) 
	{
		local velocity = getVehicleVelocity(vehid);
		local x = velocity[0];
		local y = velocity[1];
		local v = sqrt(x*x + y*y);
		v = v*10/2.755;
		return v.tointeger();
	}
	else return 0;
}

function onOpenSkinShop(clothes)
{
	triggerServerEvent("freezeMe", true);
	Clothes = clothes;
	ClothChange = clothes;
	GUIBuyClothes.window.setVisible(true);
	guiToggleCursor(true);
}
addEvent("openSkinShop", onOpenSkinShop);
      
function onFrameRender() 
{
	//#Indicators#//
	if(waitingTurn > 0 || doneTurn > 0)
	{
		local pad = getPlayerPadState(getLocalPlayer());
		local left = pad.inVehicleMove[0];
		local right = pad.inVehicleMove[1];

		if(waitingTurn > 0)
		{
			// waiting to turn left?
			if(waitingTurn == 1 && left > 128)
			{
				doneTurn = 1;
				waitingTurn = 0;
			}
			// waiting to turn right?
			else if(waitingTurn == 2 && right > 128)
			{
				doneTurn = 2;
				waitingTurn = 0;
			}
		}
		else if(doneTurn > 0)
		{
			// waiting to stop turning left?
			if(doneTurn == 1 && left == 128)
			{
				triggerServerEvent("indicators", 0);
				doneTurn = 0;
			}
			// waiting to stop turning right?
			else if(doneTurn == 2 && right == 128)
			{
				triggerServerEvent("indicators", 0);
				doneTurn = 0;
			}
		}
	}
	//#Speed#//
	if(!isPlayerOnFoot(getLocalPlayer())) 
	{
		speedBck.setVisible(true);
		speedPin.setVisible(true);
		local speed = getVehicleSpeed();
		if(speed > 260.0) speed = 260.0;
		speedPin.setRotation(0.0, 0.0, speed+1.0);                          
	} 
	else 
	{
		speedBck.setVisible(false);
		speedPin.setVisible(false);
	}
}
addEvent("frameRender", onFrameRender);