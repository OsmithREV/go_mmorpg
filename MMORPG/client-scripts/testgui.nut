
local MAX_GUIELEMENTS = 100;

local WINDOW_MOVEMENT = true;

local guiStructure = {};

for (local i = 0; i < MAX_GUIELEMENTS; ++i)
{
	guiStructure[i] <-{};
	guiStructure[i].type <- 0;
	guiStructure[i].gui <- -1;
};

class GUIButton
{
	constructor (x, y, width, height, texture)
	{
		g_PosX = x;
		g_PosY = y;
		g_CurX = x;
		g_CurY = y;
		g_Texture = texture;
		g_Width = width;
		g_Height = height;
		
		g_Button = createTexture(x, y, width, height, texture);
		
	}
	
	function show()
	{
		setTextureVisible(g_Button,true);
		g_Showed = true;
	}
	
	function hide()
	{
		setTextureVisible(g_Button,false);
		g_Showed = false;
	}
	
	function isShowed()
	{
		return g_Showed;
	}
	
	function check()
	{
		local pos = getCursorPosition();
		if ((pos.x >= g_CurX && pos.x < (g_CurX + g_Width)) && (pos.y >= g_CurY && pos.y <= (g_CurY + g_Height)))
		{
			if (g_Showed == true && g_Access == true)
			{
				g_ButtonActive = true;
			};
		}
		else
		{
			if (g_Showed == true && g_Access == true)
			{
				g_ButtonActive = false;
			};
		};
		if (g_ConnectedWindow != -1)
		{
			if (g_ConnectedWindow.isMove() == true)
			{
				if (g_OldX == 2281337228)
				{
					g_OldX = pos.x;
					g_OldY = pos.y;
				};
				if (g_OldX > pos.x)
				{
					g_CurX = g_CurX - (g_OldX - pos.x);
				}
				else
				{
					g_CurX = g_CurX + (pos.x - g_OldX);
				};
				if (g_OldY > pos.y)
				{
					g_CurY = g_CurY - (g_OldY - pos.y);
				}
				else
				{
					g_CurY = g_CurY + (pos.y - g_OldY);
				};
				g_OldX = pos.x;
				g_OldY = pos.y;
				setTexturePosition(g_Button,g_CurX,g_CurY);
			}
			else
			{
				g_OldX = 2281337228;
				g_OldY = 2281337228;
			};
			if (g_ConnectedWindow.isReset() == true)
			{
				g_CurX = g_PosX;
				g_CurY = g_PosY;
				setTexturePosition(g_Button,g_PosX,g_PosY);
			};
		};
	}
	
	function setPosition(x,y)
	{
		g_PosX = x;
		g_PosY = y;
		
		setTexturePosition(g_Button,x,y);
	}
	
	function setSize(width,height)
	{
		g_Width = width;
		g_Height = height;
		
		setTextureSize(g_Button,width,height);
	}
	
	function setTexture(new_texture)
	{
		g_Texture = new_texture;
		destroyTexture(g_Button);
		g_Button = createTexture(g_CurX,g_CurY,g_Width,g_Height,new_texture);
		if (g_Showed == true)
		{
			setTextureVisible(g_Button,true);
		};
	}
	
	function reset()
	{
		g_CurX = g_PosX;
		g_CurY = g_PosY;
		setTexturePosition(g_CurX,g_CurY,g_Width,g_Height,g_Texture);
	}
	
	function isActive()
	{
		return g_ButtonActive;
	}
	
	function connect(window)
	{
		for (local i = 0; i < MAX_GUIELEMENTS; ++i)
		{
			if (guiStructure[i].gui == window)
			{
				if (guiStructure[i].type == 2)
				{
					g_ConnectedWindow = guiStructure[i].gui;
				}
				else
				{
					print("That gui element is not window!");
				};
			};
		};
	}
	
	function disconnect()
	{
		if (g_ConnectedWindow != -1)
		{
			g_ConnectedWindow = -1;
		};
	}
	
	function access(toggle)
	{
		if (access == true)
		{
			g_Access = false;
		}
		else
		{
			g_Access = true;
		};
	}
	
	onRender = 0;
	
	g_PosX = 0;
	g_PosY = 0;
	g_CurX = 0;
	g_CurY = 0;
	g_Texture = -1;
	g_Width = 0;
	g_Height = 0;
	g_Button = -1;
	g_Showed = false;
	g_Access = true;
	g_ConnectedWindow = -1;
	g_OldX = 0;
	g_OldY = 0;
	g_ButtonActive = false;
}

class GUIWindow
{
	constructor (x,y,width,height,texture, id)
	{
		g_PosX = x;
		g_PosY = y;
		g_Width = width;
		g_Height = height;
		g_Texture = texture;
		g_CurX = x;
		g_CurY = y;
		g_ID = id;
		
		g_Window = createTexture(x,y,width,height,texture);
	}
	
	function show()
	{
		if (g_Showed == false)
		{
			g_Showed = true;
			setTextureVisible(g_Window,true);
		};
	}
	
	function hide()
	{
		if (g_Showed == true)
		{
			g_Showed = false;
			setTextureVisible(g_Window,false);
		};
	}
	
	function reset()
	{
		g_CurX = g_PosX;
		g_CurY = g_PosY;
		setTexturePosition(g_Window,g_PosX,g_PosY);
		g_Move = false;
	}
	
	function check()
	{
		local pos = getCursorPosition();
		if ((pos.x >= g_CurX && pos.x < (g_CurX + g_Width)) && (pos.y >= g_CurY && pos.y <= (g_CurY + g_Height)))
		{
			if (g_Showed == true && g_Access == true)
			{
				for (local i = 0; i < MAX_GUIELEMENTS; ++ i)
				{
					if (guiStructure[i].gui != -1)
					{
						if (guiStructure[i].type == 2)
						{
							if (guiStructure[i].gui.isActive() == false)
							{
								g_Active = true;
								for (local i = 0; i < MAX_GUIELEMENTS; ++ i)
								{
									if (guiStructure[i].gui != -1)
									{
										if (guiStructure[i].type == 2)
										{
											if (i != g_ID)
											{
												guiStructure[i].gui.setActive(false);
											};
										};
									};
								};
							};
						};
					};
				};
			};
		}
		else
		{
			if (g_Showed == true && g_Access == true)
			{
				g_Active = false;
			};
		};
		if (g_Move == true && g_ConnectedWindow == -1)
		{
			if (g_OldX == 2281337228)
			{
				g_OldX = pos.x;
				g_OldY = pos.y;
			};
			if (g_OldX > pos.x)
			{
				g_CurX = g_CurX - (g_OldX - pos.x);
			}
			else
			{
				g_CurX = g_CurX + (pos.x - g_OldX);
			};
			if (g_OldY > pos.y)
			{
				g_CurY = g_CurY - (g_OldY - pos.y);
			}
			else
			{
				g_CurY = g_CurY + (pos.y - g_OldY);
			};
			g_OldX = pos.x;
			g_OldY = pos.y;
			setTexturePosition(g_Window,g_CurX,g_CurY);
		}
		else
		{
			g_OldX = 2281337228;
			g_OldY = 2281337228;
		};
		if (g_PosX == g_CurX && g_PosY == g_CurY)
		{
			g_Reset = true;
		}
		else
		{
			g_Reset = false;
		};
		if (g_ConnectedWindow != -1)
		{
			if (g_ConnectedWindow.isMove() == true)
			{
				if (g_OldX == 2281337228)
				{
					g_OldX = pos.x;
					g_OldY = pos.y;
				};
				if (g_OldX > pos.x)
				{
					g_CurX = g_CurX - (g_OldX - pos.x);
				}
				else
				{
					g_CurX = g_CurX + (pos.x - g_OldX);
				};
				if (g_OldY > pos.y)
				{
					g_CurY = g_CurY - (g_OldY - pos.y);
				}
				else
				{
					g_CurY = g_CurY + (pos.y - g_OldY);
				};
				g_OldX = pos.x;
				g_OldY = pos.y;
				setTexturePosition(g_Window,g_CurX,g_CurY);
			}
			else
			{
				g_OldX = 2281337228;
				g_OldY = 2281337228;
			};
			if (g_ConnectedWindow.isReset() == true)
			{
				g_CurX = g_PosX;
				g_CurY = g_PosY;
				setTexturePosition(g_Window,g_PosX,g_PosY);
			};
		};
	}
	
	function isActive()
	{
		return g_Active;
	}
	
	function setActive(toggle)
	{
		g_Active = toggle;
	}
	
	function isMove()
	{
		return g_Move;
	}
	
	function setMove(tog)
	{
		g_Move = tog;
	}
	
	function isReset()
	{
		return g_Reset;
	}
	
	function access(toggle)
	{
		g_Access = toggle;
	}
	
	function canMove()
	{
		return g_CanMove;
	}
	
	function setCanMove(toggle)
	{
		g_CanMove = toggle;
	}
	
	function connect(window)
	{
		for (local i = 0; i < MAX_GUIELEMENTS; ++i)
		{
			if (guiStructure[i].gui == window)
			{
				if (guiStructure[i].type == 2)
				{
					g_ConnectedWindow = guiStructure[i].gui;
				}
				else
				{
					print("That gui element is not window!");
				};
			};
		};
	}
	
	g_ID = 0;
	g_PosX = 0;
	g_PosY = 0;
	g_Width = 0;
	g_Height = 0;
	g_Texture = -1;
	g_Window = -1;
	g_CurX = 0;
	g_CurY = 0;
	g_OldX = 0;
	g_OldY = 0;
	g_ConnectedWindow = -1;
	g_Access = true;
	g_Reset = true;
	g_Showed = false;
	g_Active = false;
	g_Move = false;
	g_CanMove = true;
}

class GUICheckbox
{
	constructor (x,y,width,height,texture,texture_active)
	{
		g_PosX = x;
		g_CurX = x;
		g_PosY = y;
		g_CurY = y;
		g_Width = width;
		g_Height = height;
		g_Texture = texture;
		g_TextureActive = texture_active;
		
		g_Checkbox = createTexture(x,y,width,height,texture);
	}
	
	function show()
	{
		if (g_Showed == false)
		{
			g_Showed = true;
			setTextureVisible(g_Checkbox,true);
		};
	}
	
	function hide()
	{
		if (g_Showed == true)
		{
			g_Showed = false;
			setTextureVisible(g_Checkbox,false);
		};
	}
	
	function isShowed ()
	{
		return g_Showed;
	}
	
	function setPosition(x,y)
	{
		g_PosX = x;
		g_PosY = y;
	}
	
	function reset()
	{
		g_CurX = g_PosX;
		g_CurY = g_PosY;
		setTexturePosition(g_Checkbox,g_CurX,g_CurY);
	}
	
	function setSize(w,h)
	{
		g_Width = w;
		g_Height = h;
		setTextureSize(g_Checkbox,w,h);
	}
	
	function connect(window)
	{
		if (g_ConnectedWindow == -1)
		{
			for (local i = 0; i < MAX_GUIELEMENTS; ++i)
			{
				if (guiStructure[i].gui == window)
				{
					if (guiStructure[i].type == 2)
					{
						g_ConnectedWindow = guiStructure[i].gui;
					}
					else
					{
						print("That gui element is not window!");
					};
				};
			};
		};
	}
	
	function check()
	{
		local pos = getCursorPosition();
		if ((pos.x >= g_CurX && pos.x < (g_CurX + g_Width)) && (pos.y >= g_CurY && pos.y <= (g_CurY + g_Height)))
		{
			if (g_Showed == true && g_Access == true)
			{
				g_Active = true;
			};
		}
		else
		{
			if (g_Showed == true && g_Access == true)
			{
				g_Active = false;
			};
		};
		if (g_ConnectedWindow != -1)
		{
			if (g_ConnectedWindow.isMove() == true)
			{
				if (g_OldX == 2281337228)
				{
					g_OldX = pos.x;
					g_OldY = pos.y;
				};
				if (g_OldX > pos.x)
				{
					g_CurX = g_CurX - (g_OldX - pos.x);
				}
				else
				{
					g_CurX = g_CurX + (pos.x - g_OldX);
				};
				if (g_OldY > pos.y)
				{
					g_CurY = g_CurY - (g_OldY - pos.y);
				}
				else
				{
					g_CurY = g_CurY + (pos.y - g_OldY);
				};
				g_OldX = pos.x;
				g_OldY = pos.y;
				setTexturePosition(g_Checkbox,g_CurX,g_CurY);
			}
			else
			{
				g_OldX = 2281337228;
				g_OldY = 2281337228;
			};
		};
		if (g_ConnectedWindow.isReset() == true)
		{
			g_CurX = g_PosX;
			g_CurY = g_PosY;
			setTexturePosition(g_Checkbox,g_CurX,g_CurY);
		};
	}
	
	function turn(toggle)
	{
		if (toggle == true)
		{
			print("ok1");
			destroyTexture(g_Checkbox);
			g_Checkbox = createTexture(g_CurX,g_CurY,g_Width,g_Height,g_Texture);
			g_Turn = false;
			if (g_Showed == true)
			{
				setTextureVisible(g_Checkbox,true);
			};
		}
		else if (toggle == false)
		{
			print("ok2");
			destroyTexture(g_Checkbox);
			g_Checkbox = createTexture(g_CurX,g_CurY,g_Width,g_Height,g_TextureActive);
			g_Turn = true;
			if (g_Showed == true)
			{
				setTextureVisible(g_Checkbox,true);
			};
		};
	}
	
	function isActive()
	{
		return g_Active;
	}

	function isTurn()
	{
		return g_Turn;
	}
	
	function disconnect()
	{
		if (g_ConnectedWindow != -1)
		{
			g_ConnectedWindow = -1;
		};
	}
	
	function getWindow()
	{
		if (g_ConnectedWindow != -1)
		{
			return g_ConnectedWindow;
		};
	}
	
	function access(toggle)
	{
		if (access == true)
		{
			g_Access = false;
		}
		else
		{
			g_Access = true;
		};
	}
	
	g_PosX = -1;
	g_PosY = -1;
	g_CurX = -1;
	g_CurY = -1;
	g_OldX = -1;
	g_OldY = -1;
	g_ConnectedWindow = -1;
	g_Texture = -1;
	g_TextureActive = -1;
	g_Width = -1;
	g_Height = -1;
	g_Checkbox = -1;
	g_Access = true;
	g_Active = false;
	g_Turn = false;
	g_Showed = false;
}

class GUITextButton
{
	constructor (text, font, x, y, r, g, b)
	{
		g_PosX = x;
		g_PosY = y;
		g_CurX = x;
		g_CurY = y;
		local resolution = getResolution();
		g_MaxX = g_CurX + ((8192.0 / resolution.width) * getTextWidth(font,text) + 20);
		g_MaxY = g_CurY + 150;
		g_R = r;
		g_G = g;
		g_B = b;
		g_AR = r;
		g_AG = g;
		g_AB = b;
		g_Text = text;
		g_Font = font;
		
		g_Button = createDraw(text, font, x, y, r,g,b, true);
		
	}
	
	function show()
	{
		setDrawVisible(g_Button,true);
		g_Showed = true;
	}
	
	function hide()
	{
		setDrawVisible(g_Button,false);
		g_Showed = false;
	}
	
	function isShowed()
	{
		return g_Showed;
	}
	
	function check()
	{
		local pos = getCursorPosition();
		if ((pos.x >= g_CurX && pos.x < (g_MaxX)) && (pos.y >= g_CurY && pos.y <= (g_MaxY)))
		{
			if (g_Showed == true && g_Access == true)
			{
				g_ButtonActive = true;
				setDrawColor(g_Button,g_AR,g_AG,g_AB);
			};
		}
		else
		{
			if (g_Showed == true && g_Access == true)
			{
				g_ButtonActive = false;
				setDrawColor(g_Button,g_R,g_G,g_B);
			};
		};
		if (g_ConnectedWindow != -1)
		{
			if (g_ConnectedWindow.isMove() == true)
			{
				if (g_OldX == 2281337228)
				{
					g_OldX = pos.x;
					g_OldY = pos.y;
				};
				if (g_OldX > pos.x)
				{
					g_CurX = g_CurX - (g_OldX - pos.x);
					g_MaxX = g_MaxX - (g_OldX - pos.x);
				}
				else
				{
					g_CurX = g_CurX + (pos.x - g_OldX);
					g_MaxX = g_MaxX + (pos.x - g_OldX);
				};
				if (g_OldY > pos.y)
				{
					g_CurY = g_CurY - (g_OldY - pos.y);
					g_MaxY = g_MaxY - (g_OldY - pos.y);
				}
				else
				{
					g_CurY = g_CurY + (pos.y - g_OldY);
					g_MaxY = g_MaxY + (pos.y - g_OldY);
				};
				g_OldX = pos.x;
				g_OldY = pos.y;
				setDrawPosition(g_Button,g_CurX,g_CurY);
			}
			else
			{
				g_OldX = 2281337228;
				g_OldY = 2281337228;
			};
			if (g_ConnectedWindow.isReset() == true)
			{
				g_CurX = g_PosX;
				g_CurY = g_PosY;
				local resolution = getResolution();
				g_MaxX = g_CurX + ((8192.0 / resolution.width) * getTextWidth(g_Font,g_Text) + 20);
				g_MaxY = g_CurY + 150;
				setDrawPosition(g_Button,g_PosX,g_PosY);
			};
		};
	}
	
	function setPosition(x,y)
	{
		g_PosX = x;
		g_PosY = y;
		g_CurX = x;
		g_CurY = y;
		local resolution = getResolution();
		g_MaxX = g_CurX + ((8192.0 / resolution.width) * getTextWidth(g_Font,g_Text) + 20);
		g_MaxY = g_CurY + 150;
		setDrawPosition(g_Button,x,y);
	}
	
	function reset()
	{
		g_CurX = g_PosX;
		g_CurY = g_PosY;
		local resolution = getResolution();
		g_MaxX = g_CurX + ((8192.0 / resolution.width) * getTextWidth(g_Font,g_Text) + 20);
		g_MaxY = g_CurY + 150;
		setDrawPosition(g_CurX,g_CurY,g_Width,g_Height,g_Texture);
	}
	
	function isActive()
	{
		return g_ButtonActive;
	}
	
	function connect(window)
	{
		for (local i = 0; i < MAX_GUIELEMENTS; ++i)
		{
			if (guiStructure[i].gui == window)
			{
				if (guiStructure[i].type == 2)
				{
					g_ConnectedWindow = guiStructure[i].gui;
				}
				else
				{
					print("That gui element is not window!");
				};
			};
		};
	}
	
	function disconnect()
	{
		if (g_ConnectedWindow != -1)
		{
			g_ConnectedWindow = -1;
		};
	}
	
	function access(toggle)
	{
		if (access == true)
		{
			g_Access = false;
		}
		else
		{
			g_Access = true;
		};
	}
	
	function setText(text)
	{
		g_Text = text;
		setDrawText(g_Button,text);
	}
	
	function setColor(r, g, b)
	{
		g_R = r;
		g_G = g;
		g_B = b;
		setDrawColor(g_Button,r,g,b);
	}
	
	function setActiveColor(r, g, b)
	{
		g_AR = r;
		g_AG = g;
		g_AB = b;
	}
	
	function getPosX()
	{
		return g_CurX;
	}
	
	function getPosY()
	{
		return g_CurY;
	}
	
	onRender = 0;
	
	g_PosX = 0;
	g_PosY = 0;
	g_CurX = 0;
	g_CurY = 0;
	g_MaxX = 0;
	g_MaxY = 0;
	g_Text = -1;
	g_R = 0;
	g_G = 0;
	g_B = 0;
	g_AR = 0;
	g_AG = 0;
	g_AB = 0;
	g_Font = -1;
	g_Button = -1;
	g_Showed = false;
	g_Access = true;
	g_ConnectedWindow = -1;
	g_OldX = 0;
	g_OldY = 0;
	g_ButtonActive = false;
}

class GUIInput
{
	constructor(x,y,font,max,r,g,b)
	{
		g_PosX = x;
		g_CurX = x;
		g_PosY = y;
		g_CurY = y;
		g_Max = max;
		
		g_InputDraw = createDraw("",font,g_CurX,g_CurY,r,g,b,true);
	}
	
	function access(toggle)
	{
		g_Access = toggle;
	}
	
	function reset()
	{
		g_CurX = g_PosX;
		g_CurY = g_PosY;
	}
	
	function open()
	{
		clearChatInput();
		chatInputPosition(g_PosX,g_PosY);
		setDrawVisible(g_InputDraw,false);
		chatInputToggle(true);
		chatInputSetText(g_Input);
		g_Opened = true;
	}
	
	function close()
	{
		clearChatInput();
		chatInputPosition(0,0); //Тут координаты для позиции чата
		chatInputToggle(false);
		g_Opened = false;
		setDrawText(g_InputDraw,g_Input);
		setDrawVisible(g_InputDraw,true);
	}
	
	function show()
	{
		g_Showed = true;
		setDrawVisible(g_InputDraw,true);
	}
	
	function hide()
	{
		g_Showed = false;
		setDrawVisible(g_InputDraw,false);
	}
	
	function isShowed()
	{
		return g_Showed;
	}
	
	function isOpen()
	{
		return g_Opened;
	}
	
	function getInput()
	{
		return g_Input;
	}
	
	function setPosition(x,y)
	{
		g_PosX = x;
		g_PosY = y;
		g_CurX = x;
		g_CurY = y;
		setDrawPosition(g_InputDraw,x,y);
	}
	
	function setColor(r,g,b)
	{
		setDrawColor(g_InputDraw,r,g,b);
	}
	
	function setInput(text)
	{
		g_Input = text;
		if (isChatInputOpen())
		{
			chatInputSetText(text);
		};
	}
	
	function clearInput()
	{
		clearChatInput();
		g_Input = -1;
	}
	
	function connect(window)
	{
		for (local i = 0; i < MAX_GUIELEMENTS; ++i)
		{
			if (guiStructure[i].gui == window)
			{
				if (guiStructure[i].type == 2)
				{
					g_ConnectedWindow = guiStructure[i].gui;
				}
				else
				{
					print("That gui element is not window!");
				};
			};
		};
	}
	
	function disconnect()
	{
		if (g_ConnectedWindow != -1)
		{
			g_ConnectedWindow = -1;
		};
	}
	
	function check()
	{
		if (g_ConnectedWindow != -1)
		{
			if (g_ConnectedWindow.isMove() == true)
			{
				if (g_OldX == 2281337228)
				{
					g_OldX = pos.x;
					g_OldY = pos.y;
				};
				if (g_OldX > pos.x)
				{
					g_CurX = g_CurX - (g_OldX - pos.x);
				}
				else
				{
					g_CurX = g_CurX + (pos.x - g_OldX);
				};
				if (g_OldY > pos.y)
				{
					g_CurY = g_CurY - (g_OldY - pos.y);
				}
				else
				{
					g_CurY = g_CurY + (pos.y - g_OldY);
				};
				g_OldX = pos.x;
				g_OldY = pos.y;
				setDrawPosition(g_InputDraw,g_CurX,g_CurY);
			}
			else
			{
				g_OldX = 2281337228;
				g_OldY = 2281337228;
			};
			if (g_ConnectedWindow.isReset() == true)
			{
				g_CurX = g_PosX;
				g_CurY = g_PosY;
				setDrawPosition(g_InputDraw,g_PosX,g_PosY);
			};
		};
	}
	
	g_PosX = -1;
	g_PosY = -1;
	g_CurX = -1;
	g_CurY = -1;
	g_OldX = -1;
	g_OldY = -1;
	g_Input = -1;
	g_ConnectedWindow = -1;
	g_InputDraw = -1;
	g_Opened = false;
	g_Access = true;
	g_Showed = false;
}

function createGUIButton(x,y,width,height,texture)
{
	local id = getGUIid();
	guiStructure[id].gui = GUIButton(x,y,width,height,texture);
	guiStructure[id].type = 1;
	callServerFunc("print","Button with ID " + id + " created.");
	return guiStructure[id].gui;
};

function createGUIWindow(x,y,width,height,texture)
{
	local id = getGUIid();
	guiStructure[id].gui = GUIWindow(x,y,width,height,texture, id);
	guiStructure[id].type = 2;
	callServerFunc("print","Window with ID " + id + " created.");
	return guiStructure[id].gui;
}

function createGUICheckbox(x,y,width,height,texture,texture_active)
{
	local id = getGUIid();
	guiStructure[id].gui = GUICheckbox(x,y,width,height,texture,texture_active);
	guiStructure[id].type = 3;
	callServerFunc("print","Checkbox with ID " + id + " created.");
	return guiStructure[id].gui;
}

function createGUITextButton(text,font,x,y,r,g,b)
{
	local id = getGUIid();
	guiStructure[id].gui = GUITextButton(text,font,x,y,r,g,b);
	guiStructure[id].type = 4;
	callServerFunc("print","Button with ID " + id + " created.");
	return guiStructure[id].gui;
}

function createGUIInput(x,y,font,r,g,b,max)
{
	local id = getGUIid();
	guiStructure[id].gui = GUIInput(x,y,font,r,g,b,max);
	guiStructure[id].type = 5;
	callServerFunc("print","InputField with ID " + id + " created.");
	return guiStructure[id].gui;
}

function getGUIid()
{
	for (local i = 0; i < MAX_GUIELEMENTS; ++i)
	{
		if (guiStructure[i].gui == -1)
		{
			return i;
			break;
		};
	};
};

function enableWindowsMovement(toggle)
{
	WINDOW_MOVEMENT = toggle;
};

addEvent("onKey",function(key,letter)
{
	for (local i = 0; i < MAX_GUIELEMENTS; ++i)
	{
		if (guiStructure[i].type == 5)
		{
			local text = guiStructure[i].gui.getInput();
			if (text.len() > guiStructure[i].gui.g_Max)
			{
				text = text.slice(0,guiStructure[i].gui.g_Max);
				guiStructure[i].gui.setInput(text);
			};
		};
	};
});

addEvent("onRender",function()
{
	for (local i = 0; i < MAX_GUIELEMENTS; ++i)
	{
		if (guiStructure[i].type != 0)
		{
			guiStructure[i].gui.check();
		};
	};
});

addEvent("onClick",function(key, xpos, ypos, wheel)
{
	if (WINDOW_MOVEMENT == true)
	{
		for (local i = 0; i < MAX_GUIELEMENTS; ++i)
		{
			if (guiStructure[i].type == 2)
			{
				if (guiStructure[i].gui.isActive() == true && guiStructure[i].gui.canMove() == true)
				{
					if (key == "RIGHT_DOWN")
					{
						guiStructure[i].gui.setMove(true);
					}
					else if (key == "RIGHT_UP")
					{
						guiStructure[i].gui.setMove(false);
					};
				};
			};
		};
	};
	for (local i = 0; i < MAX_GUIELEMENTS; ++i)
	{
		if (guiStructure[i].type == 3)
		{
			if (guiStructure[i].gui.isActive() == true)
			{
				if (key == "LEFT_DOWN")
				{
					if (guiStructure[i].gui.isTurn() == false)
					{
						guiStructure[i].gui.turn(true);
					}
					else
					{
						guiStructure[i].gui.turn(false);
					};
				};
			};
		};
	};
});