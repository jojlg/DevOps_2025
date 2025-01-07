# Crée l'utilisateur ansible et définir un mot de passe provisoire
adduser --gecos "" ansible
echo "ansible:password" | chpasswd

# Force l'utilisateur à changer son mot de passe à la prochaine connexion
chage -d 0 ansible

# Ajoute l'utilisateur ansible au groupe sudo
usermod -aG sudo ansible
chown -R ansible:ansible /home/ansible/

# Configure sudoers pour l'utilisateur ansible
echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Passe à l'utilisateur ansible pour effectuer l'installation et les autres actions
sudo -u ansible bash << EOF
# Mets à jour la liste des paquets
sudo apt-get update -y

# Installe Ansible et tree (facultatif)
sudo apt-get install ansible -y
sudo apt install tree -y

# Vérifie la version d'Ansible installée
ansible --version

# Crée le répertoire .ssh et générer la clé SSH
mkdir -p /home/ansible/.ssh
cd /home/ansible/.ssh

# Génére une clé SSH ed25519 (le nom sera 'id_srv-ansible')
ssh-keygen -t ed25519 -f id_srv-ansible -N ""

# Ajoute la clé publique au fichier authorized_keys
cat id_srv-ansible.pub >> authorized_keys

EOF

echo "Configuration terminée. L'utilisateur 'ansible' est prêt à être utilisé, son mot de passe sera à modifier à la prochaine connexion"
