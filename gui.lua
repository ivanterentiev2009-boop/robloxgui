-- Beautiful Roblox GUI Library for Cheating
-- Сохраните этот код как ModuleScript, например, "BeautifulLibrary"

local BeautifulLibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Настройки анимации
local TWEEN_PROPERTIES = {
    TweenStyle = Enum.EasingStyle.Quad,
    TweenDirection = Enum.EasingDirection.Out,
    TweenTime = 0.25
}

-- Создаем основной GUI
function BeautifulLibrary:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Beautiful Cheats"
    local ThemeColor = config.ThemeColor or Color3.fromRGB(255, 100, 150)
    local AccentColor = config.AccentColor or Color3.fromRGB(100, 150, 255)

    -- Главный ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = WindowName .. "_GUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Скругление углов
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Тень
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 30, 1, 30)
    DropShadow.ZIndex = 0
    DropShadow.Image = "rbxassetid://6014261993"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 49, 49)
    DropShadow.SliceScale = 0.5
    DropShadow.Parent = MainFrame

    -- Заголовок окна
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = ThemeColor
    TitleBar.BackgroundTransparency = 0.7
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = WindowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.Parent = TitleBar

    -- Контейнер для вкладок
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TabContainer.BackgroundTransparency = 0.3
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.Name = "TabList"
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.Parent = TabContainer

    -- Контейнер для контента
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -120, 1, -40)
    ContentContainer.Position = UDim2.new(0, 120, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    ContentPadding.Parent = ContentContainer

    -- Переменные для перетаскивания
    local dragging = false
    local dragStartPos = nil
    local frameStartPos = nil

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStartPos = input.Position
            frameStartPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStartPos
            MainFrame.Position = UDim2.new(
                frameStartPos.X.Scale,
                frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale,
                frameStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Таблицы для хранения вкладок и секций
    local tabs = {}
    local activeTab = nil
    local sections = {}

    -- Функция создания вкладки
    function BeautifulLibrary:CreateTab(tabName, iconId)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "_Tab"
        tabButton.Size = UDim2.new(1, -20, 0, 40)
        tabButton.BackgroundColor3 = AccentColor
        tabButton.BackgroundTransparency = 0.8
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 14
        tabButton.Parent = TabContainer

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "_Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = AccentColor
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = ContentContainer

        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 10)
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Parent = tabContent

        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                activeTab.Content.Visible = false
                activeTab.Button.BackgroundTransparency = 0.8
            end
            tabContent.Visible = true
            tabButton.BackgroundTransparency = 0.4
            activeTab = { Button = tabButton, Content = tabContent }
        end)

        if not activeTab then
            tabContent.Visible = true
            tabButton.BackgroundTransparency = 0.4
            activeTab = { Button = tabButton, Content = tabContent }
        end

        tabs[tabName] = { Button = tabButton, Content = tabContent }

        -- Возвращаем объект вкладки с методами
        local tabObj = {}
        
        function tabObj:CreateSection(sectionName)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = sectionName .. "_Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 30)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Parent = tabContent

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Name = "SectionLabel"
            sectionLabel.Size = UDim2.new(1, 0, 0, 30)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = sectionName
            sectionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 16
            sectionLabel.Parent = sectionFrame

            local elementContainer = Instance.new("Frame")
            elementContainer.Name = "ElementContainer"
            elementContainer.Size = UDim2.new(1, 0, 0, 10)
            elementContainer.Position = UDim2.new(0, 0, 0, 35)
            elementContainer.BackgroundTransparency = 1
            elementContainer.Parent = sectionFrame

            local elementList = Instance.new("UIListLayout")
            elementList.Padding = UDim.new(0, 8)
            elementList.SortOrder = Enum.SortOrder.LayoutOrder
            elementList.Parent = elementContainer

            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabContent.CanvasSize.Y.Offset + 50)

            -- Обновляем размер контейнера при добавлении элементов
            local function updateCanvasSize()
                local totalHeight = 0
                for _, child in ipairs(elementContainer:GetChildren()) do
                    if child:IsA("Frame") then
                        totalHeight = totalHeight + child.Size.Y.Offset + elementList.Padding.Offset
                    end
                end
                elementContainer.Size = UDim2.new(1, 0, 0, totalHeight)
                sectionFrame.Size = UDim2.new(1, 0, 0, totalHeight + 40)
                tabContent.CanvasSize = UDim2.new(0, 0, 0, tabContent.UIListLayout.AbsoluteContentSize.Y)
            end

            -- Методы для создания элементов
            local sectionObj = {}

            function sectionObj:CreateButton(config)
                local buttonFrame = Instance.new("Frame")
                buttonFrame.Name = "ButtonFrame"
                buttonFrame.Size = UDim2.new(1, 0, 0, 40)
                buttonFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                buttonFrame.BackgroundTransparency = 0.3
                buttonFrame.BorderSizePixel = 0
                buttonFrame.Parent = elementContainer

                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = buttonFrame

                local button = Instance.new("TextButton")
                button.Name = "Button"
                button.Size = UDim2.new(1, 0, 1, 0)
                button.BackgroundTransparency = 1
                button.Text = config.Name or "Button"
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.Font = Enum.Font.GothamSemibold
                button.TextSize = 14
                button.Parent = buttonFrame

                button.MouseButton1Click:Connect(function()
                    if config.Callback then
                        config.Callback()
                    end
                end)

                -- Анимация при наведении
                button.MouseEnter:Connect(function()
                    TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
                end)
                button.MouseLeave:Connect(function()
                    TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
                end)

                updateCanvasSize()
                return button
            end

            function sectionObj:CreateToggle(config)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = "ToggleFrame"
                toggleFrame.Size = UDim2.new(1, 0, 0, 40)
                toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                toggleFrame.BackgroundTransparency = 0.3
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Parent = elementContainer

                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 6)
                toggleCorner.Parent = toggleFrame

                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Name = "ToggleLabel"
                toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                toggleLabel.Position = UDim2.new(0, 10, 0, 0)
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text = config.Name or "Toggle"
                toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Font = Enum.Font.GothamSemibold
                toggleLabel.TextSize = 14
                toggleLabel.Parent = toggleFrame

                local toggleButton = Instance.new("TextButton")
                toggleButton.Name = "ToggleButton"
                toggleButton.Size = UDim2.new(0, 50, 0, 20)
                toggleButton.Position = UDim2.new(1, -60, 0.5, -10)
                toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                toggleButton.BorderSizePixel = 0
                toggleButton.Text = ""
                toggleButton.Parent = toggleFrame

                local toggleCorner2 = Instance.new("UICorner")
                toggleCorner2.CornerRadius = UDim.new(0, 10)
                toggleCorner2.Parent = toggleButton

                local toggleKnob = Instance.new("Frame")
                toggleKnob.Name = "Knob"
                toggleKnob.Size = UDim2.new(0, 16, 0, 16)
                toggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
                toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleKnob.BorderSizePixel = 0
                toggleKnob.Parent = toggleButton

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0, 8)
                knobCorner.Parent = toggleKnob

                local isOn = config.Default or false
                local function updateToggle()
                    if isOn then
                        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
                        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
                        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    if config.Callback then
                        config.Callback(isOn)
                    end
                end

                toggleButton.MouseButton1Click:Connect(function()
                    isOn = not isOn
                    updateToggle()
                end)

                updateToggle()
                updateCanvasSize()
                return {
                    Set = function(value)
                        isOn = value
                        updateToggle()
                    end
                }
            end

            function sectionObj:CreateSlider(config)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "SliderFrame"
                sliderFrame.Size = UDim2.new(1, 0, 0, 60)
                sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                sliderFrame.BackgroundTransparency = 0.3
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Parent = elementContainer

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 6)
                sliderCorner.Parent = sliderFrame

                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "SliderLabel"
                sliderLabel.Size = UDim2.new(1, -20, 0, 20)
                sliderLabel.Position = UDim2.new(0, 10, 0, 5)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = config.Name or "Slider"
                sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Font = Enum.Font.GothamSemibold
                sliderLabel.TextSize = 14
                sliderLabel.Parent = sliderFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "ValueLabel"
                valueLabel.Size = UDim2.new(0, 50, 0, 20)
                valueLabel.Position = UDim2.new(1, -60, 0, 5)
                valueLabel.BackgroundTransparency = 1
                valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                valueLabel.Font = Enum.Font.Gotham
                valueLabel.TextSize = 12
                valueLabel.Parent = sliderFrame

                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "SliderBar"
                sliderBar.Size = UDim2.new(1, -20, 0, 4)
                sliderBar.Position = UDim2.new(0, 10, 0, 35)
                sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                sliderBar.BorderSizePixel = 0
                sliderBar.Parent = sliderFrame

                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(0, 2)
                barCorner.Parent = sliderBar

                local fillBar = Instance.new("Frame")
                fillBar.Name = "FillBar"
                fillBar.Size = UDim2.new(0, 0, 1, 0)
                fillBar.BackgroundColor3 = AccentColor
                fillBar.BorderSizePixel = 0
                fillBar.Parent = sliderBar

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 2)
                fillCorner.Parent = fillBar

                local sliderButton = Instance.new("TextButton")
                sliderButton.Name = "SliderButton"
                sliderButton.Size = UDim2.new(1, 0, 0, 20)
                sliderButton.Position = UDim2.new(0, 10, 0, 27)
                sliderButton.BackgroundTransparency = 1
                sliderButton.Text = ""
                sliderButton.Parent = sliderFrame

                local knob = Instance.new("Frame")
                knob.Name = "Knob"
                knob.Size = UDim2.new(0, 14, 0, 14)
                knob.Position = UDim2.new(0, 0, 0.5, -7)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0
                knob.Parent = sliderButton

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0, 7)
                knobCorner.Parent = knob

                local minVal = config.Min or 0
                local maxVal = config.Max or 100
                local currentVal = config.Default or minVal
                local increment = config.Increment or 1

                local function updateSlider(value)
                    local percent = (value - minVal) / (maxVal - minVal)
                    fillBar.Size = UDim2.new(percent, 0, 1, 0)
                    knob.Position = UDim2.new(percent, -7, 0.5, -7)
                    valueLabel.Text = tostring(value) .. (config.Suffix or "")
                    if config.Callback then
                        config.Callback(value)
                    end
                end

                local function setValueFromPosition(inputX)
                    local relativeX = inputX - sliderBar.AbsolutePosition.X
                    local percent = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
                    local rawValue = minVal + (maxVal - minVal) * percent
                    local newValue = math.floor(rawValue / increment + 0.5) * increment
                    newValue = math.clamp(newValue, minVal, maxVal)
                    currentVal = newValue
                    updateSlider(currentVal)
                end

                sliderButton.MouseButton1Down:Connect(function()
                    setValueFromPosition(UserInputService:GetMouseLocation().X)
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            setValueFromPosition(input.Position.X)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            connection:Disconnect()
                        end
                    end)
                end)

                updateSlider(currentVal)
                updateCanvasSize()
                return {
                    Set = function(value)
                        currentVal = math.clamp(value, minVal, maxVal)
                        updateSlider(currentVal)
                    end
                }
            end

            function sectionObj:CreateDropdown(config)
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = "DropdownFrame"
                dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                dropdownFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                dropdownFrame.BackgroundTransparency = 0.3
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.ClipsDescendants = false
                dropdownFrame.Parent = elementContainer

                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 6)
                dropdownCorner.Parent = dropdownFrame

                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "DropdownButton"
                dropdownButton.Size = UDim2.new(1, 0, 1, 0)
                dropdownButton.BackgroundTransparency = 1
                dropdownButton.Text = config.Name or "Dropdown"
                dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdownButton.Font = Enum.Font.GothamSemibold
                dropdownButton.TextSize = 14
                dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                dropdownButton.Parent = dropdownFrame

                local arrow = Instance.new("ImageLabel")
                arrow.Name = "Arrow"
                arrow.Size = UDim2.new(0, 20, 0, 20)
                arrow.Position = UDim2.new(1, -25, 0.5, -10)
                arrow.BackgroundTransparency = 1
                arrow.Image = "rbxassetid://6031068421"
                arrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
                arrow.Rotation = 90
                arrow.Parent = dropdownFrame

                local optionsFrame = Instance.new("Frame")
                optionsFrame.Name = "OptionsFrame"
                optionsFrame.Size = UDim2.new(1, 0, 0, 0)
                optionsFrame.Position = UDim2.new(0, 0, 1, 5)
                optionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                optionsFrame.BorderSizePixel = 0
                optionsFrame.ClipsDescendants = true
                optionsFrame.Visible = false
                optionsFrame.Parent = dropdownFrame

                local optionsCorner = Instance.new("UICorner")
                optionsCorner.CornerRadius = UDim.new(0, 6)
                optionsCorner.Parent = optionsFrame

                local optionsList = Instance.new("UIListLayout")
                optionsList.Parent = optionsFrame

                local options = {}
                local selectedOption = config.CurrentOption or config.Options[1]

                dropdownButton.MouseButton1Click:Connect(function()
                    optionsFrame.Visible = not optionsFrame.Visible
                    arrow.Rotation = optionsFrame.Visible and -90 or 90
                    if optionsFrame.Visible then
                        optionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
                    end
                end)

                for _, optionName in ipairs(config.Options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Size = UDim2.new(1, 0, 0, 30)
                    optionButton.BackgroundTransparency = 1
                    optionButton.Text = optionName
                    optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 14
                    optionButton.Parent = optionsFrame

                    optionButton.MouseButton1Click:Connect(function()
                        selectedOption = optionName
                        dropdownButton.Text = config.Name .. ": " .. optionName
                        optionsFrame.Visible = false
                        arrow.Rotation = 90
                        if config.Callback then
                            config.Callback(optionName)
                        end
                    end)

                    table.insert(options, optionButton)
                end

                dropdownButton.Text = config.Name .. ": " .. selectedOption
                updateCanvasSize()
                return {
                    Set = function(option)
                        selectedOption = option
                        dropdownButton.Text = config.Name .. ": " .. option
                        if config.Callback then
                            config.Callback(option)
                        end
                    end
                }
            end

            return sectionObj
        end

        return tabObj
    end

    -- Метод для создания уведомления
    function BeautifulLibrary:Notify(config)
        local notificationFrame = Instance.new("Frame")
        notificationFrame.Name = "Notification"
        notificationFrame.Size = UDim2.new(0, 300, 0, 60)
        notificationFrame.Position = UDim2.new(1, -310, 0, 10)
        notificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        notificationFrame.BackgroundTransparency = 0.2
        notificationFrame.BorderSizePixel = 0
        notificationFrame.Parent = ScreenGui

        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notificationFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 25)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = config.Title or "Notification"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 16
        titleLabel.Parent = notificationFrame

        local contentLabel = Instance.new("TextLabel")
        contentLabel.Size = UDim2.new(1, -20, 0, 20)
        contentLabel.Position = UDim2.new(0, 10, 0, 35)
        contentLabel.BackgroundTransparency = 1
        contentLabel.Text = config.Content or "This is a notification"
        contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.TextSize = 12
        contentLabel.Parent = notificationFrame

        local duration = config.Duration or 3
        TweenService:Create(notificationFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, -310, 0, 10)}):Play()
        task.wait(duration)
        TweenService:Create(notificationFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 0, 10)}):Play()
        task.wait(0.5)
        notificationFrame:Destroy()
    end

    return BeautifulLibrary
end

return BeautifulLibrary