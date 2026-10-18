-- Catalog Importer
-- Dock-widget adaptation of the user's GUI.rbxm layout.

local AssetService = game:GetService("AssetService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Selection = game:GetService("Selection")
local TweenService = game:GetService("TweenService")

local PLUGIN_ID = "CatalogImporter_CustomGUI_v1"
local TOOLBAR_NAME = "Catalog Tools"
local DEFAULT_BUNDLE_ID = "52488952982257"
local TOOLBAR_ICON = "rbxassetid://117646564132740"

local ASSET_ICON = "rbxassetid://80493264138470"
local BUNDLE_ICON = "rbxassetid://18600791179"
local IMPORT_ICON = "rbxassetid://74834108605061"

local toolbar = plugin:CreateToolbar(TOOLBAR_NAME)
local toggleButton = toolbar:CreateButton(
	"CatalogImporter_Toggle",
	"Open Catalog Importer",
	TOOLBAR_ICON,
	"Catalog Importer"
)
toggleButton.ClickableWhenViewportHidden = true

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	false,
	430,
	340,
	365,
	295
)

local widget = plugin:CreateDockWidgetPluginGuiAsync(PLUGIN_ID, widgetInfo)
widget.Title = "Catalog Importer"

local colors = {
		outer = Color3.fromRGB(48, 28, 29),
		panel = Color3.fromRGB(43, 31, 36),
		panelTop = Color3.fromRGB(67, 39, 43),
		panelBottom = Color3.fromRGB(37, 26, 32),
		field = Color3.fromRGB(49, 35, 39),
		ink = Color3.fromRGB(18, 11, 12),
		text = Color3.fromRGB(255, 248, 239),
		muted = Color3.fromRGB(217, 193, 177),
		stroke = Color3.fromRGB(12, 8, 9),
		orange = Color3.fromRGB(255, 134, 48),
		orangeLight = Color3.fromRGB(255, 174, 83),
		asset = Color3.fromRGB(71, 197, 255),
		assetDark = Color3.fromRGB(22, 91, 137),
		bundle = Color3.fromRGB(177, 117, 255),
		bundleDark = Color3.fromRGB(87, 45, 142),
		green = Color3.fromRGB(130, 255, 76),
		greenDark = Color3.fromRGB(57, 155, 40),
		red = Color3.fromRGB(255, 78, 75),
		hint = Color3.fromRGB(255, 212, 133),
}

local function create(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties) do
		object[property] = value
	end
	object.Parent = parent
	return object
end

local function addCorner(parent, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius or 9) }, parent)
end

local function addStroke(parent, thickness, transparency)
	return create("UIStroke", {
		Color = colors.stroke,
		Thickness = thickness or 2,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		LineJoinMode = Enum.LineJoinMode.Round,
	}, parent)
end

local function addGradient(parent, top, bottom, rotation)
	return create("UIGradient", {
		Color = ColorSequence.new(top, bottom),
		Rotation = rotation or 90,
	}, parent)
end

local function makeTween(object, properties, duration)
	local tween = TweenService:Create(
		object,
		TweenInfo.new(duration or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

-- Root + background map to ScreenGui.All and ScreenGui.All.Background.
local root = create("Frame", {
	Name = "All",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, widget)

local background = create("Frame", {
	Name = "Background",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = colors.outer,
	BorderSizePixel = 0,
	ZIndex = 1,
}, root)
addCorner(background, 13)
addStroke(background, 3)
addGradient(background, colors.panelTop, colors.outer, 90)

-- Header follows the user's Topground / Title / CloseButton naming.
local topground = create("Frame", {
	Name = "Topground",
	Position = UDim2.fromOffset(9, 8),
	Size = UDim2.new(1, -18, 0, 52),
	BackgroundColor3 = colors.orange,
	BorderSizePixel = 0,
	ZIndex = 2,
}, root)
addCorner(topground, 10)
addStroke(topground, 2.5)
addGradient(topground, colors.orangeLight, colors.orange, 90)

create("TextLabel", {
	Name = "Title",
	Position = UDim2.fromOffset(13, 3),
	Size = UDim2.new(1, -50, 1, -6),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBlack,
	Text = '<font color="#FFE16A">CATALOG</font> <font color="#7CFF4F">IMPORTER</font>',
	RichText = true,
	TextColor3 = colors.text,
	TextSize = 19,
	TextStrokeColor3 = colors.stroke,
	TextStrokeTransparency = 0.45,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
	ZIndex = 3,
}, topground)

local closeButton = create("TextButton", {
	Name = "CloseButton",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -7, 0.5, 0),
	Size = UDim2.fromOffset(28, 29),
	BackgroundColor3 = colors.red,
	BackgroundTransparency = 0,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBlack,
	Text = "X",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 14,
	TextStrokeColor3 = colors.stroke,
	TextStrokeTransparency = 0.15,
	ZIndex = 4,
}, topground)
addCorner(closeButton, 8)
addStroke(closeButton, 1.8)

-- Mode cards map to the user's Buttons / Assets / Bundles objects.
local buttonsFrame = create("Frame", {
	Name = "Buttons",
	Position = UDim2.fromOffset(9, 70),
	Size = UDim2.new(1, -18, 0, 64),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 2,
}, root)

create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, buttonsFrame)

local function createCategoryButton(name, labelText, descriptionText, iconId, order)
	local button = create("ImageButton", {
		Name = name,
		LayoutOrder = order,
		Size = UDim2.new(0.5, -4, 1, 0),
		BackgroundColor3 = colors.panel,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		ClipsDescendants = true,
		ZIndex = 3,
	}, buttonsFrame)
	addCorner(button, 9)
	local stroke = addStroke(button, 2.2)
	local gradient = addGradient(button, colors.panelTop, colors.panelBottom, 90)

	local icon = create("ImageLabel", {
		Name = "ImageLabel",
		Position = UDim2.fromOffset(8, 8),
		Size = UDim2.fromOffset(39, 39),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = iconId,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 4,
	}, button)
	local titleLabel = create("TextLabel", {
		Name = "Title",
		Position = UDim2.fromOffset(54, 9),
		Size = UDim2.new(1, -61, 0, 23),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBlack,
		Text = labelText,
		TextColor3 = colors.text,
		TextSize = 13,
		TextStrokeColor3 = colors.stroke,
		TextStrokeTransparency = 0.75,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	}, button)
	local detailLabel = create("TextLabel", {
		Name = "Subtitle",
		Position = UDim2.fromOffset(55, 31),
		Size = UDim2.new(1, -62, 0, 15),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		Text = descriptionText,
		TextColor3 = colors.muted,
		TextSize = 8,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	}, button)
	local selectedMark = create("Frame", {
		Name = "SelectedMark",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -6, 0, 6),
		Size = UDim2.fromOffset(8, 8),
		BackgroundColor3 = colors.green,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 5,
	}, button)
	addCorner(selectedMark, 8)
	addStroke(selectedMark, 1, 0)

	button.MouseEnter:Connect(function()
		if button.Active then
			makeTween(button, { BackgroundColor3 = colors.panelTop }, 0.1)
		end
	end)
	button.MouseLeave:Connect(function()
		if button.Active then
			makeTween(button, { BackgroundColor3 = colors.panel }, 0.1)
		end
	end)

	return {
		Button = button,
		Stroke = stroke,
		Gradient = gradient,
		Icon = icon,
		Title = titleLabel,
		Subtitle = detailLabel,
		SelectedMark = selectedMark,
	}
end

local assetCard = createCategoryButton("Assets", "ASSET", "SINGLE CATALOG ITEM", ASSET_ICON, 1)
local bundleCard = createCategoryButton("Bundles", "BUNDLE", "AVATAR / CHARACTER SET", BUNDLE_ICON, 2)

-- Main List panel maps to the user's List / InputBox / Import hierarchy.
local listFrame = create("Frame", {
	Name = "List",
	Position = UDim2.fromOffset(9, 142),
	Size = UDim2.new(1, -18, 1, -151),
	BackgroundColor3 = colors.panel,
	BorderSizePixel = 0,
	ZIndex = 2,
}, root)
addCorner(listFrame, 10)
addStroke(listFrame, 2.2)
addGradient(listFrame, colors.panelTop, colors.panelBottom, 90)

local input = create("TextBox", {
	Name = "InputBox",
	Position = UDim2.fromOffset(10, 10),
	Size = UDim2.new(1, -83, 0, 45),
	BackgroundColor3 = colors.field,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Font = Enum.Font.GothamMedium,
	PlaceholderText = "Paste /bundles/ID or a bundle ID...",
	PlaceholderColor3 = colors.muted,
	Text = DEFAULT_BUNDLE_ID,
	TextColor3 = colors.text,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
	ZIndex = 3,
}, listFrame)
addCorner(input, 8)
addStroke(input, 1.8)
addGradient(input, colors.field, colors.panelBottom, 90)
create("UIPadding", {
	PaddingLeft = UDim.new(0, 10),
	PaddingRight = UDim.new(0, 8),
}, input)

local importButton = create("ImageButton", {
	Name = "Import",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -9, 0, 9),
	Size = UDim2.fromOffset(59, 58),
	BackgroundColor3 = colors.green,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	ZIndex = 3,
}, listFrame)
addCorner(importButton, 9)
addStroke(importButton, 2.2)
addGradient(importButton, colors.green, colors.greenDark, 90)
create("ImageLabel", {
	Name = "ImageLabel",
	Position = UDim2.new(0.19, 0, 0.02, 0),
	Size = UDim2.new(0.62, 0, 0.61, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Image = IMPORT_ICON,
	ScaleType = Enum.ScaleType.Fit,
	ZIndex = 4,
}, importButton)
local importTitle = create("TextLabel", {
	Name = "Title",
	Position = UDim2.new(0, 0, 0.65, 0),
	Size = UDim2.new(1, 0, 0.32, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBlack,
	Text = "IMPORT",
	TextColor3 = colors.ink,
	TextSize = 9,
	TextStrokeColor3 = colors.text,
	TextStrokeTransparency = 0.9,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 4,
}, importButton)
importButton.MouseEnter:Connect(function()
	if importButton.Active then
		makeTween(importButton, { BackgroundColor3 = colors.green:Lerp(Color3.new(1, 1, 1), 0.12) }, 0.1)
	end
end)
importButton.MouseLeave:Connect(function()
	if importButton.Active then
		makeTween(importButton, { BackgroundColor3 = colors.green }, 0.1)
	end
end)

local statusDot = create("Frame", {
	Name = "StatusDot",
	Position = UDim2.fromOffset(13, 72),
	Size = UDim2.fromOffset(8, 8),
	BackgroundColor3 = colors.hint,
	BorderSizePixel = 0,
	ZIndex = 3,
}, listFrame)
addCorner(statusDot, 8)
addStroke(statusDot, 1, 0)

local statusText = create("TextLabel", {
	Name = "StatusText",
	Position = UDim2.fromOffset(28, 66),
	Size = UDim2.new(1, -39, 1, -72),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamMedium,
	Text = "Ready — choose Asset or Bundle and paste an ID or URL.",
	TextColor3 = colors.muted,
	TextSize = 10,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	ZIndex = 3,
}, listFrame)

local selectedCategory = "Bundle"
local busy = false
local statusTone = "idle"

local function applyStatusStyle()
	local statusColor = colors.muted
	local dotColor = colors.hint
	if statusTone == "success" then
		statusColor = colors.green
		dotColor = colors.green
	elseif statusTone == "error" then
		statusColor = colors.red
		dotColor = colors.red
	elseif statusTone == "asset" then
		statusColor = colors.asset
		dotColor = colors.asset
	elseif statusTone == "bundle" then
		statusColor = colors.bundle
		dotColor = colors.bundle
	elseif statusTone == "loading" then
		statusColor = colors.orangeLight
		dotColor = colors.orangeLight
	end
	statusText.TextColor3 = statusColor
	statusDot.BackgroundColor3 = dotColor
end

local function setStatus(message, tone)
	statusText.Text = tostring(message)
	statusTone = tone or "idle"
	applyStatusStyle()
end

local function updateCategoryStyle()
	local isAsset = selectedCategory == "Asset"
	assetCard.Stroke.Color = isAsset and colors.asset or colors.stroke
	assetCard.Stroke.Thickness = isAsset and 2.8 or 1.8
	assetCard.Gradient.Color = ColorSequence.new(
		isAsset and colors.assetDark or colors.panelTop,
		isAsset and colors.panel or colors.panelBottom
	)
	assetCard.SelectedMark.Visible = isAsset
	assetCard.Title.TextColor3 = isAsset and Color3.new(1, 1, 1) or colors.text
	assetCard.Subtitle.TextColor3 = isAsset and Color3.fromRGB(221, 245, 255) or colors.muted

	bundleCard.Stroke.Color = not isAsset and colors.bundle or colors.stroke
	bundleCard.Stroke.Thickness = not isAsset and 2.8 or 1.8
	bundleCard.Gradient.Color = ColorSequence.new(
		not isAsset and colors.bundleDark or colors.panelTop,
		not isAsset and colors.panel or colors.panelBottom
	)
	bundleCard.SelectedMark.Visible = not isAsset
	bundleCard.Title.TextColor3 = colors.text
	bundleCard.Subtitle.TextColor3 = not isAsset and Color3.fromRGB(240, 222, 255) or colors.muted

	input.PlaceholderText = isAsset
		and "Paste /catalog/ID or an asset ID..."
		or "Paste /bundles/ID or a bundle ID..."
	importTitle.Text = isAsset and "IMPORT" or "CREATE"
	applyStatusStyle()
end

local function setCategory(category)
	if busy then
		return
	end
	selectedCategory = category == "Asset" and "Asset" or "Bundle"
	if selectedCategory == "Asset" and input.Text == DEFAULT_BUNDLE_ID then
		input.Text = ""
	elseif selectedCategory == "Bundle" and input.Text == "" then
		input.Text = DEFAULT_BUNDLE_ID
	end
	updateCategoryStyle()
	if selectedCategory == "Asset" then
		setStatus("Asset mode — paste a model, accessory, or compatible asset ID.", "asset")
	else
		setStatus("Bundle mode — click Import to create a rig, or right-click to load source parts.", "bundle")
	end
end

local function setBusy(value)
	busy = value
	assetCard.Button.Active = not value
	bundleCard.Button.Active = not value
	input.Active = not value
	importButton.Active = not value
	closeButton.Active = not value
	importTitle.Text = value and "WAIT..." or (selectedCategory == "Asset" and "IMPORT" or "CREATE")
end

-- Import functions
local function parseBundleId(text)
	text = tostring(text or "")
	local id = string.match(text, "[Bb]undles/(%d+)")
	if not id then
		id = string.match(text, "^%s*(%d+)%s*$")
	end
	local number = tonumber(id)
	if number and number > 0 and number % 1 == 0 then
		return number
	end
	return nil
end

local function parseAssetId(text)
	text = tostring(text or "")
	local id = string.match(text, "[Cc]atalog/(%d+)")
		or string.match(text, "[Aa]ssets?/(%d+)")
		or string.match(text, "[Ll]ibrary/(%d+)")
	if not id then
		id = string.match(text, "^%s*(%d+)%s*$")
	end
	local number = tonumber(id)
	if number and number > 0 and number % 1 == 0 then
		return number
	end
	return nil
end

local function normalize(value)
	return string.lower(tostring(value or "")):gsub("[^%w]", "")
end

local BODY_PROPERTIES = {
	head = "Head",
	dynamichead = "Head",
	torso = "Torso",
	leftarm = "LeftArm",
	rightarm = "RightArm",
	leftleg = "LeftLeg",
	rightleg = "RightLeg",
}

local SINGLE_PROPERTIES = {
	face = "Face",
	shirt = "Shirt",
	classicshirt = "Shirt",
	pants = "Pants",
	classicpants = "Pants",
	tshirt = "GraphicTShirt",
	classictshirt = "GraphicTShirt",
}

local ACCESSORY_PROPERTIES = {
	hat = "HatAccessory",
	hataccessory = "HatAccessory",
	hairaccessory = "HairAccessory",
	faceaccessory = "FaceAccessory",
	neckaccessory = "NeckAccessory",
	shoulderaccessory = "ShouldersAccessory",
	shouldersaccessory = "ShouldersAccessory",
	frontaccessory = "FrontAccessory",
	backaccessory = "BackAccessory",
	waistaccessory = "WaistAccessory",
}

local function getAssetType(item)
	local assetType = normalize(item.AssetType)
	assetType = assetType:gsub("^enumavatarassettype", "")
	assetType = assetType:gsub("^avatarassettype", "")
	return assetType
end

local function inferBodyProperty(item)
	local assetType = getAssetType(item)
	local bodyProperty = BODY_PROPERTIES[assetType]
	if bodyProperty then
		return bodyProperty
	end
	local name = normalize(item.Name)
	for key, property in pairs(BODY_PROPERTIES) do
		if name == key or string.sub(name, -#key) == key then
			return property
		end
	end
	return nil
end

local function appendId(current, assetId)
	local id = tostring(assetId)
	current = tostring(current or "")
	if current == "" then
		return id
	end
	for existing in string.gmatch(current, "[^,]+") do
		if existing == id then
			return current
		end
	end
	return current .. "," .. id
end

local function getBundleDetails(bundleId)
	local bundle = AssetService:GetBundleDetailsAsync(bundleId)
	if type(bundle) ~= "table" then
		error("Roblox returned invalid details for this bundle.")
	end
	bundle.Items = bundle.Items or {}
	return bundle
end

local function getAssetDetails(assetId)
	local info = MarketplaceService:GetProductInfoAsync(assetId, Enum.InfoType.Asset)
	if type(info) ~= "table" then
		error("Roblox returned invalid details for this asset.")
	end
	return info
end

local function getImportCFrame()
	local camera = workspace.CurrentCamera
	if camera then
		local position = camera.CFrame.Position + camera.CFrame.LookVector * 12
		return CFrame.new(position)
	end
	return CFrame.new(0, 5, 0)
end

local function placeLoadedInstance(loaded, name)
	loaded.Name = tostring(name or loaded.Name or "ImportedAsset")
	if loaded:IsA("Model") then
		loaded:PivotTo(getImportCFrame())
	elseif loaded:IsA("BasePart") then
		loaded.CFrame = getImportCFrame()
	elseif loaded:IsA("Folder") then
		local model = Instance.new("Model")
		model.Name = loaded.Name
		for _, child in ipairs(loaded:GetChildren()) do
			child.Parent = model
		end
		loaded:Destroy()
		loaded = model
		loaded:PivotTo(getImportCFrame())
	end
	loaded.Parent = workspace
	Selection:Set({ loaded })
	return loaded
end

local function importAsset(assetId)
	local productInfo
	pcall(function()
		productInfo = MarketplaceService:GetProductInfoAsync(assetId, Enum.InfoType.Asset)
	end)
	local loaded = AssetService:LoadAssetAsync(assetId)
	if not loaded then
		error("Roblox did not return a model for asset " .. tostring(assetId) .. ".")
	end
	local name = productInfo and productInfo.Name or ("Asset_" .. tostring(assetId))
	local model = placeLoadedInstance(loaded, name)
	return model, name, productInfo
end

local function buildDescriptionFromBundle(bundle)
	local outfitId
	for _, item in ipairs(bundle.Items) do
		if normalize(item.Type) == "useroutfit" then
			outfitId = tonumber(item.Id)
			break
		end
	end
	if outfitId then
		local description = Players:GetHumanoidDescriptionFromOutfitIdAsync(outfitId)
		return description, "UserOutfit " .. tostring(outfitId)
	end

	local description = Instance.new("HumanoidDescription")
	local bodyCount = 0
	local mappedCount = 0
	local ignored = {}
	for _, item in ipairs(bundle.Items) do
		if normalize(item.Type) == "asset" and tonumber(item.Id) then
			local assetId = tonumber(item.Id)
			local bodyProperty = inferBodyProperty(item)
			local assetType = getAssetType(item)
			if bodyProperty then
				if description[bodyProperty] == 0 then
					description[bodyProperty] = assetId
					bodyCount += 1
					mappedCount += 1
				end
			else
				local singleProperty = SINGLE_PROPERTIES[assetType]
				local accessoryProperty = ACCESSORY_PROPERTIES[assetType]
				if singleProperty then
					description[singleProperty] = assetId
					mappedCount += 1
				elseif accessoryProperty then
					description[accessoryProperty] = appendId(description[accessoryProperty], assetId)
					mappedCount += 1
				else
					table.insert(ignored, tostring(item.Name or item.Id))
				end
			end
		end
	end

	if bodyCount == 0 then
		description:Destroy()
		local examples = table.concat(ignored, ", ")
		if examples == "" then
			examples = "no compatible body parts were found"
		end
		error("This bundle has no UserOutfit, and compatible body parts could not be identified. " .. examples)
	end
	return description, string.format("%d body part(s), %d item(s) mapped", bodyCount, mappedCount)
end

local function importAsRig(bundleId)
	local bundle = getBundleDetails(bundleId)
	local description, source = buildDescriptionFromBundle(bundle)
	local success, modelOrError = pcall(function()
		return Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType.R15)
	end)
	description:Destroy()
	if not success then
		error("Roblox could not generate the R15 rig: " .. tostring(modelOrError))
	end
	local model = modelOrError
	model.Name = tostring(bundle.Name or ("Bundle_" .. tostring(bundleId)))
	model:PivotTo(getImportCFrame())
	model.Parent = workspace
	Selection:Set({ model })
	return model, source, bundle
end

local function importPartsSeparately(bundleId)
	local bundle = getBundleDetails(bundleId)
	local assetItems = {}
	for _, item in ipairs(bundle.Items) do
		if normalize(item.Type) == "asset" and tonumber(item.Id) then
			table.insert(assetItems, item)
		end
	end
	if #assetItems == 0 then
		error("This bundle has no Asset items to import separately.")
	end

	local folder = Instance.new("Folder")
	folder.Name = tostring(bundle.Name or ("Bundle_" .. tostring(bundleId))) .. " - Source Assets"
	folder.Parent = workspace
	local baseCFrame = getImportCFrame()
	local successes = 0
	local failures = {}
	for index, item in ipairs(assetItems) do
		setStatus(string.format("Loading source asset %d of %d: %s", index, #assetItems, tostring(item.Name or item.Id)), "loading")
		local success, loadedOrError = pcall(function()
			return AssetService:LoadAssetAsync(tonumber(item.Id))
		end)
		if success and loadedOrError then
			local loaded = loadedOrError
			loaded.Name = tostring(item.Name or ("Asset_" .. tostring(item.Id)))
			loaded.Parent = folder
			if loaded:IsA("Model") then
				loaded:PivotTo(baseCFrame * CFrame.new((successes % 3) * 5, 0, math.floor(successes / 3) * 5))
			end
			successes += 1
		else
			table.insert(failures, tostring(item.Name or item.Id) .. ": " .. tostring(loadedOrError))
		end
	end
	if successes == 0 then
		folder:Destroy()
		error("No source assets could be loaded. Check Studio asset-loading permissions. " .. table.concat(failures, " | "))
	end
	Selection:Set({ folder })
	return folder, successes, #assetItems, failures, bundle
end

local function readInputId()
	if selectedCategory == "Asset" then
		local id = parseAssetId(input.Text)
		if not id then
			error("Enter an asset ID or a supported catalog URL.")
		end
		return id
	end
	local id = parseBundleId(input.Text)
	if not id then
		error("Enter a bundle ID or a URL containing /bundles/ID.")
	end
	return id
end

local function runImport(sourceAssets)
	if busy then
		return
	end
	local ok, idOrError = pcall(readInputId)
	if not ok then
		setStatus(idOrError, "error")
		return
	end
	local categoryAtStart = selectedCategory
	setBusy(true)
	setStatus(sourceAssets and "Loading bundle source assets..." or (categoryAtStart == "Asset" and "Loading catalog asset..." or "Building avatar rig..."), "loading")
	task.spawn(function()
		local success, resultA, resultB, resultC, resultD = pcall(function()
			if sourceAssets then
				return importPartsSeparately(idOrError)
			elseif categoryAtStart == "Asset" then
				return importAsset(idOrError)
			else
				return importAsRig(idOrError)
			end
		end)

		if success then
			if sourceAssets then
				local failures = resultD or {}
				local message = string.format("Imported %d of %d source asset(s). Parts are placed in Workspace but not assembled into a rig.", resultB or 0, resultC or 0)
				if #failures > 0 then
					message ..= string.format(" %d item(s) failed; see Output for details.", #failures)
					for _, failure in ipairs(failures) do
						warn("[Catalog Importer] " .. failure)
					end
				end
				setStatus(message, "success")
			elseif categoryAtStart == "Asset" then
				setStatus("Imported: " .. tostring(resultB or resultA.Name) .. " — selected in Workspace.", "success")
			else
				setStatus("Rig created: " .. tostring(resultA.Name) .. "\nSource: " .. tostring(resultB), "success")
			end
		else
			warn("[Catalog Importer] " .. tostring(resultA))
			setStatus(tostring(resultA), "error")
		end
		setBusy(false)
	end)
end

assetCard.Button.Activated:Connect(function()
	setCategory("Asset")
end)

bundleCard.Button.Activated:Connect(function()
	setCategory("Bundle")
end)

importButton.Activated:Connect(function()
	runImport(false)
end)

importButton.MouseButton2Click:Connect(function()
	if selectedCategory == "Bundle" then
		runImport(true)
	else
		if busy then
			return
		end
		local ok, idOrError = pcall(readInputId)
		if not ok then
			setStatus(idOrError, "error")
			return
		end
		setBusy(true)
		setStatus("Inspecting asset metadata...", "loading")
		task.spawn(function()
			local success, result = pcall(getAssetDetails, idOrError)
			if success then
				setStatus(string.format("%s\nAsset ID: %s  •  Creator: %s", tostring(result.Name or "Untitled"), tostring(result.AssetId or idOrError), tostring(result.Creator and result.Creator.Name or "Unknown")), "success")
			else
				warn("[Catalog Importer] " .. tostring(result))
				setStatus(tostring(result), "error")
			end
			setBusy(false)
		end)
	end
end)

closeButton.Activated:Connect(function()
	widget.Enabled = false
end)

local function updateToolbar()
	toggleButton:SetActive(widget.Enabled)
end

toggleButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
	updateToolbar()
end)

widget:GetPropertyChangedSignal("Enabled"):Connect(updateToolbar)

input.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		runImport(false)
	end
end)

setCategory("Bundle")
updateToolbar()

plugin.Unloading:Connect(function()
	if widget then
		widget:Destroy()
	end
end)
