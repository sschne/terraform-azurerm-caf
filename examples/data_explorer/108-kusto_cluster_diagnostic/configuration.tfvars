global_settings = {
  default_region = "region1"
  regions = {
    region1 = "eastus"
  }
}
resource_groups = {
  rg1 = {
    name   = "dedicated-test"
    region = "region1"
  }
}

diagnostic_log_analytics = {
    analytics = {
      region             = "region1"
      name               = "logs"
      resource_group_key = "common"
    }
  }

diagnostics_destinations = {
    log_analytics = {
      analytics = {
        log_analytics_key              = "analytics"
        log_analytics_destination_type = "Dedicated"
      }
    }
  }

diagnostics_definition = {
  kusto_clusters = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, false, 14],
        ["AzurePolicyEvaluationDetails", true, false, 14],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}

kusto_clusters = {
  kc1 = {
    name = "kustocluster"
    resource_group = {
      key = "rg1"
      #lz_key = ""
      #name   = ""
    }
    region = "region1"

    sku = {
      name     = "Dev(No SLA)_Standard_E2a_v4"
      capacity = 1
    }

    diagnostic_profiles = {
      diagnostic_logs = {
        definition_key   = "kusto_clusters"
        destination_type = "log_analytics"
        destination_key  = "analytics"
      }
    }
  }
}

