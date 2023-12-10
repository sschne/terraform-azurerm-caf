global_settings = {
  default_region = "region1"
  regions = {
    region1 = "australiaeast"
  }
}

resource_groups = {
  test = {
    name = "rg1"
  }
}

keyvaults = {
  kv_user = {
    name                = "localuser"
    resource_group_key  = "test"
    sku_name            = "standard"
    soft_delete_enabled = true
    creation_policies = {
      logged_in_user = {
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge"]
      }
    }
  }
}

# https://docs.microsoft.com/en-us/azure/storage/
storage_accounts = {
  sa1 = {
    name                     = "sa1"
    resource_group_key       = "test"
    account_kind             = "BlobStorage" #Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2
    account_tier             = "Standard"    #Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid
    account_replication_type = "LRS"         # https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy     # Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_0 for new storage accounts.
    containers = {
      scripts = {
        name = "scripts"
      }
      test = {
        name = "testsas"
        sas_token = {
          sas_token1 = {
            name = "readtoken"
            sas_policy = {
              expire_in_days = 10
              rotation = {
                days = 10
              }
            }
            permissions = {
              read = true
              list = true
            }
            keyvault = {
              key = "kv_user"
            }
          }
        }
      }
    }
  }
}
