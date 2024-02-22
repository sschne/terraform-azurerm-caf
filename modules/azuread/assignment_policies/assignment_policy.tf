resource "azuread_access_package_assignment_policy" "policy" {
  access_package_id = can(var.settings.access_package.id) ? var.settings.access_package.id : var.access_packages[try(var.client_config.landingzone_key, var.settings.access_package.lz_key)][var.settings.access_package.key].id
  display_name      = var.settings.name
  description       = format("Access package assignment policy : [%s]", var.settings.name)
  duration_in_days  = try(var.settings.duration_in_days, null)
  expiration_date   = try(var.settings.expiration_date, null)
  extension_enabled = try(var.settings.extension_enabled, false)

  approval_settings {
    approval_required                = try(var.settings.approval_settings.approval_required, false)
    approval_required_for_extension  = try(var.settings.approval_settings.approval_required_for_extension, false)
    requestor_justification_required = try(var.settings.approval_settings.requestor_justification_required, false)

    dynamic "approval_stage" {
      for_each = toset(var.settings.approval_settings.approval_required != false ? [1] : [])
      content {
        approval_timeout_in_days            = try(var.settings.approval_settings.approval_stage.approval_timeout_in_days, 7)
        alternative_approval_enabled        = try(var.settings.approval_settings.approval_stage.alternative_approval_enabled, false)
        approver_justification_required     = try(var.settings.approval_settings.approval_stage.approver_justification_required, false)
        enable_alternative_approval_in_days = try(var.settings.approval_settings.approval_stage.enable_alternative_approval_in_days, 3)

        dynamic "alternative_approver" {
          for_each = try(var.settings.approval_settings.approval_stage.alternative_approvers, {})
          content {
            object_id    = alternative_approver.value.object_id
            subject_type = alternative_approver.value.subject_type
            backup       = try(alternative_approver.value.backup, false)
          }
        }

        dynamic "primary_approver" {
          for_each = try(var.settings.approval_settings.approval_stage.primary_approvers, {})
          content {
            object_id    = primary_approver.value.object_id
            subject_type = primary_approver.value.subject_type
            backup       = try(primary_approver.value.backup, false)
          }
        }
      }
    }
  }

  requestor_settings {
    requests_accepted = try(var.settings.requestor_settings.requests_accepted, true)
    scope_type        = try(var.settings.requestor_settings.scope_type)

    dynamic "requestor" {
      for_each = try(var.settings.requestor_settings.allowed_requestors, {})
      content {
        object_id    = try(requestor.value.object_id, null)
        subject_type = try(requestor.value.subject_type, null)
      }
    }
  }

  assignment_review_settings {
    access_recommendation_enabled   = try(var.settings.assignment_review_settings.access_recommendation_enabled, false)
    enabled                         = try(var.settings.assignment_review_settings.enabled, false)
    review_frequency                = try(var.settings.assignment_review_settings.review_frequency, null)
    duration_in_days                = try(var.settings.assignment_review_settings.duration_in_days, null)
    review_type                     = try(var.settings.assignment_review_settings.review_type, null)
    access_review_timeout_behavior  = try(var.settings.assignment_review_settings.access_review_timeout_behavior, "removeAccess")
    approver_justification_required = try(var.settings.assignment_review_settings.approver_justification_required, false)
    starting_on                     = try(var.settings.assignment_review_settings.starting_on, null)

    dynamic "reviewer" {
      for_each = try(var.settings.assignment_review_settings.reviewers, {})
      content {
        object_id    = reviewer.value.object_id
        subject_type = reviewer.value.subject_type
      }
    }
  }

  dynamic "question" {
    for_each = try(var.settings.question, {})

    content {
      required = try(question.value.required, false)
      sequence = try(question.value.sequence, null)
      text {
        default_text = question.value.question_text

        dynamic "localized_text" {
          for_each = try(question.value.localized_question_text, {})
          content {
            content       = localized_text.value.content
            language_code = localized_text.value.language_code
          }
        }
      }
      dynamic "choice" {
        for_each = try(question.value.answer_choices, {})
        content {
          actual_value = choice.value.actual_value
          display_value {
            default_text = choice.value.display_value.default_text

            dynamic "localized_text" {
              for_each = try(choice.value.display_value.localized_text, {})
              content {
                content       = localized_text.value.content
                language_code = localized_text.value.language_code
              }
            }
          }
        }
      }
    }
  }
}
