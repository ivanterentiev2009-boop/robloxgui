--====================================================================
-- WINDOWS LUNA UI LIBRARY (XP & 3.1 EDITION)
--====================================================================
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}

-- Настройки тем
Library.Themes = {
	["Windows XP"] = {
		Border = Color3.fromRGB(0, 85, 229),
		TitleBarLeft = Color3.fromRGB(0, 88, 238),
		TitleBarRight = Color3.fromRGB(61, 149, 255),
		Background = Color3.fromRGB(236, 233, 216),
		ButtonFace = Color3.fromRGB(240, 240, 225),
		Text = Color3.fromRGB(0, 0, 0),
		TitleText = Color3.fromRGB(255, 255, 255),
		CornerRadius = 8,
		Font = Enum.Font.ArialBold,
		StrokeTransparency = 0.85, -- Минимальная тень
		Gloss = true,
		CheckMark = "✔"
	},
	["Windows 3.1"] = {
		Border = Color3.fromRGB(0, 0, 0),
		TitleBarLeft = Color3.fromRGB(0, 0, 168),
		TitleBarRight = Color3.fromRGB(0, 0, 168),
		Background = Color3.fromRGB(192, 192, 192),
		ButtonFace = Color3.fromRGB(192, 192, 192),
		Text = Color3.fromRGB(0, 0, 0),
		TitleText = Color3.fromRGB(255, 255, 255),
		CornerRadius = 0,
		Font = Enum.Font.SourceSansBold,
		StrokeTransparency = 1, -- Без тени
		Gloss = false,
		CheckMark = "X"
	}
}

function Library:CreateWindow(title, themeName)
	local Theme = Library.Themes[themeName] or Library.Themes["Windows XP"]
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "WinUI_" .. math.random(100, 999)
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	local WindowFrame = Instance.new("Frame")
	WindowFrame.Size = UDim2.new(0, 550, 0, 450)
	WindowFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
	WindowFrame.BackgroundColor3 = Theme.Background
	WindowFrame.BorderSizePixel = (Theme.CornerRadius == 0) and 2 or 0
	WindowFrame.BorderColor3 = Theme.Border
	WindowFrame.Active = true
	WindowFrame.Draggable = true
	WindowFrame.ClipsDescendants = false
	WindowFrame.Parent = ScreenGui
	
	if Theme.CornerRadius > 0 then
		Instance.new("UICorner", WindowFrame).CornerRadius = UDim.new(0, Theme.CornerRadius)
	end

	-- Title Bar
	local TitleBar = Instance.new("Frame", WindowFrame)
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundColor3 = Theme.TitleBarLeft
	TitleBar.BorderSizePixel = 0
	
	if themeName ~= "Windows 3.1" then
		local TitleGradient = Instance.new("UIGradient", TitleBar)
		TitleGradient.Color = ColorSequence.new(Theme.TitleBarLeft, Theme.TitleBarRight)
	end

	-- Блик (Gloss)
	if Theme.Gloss then
		local Gloss = Instance.new("Frame", TitleBar)
		Gloss.Size = UDim2.new(1, 0, 0.4, 0)
		Gloss.BackgroundColor3 = Color3.new(1,1,1)
		Gloss.BackgroundTransparency = 0.85
		Gloss.BorderSizePixel = 0
		Instance.new("UICorner", Gloss).CornerRadius = UDim.new(0, Theme.CornerRadius)
	end

	local TitleLabel = Instance.new("TextLabel", TitleBar)
	TitleLabel.Size = UDim2.new(1, -120, 1, 0)
	TitleLabel.Position = UDim2.new(0, 12, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = Theme.TitleText
	TitleLabel.Font = Theme.Font
	TitleLabel.TextSize = 16
	TitleLabel.TextXAlignment = "Left"
	TitleLabel.TextStrokeTransparency = Theme.StrokeTransparency

	local InnerFrame = Instance.new("Frame", WindowFrame)
	InnerFrame.Size = UDim2.new(1, -8, 1, -38)
	InnerFrame.Position = UDim2.new(0, 4, 0, 34)
	InnerFrame.BackgroundColor3 = Theme.Background
	InnerFrame.BorderSizePixel = (Theme.CornerRadius == 0) and 1 or 0
	InnerFrame.ClipsDescendants = true

	-- Логика управления окном
	local isMinimized, isMaximized = false, false
	local originalSize, originalPos = WindowFrame.Size, WindowFrame.Position

	local function CreateSysBtn(text, pos, color, callback)
		local btn = Instance.new("TextButton", TitleBar)
		btn.Size = UDim2.new(0, 22, 0, 22)
		btn.Position = UDim2.new(1, pos, 0, 4)
		btn.BackgroundColor3 = color
		btn.Text = text
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Theme.Font
		btn.TextSize = 18
		if Theme.CornerRadius > 0 then Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4) end
		btn.MouseButton1Click:Connect(callback)
		return btn
	end

	CreateSysBtn("X", -28, Color3.fromRGB(228, 86, 75), function() ScreenGui:Destroy() end)
	
	CreateSysBtn("□", -54, Color3.fromRGB(22, 106, 238), function()
		if isMinimized then return end
		isMaximized = not isMaximized
		if isMaximized then
			originalSize, originalPos = WindowFrame.Size, WindowFrame.Position
			WindowFrame.Size, WindowFrame.Position = UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0)
		else
			WindowFrame.Size, WindowFrame.Position = originalSize, originalPos
		end
	end)

	CreateSysBtn("_", -80, Color3.fromRGB(22, 106, 238), function()
		isMinimized = not isMinimized
		InnerFrame.Visible = not isMinimized
		WindowFrame.Size = isMinimized and UDim2.new(0, WindowFrame.Size.X.Offset, 0, 30) or (isMaximized and UDim2.new(1, 0, 1, 0) or originalSize)
	end)

	-- Вкладки
	local TabHolder = Instance.new("Frame", InnerFrame)
	TabHolder.Size = UDim2.new(1, -10, 0, 30)
	TabHolder.Position = UDim2.new(0, 5, 0, 5)
	TabHolder.BackgroundTransparency = 1
	Instance.new("UIListLayout", TabHolder).FillDirection = "Horizontal"
	TabHolder.UIListLayout.Padding = UDim.new(0, 2)

	local PagesFolder = Instance.new("Frame", InnerFrame)
	PagesFolder.Size = UDim2.new(1, -10, 1, -45)
	PagesFolder.Position = UDim2.new(0, 5, 0, 40)
	PagesFolder.BackgroundTransparency = 1

	local window = { Tabs = {} }

	function window:CreateTab(name)
		local tabButton = Instance.new("TextButton", TabHolder)
		tabButton.Size = UDim2.new(0, 100, 1, 0)
		tabButton.BackgroundColor3 = Theme.ButtonFace
		tabButton.Text = name
		tabButton.Font = Theme.Font
		tabButton.TextSize = 14
		tabButton.TextColor3 = Theme.Text
		Instance.new("UIStroke", tabButton).Color = Color3.fromRGB(150, 150, 150)

		local page = Instance.new("ScrollingFrame", PagesFolder)
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.ScrollBarThickness = 6
		
		local layout = Instance.new("UIListLayout", page)
		layout.Padding = UDim.new(0, 10)
		Instance.new("UIPadding", page).PaddingLeft = UDim.new(0, 5)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
		end)

		local function selectTab()
			for _, t in pairs(window.Tabs) do t.Page.Visible = false end
			page.Visible = true
		end
		tabButton.MouseButton1Click:Connect(selectTab)
		table.insert(window.Tabs, { Page = page })
		if #window.Tabs == 1 then selectTab() end

		local elements = {}

		function elements:CreateButton(text, callback)
			local b = Instance.new("TextButton", page)
			b.Size = UDim2.new(0.95, 0, 0, 35)
			b.BackgroundColor3 = Theme.ButtonFace
			b.Text = text
			b.Font = Theme.Font; b.TextSize = 16; b.TextColor3 = Theme.Text
			b.TextStrokeTransparency = Theme.StrokeTransparency
			Instance.new("UIStroke", b).Color = Color3.new(0,0,0)
			b.MouseButton1Click:Connect(callback)
		end

		function elements:CreateToggle(text, callback)
			local state = false
			local f = Instance.new("Frame", page); f.Size = UDim2.new(1, 0, 0, 25); f.BackgroundTransparency = 1
			local box = Instance.new("TextButton", f); box.Size = UDim2.new(0, 20, 0, 20); box.Text = ""
			box.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UIStroke", box).Color = Color3.new(0,0,0)
			local l = Instance.new("TextLabel", f); l.Position = UDim2.new(0, 30, 0, 0); l.Size = UDim2.new(1, -30, 1, 0)
			l.Text = text; l.TextXAlignment = "Left"; l.BackgroundTransparency = 1; l.Font = Theme.Font; l.TextSize = 14; l.TextStrokeTransparency = Theme.StrokeTransparency
			box.MouseButton1Click:Connect(function()
				state = not state; box.Text = state and Theme.CheckMark or ""; callback(state)
			end)
		end

		function elements:CreateSlider(text, min, max, default, callback)
			local f = Instance.new("Frame", page); f.Size = UDim2.new(1, 0, 0, 45); f.BackgroundTransparency = 1
			local l = Instance.new("TextLabel", f); l.Text = text .. ": " .. default; l.Size = UDim2.new(1, 0, 0, 20); l.BackgroundTransparency = 1; l.Font = Theme.Font; l.TextSize = 14; l.TextStrokeTransparency = Theme.StrokeTransparency
			local track = Instance.new("Frame", f); track.Position = UDim2.new(0, 0, 0, 30); track.Size = UDim2.new(0.9, 0, 0, 4); track.BackgroundColor3 = Color3.new(0.5,0.5,0.5)
			local thumb = Instance.new("TextButton", track); thumb.Size = UDim2.new(0, 12, 0, 20); thumb.BackgroundColor3 = Theme.ButtonFace; thumb.Position = UDim2.new((default-min)/(max-min), -6, 0.5, -10); thumb.Text = ""
			Instance.new("UIStroke", thumb).Color = Color3.new(0,0,0)
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
			local f = Instance.new("Frame", page); f.Size = UDim2.new(1, 0, 0, 100); f.BackgroundTransparency = 1
			local l = Instance.new("TextLabel", f); l.Text = text; l.Size = UDim2.new(1, 0, 0, 20); l.BackgroundTransparency = 1; l.Font = Theme.Font; l.TextSize = 14; l.TextStrokeTransparency = Theme.StrokeTransparency
			local preview = Instance.new("Frame", f); preview.Position = UDim2.new(0.8, 0, 0, 25); preview.Size = UDim2.new(0, 40, 0, 40); preview.BackgroundColor3 = default
			local r, g, b = default.R, default.G, default.B
			local function colSlider(y, startV, colName)
				local track = Instance.new("Frame", f); track.Size = UDim2.new(0.7, 0, 0, 4); track.Position = UDim2.new(0, 0, 0, y); track.BackgroundColor3 = Color3.new(0.5,0.5,0.5)
				local thumb = Instance.new("TextButton", track); thumb.Size = UDim2.new(0, 10, 0, 16); thumb.BackgroundColor3 = Theme.ButtonFace; thumb.Position = UDim2.new(startV, -5, 0.5, -8); thumb.Text = ""
				local drag = false
				thumb.MouseButton1Down:Connect(function() drag = true end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
				UserInputService.InputChanged:Connect(function(i)
					if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
						local p = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
						thumb.Position = UDim2.new(p, -5, 0.5, -8)
						if colName == "R" then r = p elseif colName == "G" then g = p else b = p end
						local nc = Color3.new(r, g, b); preview.BackgroundColor3 = nc; callback(nc)
					end
				end)
			end
			colSlider(35, r, "R"); colSlider(60, g, "G"); colSlider(85, b, "B")
		end

		function elements:CreateTextBox(text, placeholder, callback)
			local f = Instance.new("Frame", page); f.Size = UDim2.new(1, 0, 0, 50); f.BackgroundTransparency = 1
			local l = Instance.new("TextLabel", f); l.Text = text; l.Size = UDim2.new(1, 0, 0, 20); l.BackgroundTransparency = 1; l.Font = Theme.Font; l.TextSize = 14; l.TextStrokeTransparency = Theme.StrokeTransparency
			local b = Instance.new("TextBox", f); b.Position = UDim2.new(0, 0, 0, 25); b.Size = UDim2.new(0.9, 0, 0, 25); b.BackgroundColor3 = Color3.new(1,1,1)
			b.PlaceholderText = placeholder; b.Text = ""; b.Font = Theme.Font; b.TextSize = 14; b.TextColor3 = Color3.new(0,0,0)
			b.FocusLost:Connect(function() callback(b.Text) end)
		end

		return elements
	end

	return window
end

return Library
