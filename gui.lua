local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}

local XP_COLORS = {
	Border = Color3.fromRGB(0, 85, 229),
	TitleBarLeft = Color3.fromRGB(0, 88, 238),
	TitleBarRight = Color3.fromRGB(61, 149, 255),
	Background = Color3.fromRGB(236, 233, 216),
	ButtonBorder = Color3.fromRGB(0, 60, 116),
	ButtonFace = Color3.fromRGB(240, 240, 225),
	Text = Color3.fromRGB(0, 0, 0),
	TitleText = Color3.fromRGB(255, 255, 255),
	CloseBtn = Color3.fromRGB(228, 86, 75),
	SysBtn = Color3.fromRGB(22, 106, 238),
	TabInactive = Color3.fromRGB(210, 207, 190),
	TabActive = Color3.fromRGB(236, 233, 216),
	Shadow = Color3.fromRGB(172, 168, 153),
	Highlight = Color3.fromRGB(255, 255, 255)
}

local MAIN_FONT = Enum.Font.ArialBold
local TEXT_SIZE = 16

function Library:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "WinXP_Library_" .. math.random(100, 999)
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	local WindowFrame = Instance.new("Frame")
	WindowFrame.Size = UDim2.new(0, 550, 0, 450)
	WindowFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
	WindowFrame.BackgroundColor3 = XP_COLORS.Border
	WindowFrame.BorderSizePixel = 0
	WindowFrame.Active = true
	WindowFrame.Draggable = true
	WindowFrame.Parent = ScreenGui
	Instance.new("UICorner", WindowFrame).CornerRadius = UDim.new(0, 8)

	local TitleBar = Instance.new("Frame", WindowFrame)
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundTransparency = 1
	
	local TitleGradient = Instance.new("UIGradient", WindowFrame)
	TitleGradient.Color = ColorSequence.new(XP_COLORS.TitleBarLeft, XP_COLORS.TitleBarRight)

	local Gloss = Instance.new("Frame", TitleBar)
	Gloss.Size = UDim2.new(1, 0, 0.4, 0)
	Gloss.BackgroundColor3 = XP_COLORS.Highlight
	Gloss.BackgroundTransparency = 0.85
	Gloss.BorderSizePixel = 0
	Instance.new("UICorner", Gloss).CornerRadius = UDim.new(0, 8)

	local TitleLabel = Instance.new("TextLabel", TitleBar)
	TitleLabel.Size = UDim2.new(1, -120, 1, 0)
	TitleLabel.Position = UDim2.new(0, 12, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = XP_COLORS.TitleText
	TitleLabel.Font = MAIN_FONT
	TitleLabel.TextSize = 16
	TitleLabel.TextXAlignment = "Left"
	TitleLabel.TextStrokeTransparency = 0.8

	local InnerFrame = Instance.new("Frame", WindowFrame)
	InnerFrame.Size = UDim2.new(1, -8, 1, -36)
	InnerFrame.Position = UDim2.new(0, 4, 0, 32)
	InnerFrame.BackgroundColor3 = XP_COLORS.Background
	InnerFrame.BorderSizePixel = 0
	InnerFrame.ClipsDescendants = true

	local isMinimized, isMaximized = false, false
	local originalSize, originalPos = WindowFrame.Size, WindowFrame.Position

	local function CreateSysBtn(text, pos, color, callback)
		local btn = Instance.new("TextButton", TitleBar)
		btn.Size = UDim2.new(0, 22, 0, 22)
		btn.Position = UDim2.new(1, pos, 0, 4)
		btn.BackgroundColor3 = color
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = MAIN_FONT
		btn.TextSize = 18
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
		btn.MouseButton1Click:Connect(callback)
		return btn
	end

	CreateSysBtn("X", -28, XP_COLORS.CloseBtn, function() ScreenGui:Destroy() end)
	CreateSysBtn("□", -54, XP_COLORS.SysBtn, function()
		if isMinimized then return end
		isMaximized = not isMaximized
		if isMaximized then
			originalSize, originalPos = WindowFrame.Size, WindowFrame.Position
			WindowFrame.Size, WindowFrame.Position = UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0)
		else
			WindowFrame.Size, WindowFrame.Position = originalSize, originalPos
		end
	end)
	CreateSysBtn("_", -80, XP_COLORS.SysBtn, function()
		isMinimized = not isMinimized
		InnerFrame.Visible = not isMinimized
		WindowFrame.Size = isMinimized and UDim2.new(0, WindowFrame.Size.X.Offset, 0, 30) or (isMaximized and UDim2.new(1, 0, 1, 0) or originalSize)
	end)

	local TabHolder = Instance.new("Frame", InnerFrame)
	TabHolder.Size = UDim2.new(1, -10, 0, 30)
	TabHolder.Position = UDim2.new(0, 5, 0, 8)
	TabHolder.BackgroundTransparency = 1
	Instance.new("UIListLayout", TabHolder).FillDirection = "Horizontal"
	TabHolder.UIListLayout.Padding = UDim.new(0, 2)

	local PagesFolder = Instance.new("Frame", InnerFrame)
	PagesFolder.Size = UDim2.new(1, -16, 1, -50)
	PagesFolder.Position = UDim2.new(0, 8, 0, 42)
	PagesFolder.BackgroundColor3 = XP_COLORS.Background
	Instance.new("UIStroke", PagesFolder).Color = XP_COLORS.Shadow

	local window = { Tabs = {} }

	function window:CreateTab(name)
		local tabButton = Instance.new("TextButton", TabHolder)
		tabButton.Size = UDim2.new(0, 100, 1, 0)
		tabButton.BackgroundColor3 = XP_COLORS.TabInactive
		tabButton.Text = name
		tabButton.Font = MAIN_FONT
		tabButton.TextColor3 = XP_COLORS.Text
		tabButton.TextSize = 14
		Instance.new("UIStroke", tabButton).Color = XP_COLORS.Shadow

		local page = Instance.new("ScrollingFrame", PagesFolder)
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.ScrollBarThickness = 7
		page.BorderSizePixel = 0
		
		local layout = Instance.new("UIListLayout", page)
		layout.Padding = UDim.new(0, 12)
		Instance.new("UIPadding", page).PaddingLeft = UDim.new(0, 10)
		page.UIPadding.PaddingRight = UDim.new(0, 15)
		page.UIPadding.PaddingTop = UDim.new(0, 10)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
		end)

		local function selectTab()
			for _, t in pairs(window.Tabs) do
				t.Button.BackgroundColor3 = XP_COLORS.TabInactive
				t.Page.Visible = false
			end
			tabButton.BackgroundColor3 = XP_COLORS.TabActive
			page.Visible = true
		end
		tabButton.MouseButton1Click:Connect(selectTab)
		table.insert(window.Tabs, { Button = tabButton, Page = page })
		if #window.Tabs == 1 then selectTab() end

		local elements = {}

		function elements:CreateButton(text, callback)
			local b = Instance.new("TextButton", page)
			b.Size = UDim2.new(1, 0, 0, 35)
			b.BackgroundColor3 = XP_COLORS.ButtonFace
			b.Text = text
			b.Font = MAIN_FONT; b.TextSize = 16; b.TextColor3 = XP_COLORS.Text; b.TextStrokeTransparency = 0.95
			Instance.new("UIStroke", b).Color = XP_COLORS.ButtonBorder
			b.MouseButton1Click:Connect(callback)
		end

		function elements:CreateToggle(text, callback)
			local state = false
			local f = Instance.new("Frame", page)
			f.Size = UDim2.new(1, 0, 0, 25); f.BackgroundTransparency = 1
			local box = Instance.new("TextButton", f)
			box.Size = UDim2.new(0, 20, 0, 20); box.BackgroundColor3 = Color3.new(1,1,1)
			box.Text = ""; Instance.new("UIStroke", box).Color = XP_COLORS.ButtonBorder
			local l = Instance.new("TextLabel", f)
			l.Position = UDim2.new(0, 30, 0, 0); l.Size = UDim2.new(1, -30, 1, 0); l.Text = text
			l.BackgroundTransparency = 1; l.TextXAlignment = "Left"; l.Font = MAIN_FONT; l.TextSize = 14
			box.MouseButton1Click:Connect(function()
				state = not state
				box.Text = state and "✔" or ""
				callback(state)
			end)
		end

		function elements:CreateSlider(text, min, max, default, callback)
			local f = Instance.new("Frame", page)
			f.Size = UDim2.new(1, 0, 0, 45); f.BackgroundTransparency = 1
			local l = Instance.new("TextLabel", f)
			l.Text = text .. ": " .. default; l.Size = UDim2.new(1, 0, 0, 20); l.BackgroundTransparency = 1; l.Font = MAIN_FONT; l.TextSize = 14
			local track = Instance.new("Frame", f)
			track.Position = UDim2.new(0, 0, 0, 30); track.Size = UDim2.new(1, 0, 0, 4); track.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
			local thumb = Instance.new("TextButton", track)
			thumb.Size = UDim2.new(0, 12, 0, 20); thumb.BackgroundColor3 = XP_COLORS.ButtonFace; thumb.Position = UDim2.new((default-min)/(max-min), -6, 0.5, -10); thumb.Text = ""
			Instance.new("UIStroke", thumb).Color = XP_COLORS.ButtonBorder
			local drag = false
			thumb.MouseButton1Down:Connect(function() drag = true end)
			UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
			UserInputService.InputChanged:Connect(function(i)
				if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
					local p = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					thumb.Position = UDim2.new(p, -6, 0.5, -10)
					local val = math.floor(min + (max - min) * p)
					l.Text = text .. ": " .. val; callback(val)
				end
			end)
		end

		function elements:CreateColorPicker(text, default, callback)
			local f = Instance.new("Frame", page)
			f.Size = UDim2.new(1, 0, 0, 100); f.BackgroundTransparency = 1
			local l = Instance.new("TextLabel", f)
			l.Text = text; l.Size = UDim2.new(1, 0, 0, 20); l.BackgroundTransparency = 1; l.Font = MAIN_FONT; l.TextSize = 14
			local preview = Instance.new("Frame", f)
			preview.Position = UDim2.new(1, -40, 0, 0); preview.Size = UDim2.new(0, 35, 0, 35); preview.BackgroundColor3 = default
			Instance.new("UIStroke", preview).Color = XP_COLORS.Shadow
			local r, g, b = default.R, default.G, default.B
			local function colSlider(y, startV, colName)
				local track = Instance.new("Frame", f)
				track.Size = UDim2.new(1, -60, 0, 4); track.Position = UDim2.new(0, 0, 0, y); track.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
				local thumb = Instance.new("TextButton", track)
				thumb.Size = UDim2.new(0, 10, 0, 18); thumb.BackgroundColor3 = XP_COLORS.ButtonFace; thumb.Position = UDim2.new(startV, -5, 0.5, -9); thumb.Text = ""
				Instance.new("UIStroke", thumb).Color = XP_COLORS.ButtonBorder
				local drag = false
				thumb.MouseButton1Down:Connect(function() drag = true end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
				UserInputService.InputChanged:Connect(function(i)
					if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
						local p = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
						thumb.Position = UDim2.new(p, -5, 0.5, -9)
						if colName == "R" then r = p elseif colName == "G" then g = p else b = p end
						local nc = Color3.new(r, g, b); preview.BackgroundColor3 = nc; callback(nc)
					end
				end)
			end
			colSlider(35, r, "R"); colSlider(60, g, "G"); colSlider(85, b, "B")
		end

		function elements:CreateTextBox(text, placeholder, callback)
			local f = Instance.new("Frame", page)
			f.Size = UDim2.new(1, 0, 0, 55); f.BackgroundTransparency = 1
			local l = Instance.new("TextLabel", f)
			l.Text = text; l.Size = UDim2.new(1, 0, 0, 20); l.BackgroundTransparency = 1; l.Font = MAIN_FONT; l.TextSize = 14
			local b = Instance.new("TextBox", f)
			b.Position = UDim2.new(0, 0, 0, 25); b.Size = UDim2.new(1, 0, 0, 25); b.BackgroundColor3 = Color3.new(1,1,1); b.PlaceholderText = placeholder; b.Text = ""; b.Font = MAIN_FONT; b.TextSize = 14; b.TextColor3 = Color3.new(0,0,0)
			Instance.new("UIStroke", b).Color = XP_COLORS.Shadow
			b.FocusLost:Connect(function() callback(b.Text) end)
		end

		return elements
	end

	return window
end

return Library
