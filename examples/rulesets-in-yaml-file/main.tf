locals {
  rulesets_file = yamldecode(file("rulesets.yml"))
  rulesets = [
    for rs in local.rulesets_file.rulesets : {
      name        = rs.name
      sensitivity = lookup(rs, "sensitivity", "")
      mode        = lookup(rs, "mode", "")
      rule_groups = lookup(rs, "rule_groups", [])
    }
  ]
  rulesets_groups = [
    for rs in local.rulesets : {
      name        = rs.name
      sensitivity = rs.sensitivity
      mode        = rs.mode
      rule_groups = [
        for g in rs.rule_groups : {
          name  = g.name
          mode  = g.mode
          rules = lookup(g, "rules", [])
        }
      ]
    }
  ]
}

module "waf_rulesets" {
  for_each = toset(local.rulesets_file.zones)
  source   = "../.."

  zone_name = each.key
  rulesets  = local.rulesets_groups
}

output "waf_rulesets" {
  value = module.waf_rulesets
}
