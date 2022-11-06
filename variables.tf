variable "account_id" {
    description = "Account ID where KMS key is being created"
    type        = string
}

variable "description" {
  description = "(Optional) The description of the key as viewed in AWS console."
  type        = string
  default     = null
}

variable "key_spec" {
    description = <<EOF
Specifies whether the key contains a symmetric key or an asymmetric key pair 
and the encryption algorithms or signing algorithms that the key supports.
EOF
    type        = string
    default     = "SYMMETRIC_DEFAULT"

    validation {
      condition = contains(["SYMMETRIC_DEFAULT", 
                            "HMAC_224", "HMAC_256", "HMAC_384", "HMAC_512",
                            "RSA_2048", "RSA_3072", "RSA_4096",
                            "ECC_NIST_P256", "ECC_NIST_P384", "ECC_NIST_P521", "ECC_SECG_P256K1"], 
                            var.key_usage)
      error_message = <<EOF
Valid values are as follows:
For Symmetric (Encrypt and decrypt): `SYMMETRIC_DEFAULT`
For Symmetric (Generate and Verify Mac): `HMAC_224`, `HMAC_256`, `HMAC_384`, `HMAC_512`
For Asymmetric (Encrypt and decrypt): `RSA_2048`, `RSA_3072`, `RSA_4096`
For Asymmetric (Sign and verify): `RSA_2048`, `RSA_3072`, `RSA_4096`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, `ECC_SECG_P256K1`.
EOF
    }
}

variable "key_usage" {
  description = "(Optional) Specifies the intended use of the key."
  type        = string
  default     = "ENCRYPT_DECRYPT"

  validation {
      condition = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.key_usage)
      errorerror_message = "Valid values for `jey_usage` are `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, `GENERATE_VERIFY_MAC`" 
  }
}

variable "custom_key_store_id" {
    description = "ID of the KMS Custom Key Store where the key will be stored instead of KMS (eg CloudHSM)."
    type        = string
    default     = null
}

variable "aliases" {
    description = "List of the aliases."
    type        = list(string)
    default     = []
}
variable "bypass_policy_lockout_safety_check" {
    description = "Flag to decide if the key policy lockout safety check should be bypassed."
    type        = bool
    default     = false
}

variable "deletion_window_in_days" {
    description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key."
    type        = number
    default     = 30
}

variable "enable_key_rotation" {
    description = "Flag to decide if KMS key rotation is enabled."
    type        = bool
    default     = false
}

variable "multi_region" {
    description = "Flag to decide if KMS key is multi-region or regional."
    type        = bool
    default     = false
}

variable "enabled" {
    description = "Flag to decide if KMS key is enabled."
    type        = bool
    default     = true
}

variable "key_administrators" {
    description = <<EOF
KMS Key Administration: 
List of ARNs for IAM principals that would be allowed to manage the KMS key
Principals: IAM users and roles in the account
EOF
    type        = list(string)
    default     = []
}

variable "key_grants_users" {
    description = <<EOF
KMS Key use with AWS Services:
List of ARNs for IAM principals that would be allowed to grant AWS services 
that are integrated with AWS KMS to use the KMS key on their behalf
Principals: IAM users and roles in the account, and external AWS accounts
EOF
    type        = list(string)
    default     = []
}

variable "key_symmetric_encryption_users" {
    description = <<EOF
Key type: Symmetric, Key usage: Encrypt and decrypt
List of ARNs for IAM principals that would be allowed to use the 
symmetric KMS key directly for all supported cryptographic operations
Principals: IAM users and roles in the account, and external AWS accounts
EOF
    type        = list(string)
    default     = []
}

variable "key_symmetric_hmac_users" {
    description = <<EOF
KMS Key Administration: 
List of ARNs for IAM principals that would be allowed to use the symmetric HMAC keys
Principals: IAM users and roles in the account, and external AWS accounts
EOF
    type        = list(string)
    default     = []
}

variable "key_asymmetric_public_encryption_users" {
    description = <<EOF
KMS Key Administration: 
List of ARNs for IAM principals that would be allowed to use the 
asymmetric KMS key for Encrypt and decrypt.
Principals: IAM users and roles in the account, and external AWS accounts
EOF
    type        = list(string)
    default     = []
}

variable "key_asymmetric_sign_verify_users" {
    description = <<EOF
KMS Key Administration: 
List of ARNs for IAM principals that would be allowed to use the 
asymmetric KMS key directly for Sign and Verify.
Principals: IAM users and roles in the account, and external AWS accounts
EOF
    type        = list(string)
    default     = []
}

variable "tags" {
  description = "(Optional) A map of tags to assign to all the resource."
  type        = map(any)
  default     = {}
}