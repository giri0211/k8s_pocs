docker pull hieven/terraform-visual-cli:0.1.0-0.12.29
docker run -it --rm hieven/terraform-visual-cli:0.1.0-0.12.29


# Terraform-visual Through CLI
npm install -g @terraform-visual/cli
# https://www.npmjs.com/package/@terraform-visual/cli

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

yarn global add @terraform-visual/cli
yarn add @terraform-visual/cli

# CLI installation in windows machine
npm install --global yarn
# on windows install yarn
choco install yarn
yarn global add @terraform-visual/cli
# gets the folder where yarn is installed
yarn global dir
# add the path to the system environment variables

terraform-visual --plan ./debugging/inframap/terraform-visual/plan-formatted.json