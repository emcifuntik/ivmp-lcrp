/*
 *	Copyright (C) 2011 Alex009
 *	License read in license.txt
 *	Description: Player SA-MP server class
 */

#pragma once

#include "packets.h"
#include "defines.h"

#pragma pack(push)
#pragma pack(1)

class CPlayer
{
public:
	CPlayer();
	~CPlayer();
	
	// vars
	float				Position[3];			// 0x0
	float				Health;					// 0xC
	float				Armour;					// 0x10
	unsigned char		unk_1[0x10];			// 0x14
	float				Angle;					// 0x24
	unsigned char		unk_2[0x16];			// 0x28
	unsigned long		SyncType;				// 0x3E
	Packet_Foot			FootSync;				// 0x42
	Packet_InCar		InCarSync;				// 0x86
	Packet_Passanger	PassangerSync;			// 0xC5
	Packet_Aim			AimSync;				// 0xDD
	unsigned char		unk_3[0xAD];			// 0xFC
	unsigned long		AimSyncSendState;		// 0x1A9
	unsigned char		unk_4[0x8];				// 0x1AD
	unsigned char		State;					// 0x1B5
	unsigned char		unk_5[0x39];			// 0x1B6
	unsigned char		IsStreamed[MAX_PLAYERS];// 0x1EF
	unsigned char		unk_6[0x1588];			// 0x3E3
	unsigned short		WeaponSkill[11];		// 0x196B
	unsigned char		unk_7[0x5];				// 0x1981
	unsigned long		Skin;					// 0x1986
	unsigned char		unk_8[0x2F];			// 0x198A
	unsigned char		VehicleSeat;			// 0x19B9
	unsigned short		VehicleId;				// 0x19BA
	unsigned char		unk_9[0x3C];			// 0x198C
	unsigned long		Interior;				// 0x19C8
};

#pragma pack(pop)