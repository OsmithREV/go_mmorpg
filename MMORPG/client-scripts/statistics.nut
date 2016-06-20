class MultiplayerStatistics
{
	constructor()
	{
		local netStats = getNetworkStats();
		
		m_DrawTitle = createDraw("Multiplayer debug", "FONT_OLD_20_WHITE_HI.TGA", 50, 50, 255, 255, 255);
		m_DrawPing = createDraw(format("Ping: %i ms", getPing()), "FONT_OLD_10_WHITE_HI.TGA", 50, 400, 255, 255, 255);
		m_DrawFPS = createDraw(format("FPS: %i", getFPSRate()), "FONT_OLD_10_WHITE_HI.TGA", 50, 600, 255, 255, 255);
		m_DrawReceivecPackets = createDraw(format("Received packet count: %i", netStats.packetReceived), "FONT_OLD_10_WHITE_HI.TGA", 50, 800, 255, 255, 255);
		m_DrawLostPackets = createDraw(format("Lost packet count: %i", netStats.packetlossTotal), "FONT_OLD_10_WHITE_HI.TGA", 50, 1000, 255, 255, 255);
		m_DrawLostPacketsLastSec = createDraw(format("Lost packet in last second count: %i", netStats.packetlossLastSecond), "FONT_OLD_10_WHITE_HI.TGA", 50, 1200, 255, 255, 255);
		m_DrawMessageBuffer = createDraw(format("Message buffer: %i", netStats.messagesInResendBuffer), "FONT_OLD_10_WHITE_HI.TGA", 50, 1400, 255, 255, 255);
		m_DrawBufferBytesToSend = createDraw(format("Buffer bytes to send: %i", netStats.bytesInResendBuffer), "FONT_OLD_10_WHITE_HI.TGA", 50, 1600, 255, 255, 255);
		m_DrawStreamedPlayers = createDraw(format("Streamed players: %i", getStreamedPlayers()), "FONT_OLD_10_WHITE_HI.TGA", 50, 1800, 255, 255, 255);
		m_DrawStreamedItems = createDraw(format("Streamend items: %i", getStreamedItems()), "FONT_OLD_10_WHITE_HI.TGA", 50, 2000, 255, 255, 255);
		
		setTimer(function(stats)
		{
			local netStats = getNetworkStats();
		
			setDrawText(stats.m_DrawPing, format("Ping: %i ms", getPing()));
			setDrawText(stats.m_DrawFPS, format("FPS: %i", getFPSRate()));
			setDrawText(stats.m_DrawReceivecPackets, format("Received packet count: %i", netStats.packetReceived));
			setDrawText(stats.m_DrawLostPackets, format("Lost packet count: %i", netStats.packetlossTotal));
			setDrawText(stats.m_DrawLostPacketsLastSec, format("Lost packet in last second count: %i", netStats.packetlossLastSecond));
			setDrawText(stats.m_DrawMessageBuffer, format("Message buffer: %i", netStats.messagesInResendBuffer));
			setDrawText(stats.m_DrawBufferBytesToSend, format("Buffer bytes to send: %i", netStats.bytesInResendBuffer));
			setDrawText(stats.m_DrawStreamedPlayers, format("Streamed players: %i", getStreamedPlayers()));
			setDrawText(stats.m_DrawStreamedItems, format("Streamend items: %i", getStreamedItems()));
		}, 200, true, this);
		
		m_bVisible = false;
	}
	
	function show()
	{
		if (!m_bVisible)
		{
			setDrawVisible(m_DrawTitle, true);
			setDrawVisible(m_DrawPing, true);
			setDrawVisible(m_DrawFPS, true);
			setDrawVisible(m_DrawReceivecPackets, true);
			setDrawVisible(m_DrawLostPackets, true);
			setDrawVisible(m_DrawLostPacketsLastSec, true);
			setDrawVisible(m_DrawMessageBuffer, true);
			setDrawVisible(m_DrawBufferBytesToSend, true);
			setDrawVisible(m_DrawStreamedPlayers, true);
			setDrawVisible(m_DrawStreamedItems, true);
			
			globalChat.hide();
			
			m_bVisible = true;
		}
	}
	
	function hide()
	{
		if (m_bVisible)
		{
			setDrawVisible(m_DrawTitle, false);
			setDrawVisible(m_DrawPing, false);
			setDrawVisible(m_DrawFPS, false);
			setDrawVisible(m_DrawReceivecPackets, false);
			setDrawVisible(m_DrawLostPackets, false);
			setDrawVisible(m_DrawLostPacketsLastSec, false);
			setDrawVisible(m_DrawMessageBuffer, false);
			setDrawVisible(m_DrawBufferBytesToSend, false);
			setDrawVisible(m_DrawStreamedPlayers, false);
			setDrawVisible(m_DrawStreamedItems, false);
			
			globalChat.show();
			
			m_bVisible = false;
		}
	}
	
	m_bVisible							= false;
	m_DrawTitle 							= null;
	m_DrawPing 							= null;
	m_DrawFPS							= null;
	m_DrawReceivecPackets 		= null;
	m_DrawLostPackets 				= null;
	m_DrawLostPacketsLastSec	= null;
	m_DrawMessageBuffer 			= null;
	m_DrawBufferBytesToSend	= null;
	m_DrawStreamedPlayers		= null;
	m_DrawStreamedItems 			= null;
};

globalMultiStats <- MultiplayerStatistics();

addEvent("onKey", function(key, letter)
{
	if (key == KEY_F6)
	{
		if (globalMultiStats.m_bVisible)
			globalMultiStats.hide();
		else if (!isChatInputOpen())
			globalMultiStats.show();
	}
});
//DLG_CONVERSATION.TGA