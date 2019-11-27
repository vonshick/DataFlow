# DataFlow
Keras neural network deployed on AWS with Ansible and Docker.

To deploy script with ansible 
1. Pass the IP address in **host** file.
2. Change username in **main.yml**.
3. Run following command:

```
ansible-playbook -i hosts main.yml --ask-become-pass
```