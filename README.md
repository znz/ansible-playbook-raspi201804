# Ansible Playbook for Raspbian GNU/Linux 9.4 (stretch)

## Usage

- `ansible-galaxy install --role-file provision/requirements.yml --roles-path provision/roles`
- `ansible-playbook -i provision/inventory/production provision/playbook.yml -b -K`
