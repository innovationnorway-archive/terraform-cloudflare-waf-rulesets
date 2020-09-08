![test](https://github.com/innovationnorway/terraform-cloudflare-waf-rulesets/workflows/test/badge.svg)

# Cloudflare WAF Rulesets Module

This [Terraform](https://www.terraform.io/docs/) module manages [Cloudflare WAF rulesets](https://support.cloudflare.com/hc/en-us/articles/200172016-Understanding-the-Cloudflare-Web-Application-Firewall-WAF-).

## Example Usage

```hcl
module "waf_rulesets" {
  source = "innovationnorway/waf-rulesets/cloudflare"

  zone_name = "example.com"

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
              id   = "990012" # Rogue web site crawler
              mode = "off"
            },
          ]
        },
      ]
    },
  ]
}
```

## Arguments

* `zone_name` - The name of the DNS zone.

* `rulesets` -  A list of `rulesets` objects.

The `rulesets` object supports the following:

* `name` - The name of the firewall package.

* `sensitivity` - The sensitivity of the firewall package.

* `mode` - The default action that will be taken for rules under the firewall package. Possible values are: `simulate`, `block`, `challenge`. 

> **Note:** Only `anomaly` WAF packages can have their package attributes updated. Use empty string for `traditional` and `user` WAF packages.

* `rule_groups` - A list of `rule_groups` objects.

The `rule_groups` object supports the following:

* `name` - The name of the firewall rule group.

* `mode` - Whether or not the rules contained within this group are configurable/usable. Possible values are: `on`, `off`.

* `rules` - A list of `rules` objects.

The `rules` object supports the following:

* `id` - The ID of the WAF rule.

* `mode` - The mode to use when the rule is triggered. Value is restricted based on the `allowed_modes` of the rule. Possible values are: `default`, `disable`, `simulate`, `block`, `challenge`, `on`, `off`.
