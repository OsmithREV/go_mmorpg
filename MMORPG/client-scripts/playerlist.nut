local LIST = {
	x = 2596,
	y = 1000,
	width = 3000,
	height = 6200,
	offset = 50,
}

local PLAYER_PER_PAGE = 30;

class PlayerListItem
{
	constructor(id, ping)
	{
		local color = getPlayerColor(id);
		
		m_Id = id;
		
		m_DrawId = createDraw(format("%i", id), "FONT_OLD_10_WHITE_HI.TGA", 0, 0, color.r, color.g, color.b);
		m_DrawName = createDraw(getPlayerName(id), "FONT_OLD_10_WHITE_HI.TGA", 0, 0, color.r, color.g, color.b);
		m_DrawPing = createDraw(format("%i", ping), "FONT_OLD_10_WHITE_HI.TGA", 0, 0, color.r, color.g, color.b);
	}
	
	function destroy()
	{
		destroyDraw(m_DrawId);
		destroyDraw(m_DrawName);
		destroyDraw(m_DrawPing);
	}
	
	function show(y)
	{
		setDrawPosition(m_DrawId, LIST.x + LIST.offset, y);
		setDrawPosition(m_DrawName, LIST.x + LIST.offset + 300, y);
		setDrawPosition(m_DrawPing, LIST.x + LIST.offset + LIST.width - 450, y);
	
		setDrawVisible(m_DrawId, true);
		setDrawVisible(m_DrawName, true);
		setDrawVisible(m_DrawPing, true);
	}
	
	function hide()
	{
		setDrawVisible(m_DrawId, false);
		setDrawVisible(m_DrawName, false);
		setDrawVisible(m_DrawPing, false);
	}
	
	function updatePing(ping)
	{
		setDrawText(m_DrawPing, format("%i", ping));
	}
	
	function updateName(name)
	{
		setDrawText(m_DrawName, name);
	}
	
	function updateColor(r, g, b)
	{
		setDrawColor(m_DrawId, r, g, b);
		setDrawColor(m_DrawName, r, g, b);
		setDrawColor(m_DrawPing, r, g, b);
	}
	
	m_Id = -1;
	m_DrawId = -1;
	m_DrawName = -1;
	m_DrawPing = -1;
}

class PlayerList
{
	constructor()
	{
		m_isShowed = false;
		m_CurrPage = 1;
		m_MaxPages = 1;
		m_Size = 0;
		m_List = [];
		
		m_DrawId = createDraw("ID", "FONT_OLD_10_WHITE_HI.TGA", LIST.x + LIST.offset, LIST.y + LIST.offset, 255, 255, 0);
		m_DrawName = createDraw("Name", "FONT_OLD_10_WHITE_HI.TGA", LIST.x + LIST.offset + 300, LIST.y + LIST.offset, 255, 255, 0);
		m_DrawPing = createDraw("Ping", "FONT_OLD_10_WHITE_HI.TGA", LIST.x + LIST.offset + LIST.width - 450, LIST.y + LIST.offset, 255, 255, 0);
		
		m_TexBg = createTexture(LIST.x, LIST.y, LIST.width, LIST.height, "DLG_CONVERSATION.TGA");
		setTextureVisible(m_TexBg, false);
	}

	function toggle()
	{
		m_isShowed ? hide() : show();
	}
	
	function show()
	{
		setDrawVisible(m_DrawId, true);
		setDrawVisible(m_DrawName, true);
		setDrawVisible(m_DrawPing, true);
		setTextureVisible(m_TexBg, true);
	
		local y = LIST.y + 200;
		
		local begin = m_CurrPage * PLAYER_PER_PAGE - PLAYER_PER_PAGE;
		local end = m_CurrPage * PLAYER_PER_PAGE > m_Size ? m_Size : m_CurrPage * PLAYER_PER_PAGE;

		for (local i = begin; i < end; ++i)
		{
			m_List[i].show(y);
			y += 200;
		}
		
		m_isShowed = true;
	}
	
	function hide()
	{
		setDrawVisible(m_DrawId, false);
		setDrawVisible(m_DrawName, false);
		setDrawVisible(m_DrawPing, false);
		setTextureVisible(m_TexBg, false);
	
		foreach (player in m_List)
			player.hide();
			
		m_isShowed = false;
	}

	function insert(pid, ping)
	{
		m_List.append(PlayerListItem(pid, ping));
		
		m_List.sort(function(first, second)
		{
			if (first.m_Id > second.m_Id) return 1;
			if (first.m_Id < second.m_Id) return -1;
			return 0;
		});

		++m_Size;
		
		local pages = m_Size / PLAYER_PER_PAGE;
		
		if (pages % PLAYER_PER_PAGE == 0)
			m_MaxPages = pages;
		else
			m_MaxPages = pages + 1;
	}
	
	function remove(pid)
	{
		local index = null;
		foreach (id, player in m_List)
			if (player.m_Id == pid)
			{
				player.destroy();
				index = id;
			}		
				
		if (index != null)
		{
			m_List.remove(index);
			--m_Size;
		}
	}
	
	function switchPage(toggle)
	{
		if (m_isShowed)
		{
			m_CurrPage += toggle;
			
			if (m_CurrPage < 1) m_CurrPage = 1;
			if (m_CurrPage > m_MaxPages) m_CurrPage = m_MaxPages;
		
			hide();
			show();
		}
	}
	
	function updatePing(pid, ping)
	{
		foreach (player in m_List)
			if (player.m_Id == pid)
				player.updatePing(ping);
	}
	
	function updateName(pid, name)
	{
		foreach (player in m_List)
			if (player.m_Id == pid)
				player.updateName(name);
	}
	
	function updateColor(pid, r, g, b)
	{
		foreach (player in m_List)
			if (player.m_Id == pid)
				player.updateColor(r, g, b);
	}
	
	m_List = null;
	m_TexBg = null;
	m_isShowed = false;
	m_DrawId = -1;
	m_DrawName = -1;
	m_DrawPing = -1;
	m_CurrPage = -1;
	m_Size = -1;
	m_MaxPages = -1;
}

local playerList = PlayerList();

addEvent("onPlayerCreated", function(pid, ping)
{
	playerList.insert(pid, ping);
});

addEvent("onPlayerDestroyed", function(pid)
{
	playerList.remove(pid);
});

addEvent("onPlayerChangeName", function(pid, name)
{
	playerList.updateName(pid, name);
});

addEvent("onPlayerChangeColor", function(pid, r, g, b)
{
	playerList.updateColor(pid, r, g, b);
});

addEvent("onPing", function(pid, ping)
{
	playerList.updatePing(pid, ping);
});

addEvent("onKey", function(key, letter)
{
	switch (key)
	{
	case KEY_F5:
		playerList.toggle();
		break;
		
	case KEY_I:
		playerList.switchPage(1);
		break;
		
	case KEY_U:
		playerList.switchPage(-1);
		break;
	}
});