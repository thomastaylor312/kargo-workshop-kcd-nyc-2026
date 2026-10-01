# CHANGE `participant` to something unique to your fork (e.g. your GitHub handle).
participant = "thomastaylor312"
env_name    = "prod"
# image_tag is updated by the Kargo promotion (hcl-update).
image_tag = "latest"

# Lambda function name prefix (must match what the workshop AWS creds are scoped
# to). The shared execution role ARN is defaulted in variables.tf.
function_prefix = "kargo-guestbook"
