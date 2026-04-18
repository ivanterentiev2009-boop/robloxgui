-- Beautiful Roblox GUI Library v2.0
-- Улучшенный дизайн с градиентами, анимациями и размытием фона

local BeautifulLibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Константы для анимаций
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local FAST_TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Вспомогательная функция для создания градиента (UIGradient)
local function createGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

-- Основная функция создания окна
function BeautifulLibrary:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Beautiful Cheats"
    local ThemeColor = config.ThemeColor or Color3.fromRGB(255, 100, 150)
    local AccentColor = config.AccentColor or Color3.fromRGB(100, 150, 255)
    local BackgroundBlur = config.BackgroundBlur ~= false -- по умолчанию размытие включено

    -- Создаём ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = WindowName .. "_GUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Эффект размытия фона
    if BackgroundBlur then
        local Blur = Instance.new("BlurEffect")
        Blur.Size = 10
        Blur.Parent = game:GetService("Lighting")
        -- Удаляем размытие при закрытии GUI (можно добавить метод :Destroy())
        ScreenGui.Destroying:Connect(function()
            Blur:Destroy()
        end)
    end

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Скругление углов
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- Тень окна
    local Shadow = Instance.new("ImageLabel")
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 49, 49)
    Shadow.SliceScale = 0.5
    Shadow.Parent = MainFrame

    -- Градиентный заголовок
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = ThemeColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 16)
    TitleCorner.Parent = TitleBar

    createGradient(TitleBar, ThemeColor, AccentColor, 135)

    -- Название окна
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = WindowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextStrokeTransparency = 0.8
    TitleLabel.Parent = TitleBar

    -- Кнопка сворачивания
    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -40, 0.5, -15)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Image = "rbxassetid://6035067836" -- иконка стрелки вниз
    MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Parent = TitleBar

    local isMinimized = false
    local originalSize = MainFrame.Size
    local minimizedSize = UDim2.new(0, 550, 0, 50)

    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and minimizedSize or originalSize
        TweenService:Create(MainFrame, TWEEN_INFO, {Size = targetSize}):Play()
        MinimizeButton.Image = isMinimized and "rbxassetid://6035047409" or "rbxassetid://6035067836"
        ContentContainer.Visible = not isMinimized
        TabContainer.Visible = not isMinimized
    end)

    -- Контейнер вкладок
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 130, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    TabContainer.BackgroundTransparency = 0.2
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 8)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 15)
    TabPadding.Parent = TabContainer

    -- Контейнер контента
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -130, 1, -50)
    ContentContainer.Position = UDim2.new(0, 130, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    ContentPadding.Parent = ContentContainer

    -- Перетаскивание окна
    local dragging, dragStart, frameStart
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                frameStart.X.Scale, frameStart.X.Offset + delta.X,
                frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
            )
        end
    end)

    -- Хранилище вкладок и секций
    local tabs = {}
    local activeTab = nil

    -- Функция создания вкладки
    function BeautifulLibrary:CreateTab(tabName, iconId)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "_Tab"
        tabButton.Size = UDim2.new(1, -20, 0, 45)
        tabButton.BackgroundColor3 = AccentColor
        tabButton.BackgroundTransparency = 0.85
        tabButton.BorderSizePixel = 0
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.Parent = TabContainer

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 10)
        tabCorner.Parent = tabButton

        -- Иконка (если указана)
        if iconId then
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 24, 0, 24)
            icon.Position = UDim2.new(0, 10, 0.5, -12)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://" .. iconId
            icon.ImageColor3 = Color3.fromRGB(220, 220, 220)
            icon.Parent = tabButton
        end

        -- Текст
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -30, 1, 0)
        tabLabel.Position = UDim2.new(0, iconId and 40 or 15, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabName
        tabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Font = Enum.Font.GothamSemibold
        tabLabel.TextSize = 15
        tabLabel.Parent = tabButton

        -- Контент вкладки
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "_Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = AccentColor
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.ScrollingEnabled = true
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Parent = ContentContainer

        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 10)
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Parent = tabContent

        -- Анимация наведения на кнопку вкладки
        tabButton.MouseEnter:Connect(function()
            if activeTab and activeTab.Button == tabButton then return end
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundTransparency = 0.75}):Play()
        end)
        tabButton.MouseLeave:Connect(function()
            if activeTab and activeTab.Button == tabButton then return end
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundTransparency = 0.85}):Play()
        end)

        -- Переключение вкладок
        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                activeTab.Content.Visible = false
                TweenService:Create(activeTab.Button, FAST_TWEEN, {BackgroundTransparency = 0.85}):Play()
            end
            tabContent.Visible = true
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundTransparency = 0.6}):Play()
            activeTab = { Button = tabButton, Content = tabContent }
        end)

        -- Активируем первую вкладку автоматически
        if not activeTab then
            tabContent.Visible = true
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundTransparency = 0.6}):Play()
            activeTab = { Button = tabButton, Content = tabContent }
        end

        tabs[tabName] = { Button = tabButton, Content = tabContent }

        -- Объект вкладки для создания секций
        local tabObj = {}
        
        function tabObj:CreateSection(sectionName)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = sectionName .. "_Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 35)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Parent = tabContent

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 30)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = sectionName
            sectionLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 18
            sectionLabel.Parent = sectionFrame

            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, 30)
            line.BackgroundColor3 = AccentColor
            line.BackgroundTransparency = 0.5
            line.BorderSizePixel = 0
            line.Parent = sectionFrame

            local elementContainer = Instance.new("Frame")
            elementContainer.Name = "ElementContainer"
            elementContainer.Size = UDim2.new(1, 0, 0, 10)
            elementContainer.Position = UDim2.new(0, 0, 0, 40)
            elementContainer.BackgroundTransparency = 1
            elementContainer.Parent = sectionFrame

            local elementList = Instance.new("UIListLayout")
            elementList.Padding = UDim.new(0, 10)
            elementList.SortOrder = Enum.SortOrder.LayoutOrder
            elementList.Parent = elementContainer

            -- Функция обновления размеров
            local function updateSectionSize()
                local totalHeight = 0
                for _, child in ipairs(elementContainer:GetChildren()) do
                    if child:IsA("Frame") then
                        totalHeight = totalHeight + child.Size.Y.Offset + elementList.Padding.Offset
                    end
                end
                elementContainer.Size = UDim2.new(1, 0, 0, totalHeight)
                sectionFrame.Size = UDim2.new(1, 0, 0, totalHeight + 45)
            end

            local sectionObj = {}

            -- Кнопка
            function sectionObj:CreateButton(config)
                local btnFrame = Instance.new("Frame")
                btnFrame.Size = UDim2.new(1, 0, 0, 45)
                btnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                btnFrame.BackgroundTransparency = 0.4
                btnFrame.BorderSizePixel = 0
                btnFrame.Parent = elementContainer

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btnFrame

                createGradient(btnFrame, ThemeColor, AccentColor, 90)
                btnFrame.UIGradient.Enabled = false

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = config.Name or "Button"
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 15
                btn.TextStrokeTransparency = 0.9
                btn.Parent = btnFrame

                btn.MouseEnter:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundTransparency = 0.2}):Play()
                    btnFrame.UIGradient.Enabled = true
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundTransparency = 0.4}):Play()
                    btnFrame.UIGradient.Enabled = false
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
                togFrame.BackgroundTransparency = 0.4
                togFrame.BorderSizePixel = 0
                togFrame.Parent = elementContainer

                local togCorner = Instance.new("UICorner")
                togCorner.CornerRadius = UDim.new(0, 8)
                togCorner.Parent = togFrame

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
                toggleBtn.Size = UDim2.new(0, 56, 0, 24)
                toggleBtn.Position = UDim2.new(1, -70, 0.5, -12)
                toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Text = ""
                toggleBtn.AutoButtonColor = false
                toggleBtn.Parent = togFrame

                local togBtnCorner = Instance.new("UICorner")
                togBtnCorner.CornerRadius = UDim.new(0, 12)
                togBtnCorner.Parent = toggleBtn

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 20, 0, 20)
                knob.Position = UDim2.new(0, 2, 0.5, -10)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0
                knob.Parent = toggleBtn

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0, 10)
                knobCorner.Parent = knob

                local isOn = config.Default or false
                local function updateToggle()
                    if isOn then
                        TweenService:Create(toggleBtn, FAST_TWEEN, {BackgroundColor3 = AccentColor}):Play()
                        TweenService:Create(knob, FAST_TWEEN, {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
                    else
                        TweenService:Create(toggleBtn, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
                        TweenService:Create(knob, FAST_TWEEN, {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
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
                sldFrame.BackgroundTransparency = 0.4
                sldFrame.BorderSizePixel = 0
                sldFrame.Parent = elementContainer

                local sldCorner = Instance.new("UICorner")
                sldCorner.CornerRadius = UDim.new(0, 8)
                sldCorner.Parent = sldFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -30, 0, 25)
                label.Position = UDim2.new(0, 15, 0, 8)
                label.BackgroundTransparency = 1
                label.Text = config.Name or "Slider"
                label.TextColor3 = Color3.fromRGB(240, 240, 240)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.GothamSemibold
                label.TextSize = 15
                label.Parent = sldFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 50, 0, 25)
                valueLabel.Position = UDim2.new(1, -60, 0, 8)
                valueLabel.BackgroundTransparency = 1
                valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                valueLabel.Font = Enum.Font.Gotham
                valueLabel.TextSize = 13
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = sldFrame

                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(1, -30, 0, 4)
                bar.Position = UDim2.new(0, 15, 0, 42)
                bar.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
                bar.BorderSizePixel = 0
                bar.Parent = sldFrame

                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(0, 2)
                barCorner.Parent = bar

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = AccentColor
                fill.BorderSizePixel = 0
                fill.Parent = bar

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 2)
                fillCorner.Parent = fill

                createGradient(fill, ThemeColor, AccentColor, 0)

                local sliderBtn = Instance.new("TextButton")
                sliderBtn.Size = UDim2.new(1, -30, 0, 20)
                sliderBtn.Position = UDim2.new(0, 15, 0, 34)
                sliderBtn.BackgroundTransparency = 1
                sliderBtn.Text = ""
                sliderBtn.Parent = sldFrame

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 16, 0, 16)
                knob.Position = UDim2.new(0, -8, 0.5, -8)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0
                knob.Parent = sliderBtn

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0, 8)
                knobCorner.Parent = knob

                local minVal = config.Min or 0
                local maxVal = config.Max or 100
                local current = config.Default or minVal
                local inc = config.Increment or 1
                local suffix = config.Suffix or ""

                local function updateSlider(val)
                    local percent = (val - minVal) / (maxVal - minVal)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    knob.Position = UDim2.new(percent, -8, 0.5, -8)
                    valueLabel.Text = tostring(val) .. suffix
                    if config.Callback then config.Callback(val) end
                end

                local function setFromPos(x)
                    local relX = math.clamp(x - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
                    local percent = relX / bar.AbsoluteSize.X
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

                updateSlider(current)
                updateSectionSize()
                return { Set = function(v) current = math.clamp(v, minVal, maxVal); updateSlider(current) end }
            end

            -- Выпадающий список
            function sectionObj:CreateDropdown(config)
                local ddFrame = Instance.new("Frame")
                ddFrame.Size = UDim2.new(1, 0, 0, 45)
                ddFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                ddFrame.BackgroundTransparency = 0.4
                ddFrame.BorderSizePixel = 0
                ddFrame.ClipsDescendants = false
                ddFrame.Parent = elementContainer

                local ddCorner = Instance.new("UICorner")
                ddCorner.CornerRadius = UDim.new(0, 8)
                ddCorner.Parent = ddFrame

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
                        TweenService:Create(optBtn, FAST_TWEEN, {BackgroundColor3 = AccentColor, BackgroundTransparency = 0.7}):Play()
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
    function BeautifulLibrary:Notify(config)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 320, 0, 70)
        notif.Position = UDim2.new(1, -330, 0, 20)
        notif.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.Parent = ScreenGui

        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 12)
        notifCorner.Parent = notif

        createGradient(notif, ThemeColor, AccentColor, 135)
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
        content.Parent = notif

        TweenService:Create(notif, TWEEN_INFO, {Position = UDim2.new(1, -330, 0, 20)}):Play()
        task.wait(config.Duration or 4)
        TweenService:Create(notif, TWEEN_INFO, {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.3)
        notif:Destroy()
    end

    return BeautifulLibrary
end

return BeautifulLibrary
