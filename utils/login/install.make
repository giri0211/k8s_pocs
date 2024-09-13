.PHONY: install

install:
	@echo "Installing kubectl-whoami..."
	curl -LO "https://github.com/rajatjindal/kubectl-whoami/releases/download/v0.1.0/kubectl-whoami_v0.1.0_$(uname -s)_$(uname -m).tar.gz"
	tar -zxvf kubectl-whoami_v0.1.0_$(uname -s)_$(uname -m).tar.gz
	chmod +x kubectl-whoami
	mv kubectl-whoami /usr/local/bin/
	rm kubectl-whoami_v0.1.0_$(uname -s)_$(uname -m).tar.gz
	@echo "kubectl-whoami installed successfully."


(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m)" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

