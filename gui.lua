-- Modern GUI Library for Roblox Executors
-- Inspired by Model Executor v3.2 design
-- Сохраните как ModuleScript

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Анимационные константы
local TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local FAST_TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Вспомогательные функции
local function createGradient(parent, color1, color2, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    grad.Rotation = rotation or 135
    grad.Parent = parent
    return grad
end

local function createShadow(parent, transparency, zIndex)
    local shadow = Instance.new("Frame")
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.6
    shadow.BorderSizePixel = 0
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.ZIndex = zIndex or (parent.ZIndex - 1)
    shadow.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, parent:FindFirstChildOfClass("UICorner") and parent.UICorner.CornerRadius.Offset + 4 or 16)
    corner.Parent = shadow
    return shadow
end

-- Главная функция создания окна
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Modern Hub"
    local themeColor = config.ThemeColor or Color3.fromRGB(80, 120, 255)
    local accentColor = config.AccentColor or Color3.fromRGB(60, 90, 200)
    local minimizable = config.Minimizable ~= false
    local draggable = config.Draggable ~= false

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = windowName .. "_GUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 550, 0, 380)
    MainFrame.Active = draggable
    MainFrame.Draggable = draggable
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = MainFrame

    createShadow(MainFrame, 0.7, 0)

    -- Заголовок (градиентный)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = themeColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = TitleBar
    createGradient(TitleBar, themeColor, accentColor, 135)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextStrokeTransparency = 0.8

-- Кнопки управления
local function createWindowButton(text, color, positionOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = TitleBar
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, positionOffset, 0.5, -15)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, FAST_TWEEN, {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.2)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, FAST_TWEEN, {BackgroundColor3 = color}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Мини-кнопка (создаётся заранее, но будет показана при сворачивании)
local MiniButton
if minimizable then
    MiniButton = Instance.new("TextButton")
    MiniButton.Name = "MiniButton"
    MiniButton.Parent = ScreenGui
    MiniButton.BackgroundColor3 = themeColor
    MiniButton.BorderSizePixel = 0
    MiniButton.Size = UDim2.new(0, 54, 0, 54)
    MiniButton.Position = UDim2.new(0.1, 0, 0.8, 0)
    MiniButton.Text = ""
    MiniButton.AutoButtonColor = false
    MiniButton.Visible = false
    MiniButton.Active = true
    MiniButton.Draggable = true
    MiniButton.ZIndex = 10

    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 12)
    miniCorner.Parent = MiniButton

    createGradient(MiniButton, themeColor, accentColor, 135)
    createShadow(MiniButton, 0.6, 9)

    MiniButton.MouseEnter:Connect(function()
        TweenService:Create(MiniButton, FAST_TWEEN, {BackgroundColor3 = themeColor:Lerp(Color3.fromRGB(255,255,255), 0.2)}):Play()
    end)
    MiniButton.MouseLeave:Connect(function()
        TweenService:Create(MiniButton, FAST_TWEEN, {BackgroundColor3 = themeColor}):Play()
    end)

    -- При клике на мини-кнопку показываем главное окно и скрываем мини-кнопку
    MiniButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MiniButton.Visible = false
        -- Анимация появления главного окна
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TWEEN_INFO, {Size = originalSize}):Play()
    end)
end

-- Кнопка сворачивания (скрывает окно и показывает мини-кнопку)
local MinimizeButton = createWindowButton("−", Color3.fromRGB(255, 180, 40), -75, function()
    if minimizable and MiniButton then
        MainFrame.Visible = false
        MiniButton.Visible = true
        -- Анимация появления мини-кнопки
        MiniButton.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MiniButton, TWEEN_INFO, {Size = UDim2.new(0, 54, 0, 54)}):Play()
    end
end)

-- Кнопка закрытия (полностью удаляет GUI)
local CloseButton = createWindowButton("✕", Color3.fromRGB(255, 80, 80), -40, function()
    ScreenGui:Destroy()
end)
    
    -- Переменные для вкладок
    local tabs = {}
    local activeTab = nil

    -- Мини-кнопка (как в примере)
    local MiniButton
    if minimizable then
        MiniButton = Instance.new("TextButton")
        MiniButton.Name = "MiniButton"
        MiniButton.Parent = ScreenGui
        MiniButton.BackgroundColor3 = themeColor
        MiniButton.BorderSizePixel = 0
        MiniButton.Size = UDim2.new(0, 54, 0, 54)
        MiniButton.Position = UDim2.new(0.1, 0, 0.8, 0)
        MiniButton.Text = ""
        MiniButton.AutoButtonColor = false
        MiniButton.Visible = false
        MiniButton.Active = true
        MiniButton.Draggable = true
        MiniButton.ZIndex = 10

        local miniCorner = Instance.new("UICorner")
        miniCorner.CornerRadius = UDim.new(0, 12)
        miniCorner.Parent = MiniButton

        createGradient(MiniButton, themeColor, accentColor, 135)
        createShadow(MiniButton, 0.6, 9)

        MiniButton.MouseEnter:Connect(function()
            TweenService:Create(MiniButton, FAST_TWEEN, {BackgroundColor3 = themeColor:Lerp(Color3.fromRGB(255,255,255), 0.2)}):Play()
        end)
        MiniButton.MouseLeave:Connect(function()
            TweenService:Create(MiniButton, FAST_TWEEN, {BackgroundColor3 = themeColor}):Play()
        end)
        MiniButton.MouseButton1Click:Connect(function()
            MainFrame.Visible = true
            MiniButton.Visible = false
            -- Анимация появления
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, TWEEN_INFO, {Size = originalSize}):Play()
        end)
    end

    -- Функция создания вкладки
    function Library:CreateTab(tabName, iconId)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "_Tab"
        tabButton.Parent = TabPanel
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, -20, 0, 42)
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.ZIndex = 2

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = tabButton

        -- Иконка (если указана)
        if iconId then
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 24, 0, 24)
            icon.Position = UDim2.new(0, 12, 0.5, -12)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://" .. iconId
            icon.ImageColor3 = Color3.fromRGB(220, 220, 220)
            icon.Parent = tabButton
        end

        -- Текст
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -30, 1, 0)
        tabLabel.Position = UDim2.new(0, iconId and 45 or 15, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabName
        tabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Font = Enum.Font.GothamSemibold
        tabLabel.TextSize = 15
        tabLabel.Parent = tabButton

        -- Контент вкладки (ScrollingFrame)
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "_Content"
        tabContent.Parent = ContentArea
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = themeColor
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollingEnabled = true

        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 10)
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Parent = tabContent

        -- Анимации при наведении
        tabButton.MouseEnter:Connect(function()
            if activeTab and activeTab.Button == tabButton then return end
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
        end)
        tabButton.MouseLeave:Connect(function()
            if activeTab and activeTab.Button == tabButton then return end
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
        end)

        -- Переключение вкладок
        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                activeTab.Content.Visible = false
                TweenService:Create(activeTab.Button, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
            end
            tabContent.Visible = true
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = themeColor}):Play()
            activeTab = { Button = tabButton, Content = tabContent }
        end)

        -- Активируем первую вкладку
        if not activeTab then
            tabContent.Visible = true
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = themeColor}):Play()
            activeTab = { Button = tabButton, Content = tabContent }
        end

        table.insert(tabs, {Button = tabButton, Content = tabContent})

        -- Объект вкладки для создания секций
        local tabObj = {}
        
        function tabObj:CreateSection(sectionName)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = sectionName .. "_Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 35)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Parent = tabContent

            -- Заголовок секции
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 28)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = sectionName
            sectionLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 16
            sectionLabel.Parent = sectionFrame

            -- Линия-разделитель
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, 28)
            line.BackgroundColor3 = themeColor
            line.BackgroundTransparency = 0.4
            line.BorderSizePixel = 0
            line.Parent = sectionFrame

            -- Контейнер для элементов
            local elementContainer = Instance.new("Frame")
            elementContainer.Name = "ElementContainer"
            elementContainer.Size = UDim2.new(1, 0, 0, 10)
            elementContainer.Position = UDim2.new(0, 0, 0, 35)
            elementContainer.BackgroundTransparency = 1
            elementContainer.Parent = sectionFrame

            local elementList = Instance.new("UIListLayout")
            elementList.Padding = UDim.new(0, 10)
            elementList.SortOrder = Enum.SortOrder.LayoutOrder
            elementList.Parent = elementContainer

            local function updateSectionSize()
                local totalHeight = 0
                for _, child in ipairs(elementContainer:GetChildren()) do
                    if child:IsA("Frame") then
                        totalHeight = totalHeight + child.Size.Y.Offset + elementList.Padding.Offset
                    end
                end
                elementContainer.Size = UDim2.new(1, 0, 0, totalHeight)
                sectionFrame.Size = UDim2.new(1, 0, 0, totalHeight + 40)
            end

            local sectionObj = {}

            -- Кнопка
            function sectionObj:CreateButton(config)
                local btnFrame = Instance.new("Frame")
                btnFrame.Size = UDim2.new(1, 0, 0, 45)
                btnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                btnFrame.BackgroundTransparency = 0.3
                btnFrame.BorderSizePixel = 0
                btnFrame.Parent = elementContainer

                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent = btnFrame

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = config.Name or "Button"
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 15
                btn.TextStrokeTransparency = 0.9
                btn.Parent = btnFrame

                -- Эффекты при наведении
                btn.MouseEnter:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundTransparency = 0.1}):Play()
                    if not btnFrame:FindFirstChildOfClass("UIGradient") then
                        createGradient(btnFrame, themeColor, accentColor, 90)
                    end
                    btnFrame.UIGradient.Enabled = true
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundTransparency = 0.3}):Play()
                    if btnFrame:FindFirstChildOfClass("UIGradient") then
                        btnFrame.UIGradient.Enabled = false
                    end
                end)

                btn.MouseButton1Click:Connect(function()
                    if config.Callback then config.Callback() end
                end)

                updateSectionSize()
                return btn
            end

            -- Тоггл
            function sectionObj:CreateToggle(config)
                local togFrame = Instance.new("Frame")
                togFrame.Size = UDim2.new(1, 0, 0, 45)
                togFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                togFrame.BackgroundTransparency = 0.3
                togFrame.BorderSizePixel = 0
                togFrame.Parent = elementContainer

                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent = togFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.7, 0, 1, 0)
                label.Position = UDim2.new(0, 15, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = config.Name or "Toggle"
                label.TextColor3 = Color3.fromRGB(240, 240, 240)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.GothamSemibold
                label.TextSize = 15
                label.Parent = togFrame

                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 50, 0, 24)
                toggleBtn.Position = UDim2.new(1, -65, 0.5, -12)
                toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Text = ""
                toggleBtn.AutoButtonColor = false
                toggleBtn.Parent = togFrame

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 12)
                btnCorner.Parent = toggleBtn

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.Position = UDim2.new(0, 3, 0.5, -9)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0
                knob.Parent = toggleBtn

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0, 9)
                knobCorner.Parent = knob

                local isOn = config.Default or false
                local function updateToggle()
                    if isOn then
                        TweenService:Create(toggleBtn, FAST_TWEEN, {BackgroundColor3 = themeColor}):Play()
                        TweenService:Create(knob, FAST_TWEEN, {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
                    else
                        TweenService:Create(toggleBtn, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
                        TweenService:Create(knob, FAST_TWEEN, {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
                    end
                    if config.Callback then config.Callback(isOn) end
                end

                toggleBtn.MouseButton1Click:Connect(function()
                    isOn = not isOn
                    updateToggle()
                end)

                updateToggle()
                updateSectionSize()
                return { Set = function(v) isOn = v; updateToggle() end }
            end

            -- Слайдер
            function sectionObj:CreateSlider(config)
                local sldFrame = Instance.new("Frame")
                sldFrame.Size = UDim2.new(1, 0, 0, 65)
                sldFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                sldFrame.BackgroundTransparency = 0.3
                sldFrame.BorderSizePixel = 0
                sldFrame.Parent = elementContainer

                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent = sldFrame

                local titleLabel = Instance.new("TextLabel")
                titleLabel.Size = UDim2.new(1, -60, 0, 25)
                titleLabel.Position = UDim2.new(0, 15, 0, 8)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = config.Name or "Slider"
                titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.Font = Enum.Font.GothamSemibold
                titleLabel.TextSize = 15
                titleLabel.Parent = sldFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 40, 0, 25)
                valueLabel.Position = UDim2.new(1, -45, 0, 8)
                valueLabel.BackgroundTransparency = 1
                valueLabel.TextColor3 = themeColor
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextSize = 14
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = sldFrame

                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -30, 0, 6)
                sliderBg.Position = UDim2.new(0, 15, 0, 40)
                sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                sliderBg.BorderSizePixel = 0
                sliderBg.Parent = sldFrame

                local bgCorner = Instance.new("UICorner")
                bgCorner.CornerRadius = UDim.new(0, 3)
                bgCorner.Parent = sliderBg

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = themeColor
                fill.BorderSizePixel = 0
                fill.Parent = sliderBg

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 3)
                fillCorner.Parent = fill

                createGradient(fill, themeColor, accentColor, 0)

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 14, 0, 14)
                knob.Position = UDim2.new(0, -7, 0.5, -7)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0
                knob.Parent = sliderBg

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0, 7)
                knobCorner.Parent = knob

                local sliderBtn = Instance.new("TextButton")
                sliderBtn.Size = UDim2.new(1, -30, 0, 20)
                sliderBtn.Position = UDim2.new(0, 15, 0, 33)
                sliderBtn.BackgroundTransparency = 1
                sliderBtn.Text = ""
                sliderBtn.Parent = sldFrame

                local minVal = config.Min or 0
                local maxVal = config.Max or 100
                local current = config.Default or minVal
                local inc = config.Increment or 1
                local suffix = config.Suffix or ""

                local function updateSlider(val)
                    local percent = (val - minVal) / (maxVal - minVal)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    knob.Position = UDim2.new(percent, -7, 0.5, -7)
                    valueLabel.Text = tostring(val) .. suffix
                    titleLabel.Text = config.Name .. " (" .. val .. suffix .. ")"
                    if config.Callback then config.Callback(val) end
                end

                local function setFromPos(x)
                    local relX = math.clamp(x - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
                    local percent = relX / sliderBg.AbsoluteSize.X
                    local raw = minVal + (maxVal - minVal) * percent
                    local newVal = math.floor(raw / inc + 0.5) * inc
                    newVal = math.clamp(newVal, minVal, maxVal)
                    current = newVal
                    updateSlider(current)
                end

                sliderBtn.MouseButton1Down:Connect(function()
                    setFromPos(UserInputService:GetMouseLocation().X)
                    local conn
                    conn = RunService.RenderStepped:Connect(function()
                        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            conn:Disconnect()
                        else
                            setFromPos(UserInputService:GetMouseLocation().X)
                        end
                    end)
                end)

                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        setFromPos(input.Position.X)
                        local conn
                        conn = RunService.RenderStepped:Connect(function()
                            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                                conn:Disconnect()
                            else
                                setFromPos(UserInputService:GetMouseLocation().X)
                            end
                        end)
                    end
                end)

                updateSlider(current)
                updateSectionSize()
                return { Set = function(v) current = math.clamp(v, minVal, maxVal); updateSlider(current) end }
            end

            -- Выпадающий список
            function sectionObj:CreateDropdown(config)
                local ddFrame = Instance.new("Frame")
                ddFrame.Size = UDim2.new(1, 0, 0, 45)
                ddFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                ddFrame.BackgroundTransparency = 0.3
                ddFrame.BorderSizePixel = 0
                ddFrame.ClipsDescendants = false
                ddFrame.Parent = elementContainer

                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent = ddFrame

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = config.Name .. ": " .. (config.CurrentOption or config.Options[1])
                btn.TextColor3 = Color3.fromRGB(240, 240, 240)
                btn.Font = Enum.Font.GothamSemibold
                btn.TextSize = 15
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = ddFrame

                local padding = Instance.new("UIPadding")
                padding.PaddingLeft = UDim.new(0, 15)
                padding.Parent = btn

                local arrow = Instance.new("ImageLabel")
                arrow.Size = UDim2.new(0, 20, 0, 20)
                arrow.Position = UDim2.new(1, -25, 0.5, -10)
                arrow.BackgroundTransparency = 1
                arrow.Image = "rbxassetid://6031068421"
                arrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
                arrow.Rotation = 90
                arrow.Parent = ddFrame

                local optsFrame = Instance.new("Frame")
                optsFrame.Size = UDim2.new(1, 0, 0, 0)
                optsFrame.Position = UDim2.new(0, 0, 1, 5)
                optsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                optsFrame.BorderSizePixel = 0
                optsFrame.ClipsDescendants = true
                optsFrame.Visible = false
                optsFrame.ZIndex = 5
                optsFrame.Parent = ddFrame

                local optsCorner = Instance.new("UICorner")
                optsCorner.CornerRadius = UDim.new(0, 8)
                optsCorner.Parent = optsFrame

                local optsList = Instance.new("UIListLayout")
                optsList.Parent = optsFrame

                local selected = config.CurrentOption or config.Options[1]

                btn.MouseButton1Click:Connect(function()
                    optsFrame.Visible = not optsFrame.Visible
                    arrow.Rotation = optsFrame.Visible and -90 or 90
                    if optsFrame.Visible then
                        optsFrame.Size = UDim2.new(1, 0, 0, #config.Options * 35)
                    end
                end)

                for _, opt in ipairs(config.Options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 35)
                    optBtn.BackgroundTransparency = 1
                    optBtn.Text = opt
                    optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    optBtn.Font = Enum.Font.Gotham
                    optBtn.TextSize = 14
                    optBtn.Parent = optsFrame

                    optBtn.MouseEnter:Connect(function()
                        TweenService:Create(optBtn, FAST_TWEEN, {BackgroundColor3 = themeColor, BackgroundTransparency = 0.7}):Play()
                    end)
                    optBtn.MouseLeave:Connect(function()
                        TweenService:Create(optBtn, FAST_TWEEN, {BackgroundTransparency = 1}):Play()
                    end)

                    optBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        btn.Text = config.Name .. ": " .. opt
                        optsFrame.Visible = false
                        arrow.Rotation = 90
                        if config.Callback then config.Callback(opt) end
                    end)
                end

                updateSectionSize()
                return { Set = function(opt) selected = opt; btn.Text = config.Name .. ": " .. opt; if config.Callback then config.Callback(opt) end end }
            end

            return sectionObj
        end

        return tabObj
    end

    -- Метод уведомления
    function Library:Notify(config)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 300, 0, 70)
        notif.Position = UDim2.new(1, -310, 0, 20)
        notif.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.ZIndex = 20
        notif.Parent = ScreenGui

        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notif

        createGradient(notif, themeColor, accentColor, 135)
        notif.UIGradient.Enabled = true

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -30, 0, 25)
        title.Position = UDim2.new(0, 15, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = config.Title or "Notification"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.ZIndex = 21
        title.Parent = notif

        local content = Instance.new("TextLabel")
        content.Size = UDim2.new(1, -30, 0, 20)
        content.Position = UDim2.new(0, 15, 0, 40)
        content.BackgroundTransparency = 1
        content.Text = config.Content or "This is a notification"
        content.TextColor3 = Color3.fromRGB(220, 220, 220)
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.Font = Enum.Font.Gotham
        content.TextSize = 13
        content.ZIndex = 21
        content.Parent = notif

        -- Анимация
        notif.Position = UDim2.new(1, 20, 0, 20)
        TweenService:Create(notif, TWEEN_INFO, {Position = UDim2.new(1, -310, 0, 20)}):Play()
        task.wait(config.Duration or 4)
        TweenService:Create(notif, TWEEN_INFO, {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.3)
        notif:Destroy()
    end

    -- Показать окно с анимацией
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TWEEN_INFO, {Size = originalSize}):Play()

    -- Показать мини-кнопку при закрытии
    if minimizable then
        CloseButton.MouseButton1Click:Connect(function()
            if MiniButton then
                MiniButton.Visible = true
                -- Анимация появления мини-кнопки
                MiniButton.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(MiniButton, TWEEN_INFO, {Size = UDim2.new(0, 54, 0, 54)}):Play()
            end
        end)
    end

    return Library
end

return Library
