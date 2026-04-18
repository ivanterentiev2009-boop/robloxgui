-- Windows XP Style GUI Library for Roblox
-- Сохраните как ModuleScript

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Анимации (в стиле XP анимации почти нет, но оставим плавные для современности)
local TWEEN_INFO = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local FAST_TWEEN = TweenInfo.new(0.1, Enum.EasingStyle.Linear)

-- Вспомогательные функции
local function createShadow(parent) -- в XP теней почти нет, оставим лёгкую
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
    -- Цвета Windows XP
    local xpBlue = Color3.fromRGB(0, 88, 227)        -- #0058E3
    local xpBlueLight = Color3.fromRGB(60, 140, 255) -- градиент
    local xpGray = Color3.fromRGB(236, 233, 216)     -- фон окна
    local xpGrayDark = Color3.fromRGB(212, 208, 200) -- панель вкладок
    local xpBorder = Color3.fromRGB(100, 100, 100)
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
    MainFrame.BackgroundColor3 = xpGray
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = xpBorder
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
    TitleBar.BackgroundColor3 = xpBlue
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30) -- классическая высота заголовка XP

    -- Градиент (сверху светлее, снизу темнее)
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, xpBlueLight),
        ColorSequenceKeypoint.new(1, xpBlue)
    })
    titleGradient.Rotation = 90
    titleGradient.Parent = TitleBar

    -- Иконка приложения (маленький квадратик слева)
    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Parent = TitleBar
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Size = UDim2.new(0, 16, 0, 16)
    TitleIcon.Position = UDim2.new(0, 6, 0.5, -8)
    TitleIcon.Image = "rbxassetid://6031068421" -- любая иконка, можно заменить
    TitleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    TitleIcon.ScaleType = Enum.ScaleType.Fit

    -- Название окна
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 28, 0, 0)
    TitleLabel.Font = Enum.Font.Tahoma
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 13
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
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.8
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn.Size = UDim2.new(0, 24, 0, 20)
        btn.Font = Enum.Font.Tahoma
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
                BorderColor3 = Color3.fromRGB(255, 255, 255)
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
        MiniButton.BackgroundColor3 = xpBlue
        MiniButton.BorderSizePixel = 1
        MiniButton.BorderColor3 = xpBorder
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
            ColorSequenceKeypoint.new(0, xpBlueLight),
            ColorSequenceKeypoint.new(1, xpBlue)
        })
        miniGrad.Rotation = 90
        miniGrad.Parent = MiniButton

        -- Иконка (окно)
        local miniIcon = Instance.new("ImageLabel")
        miniIcon.BackgroundTransparency = 1
        miniIcon.Size = UDim2.new(0, 24, 0, 24)
        miniIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
        miniIcon.Image = "rbxassetid://6026568198" -- иконка окна
        miniIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        miniIcon.Parent = MiniButton

        createShadow(MiniButton)

        MiniButton.MouseEnter:Connect(function()
            TweenService:Create(MiniButton, FAST_TWEEN, {
                BackgroundColor3 = xpBlue:Lerp(Color3.fromRGB(255,255,255), 0.2)
            }):Play()
        end)
        MiniButton.MouseLeave:Connect(function()
            TweenService:Create(MiniButton, FAST_TWEEN, {
                BackgroundColor3 = xpBlue
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

    -- Кнопка сворачивания (минус/подчёркивание)
    local MinimizeButton = createXPControlButton("–", function()
        if minimizable and MiniButton then
            MainFrame.Visible = false
            MiniButton.Visible = true
            MiniButton.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MiniButton, TWEEN_INFO, {Size = UDim2.new(0, 48, 0, 48)}):Play()
        end
    end)

    -- Кнопка закрытия (крестик)
    local CloseButton = createXPControlButton("✕", function()
        TweenService:Create(MainFrame, TWEEN_INFO, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.15)
        ScreenGui:Destroy()
    end)

    -- Панель вкладок (слева) в стиле XP
    local TabPanel = Instance.new("Frame")
    TabPanel.Name = "TabPanel"
    TabPanel.Parent = MainFrame
    TabPanel.BackgroundColor3 = xpGrayDark
    TabPanel.BorderSizePixel = 1
    TabPanel.BorderColor3 = xpBorder
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
    ContentArea.BackgroundColor3 = xpGray
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
        tabButton.BackgroundColor3 = xpGray
        tabButton.BorderSizePixel = 1
        tabButton.BorderColor3 = xpBorder
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
        tabLabel.Font = Enum.Font.Tahoma
        tabLabel.TextSize = 13
        tabLabel.Parent = tabButton

        -- Контент вкладки (ScrollingFrame)
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "_Content"
        tabContent.Parent = ContentArea
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = xpBlue
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollingEnabled = true

        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 8)
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Parent = tabContent

        -- Анимации при наведении
        tabButton.MouseEnter:Connect(function()
            if activeTab and activeTab.Button == tabButton then return end
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        tabButton.MouseLeave:Connect(function()
            if activeTab and activeTab.Button == tabButton then return end
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = xpGray}):Play()
        end)

        -- Переключение вкладок
        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                activeTab.Content.Visible = false
                TweenService:Create(activeTab.Button, FAST_TWEEN, {BackgroundColor3 = xpGray}):Play()
            end
            tabContent.Visible = true
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            activeTab = { Button = tabButton, Content = tabContent }
        end)

        -- Активируем первую вкладку
        if not activeTab then
            tabContent.Visible = true
            TweenService:Create(tabButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
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
            sectionLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Font = Enum.Font.TahomaBold
            sectionLabel.TextSize = 13
            sectionLabel.Parent = sectionFrame

            -- Линия-разделитель (тонкая, как в XP)
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, 24)
            line.BackgroundColor3 = xpBorder
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

            -- Кнопка в стиле XP
            function sectionObj:CreateButton(config)
                local btnFrame = Instance.new("Frame")
                btnFrame.Size = UDim2.new(1, 0, 0, 36)
                btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btnFrame.BorderSizePixel = 1
                btnFrame.BorderColor3 = xpBorder
                btnFrame.Parent = elementContainer

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = config.Name or "Button"
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                btn.Font = Enum.Font.Tahoma
                btn.TextSize = 13
                btn.Parent = btnFrame

                btn.MouseEnter:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(240, 240, 240)}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btnFrame, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                end)
                btn.MouseButton1Click:Connect(function()
                    if config.Callback then config.Callback() end
                end)

                updateSectionSize()
                return btn
            end

            -- Тоггл (чекбокс в стиле XP)
            function sectionObj:CreateToggle(config)
                local togFrame = Instance.new("Frame")
                togFrame.Size = UDim2.new(1, 0, 0, 32)
                togFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                togFrame.BorderSizePixel = 1
                togFrame.BorderColor3 = xpBorder
                togFrame.Parent = elementContainer

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.7, 0, 1, 0)
                label.Position = UDim2.new(0, 8, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = config.Name or "Toggle"
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Tahoma
                label.TextSize = 13
                label.Parent = togFrame

                local checkBox = Instance.new("ImageButton")
                checkBox.Size = UDim2.new(0, 18, 0, 18)
                checkBox.Position = UDim2.new(1, -28, 0.5, -9)
                checkBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                checkBox.BorderSizePixel = 1
                checkBox.BorderColor3 = xpBorder
                checkBox.Image = ""
                checkBox.AutoButtonColor = false
                checkBox.Parent = togFrame

                local checkMark = Instance.new("ImageLabel")
                checkMark.Size = UDim2.new(0, 12, 0, 12)
                checkMark.Position = UDim2.new(0.5, -6, 0.5, -6)
                checkMark.BackgroundTransparency = 1
                checkMark.Image = "rbxassetid://6031068421" -- галочка
                checkMark.ImageColor3 = Color3.fromRGB(0, 0, 0)
                checkMark.Visible = false
                checkMark.Parent = checkBox

                local isOn = config.Default or false
                local function updateToggle()
                    checkMark.Visible = isOn
                    if config.Callback then config.Callback(isOn) end
                end

                checkBox.MouseButton1Click:Connect(function()
                    isOn = not isOn
                    updateToggle()
                end)
                label.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isOn = not isOn
                        updateToggle()
                    end
                end)

                updateToggle()
                updateSectionSize()
                return { Set = function(v) isOn = v; updateToggle() end }
            end

            -- Слайдер в стиле XP
            function sectionObj:CreateSlider(config)
                local sldFrame = Instance.new("Frame")
                sldFrame.Size = UDim2.new(1, 0, 0, 56)
                sldFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sldFrame.BorderSizePixel = 1
                sldFrame.BorderColor3 = xpBorder
                sldFrame.Parent = elementContainer

                local titleLabel = Instance.new("TextLabel")
                titleLabel.Size = UDim2.new(1, -16, 0, 20)
                titleLabel.Position = UDim2.new(0, 8, 0, 4)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = config.Name or "Slider"
                titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.Font = Enum.Font.Tahoma
                titleLabel.TextSize = 13
                titleLabel.Parent = sldFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 40, 0, 20)
                valueLabel.Position = UDim2.new(1, -48, 0, 4)
                valueLabel.BackgroundTransparency = 1
                valueLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                valueLabel.Font = Enum.Font.Tahoma
                valueLabel.TextSize = 13
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = sldFrame

                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -16, 0, 6)
                sliderBg.Position = UDim2.new(0, 8, 0, 32)
                sliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderBg.BorderSizePixel = 1
                sliderBg.BorderColor3 = xpBorder
                sliderBg.Parent = sldFrame

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = xpBlue
                fill.BorderSizePixel = 0
                fill.Parent = sliderBg

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 10, 0, 16)
                knob.Position = UDim2.new(0, -5, 0.5, -8)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 1
                knob.BorderColor3 = xpBorder
                knob.Parent = sliderBg

                local sliderBtn = Instance.new("TextButton")
                sliderBtn.Size = UDim2.new(1, -16, 0, 20)
                sliderBtn.Position = UDim2.new(0, 8, 0, 25)
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
                ddFrame.Size = UDim2.new(1, 0, 0, 36)
                ddFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ddFrame.BorderSizePixel = 1
                ddFrame.BorderColor3 = xpBorder
                ddFrame.ClipsDescendants = false
                ddFrame.Parent = elementContainer

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = config.Name .. ": " .. (config.CurrentOption or config.Options[1])
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                btn.Font = Enum.Font.Tahoma
                btn.TextSize = 13
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = ddFrame

                local padding = Instance.new("UIPadding")
                padding.PaddingLeft = UDim.new(0, 8)
                padding.Parent = btn

                local arrow = Instance.new("ImageLabel")
                arrow.Size = UDim2.new(0, 16, 0, 16)
                arrow.Position = UDim2.new(1, -24, 0.5, -8)
                arrow.BackgroundTransparency = 1
                arrow.Image = "rbxassetid://6031068421" -- стрелка вниз
                arrow.ImageColor3 = Color3.fromRGB(0, 0, 0)
                arrow.Rotation = 90
                arrow.Parent = ddFrame

                local optsFrame = Instance.new("Frame")
                optsFrame.Size = UDim2.new(1, 0, 0, 0)
                optsFrame.Position = UDim2.new(0, 0, 1, 2)
                optsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                optsFrame.BorderSizePixel = 1
                optsFrame.BorderColor3 = xpBorder
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
                        optsFrame.Size = UDim2.new(1, 0, 0, #config.Options * 30)
                    end
                end)

                for _, opt in ipairs(config.Options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 30)
                    optBtn.BackgroundTransparency = 1
                    optBtn.Text = opt
                    optBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                    optBtn.Font = Enum.Font.Tahoma
                    optBtn.TextSize = 13
                    optBtn.Parent = optsFrame

                    optBtn.MouseEnter:Connect(function()
                        TweenService:Create(optBtn, FAST_TWEEN, {BackgroundColor3 = xpBlue, BackgroundTransparency = 0.7}):Play()
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
        notif.BackgroundColor3 = xpGray
        notif.BorderSizePixel = 1
        notif.BorderColor3 = xpBorder
        notif.ZIndex = 20
        notif.Parent = ScreenGui

        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 24)
        titleBar.BackgroundColor3 = xpBlue
        titleBar.BorderSizePixel = 0
        titleBar.Parent = notif

        local titleGrad = Instance.new("UIGradient")
        titleGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, xpBlueLight),
            ColorSequenceKeypoint.new(1, xpBlue)
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
        title.Font = Enum.Font.TahomaBold
        title.TextSize = 12
        title.ZIndex = 21
        title.Parent = titleBar

        local content = Instance.new("TextLabel")
        content.Size = UDim2.new(1, -20, 0, 30)
        content.Position = UDim2.new(0, 10, 0, 32)
        content.BackgroundTransparency = 1
        content.Text = config.Content or "This is a notification"
        content.TextColor3 = Color3.fromRGB(0, 0, 0)
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.Font = Enum.Font.Tahoma
        content.TextSize = 12
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
