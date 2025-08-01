local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

local library = {}
local ThemeColor = Color3.fromRGB(255, 255, 255)

function library:CreateObject(class: string, properties: {}, parent: Instance)
	local Object: Instance = Instance.new(class)

	for i, property in pairs(properties) do
		Object[i] = property
	end

	if parent ~= nil then
		Object.Parent = parent
	end

	return Object
end

function library:SetDraggable(gui)
	local UserInputService = game:GetService("UserInputService")

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function library:RoundCorners(object: Instance, radius: number)
	return library:CreateObject("UICorner", {
		CornerRadius = UDim.new(0, radius)
	}, object)
end

function library.new(title: string)
	local menu = {}
	menu.Tabs = {}
	menu.Sections = {}

	-- ScreenGui

	local ScreenGui = library:CreateObject("ScreenGui", {
		Name = title .. "ScreenGui",
		ResetOnSpawn = false
	}, Player.PlayerGui)

	-- Main frame

	local Main = library:CreateObject("Frame", {
		Name = title,
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		Size = UDim2.new(0, 450, 0, 250),
		Position = UDim2.new(0.5, 0, 0.2, 0)
	}, ScreenGui)

	library:RoundCorners(Main, 5)
	library:SetDraggable(Main)

	-- Toggle Circle
	local ToggleCircle = library:CreateObject("TextButton", {
		Name = "ToggleCircle",
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		Size = UDim2.new(0, 40, 0, 40),
		Position = UDim2.new(0.6, 0, 0, 10),
		Text = "=", -- Hamburger icon
		TextColor3 = ThemeColor,
		Font = Enum.Font.SourceSansBold,
		TextScaled = true
	}, ScreenGui)

	library:RoundCorners(ToggleCircle, 20)
	library:SetDraggable(ToggleCircle)

	-- Toggle functionality
	ToggleCircle.MouseButton1Click:Connect(function()
		Main.Visible = not Main.Visible
	end)

	-- TopBar

	local TopBar = library:CreateObject("Frame", {
		Name = "TopBar",
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Size = UDim2.new(1, 0, 0, 40)
	}, Main)	

	local CloseButton = library:CreateObject("TextButton", {
		Name = "Close",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 420, 0, 10),
		Size = UDim2.new(0, 20, 0, 20),
		Font = Enum.Font.SourceSans,
		Text = "X",
		TextColor3 = ThemeColor,
		TextScaled = true
	}, TopBar)

	CloseButton.Activated:Connect(function()
		Main.Visible = false
	end)

	library:CreateObject("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 9),
		Size = UDim2.new(0, 400, 0, 22),
		Font = Enum.Font.SourceSansSemibold,
		Text = title,
		TextColor3 = ThemeColor,
		TextScaled = true,
		TextXAlignment = Enum.TextXAlignment.Left
	}, TopBar)

	library:RoundCorners(TopBar, 5)

	-- SideBar

	local SideBar = library:CreateObject("Frame", {
		Name = "SideBar",
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Position = UDim2.new(0, 0, 0, 40),
		Size = UDim2.new(0, 120, 0, 210)
	}, Main)

	local TabContainer = library:CreateObject("Frame", {
		Name = "TabContainer",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 5),
		Size = UDim2.new(0, 100, 0, 20)
	}, SideBar)

	library:CreateObject("Frame", {
		Name = "RoughEdges",
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, -5),
		Size = UDim2.new(0, 120, 0, 10)
	}, SideBar)

	local ListLayout = library:CreateObject("UIListLayout", {
		Padding = UDim.new(0, 5)
	}, TabContainer)

	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	library:RoundCorners(SideBar, 5)

	-- Section

	function menu:CreateTabButton(text: string)
		local TabButton = library:CreateObject("TextButton", {
			Name = text,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 100, 0, 20),
			Font = Enum.Font.SourceSans,
			Text = text,
			TextColor3 = ThemeColor,
			TextScaled = true
		}, TabContainer)

		menu.Tabs[text] = TabButton

		TabButton.MouseButton1Click:Connect(function()
			for sectionName, sectionFrame in pairs(menu.Sections) do
				sectionFrame.Visible = (sectionName == text)
			end
		end)

		return TabButton
	end

	function menu:CreateSection(name: string)
		local section = {}

		local SectionContainer = library:CreateObject("ScrollingFrame", {
			Name = "SectionContainer",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 130, 0, 50),
			Size = UDim2.new(0, 310, 0, 190),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(0, 0, 0, 190),
			ScrollBarImageTransparency = 0.5,
			ScrollBarThickness = 6
		}, Main)

		SectionContainer.Visible = false

		library:CreateObject("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, SectionContainer)

		menu:CreateTabButton(name)
		menu.Sections[name] = SectionContainer

		section.Frame = SectionContainer

		SectionContainer.ChildAdded:Connect(function(object)
			if object:IsA("GuiObject") then
				object.LayoutOrder = #SectionContainer:GetChildren()
			end
		end)

		function section:CreateTextLabel(text: string)
			local Label = library:CreateObject("TextLabel", {
				Name = text .. "Label",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 300, 0, 20),
				Font = Enum.Font.SourceSans,
				Text = text,
				TextColor3 = ThemeColor,
				TextSize = 20,
			}, SectionContainer)

			Label.LayoutOrder = #SectionContainer:GetChildren()

			return Label
		end

		function section:CreateButton(text: string, callback)
			local Button = library:CreateObject("TextButton", {
				Name = text,
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				Size = UDim2.new(0, 300, 0, 30),
				Font = Enum.Font.SourceSans,
				Text = text,
				TextColor3 = ThemeColor,
				TextSize = 20
			}, SectionContainer)

			library:RoundCorners(Button, 5)

			Button.Activated:Connect(callback)

			Button.LayoutOrder = #SectionContainer:GetChildren()

			return Button
		end

		function section:CreateTextBox(placeholder: string, action: string, callback)
			local Container = library:CreateObject("Frame", {
				Name = placeholder .. "TextBox",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 300, 0, 30)
			}, SectionContainer)

			local TextBox = library:CreateObject("TextBox", {
				Name = "TextBox",
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				Size = UDim2.new(0, 220, 0, 30),
				Font = Enum.Font.SourceSans,
				PlaceholderText = placeholder,
				Text = "",
				TextColor3 = ThemeColor,
				TextSize = 20
			}, Container)

			library:RoundCorners(TextBox, 5)

			local Button = section:CreateButton(action, function()
				callback(TextBox.Text)
			end)

			Button.Parent = Container
			Button.Position = UDim2.new(0, 225, 0, 0)
			Button.Size = UDim2.new(0, 75, 0, 30)

			Container.LayoutOrder = #SectionContainer:GetChildren()

			return Container
		end

		function section:CreateInput(text: string, default: Enum.KeyCode?, callback)
			local CurrentInput = default
			local SkipTurn = false

			local Container = library:CreateObject("Frame", {
				Name = text .. "Input",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 300, 0, 30)
			}, SectionContainer)

			local InputButton = library:CreateObject("TextButton", {
				Name = "InputButton",
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				Position = UDim2.new(0, 250, 0, 2),
				Size = UDim2.new(0, 50, 0, 25),
				Font = Enum.Font.SourceSans,
				Text = "...",
				TextColor3 = ThemeColor,
				TextSize = 20
			}, Container)

			library:RoundCorners(InputButton, 5)

			if CurrentInput and CurrentInput ~= Enum.KeyCode.Unknown then
				InputButton.Text = CurrentInput.Name
			end

			InputButton.Activated:Connect(function()
				InputButton.Text = "..."

				local input = UserInputService.InputBegan:Wait()

				if (not input.KeyCode) or input.KeyCode == Enum.KeyCode.Unknown then
					CurrentInput = Enum.KeyCode.Unknown
					InputButton.Text = "None"
				else
					SkipTurn = true
					CurrentInput = input.KeyCode
					InputButton.Text = input.KeyCode.Name
				end
			end)

			UserInputService.InputBegan:Connect(function(input)
				if SkipTurn then SkipTurn = false return end

				if input.KeyCode == CurrentInput and input.KeyCode ~= Enum.KeyCode.Unknown then
					callback(input.KeyCode)
				end
			end)

			local Label = library:CreateObject("TextLabel", {
				Name = "Label",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 5),
				Size = UDim2.new(0, 175, 0, 20),
				Font = Enum.Font.SourceSans,
				Text = text,
				TextColor3 = ThemeColor,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left
			}, Container)

			Container.LayoutOrder = #SectionContainer:GetChildren()

			return Container
		end

		function section:CreateToggle(text: string, callback)
			local IsToggled = false

			local Container = library:CreateObject("Frame", {
				Name = text .. "Toggle",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 300, 0, 30)
			}, SectionContainer)

			local Toggle = library:CreateObject("ImageButton", {
				Name = "Toggle",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "rbxassetid://5228566966"
			}, Container)

			Toggle.Activated:Connect(function()
				IsToggled = not IsToggled

				if IsToggled then
					Toggle.Image = "rbxassetid://5228569533"
				else
					Toggle.Image = "rbxassetid://5228566966"
				end

				callback(IsToggled)
			end)

			local Label = library:CreateObject("TextLabel", {
				Name = "Label",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 30, 0, 5),
				Size = UDim2.new(0, 260, 0, 20),
				Font = Enum.Font.SourceSans,
				Text = text,
				TextColor3 = ThemeColor,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left
			}, Container)

			Container.LayoutOrder = #SectionContainer:GetChildren()

			return Container
		end

		function section:CreateSlider(text: string, max: number, default: number?, increment: number?, callback)
			local defaultValue = default or 0
			local step = increment or 1

			local Container = library:CreateObject("Frame", {
				Name = text .. "Slider",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 300, 0, 50)
			}, SectionContainer)

			local Label = library:CreateObject("TextLabel", {
				Name = "Label",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150, 0, 20),
				Font = Enum.Font.SourceSans,
				Text = text,
				TextColor3 = ThemeColor,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left
			}, Container)

			local ValueBox = library:CreateObject("TextBox", {
				Name = "Value",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 150, 0, 0),
				Size = UDim2.new(0, 150, 0, 20),
				Font = Enum.Font.SourceSans,
				PlaceholderText = tostring(defaultValue),
				Text = tostring(defaultValue),
				TextColor3 = ThemeColor:Lerp(Color3.new(0, 0, 0), 0.5),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Right
			}, Container)

			local Bar = library:CreateObject("Frame", {
				Name = "Bar",
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				Position = UDim2.new(0, 0, 0, 30),
				Size = UDim2.new(1, 0, 0, 8)
			}, Container)
			library:RoundCorners(Bar, 8)

			local Fill = library:CreateObject("Frame", {
				Name = "Amount",
				BackgroundColor3 = Color3.new(1, 1, 1),
				Size = UDim2.new(0, 0, 1, 0)
			}, Bar)
			library:RoundCorners(Fill, 8)

			local Handle = library:CreateObject("ImageButton", {
				Name = "Slide",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(0, 24, 0, 24),
				Image = "", -- Optional: icon
				AutoButtonColor = false
			}, Fill)
			library:RoundCorners(Handle, 12)

			local function updateSlider(value: number)
				value = math.clamp(math.floor(value / step + 0.5) * step, 0, max)
				local percent = value / max
				local px = percent * Bar.AbsoluteSize.X

				Handle.Position = UDim2.new(0, px, 0.5, 0)
				Fill.Size = UDim2.new(0, px, 1, 0)
				ValueBox.Text = tostring(value)
				callback(value)
			end

			local dragging = false

			local function onInputMoved(input)
				if not dragging or input.UserInputType ~= Enum.UserInputType.Touch then return end
				local barX = Bar.AbsolutePosition.X
				local posX = math.clamp(input.Position.X - barX, 0, Bar.AbsoluteSize.X)
				local percent = posX / Bar.AbsoluteSize.X
				local value = percent * max
				updateSlider(value)
			end

			Handle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(onInputMoved)

			ValueBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					local input = tonumber(ValueBox.Text)
					if input then
						updateSlider(input)
					end
				end
			end)

			-- Initial state
			updateSlider(defaultValue)
			Container.LayoutOrder = #SectionContainer:GetChildren()

			return Container
		end

		return section
	end

	return menu
end

return library
