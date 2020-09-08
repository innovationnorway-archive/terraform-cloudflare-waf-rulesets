data "cloudflare_zones" "main" {
  # We use this to get the zone identifier, since
  # we only know it's name.
  filter {
    name = var.zone_name
  }
}

data "cloudflare_waf_packages" "main" {
  for_each = toset(var.rulesets.*.name)
  zone_id  = data.cloudflare_zones.main.zones.0.id
  filter {
    name = each.key
  }
}

data "cloudflare_waf_groups" "main" {
  for_each   = { for g in local.rule_groups : g.name => g }
  zone_id    = data.cloudflare_zones.main.zones.0.id
  package_id = data.cloudflare_waf_packages.main[each.value.package].packages.0.id
  filter {
    name = each.key
  }
}

resource "cloudflare_waf_package" "main" {
  for_each    = { for rs in var.rulesets : rs.name => rs if rs.mode != "" }
  package_id  = data.cloudflare_waf_packages.main[each.key].packages.0.id
  zone_id     = data.cloudflare_zones.main.zones.0.id
  sensitivity = each.value.sensitivity
  action_mode = each.value.mode
}

resource "cloudflare_waf_group" "main" {
  for_each = { for g in local.rule_groups : g.name => g }
  group_id = data.cloudflare_waf_groups.main[each.key].groups.0.id
  zone_id  = data.cloudflare_zones.main.zones.0.id
  mode     = each.value.mode
}

resource "cloudflare_waf_rule" "main" {
  for_each = { for r in local.rules : r.id => r }
  rule_id  = each.key
  zone_id  = data.cloudflare_zones.main.zones.0.id
  mode     = each.value.mode
}
