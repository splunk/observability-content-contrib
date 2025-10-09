resource "signalfx_detector" "token-expiration" {
  authorized_writer_teams = null
  authorized_writer_users = null
  description             = null
  disable_sampling        = false
  end_time                = null
  max_delay               = 0
  min_delay               = 0
  name                    = "Tokens Expiring 7 & 30 day Detector (jrh)"
  program_text            = "A = data('tokens.expiring.7days').sum(by=['token_names']).publish(label='A')\nAB = alerts(detector_name='Tokens Expiring 7 & 30 day Detector').publish(label='AB')\nB = data('tokens.expiring.30days').sum(by=['token_names']).publish(label='B')\ndetect((when(A > threshold(0))) or (when(B > threshold(0))), auto_resolve_after='6h').publish('Tokens Expiring 7 & 30 day Detector')"
  show_data_markers       = true
  show_event_lines        = false
  start_time              = null
  tags                    = []
  teams                   = []
  time_range              = 43200
  timezone                = null
  rule {
    description           = "The value of tokens.expiring.7days - Sum by token_names is above 0 OR The value of tokens.expiring.30days - Sum by token_names is above 0."
    detect_label          = "Tokens Expiring 7 & 30 day Detector"
    disabled              = false
    notifications         = []
    parameterized_body    = "{{#if anomalous}}\n\tRule \"{{{ruleName}}}\" in detector \"{{{detectorName}}}\" triggered at {{dateTimeFormat timestamp format=\"full\"}}.\n{{else}}\n\tRule \"{{{ruleName}}}\" in detector \"{{{detectorName}}}\" cleared at {{dateTimeFormat timestamp format=\"full\"}}.\n{{/if}}\n\n{{#if anomalous}}Signal value for tokens.expiring.7days - Sum by token_names: {{inputs.A.value}}\ntoken_names: {{dimensions.token_names}}\n{{else}}\nCurrent signal value for tokens.expiring.7days - Sum by token_names: {{inputs.A.value}}\n{{/if}}\n\n\n{{#if anomalous}}Signal value for tokens.expiring.30days - Sum by token_names: {{inputs.B.value}}\ntoken_names: {{dimensions.token_names}}\n{{else}}\nCurrent signal value for tokens.expiring.30days - Sum by token_names: {{inputs.B.value}}\n{{/if}}\n\n{{#notEmpty dimensions}}\nSignal details:\n{{{dimensions}}}\n{{/notEmpty}}\n\n{{#if anomalous}}\n{{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}\n{{#if tip}}Tip: {{{tip}}}{{/if}}\n{{/if}}\n\n{{#if detectorTags}}Tags: {{detectorTags}}{{/if}}\n\n{{#if detectorTeams}}\nTeams:{{#each detectorTeams}} {{name}}{{#unless @last}},{{/unless}}{{/each}}.\n{{/if}}"
    parameterized_subject = "({{{detectorName}}}) Alert"
    runbook_url           = null
    severity              = "Critical"
    tip                   = null
  }
  viz_options {
    color        = "brown"
    display_name = "tokens.expiring.7days - Sum by token_names"
    label        = "A"
    value_prefix = null
    value_suffix = null
    value_unit   = null
  }
  viz_options {
    color        = "yellow"
    display_name = "tokens.expiring.30days - Sum by token_names"
    label        = "B"
    value_prefix = null
    value_suffix = null
    value_unit   = null
  }
}
