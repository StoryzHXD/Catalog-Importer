local AssetService = game:GetService("AssetService")
local Players = game:GetService("Players")
local Selection = game:GetService("Selection")

local PLUGIN_ID = "CatalogImporter_Widget_v1"
local DEFAULT_BUNDLE_ID = "52488952982257"
local TOOLBAR_NAME = "Catalog Tools"

local toolbar = plugin:CreateToolbar(TOOLBAR_NAME)
local toggleButton = toolbar:CreateButton(
	"CatalogImporter_Toggle",
	"Open Catalog Importer",
	""
)
toggleButton.ClickableWhenViewportHidden = true

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	false,
	520,
	690,
	430,
	550
)

local widget = plugin:CreateDockWidgetPluginGuiAsync(PLUGIN_ID, widgetInfo)
widget.Title = "Catalog Importer | Toon Lab"

local function create(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties) do
		object[property] = value
	end
	object.Parent = parent
	return object
end

local colors = {
	background = Color3.fromRGB(247, 245, 255),
	panel = Color3.fromRGB(255, 255, 255),	
	panelTint = Color3.fromRGB(242, 238, 255),
	field = Color3.fromRGB(249, 248, 255),
	ink = Color3.fromRGB(47, 38, 79),
	text = Color3.fromRGB(52, 44, 83),
	muted = Color3.fromRGB(119, 112, 148),
	purple = Color3.fromRGB(126, 87, 255),
	purpleLight = Color3.fromRGB(166, 132, 255),
	blue = Color3.fromRGB(83, 139, 255),
	pink = Color3.fromRGB(255, 103, 143),
	yellow = Color3.fromRGB(255, 218, 91),
	mint = Color3.fromRGB(76, 215, 177),
	secondary = Color3.fromRGB(233, 227, 255),
	green = Color3.fromRGB(38, 157, 117),
	red = Color3.fromRGB(209, 58, 89),
	stroke = Color3.fromRGB(62, 48, 104),
}

local root = create("Frame", {
	Name = "Root",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = colors.background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, widget)
create("UIGradient", {
	Rotation = 90,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 248, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(237, 244, 255)),
	}),
}, root)

local scrollFrame = create("ScrollingFrame", {
	Name = "ContentScroller",
	Position = UDim2.fromOffset(0, 0),
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	CanvasSize = UDim2.fromOffset(0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	ScrollBarThickness = 5,
	ScrollBarImageColor3 = colors.purple,
	ScrollBarImageTransparency = 0.2,	
}, root)
create("UIPadding", {
	PaddingTop = UDim.new(0, 13),
	PaddingBottom = UDim.new(0, 14),
	PaddingLeft = UDim.new(0, 13),
	PaddingRight = UDim.new(0, 13),
}, scrollFrame)

local contentLayout = create("UIListLayout", {
	FillDirection = Enum.FillDirection.Vertical,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),	
}, scrollFrame)

local function addCorner(parent, radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius or 12),
	}, parent)
end

local function addStroke(parent, color, thickness, transparency)
	return create("UIStroke", {
		Color = color or colors.stroke,
		Thickness = thickness or 1.5,
		Transparency = transparency or 0.2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, parent)
end

local function addGradient(parent, first, second, rotation)
	return create("UIGradient", {
		Rotation = rotation or 0,
		Color = ColorSequence.new(first, second),
	}, parent)
end

local function makeCard(name, order, height, parent, tint)
	local card = create("Frame", {
		Name = name,
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = tint or colors.panel,
		BorderSizePixel = 0,
	}, parent)
	addCorner(card, 14)
	addStroke(card, colors.stroke, 1.4, 0.62)
	return card
end

-- Hero banner: bold colors, playful stamps and a thick illustrated outline.
local headerShadow = create("Frame", {
	Name = "HeaderShadow",
	LayoutOrder = 1,
	Position = UDim2.fromOffset(0, 4),
	Size = UDim2.new(1, 0, 0, 104),
	BackgroundColor3 = colors.ink,
	BorderSizePixel = 0,	
}, scrollFrame)
addCorner(headerShadow, 17)

local header = create("Frame", {
	Name = "HeroHeader",
	Size = UDim2.new(1, 0, 1, -4),
	Position = UDim2.fromOffset(0, 0),
	BackgroundColor3 = colors.purple,
	BorderSizePixel = 0,	
}, headerShadow)
addCorner(header, 17)
addStroke(header, colors.ink, 2.2, 0.05)
addGradient(header, Color3.fromRGB(147, 100, 255), Color3.fromRGB(79, 128, 255), 10)

local decoCircle = create("Frame", {
	Name = "DecorCircle",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, 18, 0.5, -4),
	Size = UDim2.fromOffset(132, 132),
	BackgroundColor3 = colors.pink,
	BackgroundTransparency = 0.14,
	BorderSizePixel = 0,
}, header)
addCorner(decoCircle, 100)
addStroke(decoCircle, Color3.fromRGB(255, 255, 255), 2, 0.45)

local decoCircleSmall = create("Frame", {
	Name = "DecorDot",
	Position = UDim2.new(1, -74, 0, 12),
	Size = UDim2.fromOffset(13, 13),
	BackgroundColor3 = colors.yellow,
	BorderSizePixel = 0,
}, header)
addCorner(decoCircleSmall, 50)

local logo = create("Frame", {
	Name = "LogoSticker",
	Position = UDim2.fromOffset(15, 22),
	Size = UDim2.fromOffset(56, 56),
	BackgroundColor3 = colors.yellow,
	BorderSizePixel = 0,
	Rotation = -5,
}, header)
addCorner(logo, 15)
addStroke(logo, colors.ink, 2.4, 0.02)
addGradient(logo, Color3.fromRGB(255, 235, 122), colors.yellow, 90)
create("TextLabel", {
	Name = "LogoText",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "CI",
	TextColor3 = colors.ink,
	TextSize = 21,
	TextStrokeColor3 = Color3.fromRGB(255, 245, 180),
	TextStrokeTransparency = 0.35,
	Rotation = 5,
}, logo)

create("TextLabel", {
	Name = "Eyebrow",
	Position = UDim2.fromOffset(84, 12),
	Size = UDim2.new(1, -170, 0, 16),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "TOON LAB  /  FERRAMENTAS DE CRIACAO",
	TextColor3 = Color3.fromRGB(235, 230, 255),
	TextSize = 9,
	TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local title = create("TextLabel", {
	Name = "Title",
	Position = UDim2.fromOffset(82, 29),
	Size = UDim2.new(1, -155, 0, 28),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "CATALOG IMPORTER",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 18,
	TextStrokeColor3 = colors.ink,
	TextStrokeTransparency = 0.76,
	TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local subtitle = create("TextLabel", {
	Name = "Subtitle",
	Position = UDim2.fromOffset(84, 58),
	Size = UDim2.new(1, -150, 0, 24),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = "Do catálogo para o Studio. Bora criar!",
	TextColor3 = Color3.fromRGB(247, 244, 255),
	TextSize = 10,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
}, header)

local inputCard = makeCard("BundleInputCard", 2, 100, scrollFrame, colors.panel)
create("TextLabel", {
	Name = "InputTitle",
	Position = UDim2.fromOffset(13, 10),
	Size = UDim2.new(1, -26, 0, 20),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "01   /   QUAL BUNDLE VAMOS BUSCAR?",
	TextColor3 = colors.text,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
}, inputCard)

local input = create("TextBox", {
	Name = "BundleInput",
	Position = UDim2.fromOffset(12, 39),
	Size = UDim2.new(1, -24, 0, 44),
	BackgroundColor3 = colors.field,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Font = Enum.Font.GothamMedium,
	PlaceholderText = "Cole a URL ou o ID do bundle...",
	Text = DEFAULT_BUNDLE_ID,
	TextColor3 = colors.text,
	PlaceholderColor3 = Color3.fromRGB(164, 157, 188),
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
}, inputCard)
addCorner(input, 11)
addStroke(input, Color3.fromRGB(170, 151, 227), 1.4, 0.25)
addGradient(input, Color3.fromRGB(255, 255, 255), Color3.fromRGB(246, 243, 255), 90)
create("UIPadding", {
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12),
}, input)

local buttonRow = create("Frame", {
	Name = "PrimaryActions",
	LayoutOrder = 3,
	Size = UDim2.new(1, 0, 0, 52),
	BackgroundTransparency = 1,
}, scrollFrame)
create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 9),
}, buttonRow)

local function createButton(name, text, color, parent, layoutOrder, secondColor)
	local button = create("TextButton", {
		Name = name,
		LayoutOrder = layoutOrder or 1,
		Size = UDim2.new(0.5, -5, 1, -4),
		Position = UDim2.fromOffset(0, 0),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBlack,
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 11,
		TextWrapped = true,
	}, parent)
	addCorner(button, 12)
	addStroke(button, colors.ink, 1.8, 0.12)
	addGradient(button, secondColor or color:Lerp(Color3.new(1, 1, 1), 0.12), color:Lerp(Color3.new(0, 0, 0), 0.05), 90)

	local baseColor = color
	button.MouseEnter:Connect(function()
		if button.Active then
			button.BackgroundColor3 = baseColor:Lerp(Color3.new(1, 1, 1), 0.12)
		end
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = baseColor
	end)

	return button
end

local inspectButton = createButton("InspectButton", "◉  Ver bundle", colors.pink, buttonRow, 1, Color3.fromRGB(255, 133, 159))
local importRigButton = createButton("ImportRigButton", "✦  Criar personagem", colors.purple, buttonRow, 2, Color3.fromRGB(160, 119, 255))

local rawButton = createButton(
	"ImportPartsButton",
	"▦  Importar peças de origem · AVANCADO",
	colors.ink,
	scrollFrame,
	4,
	Color3.fromRGB(84, 69, 123)
)
rawButton.Size = UDim2.new(1, 0, 0, 46)
rawButton.TextSize = 11

local detailsPanel = makeCard("DetailsPanel", 5, 177, scrollFrame, colors.panelTint)
addGradient(detailsPanel, Color3.fromRGB(255, 255, 255), Color3.fromRGB(243, 239, 255), 90)

create("TextLabel", {
	Name = "DetailsIcon",
	Position = UDim2.fromOffset(12, 10),
	Size = UDim2.fromOffset(26, 25),
	BackgroundColor3 = colors.yellow,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBlack,
	Text = "!",
	TextColor3 = colors.ink,
	TextSize = 15,
}, detailsPanel)
local detailsIcon = detailsPanel:FindFirstChild("DetailsIcon")
addCorner(detailsIcon, 8)
addStroke(detailsIcon, colors.ink, 1.2, 0.15)

create("TextLabel", {
	Name = "DetailsTitle",
	Position = UDim2.fromOffset(47, 11),
	Size = UDim2.new(1, -145, 0, 24),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "RESUMO DO BUNDLE",
	TextColor3 = colors.text,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
}, detailsPanel)

local detailsBadge = create("TextLabel", {
	Name = "DetailsBadge",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -11, 0, 11),
	Size = UDim2.fromOffset(87, 23),
	BackgroundColor3 = colors.mint,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBlack,
	Text = "AGUARDANDO...",
	TextColor3 = colors.ink,
	TextSize = 9,
}, detailsPanel)
addCorner(detailsBadge, 8)
addStroke(detailsBadge, colors.ink, 1.2, 0.18)
addGradient(detailsBadge, Color3.fromRGB(142, 241, 208), colors.mint, 90)

local detailsText = create("TextLabel", {
	Name = "DetailsText",
	Position = UDim2.fromOffset(14, 45),
	Size = UDim2.new(1, -28, 1, -55),
	BackgroundTransparency = 1,
	Font = Enum.Font.Code,
	Text = "Bundle: ainda não consultado\n\nOs dados do catálogo vão aparecer aqui depois da inspeção.",
	TextColor3 = colors.muted,
	TextSize = 11,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
}, detailsPanel)

local statusPanel = makeCard("StatusPanel", 6, 78, scrollFrame, Color3.fromRGB(255, 255, 255))
addStroke(statusPanel, colors.purple, 1.6, 0.48)

local statusPill = create("Frame", {
	Name = "StatusPill",
	Position = UDim2.fromOffset(12, 15),
	Size = UDim2.fromOffset(12, 12),
	BackgroundColor3 = colors.yellow,
	BorderSizePixel = 0,
}, statusPanel)
addCorner(statusPill, 50)
addStroke(statusPill, colors.ink, 1.1, 0.15)

create("TextLabel", {
	Name = "StatusCaption",
	Position = UDim2.fromOffset(32, 10),
	Size = UDim2.new(1, -44, 0, 15),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "CENTRAL DE COMANDO",
	TextColor3 = colors.text,
	TextSize = 9,
	TextXAlignment = Enum.TextXAlignment.Left,
}, statusPanel)

local statusText = create("TextLabel", {
	Name = "StatusText",
	Position = UDim2.fromOffset(32, 28),
	Size = UDim2.new(1, -44, 1, -35),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = "Pronto! Cole um ID ou URL de bundle para começar a aventura.",
	TextColor3 = colors.muted,
	TextSize = 11,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
}, statusPanel)

local footer = create("TextLabel", {
	Name = "Footer",
	LayoutOrder = 7,
	Size = UDim2.new(1, 0, 0, 23),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "FEITO PARA CRIADORES   ✦   VERIFIQUE AS PERMISSOES",
	TextColor3 = colors.muted,
	TextSize = 8,	
	TextXAlignment = Enum.TextXAlignment.Center,
}, scrollFrame)

local lastBundle = nil
local busy = false

local function setStatus(message, color)
	statusText.Text = tostring(message)
	statusText.TextColor3 = color or colors.muted
	statusPill.BackgroundColor3 = color or colors.yellow
	if color == colors.green then
		statusPill.BackgroundColor3 = colors.mint
	elseif color == colors.red then
		statusPill.BackgroundColor3 = colors.pink
	elseif not color then
		statusPill.BackgroundColor3 = colors.yellow
	end
end

local function setBusy(value)
	busy = value
	inspectButton.Active = not value
	importRigButton.Active = not value
	rawButton.Active = not value
	input.Active = not value
	inspectButton.AutoButtonColor = false
	importRigButton.AutoButtonColor = false
	rawButton.AutoButtonColor = false
	importRigButton.Text = value and "◌  CRIANDO..." or "✦  Criar personagem"
	inspectButton.Text = value and "◌  AGUARDE..." or "◉  Ver bundle"
	rawButton.Text = value and "PROCESSANDO ASSETS..." or "▦  Importar peças de origem · AVANCADO"
end

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

local function formatDetails(bundle)
	local lines = {
		"Bundle: " .. tostring(bundle.Name or "Sem nome"),
		"ID: " .. tostring(bundle.Id or "?"),
		"Tipo: " .. tostring(bundle.BundleType or "desconhecido"),
		"Itens: " .. tostring(#(bundle.Items or {})),
	}

	for index, item in ipairs(bundle.Items or {}) do
		if index > 5 then
			table.insert(lines, "... e mais " .. tostring(#bundle.Items - 5) .. " item(ns)")
			break
		end
		table.insert(lines, string.format(
			"%d. %s | %s | %s",
			index,
			tostring(item.Name or "Sem nome"),
			tostring(item.AssetType or item.Type or "Asset"),
			tostring(item.Id or "?")
		))
	end

	return table.concat(lines, "\n")
end

local function getBundleDetails(bundleId)
	local bundle = AssetService:GetBundleDetailsAsync(bundleId)
	if type(bundle) ~= "table" then
		error("A API do Roblox não retornou detalhes válidos para esse bundle.")
	end
	bundle.Items = bundle.Items or {}
	lastBundle = bundle
	detailsBadge.Text = string.format("%d ITENS", #bundle.Items)
	detailsBadge.BackgroundColor3 = colors.mint
	detailsText.Text = formatDetails(bundle)
	return bundle
end

local function getImportCFrame()
	local camera = workspace.CurrentCamera
	if camera then
		local position = camera.CFrame.Position + camera.CFrame.LookVector * 12
		return CFrame.new(position)
	end
	return CFrame.new(0, 5, 0)
end

local function buildDescriptionFromBundle(bundle)
	local outfitId = nil
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
					bodyCount = bodyCount + 1
					mappedCount = mappedCount + 1
				end
			else
				local singleProperty = SINGLE_PROPERTIES[assetType]
				local accessoryProperty = ACCESSORY_PROPERTIES[assetType]

				if singleProperty then
					description[singleProperty] = assetId
					mappedCount = mappedCount + 1
				elseif accessoryProperty then
					description[accessoryProperty] = appendId(description[accessoryProperty], assetId)
					mappedCount = mappedCount + 1
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
			examples = "nenhuma peça corporal compatível foi encontrada"
		end
		error("Este bundle não contém um UserOutfit e não foi possível identificar peças corporais compatíveis. " .. examples)
	end

	return description, string.format("%d peça(s) corporal(is), %d item(ns) mapeado(s)", bodyCount, mappedCount)
end

local function importAsRig(bundleId)
	local bundle = getBundleDetails(bundleId)
	local description, source = buildDescriptionFromBundle(bundle)
	local success, modelOrError = pcall(function()
		return Players:CreateHumanoidModelFromDescriptionAsync(
			description,
			Enum.HumanoidRigType.R15
		)
	end)
	description:Destroy()

	if not success then
		error("O Roblox não conseguiu gerar o rig R15: " .. tostring(modelOrError))
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
		error("Esse bundle não possui itens do tipo Asset para importar separadamente.")
	end

	local folder = Instance.new("Folder")
	folder.Name = tostring(bundle.Name or ("Bundle_" .. tostring(bundleId))) .. " - Source Assets"
	folder.Parent = workspace

	local baseCFrame = getImportCFrame()
	local successes = 0
	local failures = {}

	for index, item in ipairs(assetItems) do
		setStatus(string.format("Carregando asset %d de %d: %s", index, #assetItems, tostring(item.Name or item.Id)))
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
			successes = successes + 1
		else
			table.insert(failures, tostring(item.Name or item.Id) .. ": " .. tostring(loadedOrError))
		end
	end

	if successes == 0 then
		folder:Destroy()
		error("Nenhum asset pôde ser carregado. Verifique se 'Allow Loading Third Party Assets' está habilitado em Game Settings > Security. " .. table.concat(failures, " | "))
	end

	Selection:Set({ folder })
	return folder, successes, #assetItems, failures, bundle
end

local function getInputBundleId()
	local bundleId = parseBundleId(input.Text)
	if not bundleId then
		error("Insira um ID numérico ou uma URL contendo /bundles/ID.")
	end
	return bundleId
end

local function runAction(button, callback)
	if busy then
		return
	end

	local ok, bundleIdOrError = pcall(getInputBundleId)
	if not ok then
		setStatus(bundleIdOrError, colors.red)
		return
	end

	setBusy(true)
	setStatus("Consultando o catálogo do Roblox...")

	task.spawn(function()
		local success, resultA, resultB, resultC, resultD, resultE = pcall(callback, bundleIdOrError)
		if success then
			if button == inspectButton then
				setStatus("Bundle consultado com sucesso.", colors.green)
			elseif button == importRigButton then
				setStatus("Rig importado: " .. resultA.Name .. "\nOrigem: " .. tostring(resultB), colors.green)
			elseif button == rawButton then
				local message = string.format("Importados %d de %d asset(s) separados.\nEles não formam automaticamente um rig.", resultB, resultC)
				if resultD and #resultD > 0 then
					message = message .. "\nFalhas: " .. tostring(#resultD) .. " (consulte Output)."
					for _, failure in ipairs(resultD) do
						warn("[Catalog Importer] " .. failure)
					end
				end
				setStatus(message, colors.green)
			end
		else
			warn("[Catalog Importer] " .. tostring(resultA))
			setStatus(tostring(resultA), colors.red)
		end

		setBusy(false)
	end)
end

inspectButton.Activated:Connect(function()
	runAction(inspectButton, function(bundleId)
		return getBundleDetails(bundleId)
	end)
end)

importRigButton.Activated:Connect(function()
	runAction(importRigButton, importAsRig)
end)

rawButton.Activated:Connect(function()
	runAction(rawButton, importPartsSeparately)
end)

toggleButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

plugin.Unloading:Connect(function()
	if widget then
		widget:Destroy()
	end
end)