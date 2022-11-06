resource aws_kms_key "this" {
    description   = var.description

    customer_master_key_spec = var.key_spec
    key_usage     = var.key_usage

    custom_key_store_id = var.custom_key_store_id
  
    bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check

    deletion_window_in_days = 10

    enable_key_rotation = var.enable_key_rotation
    multi_region        = var.multi_region
    is_enabled          = var.enabled

    policy = data.aws_iam_policy_document.this.json
    
    tags = var.tags
}

resource aws_kms_alias "this" {
    for_each = { for alias in var.aliases:alias => alias }

    name          = format("alias/%s", each.value)
    target_key_id = aws_kms_key.this.key_id
}