/*
 * Copyright (C) 2011-2025 MicroSIP (http://www.microsip.org)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#pragma once

#include "const.h"

#define _GLOBAL_DPI
#define _GLOBAL_DTLS

#define STR_SZ 256

#define _GLOBAL_WIDTH 162

//#ifndef _GLOBAL_RINGIN_WIDTH
#define _GLOBAL_RINGIN_WIDTH 180
//#endif

#define _GLOBAL_DIALER_WIDTH 162

#define _GLOBAL_ICON "res\\microsip.ico"
#define _GLOBAL_ICON_INACTIVE "res\\tray_inactive.ico"

#define _GLOBAL_HEIGHT1 0
#define _GLOBAL_HEIGHT2 _GLOBAL_HEIGHT1+16

#define _GLOBAL_HEIGHT3 _GLOBAL_HEIGHT2+23

#define _GLOBAL_HEIGHT4 _GLOBAL_HEIGHT3

#define _GLOBAL_HEIGHT_FINAL _GLOBAL_HEIGHT4

#define _GLOBAL_HEIGHT 192 + _GLOBAL_HEIGHT_FINAL

#define _GLOBAL_TAB_WIDTH 47

#define _GLOBAL_ACCT_OFFSET_LEFT 0

#define IDD_CALLS_OFFSET_INITIAL _GLOBAL_HEIGHT - 17
#define IDD_CALLS_OFFSET_LISTVIEW1 IDD_CALLS_OFFSET_INITIAL
#define IDD_CALLS_OFFSET_LISTVIEW2 IDD_CALLS_OFFSET_LISTVIEW1

#define IDD_CALLS_OFFSET_LISTVIEW IDD_CALLS_OFFSET_LISTVIEW2+2


#define _GLOBAL_CODECS_ENABLED "PCMA/8000/1 PCMU/8000/1"

#define _GLOBAL_SETT_DENYINC_DEFAULT "button"
#define _GLOBAL_SETT_AA_DEFAULT "button"

#define _GLOBAL_BUSINESS_FEATURE "This feature is not available in the free version."
#define _GLOBAL_MENU_WEBSITE "https://www.microsip.org/"
#define _GLOBAL_MENU_HELP "https://www.microsip.org/help"
#define _GLOBAL_HELP_WEBSITE "https://www.microsip.org/help"
#define _GLOBAL_URL_CHECK_VERSION "https://www.microsip.org/check-version?ver="

#define _GLOBAL_EC_DEFAULT "1"

#define _GLOBAL_NAME_NICE _GLOBAL_NAME

#define _GLOBAL_NAME_VISIBLE _GLOBAL_NAME_NICE

#define _GLOBAL_CALL_PICKUP "**"

#define _GLOBAL_SHORTCUTS
#define _GLOBAL_SHORTCUTS_QTY 8

#define MACRO_ENABLE_LOCAL_ACCOUNT (accountSettings.enableLocalAccount || !accountSettings.accountId)

#define _GLOBAL_SUBSCRIBE

#ifndef LVS_EX_AUTOSIZECOLUMNS
#define LVS_EX_AUTOSIZECOLUMNS 0x10000000
#endif

#define _GLOBAL_FEATURE_CODES_CP_DEFAULT "**"
#define _GLOBAL_FEATURE_CODES_CP_ENABLE 1

#define _GLOBAL_DIALER_CALL_COLOR RGB(76, 217, 100)
#define _GLOBAL_DIALER_END_COLOR RGB(255, 59, 48)

// ---------------------------------------------------------------------------
// Login simplificado: valores PADRAO da conta SIP (pre-preenchidos e travados).
// O usuario so edita Usuario (username), Login (authID) e Senha (password).
// Altere os valores abaixo conforme o seu PBX antes de compilar.
// ---------------------------------------------------------------------------
#define _GLOBAL_ACC_LABEL              "G4F"
#define _GLOBAL_ACC_SERVER             "g4f.advancetelecom.com.br:21225"
#define _GLOBAL_ACC_PROXY              "g4f.advancetelecom.com.br:21225"
#define _GLOBAL_ACC_DOMAIN             "g4f.advancetelecom.com.br:21225"
#define _GLOBAL_ACC_SRTP               ""   // "" = Desabilitado
#define _GLOBAL_ACC_TRANSPORT          ""   // "" = UDP+TCP
#define _GLOBAL_ACC_PUBLIC_ADDR        ""   // "" = Auto
#define _GLOBAL_ACC_REGISTER_REFRESH   30
#define _GLOBAL_ACC_KEEP_ALIVE         15
#define _GLOBAL_ACC_PUBLISH            false
#define _GLOBAL_ACC_REWRITE            true
#define _GLOBAL_ACC_ICE                false
#define _GLOBAL_ACC_DISABLE_SESS_TIMER false
