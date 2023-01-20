resource "signalfx_dashboard_group" "kafka_dashboard_group" {
  name        = "${var.o11y_prefix} Kafka Lag Dashboard(s)"
  description = "Dashboard(s) for Kafka Lag"
}

resource "signalfx_list_chart" "kafka_partition_offset_chart" {
  name = "Topic Partition - Current Offset"
  description = "Latest offset of a topic from a broker's POV"

  program_text = <<-EOF
        A = data('kafka_topic_partition_current_offset').publish(label='Current Offset')
        EOF

  sort_by = "-value"


  legend_options_fields {
    property = "topic"
    enabled  = true
  }

  legend_options_fields {
    property = "partition"
    enabled  = true
  }

  legend_options_fields {
    property = "host"
    enabled  = true
  }

  legend_options_fields {
    property = "sf_metric"
    enabled  = false
  }

  legend_options_fields {
    property = "sf_originatingMetric"
    enabled  = false
  }  

  legend_options_fields {
    property = "metric_source"
    enabled  = false
  }   

  legend_options_fields {
    property = "container_image"
    enabled  = false
  }

  legend_options_fields {
    property = "container_name"
    enabled  = false
  } 

  legend_options_fields {
    property = "container_id"
    enabled  = false
  }  

}

resource "signalfx_list_chart" "kafka_consumer_group_offset_chart" {
  name = "Consumer Group Current Offset"
  description = "Latest offset of the consumer group"

  program_text = <<-EOF
        A = data('kafka_consumergroup_current_offset').publish(label='Current offset(consumer group)')
        EOF

  sort_by = "-value"     

  legend_options_fields {
    property = "topic"
    enabled  = true
  }

  legend_options_fields {
    property = "partition"
    enabled  = true
  }

  legend_options_fields {
    property = "host"
    enabled  = true
  }

  legend_options_fields {
    property = "consumergroup"
    enabled  = true
  } 

  legend_options_fields {
    property = "sf_metric"
    enabled  = false
  }

  legend_options_fields {
    property = "sf_originatingMetric"
    enabled  = false
  } 

  legend_options_fields {
    property = "metric_source"
    enabled  = false
  }   

  legend_options_fields {
    property = "container_image"
    enabled  = false
  }

  legend_options_fields {
    property = "container_name"
    enabled  = false
  } 

  legend_options_fields {
    property = "container_id"
    enabled  = false
  }    
}

resource "signalfx_list_chart" "kafka_consumer_lag_list" {
  name = "Consumer Group Current Offset"
  description = "How far is the consumer group behind the broker. If this is much greater than 0, it would indicate that consumption has either stopped or is not scaled enough"

  program_text = <<-EOF
        A = data('kafka_consumergroup_lag').publish(label='Consumer Group Lag')
        EOF

  sort_by = "-value"      

  legend_options_fields {
    property = "topic"
    enabled  = true
  }

  legend_options_fields {
    property = "partition"
    enabled  = true
  }

  legend_options_fields {
    property = "host"
    enabled  = true
  }

  legend_options_fields {
    property = "consumergroup"
    enabled  = true
  } 

  legend_options_fields {
    property = "sf_metric"
    enabled  = false
  }

  legend_options_fields {
    property = "sf_originatingMetric"
    enabled  = false
  } 

  legend_options_fields {
    property = "metric_source"
    enabled  = false
  }   

  legend_options_fields {
    property = "container_image"
    enabled  = false
  }

  legend_options_fields {
    property = "container_name"
    enabled  = false
  } 

  legend_options_fields {
    property = "container_id"
    enabled  = false
  }  
}

resource "signalfx_time_chart" "kafka_consumer_lag_line" {
  name = "Consumer Group Current Offset"
  description = "How far is the consumer group behind the broker. If this is much greater than 0, it would indicate that consumption has either stopped or is not scaled enough"

  program_text = <<-EOF
        A = data('kafka_consumergroup_lag').publish(label='Consumer Group Lag')
        EOF

  plot_type = "LineChart"      

  legend_options_fields {
    property = "topic"
    enabled  = true
  }

  legend_options_fields {
    property = "partition"
    enabled  = true
  }

  legend_options_fields {
    property = "host"
    enabled  = true
  }

  legend_options_fields {
    property = "consumergroup"
    enabled  = true
  }  

  legend_options_fields {
    property = "sf_metric"
    enabled  = false
  }

  legend_options_fields {
    property = "sf_originatingMetric"
    enabled  = false
  } 

  legend_options_fields {
    property = "metric_source"
    enabled  = false
  }   

  legend_options_fields {
    property = "container_image"
    enabled  = false
  }

  legend_options_fields {
    property = "container_name"
    enabled  = false
  } 

  legend_options_fields {
    property = "container_id"
    enabled  = false
  }  
}

resource "signalfx_dashboard" "kafka_dashboard" {
  name            = "Kafka Consumer Lag"
  dashboard_group = signalfx_dashboard_group.kafka_dashboard_group.id
  time_range      = "-1h"

  variable {
    property = "host"
    alias    = "broker"
  }

  variable {
    property = "topic"
    alias    = "topic"
  }

  variable {
    property = "partition"
    alias    = "partition"
  }


  chart {
    chart_id = signalfx_list_chart.kafka_partition_offset_chart.id
    width    = 4
    height   = 3
    row      = 0
    column   = 0
  }

  chart {
    chart_id = signalfx_list_chart.kafka_consumer_group_offset_chart.id
    width    = 4
    height   = 3
    row      = 0
    column   = 4
  }

  chart {
    chart_id = signalfx_list_chart.kafka_consumer_lag_list.id
    width    = 4
    height   = 3
    row      = 0
    column   = 8
  }  

  chart {
    chart_id = signalfx_time_chart.kafka_consumer_lag_line.id
    width    = 12
    height   = 2
    row      = 3
    column   = 0
  }  
}