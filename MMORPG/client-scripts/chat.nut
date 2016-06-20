local CHAT_MAX_LINES = 10;
local CHAT_MAX_LINES = 10;
local FREEZE_STATUS = false;

class ChatLinePlayer
{
	constructor(pid, message)
	{
		m_FadeOut = true;
		m_Alpha = 0;
		m_Color = getPlayerColor(pid);
		m_Position = { x = 0, y = 0 };
		
		local name = getPlayerName(pid);
		local resolution = getResolution();
		
		m_Position.x = (8192.0 / resolution.width) * getTextWidth("FONT_OLD_10_WHITE_HI.TGA", name) + 80;
		m_Position.y = 0;
		
		m_DrawName = createDraw(name + ":", "FONT_OLD_10_WHITE_HI.TGA", 50, 0, m_Color.r, m_Color.g, m_Color.b, 0);
		m_DrawMessage = createDraw(message, "FONT_OLD_10_WHITE_HI.TGA", 50 + m_Position.x, 0, 255, 255, 255, 0);
	}
	
	function destroy()
	{
		destroyDraw(m_DrawName);
		destroyDraw(m_DrawMessage);
	}
	
	function show()
	{
		setDrawVisible(m_DrawName, true);
		setDrawVisible(m_DrawMessage, true);
	}
	
	function hide()
	{
		setDrawVisible(m_DrawName, false);
		setDrawVisible(m_DrawMessage, false);
	}
	
	function update(y)
	{
		m_Position.y = y;
	
		setDrawPosition(m_DrawName, 50, y);
		setDrawPosition(m_DrawMessage, 50 + m_Position.x, y);
	}
	
	function fadeOut()
	{
		if (m_FadeOut)
		{
			m_Alpha += 30;
			
			if (m_Alpha > 255)
			{
				m_Alpha = 255;
				m_FadeOut = false;
			}

			setDrawColor(m_DrawName, m_Color.r, m_Color.g, m_Color.b, m_Alpha);
			setDrawColor(m_DrawMessage, 255, 255, 255, m_Alpha);
		}
	}
	
	function move(offset)
	{
		m_Position.y -= offset;
	
		setDrawPosition(m_DrawName, 50, m_Position.y);
		setDrawPosition(m_DrawMessage, 50 + m_Position.x, m_Position.y);
	}
	
	m_Color = null;
	m_Position = null;
	m_FadeOut = false;
	m_Alpha = 0;
	m_DrawName = -1;
	m_DrawMessage = -1;
}

class ChatLineServer
{
	constructor(message, r, g, b)
	{
		m_FadeOut = true;
		m_Alpha = 0;
		m_Color = { r = r, g = g, b = b};
		m_PositionY = 0;
		
		m_DrawMessage = createDraw(message, "FONT_OLD_10_WHITE_HI.TGA", 50, 0, r, g, b, 0);
	}
	
	function destroy()
	{
		destroyDraw(m_DrawMessage);
	}
	
	function show()
	{
		setDrawVisible(m_DrawMessage, true);
	}
	
	function hide()
	{
		setDrawVisible(m_DrawMessage, false);
	}
	
	function update(y)
	{
		m_PositionY = y;
	
		setDrawPosition(m_DrawMessage, 50, m_PositionY);
	}
	
	function fadeOut()
	{
		if (m_FadeOut)
		{
			m_Alpha += 30;
			
			if (m_Alpha > 255)
			{
				m_Alpha = 255;
				m_FadeOut = false;
			}

			setDrawColor(m_DrawMessage, m_Color.r, m_Color.g, m_Color.b, m_Alpha);
		}
	}
	
	function move(offset)
	{
		m_PositionY -= offset;
	
		setDrawPosition(m_DrawMessage, 50, m_PositionY);
	}
	
	m_Color = null;
	m_PositionY = -1;
	m_FadeOut = false;
	m_Alpha = 0;
	m_DrawMessage = -1;
}

class Chat
{
	constructor(lines)
	{
		m_MaxLines = lines;
		m_isShowed = true;
		m_Update = false;
		m_OffsetMove = 0;
		m_Lines = [];
		
		setTimer(function(chat)
		{
			if (chat.m_OffsetMove)
			{
				chat.m_OffsetMove -= 40;
				if (chat.m_OffsetMove < 0) chat.m_OffsetMove = 0;

				foreach (line in chat.m_Lines)
					line.move(40);
			}
			else if (chat.m_Queue.len() > 0)
			{
				chat.m_Lines.append(chat.m_Queue[0]);
				chat.update();
				chat.m_Queue.remove(0);
			}
				
			foreach (line in chat.m_Lines)
				line.fadeOut();
		}, 30, true, this);
		
		chatInputPosition(50, lines * 200 + 50);
	}
	
	function open()
	{
		clearChatInput();
		chatInputToggle(true);
		
		FREEZE_STATUS = isFrozen();
		setFreeze(true);
	}
	
	function send()
	{
		chatInputSend();
		
		if (!FREEZE_STATUS)
			setFreeze(false);
	}
	
	function close()
	{
		chatInputToggle(false);
		
		if (!FREEZE_STATUS)
			setFreeze(false);
	}
	
	function show()
	{
		foreach (line in m_Lines)
			line.show();
			
		m_isShowed = true;
	}
	
	function hide()
	{
		foreach (line in m_Lines)
			line.hide();
			
		m_isShowed = false;
	}
	
	function update()
	{
		local size = m_Lines.len();
		if (size > m_MaxLines)
		{
			m_Lines[0].destroy();
			m_Lines.remove(0);
			
			m_OffsetMove += 200;
		}

		m_Lines.top().update((size - 1) * 200);
		if (m_isShowed) show();
	}
	
	function playerMessage(pid, message)
	{
		m_Queue.append(ChatLinePlayer(pid, message));
	}
	
	function serverMessage(message, r, g, b)
	{
		m_Queue.append(ChatLineServer(message, r, g, b));
	}
	
	function clear()
	{
		m_Queue.clear();
		
		foreach (line in m_Lines)
			line.destroy();
			
		m_Lines.clear();
	}
	
	m_isShowed = false;
	m_Update = false;
	m_OffsetMove = -1;
	m_MaxLines = -1;
	m_Lines = [];
	m_Queue = [];
}

// old chat function
function addMessage(r, g, b, message)
{
	globalChat.serverMessage(message, r, g, b);
}

function showChat(toggle)
{
	toggle ? globalChat.show() : globalChat.hide();
}

function clearChat()
{
	globalChat.clear();
}

globalChat <- Chat(CHAT_MAX_LINES);
globalChat.show();

addEvent("onMessage", function(pid, message, r, g, b)
{
	if (pid == -1)
		globalChat.serverMessage(message, r, g, b);
});

addEvent("onKey", function(key, letter)
{
	if (isChatInputOpen())
	{
		playGesticulation();
		
		if (key == KEY_RETURN)
			globalChat.send();
		else if (key == KEY_ESCAPE)
			globalChat.close();
	}
	else if (key == KEY_T)
	{
		globalMultiStats.hide();
		globalChat.open();
	}
});