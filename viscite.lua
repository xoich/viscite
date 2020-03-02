state = 'n'

local function key(code, shift, ctrl, alt)
	local mod = ((shift and 1 or 0) << 2) | ((ctrl and 1 or 0) << 1) | (alt and 1 or 0)
	if type(code) == "string" then code = string.byte(code) end
	return (code << 3) | mod
end

nmap = {
	[key'0'] = "HomeDisplay",
	[key'k'] = "LineUp", 
	[key'j'] = "LineDown", 
	[key'b'] = "WordLeft", 
	[key'w'] = "WordRight", 
	[key'p'] = "Paste", 
	[key'$'] = "LineEnd",
	[key'h'] = "CharLeft",
	[key'l'] = "CharRight",
	[key'u'] = "Undo",
	[key('r',false, true)] = "Redo",
	[key('d',false, true)] = "PageDown",
	[key('u',false, true)] = "PageUp",
	[key'i'] = function() OnKey = imapOnKey end
}

function nmapOnKey(key, shift, ctrl, alt)
	local mod = ((shift and 1 or 0) << 2) | ((ctrl and 1 or 0) << 1) | (alt and 1 or 0)
	local act = nmap[(key << 3) | mod]
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
	if ctrl and key == 91 then
		OnKey = nmapOnKey
		return true
	end
	return false
end

OnKey = nmapOnKey

