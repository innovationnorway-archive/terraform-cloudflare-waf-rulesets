output "zone_name" {
  value       = var.zone_name
  description = "Echoes back the `zone_name` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "zone_id" {
  value       = data.cloudflare_zones.main.zones[0].id
  description = "The zone ID."
}

output "rulesets" {
  value = tolist([
    for rs in var.rulesets : {
      id          = data.cloudflare_waf_packages.main[rs.name].packages.0.id
      name        = rs.name
      sensitivity = rs.sensitivity
      mode        = rs.mode
      rule_groups : [
        for g in rs.rule_groups : {
          id   = data.cloudflare_waf_groups.main[g.name].groups.0.id
          name = g.name
          mode = g.mode
          rules = [
            for r in g.rules : {
              id   = r.id
              mode = r.mode
            }
          ]
        }
      ]
    }
  ])
  description = "A list of `rulesets` objects."
}
