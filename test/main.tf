module "waf_rulesets" {
  source = "../"

  zone_name = var.zone_name

  rulesets = [
    {
      name        = "OWASP ModSecurity Core Rule Set"
      mode        = "simulate"
      sensitivity = "off"
      rule_groups = [
        {
          name = "OWASP Bad Robots"
          mode = "on"
          rules = [
            {
              id   = "990012"
              mode = "off"
            },
          ]
        },
      ]
    },
  ]
}

data "testing_assertions" "waf_rulesets" {
  subject = "WAF Rulesets"

  equal "rulesets" {
    statement = "has the expected rulesets"

    got = module.waf_rulesets.rulesets
    want = tolist([
      {
        id   = "c504870194831cd12c3fc0284f294abb"
        mode = "simulate"
        name = "OWASP ModSecurity Core Rule Set"
        rule_groups = [
          {
            id   = "07d700cf30fda7548be94ff01087d0c4"
            mode = "on"
            name = "OWASP Bad Robots"
            rules = [
              {
                id   = "990012"
                mode = "off"
              },
            ]
          },
        ]
        sensitivity = "off"
      },
    ])
  }
}

output "waf_rulesets" {
  value = module.waf_rulesets
}
