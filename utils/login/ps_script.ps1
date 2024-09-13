

# Set the environment variable globally
[Environment]::SetEnvironmentVariable("TF_VAR_akeyless_access_id", "p-jcl9kxi2j1tb", 1)
[Environment]::SetEnvironmentVariable("TF_VAR_akeyless_access_key", "UQwK6o1I09xdgWuoeDN+0Xp8LOZzJf1wMG+ID79oiow=", 1)


export TF_VAR_AKEYLESS_NONPROD_ACCESS_ID="p-jcl9kxi2j1tb"
export TF_VAR_AKEYLESS_NONPROD_ACCESS_KEY="UQwK6o1I09xdgWuoeDN+0Xp8LOZzJf1wMG+ID79oiow="
export AKEYLESS_NONPROD_ACCESS_ID="p-jcl9kxi2j1tb"
export AKEYLESS_NONPROD_ACCESS_KEY="UQwK6o1I09xdgWuoeDN+0Xp8LOZzJf1wMG+ID79oiow="

echo $TF_VAR_AKEYLESS_NONPROD_ACCESS_ID
echo $TF_VAR_AKEYLESS_NONPROD_ACCESS_KEY

terragrunt plan --terragrunt-config  ./aws/phr-platform-dev/us-east-1/tig-5485-test-c1.hcl -out plan-3.out

# WSL
terragrunt plan --terragrunt-config ./aws/phr-sandbox/us-east-1/tig-5485-test-c1.hcl -out plan-wsl.out 