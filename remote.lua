local kb = require("keyboard");
local win = libs.win;
local ms = libs.mouse;

-- Native Windows Stuff
local ffi = require("ffi");
ffi.cdef[[
bool LockWorkStation();
int ExitWindowsEx(int uFlags, int dwReason);
bool SetSuspendState(bool hibernate, bool forceCritical, bool disableWakeEvent);
]]
local PowrProf = ffi.load("PowrProf");

--@help Put system in sleep state
actions.sleep = function ()
	actions.pc_screen();
	PowrProf.SetSuspendState(false, true, false);
end

--@help Change screen
actions.pc_screen = function ()
	set_primary_screen();
	
	win.close("kodi.exe");
	win.close("steam.exe");
	os.start("taskkill.exe /F /IM steam.exe");
	os.start("taskkill.exe /F /IM kodi.exe");
	os.sleep (2000);
end

--@help Force system shutdown
--@param sec:number Timeout in seconds (default 5)
actions.shutdown = function ()
	actions.pc_screen();

	if not sec then sec = 5; end
	os.execute("shutdown /s /f /t " .. sec);
end

--@help Change screen
actions.kodi_screen = function ()
	set_expand_screen();
	set_secondary_screen();

	os.start("C:/Program Files (x86)/Kodi/kodi.exe");
	os.sleep (6000);
	
	ms.moveto(0,0);
    ms.click();
end

--@help Change screen
actions.steam_screen = function ()
	set_expand_screen();
	set_secondary_screen();

	os.sleep (2000);
	os.start("C:/Program Files (x86)/Steam/Steam.exe -bigpicture");
end

--@help Launch Kodi application
actions.launch = function()
	if OS_WINDOWS then
		os.start("%programfiles(x86)%\\Kodi\\Kodi.exe"); 
	elseif OS_OSX then
		os.script("tell application \"Kodi\" to activate");
	end
end

--@help Focus Kodi application
actions.switch = function()
	set_expand_screen();
	set_secondary_screen();
	
	if OS_WINDOWS then
		local hwnd = win.window("Kodi.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("Kodi.exe");
	end
end

set_secondary_screen = function ()
	kb.stroke("lwin", "p");
    os.sleep (500);
    kb.stroke("end");
	os.sleep (500);
	kb.stroke("return");
	os.sleep (500);
	kb.stroke("esc");
	os.sleep (1000);
end

set_primary_screen = function ()
	kb.stroke("lwin", "p");
    os.sleep (500);
    kb.stroke("home");
	os.sleep (500);
	kb.stroke("return");
	os.sleep (500);
	kb.stroke("esc");
	os.sleep (1000);
end

set_expand_screen = function ()
	kb.stroke("lwin", "p");
    os.sleep (500);
    kb.stroke("end");
	os.sleep (500);
	kb.stroke("up");
	os.sleep (500);
	kb.stroke("return");
	os.sleep (1000);
end

--@help Start playback
actions.play = function()
	actions.switch();
	kb.stroke("space");
end