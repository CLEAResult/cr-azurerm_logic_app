resource "azurerm_logic_app_workflow" "logicapp" {
  name                = format("%s%03d", local.name, count.index + 1)
  count               = var.num
  location            = var.location
  resource_group_name = var.rg_name

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  tags = merge({
    InfrastructureAsCode = "True"
  }, var.tags)
}

resource "azuread_group" "LogicAppContributor" {
  name = format("g%s%s%s_AZ_LogicAppContributor", local.default_rgid, local.env_id, local.rg_type)
}

resource "azurerm_role_assignment" "LogicAppContributor" {
  scope                = format("/subscriptions/%s/resourceGroups/%s", var.subscription_id, var.rg_name)
  role_definition_name = "Logic App Contributor"
  principal_id         = azuread_group.LogicAppContributor.id
}