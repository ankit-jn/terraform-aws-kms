## KMS Key Policy
## Ref: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html
data aws_iam_policy_document "this" {

    # KMS Key Default Policy
    statement {
        sid       = "Enable IAM User Permissions" #Enable IAM policies
        actions   = ["kms:*"]
        resources = ["*"]

        principals {
            type        = "AWS"
            identifiers = ["arn:aws:iam::${var.account_id}:root"]
        }
    }

    # KMS Key Administration: 
    # Allow principals (IAM users and roles) to manage the KMS key
    # Principals: IAM users and roles in the account
    dynamic "statement" {
        for_each = length(var.key_administrators) > 0 ? [1] : []

        content {
            sid = "KeyAdministratorsAccess"
            actions = [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion",
            ]
            resources = ["*"]

            principals {
                type        = "AWS"
                identifiers = var.key_administrators
            }
        }
    }

    # KMS Key use with AWS Services:
    # Gives the Principals permission to allow AWS services that are integrated with AWS KMS to use the KMS key on their behalf
    # Principals: IAM users and roles in the account, and external AWS accounts
    dynamic "statement" {
        for_each = length(var.key_grants_users) > 0 ? [1] : []

        content {
            sid = "Allow attachment of persistent resources"
            actions = [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant",
            ]
            resources = ["*"]

            principals {
                type        = "AWS"
                identifiers = var.key_grants_users
            }

            condition {
                test     = "Bool"
                variable = "kms:GrantIsForAWSResource"
                values   = [true]
            }
        }
    }


    # Key type: Symmetric
    # Key usage: Encrypt and decrypt
    # Gives the Principals permission for symmetric encryption keys
    # Principals: IAM users and roles in the account, and external AWS accounts
    dynamic "statement" {
        for_each = ((key_spec == "SYMMETRIC_DEFAULT")
                        && (length(var.key_symmetric_encryption_users) > 0)) ? [1] : []

        content {
            sid = "KeySymmetricEncryption"
            actions = [
                "kms:Decrypt",
                "kms:DescribeKey",
                "kms:Encrypt",
                "kms:GenerateDataKey*",
                "kms:ReEncrypt*",
            ]                
            resources = ["*"]

            principals {
                type        = "AWS"
                identifiers = var.key_symmetric_encryption_users
            }
        }
    }
    
    # Key type: Symmetric
    # Key usage: Generate and verify MAC
    # Gives the Principals permission for HMAC keys
    # Principals: IAM users and roles in the account, and external AWS accounts
    dynamic "statement" {
        for_each = ((key_usage == "GENERATE_VERIFY_MAC")
                        && (length(var.key_symmetric_hmac_users) > 0)) ? [1] : []

        content {
            sid = "KeyHMAC"
            actions = [
                "kms:DescribeKey",
                "kms:GenerateMac",
                "kms:VerifyMac",
            ]
            resources = ["*"]

            principals {
                type        = "AWS"
                identifiers = var.key_symmetric_hmac_users
            }
        }
    }

    # Key type: Asymmetric
    # Key usage: Encrypt and decrypt [Public Key Encryption]
    # Gives the Principals permission for Encrypt and Decrypt
    # Principals: IAM users and roles in the account, and external AWS accounts
    dynamic "statement" {
        for_each = length(var.key_asymmetric_public_encryption_users) > 0 ? [1] : []

        content {
            sid = "KeyAsymmetricPublicEncryption"
            actions = [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:DescribeKey",
                "kms:GetPublicKey",
            ]
            resources = ["*"]

            principals {
                type        = "AWS"
                identifiers = var.key_asymmetric_public_encryption_users
            }
        }
    }

    # Key type: Asymmetric
    # Key usage: Sign and verify
    # Gives the Principals permission for Sign and verify
    # Principals: IAM users and roles in the account, and external AWS accounts
    dynamic "statement" {
        for_each = ((key_usage == "SIGN_VERIFY")
                        && (length(var.key_asymmetric_sign_verify_users) > 0 ))? [1] : []

        content {
            sid = "KeyAsymmetricSignVerify"
            actions = [
                "kms:DescribeKey",
                "kms:GetPublicKey",
                "kms:Sign",
                "kms:Verify",
            ]
            resources = ["*"]

            principals {
                type        = "AWS"
                identifiers = var.key_asymmetric_sign_verify_users
            }
        }
    }

}