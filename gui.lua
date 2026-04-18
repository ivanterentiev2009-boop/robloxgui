-- Ultimate Windows XP GUI Library for Roblox
-- Максимально точная копия стиля Luna (исправлены шрифты)
-- Сохраните как ModuleScript

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Анимации (в стиле XP анимации почти нет, оставим плавные для современности)
local TWEEN_INFO = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local FAST_TWEEN = TweenInfo.new(0.1, Enum.EasingStyle.Linear)

-- Цвета Windows XP (Luna Blue)
local XPColors = {
    TitleBarStart = Color3.fromRGB(0, 88, 227),     -- #0058E3 - Начало градиента
    TitleBarEnd = Color3.fromRGB(60, 140, 255),     -- #3C8CFF - Конец градиента
    WindowBackground = Color3.fromRGB(236, 233, 216), -- #ECE9D8 - Фон окна
    TabPanel = Color3.fromRGB(212, 208, 200),        -- #D4D0C8 - Панель вкладок
    Border = Color3.fromRGB(100, 100, 100),          -- #646464 - Границы
    ButtonHighlight = Color3.fromRGB(255, 255, 255), -- #FFFFFF - Подсветка
    ButtonPressed = Color3.fromRGB(200, 200, 200),   -- #C8C8C8 - Нажатая кнопка
    DisabledText = Color3.fromRGB(161, 161, 146),    -- #A1A192 - Текст отключенного элемента
    DisabledFill = Color3.fromRGB(235, 235, 228),    -- #EBEBE4 - Фон отключенного поля
    CheckboxBorder = Color3.fromRGB(0, 0, 0),        -- #000000 - Граница чекбокса
    CheckboxFill = Color3.fromRGB(255, 255, 255),    -- #FFFFFF - Фон чекбокса
    ScrollbarShaft = Color3.fromRGB(212, 208, 200),  -- #D4D0C8 - Фон скроллбара
    ScrollbarThumb = Color3.fromRGB(172, 168, 153),  -- #ACA899 - Ползунок скроллбара
    ScrollbarArrow = Color3.fromRGB(0, 0, 0),        -- #000000 - Стрелки скроллбара
    SliderThumb = Color3.fromRGB(172, 168, 153),     -- #ACA899 - Ползунок слайдера
    GroupBoxBorder = Color3.fromRGB(208, 208, 191),  -- #D0D0BF - Граница групповой рамки
    GroupBoxTitle = Color3.fromRGB(0, 70, 213)       -- #0046D5 - Заголовок групповой рамки
}

-- Вспомогательные функции
local function createShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.9
    shadow.BorderSizePixel = 1
    shadow.BorderColor3 = Color3.fromRGB(64, 64, 64)
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

-- Главная функция создания окна
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "XP Hub"
    local minimizable = config.Minimizable ~= false
    local draggable = config.Draggable ~= false

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = windowName .. "_GUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Главное окно (в стиле XP)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = XPColors.WindowBackground
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = XPColors.Border
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 550, 0, 380)
    MainFrame.Active = draggable
    MainFrame.Draggable = draggable
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true

    local originalSize = MainFrame.Size

    -- Заголовок в стиле Windows XP (синий градиент)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = XPColors.TitleBarStart
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)

    -- Градиент (сверху светлее, снизу темнее)
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, XPColors.TitleBarEnd),
        ColorSequenceKeypoint.new(1, XPColors.TitleBarStart)
    })
    titleGradient.Rotation = 90
    titleGradient.Parent = TitleBar

    -- Иконка приложения (маленький квадратик слева)
    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Parent = TitleBar
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Size = UDim2.new(0, 16, 0, 16)
    TitleIcon.Position = UDim2.new(0, 6, 0.5, -8)
    TitleIcon.Image = "rbxassetid://6031068421"
    TitleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    TitleIcon.ScaleType = Enum.ScaleType.Fit

    -- Название окна
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 28, 0, 0)
    TitleLabel.Font = Enum.Font.SourceSansBold  -- ИСПРАВЛЕНО
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 11
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Контейнер для кнопок управления (справа)
    local WindowControls = Instance.new("Frame")
    WindowControls.Parent = TitleBar
    WindowControls.BackgroundTransparency = 1
    WindowControls.Size = UDim2.new(0, 60, 1, 0)
    WindowControls.Position = UDim2.new(1, -60, 0, 0)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = WindowControls
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 2)

    -- Функция создания кнопки управления в стиле XP
    local function createXPControlButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = XPColors.ButtonHighlight
        btn.BackgroundTransparency = 0.8
        btn.BorderSizePixel = 1
        btn.BorderColor3 = XPColors.ButtonHighlight
        btn.Size = UDim2.new(0, 24, 0, 20)
        btn.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.AutoButtonColor = false
        btn.Parent = WindowControls

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, FAST_TWEEN, {
                BackgroundTransparency = 0.4,
                BorderColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, FAST_TWEEN, {
                BackgroundTransparency = 0.8,
                BorderColor3 = XPColors.ButtonHighlight
            }):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Мини-кнопка (создаётся заранее, показывается при сворачивании)
    local MiniButton
    if minimizable then
        MiniButton = Instance.new("TextButton")
        MiniButton.Name = "MiniButton"
        MiniButton.Parent = ScreenGui
        MiniButton.BackgroundColor3 = XPColors.TitleBarStart
        MiniButton.BorderSizePixel = 1
        MiniButton.BorderColor3 = XPColors.Border
        MiniButton.Size = UDim2.new(0, 48, 0, 48)
        MiniButton.Position = UDim2.new(0.1, 0, 0.8, 0)
        MiniButton.Text = ""
        MiniButton.AutoButtonColor = false
        MiniButton.Visible = false
        MiniButton.Active = true
        MiniButton.Draggable = true
        MiniButton.ZIndex = 10

        -- Градиент мини-кнопки
        local miniGrad = Instance.new("UIGradient")
        miniGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, XPColors.TitleBarEnd),
            ColorSequenceKeypoint.new(1, XPColors.TitleBarStart)
        })
        miniGrad.Rotation = 90
        miniGrad.Parent = MiniButton

        -- Иконка (окно)
        local miniIcon = Instance.new("ImageLabel")
        miniIcon.BackgroundTransparency = 1
        miniIcon.Size = UDim2.new(0, 24, 0, 24)
        miniIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
        miniIcon.Image = "rbxassetid://6026568198"
        miniIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        miniIcon.Parent = MiniButton

        createShadow(MiniButton)

        MiniButton.MouseEnter:Connect(function()
            TweenService:Create(MiniButton, FAST_TWEEN, {
                BackgroundColor3 = XPColors.TitleBarStart:Lerp(Color3.fromRGB(255,255,255), 0.2)
            }):Play()
        end)
        MiniButton.MouseLeave:Connect(function()
            TweenService:Create(MiniButton, FAST_TWEEN, {
                BackgroundColor3 = XPColors.TitleBarStart
            }):Play()
        end)

        -- При клике на мини-кнопку показываем главное окно
        MiniButton.MouseButton1Click:Connect(function()
            MainFrame.Visible = true
            MiniButton.Visible = false
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, TWEEN_INFO, {Size = originalSize}):Play()
        end)
    end

    -- Кнопка сворачивания
    local MinimizeButton = createXPControlButton("–", function()
        if minimizable and MiniButton then
            MainFrame.Visible = false
            MiniButton.Visible = true
            MiniButton.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MiniButton, TWEEN_INFO, {Size = UDim2.new(0, 48, 0, 48)}):Play()
        end
    end)

    -- Кнопка закрытия
    local CloseButton = createXPControlButton("✕", function()
        TweenService:Create(MainFrame, TWEEN_INFO, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.15)
        ScreenGui:Destroy()
    end)

    -- Панель вкладок (слева) в стиле XP
    local TabPanel = Instance.new("Frame")
    TabPanel.Name = "TabPanel"
    TabPanel.Parent = MainFrame
    TabPanel.BackgroundColor3 = XPColors.TabPanel
    TabPanel.BorderSizePixel = 1
    TabPanel.BorderColor3 = XPColors.Border
    TabPanel.Size = UDim2.new(0, 140, 1, -30)
    TabPanel.Position = UDim2.new(0, 0, 0, 30)

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 2)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabPanel

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 6)
    TabPadding.PaddingBottom = UDim.new(0, 6)
    TabPadding.Parent = TabPanel

    -- Область контента
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundColor3 = XPColors.WindowBackground
    ContentArea.BorderSizePixel = 0
    ContentArea.Size = UDim2.new(1, -140, 1, -30)
    ContentArea.Position = UDim2.new(0, 140, 0, 30)

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 8)
    ContentPadding.PaddingRight = UDim.new(0, 8)
    ContentPadding.PaddingTop = UDim.new(0, 8)
    ContentPadding.PaddingBottom = UDim.new(0, 8)
    ContentPadding.Parent = ContentArea

    -- Переменные для вкладок
    local tabs = {}
    local activeTab = nil

    -- Функция создания вкладки
    function Library:CreateTab(tabName, iconId)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "_Tab"
        tabButton.Parent = TabPanel
        tabButton.BackgroundColor3 = XPColors.WindowBackground
        tabButton.BorderSizePixel = 1
        tabButton.BorderColor3 = XPColors.Border
        tabButton.Size = UDim2.new(1, -8, 0, 32)
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.ZIndex = 2

        if iconId then
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 20, 0, 20)
            icon.Position = UDim2.new(0, 8, 0.5, -10)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://" .. iconId
            icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
            icon.Parent = tabButton
        end

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -20, 1, 0)
        tabLabel.Position = UDim2.new(0, iconId and 36 or 12, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabName
        tabLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
        tabLabel.TextSize = 11
        tabLabel.Parent = tabButton

        -- Контент вкладки (ScrollingFrame) с новым скроллбаром
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "_Content"
        tabContent.Parent = ContentArea
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 17
        tabContent.ScrollBarImageColor3 = XPColors.ScrollbarThumb
        tabContent.ScrollBarImageTransparency = 0
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollingEnabled = true
        
        -- Настройка фона скроллбара
        local scrollbar = Instance.new("Frame")
        scrollbar.Name = "ScrollbarBackground"
        scrollbar.BackgroundColor3 = XPColors.ScrollbarShaft
        scrollbar.BorderSizePixel = 1
        scrollbar.BorderColor3 = XPColors.Border
        scrollbar.Size = UDim2.new(1, 0, 1, 0)
        scrollbar.Visible = false
        scrollbar.Parent = tabContent
        
        -- Кнопки скроллбара (вверх/вниз)
        local upArrow = Instance.new("ImageButton")
        upArrow.Name = "UpArrow"
        upArrow.Size = UDim2.new(1, 0, 0, 17)
        upArrow.Position = UDim2.new(0, 0, 0, 0)
        upArrow.BackgroundColor3 = XPColors.ButtonHighlight
        upArrow.BorderSizePixel = 1
        upArrow.BorderColor3 = XPColors.Border
        upArrow.Image = "rbxassetid://6031068421"
        upArrow.ImageColor3 = XPColors.ScrollbarArrow
        upArrow.Rotation = 0
        upArrow.Parent = scrollbar
        
        local downArrow = Instance.new("ImageButton")
        downArrow.Name = "DownArrow"
        downArrow.Size = UDim2.new(1, 0, 0, 17)
        downArrow.Position = UDim2.new(0, 0, 1, -17)
        downArrow.BackgroundColor3 = XPColors.ButtonHighlight
        downArrow.BorderSizePixel = 1
        downArrow.BorderColor3 = XPColors.Border
        downArrow.Image = "rbxassetid://6031068421"
        downArrow.ImageColor3 = XPColors.ScrollbarArrow
        downArrow.Rotation = 180
        downArrow.Parent = scrollbar

        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 8)
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Parent = tabContent

        -- Анимации при наведении
        tabButton.MouseEnter:Connect(function()
            if activeTab and activeTab.Button == tabButton then return end
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = XPColors.ButtonHighlight}):Play()
        end)
        tabButton.MouseLeave:Connect(function()
            if activeTab and activeTab.Button == tabButton then return end
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = XPColors.WindowBackground}):Play()
        end)

        -- Переключение вкладок
        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                activeTab.Content.Visible = false
                TweenService:Create(activeTab.Button, FAST_TWEEN, {BackgroundColor3 = XPColors.WindowBackground}):Play()
            end
            tabContent.Visible = true
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = XPColors.ButtonHighlight}):Play()
            activeTab = { Button = tabButton, Content = tabContent }
        end)

        -- Активируем первую вкладку
        if not activeTab then
            tabContent.Visible = true
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = XPColors.ButtonHighlight}):Play()
            activeTab = { Button = tabButton, Content = tabContent }
        end

        table.insert(tabs, {Button = tabButton, Content = tabContent})

        -- Объект вкладки для создания секций
        local tabObj = {}
        
        function tabObj:CreateSection(sectionName)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = sectionName .. "_Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 30)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Parent = tabContent

            -- Заголовок секции (как в групповых рамках XP)
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 24)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = sectionName
            sectionLabel.TextColor3 = XPColors.GroupBoxTitle
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Font = Enum.Font.SourceSansBold  -- ИСПРАВЛЕНО
            sectionLabel.TextSize = 11
            sectionLabel.Parent = sectionFrame

            -- Линия-разделитель (тонкая, как в XP)
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, 24)
            line.BackgroundColor3 = XPColors.GroupBoxBorder
            line.BorderSizePixel = 0
            line.Parent = sectionFrame

            -- Контейнер для элементов
            local elementContainer = Instance.new("Frame")
            elementContainer.Name = "ElementContainer"
            elementContainer.Size = UDim2.new(1, 0, 0, 10)
            elementContainer.Position = UDim2.new(0, 0, 0, 30)
            elementContainer.BackgroundTransparency = 1
            elementContainer.Parent = sectionFrame

            local elementList = Instance.new("UIListLayout")
            elementList.Padding = UDim.new(0, 6)
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
                sectionFrame.Size = UDim2.new(1, 0, 0, totalHeight + 35)
            end

            local sectionObj = {}

            -- Кнопка в стиле XP (размер 75x23)
            function sectionObj:CreateButton(config)
                local btnFrame = Instance.new("Frame")
                btnFrame.Size = UDim2.new(0, 75, 0, 23)
                btnFrame.BackgroundColor3 = XPColors.ButtonHighlight
                btnFrame.BorderSizePixel = 1
                btnFrame.BorderColor3 = XPColors.Border
                btnFrame.Parent = elementContainer

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = config.Name or "Button"
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                btn.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
                btn.TextSize = 11
                btn.Parent = btnFrame
                
                -- Состояния кнопки
                btn.MouseEnter:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(240, 240, 240)}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundColor3 = XPColors.ButtonHighlight}):Play()
                end)
                btn.MouseButton1Down:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundColor3 = XPColors.ButtonPressed}):Play()
                    btn.Position = UDim2.new(0, 1, 0, 1)
                end)
                btn.MouseButton1Up:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundColor3 = XPColors.ButtonHighlight}):Play()
                    btn.Position = UDim2.new(0, 0, 0, 0)
                end)
                btn.MouseButton1Click:Connect(function()
                    if config.Callback then config.Callback() end
                end)

                updateSectionSize()
                return btn
            end

            -- Тоггл (чекбокс в стиле XP, размер 16x16)
            function sectionObj:CreateToggle(config)
                local togFrame = Instance.new("Frame")
                togFrame.Size = UDim2.new(1, 0, 0, 22)
                togFrame.BackgroundTransparency = 1
                togFrame.Parent = elementContainer

                local checkBox = Instance.new("ImageButton")
                checkBox.Size = UDim2.new(0, 16, 0, 16)
                checkBox.Position = UDim2.new(0, 0, 0.5, -8)
                checkBox.BackgroundColor3 = XPColors.CheckboxFill
                checkBox.BorderSizePixel = 1
                checkBox.BorderColor3 = XPColors.CheckboxBorder
                checkBox.Image = ""
                checkBox.AutoButtonColor = false
                checkBox.Parent = togFrame

                local checkMark = Instance.new("ImageLabel")
                checkMark.Size = UDim2.new(0, 10, 0, 10)
                checkMark.Position = UDim2.new(0.5, -5, 0.5, -5)
                checkMark.BackgroundTransparency = 1
                checkMark.Image = "rbxassetid://6031068421"
                checkMark.ImageColor3 = Color3.fromRGB(0, 0, 0)
                checkMark.Visible = false
                checkMark.Parent = checkBox

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -24, 1, 0)
                label.Position = UDim2.new(0, 24, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = config.Name or "Toggle"
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
                label.TextSize = 11
                label.Parent = togFrame

                local isOn = config.Default or false
                local isEnabled = config.Enabled ~= false
                
                local function updateToggle()
                    checkMark.Visible = isOn
                    if not isEnabled then
                        checkBox.BorderColor3 = XPColors.DisabledText
                        checkMark.ImageColor3 = XPColors.DisabledText
                        label.TextColor3 = XPColors.DisabledText
                    else
                        checkBox.BorderColor3 = XPColors.CheckboxBorder
                        checkMark.ImageColor3 = Color3.fromRGB(0, 0, 0)
                        label.TextColor3 = Color3.fromRGB(0, 0, 0)
                    end
                    if config.Callback then config.Callback(isOn) end
                end

                local function toggle()
                    if not isEnabled then return end
                    isOn = not isOn
                    updateToggle()
                end

                checkBox.MouseButton1Click:Connect(toggle)
                label.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        toggle()
                    end
                end)

                updateToggle()
                updateSectionSize()
                return { 
                    Set = function(v) isOn = v; updateToggle() end,
                    SetEnabled = function(v) isEnabled = v; updateToggle() end
                }
            end

            -- RadioButton в стиле XP (размер 16x16)
            function sectionObj:CreateRadio(config)
                local radioFrame = Instance.new("Frame")
                radioFrame.Size = UDim2.new(1, 0, 0, 22)
                radioFrame.BackgroundTransparency = 1
                radioFrame.Parent = elementContainer

                local radioButton = Instance.new("ImageButton")
                radioButton.Size = UDim2.new(0, 16, 0, 16)
                radioButton.Position = UDim2.new(0, 0, 0.5, -8)
                radioButton.BackgroundColor3 = XPColors.CheckboxFill
                radioButton.BorderSizePixel = 1
                radioButton.BorderColor3 = XPColors.CheckboxBorder
                radioButton.Image = ""
                radioButton.AutoButtonColor = false
                radioButton.Parent = radioFrame

                local radioDot = Instance.new("ImageLabel")
                radioDot.Size = UDim2.new(0, 8, 0, 8)
                radioDot.Position = UDim2.new(0.5, -4, 0.5, -4)
                radioDot.BackgroundTransparency = 1
                radioDot.Image = "rbxassetid://6031068421"
                radioDot.ImageColor3 = Color3.fromRGB(0, 0, 0)
                radioDot.Visible = false
                radioDot.Parent = radioButton

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -24, 1, 0)
                label.Position = UDim2.new(0, 24, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = config.Name or "Radio"
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
                label.TextSize = 11
                label.Parent = radioFrame

                local isOn = config.Default or false
                local isEnabled = config.Enabled ~= false
                
                local function updateRadio()
                    radioDot.Visible = isOn
                    if not isEnabled then
                        radioButton.BorderColor3 = XPColors.DisabledText
                        radioDot.ImageColor3 = XPColors.DisabledText
                        label.TextColor3 = XPColors.DisabledText
                    else
                        radioButton.BorderColor3 = XPColors.CheckboxBorder
                        radioDot.ImageColor3 = Color3.fromRGB(0, 0, 0)
                        label.TextColor3 = Color3.fromRGB(0, 0, 0)
                    end
                    if config.Callback then config.Callback(isOn) end
                end

                local function select()
                    if not isEnabled then return end
                    isOn = true
                    updateRadio()
                end

                radioButton.MouseButton1Click:Connect(select)
                label.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        select()
                    end
                end)

                updateRadio()
                updateSectionSize()
                return { 
                    Set = function(v) isOn = v; updateRadio() end,
                    SetEnabled = function(v) isEnabled = v; updateRadio() end
                }
            end

            -- Слайдер в стиле XP
            function sectionObj:CreateSlider(config)
                local sldFrame = Instance.new("Frame")
                sldFrame.Size = UDim2.new(1, 0, 0, 56)
                sldFrame.BackgroundTransparency = 1
                sldFrame.Parent = elementContainer

                local titleLabel = Instance.new("TextLabel")
                titleLabel.Size = UDim2.new(1, -16, 0, 20)
                titleLabel.Position = UDim2.new(0, 0, 0, 4)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = config.Name or "Slider"
                titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
                titleLabel.TextSize = 11
                titleLabel.Parent = sldFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 40, 0, 20)
                valueLabel.Position = UDim2.new(1, -40, 0, 4)
                valueLabel.BackgroundTransparency = 1
                valueLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                valueLabel.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
                valueLabel.TextSize = 11
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = sldFrame

                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, 0, 0, 6)
                sliderBg.Position = UDim2.new(0, 0, 0, 32)
                sliderBg.BackgroundColor3 = XPColors.ButtonHighlight
                sliderBg.BorderSizePixel = 1
                sliderBg.BorderColor3 = XPColors.Border
                sliderBg.Parent = sldFrame

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = XPColors.TitleBarStart
                fill.BorderSizePixel = 0
                fill.Parent = sliderBg

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 10, 0, 16)
                knob.Position = UDim2.new(0, -5, 0.5, -8)
                knob.BackgroundColor3 = XPColors.SliderThumb
                knob.BorderSizePixel = 1
                knob.BorderColor3 = XPColors.Border
                knob.Parent = sliderBg

                local sliderBtn = Instance.new("TextButton")
                sliderBtn.Size = UDim2.new(1, 0, 0, 20)
                sliderBtn.Position = UDim2.new(0, 0, 0, 25)
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
                    knob.Position = UDim2.new(percent, -5, 0.5, -8)
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

            -- Выпадающий список в стиле XP
            function sectionObj:CreateDropdown(config)
                local ddFrame = Instance.new("Frame")
                ddFrame.Size = UDim2.new(1, 0, 0, 30)
                ddFrame.BackgroundTransparency = 1
                ddFrame.ClipsDescendants = false
                ddFrame.Parent = elementContainer

                local btnFrame = Instance.new("Frame")
                btnFrame.Size = UDim2.new(1, 0, 0, 23)
                btnFrame.BackgroundColor3 = XPColors.ButtonHighlight
                btnFrame.BorderSizePixel = 1
                btnFrame.BorderColor3 = XPColors.Border
                btnFrame.Parent = ddFrame

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = config.Name .. ": " .. (config.CurrentOption or config.Options[1])
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                btn.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
                btn.TextSize = 11
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = btnFrame

                local padding = Instance.new("UIPadding")
                padding.PaddingLeft = UDim.new(0, 4)
                padding.Parent = btn

                local arrow = Instance.new("ImageButton")
                arrow.Size = UDim2.new(0, 17, 0, 17)
                arrow.Position = UDim2.new(1, -17, 0.5, -8)
                arrow.BackgroundColor3 = XPColors.ButtonHighlight
                arrow.BorderSizePixel = 1
                arrow.BorderColor3 = XPColors.Border
                arrow.Image = "rbxassetid://6031068421"
                arrow.ImageColor3 = Color3.fromRGB(0, 0, 0)
                arrow.Rotation = 90
                arrow.Parent = ddFrame

                local optsFrame = Instance.new("Frame")
                optsFrame.Size = UDim2.new(1, 0, 0, 0)
                optsFrame.Position = UDim2.new(0, 0, 1, 2)
                optsFrame.BackgroundColor3 = XPColors.ButtonHighlight
                optsFrame.BorderSizePixel = 1
                optsFrame.BorderColor3 = XPColors.Border
                optsFrame.ClipsDescendants = true
                optsFrame.Visible = false
                optsFrame.ZIndex = 5
                optsFrame.Parent = ddFrame

                local optsList = Instance.new("UIListLayout")
                optsList.Parent = optsFrame

                local selected = config.CurrentOption or config.Options[1]

                btn.MouseButton1Click:Connect(function()
                    optsFrame.Visible = not optsFrame.Visible
                    arrow.Rotation = optsFrame.Visible and -90 or 90
                    if optsFrame.Visible then
                        optsFrame.Size = UDim2.new(1, 0, 0, #config.Options * 23)
                    end
                end)
                
                arrow.MouseButton1Click:Connect(function()
                    optsFrame.Visible = not optsFrame.Visible
                    arrow.Rotation = optsFrame.Visible and -90 or 90
                    if optsFrame.Visible then
                        optsFrame.Size = UDim2.new(1, 0, 0, #config.Options * 23)
                    end
                end)

                for _, opt in ipairs(config.Options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 23)
                    optBtn.BackgroundTransparency = 1
                    optBtn.Text = opt
                    optBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                    optBtn.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
                    optBtn.TextSize = 11
                    optBtn.TextXAlignment = Enum.TextXAlignment.Left
                    optBtn.Parent = optsFrame
                    
                    local optPadding = Instance.new("UIPadding")
                    optPadding.PaddingLeft = UDim.new(0, 4)
                    optPadding.Parent = optBtn

                    optBtn.MouseEnter:Connect(function()
                        TweenService:Create(optBtn, FAST_TWEEN, {BackgroundColor3 = XPColors.TitleBarStart, BackgroundTransparency = 0.7}):Play()
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

    -- Метод уведомления в стиле XP (всплывающее окно)
    function Library:Notify(config)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 260, 0, 70)
        notif.Position = UDim2.new(1, -270, 0, 20)
        notif.BackgroundColor3 = XPColors.WindowBackground
        notif.BorderSizePixel = 1
        notif.BorderColor3 = XPColors.Border
        notif.ZIndex = 20
        notif.Parent = ScreenGui

        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 24)
        titleBar.BackgroundColor3 = XPColors.TitleBarStart
        titleBar.BorderSizePixel = 0
        titleBar.Parent = notif

        local titleGrad = Instance.new("UIGradient")
        titleGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, XPColors.TitleBarEnd),
            ColorSequenceKeypoint.new(1, XPColors.TitleBarStart)
        })
        titleGrad.Rotation = 90
        titleGrad.Parent = titleBar

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -10, 1, 0)
        title.Position = UDim2.new(0, 6, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = config.Title or "Notification"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.SourceSansBold  -- ИСПРАВЛЕНО
        title.TextSize = 11
        title.ZIndex = 21
        title.Parent = titleBar

        local content = Instance.new("TextLabel")
        content.Size = UDim2.new(1, -20, 0, 30)
        content.Position = UDim2.new(0, 10, 0, 32)
        content.BackgroundTransparency = 1
        content.Text = config.Content or "This is a notification"
        content.TextColor3 = Color3.fromRGB(0, 0, 0)
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.Font = Enum.Font.SourceSans  -- ИСПРАВЛЕНО
        content.TextSize = 11
        content.ZIndex = 21
        content.Parent = notif

        -- Анимация
        notif.Position = UDim2.new(1, 20, 0, 20)
        TweenService:Create(notif, TWEEN_INFO, {Position = UDim2.new(1, -270, 0, 20)}):Play()
        task.wait(config.Duration or 4)
        TweenService:Create(notif, TWEEN_INFO, {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.2)
        notif:Destroy()
    end

    -- Показать окно с анимацией
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TWEEN_INFO, {Size = originalSize}):Play()

    return Library
end

return Library
