variable "zone_name" {
  type        = string
  description = "The name of the DNS zone."
}

variable "rulesets" {
  type = list(object({
    name        = string
    sensitivity = string
    mode        = string
    rule_groups = list(object({
      name = string
      mode = string
      rules = list(object({
        id   = string
        mode = string
      }))
    }))
  }))
  description = "A list of `rulesets` objects."
}

locals {
  # The "cloudflare_waf_group" resource only deal with one group at a time,
  # so we need to flatten these.
  rule_groups = flatten([
    for rs in var.rulesets : [
      for g in rs.rule_groups : {
        package = rs.name
        name    = g.name
        mode    = g.mode
        rules   = g.rules
      }
    ]
  ])

  # The "cloudflare_waf_rule" resource only deal with one group at a time,
  # so we need to flatten these.
  rules = flatten([
    for g in local.rule_groups : [
      for r in g.rules : {
        package = g.package
        group   = g.name
        id      = r.id
        mode    = r.mode
      }
    ]
  ])
}
