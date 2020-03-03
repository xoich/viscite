local function keycode(code, shift, ctrl, alt)
	return ((shift and 1 or 0) << 2) | ((ctrl and 1 or 0) << 1) | (alt and 1 or 0)
		| (code << 3)
end

local function keych(ch, shift, ctrl, alt)
	return keycode(string.byte(ch), shift, ctrl, alt)
end

local function iMode()
	editor.CaretStyle = 1
	OnKey = imapOnKey
end

local function nMode()
	editor.CaretStyle = 2
	OnKey = nmapOnKey
end

local function OnKeyFromMap(map)
	OnKey = function (key, s, c, a)
		local act = map[keycode(key, s, c, a)]
		if act then
			local morekeys = false
			if type(act) == "string" then
				morekeys = editor[act](editor)
			else
				act()
			end
			if not morekeys then nMode() end
		else
			print "Keybinding not found"
			nMode()
		end
		return true
	end
end

imap = {
	[keych('h', false, true)] = "DeleteBack",
	[keych('[', false, true)] = nMode,
	[keych('m', false, true)] = "NewLine",
	[keych('w', false, true)] = "DelWordLeft",
	[keycode(65307)] = nMode
}

local dmap = {
	[keych'w'] = function() editor:DelWordRight() end,
	[keych'd'] = function() editor:LineDelete() end
}

nmap = {
	[keych'd'] = function() OnKeyFromMap(dmap) end,
	[keych'g'] = function () OnKeyFromMap({[keych'g'] = "DocumentStart"}) end,
	[keych('G', true)] = "DocumentEnd",
	[keych'0'] = "HomeDisplay",
	[keych'k'] = "LineUp", 
	[keych'j'] = "LineDown", 
	[keych'b'] = "WordLeft", 
	[keych'w'] = "WordRight", 
	[keych'e'] = "WordRightEnd",
	[keych'p'] = "Paste", 
	[keych('$', true, false)] = "LineEnd",
	[keych'h'] = "CharLeft",
	[keych'l'] = "CharRight",
	[keych'u'] = "Undo",
	[keych('r',false, true)] = "Redo",
	[keych('d',false, true)] = "PageDown",
	[keych('u',false, true)] = "PageUp",
	[keych('S', true)] = function() scite.MenuCommand(IDM_SAVE) end,
	[keych'o'] = function() editor:LineEnd() editor:NewLine() iMode() end,
	[keych('A', true)] = function() editor:LineEnd() iMode() end,
	[keych'a'] = function() editor:CharRight() iMode() end,
	[keych'x'] = function() editor:CharRight() editor:DeleteBack() end,
	[keych'i'] = function() iMode() end
}

function nmapOnKey(key, shift, ctrl, alt)
	local act = nmap[keycode(key, shift, ctrl, alt)]
	if act then
		if type(act) == "string" then
			editor[act](editor)
		else
			act()
		end
		return true
	end
	print(key, shift, ctrl, alt)
	return true
end

function imapOnKey(key, shift, ctrl, alt)
	local act = imap[keycode(key, shift, ctrl, alt)]
	if act then
		if type(act) == "string" then
			editor[act](editor)
		else
			act()
		end
		return true
	end
	return false
end

OnKey = nmapOnKey

