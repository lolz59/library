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
	
	-- ScreenGui
	
	local ScreenGui = library:CreateObject("ScreenGui", {
		Name = title .. "ScreenGui",
		ResetOnSpawn = false
	}, Player.PlayerGui)
	
	-- Main frame
	
	local Main = library:CreateObject("Frame", {
		Name = title,
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		Size = UDim2.new(0, 450, 0, 250)
	}, ScreenGui)
	
	library:RoundCorners(Main, 5)
	library:SetDraggable(Main)
	
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
		print("Closed")
	end)
	
	local HideButton = library:CreateObject("TextButton", {
		Name = "Hide",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 400, 0, 10),
		Size = UDim2.new(0, 20, 0, 20),
		Font = Enum.Font.SourceSans,
		Text = "-",
		TextColor3 = ThemeColor,
		TextScaled = true
	}, TopBar)

	HideButton.Activated:Connect(function()
		if HideButton.Text == "+" then
			HideButton.Text = "-"
		elseif HideButton.Text == "-" then
			HideButton.Text = "+"
		end
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
	
	library:CreateObject("UIListLayout", {
		Padding = UDim.new(0, 5)
	}, TabContainer)
	
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
	end
	
	function menu:CreateSection(name: string)
		local section = {}
		
		local SectionContainer = library:CreateObject("ScrollingFrame", {
			Name = "SectionContainer",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 130, 0, 50),
			Size = UDim2.new(0, 310, 0, 190),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(0, 0, 0, 190),
			ScrollBarImageTransparency = 0.5,
			ScrollBarThickness = 6
		}, Main)
		
		library:CreateObject("UIListLayout", {
			Padding = UDim.new(0, 5)
		}, SectionContainer)
		
		menu:CreateTabButton(name)
		
		section.Frame = SectionContainer
		
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
				InputButton.Text = "None"
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

			return Container
		end
		
		function section:CreateSlider(text: string, max: number, callback)
			local Container = library:CreateObject("Frame", {
				Name = text .. "Slider",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 300, 0, 40)
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
				PlaceholderText = "0",
				Text = "0",
				TextColor3 = Color3.new(ThemeColor.R * 0.75, ThemeColor.G * 0.75, ThemeColor.B * 0.75),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Right
			}, Container)
			
			local Bar = library:CreateObject("Frame", {
				Name = "Bar",
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				Position = UDim2.new(0, 0, 0, 30),
				Size = UDim2.new(1, 0, 0, 5)
			}, Container)
			
			library:RoundCorners(Bar, 15)
			
			local Amount = library:CreateObject("Frame", {
				Name = "Amount",
				BackgroundColor3 = Color3.new(1, 1, 1),
				Size = UDim2.new(0, 0, 1, 0)
			}, Bar)
			
			library:RoundCorners(Amount, 15)
			
			local SlideButton: TextButton = library:CreateObject("TextButton", {
				Name = "Slide",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, 15, 0, 15),
				Text = ""
			}, Amount)
			
			library:RoundCorners(SlideButton, 15)
			
			local MovingSlider = false
			local SnapAmount = Bar.AbsoluteSize.X / max
			
			SlideButton.MouseButton1Down:Connect(function()
				MovingSlider = true
			end)
			
			SlideButton.MouseButton1Up:Connect(function()
				MovingSlider = false
			end)
			
			Mouse.Button1Up:Connect(function()
				MovingSlider = false
			end)
			
			Mouse.Move:Connect(function()
				if MovingSlider then
					local xOffset = math.floor((Mouse.X - Bar.AbsolutePosition.X) / SnapAmount + 0.5) * SnapAmount
					local xOffsetClamped = math.clamp(xOffset, 0, Bar.AbsoluteSize.X)
					
					TweenService:Create(SlideButton, TweenInfo.new(0.1), {Position = UDim2.new(0, xOffsetClamped, Bar.Position.Y)}):Play()
					TweenService:Create(Amount, TweenInfo.new(0.1), {Size = UDim2.new(0, xOffsetClamped, 1, 0)}):Play()
					
					local RoundedAbsSize = math.floor(Bar.AbsoluteSize.X / SnapAmount + 0.5) * SnapAmount
					local RoundedOffsetClamped = math.floor(xOffsetClamped / SnapAmount + 0.5) * SnapAmount
					
					local Value = RoundedOffsetClamped / RoundedAbsSize * max
					
					callback(Value)
					
					ValueBox.Text = Value
				end
			end)
			
			ValueBox.FocusLost:Connect(function(entered)
				if not entered then return end
				
				local input = tonumber(ValueBox.Text)
				
				if input then
					local InputClamped = math.clamp(input, 0, max)
					
					local xOffset = InputClamped / max * math.floor(Bar.AbsoluteSize.X / SnapAmount + 0.5) * SnapAmount
					local xOffsetRounded = math.floor(xOffset / SnapAmount + 0.5) * SnapAmount
					local xOffsetClamped = math.clamp(xOffsetRounded, 0, Bar.AbsoluteSize.X)
					
					local NewInput = xOffsetClamped / Bar.AbsoluteSize.X * max
					
					TweenService:Create(SlideButton, TweenInfo.new(0.1), {Position = UDim2.new(0, xOffsetClamped, Bar.Position.Y)}):Play()
					TweenService:Create(Amount, TweenInfo.new(0.1), {Size = UDim2.new(0, xOffsetClamped, 1, 0)}):Play()
					
					callback(NewInput)
					
					ValueBox.Text = NewInput
				end
			end)
						
			Container.LayoutOrder = #SectionContainer:GetChildren()

			return Container
		end
		
		return section
	end
	
	return menu
end
