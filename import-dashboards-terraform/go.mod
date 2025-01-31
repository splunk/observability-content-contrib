module main

go 1.22

toolchain go1.22.8

require (
	github.com/hashicorp/go-version v1.7.0
	github.com/hashicorp/hcl/v2 v2.22.0
	github.com/hashicorp/terraform-exec v0.21.0
	github.com/signalfx/signalfx-go v1.42.0
	github.com/zclconf/go-cty v1.15.0
)

require (
	github.com/agext/levenshtein v1.2.1 // indirect
	github.com/apparentlymart/go-textseg/v15 v15.0.0 // indirect
	github.com/golang/protobuf v1.5.2 // indirect
	github.com/google/go-cmp v0.6.0 // indirect
	github.com/hashicorp/terraform-json v0.22.1 // indirect
	github.com/mitchellh/go-wordwrap v0.0.0-20150314170334-ad45545899c7 // indirect
	golang.org/x/mod v0.16.0 // indirect
	golang.org/x/net v0.23.0 // indirect
	golang.org/x/oauth2 v0.0.0-20220411215720-9780585627b5 // indirect
	golang.org/x/sys v0.18.0 // indirect
	golang.org/x/text v0.14.0 // indirect
	golang.org/x/tools v0.13.0 // indirect
	google.golang.org/appengine v1.6.7 // indirect
	google.golang.org/protobuf v1.33.0 // indirect
)

// https://github.com/hashicorp/terraform-exec/pull/446 can be removed after the PR is merged
replace github.com/hashicorp/terraform-exec v0.21.0 => github.com/hrmsk66/terraform-exec v0.21.0
