global_settings = {
  default_region = "region1"
  regions = {
    region1 = "westeurope"
  }
  random_length = 5
}

resource_groups = {
  test_caf = {
    name = "test-caf"
  }
}
azuread_groups = {
  caf_test_group = {
    display_name = "caf-test-user-group"
    description  = "CAF Example Test user group - created from tf"
  }
}
azuread_access_package_catalogs = {
  dev_catalog_7 = {
    display_name = "Dev-Catalog CAF TEST 7"
    description  = "DEV Env Catalog"
  }
}
azuread_access_packages = {
  dev_app_v7 = {
    display_name = "Dev-App-Packagev7 CAF TESTING"
    description  = "Access for Dev App"
    catalog = {
      key = "dev_catalog_7"
    }
    resource_origin = {
      key = "caf_test_group"
    }
    resource_origin_system = "AadGroup"
  }
}

azuread_access_package_assignment_policies = {
  policy7 = {
    name = "Policy7"
    access_package = {
      key = "dev_app_v7"
    }
    requestor_settings = {
      scope_type = "SpecificDirectorySubjects"
      allowed_requestors = {
        reshma_rajasumam = {
          object_id    = "603a172d-e44f-4d5c-85d2-b61f03f40490"
          subject_type = "singleUser"
        }
      }
    }
    approval_settings = {
      approval_required = true
      approval_stage = {
        approval_timeout_in_days = 14
        primary_approvers = {
          reshma_rajasumam = {
            object_id    = "603a172d-e44f-4d5c-85d2-b61f03f40490"
            subject_type = "singleUser"
          }
        }
      }
    }
    assignment_review_settings = {
      enabled                        = true
      review_frequency               = "weekly"
      duration_in_days               = 1
      review_type                    = "Reviewers"
      access_review_timeout_behavior = "keepAccess"
      reviewers = {
        reshma_rajasumam = {
          object_id    = "603a172d-e44f-4d5c-85d2-b61f03f40490"
          subject_type = "singleUser"
        }
      }
    }
    question = {
      question1 = {
        question_text = "What is the purpose of this request?"
        localized_question_text = {
          local_text1 = {
            language_code = "en"
            content       = "localized question test"
          }
          local_text2 = {
            language_code = "de"
            content       = "Test mit lokalisierten Fragen"
          }
        }
        answer_choices = {
          choice1 = {
            actual_value = "New Project - New Subscription"
            display_value = {
              default_text = "New Project"
              localized_text = {
                local_text1 = {
                  language_code = "en"
                  content       = "New Project"
                }
                local_text2 = {
                  language_code = "de"
                  content       = "Neues Projekt"
                }
              }
            }
          }
          choice2 = {
            actual_value = "Existing Project - Existing Subscription"
            display_value = {
              default_text = "Existing Project"
              localized_text = {
                local_text1 = {
                  language_code = "en"
                  content       = "Existing Project"
                }
                local_text2 = {
                  language_code = "de"
                  content       = "Bestehendes Projekt"
                }
              }
            }
          }
        }
      }
    }
  }
}