# Rulesets in a YAML file

It may be convenient to represent rulesets in a YAML file rather than writing them as object values directly in the Terraform configuration, because YAML allows for a denser representation of rulesets that might be easier to quickly read.

Create a YAML file `rulesets.yml` and place it inside the calling module.

```yaml
rulesets:
- name: "CloudFlare"
  rule_groups:
  - name: "Cloudflare Drupal"
    mode: "off"
  - name: "Cloudflare Specials"
    mode: "on"

- name: "OWASP ModSecurity Core Rule Set"
  mode: "simulate"
  sensitivity: "off"
  rule_groups:
  - name: "OWASP Bad Robots"
    mode: "on"
    rules:
    - id: "990002"
      mode: "off"
```
